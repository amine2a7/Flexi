-- Decisions of 2026-11-04. Both bounds of a tranche are included (a single amount is a valid
-- tranche). Every company and every shop has a grid: no fallback rate, a missing grid refuses the
-- operation and raises an alert. The grid of a shop is never readable by a beneficiary: the rate
-- of a payment is computed by the server under its internal service role.
ALTER TABLE "commission_tiers" DROP CONSTRAINT "commission_tiers_bounds";
ALTER TABLE "commission_tiers" ADD CONSTRAINT "commission_tiers_bounds" CHECK (
  "min_millimes" IS NULL OR "max_millimes" IS NULL OR "min_millimes" <= "max_millimes"
);

ALTER TYPE "FraudAlertKind" ADD VALUE 'COMMISSION_GRID_MISSING';

-- Shops without a former profile: a one-line grid at the rate of their first accepted credit
-- type; companies without a grid: the order fee rate of the settings.
INSERT INTO "commission_grids" ("id", "merchant_id")
SELECT gen_random_uuid(), m."id" FROM "merchants" m
WHERE NOT EXISTS (SELECT 1 FROM "commission_grids" g WHERE g."merchant_id" = m."id");
INSERT INTO "commission_grids" ("id", "company_id")
SELECT gen_random_uuid(), c."id" FROM "companies" c
WHERE NOT EXISTS (SELECT 1 FROM "commission_grids" g WHERE g."company_id" = c."id");
INSERT INTO "commission_tiers" ("grid_id", "position", "rate_bps")
SELECT g."id", 0, coalesce(t."commission_rate_bps", 0)
FROM "commission_grids" g
JOIN "merchants" m ON m."id" = g."merchant_id"
LEFT JOIN "credit_type_settings" t ON t."credit_type" = m."accepted_credit_types"[1]
WHERE NOT EXISTS (SELECT 1 FROM "commission_tiers" x WHERE x."grid_id" = g."id");
INSERT INTO "commission_tiers" ("grid_id", "position", "rate_bps")
SELECT g."id", 0, coalesce((SELECT s."order_fee_rate_bps" FROM "platform_settings" s LIMIT 1), 0)
FROM "commission_grids" g
WHERE g."company_id" IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM "commission_tiers" x WHERE x."grid_id" = g."id");
