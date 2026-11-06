-- Departments of a company (cahier ENT-04 « groupes/départements », spec 05 §3): a company groups
-- its employees by department. An employee belongs to at most one department.
CREATE TABLE "departments" (
  "id" UUID PRIMARY KEY,
  "company_id" UUID NOT NULL REFERENCES "companies" ("id") ON DELETE RESTRICT,
  "name" VARCHAR(80) NOT NULL,
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  CONSTRAINT "departments_name_not_blank" CHECK (btrim("name") <> '')
);
CREATE UNIQUE INDEX "departments_company_name_key" ON "departments" ("company_id", lower("name"));
ALTER TABLE "departments" ENABLE ROW LEVEL SECURITY;
CREATE POLICY departments_access ON "departments" USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
);
GRANT SELECT, INSERT, UPDATE ON "departments" TO flexipay_app;

ALTER TABLE "employees" ADD COLUMN "department_id" UUID REFERENCES "departments" ("id") ON DELETE RESTRICT;
CREATE INDEX "employees_department_idx" ON "employees" ("department_id");
