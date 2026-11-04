-- Commission grids replace the commission profiles (decision of 2026-11-03). Each company (rate on
-- each order amount) and each merchant (rate on each payout amount) has a grid: tranches
-- [min, max) and one default line without bounds. A change inserts a new version (four eyes);
-- versions are never updated nor deleted (history). VAT and stamp duty become settings.
ALTER TYPE "ApprovalType" ADD VALUE 'COMMISSION_GRID_CHANGE';

CREATE TABLE "commission_grids" (
  "id" UUID PRIMARY KEY,
  "company_id" UUID REFERENCES "companies" ("id") ON DELETE RESTRICT,
  "merchant_id" UUID REFERENCES "merchants" ("id") ON DELETE RESTRICT,
  -- Approved request that installed this version (null: creation or migration of a profile).
  "approval_id" UUID REFERENCES "approvals" ("id") ON DELETE RESTRICT,
  "created_by" UUID,
  "effective_from" TIMESTAMPTZ(3) NOT NULL DEFAULT now(),
  CONSTRAINT "commission_grids_one_owner" CHECK (("company_id" IS NULL) <> ("merchant_id" IS NULL))
);
CREATE INDEX "commission_grids_company_idx" ON "commission_grids" ("company_id", "effective_from");
CREATE INDEX "commission_grids_merchant_idx" ON "commission_grids" ("merchant_id", "effective_from");

CREATE TABLE "commission_tiers" (
  "grid_id" UUID NOT NULL REFERENCES "commission_grids" ("id") ON DELETE RESTRICT,
  "position" INTEGER NOT NULL CHECK ("position" >= 0),
  "rate_bps" INTEGER NOT NULL CHECK ("rate_bps" BETWEEN 0 AND 10000),
  "min_millimes" BIGINT CHECK ("min_millimes" >= 0),
  "max_millimes" BIGINT CHECK ("max_millimes" >= 0),
  PRIMARY KEY ("grid_id", "position"),
  CONSTRAINT "commission_tiers_bounds" CHECK (
    "min_millimes" IS NULL OR "max_millimes" IS NULL OR "min_millimes" < "max_millimes"
  )
);
-- One default line per grid (overlaps are refused by the API, shared schema).
CREATE UNIQUE INDEX "commission_tiers_one_default" ON "commission_tiers" ("grid_id")
  WHERE "min_millimes" IS NULL AND "max_millimes" IS NULL;

ALTER TABLE "commission_grids" ENABLE ROW LEVEL SECURITY;
CREATE POLICY commission_grids_read ON "commission_grids" FOR SELECT USING (
  app_is_platform()
  OR (app_role() = 'COMPANY' AND "company_id" = app_uuid('company_id'))
  OR (app_role() = 'MERCHANT' AND "merchant_id" = app_uuid('merchant_id'))
);
CREATE POLICY commission_grids_insert ON "commission_grids" FOR INSERT WITH CHECK (app_is_platform());
ALTER TABLE "commission_tiers" ENABLE ROW LEVEL SECURITY;
-- A line is visible with its grid (the grid policy applies inside the subquery).
CREATE POLICY commission_tiers_read ON "commission_tiers" FOR SELECT USING (
  EXISTS (SELECT 1 FROM "commission_grids" g WHERE g."id" = "grid_id")
);
CREATE POLICY commission_tiers_insert ON "commission_tiers" FOR INSERT WITH CHECK (app_is_platform());
GRANT SELECT, INSERT ON "commission_grids", "commission_tiers" TO flexipay_app;

-- Migration of the data: each shop with a profile gets a one-line grid at the profile rate; each
-- company gets a one-line grid at the order fee rate. A shop without a profile keeps the rate of
-- each credit type until the administrator gives it a grid (à confirmer par Amine).
INSERT INTO "commission_grids" ("id", "merchant_id", "effective_from")
SELECT gen_random_uuid(), m."id", p."updated_at"
FROM "merchants" m JOIN "commission_profiles" p ON p."id" = m."commission_profile_id";
INSERT INTO "commission_tiers" ("grid_id", "position", "rate_bps")
SELECT g."id", 0, p."rate_bps"
FROM "commission_grids" g
JOIN "merchants" m ON m."id" = g."merchant_id"
JOIN "commission_profiles" p ON p."id" = m."commission_profile_id";
INSERT INTO "commission_grids" ("id", "company_id", "effective_from")
SELECT gen_random_uuid(), c."id", c."created_at"
FROM "companies" c CROSS JOIN "platform_settings" s;
INSERT INTO "commission_tiers" ("grid_id", "position", "rate_bps")
SELECT g."id", 0, s."order_fee_rate_bps"
FROM "commission_grids" g CROSS JOIN "platform_settings" s
WHERE g."company_id" IS NOT NULL;

-- Pending changes of a profile can no longer be applied.
UPDATE "approvals"
SET "status" = 'REJECTED', "decided_at" = now(),
    "reject_reason" = 'Profils de commission remplacés par les grilles (2026-11-03).'
WHERE "type" = 'COMMISSION_RATE_CHANGE' AND "status" = 'PENDING';

ALTER TABLE "merchants" DROP COLUMN "commission_profile_id";
DROP TABLE "commission_profiles";

-- VAT on the commission and stamp duty (decision of 2026-11-03), set by the super-admin.
ALTER TABLE "platform_settings"
  ADD COLUMN "vat_rate_bps" INTEGER NOT NULL DEFAULT 1900 CHECK ("vat_rate_bps" BETWEEN 0 AND 10000),
  ADD COLUMN "stamp_duty_millimes" BIGINT NOT NULL DEFAULT 1000 CHECK ("stamp_duty_millimes" >= 0);
UPDATE "platform_settings" SET "payout_minimum_millimes" = 50000;
