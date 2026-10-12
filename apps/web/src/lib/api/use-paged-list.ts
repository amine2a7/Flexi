'use client';

import type { Schemas } from '@flexipay/api-client';
import { useCallback, useEffect, useState, type DependencyList } from 'react';

type PageInfo = Schemas['PageInfo'];

interface PagedResult<Row> {
  readonly data?: { readonly data: Row[]; readonly page: PageInfo };
  readonly error?: unknown;
}

/**
 * Cursor pagination (contract §7): keeps the cursors of the pages already seen to go back, asks
 * for the bounded counter only on the first page of a new filter, and reloads when `deps` change.
 */
export function usePagedList<Row>(
  load: (cursor: string | undefined, withCount: boolean) => Promise<PagedResult<Row>>,
  deps: DependencyList,
) {
  const [cursors, setCursors] = useState<(string | undefined)[]>([undefined]);
  const [rows, setRows] = useState<Row[] | undefined>(undefined);
  const [page, setPage] = useState<PageInfo | undefined>(undefined);
  const [count, setCount] = useState<PageInfo['count']>(undefined);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<unknown>(undefined);
  const [attempt, setAttempt] = useState(0);

  // A new filter starts again from the first page.
  useEffect(() => {
    // A new filter restarts from the first page.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setCursors([undefined]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);

  const pageNumber = cursors.length;
  const cursor = cursors[cursors.length - 1];

  useEffect(() => {
    let active = true;
    // Reset to the loading state when the request changes (data fetching, not derived state).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setLoading(true);
    setError(undefined);
    load(cursor, pageNumber === 1)
      .then((result) => {
        if (!active) return;
        if (result.data === undefined) {
          setError(result.error ?? new Error('empty response'));
          return;
        }
        setRows(result.data.data);
        setPage(result.data.page);
        if (pageNumber === 1) setCount(result.data.page.count);
      })
      .catch((reason: unknown) => {
        if (active) setError(reason);
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cursor, pageNumber, attempt, ...deps]);

  const next = useCallback(() => {
    const nextCursor = page?.nextCursor;
    if (nextCursor !== null && nextCursor !== undefined)
      setCursors((current) => [...current, nextCursor]);
  }, [page]);
  const previous = useCallback(() => {
    setCursors((current) => (current.length > 1 ? current.slice(0, -1) : current));
  }, []);
  const reload = useCallback(() => {
    setAttempt((value) => value + 1);
  }, []);

  return {
    rows,
    page: page === undefined ? undefined : { ...page, count },
    pageNumber,
    loading,
    error,
    next,
    previous,
    reload,
  };
}
