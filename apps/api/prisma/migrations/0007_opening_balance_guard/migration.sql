-- Opening balances (decision of 2026-10-14): only the development seed may write them. The
-- database refuses them (and their reversal) unless ALL of these hold:
--   - the writer is not the application role (the API can never create money this way);
--   - the transaction declared itself as the seed: set_config('app.seed', 'on', true);
--   - the database is not a production one. Production databases are marked once, when they are
--     provisioned: ALTER DATABASE <name> SET app.environment = 'production';
CREATE FUNCTION ledger_opening_guard() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF current_user = 'flexipay_app'
     OR coalesce(current_setting('app.seed', true), '') <> 'on'
     OR coalesce(current_setting('app.environment', true), '') = 'production' THEN
    RAISE EXCEPTION 'OPENING_BALANCE entries are reserved to the development seed'
      USING ERRCODE = '42501';
  END IF;
  RETURN NEW;
END $$;

CREATE TRIGGER ledger_transactions_opening_guard BEFORE INSERT ON ledger_transactions
  FOR EACH ROW WHEN (NEW.type IN ('OPENING_BALANCE', 'REVERSAL_OPENING_BALANCE'))
  EXECUTE FUNCTION ledger_opening_guard();
