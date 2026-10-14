-- FlexiPay: application role, ledger invariants, append-only tables, Row-Level Security.
-- Never edit this migration once applied: add a new one (CLAUDE.md rule 17).

-- ------------------------------------------------------------------ application role
-- Created here (decision of 2026-10-11, DC-5) without password; `db:setup` gives it LOGIN and the
-- password of infra/.env. NOSUPERUSER NOBYPASSRLS: the policies below always apply to the API.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'flexipay_app') THEN
    CREATE ROLE flexipay_app NOLOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOINHERIT;
  END IF;
END $$;

GRANT USAGE ON SCHEMA public TO flexipay_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO flexipay_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO flexipay_app;

-- Ledger and audit log: append-only for the application (and by trigger for everyone).
REVOKE UPDATE, DELETE, TRUNCATE ON ledger_transactions, ledger_entries, audit_log FROM flexipay_app;
REVOKE DELETE, TRUNCATE ON account_balances, credit_lots FROM flexipay_app;
REVOKE DELETE, TRUNCATE ON credit_orders, payments, payout_requests, settlement_batches FROM flexipay_app;

-- ------------------------------------------------------------------ amounts
ALTER TABLE ledger_entries ADD CONSTRAINT ledger_entries_amount_positive CHECK (amount_millimes > 0);
ALTER TABLE account_balances
  ADD CONSTRAINT account_balances_non_negative CHECK (NOT non_negative OR balance_millimes >= 0);
ALTER TABLE credit_lots
  ADD CONSTRAINT credit_lots_remaining_range
  CHECK (remaining_millimes >= 0 AND remaining_millimes <= initial_millimes AND initial_millimes > 0);
ALTER TABLE credit_orders
  ADD CONSTRAINT credit_orders_amounts
  CHECK (amount_millimes > 0 AND fees_millimes >= 0 AND total_millimes = amount_millimes + fees_millimes);
ALTER TABLE credit_order_lines ADD CONSTRAINT credit_order_lines_amount CHECK (amount_millimes > 0);
ALTER TABLE allocations ADD CONSTRAINT allocations_amount CHECK (amount_millimes > 0);
ALTER TABLE payments ADD CONSTRAINT payments_amount CHECK (amount_millimes > 0);
ALTER TABLE payout_quotes
  ADD CONSTRAINT payout_quotes_amounts
  CHECK (gross_millimes > 0 AND commission_millimes >= 0 AND net_millimes = gross_millimes - commission_millimes);
ALTER TABLE payout_requests
  ADD CONSTRAINT payout_requests_amounts
  CHECK (gross_millimes > 0 AND commission_millimes >= 0 AND net_millimes = gross_millimes - commission_millimes);
ALTER TABLE payout_requests
  ADD CONSTRAINT payout_requests_rate CHECK (commission_rate_bps BETWEEN 0 AND 10000);
ALTER TABLE commission_profiles ADD CONSTRAINT commission_profiles_rate CHECK (rate_bps BETWEEN 0 AND 10000);
ALTER TABLE credit_type_settings
  ADD CONSTRAINT credit_type_settings_values
  CHECK (commission_rate_bps BETWEEN 0 AND 10000 AND validity_months BETWEEN 1 AND 60 AND daily_limit_millimes > 0);
ALTER TABLE users
  ADD CONSTRAINT users_single_tenant
  CHECK (num_nonnulls(company_id, merchant_id, employee_id) <= 1);

-- ------------------------------------------------------------------ append-only tables
CREATE FUNCTION forbid_change() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION '% is append-only', TG_TABLE_NAME USING ERRCODE = '42501';
END $$;

CREATE TRIGGER ledger_transactions_append_only BEFORE UPDATE OR DELETE ON ledger_transactions
  FOR EACH ROW EXECUTE FUNCTION forbid_change();
CREATE TRIGGER ledger_transactions_no_truncate BEFORE TRUNCATE ON ledger_transactions
  FOR EACH STATEMENT EXECUTE FUNCTION forbid_change();
CREATE TRIGGER ledger_entries_append_only BEFORE UPDATE OR DELETE ON ledger_entries
  FOR EACH ROW EXECUTE FUNCTION forbid_change();
CREATE TRIGGER ledger_entries_no_truncate BEFORE TRUNCATE ON ledger_entries
  FOR EACH STATEMENT EXECUTE FUNCTION forbid_change();
CREATE TRIGGER audit_log_append_only BEFORE UPDATE OR DELETE ON audit_log
  FOR EACH ROW EXECUTE FUNCTION forbid_change();
CREATE TRIGGER audit_log_no_truncate BEFORE TRUNCATE ON audit_log
  FOR EACH STATEMENT EXECUTE FUNCTION forbid_change();

-- ------------------------------------------------------------------ double entry
-- Checked at COMMIT (deferred): every ledger transaction has entries, and debits = credits.
CREATE FUNCTION ledger_check_balanced() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
  tx uuid := CASE WHEN TG_TABLE_NAME = 'ledger_transactions' THEN NEW.id ELSE NEW.transaction_id END;
  debits bigint;
  credits bigint;
BEGIN
  SELECT coalesce(sum(amount_millimes) FILTER (WHERE direction = 'D'), 0),
         coalesce(sum(amount_millimes) FILTER (WHERE direction = 'C'), 0)
    INTO debits, credits
    FROM ledger_entries WHERE transaction_id = tx;
  IF debits = 0 OR debits <> credits THEN
    RAISE EXCEPTION 'unbalanced ledger transaction %', tx USING ERRCODE = '23514';
  END IF;
  RETURN NULL;
END $$;

CREATE CONSTRAINT TRIGGER ledger_entries_balanced AFTER INSERT ON ledger_entries
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION ledger_check_balanced();
CREATE CONSTRAINT TRIGGER ledger_transactions_have_entries AFTER INSERT ON ledger_transactions
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION ledger_check_balanced();

-- A reversal points to an existing transaction, and a transaction is reversed at most once.
ALTER TABLE ledger_transactions
  ADD CONSTRAINT ledger_transactions_reverses_fk FOREIGN KEY (reverses_id) REFERENCES ledger_transactions (id);
CREATE UNIQUE INDEX ledger_transactions_reversed_once ON ledger_transactions (reverses_id)
  WHERE reverses_id IS NOT NULL;

-- Idempotency safety net, independent of the registry (contract §5): one ledger transaction per
-- (tenant, user, key).
CREATE UNIQUE INDEX ledger_transactions_idempotency ON ledger_transactions (tenant_id, user_id, idempotency_key)
  NULLS NOT DISTINCT WHERE idempotency_key IS NOT NULL;

-- ------------------------------------------------------------------ Row-Level Security
-- The API sets, inside each SQL transaction (set_config(..., true)): app.role (ADMIN, COMPANY,
-- MERCHANT, EMPLOYEE or SYSTEM for audited cross-tenant server steps), app.company_id,
-- app.merchant_id, app.employee_id, app.user_id. Without them, no tenant row is visible.
CREATE FUNCTION app_role() RETURNS text LANGUAGE sql STABLE AS
  $$ SELECT coalesce(current_setting('app.role', true), '') $$;
CREATE FUNCTION app_uuid(name text) RETURNS uuid LANGUAGE sql STABLE AS
  $$ SELECT nullif(current_setting('app.' || name, true), '')::uuid $$;
CREATE FUNCTION app_is_platform() RETURNS boolean LANGUAGE sql STABLE AS
  $$ SELECT app_role() IN ('ADMIN', 'SYSTEM') $$;

ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
CREATE POLICY companies_access ON companies USING (
  app_is_platform() OR id = app_uuid('company_id')
);

ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
CREATE POLICY employees_access ON employees USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
  OR (app_role() = 'EMPLOYEE' AND id = app_uuid('employee_id'))
);

ALTER TABLE merchants ENABLE ROW LEVEL SECURITY;
-- Name, city and accepted types of a merchant are shown to beneficiaries (pay by merchant code).
CREATE POLICY merchants_read ON merchants FOR SELECT USING (
  app_is_platform() OR id = app_uuid('merchant_id') OR app_role() = 'EMPLOYEE'
);
CREATE POLICY merchants_write ON merchants FOR UPDATE USING (app_is_platform());
CREATE POLICY merchants_insert ON merchants FOR INSERT WITH CHECK (app_is_platform());

ALTER TABLE points_of_sale ENABLE ROW LEVEL SECURITY;
CREATE POLICY points_of_sale_access ON points_of_sale USING (
  app_is_platform() OR merchant_id = app_uuid('merchant_id')
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY users_access ON users USING (
  app_is_platform()
  OR id = app_uuid('user_id')
  OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
);

ALTER TABLE credit_orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY credit_orders_access ON credit_orders USING (
  app_is_platform() OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
);
ALTER TABLE credit_order_lines ENABLE ROW LEVEL SECURITY;
CREATE POLICY credit_order_lines_access ON credit_order_lines USING (
  EXISTS (SELECT 1 FROM credit_orders o WHERE o.id = order_id)
);
ALTER TABLE credit_order_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY credit_order_events_access ON credit_order_events USING (
  EXISTS (SELECT 1 FROM credit_orders o WHERE o.id = order_id)
);

ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
CREATE POLICY invoices_access ON invoices USING (
  app_is_platform() OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
);

ALTER TABLE allocations ENABLE ROW LEVEL SECURITY;
CREATE POLICY allocations_access ON allocations USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
  OR (app_role() = 'EMPLOYEE' AND employee_id = app_uuid('employee_id'))
);

ALTER TABLE credit_expiries ENABLE ROW LEVEL SECURITY;
CREATE POLICY credit_expiries_access ON credit_expiries USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
  OR (app_role() = 'EMPLOYEE' AND employee_id = app_uuid('employee_id'))
);

ALTER TABLE payment_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY payment_codes_access ON payment_codes USING (
  app_role() = 'SYSTEM' OR (app_role() = 'EMPLOYEE' AND employee_id = app_uuid('employee_id'))
);

ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY payments_access ON payments USING (
  app_is_platform()
  OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
  OR (app_role() = 'EMPLOYEE' AND employee_id = app_uuid('employee_id'))
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
);
ALTER TABLE payment_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY payment_events_access ON payment_events USING (
  EXISTS (SELECT 1 FROM payments p WHERE p.id = payment_id)
);

ALTER TABLE payout_quotes ENABLE ROW LEVEL SECURITY;
CREATE POLICY payout_quotes_access ON payout_quotes USING (
  app_is_platform() OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
);
ALTER TABLE payout_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY payout_requests_access ON payout_requests USING (
  app_is_platform() OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
);
ALTER TABLE payout_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY payout_events_access ON payout_events USING (
  EXISTS (SELECT 1 FROM payout_requests r WHERE r.id = payout_id)
);

ALTER TABLE merchant_documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY merchant_documents_access ON merchant_documents USING (
  app_is_platform() OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
);

ALTER TABLE kyc_files ENABLE ROW LEVEL SECURITY;
CREATE POLICY kyc_files_access ON kyc_files USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
  OR (app_role() = 'MERCHANT' AND merchant_id = app_uuid('merchant_id'))
);
ALTER TABLE kyc_documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY kyc_documents_access ON kyc_documents USING (
  EXISTS (SELECT 1 FROM kyc_files f WHERE f.id = file_id)
);
ALTER TABLE kyc_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY kyc_events_access ON kyc_events USING (
  EXISTS (SELECT 1 FROM kyc_files f WHERE f.id = file_id)
);

-- Platform tables: administrators (and audited server steps) only.
ALTER TABLE approvals ENABLE ROW LEVEL SECURITY;
CREATE POLICY approvals_access ON approvals USING (app_is_platform());
ALTER TABLE settlement_batches ENABLE ROW LEVEL SECURITY;
CREATE POLICY settlement_batches_access ON settlement_batches USING (
  app_is_platform()
  OR (app_role() = 'MERCHANT' AND EXISTS (
    SELECT 1 FROM payout_requests r WHERE r.batch_id = settlement_batches.id
  ))
);
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY contact_messages_read ON contact_messages FOR SELECT USING (app_is_platform());
CREATE POLICY contact_messages_update ON contact_messages FOR UPDATE USING (app_is_platform());
-- The public form inserts as SYSTEM through the contact service only.
CREATE POLICY contact_messages_insert ON contact_messages FOR INSERT WITH CHECK (app_role() = 'SYSTEM');
