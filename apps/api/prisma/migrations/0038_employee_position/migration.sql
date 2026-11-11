-- Processus v2, bug 3: an employee has a department (list of the company) and a position (free
-- text, e.g. « Ouvrier »); both filter the list and drive bulk allocations. A department is
-- archived (never deleted), and only once it has no employee.
ALTER TABLE "employees" ADD COLUMN "position" VARCHAR(80);
CREATE INDEX "employees_company_position_idx" ON "employees" ("company_id", lower("position"));
ALTER TABLE "departments" ADD COLUMN "archived_at" TIMESTAMPTZ(3);
