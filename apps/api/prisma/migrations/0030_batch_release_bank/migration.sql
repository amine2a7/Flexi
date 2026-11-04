-- Settlement batches (task 9, decisions of 2026-11-02/03): a batch leaves only once released by
-- Finance in four eyes (RELEASED), then its order goes to the bank at its date (SENT: the debt of
-- the merchant is deducted then) and the return of the bank pays it (PAID). Simulated bank.
ALTER TYPE "SettlementStatus" ADD VALUE 'RELEASED' BEFORE 'PAID';
ALTER TYPE "SettlementStatus" ADD VALUE 'SENT' BEFORE 'PAID';
ALTER TYPE "ApprovalType" ADD VALUE 'BATCH_RELEASE';
ALTER TABLE "settlement_batches"
  ADD COLUMN "released_at" TIMESTAMPTZ(3),
  ADD COLUMN "sent_at" TIMESTAMPTZ(3),
  ADD COLUMN "bank_reference" VARCHAR(40);
