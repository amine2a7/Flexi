'use client';

import { useCallback, useEffect, useState, type DependencyList } from 'react';

export type QueryState<T> =
  | { readonly status: 'loading' }
  | { readonly status: 'success'; readonly data: T }
  | { readonly status: 'error'; readonly error: unknown };

interface FetchResult<T> {
  readonly data?: T;
  readonly error?: unknown;
}

/**
 * Loads data from the API on mount and whenever `deps` change. Returns the state and a `reload`
 * function. Network failures are reported as an error state, never thrown.
 */
export function useApiQuery<T>(
  load: () => Promise<FetchResult<T>>,
  deps: DependencyList,
): QueryState<T> & { readonly reload: () => void } {
  const [state, setState] = useState<QueryState<T>>({ status: 'loading' });
  const [attempt, setAttempt] = useState(0);
  const reload = useCallback(() => {
    setAttempt((value) => value + 1);
  }, []);

  useEffect(() => {
    let active = true;
    // Reset to the loading state when the request changes (data fetching, not derived state).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setState({ status: 'loading' });
    load()
      .then((result) => {
        if (!active) return;
        if (result.data !== undefined) setState({ status: 'success', data: result.data });
        else setState({ status: 'error', error: result.error });
      })
      .catch((error: unknown) => {
        if (active) setState({ status: 'error', error });
      });
    return () => {
      active = false;
    };
    // The caller owns the dependency list of `load` (same contract as useEffect).
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [...deps, attempt]);

  return { ...state, reload };
}
