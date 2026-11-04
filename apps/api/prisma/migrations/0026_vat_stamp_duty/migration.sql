-- VAT on the commission and stamp duty (decision of 2026-11-03), frozen in each order, payout
-- quote and payout request; the VAT of a cancelled commission is cancelled with it (dispute).
ALTER TABLE "credit_orders"
  ADD COLUMN "vat_rate_bps" INTEGER NOT NULL DEFAULT 0 CHECK ("vat_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "vat_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("vat_millimes" >= 0),
  ADD COLUMN "stamp_duty_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("stamp_duty_millimes" >= 0);
ALTER TABLE "payout_quotes"
  ADD COLUMN "vat_rate_bps" INTEGER NOT NULL DEFAULT 0 CHECK ("vat_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "vat_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("vat_millimes" >= 0),
  ADD COLUMN "stamp_duty_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("stamp_duty_millimes" >= 0);
ALTER TABLE "payout_requests"
  ADD COLUMN "vat_rate_bps" INTEGER NOT NULL DEFAULT 0 CHECK ("vat_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "vat_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("vat_millimes" >= 0),
  ADD COLUMN "stamp_duty_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("stamp_duty_millimes" >= 0);
ALTER TABLE "disputes"
  ADD COLUMN "vat_reversed_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("vat_reversed_millimes" >= 0);

-- Every line adds up (rows before this migration have no VAT nor stamp: still true for them).
ALTER TABLE "credit_orders" ADD CONSTRAINT "credit_orders_total_lines" CHECK (
  "total_millimes" = "amount_millimes" + "fees_millimes" + "vat_millimes" + "stamp_duty_millimes"
) NOT VALID;
ALTER TABLE "payout_quotes" ADD CONSTRAINT "payout_quotes_net_lines" CHECK (
  "net_millimes" = "gross_millimes" - "commission_millimes" - "vat_millimes" - "stamp_duty_millimes"
  AND "net_millimes" > 0
) NOT VALID;
ALTER TABLE "payout_requests" ADD CONSTRAINT "payout_requests_net_lines" CHECK (
  "net_millimes" = "gross_millimes" - "commission_millimes" - "vat_millimes" - "stamp_duty_millimes"
  AND "net_millimes" > 0
) NOT VALID;
