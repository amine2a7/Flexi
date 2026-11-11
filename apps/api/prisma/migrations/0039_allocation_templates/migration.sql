-- Allocation templates (processus v2, processus 4): a company saves the filters (department,
-- position) and the amount per credit type of an allocation, then relaunches it with its current
-- employees. A template is never a frozen list of people. Deleted = archived (kept for history).
CREATE TABLE "allocation_templates" (
  "id" UUID PRIMARY KEY,
  "company_id" UUID NOT NULL REFERENCES "companies" ("id") ON DELETE RESTRICT,
  "name" VARCHAR(80) NOT NULL,
  "department_id" UUID REFERENCES "departments" ("id") ON DELETE RESTRICT,
  "position" VARCHAR(80),
  "created_by" UUID NOT NULL,
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  "last_run_at" TIMESTAMPTZ(3),
  "archived_at" TIMESTAMPTZ(3),
  CONSTRAINT "allocation_templates_name_not_blank" CHECK (btrim("name") <> '')
);
CREATE UNIQUE INDEX "allocation_templates_company_name_key"
  ON "allocation_templates" ("company_id", lower("name")) WHERE "archived_at" IS NULL;
ALTER TABLE "allocation_templates" ENABLE ROW LEVEL SECURITY;
CREATE POLICY allocation_templates_access ON "allocation_templates" USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
);
GRANT SELECT, INSERT, UPDATE ON "allocation_templates" TO flexipay_app;

-- One amount per credit type, the same for every selected employee (millimes, never a decimal).
CREATE TABLE "allocation_template_amounts" (
  "template_id" UUID NOT NULL REFERENCES "allocation_templates" ("id") ON DELETE CASCADE,
  "company_id" UUID NOT NULL REFERENCES "companies" ("id") ON DELETE RESTRICT,
  "credit_type" "CreditType" NOT NULL,
  "amount_millimes" BIGINT NOT NULL,
  PRIMARY KEY ("template_id", "credit_type"),
  CONSTRAINT "allocation_template_amounts_positive" CHECK ("amount_millimes" > 0)
);
ALTER TABLE "allocation_template_amounts" ENABLE ROW LEVEL SECURITY;
CREATE POLICY allocation_template_amounts_access ON "allocation_template_amounts" USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
);
GRANT SELECT, INSERT, DELETE ON "allocation_template_amounts" TO flexipay_app;

-- The template an allocation was relaunched from (history; null for a free allocation).
ALTER TABLE "allocations" ADD COLUMN "template_id" UUID REFERENCES "allocation_templates" ("id");
