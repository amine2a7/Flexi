-- Quote of a credit order, frozen for the validity of the settings (7 days by default): the order
-- created from it takes its amounts, even if the grid or the taxes changed meanwhile. Used once.
CREATE TABLE "order_quotes" (
  "id" UUID PRIMARY KEY,
  "company_id" UUID NOT NULL REFERENCES "companies" ("id") ON DELETE RESTRICT,
  "lines" JSONB NOT NULL,
  "amount_millimes" BIGINT NOT NULL,
  "fee_rate_bps" INTEGER NOT NULL,
  "fees_millimes" BIGINT NOT NULL,
  "vat_rate_bps" INTEGER NOT NULL,
  "vat_millimes" BIGINT NOT NULL,
  "stamp_duty_millimes" BIGINT NOT NULL,
  "total_millimes" BIGINT NOT NULL,
  "expires_at" TIMESTAMPTZ(3) NOT NULL,
  "used_at" TIMESTAMPTZ(3),
  "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  CONSTRAINT "order_quotes_amounts" CHECK (
    "amount_millimes" > 0 AND "fees_millimes" >= 0 AND "vat_millimes" >= 0
    AND "stamp_duty_millimes" >= 0
    AND "total_millimes" = "amount_millimes" + "fees_millimes" + "vat_millimes" + "stamp_duty_millimes"
  )
);
CREATE INDEX "order_quotes_company_idx" ON "order_quotes" ("company_id");
ALTER TABLE "order_quotes" ENABLE ROW LEVEL SECURITY;
CREATE POLICY order_quotes_access ON "order_quotes" USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND company_id = app_uuid('company_id'))
);
GRANT SELECT, INSERT, UPDATE ON "order_quotes" TO flexipay_app;
