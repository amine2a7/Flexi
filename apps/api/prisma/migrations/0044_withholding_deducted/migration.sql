-- Corrections after the demo (2026-11-13): the withholding is DEDUCTED from the total of an order
-- (rate of the legal form x frais TTC, above 1 000 TND), never added. NOT VALID: the new rule binds
-- every new row; the orders and quotes already recorded keep the rule they were created with.
ALTER TABLE "credit_orders" DROP CONSTRAINT credit_orders_amounts;
ALTER TABLE "credit_orders" ADD CONSTRAINT credit_orders_amounts CHECK (
  amount_millimes > 0 AND fees_millimes >= 0
  AND total_millimes = amount_millimes + fees_millimes + vat_millimes - withholding_millimes
    + stamp_duty_millimes + transfer_fee_millimes
) NOT VALID;
ALTER TABLE "order_quotes" DROP CONSTRAINT order_quotes_amounts;
ALTER TABLE "order_quotes" ADD CONSTRAINT order_quotes_amounts CHECK (
  amount_millimes > 0 AND fees_millimes >= 0
  AND total_millimes = amount_millimes + fees_millimes + vat_millimes - withholding_millimes
    + stamp_duty_millimes + transfer_fee_millimes
) NOT VALID;
