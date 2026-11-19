-- W-SUP-bis: review of fp_search_candidates (SECURITY DEFINER).
-- 1. search_path fixed with pg_catalog first, then the schema of the app (no object of another
--    schema, nor of pg_temp before them, can be called in its place).
-- 2. The function checks the session itself: outside the platform (ADMIN, SYSTEM) it only
--    searches the rows of the company, merchant or beneficiary of the session (app.role and
--    app.*_id set by the API in each transaction); a scope asked by the caller must be that
--    same tenant, otherwise nothing is returned. A table without a column of the tenant
--    returns nothing.
-- 3. The typed text only reaches the queries as parameters ($1..$5); the identifiers come from
--    fixed lists. Only ids and scores are returned (never a sealed or clear CIN or RIB).
CREATE OR REPLACE FUNCTION fp_search_candidates(
  tbl text, needle text, pattern text, words text, parts text[], scope_column text, scope_id uuid
) RETURNS TABLE (id uuid, score real)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = pg_catalog, public, pg_temp AS $$
DECLARE
  session_role text := public.app_role();
  tenant_column text;
  tenant_id uuid;
  scope text := '';
  found integer;
  q text := public.fp_norm(needle);
  p text := public.fp_norm(pattern);
  w text := CASE WHEN words IS NULL THEN NULL ELSE public.fp_norm(words) END;
  pieces text[] := ARRAY(SELECT public.fp_norm(x) FROM unnest(coalesce(parts, '{}')) AS x LIMIT 4);
  every_piece text := 'false';
BEGIN
  IF tbl NOT IN ('companies', 'merchants', 'users', 'employees', 'credit_orders', 'payments',
                 'payout_requests', 'invoices', 'support_tickets') THEN
    RAISE EXCEPTION 'table not searchable' USING ERRCODE = '42501';
  END IF;
  IF scope_column IS NOT NULL
     AND (scope_column NOT IN ('company_id', 'merchant_id', 'employee_id') OR scope_id IS NULL) THEN
    RAISE EXCEPTION 'scope not allowed' USING ERRCODE = '42501';
  END IF;

  IF session_role IN ('ADMIN', 'SYSTEM') THEN
    -- The platform reads every tenant; the API may narrow it to one.
    tenant_column := scope_column;
    tenant_id := scope_id;
  ELSE
    tenant_column := CASE session_role
      WHEN 'COMPANY' THEN CASE tbl
        WHEN 'companies' THEN 'id' WHEN 'users' THEN 'company_id'
        WHEN 'employees' THEN 'company_id' WHEN 'credit_orders' THEN 'company_id'
        WHEN 'payments' THEN 'company_id' WHEN 'invoices' THEN 'company_id'
        WHEN 'support_tickets' THEN 'company_id' END
      WHEN 'MERCHANT' THEN CASE tbl
        WHEN 'merchants' THEN 'id' WHEN 'users' THEN 'merchant_id'
        WHEN 'payments' THEN 'merchant_id' WHEN 'payout_requests' THEN 'merchant_id'
        WHEN 'support_tickets' THEN 'merchant_id' END
      WHEN 'EMPLOYEE' THEN CASE tbl
        WHEN 'employees' THEN 'id' WHEN 'payments' THEN 'employee_id'
        WHEN 'support_tickets' THEN 'employee_id' END
    END;
    tenant_id := CASE session_role
      WHEN 'COMPANY' THEN public.app_uuid('company_id')
      WHEN 'MERCHANT' THEN public.app_uuid('merchant_id')
      WHEN 'EMPLOYEE' THEN public.app_uuid('employee_id')
    END;
    -- No session, a role without rows in this table, or a scope of another tenant: nothing.
    IF tenant_column IS NULL OR tenant_id IS NULL THEN
      RETURN;
    END IF;
    IF scope_column IS NOT NULL AND scope_id IS DISTINCT FROM tenant_id THEN
      RETURN;
    END IF;
  END IF;

  IF tenant_column IS NOT NULL THEN
    scope := format(' AND t.%I = $4', tenant_column);
  END IF;
  IF cardinality(pieces) > 1 THEN
    SELECT string_agg(format('t.search_text LIKE $5[%s]', i), ' AND ')
      INTO every_piece FROM generate_series(1, cardinality(pieces)) AS i;
  END IF;

  -- 1. Pieces of words and word prefixes (substring, full text).
  RETURN QUERY EXECUTE format(
    'SELECT t.id, public.word_similarity($1, t.search_text) AS score FROM public.%I t
      WHERE (t.search_text LIKE $2 OR t.search_tsv @@ to_tsquery(''simple'', $3) OR (%s))%s
      ORDER BY score DESC LIMIT 200', tbl, every_piece, scope)
    USING q, p, w, tenant_id, pieces;
  GET DIAGNOSTICS found = ROW_COUNT;
  -- 2. Typos (trigrams), only when the text is not found as typed.
  IF found < 5 AND length(q) >= 3 THEN
    PERFORM set_config('pg_trgm.word_similarity_threshold', '0.55', true);
    RETURN QUERY EXECUTE format(
      'SELECT t.id, public.word_similarity($1, t.search_text) AS score FROM public.%I t
        WHERE $1 OPERATOR(public.<%%) t.search_text
          AND NOT (t.search_text LIKE $2 OR coalesce(t.search_tsv @@ to_tsquery(''simple'', $3), false)
                   OR (%s))%s
        ORDER BY score DESC LIMIT 20', tbl, every_piece, scope)
      USING q, p, w, tenant_id, pieces;
  END IF;
END $$;

-- Executed by the API only (flexipay_app, the role of fp_app): never PUBLIC, the worker nor the
-- reporting role.
REVOKE ALL ON FUNCTION fp_search_candidates(text, text, text, text, text[], text, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION fp_search_candidates(text, text, text, text, text[], text, uuid)
  TO flexipay_app;
