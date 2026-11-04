-- The amount checks of 0002 predate the VAT and the stamp duty (0026): they are replaced by the
-- checks on every line (amounts positive, total and net computed from all the lines).
ALTER TABLE "credit_orders" DROP CONSTRAINT credit_orders_amounts;
ALTER TABLE "credit_orders" ADD CONSTRAINT credit_orders_amounts CHECK (
  amount_millimes > 0 AND fees_millimes >= 0
  AND total_millimes = amount_millimes + fees_millimes + vat_millimes + stamp_duty_millimes
);
ALTER TABLE "payout_quotes" DROP CONSTRAINT payout_quotes_amounts;
ALTER TABLE "payout_quotes" ADD CONSTRAINT payout_quotes_amounts CHECK (
  gross_millimes > 0 AND commission_millimes >= 0
  AND net_millimes = gross_millimes - commission_millimes - vat_millimes - stamp_duty_millimes
);
ALTER TABLE "payout_requests" DROP CONSTRAINT payout_requests_amounts;
ALTER TABLE "payout_requests" ADD CONSTRAINT payout_requests_amounts CHECK (
  gross_millimes > 0 AND commission_millimes >= 0
  AND net_millimes = gross_millimes - commission_millimes - vat_millimes - stamp_duty_millimes
);
