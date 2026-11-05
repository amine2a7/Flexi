-- Every business value comes from the settings of the super-admin (request of 2026-11-05): the
-- FlexiPay bank account (was the server configuration), the four-eyes threshold of the orders,
-- the validity of a quote, of an invitation and of the sign-in code (OTP), the PIN lock tiers,
-- the cancellation window of a payment and the settlement cycle. Defaults = the former constants
-- (invitation: 7 days asked by the user, was 72 h).
ALTER TABLE platform_settings
  ADD COLUMN funding_bank_name varchar(120) NOT NULL DEFAULT 'Banque Internationale Arabe de Tunisie (BIAT)',
  ADD COLUMN funding_holder varchar(120) NOT NULL DEFAULT 'FlexiPay SA',
  ADD COLUMN funding_rib varchar(20) NOT NULL DEFAULT '08006000671234567891',
  ADD COLUMN funding_iban varchar(24) NOT NULL DEFAULT 'TN5908006000671234567891',
  ADD COLUMN second_validation_threshold_millimes bigint NOT NULL DEFAULT 10000000,
  ADD COLUMN quote_validity_days integer NOT NULL DEFAULT 7,
  ADD COLUMN invitation_validity_days integer NOT NULL DEFAULT 7,
  ADD COLUMN otp_validity_minutes integer NOT NULL DEFAULT 5,
  ADD COLUMN pin_lock_minutes integer[] NOT NULL DEFAULT '{15,30,60}',
  ADD COLUMN payment_cancel_hours integer NOT NULL DEFAULT 24,
  ADD COLUMN settlement_delay_days integer NOT NULL DEFAULT 2;

ALTER TABLE platform_settings
  ADD CONSTRAINT platform_settings_funding_rib_check CHECK (funding_rib ~ '^[0-9]{20}$'),
  ADD CONSTRAINT platform_settings_funding_iban_check CHECK (funding_iban ~ '^TN[0-9]{22}$'),
  ADD CONSTRAINT platform_settings_threshold_check CHECK (second_validation_threshold_millimes > 0),
  ADD CONSTRAINT platform_settings_quote_days_check CHECK (quote_validity_days BETWEEN 1 AND 90),
  ADD CONSTRAINT platform_settings_invitation_days_check CHECK (invitation_validity_days BETWEEN 1 AND 30),
  ADD CONSTRAINT platform_settings_otp_minutes_check CHECK (otp_validity_minutes BETWEEN 1 AND 30),
  ADD CONSTRAINT platform_settings_pin_lock_check CHECK (
    cardinality(pin_lock_minutes) BETWEEN 1 AND 5 AND 0 < ALL (pin_lock_minutes)),
  ADD CONSTRAINT platform_settings_cancel_hours_check CHECK (payment_cancel_hours BETWEEN 0 AND 72),
  ADD CONSTRAINT platform_settings_settlement_days_check CHECK (settlement_delay_days BETWEEN 1 AND 10);

-- A credit order keeps the rules of its creation (like its rates): the end of its quote and
-- whether it needs a second validation. Existing orders: 7 days, the former 10 000 TND threshold.
ALTER TABLE credit_orders
  ADD COLUMN quote_expires_at timestamptz(3),
  ADD COLUMN second_validation_required boolean NOT NULL DEFAULT false;
UPDATE credit_orders
   SET quote_expires_at = created_at + interval '7 days',
       second_validation_required = amount_millimes > 10000000;
-- The API always sets it from the settings; the default only serves direct inserts (tests).
ALTER TABLE credit_orders ALTER COLUMN quote_expires_at SET NOT NULL,
  ALTER COLUMN quote_expires_at SET DEFAULT (now() + interval '7 days');
