-- Ledger-auditor review of 2026-10-15.
-- C1/C3: safety net in the database, whatever the application does: an order is validated once,
-- a payout is requested once and executed once (their reference is unique per type; a reversal
-- carries reverses_id and is not concerned).
CREATE UNIQUE INDEX ledger_transactions_once_per_reference ON ledger_transactions (type, reference)
  WHERE type IN ('ORDER_VALIDATED', 'PAYOUT_REQUESTED', 'PAYOUT_EXECUTED') AND reverses_id IS NULL;

-- C13: opening balances only in a database explicitly marked as a development one (db:setup does
-- ALTER DATABASE ... SET app.environment = 'development'); an unmarked database refuses them.
CREATE OR REPLACE FUNCTION ledger_opening_guard() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF current_user = 'flexipay_app'
     OR coalesce(current_setting('app.seed', true), '') <> 'on'
     OR coalesce(current_setting('app.environment', true), '') <> 'development' THEN
    RAISE EXCEPTION 'OPENING_BALANCE entries are reserved to the development seed'
      USING ERRCODE = '42501';
  END IF;
  RETURN NEW;
END $$;
