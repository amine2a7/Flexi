-- Records of companies and merchants editable at any time by the administrator (decision of
-- 2026-11-03): history of the changes (names of the fields only, never their values: no personal
-- data in the history), the grid and the RIB through four-eyes requests.
ALTER TYPE "ApprovalType" ADD VALUE 'IBAN_CHANGE';

CREATE TABLE "account_changes" (
  "id" UUID PRIMARY KEY,
  "company_id" UUID REFERENCES "companies" ("id") ON DELETE RESTRICT,
  "merchant_id" UUID REFERENCES "merchants" ("id") ON DELETE RESTRICT,
  "fields" VARCHAR(40)[] NOT NULL,
  "reason" VARCHAR(500),
  "actor_id" UUID,
  "actor_name" VARCHAR(120) NOT NULL,
  "occurred_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  CONSTRAINT "account_changes_one_owner" CHECK (("company_id" IS NULL) <> ("merchant_id" IS NULL))
);
CREATE INDEX "account_changes_company_idx" ON "account_changes" ("company_id", "occurred_at");
CREATE INDEX "account_changes_merchant_idx" ON "account_changes" ("merchant_id", "occurred_at");
ALTER TABLE "account_changes" ENABLE ROW LEVEL SECURITY;
CREATE POLICY account_changes_access ON "account_changes" USING (app_is_platform());
GRANT SELECT, INSERT ON "account_changes" TO flexipay_app;
