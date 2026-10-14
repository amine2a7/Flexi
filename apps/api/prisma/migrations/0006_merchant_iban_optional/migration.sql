-- A merchant created by an administrator has no IBAN until its KYC (bank details) is checked;
-- a payout request needs one.
ALTER TABLE merchants ALTER COLUMN iban DROP NOT NULL;
