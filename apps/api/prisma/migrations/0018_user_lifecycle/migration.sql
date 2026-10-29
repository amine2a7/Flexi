-- User management (decisions A to D of 2026-10-23, e3 of 2026-10-22): deactivated accounts, grace
-- period of a deactivated employee, subject and reason of an audit entry.
ALTER TYPE "UserStatus" ADD VALUE IF NOT EXISTS 'DEACTIVATED';
ALTER TYPE "EmployeeStatus" ADD VALUE IF NOT EXISTS 'DEACTIVATED';

-- Moment of the deactivation (irreversible).
ALTER TABLE "users" ADD COLUMN "deactivated_at" TIMESTAMPTZ(3);
-- End of the grace period, frozen at the deactivation (like the commission snapshot).
ALTER TABLE "employees" ADD COLUMN "grace_until" TIMESTAMPTZ(3);

-- Grace period of a deactivated employee, set by the administrator (30 days by default).
ALTER TABLE "platform_settings" ADD COLUMN "account_grace_days" INTEGER NOT NULL DEFAULT 30
  CHECK ("account_grace_days" BETWEEN 1 AND 365);

-- History of an account: the user the entry is about and the reason typed by the actor.
ALTER TABLE "audit_log" ADD COLUMN "subject_id" UUID;
ALTER TABLE "audit_log" ADD COLUMN "reason" VARCHAR(500);
CREATE INDEX "audit_log_subject_id_idx" ON "audit_log" ("subject_id", "occurred_at");
