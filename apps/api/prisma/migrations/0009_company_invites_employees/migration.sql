-- A company creates the sign-in account of its own employees (invitation, decision of 2026-10-14):
-- only an EMPLOYEE account, tied to one of its employees, with a temporary password to change.
-- Everything else on users stays reserved to the platform (policy users_access).
CREATE POLICY users_company_invites ON users FOR INSERT WITH CHECK (
  app_role() = 'COMPANY'
  AND role = 'EMPLOYEE'
  AND sub_role IS NULL
  AND company_id IS NULL
  AND merchant_id IS NULL
  AND must_change_password
  AND mfa_secret_enc IS NULL
  AND employee_id IN (SELECT id FROM employees WHERE company_id = app_uuid('company_id'))
);
