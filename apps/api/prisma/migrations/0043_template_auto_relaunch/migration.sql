-- Processus v2, « Relancer chaque mois » (décision du 2026-11-12): a template may relaunch itself
-- on a day of the month (1 to 28, present in every month); one automatic run per month at most.
ALTER TABLE "allocation_templates"
  ADD COLUMN "auto_monthly_day" SMALLINT CHECK ("auto_monthly_day" BETWEEN 1 AND 28),
  ADD COLUMN "last_auto_run_month" CHAR(7) CHECK ("last_auto_run_month" ~ '^[0-9]{4}-[0-9]{2}$'),
  ADD COLUMN "last_auto_run_status" VARCHAR(30);
