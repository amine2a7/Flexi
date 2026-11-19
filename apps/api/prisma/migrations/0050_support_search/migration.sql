-- W-SUP: support tickets and dynamic search.

-- ---------------------------------------------------------------- search
-- Full-text search (tsvector, without accents) and trigrams (typos, pieces of words). Both are
-- trusted extensions: the owner of the database creates them.
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Searched text, lower case and without accents. Declared immutable so that it can be indexed
-- (the unaccent dictionary is fixed). Never applied to a sealed column (CIN, RIB, phones).
CREATE FUNCTION fp_norm(value text) RETURNS text
LANGUAGE sql IMMUTABLE PARALLEL SAFE AS
$$ SELECT lower(public.unaccent('public.unaccent'::regdictionary, coalesce(value, ''))) $$;

-- Searched text of each table, stored (computed once per write, never per search): the row
-- level security keeps non-leakproof operators (LIKE, trigrams) above its own filter, so a search
-- reads these two cheap columns instead of normalising every row. Trigram index (substring,
-- typos) and full-text index (words, prefixes) on them.
ALTER TABLE "companies"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("name" || ' ' || "email" || ' ' || "city")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("name" || ' ' || "email" || ' ' || "city"))) STORED;
CREATE INDEX "companies_search_trgm" ON "companies" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "companies_search_fts" ON "companies" USING gin ("search_tsv");

ALTER TABLE "merchants"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("name" || ' ' || "email" || ' ' || "city" || ' ' || "payment_code")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("name" || ' ' || "email" || ' ' || "city" || ' ' || "payment_code"))) STORED;
CREATE INDEX "merchants_search_trgm" ON "merchants" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "merchants_search_fts" ON "merchants" USING gin ("search_tsv");

ALTER TABLE "users"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("display_name" || ' ' || "email")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("display_name" || ' ' || "email"))) STORED;
CREATE INDEX "users_search_trgm" ON "users" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "users_search_fts" ON "users" USING gin ("search_tsv");

ALTER TABLE "employees"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("first_name" || ' ' || "last_name" || ' ' || "email" || ' ' || "employee_number")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("first_name" || ' ' || "last_name" || ' ' || "email" || ' ' || "employee_number"))) STORED;
CREATE INDEX "employees_search_trgm" ON "employees" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "employees_search_fts" ON "employees" USING gin ("search_tsv");

ALTER TABLE "credit_orders"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("reference")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("reference"))) STORED;
CREATE INDEX "credit_orders_search_trgm" ON "credit_orders" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "credit_orders_search_fts" ON "credit_orders" USING gin ("search_tsv");

ALTER TABLE "payments"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("reference")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("reference"))) STORED;
CREATE INDEX "payments_search_trgm" ON "payments" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "payments_search_fts" ON "payments" USING gin ("search_tsv");

ALTER TABLE "payout_requests"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("reference")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("reference"))) STORED;
CREATE INDEX "payout_requests_search_trgm" ON "payout_requests" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "payout_requests_search_fts" ON "payout_requests" USING gin ("search_tsv");

ALTER TABLE "invoices"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("number")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("number"))) STORED;
CREATE INDEX "invoices_search_trgm" ON "invoices" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "invoices_search_fts" ON "invoices" USING gin ("search_tsv");

-- ---------------------------------------------------------------- support tickets
CREATE TYPE "TicketCategory" AS ENUM (
  'PAYMENT_DECLINED', 'DISPUTED_TRANSACTION', 'ACCOUNT_ACCESS', 'ORDER_TRANSFER', 'PAYOUT',
  'KYC', 'OTHER');
CREATE TYPE "TicketStatus" AS ENUM (
  'OPEN', 'IN_PROGRESS', 'WAITING_CUSTOMER', 'RESOLVED', 'CLOSED');
CREATE TYPE "TicketPriority" AS ENUM ('NORMAL', 'HIGH');
CREATE TYPE "TicketTeam" AS ENUM ('SUPPORT', 'FINANCE', 'OPERATIONS');
CREATE TYPE "TicketLinkType" AS ENUM ('PAYMENT', 'ORDER', 'PAYOUT');

-- TK-AAAA-NNNNNN: one sequence, the year of the opening.
CREATE SEQUENCE ticket_reference_seq START 1;
GRANT USAGE, SELECT ON SEQUENCE ticket_reference_seq TO flexipay_app;

CREATE TABLE "support_tickets" (
  "id" UUID PRIMARY KEY,
  "reference" VARCHAR(20) NOT NULL UNIQUE,
  "category" "TicketCategory" NOT NULL,
  "priority" "TicketPriority" NOT NULL,
  "status" "TicketStatus" NOT NULL DEFAULT 'OPEN',
  "team" "TicketTeam" NOT NULL DEFAULT 'SUPPORT',
  "subject" VARCHAR(160) NOT NULL,
  "description" VARCHAR(4000) NOT NULL,
  -- A secret typed by the client (PIN, password, card number) was masked before saving.
  "redacted" BOOLEAN NOT NULL DEFAULT false,
  "requester_id" UUID NOT NULL REFERENCES "users" ("id"),
  "requester_name" VARCHAR(120) NOT NULL,
  "requester_role" "Role" NOT NULL,
  "company_id" UUID REFERENCES "companies" ("id"),
  "merchant_id" UUID REFERENCES "merchants" ("id"),
  "employee_id" UUID REFERENCES "employees" ("id"),
  "link_type" "TicketLinkType",
  "link_id" UUID,
  "link_reference" VARCHAR(32),
  "assignee_id" UUID REFERENCES "users" ("id"),
  "assignee_name" VARCHAR(120),
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- First answer expected before this instant (« en retard » after it).
  "first_response_due_at" TIMESTAMPTZ(3) NOT NULL,
  "first_response_at" TIMESTAMPTZ(3),
  "resolved_at" TIMESTAMPTZ(3),
  "closed_at" TIMESTAMPTZ(3),
  CONSTRAINT "support_tickets_one_tenant"
    CHECK (num_nonnulls("company_id", "merchant_id", "employee_id") = 1),
  CONSTRAINT "support_tickets_link" CHECK (("link_type" IS NULL) = ("link_id" IS NULL))
);
CREATE INDEX "support_tickets_queue_idx" ON "support_tickets" ("status", "created_at" DESC);
CREATE INDEX "support_tickets_company_idx" ON "support_tickets" ("company_id", "created_at" DESC);
CREATE INDEX "support_tickets_merchant_idx" ON "support_tickets" ("merchant_id", "created_at" DESC);
CREATE INDEX "support_tickets_employee_idx" ON "support_tickets" ("employee_id", "created_at" DESC);
ALTER TABLE "support_tickets"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (fp_norm("reference" || ' ' || "subject")) STORED,
  ADD COLUMN "search_tsv" TSVECTOR
    GENERATED ALWAYS AS (to_tsvector('simple', fp_norm("reference" || ' ' || "subject"))) STORED;
CREATE INDEX "support_tickets_search_trgm" ON "support_tickets" USING gin ("search_text" gin_trgm_ops);
CREATE INDEX "support_tickets_search_fts" ON "support_tickets" USING gin ("search_tsv");

-- The conversation is append only: a message is never changed nor removed.
CREATE TABLE "support_ticket_messages" (
  "id" UUID PRIMARY KEY,
  "ticket_id" UUID NOT NULL REFERENCES "support_tickets" ("id"),
  "author_id" UUID REFERENCES "users" ("id"),
  "author_name" VARCHAR(120) NOT NULL,
  "from_agent" BOOLEAN NOT NULL,
  -- Internal note: FlexiPay only.
  "internal" BOOLEAN NOT NULL DEFAULT false,
  "body" VARCHAR(4000) NOT NULL,
  "redacted" BOOLEAN NOT NULL DEFAULT false,
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "support_ticket_messages_internal" CHECK (NOT "internal" OR "from_agent")
);
CREATE INDEX "support_ticket_messages_ticket_idx"
  ON "support_ticket_messages" ("ticket_id", "created_at");

-- Pieces (PDF, JPG, PNG, 5 MB), encrypted on the storage, reached by a signed link (5 min).
CREATE TABLE "support_ticket_attachments" (
  "id" UUID PRIMARY KEY,
  "ticket_id" UUID NOT NULL REFERENCES "support_tickets" ("id"),
  "message_id" UUID REFERENCES "support_ticket_messages" ("id"),
  "file_name" VARCHAR(255) NOT NULL,
  "content_type" VARCHAR(40) NOT NULL,
  "size_bytes" INTEGER NOT NULL CHECK ("size_bytes" > 0 AND "size_bytes" <= 5242880),
  "storage_key" TEXT NOT NULL,
  "uploaded_by" UUID REFERENCES "users" ("id"),
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX "support_ticket_attachments_ticket_idx" ON "support_ticket_attachments" ("ticket_id");

GRANT SELECT, INSERT, UPDATE ON "support_tickets" TO flexipay_app;
GRANT SELECT, INSERT ON "support_ticket_messages", "support_ticket_attachments" TO flexipay_app;
REVOKE DELETE, TRUNCATE ON "support_tickets", "support_ticket_messages",
  "support_ticket_attachments" FROM flexipay_app;

-- A ticket belongs to one tenant: the platform, or its company, merchant or beneficiary. Inside
-- a company or a merchant, the service narrows it to the requester (the owner sees them all).
ALTER TABLE "support_tickets" ENABLE ROW LEVEL SECURITY;
CREATE POLICY support_tickets_access ON "support_tickets" USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
  OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
  OR (app_role() = 'EMPLOYEE' AND employee_id = app_uuid('employee_id'))
);

-- Internal notes never reach a client, even by a direct read.
ALTER TABLE "support_ticket_messages" ENABLE ROW LEVEL SECURITY;
CREATE POLICY support_ticket_messages_access ON "support_ticket_messages"
  USING (
    EXISTS (SELECT 1 FROM support_tickets t WHERE t.id = ticket_id)
    AND (app_is_platform() OR NOT internal)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM support_tickets t WHERE t.id = ticket_id)
    AND (app_is_platform() OR (NOT internal AND NOT from_agent))
  );

ALTER TABLE "support_ticket_attachments" ENABLE ROW LEVEL SECURITY;
CREATE POLICY support_ticket_attachments_access ON "support_ticket_attachments" USING (
  EXISTS (SELECT 1 FROM support_tickets t WHERE t.id = ticket_id)
  AND (message_id IS NULL
       OR EXISTS (SELECT 1 FROM support_ticket_messages m WHERE m.id = message_id))
);

-- ---------------------------------------------------------------- candidates of a search
-- The row level security keeps the non-leakproof search operators (LIKE, trigrams, full text)
-- above its own filter: they could never use the GIN indexes under it. This function, owned by
-- the schema owner, only returns the ids and scores of the best rows of one table (optionally of
-- one tenant column) through the indexes; the API then reads those rows UNDER the RLS of the
-- session and its explicit tenant filter, so no row of another tenant is ever returned.
CREATE FUNCTION fp_search_candidates(
  tbl text, needle text, pattern text, words text, parts text[], scope_column text, scope_id uuid
) RETURNS TABLE (id uuid, score real)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public, pg_temp AS $$
DECLARE
  scope text := '';
  found integer;
  q text := fp_norm(needle);
  p text := fp_norm(pattern);
  w text := CASE WHEN words IS NULL THEN NULL ELSE fp_norm(words) END;
  -- Every word typed found as a piece of the text (« prenom 512 » finds « Prénom512 »).
  pieces text[] := ARRAY(SELECT fp_norm(x) FROM unnest(coalesce(parts, '{}')) AS x LIMIT 4);
  every_piece text := 'false';
BEGIN
  IF tbl NOT IN ('companies', 'merchants', 'users', 'employees', 'credit_orders', 'payments',
                 'payout_requests', 'invoices', 'support_tickets') THEN
    RAISE EXCEPTION 'table not searchable' USING ERRCODE = '42501';
  END IF;
  IF scope_column IS NOT NULL THEN
    IF scope_column NOT IN ('company_id', 'merchant_id', 'employee_id') OR scope_id IS NULL THEN
      RAISE EXCEPTION 'scope not allowed' USING ERRCODE = '42501';
    END IF;
    scope := format(' AND t.%I = $4', scope_column);
  END IF;
  IF cardinality(pieces) > 1 THEN
    SELECT string_agg(format('t.search_text LIKE $5[%s]', i), ' AND ')
      INTO every_piece FROM generate_series(1, cardinality(pieces)) AS i;
  END IF;
  -- 1. Pieces of words and word prefixes (substring, full text).
  RETURN QUERY EXECUTE format(
    'SELECT t.id, word_similarity($1, t.search_text) AS score FROM %I t
      WHERE (t.search_text LIKE $2 OR t.search_tsv @@ to_tsquery(''simple'', $3) OR (%s))%s
      ORDER BY score DESC LIMIT 200', tbl, every_piece, scope)
    USING q, p, w, scope_id, pieces;
  GET DIAGNOSTICS found = ROW_COUNT;
  -- 2. Typos (trigrams), only when the text is not found as typed.
  IF found < 5 AND length(q) >= 3 THEN
    PERFORM set_config('pg_trgm.word_similarity_threshold', '0.55', true);
    RETURN QUERY EXECUTE format(
      'SELECT t.id, word_similarity($1, t.search_text) AS score FROM %I t
        WHERE $1 <%% t.search_text
          AND NOT (t.search_text LIKE $2 OR coalesce(t.search_tsv @@ to_tsquery(''simple'', $3), false)
                   OR (%s))%s
        ORDER BY score DESC LIMIT 20', tbl, every_piece, scope)
      USING q, p, w, scope_id, pieces;
  END IF;
END $$;
REVOKE ALL ON FUNCTION fp_search_candidates(text, text, text, text, text[], text, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION fp_search_candidates(text, text, text, text, text[], text, uuid) TO flexipay_app;
