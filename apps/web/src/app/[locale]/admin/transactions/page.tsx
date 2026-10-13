'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { FilterBar, type Filters } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

type Status = Schemas['PaymentStatus'];
const STATUSES: readonly Status[] = ['CONFIRMED', 'SETTLED', 'REFUSED', 'DISPUTED', 'INITIATED'];

/** Global transactions: every payment at a merchant, with search and status filter. */
export default function AdminTransactionsPage() {
  const t = useTranslations('admin.transactions');
  const tRoot = useTranslations();
  const locale = useLocale();
  const [filters, setFilters] = useState<Filters>({ q: '', status: '', creditType: '' });
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/transactions', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === '' ? {} : { status: filters.status as Status }),
            ...(filters.creditType === '' ? {} : { creditType: filters.creditType }),
          },
        },
      }),
    [filters],
  );

  const columns: Column<Schemas['AdminTransaction']>[] = [
    {
      key: 'merchant',
      header: t('merchant'),
      cell: (row) => <span className="font-label text-text">{row.merchantName}</span>,
      sortValue: (row) => row.merchantName,
    },
    {
      key: 'company',
      header: t('company'),
      cell: (row) => row.companyName,
      sortValue: (row) => row.companyName,
    },
    {
      key: 'category',
      header: t('category'),
      cell: (row) => <CreditTypeBadge type={row.creditType} />,
      sortValue: (row) => row.creditType,
    },
    {
      key: 'amount',
      header: t('amount'),
      align: 'end',
      cell: (row) => <Amount millimes={row.amountMillimes} />,
      sortValue: (row) => row.amountMillimes,
    },
    {
      key: 'date',
      header: t('date'),
      cell: (row) => (
        <span className="text-text-muted">{formatDateTime(row.createdAt, locale)}</span>
      ),
      sortValue: (row) => row.createdAt,
    },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => <span dir="ltr">{row.reference}</span>,
      sortValue: (row) => row.reference,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
  ];

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <FilterBar
          searchLabel={t('search')}
          statusLabel={t('status')}
          statusOptions={STATUSES.map((value) => ({
            value,
            label: tRoot(messageKey(`statusLabel.${value}`)),
          }))}
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
