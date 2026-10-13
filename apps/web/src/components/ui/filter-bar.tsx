'use client';

import { Search } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { Button } from './button';
import { CreditTypeSelect, type CreditType } from './credit-type';
import { SelectField, TextField } from './field';

export interface Filters {
  q: string;
  status: string;
  creditType: CreditType | '';
}

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

/** Search, status and credit type filters, applied explicitly (no request at every keystroke). */
export function FilterBar({
  searchLabel,
  statusLabel,
  statusOptions,
  statusPlaceholder,
  withCreditType = false,
  onApply,
}: FilterBarProps) {
  const t = useTranslations('ui.filters');
  const [q, setQ] = useState('');
  const [status, setStatus] = useState('');
  const [creditType, setCreditType] = useState<CreditType | ''>('');

  function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    onApply({ q: q.trim(), status, creditType });
  }

  return (
    <form
      onSubmit={onSubmit}
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
          }}
        />
      ) : null}
      {withCreditType ? (
        <CreditTypeSelect
          label={t('creditType')}
          placeholder={t('allTypes')}
          value={creditType}
          onChange={setCreditType}
        />
      ) : null}
      <div className="flex gap-2">
        <Button
          type="submit"
          variant="secondary"
          icon={<Search aria-hidden="true" className="size-icon-sm" />}
        >
          {t('apply')}
        </Button>
        <Button
          variant="ghost"
          onClick={() => {
            setQ('');
            setStatus('');
            setCreditType('');
            onApply({ q: '', status: '', creditType: '' });
          }}
        >
          {t('reset')}
        </Button>
      </div>
    </form>
  );
}
