'use client';

import { Search } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { Button } from './button';
import { SelectField, TextField } from './field';

interface FilterBarProps {
  readonly searchLabel?: string;
  readonly statusLabel?: string;
  readonly statusOptions?: readonly { value: string; label: string }[];
  readonly onApply: (filters: { q: string; status: string }) => void;
}

/** Search and status filter, applied explicitly (no request at every keystroke). */
export function FilterBar({ searchLabel, statusLabel, statusOptions, onApply }: FilterBarProps) {
  const t = useTranslations('ui.filters');
  const [q, setQ] = useState('');
  const [status, setStatus] = useState('');

  function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    onApply({ q: q.trim(), status });
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
          onChange={(event) => { setQ(event.target.value); }}
        />
      ) : null}
      {statusOptions !== undefined && statusLabel !== undefined ? (
        <SelectField
          label={statusLabel}
          options={statusOptions}
          placeholder={t('allStatuses')}
          value={status}
          onChange={(event) => { setStatus(event.target.value); }}
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
            onApply({ q: '', status: '' });
          }}
        >
          {t('reset')}
        </Button>
      </div>
    </form>
  );
}
