'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { FilterBar, type Filters } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

type Operation = Schemas['EmployeeOperation'];
const TYPES: Schemas['EmployeeOperationType'][] = [
  'PAYMENT',
  'ALLOCATION',
  'EXPIRY',
  'FAMILY_TRANSFER',
];

/** History of the beneficiary: payments, credits received and expiries, by type of credit. */
export default function BeneficiaryHistoryPage() {
  const t = useTranslations('beneficiary.history');
  const tTypes = useTranslations('ui.creditTypes');
  const locale = useLocale();
  const [filters, setFilters] = useState<Filters>({ q: '', status: '', creditType: '' });
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/employee/operations', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.status === ''
              ? {}
              : { type: filters.status as Schemas['EmployeeOperationType'] }),
            ...(filters.creditType === '' ? {} : { creditType: filters.creditType }),
            ...(filters.q === '' ? {} : { q: filters.q }),
          },
        },
      }),
    [filters],
  );

  const columns: Column<Operation>[] = [
    {
      key: 'counterparty',
      header: t('counterparty'),
      cell: (row) => (
        <Link
          href={`/beneficiaire/historique/${row.id}`}
          className="flex flex-col font-label text-navy underline-offset-2 hover:underline"
          aria-label={t('open', { reference: row.reference })}
        >
          <span>{row.counterpartyName}</span>
          <span className="text-caption text-text-muted">{t(`types.${row.type}`)}</span>
        </Link>
      ),
      sortValue: (row) => row.counterpartyName,
    },
    {
      key: 'creditType',
      header: tTypes('column'),
      cell: (row) => <CreditTypeBadge type={row.creditType} />,
      sortValue: (row) => row.creditType,
    },
    {
      key: 'amount',
      header: t('amount'),
      align: 'end',
      cell: (row) => (
        <Amount
          millimes={row.amountMillimes}
          sign={row.direction === 'CREDIT' ? 'credit' : 'debit'}
        />
      ),
      sortValue: (row) => row.amountMillimes,
    },
    {
      key: 'date',
      header: t('date'),
      cell: (row) => (
        <span className="text-text-muted">{formatDateTime(row.occurredAt, locale)}</span>
      ),
      sortValue: (row) => row.occurredAt,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => (
        <StatusBadge status={row.status} labelKey={`beneficiary.history.statuses.${row.status}`} />
      ),
    },
  ];

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <FilterBar
          searchLabel={t('search')}
          statusLabel={t('type')}
          statusPlaceholder={t('allOperations')}
          statusOptions={TYPES.map((value) => ({ value, label: t(`types.${value}`) }))}
          withCreditType
          onApply={setFilters}
        />
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
