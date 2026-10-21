-- Personal data encrypted at rest (securite B5-S11): IBAN and phone columns hold AES-256-GCM
-- values (longer than the clear ones); a user's phone is found and kept unique by its HMAC index.
-- Rows already in clear are encrypted by `pnpm --filter @flexipay/api db:encrypt-pii`.
ALTER TABLE merchants ALTER COLUMN iban TYPE text, ALTER COLUMN phone TYPE text;
ALTER TABLE payout_requests ALTER COLUMN iban TYPE text;
ALTER TABLE companies ALTER COLUMN phone TYPE text;
ALTER TABLE employees ALTER COLUMN phone TYPE text;
ALTER TABLE contact_messages ALTER COLUMN phone TYPE text;
ALTER TABLE users ALTER COLUMN phone TYPE text, ADD COLUMN phone_hash char(64);
DROP INDEX users_phone_key;
CREATE UNIQUE INDEX users_phone_hash_key ON users (phone_hash);
