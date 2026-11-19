'use client';

import { useSearchParams } from 'next/navigation';
import { useCallback, useEffect, useMemo, useRef } from 'react';
import { usePathname, useRouter } from '@/i18n/navigation';

/**
 * Filters of a list page kept in the URL (W-SUP: `?q=&statut=&type=…`), so that a search is
 * shared, survives a reload and comes back with the browser history. `params` maps each filter to
 * its French query name; an empty value is removed from the URL.
 */
export function useUrlFilters<Key extends string>(
  params: Readonly<Record<Key, string>>,
): [Record<Key, string>, (next: Partial<Record<Key, string>>) => void] {
  const searchParams = useSearchParams();
  const router = useRouter();
  const pathname = usePathname();
  const keys = Object.keys(params) as Key[];
  const query = searchParams.toString();

  const values = useMemo(() => {
    const read = new URLSearchParams(query);
    return Object.fromEntries(
      keys.map((key) => [key, read.get(params[key])?.slice(0, 100) ?? '']),
    ) as Record<Key, string>;
    // `params` is a constant of the page.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query]);

  const update = useCallback(
    (next: Partial<Record<Key, string>>) => {
      const write = new URLSearchParams(query);
      for (const key of Object.keys(next) as Key[]) {
        const value = next[key]?.trim() ?? '';
        if (value === '') write.delete(params[key]);
        else write.set(params[key], value);
      }
      const search = write.toString();
      router.replace(search === '' ? pathname : `${pathname}?${search}`, { scroll: false });
    },
    // `params` is a constant of the page.
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [query, pathname, router],
  );

  return [values, update];
}

/** Names of the common filters in the URL (French, as the pages). */
export const LIST_PARAMS = { q: 'q', status: 'statut', creditType: 'type' } as const;

/**
 * Typed filters of a page kept in the URL: `defaults` gives the empty value of each filter,
 * `names` its French name in the URL. Setting the filters replaces them all in the URL.
 */
export function useUrlFilterState<T extends Record<keyof T, string>>(
  defaults: T,
  names: Readonly<Record<keyof T & string, string>>,
): [T, (next: T) => void] {
  const [values, update] = useUrlFilters(names);
  const filters = useMemo(() => ({ ...defaults, ...values }), [defaults, values]);
  const set = useCallback(
    (next: T) => {
      update(next);
    },
    [update],
  );
  return [filters, set];
}

/** Runs `apply` once `value` has not changed for `delay` ms (search typed in a list). */
export function useDebounced(value: string, current: string, apply: (value: string) => void) {
  const latest = useRef(apply);
  useEffect(() => {
    latest.current = apply;
  }, [apply]);
  useEffect(() => {
    if (value.trim() === current) return;
    const timer = setTimeout(() => {
      latest.current(value.trim());
    }, 300);
    return () => {
      clearTimeout(timer);
    };
  }, [value, current]);
}
