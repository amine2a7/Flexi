-- N2 disputes (decision of 2026-10-31): opened by an administrator on a payment, the amount is
-- held out of the merchant wallet (excluded from settlement), investigated (notes), then rejected
-- or accepted with the second validation of Finance (refund to the employee).
ALTER TYPE "ApprovalType" ADD VALUE IF NOT EXISTS 'DISPUTE_REFUND';
CREATE TYPE "DisputeStatus" AS ENUM ('OPEN', 'ACCEPTANCE_PENDING', 'ACCEPTED', 'REJECTED');
CREATE SEQUENCE dispute_number_seq START 1;

CREATE TABLE "disputes" (
  "id" UUID PRIMARY KEY,
  "reference" VARCHAR(32) NOT NULL UNIQUE,
  "payment_id" UUID NOT NULL UNIQUE REFERENCES "payments" ("id"),
  "merchant_id" UUID NOT NULL REFERENCES "merchants" ("id"),
  "amount_millimes" BIGINT NOT NULL CHECK ("amount_millimes" > 0),
  "reason" VARCHAR(500) NOT NULL,
  "status" "DisputeStatus" NOT NULL DEFAULT 'OPEN',
  "opened_by" UUID NOT NULL,
  "opened_by_name" VARCHAR(120) NOT NULL,
  "opened_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  -- Target of the decision: 15 days (decision of 2026-10-31).
  "due_at" TIMESTAMPTZ(3) NOT NULL,
  "decision_reason" VARCHAR(500),
  "decided_at" TIMESTAMPTZ(3),
  "hold_transaction_id" UUID NOT NULL,
  "resolution_transaction_id" UUID
);
CREATE INDEX "disputes_status_idx" ON "disputes" ("status", "opened_at");

CREATE TABLE "dispute_notes" (
  "id" UUID PRIMARY KEY,
  "dispute_id" UUID NOT NULL REFERENCES "disputes" ("id"),
  "author_id" UUID NOT NULL,
  "author_name" VARCHAR(120) NOT NULL,
  "text" VARCHAR(2000) NOT NULL,
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now()
);
CREATE INDEX "dispute_notes_dispute_idx" ON "dispute_notes" ("dispute_id", "created_at");

-- Platform staff only.
ALTER TABLE "disputes" ENABLE ROW LEVEL SECURITY;
CREATE POLICY disputes_access ON "disputes" USING (app_is_platform());
ALTER TABLE "dispute_notes" ENABLE ROW LEVEL SECURITY;
CREATE POLICY dispute_notes_access ON "dispute_notes" USING (app_is_platform());
GRANT SELECT, INSERT, UPDATE ON "disputes" TO flexipay_app;
GRANT SELECT, INSERT ON "dispute_notes" TO flexipay_app;
GRANT USAGE, SELECT ON SEQUENCE dispute_number_seq TO flexipay_app;
