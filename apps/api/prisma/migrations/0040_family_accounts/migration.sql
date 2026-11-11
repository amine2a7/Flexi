-- Family accounts (processus v2, « Comptes famille »): a beneficiary creates up to N accounts for
-- relatives and transfers part of his credit to them; he takes it back at any time. A member is an
-- employee row held by the beneficiary (own wallet per type, PIN, lots, history), never a wallet
-- of the company: the company never allocates to a member and does not see it in its lists.
ALTER TABLE "employees" ADD COLUMN "holder_employee_id" UUID REFERENCES "employees" ("id") ON DELETE RESTRICT;
ALTER TABLE "employees" ADD COLUMN "relationship" VARCHAR(20);
ALTER TABLE "employees" ADD CONSTRAINT "employees_family_relationship" CHECK (
  ("holder_employee_id" IS NULL AND "relationship" IS NULL)
  OR ("holder_employee_id" IS NOT NULL AND "relationship" IN ('SPOUSE', 'CHILD', 'PARENT'))
);
CREATE INDEX "employees_holder_idx" ON "employees" ("holder_employee_id");

-- The company can switch family accounts off for its employees (parameter, on by default).
ALTER TABLE "companies" ADD COLUMN "family_accounts_enabled" BOOLEAN NOT NULL DEFAULT true;

-- What the holder set on a transfer to a member, per credit type: a daily cap and an end date
-- (both optional). Amounts in millimes.
CREATE TABLE "family_grants" (
  "member_employee_id" UUID NOT NULL REFERENCES "employees" ("id") ON DELETE RESTRICT,
  "holder_employee_id" UUID NOT NULL REFERENCES "employees" ("id") ON DELETE RESTRICT,
  "credit_type" "CreditType" NOT NULL,
  "daily_limit_millimes" BIGINT,
  "ends_on" DATE,
  "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  PRIMARY KEY ("member_employee_id", "credit_type"),
  CONSTRAINT "family_grants_limit_positive" CHECK ("daily_limit_millimes" IS NULL OR "daily_limit_millimes" > 0)
);
ALTER TABLE "family_grants" ENABLE ROW LEVEL SECURITY;
CREATE POLICY family_grants_access ON "family_grants" USING (
  app_is_platform()
  OR (app_role() = 'EMPLOYEE' AND (holder_employee_id = app_uuid('employee_id')
                                   OR member_employee_id = app_uuid('employee_id')))
);
GRANT SELECT, INSERT, UPDATE ON "family_grants" TO flexipay_app;

-- A beneficiary sees (and creates) the rows of his own family members; the company never sees
-- them (lists, counts, allocations: a member is not its employee).
DROP POLICY employees_access ON employees;
CREATE POLICY employees_access ON employees USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id') AND holder_employee_id IS NULL)
  OR (app_role() = 'EMPLOYEE' AND (id = app_uuid('employee_id')
                                   OR holder_employee_id = app_uuid('employee_id')))
);

-- The wallets of his family members are visible to the holder (transfer, take back).
CREATE OR REPLACE FUNCTION ledger_account_visible(kind "LedgerOwnerType", owner uuid) RETURNS boolean
  LANGUAGE sql STABLE AS $$
  SELECT app_is_platform()
    OR (app_role() = 'COMPANY' AND kind = 'COMPANY' AND owner = app_uuid('company_id'))
    OR (app_role() = 'COMPANY' AND kind = 'EMPLOYEE'
        AND EXISTS (SELECT 1 FROM employees e WHERE e.id = owner AND e.company_id = app_uuid('company_id')))
    OR (app_role() = 'EMPLOYEE' AND kind = 'EMPLOYEE' AND owner = app_uuid('employee_id'))
    OR (app_role() = 'EMPLOYEE' AND kind = 'EMPLOYEE'
        AND EXISTS (SELECT 1 FROM employees e WHERE e.id = owner AND e.holder_employee_id = app_uuid('employee_id')))
    OR (app_role() = 'EMPLOYEE' AND kind = 'MERCHANT')
    OR (app_role() = 'MERCHANT' AND kind = 'MERCHANT' AND owner = app_uuid('merchant_id'))
    OR (app_role() = 'MERCHANT' AND kind = 'PLATFORM')
$$;

-- Five members at most (processus v2, decision of 10/11).
UPDATE "platform_settings" SET "max_family_members" = 5 WHERE "max_family_members" < 5;
