'use client';

import { RotateCcw } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useRef, useState } from 'react';
import { LIST_PARAMS, useUrlFilters } from '@/lib/ui/use-url-filters';
import { Button } from './button';
import { CreditTypeSelect, type CreditType } from './credit-type';
import { SelectField, TextField } from './field';

export interface Filters {
  q: string;
  status: string;
  creditType: CreditType | '';
}

/** Delay after the last key before the search runs (W-SUP: 300 ms). */
export const SEARCH_DELAY_MS = 300;

interface FilterBarProps {
  readonly searchLabel?: string;
  readonly statusLabel?: string;
  readonly statusOptions?: readonly { value: string; label: string }[];
  /** First option of the status select (default: all statuses). */
  readonly statusPlaceholder?: string;
  /** Adds the credit type filter (every list with amounts of credit). */
  readonly withCreditType?: boolean;
  readonly onApply: (filters: Filters) => void;
}

const CREDIT_TYPES: readonly string[] = ['RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX'];

function asFilters(values: { q: string; status: string; creditType: string }): Filters {
  return {
    q: values.q.trim(),
    status: values.status,
    creditType: CREDIT_TYPES.includes(values.creditType) ? (values.creditType as CreditType) : '',
  };
}

/**
 * Search, status and credit type filters (W-SUP): the search runs while typing (300 ms after the
 * last key), a select applies at once, and everything is kept in the URL (`?q=&statut=&type=`):
 * a page opened from a shared link, or reloaded, shows the same list.
 */
export function FilterBar({
  searchLabel,
  statusLabel,
  statusOptions,
  statusPlaceholder,
  withCreditType = false,
  onApply,
}: FilterBarProps) {
  const t = useTranslations('ui.filters');
  const [url, setUrl] = useUrlFilters(LIST_PARAMS);
  const [q, setQ] = useState(url.q);
  const [status, setStatus] = useState(url.status);
  const [creditType, setCreditType] = useState<CreditType | ''>(asFilters(url).creditType);
  const apply = useRef(onApply);
  useEffect(() => {
    apply.current = onApply;
  }, [onApply]);

  // Filters opened from the URL (shared link, reload, back button).
  const fromUrl = JSON.stringify(asFilters(url));
  const applied = useRef<string | undefined>(undefined);
  useEffect(() => {
    if (applied.current === fromUrl) return;
    const first = applied.current === undefined;
    applied.current = fromUrl;
    const filters = JSON.parse(fromUrl) as Filters;
    if (first && filters.q === '' && filters.status === '' && filters.creditType === '') return;
    apply.current(filters);
  }, [fromUrl]);

  // The text typed reaches the URL 300 ms after the last key.
  useEffect(() => {
    if (q.trim() === url.q) return;
    const timer = setTimeout(() => {
      setUrl({ q: q.trim() });
    }, SEARCH_DELAY_MS);
    return () => {
      clearTimeout(timer);
    };
  }, [q, url.q, setUrl]);

  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        setUrl({ q: q.trim() });
      }}
      role="search"
      className="mb-4 grid items-end gap-3 sm:grid-cols-2 lg:grid-cols-4"
    >
      {searchLabel !== undefined ? (
        <TextField
          label={searchLabel}
          type="search"
          value={q}
          onChange={(event) => {
            setQ(event.target.value);
          }}
        />
      ) : null}
      {statusOptions !== undefined && statusLabel !== undefined ? (
        <SelectField
          label={statusLabel}
          options={statusOptions}
          placeholder={statusPlaceholder ?? t('allStatuses')}
          value={status}
          onChange={(event) => {
            setStatus(event.target.value);
            setUrl({ status: event.target.value });
          }}
        />
      ) : null}
      {withCreditType ? (
        <CreditTypeSelect
          label={t('creditType')}
          placeholder={t('allTypes')}
          value={creditType}
          onChange={(value) => {
            setCreditType(value);
            setUrl({ creditType: value });
          }}
        />
      ) : null}
      <div className="flex gap-2">
        <Button
          variant="ghost"
          icon={<RotateCcw aria-hidden="true" className="size-icon-sm" />}
          onClick={() => {
            setQ('');
            setStatus('');
            setCreditType('');
            setUrl({ q: '', status: '', creditType: '' });
          }}
        >
          {t('reset')}
        </Button>
      </div>
    </form>
  );
}
