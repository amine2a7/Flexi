-- Fix of 0002: the balance check read NEW.transaction_id, which ledger_transactions does not have.
-- The transaction id is now taken from the row as JSON, valid for both tables.
CREATE OR REPLACE FUNCTION ledger_check_balanced() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
  tx uuid := CASE WHEN TG_TABLE_NAME = 'ledger_transactions'
                  THEN (to_jsonb(NEW) ->> 'id')::uuid
                  ELSE (to_jsonb(NEW) ->> 'transaction_id')::uuid END;
  debits bigint;
  credits bigint;
BEGIN
  SELECT coalesce(sum(amount_millimes) FILTER (WHERE direction = 'D'), 0),
         coalesce(sum(amount_millimes) FILTER (WHERE direction = 'C'), 0)
    INTO debits, credits
    FROM ledger_entries WHERE transaction_id = tx;
  IF debits = 0 OR debits <> credits THEN
    RAISE EXCEPTION 'unbalanced ledger transaction %', tx USING ERRCODE = '23514';
  END IF;
  RETURN NULL;
END $$;
