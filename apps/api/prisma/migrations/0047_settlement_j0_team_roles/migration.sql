-- Request of 2026-11-14.
-- 1. The settlement cycle accepts J+0 (0 to 10 business days).
ALTER TABLE platform_settings DROP CONSTRAINT platform_settings_settlement_days_check;
ALTER TABLE platform_settings
  ADD CONSTRAINT platform_settings_settlement_days_check CHECK (settlement_delay_days BETWEEN 0 AND 10);

-- 2. Company sub-roles: Propriétaire (OWNER), RH (MANAGER), Finance (FINANCE). The former
--    « Comptable » (ACCOUNTANT) of a company becomes Finance. Merchant sub-roles: Propriétaire
--    (OWNER), Caissier (CASHIER). The sessions of a changed account end (new permissions).
UPDATE sessions SET revoked_at = now()
 WHERE revoked_at IS NULL
   AND user_id IN (SELECT id FROM users WHERE role = 'COMPANY' AND sub_role = 'ACCOUNTANT');
UPDATE users SET sub_role = 'FINANCE' WHERE role = 'COMPANY' AND sub_role = 'ACCOUNTANT';

-- 3. A deleted (archived, always empty) department frees its name: a new one may take it.
DROP INDEX "departments_company_name_key";
CREATE UNIQUE INDEX "departments_company_name_key" ON "departments" ("company_id", lower("name"))
  WHERE archived_at IS NULL;
