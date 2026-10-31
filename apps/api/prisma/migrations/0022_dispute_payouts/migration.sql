-- Disputes and payouts (decisions of 2026-10-31): a payment in a payout not yet paid puts the
-- payout on hold; an accepted dispute on a paid payment becomes a merchant debt deducted from
-- the next settlement.
ALTER TYPE "PayoutStatus" ADD VALUE IF NOT EXISTS 'ON_HOLD';
ALTER TABLE "payout_requests" ADD COLUMN "deducted_millimes" BIGINT NOT NULL DEFAULT 0
  CHECK ("deducted_millimes" >= 0);

-- What the dispute changed, to restore it when rejected.
ALTER TABLE "disputes" ALTER COLUMN "hold_transaction_id" DROP NOT NULL;
ALTER TABLE "disputes" ADD COLUMN "held_payout_id" UUID;
ALTER TABLE "disputes" ADD COLUMN "held_payout_status" VARCHAR(20);
ALTER TABLE "disputes" ADD COLUMN "payment_previous_status" VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED';
