-- Decisions of 2026-10-14:
-- - commission: the shop's own profile when it has one, otherwise the rate of the credit type;
-- - expired credits: destination set by the administrator (FlexiPay revenue or back to the company).
ALTER TABLE merchants ALTER COLUMN commission_profile_id DROP NOT NULL;

CREATE TYPE "ExpiredCreditsDestination" AS ENUM ('PLATFORM_REVENUE', 'COMPANY_RETURN');
ALTER TABLE platform_settings
  ADD COLUMN expired_credits_destination "ExpiredCreditsDestination" NOT NULL DEFAULT 'PLATFORM_REVENUE';
