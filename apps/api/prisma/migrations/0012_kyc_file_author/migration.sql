-- Four eyes (decision of 2026-10-21, securite B5-S02-a): the administrator who opened a KYC file
-- (by creating the merchant or the company) never decides it.
ALTER TABLE kyc_files ADD COLUMN created_by uuid;
