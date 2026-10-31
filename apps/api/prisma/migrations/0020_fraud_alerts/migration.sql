-- Fraud alerts (decision of 2026-10-31): starting rules set by the super-admin, never blocking
-- anything; Opérations handles each alert (open, in progress, closed with a reason).
CREATE TYPE "FraudAlertKind" AS ENUM ('REPEATED_REFUSALS', 'MERCHANT_BURST', 'NEAR_DAILY_LIMIT', 'RIB_CHANGE_PAYOUT', 'NEW_DEVICE_PAYMENT');
CREATE TYPE "FraudAlertSeverity" AS ENUM ('HIGH', 'MEDIUM', 'LOW');
CREATE TYPE "FraudAlertStatus" AS ENUM ('OPEN', 'IN_PROGRESS', 'CLOSED');

CREATE TABLE "fraud_alerts" (
  "id" UUID PRIMARY KEY,
  "kind" "FraudAlertKind" NOT NULL,
  "severity" "FraudAlertSeverity" NOT NULL,
  -- Shown name of the account or shop concerned (never a sensitive value).
  "subject" VARCHAR(120) NOT NULL,
  -- One alert per rule, subject and time window (the job may run twice).
  "subject_key" VARCHAR(160) NOT NULL,
  "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  "status" "FraudAlertStatus" NOT NULL DEFAULT 'OPEN',
  "handled_by" UUID,
  "handled_by_name" VARCHAR(120),
  "close_reason" VARCHAR(500),
  "closed_at" TIMESTAMPTZ(3),
  UNIQUE ("kind", "subject_key")
);
CREATE INDEX "fraud_alerts_status_idx" ON "fraud_alerts" ("status", "occurred_at");

ALTER TABLE "fraud_alerts" ENABLE ROW LEVEL SECURITY;
CREATE POLICY fraud_alerts_access ON "fraud_alerts" USING (app_is_platform());
GRANT SELECT, INSERT, UPDATE ON "fraud_alerts" TO flexipay_app;

-- Thresholds of the starting rules, set by the super-admin (settings change, four eyes).
ALTER TABLE "platform_settings" ADD COLUMN "fraud_rules" JSONB NOT NULL DEFAULT
  '{"refusedCount":5,"refusedMinutes":10,"merchantCount":3,"merchantMinutes":5,"limitPercent":80,"ribPayoutHours":24}';
