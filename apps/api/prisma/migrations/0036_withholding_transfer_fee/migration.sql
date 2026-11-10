-- Fee rules of processus v2 (decisions of 2026-11-10): every order and every merchant payout
-- carries the commission, the VAT, a withholding tax above a threshold (rate of the legal form,
-- on the commission, ADDED like the VAT), the stamp duty and a transfer fee. All are settings,
-- frozen in each quote, order and payout. The legal form is required when a client is created
-- (rows created before: PM MF, the most common form, to be checked by Operations).
CREATE TYPE "LegalForm" AS ENUM ('PP_CIN', 'PP_MF', 'PM_MF');
ALTER TABLE "companies" ADD COLUMN "legal_form" "LegalForm" NOT NULL DEFAULT 'PM_MF';
ALTER TABLE "merchants" ADD COLUMN "legal_form" "LegalForm" NOT NULL DEFAULT 'PM_MF';

ALTER TABLE "platform_settings"
  ADD COLUMN "withholding_threshold_millimes" BIGINT NOT NULL DEFAULT 1000000 CHECK ("withholding_threshold_millimes" >= 0),
  ADD COLUMN "withholding_pp_cin_bps" INTEGER NOT NULL DEFAULT 300 CHECK ("withholding_pp_cin_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "withholding_pp_mf_bps" INTEGER NOT NULL DEFAULT 150 CHECK ("withholding_pp_mf_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "withholding_pm_mf_bps" INTEGER NOT NULL DEFAULT 100 CHECK ("withholding_pm_mf_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "transfer_fee_millimes" BIGINT NOT NULL DEFAULT 4000 CHECK ("transfer_fee_millimes" >= 0);

ALTER TABLE "credit_orders"
  ADD COLUMN "withholding_rate_bps" INTEGER NOT NULL DEFAULT 0 CHECK ("withholding_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "withholding_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("withholding_millimes" >= 0),
  ADD COLUMN "transfer_fee_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("transfer_fee_millimes" >= 0);
ALTER TABLE "order_quotes"
  ADD COLUMN "withholding_rate_bps" INTEGER NOT NULL DEFAULT 0 CHECK ("withholding_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "withholding_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("withholding_millimes" >= 0),
  ADD COLUMN "transfer_fee_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("transfer_fee_millimes" >= 0);
ALTER TABLE "payout_quotes"
  ADD COLUMN "withholding_rate_bps" INTEGER NOT NULL DEFAULT 0 CHECK ("withholding_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "withholding_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("withholding_millimes" >= 0),
  ADD COLUMN "transfer_fee_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("transfer_fee_millimes" >= 0);
ALTER TABLE "payout_requests"
  ADD COLUMN "withholding_rate_bps" INTEGER NOT NULL DEFAULT 0 CHECK ("withholding_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "withholding_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("withholding_millimes" >= 0),
  ADD COLUMN "transfer_fee_millimes" BIGINT NOT NULL DEFAULT 0 CHECK ("transfer_fee_millimes" >= 0);

-- Every line adds up, the two new ones included (rows before: 0, still true for them).
ALTER TABLE "credit_orders" DROP CONSTRAINT credit_orders_amounts;
ALTER TABLE "credit_orders" DROP CONSTRAINT credit_orders_total_lines;
ALTER TABLE "credit_orders" ADD CONSTRAINT credit_orders_amounts CHECK (
  amount_millimes > 0 AND fees_millimes >= 0
  AND total_millimes = amount_millimes + fees_millimes + vat_millimes + withholding_millimes
    + stamp_duty_millimes + transfer_fee_millimes
);
ALTER TABLE "order_quotes" DROP CONSTRAINT order_quotes_amounts;
ALTER TABLE "order_quotes" ADD CONSTRAINT order_quotes_amounts CHECK (
  amount_millimes > 0 AND fees_millimes >= 0
  AND total_millimes = amount_millimes + fees_millimes + vat_millimes + withholding_millimes
    + stamp_duty_millimes + transfer_fee_millimes
);
ALTER TABLE "payout_quotes" DROP CONSTRAINT payout_quotes_amounts;
ALTER TABLE "payout_quotes" DROP CONSTRAINT payout_quotes_net_lines;
ALTER TABLE "payout_quotes" ADD CONSTRAINT payout_quotes_amounts CHECK (
  gross_millimes > 0 AND commission_millimes >= 0 AND net_millimes > 0
  AND net_millimes = gross_millimes - commission_millimes - vat_millimes - withholding_millimes
    - stamp_duty_millimes - transfer_fee_millimes
);
ALTER TABLE "payout_requests" DROP CONSTRAINT payout_requests_amounts;
ALTER TABLE "payout_requests" DROP CONSTRAINT payout_requests_net_lines;
ALTER TABLE "payout_requests" ADD CONSTRAINT payout_requests_amounts CHECK (
  gross_millimes > 0 AND commission_millimes >= 0 AND net_millimes > 0
  AND net_millimes = gross_millimes - commission_millimes - vat_millimes - withholding_millimes
    - stamp_duty_millimes - transfer_fee_millimes
);
