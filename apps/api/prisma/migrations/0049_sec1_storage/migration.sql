-- SEC-1: security of the storage.
-- Runs as fp_migrate, owner of the schema. The roles are created beforehand by the
-- superuser (db:setup locally, the DBA elsewhere): this migration only grants.

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'fp_app')
     OR NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'fp_worker')
     OR NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'fp_report') THEN
    RAISE EXCEPTION 'roles fp_app, fp_worker and fp_report must exist (db:setup)';
  END IF;
END $$;

-- ---------------------------------------------------------------- roles
-- No DDL for anyone but the owner.
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
-- fp_app is a member of flexipay_app (grants and policies); the guard of the opening balances
-- refuses every member of it, not only the former login name.
CREATE OR REPLACE FUNCTION ledger_opening_guard() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  -- Direct membership (pg_has_role would also be true for a superuser).
  IF current_user = 'flexipay_app'
     OR EXISTS (SELECT 1 FROM pg_auth_members m
                 WHERE m.roleid = 'flexipay_app'::regrole AND m.member = current_user::regrole)
     OR coalesce(current_setting('app.seed', true), '') <> 'on'
     OR coalesce(current_setting('app.environment', true), '') <> 'development' THEN
    RAISE EXCEPTION 'OPENING_BALANCE entries are reserved to the development seed'
      USING ERRCODE = '42501';
  END IF;
  RETURN NEW;
END $$;

-- fp_worker: the outbox only (the platform policy of the table applies).
GRANT USAGE ON SCHEMA public TO fp_worker;
GRANT SELECT, UPDATE ON "outbox_events" TO fp_worker;

-- fp_report: reading only (BYPASSRLS given by db:setup), never the sessions nor the keys.
GRANT USAGE ON SCHEMA public TO fp_report;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO fp_report;
REVOKE SELECT ON "sessions", "mfa_challenges" FROM fp_report;

-- ---------------------------------------------------------------- data keys (envelope)
-- Data keys of the personal data, each wrapped (AES-256-GCM) by the master key of the
-- environment (DATA_MASTER_KEY, a key vault later). The API reads them, never writes them.
CREATE TABLE "data_keys" (
  "id" SMALLINT PRIMARY KEY CHECK ("id" > 0),
  "wrapped_key" TEXT NOT NULL,
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "retired_at" TIMESTAMPTZ(3)
);
GRANT SELECT ON "data_keys" TO flexipay_app;
REVOKE ALL ON "data_keys" FROM fp_report;

-- ---------------------------------------------------------------- identifiers
-- CIN number, tax id (matricule fiscal) and RIB sealed (AES-256-GCM, data key), with a blind
-- index (HMAC-SHA256, BLIND_INDEX_KEY) for the search and the uniqueness.
ALTER TABLE "companies"
  ADD COLUMN "national_id" TEXT,
  ADD COLUMN "national_id_index" CHAR(64),
  ADD COLUMN "tax_id" TEXT,
  ADD COLUMN "tax_id_index" CHAR(64);
ALTER TABLE "merchants"
  ADD COLUMN "national_id" TEXT,
  ADD COLUMN "national_id_index" CHAR(64),
  ADD COLUMN "tax_id" TEXT,
  ADD COLUMN "tax_id_index" CHAR(64),
  ADD COLUMN "iban_index" CHAR(64);
CREATE UNIQUE INDEX "companies_national_id_index_key" ON "companies" ("national_id_index")
  WHERE "national_id_index" IS NOT NULL;
CREATE UNIQUE INDEX "companies_tax_id_index_key" ON "companies" ("tax_id_index")
  WHERE "tax_id_index" IS NOT NULL;
CREATE UNIQUE INDEX "merchants_national_id_index_key" ON "merchants" ("national_id_index")
  WHERE "national_id_index" IS NOT NULL;
CREATE UNIQUE INDEX "merchants_tax_id_index_key" ON "merchants" ("tax_id_index")
  WHERE "tax_id_index" IS NOT NULL;
CREATE INDEX "merchants_iban_index_idx" ON "merchants" ("iban_index");

-- ---------------------------------------------------------------- hash chains
-- The ledger and the audit log stay append only (REVOKE UPDATE, DELETE since 0002, triggers);
-- each new line is also chained: hash of the previous one + its own content, kept in a separate
-- append-only table (the ledger lines themselves are never rewritten). The nightly
-- reconciliation recomputes the chains: a line changed by hand breaks its link.

CREATE FUNCTION ledger_entry_digest(e "ledger_entries", prev TEXT) RETURNS TEXT
LANGUAGE sql STABLE AS $$
  SELECT encode(sha256(convert_to(concat_ws('|',
    prev, e.id::text, e.transaction_id::text, e.account_id::text, e.direction::text,
    e.amount_millimes::text, e.balance_after_millimes::text, coalesce(e.lot_id::text, ''),
    to_char(e.created_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS')), 'UTF8')), 'hex')
$$;

CREATE FUNCTION audit_entry_digest(a "audit_log", prev TEXT) RETURNS TEXT
LANGUAGE sql STABLE AS $$
  SELECT encode(sha256(convert_to(concat_ws('|',
    prev, a.id::text, to_char(a.occurred_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS'),
    coalesce(a.actor_user_id::text, ''), a.actor_name, a.action, a.target,
    coalesce(a.subject_id::text, ''), coalesce(a.reason, '')), 'UTF8')), 'hex')
$$;

-- Ledger: one chain per account (its lines are written under the lock of the account).
CREATE TABLE "ledger_entry_chain" (
  "entry_id" BIGINT PRIMARY KEY REFERENCES "ledger_entries" ("id"),
  "account_id" UUID NOT NULL,
  "prev_hash" TEXT NOT NULL,
  "row_hash" TEXT NOT NULL,
  -- A fork (two lines on the same previous one) is refused, never silent.
  UNIQUE ("account_id", "prev_hash")
);

-- Audit: one chain, written under a transaction lock.
CREATE TABLE "audit_log_chain" (
  "seq" BIGSERIAL PRIMARY KEY,
  "audit_id" UUID NOT NULL UNIQUE REFERENCES "audit_log" ("id"),
  "prev_hash" TEXT NOT NULL UNIQUE,
  "row_hash" TEXT NOT NULL
);

REVOKE ALL ON "ledger_entry_chain", "audit_log_chain" FROM PUBLIC, flexipay_app;
REVOKE ALL ON SEQUENCE "audit_log_chain_seq_seq" FROM PUBLIC, flexipay_app;

CREATE FUNCTION chain_append_only() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'hash chains are append only' USING ERRCODE = '42501';
END $$;
CREATE TRIGGER ledger_entry_chain_append_only BEFORE UPDATE OR DELETE ON "ledger_entry_chain"
  FOR EACH ROW EXECUTE FUNCTION chain_append_only();
CREATE TRIGGER audit_log_chain_append_only BEFORE UPDATE OR DELETE ON "audit_log_chain"
  FOR EACH ROW EXECUTE FUNCTION chain_append_only();

CREATE FUNCTION ledger_chain_append() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp AS $$
DECLARE
  prev TEXT;
BEGIN
  SELECT c.row_hash INTO prev FROM ledger_entry_chain c
   WHERE c.account_id = NEW.account_id ORDER BY c.entry_id DESC LIMIT 1;
  prev := coalesce(prev, '');
  INSERT INTO ledger_entry_chain (entry_id, account_id, prev_hash, row_hash)
  VALUES (NEW.id, NEW.account_id, prev, ledger_entry_digest(NEW, prev));
  RETURN NULL;
END $$;

CREATE FUNCTION audit_chain_append() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp AS $$
DECLARE
  prev TEXT;
BEGIN
  PERFORM pg_advisory_xact_lock(7426001);
  SELECT c.row_hash INTO prev FROM audit_log_chain c ORDER BY c.seq DESC LIMIT 1;
  prev := coalesce(prev, '');
  INSERT INTO audit_log_chain (audit_id, prev_hash, row_hash)
  VALUES (NEW.id, prev, audit_entry_digest(NEW, prev));
  RETURN NULL;
END $$;

-- Existing lines, in their order.
DO $$
DECLARE
  e ledger_entries;
  a audit_log;
  prev TEXT;
BEGIN
  FOR e IN SELECT * FROM ledger_entries ORDER BY account_id, id LOOP
    SELECT c.row_hash INTO prev FROM ledger_entry_chain c
     WHERE c.account_id = e.account_id ORDER BY c.entry_id DESC LIMIT 1;
    prev := coalesce(prev, '');
    INSERT INTO ledger_entry_chain VALUES (e.id, e.account_id, prev, ledger_entry_digest(e, prev));
  END LOOP;
  prev := '';
  FOR a IN SELECT * FROM audit_log ORDER BY occurred_at, id LOOP
    INSERT INTO audit_log_chain (audit_id, prev_hash, row_hash)
    VALUES (a.id, prev, audit_entry_digest(a, prev));
    prev := audit_entry_digest(a, prev);
  END LOOP;
END $$;

CREATE TRIGGER zz_ledger_entries_chain AFTER INSERT ON "ledger_entries"
  FOR EACH ROW EXECUTE FUNCTION ledger_chain_append();
CREATE TRIGGER zz_audit_log_chain AFTER INSERT ON "audit_log"
  FOR EACH ROW EXECUTE FUNCTION audit_chain_append();

-- Lines whose link is broken (content changed, line inserted, removed or missing from the chain).
CREATE FUNCTION ledger_chain_breaks() RETURNS SETOF BIGINT
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public, pg_temp AS $$
  SELECT e.id FROM ledger_entries e LEFT JOIN ledger_entry_chain c ON c.entry_id = e.id
   WHERE c.entry_id IS NULL
  UNION
  SELECT c.entry_id FROM (
    SELECT c.*, lag(c.row_hash, 1, '') OVER (PARTITION BY c.account_id ORDER BY c.entry_id)
             AS expected_prev
      FROM ledger_entry_chain c) c
    LEFT JOIN ledger_entries e ON e.id = c.entry_id
   WHERE e.id IS NULL OR c.prev_hash <> c.expected_prev
      OR c.row_hash <> ledger_entry_digest(e, c.prev_hash)
$$;

CREATE FUNCTION audit_chain_breaks() RETURNS SETOF UUID
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public, pg_temp AS $$
  SELECT a.id FROM audit_log a LEFT JOIN audit_log_chain c ON c.audit_id = a.id
   WHERE c.audit_id IS NULL
  UNION
  SELECT c.audit_id FROM (
    SELECT c.*, lag(c.row_hash, 1, '') OVER (ORDER BY c.seq) AS expected_prev
      FROM audit_log_chain c) c
    LEFT JOIN audit_log a ON a.id = c.audit_id
   WHERE a.id IS NULL OR c.prev_hash <> c.expected_prev
      OR c.row_hash <> audit_entry_digest(a, c.prev_hash)
$$;

REVOKE ALL ON FUNCTION ledger_chain_breaks(), audit_chain_breaks() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION ledger_chain_breaks(), audit_chain_breaks() TO flexipay_app;
