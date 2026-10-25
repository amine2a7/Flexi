-- QY-03 b (decision of 2026-10-22): the administrator who created a merchant never approves its
-- payouts (four eyes). Nullable: merchants created before this migration have no known creator.
ALTER TABLE "merchants" ADD COLUMN "created_by" UUID;
