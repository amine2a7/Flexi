-- Payment recorded by Finance (processus 6, bug 6): the transfer is made from FlexiPay's bank
-- outside the platform, then Finance enters its bank reference, date and amount: the payout (or
-- every payout of the batch) is paid. An amount other than the net needs a reason.
ALTER TABLE "payout_requests"
  ADD COLUMN "bank_reference" VARCHAR(40),
  ADD COLUMN "paid_on" DATE,
  ADD COLUMN "paid_amount_millimes" BIGINT,
  ADD COLUMN "payment_note" VARCHAR(500),
  ADD CONSTRAINT "payout_requests_paid_amount" CHECK ("paid_amount_millimes" IS NULL OR "paid_amount_millimes" >= 0);
ALTER TABLE "settlement_batches" ADD COLUMN "paid_on" DATE;
