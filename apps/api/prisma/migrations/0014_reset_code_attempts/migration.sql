-- Reset code by SMS (securite B5-S06): at most 5 attempts per code, reserved atomically before
-- the check (simultaneous requests included); beyond that the code is dead.
ALTER TABLE password_reset_tokens
  ADD COLUMN kind varchar(4) NOT NULL DEFAULT 'LINK',
  ADD COLUMN attempts integer NOT NULL DEFAULT 0;
ALTER TABLE password_reset_tokens
  ADD CONSTRAINT password_reset_tokens_kind CHECK (kind IN ('LINK', 'OTP')),
  ADD CONSTRAINT password_reset_tokens_attempts CHECK (attempts BETWEEN 0 AND 5);
