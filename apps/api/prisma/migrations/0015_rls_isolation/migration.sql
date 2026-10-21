-- Row-Level Security on the ledger, the authentication secrets, the audit log and the idempotency
-- registry (securite B5-S10): the database isolates them even if a query forgets a filter.

-- ------------------------------------------------------------------ ledger
-- An account is visible to the platform, to its owner, to a company for the wallets of its own
-- employees; the write paths also need: a beneficiary's payment credits the merchant wallet, a
-- merchant's payout request credits platform accounts (payable, commission).
CREATE FUNCTION ledger_account_visible(kind "LedgerOwnerType", owner uuid) RETURNS boolean
  LANGUAGE sql STABLE AS $$
  SELECT app_is_platform()
    OR (app_role() = 'COMPANY' AND kind = 'COMPANY' AND owner = app_uuid('company_id'))
    OR (app_role() = 'COMPANY' AND kind = 'EMPLOYEE'
        AND EXISTS (SELECT 1 FROM employees e WHERE e.id = owner AND e.company_id = app_uuid('company_id')))
    OR (app_role() = 'EMPLOYEE' AND kind = 'EMPLOYEE' AND owner = app_uuid('employee_id'))
    OR (app_role() = 'EMPLOYEE' AND kind = 'MERCHANT')
    OR (app_role() = 'MERCHANT' AND kind = 'MERCHANT' AND owner = app_uuid('merchant_id'))
    OR (app_role() = 'MERCHANT' AND kind = 'PLATFORM')
$$;

ALTER TABLE ledger_accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY ledger_accounts_access ON ledger_accounts
  USING (ledger_account_visible(owner_type, owner_id))
  WITH CHECK (ledger_account_visible(owner_type, owner_id));

-- Balances, entries and lots follow their account (the subquery is itself filtered by RLS).
ALTER TABLE account_balances ENABLE ROW LEVEL SECURITY;
CREATE POLICY account_balances_access ON account_balances
  USING (EXISTS (SELECT 1 FROM ledger_accounts a WHERE a.id = account_balances.account_id));
ALTER TABLE ledger_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY ledger_entries_access ON ledger_entries
  USING (EXISTS (SELECT 1 FROM ledger_accounts a WHERE a.id = ledger_entries.account_id));
ALTER TABLE credit_lots ENABLE ROW LEVEL SECURITY;
CREATE POLICY credit_lots_access ON credit_lots
  USING (EXISTS (SELECT 1 FROM ledger_accounts a WHERE a.id = credit_lots.account_id));

-- A transaction is written by any signed-in context (its entries are checked above) and read
-- when one of its entries is visible.
ALTER TABLE ledger_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY ledger_transactions_insert ON ledger_transactions FOR INSERT
  WITH CHECK (app_role() <> '');
CREATE POLICY ledger_transactions_read ON ledger_transactions FOR SELECT
  USING (app_is_platform()
         OR EXISTS (SELECT 1 FROM ledger_entries e WHERE e.transaction_id = ledger_transactions.id));

-- The balance check of a transaction always sees all its entries (owner rights, not the RLS of
-- the caller): an invisible entry can never make an unbalanced transaction pass, or the reverse.
ALTER FUNCTION ledger_check_balanced() SECURITY DEFINER;
ALTER FUNCTION ledger_check_balanced() SET search_path = public;

-- ------------------------------------------------------------------ authentication secrets
-- Only the audited server steps (SYSTEM) touch them; the API never reads them in a user context.
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY sessions_system ON sessions USING (app_role() = 'SYSTEM');
ALTER TABLE recovery_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY recovery_codes_system ON recovery_codes USING (app_role() = 'SYSTEM');
ALTER TABLE mfa_challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY mfa_challenges_system ON mfa_challenges USING (app_role() = 'SYSTEM');
ALTER TABLE password_reset_tokens ENABLE ROW LEVEL SECURITY;
CREATE POLICY password_reset_tokens_system ON password_reset_tokens USING (app_role() = 'SYSTEM');
ALTER TABLE login_failures ENABLE ROW LEVEL SECURITY;
CREATE POLICY login_failures_system ON login_failures USING (app_role() = 'SYSTEM');

-- ------------------------------------------------------------------ audit and idempotency
-- Every action writes its audit entry in its own transaction; only the platform reads them.
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY audit_log_insert ON audit_log FOR INSERT WITH CHECK (app_role() <> '');
CREATE POLICY audit_log_read ON audit_log FOR SELECT USING (app_is_platform());

ALTER TABLE idempotency_keys ENABLE ROW LEVEL SECURITY;
CREATE POLICY idempotency_keys_access ON idempotency_keys
  USING (app_is_platform() OR user_id = app_uuid('user_id'))
  WITH CHECK (app_is_platform() OR user_id = app_uuid('user_id'));

-- ------------------------------------------------------------------ companies
-- Read by the platform, the company and its beneficiaries; written by the platform only.
DROP POLICY companies_access ON companies;
CREATE POLICY companies_read ON companies FOR SELECT
  USING (app_is_platform() OR id = app_uuid('company_id'));
CREATE POLICY companies_write ON companies FOR UPDATE USING (app_is_platform());
CREATE POLICY companies_insert ON companies FOR INSERT WITH CHECK (app_is_platform());
CREATE POLICY companies_delete ON companies FOR DELETE USING (app_is_platform());
