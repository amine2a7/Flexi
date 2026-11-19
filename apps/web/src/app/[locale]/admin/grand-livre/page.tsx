'use client';

import type { Schemas } from '@flexipay/api-client';
import { Search } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { useUrlFilterState } from '@/lib/ui/use-url-filters';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextField } from '@/components/ui/field';
import { PageHeader } from '@/components/ui/layout-blocks';
import { PdfDownloadButton } from '@/components/ui/pdf-download';

type Entry = Schemas['LedgerEntry'];
type ClientType = 'COMPANY' | 'MERCHANT';

interface LedgerFilters {
  clientType: ClientType | '';
  clientId: string;
  transactionType: string;
  from: string;
  to: string;
}

const EMPTY: LedgerFilters = {
  clientType: '',
  clientId: '',
  transactionType: '',
  from: '',
  to: '',
};

/** Day typed in the date field (local) to the instant the API expects (`createdTo` excluded). */
function instant(day: string, next = false): string | undefined {
  if (day === '') return undefined;
  const date = new Date(`${day}T00:00:00`);
  if (next) date.setDate(date.getDate() + 1);
  return date.toISOString();
}

const URL_NAMES = {
  clientType: 'client',
  clientId: 'id',
  transactionType: 'type',
  from: 'du',
  to: 'au',
} as const;

/** Query of the list and of the CSV export (same filters). */
function ledgerQuery(filters: LedgerFilters) {
  const from = instant(filters.from);
  const to = instant(filters.to, true);
  return {
    ...(filters.clientType === '' || filters.clientId === ''
      ? {}
      : { clientType: filters.clientType, clientId: filters.clientId }),
    ...(filters.transactionType === '' ? {} : { transactionType: filters.transactionType }),
    ...(from === undefined ? {} : { createdFrom: from }),
    ...(to === undefined ? {} : { createdTo: to }),
  };
}

/**
 * General ledger (W-FIN): every double-entry line, read only, for Finance and the super-admin.
 * Filters: client (a company with its employees, or a merchant), period, transaction type; the
 * same selection is exported as CSV.
 */
export default function LedgerPage() {
  const t = useTranslations('admin.ledger');
  const locale = useLocale();
  // W-SUP: the filters are kept in the URL (shared links, reload, back button).
  const [filters, setFilters] = useUrlFilterState(EMPTY, URL_NAMES);
  const [draft, setDraft] = useState<LedgerFilters>(filters);
  const types = useApiQuery(() => getApi().GET('/v1/admin/ledger-entries/types'), []);
  const clients = useApiQuery(async () => {
    if (draft.clientType === 'COMPANY') {
      const page = await getApi().GET('/v1/admin/companies', { params: { query: { limit: 100 } } });
      return page.data === undefined
        ? { error: page.error }
        : { data: page.data.data.map((row) => ({ value: row.id, label: row.name })) };
    }
    if (draft.clientType === 'MERCHANT') {
      const page = await getApi().GET('/v1/admin/merchants', { params: { query: { limit: 100 } } });
      return page.data === undefined
        ? { error: page.error }
        : { data: page.data.data.map((row) => ({ value: row.id, label: row.name })) };
    }
    return { data: [] as { value: string; label: string }[] };
  }, [draft.clientType]);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/ledger-entries', {
        params: { query: { cursor, withCount, ...ledgerQuery(filters) } },
      }),
    [filters],
  );
  const set = (field: keyof LedgerFilters) => (value: string) => {
    setDraft((current) => ({
      ...current,
      [field]: value,
      ...(field === 'clientType' ? { clientId: '' } : {}),
    }));
  };

  function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setFilters(draft);
  }

  const columns: Column<Entry>[] = [
    {
      key: 'date',
      header: t('date'),
      cell: (row) => (
        <span className="text-text-muted">{formatDateTime(row.occurredAt, locale)}</span>
      ),
      sortValue: (row) => row.occurredAt,
    },
    {
      key: 'reference',
      header: t('reference'),
      card: 'title',
      cell: (row) => (
        <span className="flex flex-col">
          <span dir="ltr" className="font-label text-text">
            {row.reference}
          </span>
          <span className="text-caption text-text-muted">{row.transactionType}</span>
        </span>
      ),
      sortValue: (row) => row.reference,
    },
    {
      key: 'account',
      header: t('account'),
      cell: (row) => (
        <span className="flex flex-col">
          <span dir="auto">{row.ownerName ?? t(`owner.${row.ownerType}`)}</span>
          <span dir="ltr" className="break-all text-caption text-text-muted">
            {row.accountCode}
          </span>
        </span>
      ),
    },
    {
      key: 'type',
      header: t('creditType'),
      cell: (row) => (row.creditType === null ? '—' : <CreditTypeBadge type={row.creditType} />),
    },
    {
      key: 'debit',
      header: t('debit'),
      align: 'end',
      cell: (row) => (row.direction === 'DEBIT' ? <Amount millimes={row.amountMillimes} /> : ''),
    },
    {
      key: 'credit',
      header: t('credit'),
      align: 'end',
      cell: (row) => (row.direction === 'CREDIT' ? <Amount millimes={row.amountMillimes} /> : ''),
    },
    {
      key: 'balance',
      header: t('balanceAfter'),
      align: 'end',
      cell: (row) => <Amount millimes={row.balanceAfterMillimes} />,
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <PdfDownloadButton
            label={t('export')}
            fileName={`grand-livre-${new Date().toISOString().slice(0, 10)}.csv`}
            load={() =>
              getApi().GET('/v1/admin/ledger-entries/export', {
                params: { query: ledgerQuery(filters) },
                parseAs: 'blob',
              })
            }
          />
        }
      />
      <Card>
        <form
          onSubmit={onSubmit}
          role="search"
          className="mb-4 grid items-end gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6"
        >
          <SelectField
            label={t('clientType')}
            placeholder={t('allClients')}
            options={[
              { value: 'COMPANY', label: t('owner.COMPANY') },
              { value: 'MERCHANT', label: t('owner.MERCHANT') },
            ]}
            value={draft.clientType}
            onChange={(event) => {
              set('clientType')(event.target.value);
            }}
          />
          <SelectField
            label={t('client')}
            placeholder={t('pickClient')}
            disabled={draft.clientType === ''}
            options={clients.status === 'success' ? clients.data : []}
            value={draft.clientId}
            onChange={(event) => {
              set('clientId')(event.target.value);
            }}
          />
          <SelectField
            label={t('transactionType')}
            placeholder={t('allTypes')}
            options={
              types.status === 'success'
                ? types.data.data.map((value) => ({ value, label: value }))
                : []
            }
            value={draft.transactionType}
            onChange={(event) => {
              set('transactionType')(event.target.value);
            }}
          />
          <TextField
            label={t('from')}
            type="date"
            value={draft.from}
            onChange={(event) => {
              set('from')(event.target.value);
            }}
          />
          <TextField
            label={t('to')}
            type="date"
            value={draft.to}
            onChange={(event) => {
              set('to')(event.target.value);
            }}
          />
          <Button type="submit" icon={<Search aria-hidden="true" className="size-icon-sm" />}>
            {t('apply')}
          </Button>
        </form>
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('empty') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}
