'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeftRight, ChevronRight } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { FilterBar, type Filters } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { Skeleton } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';

type Status = Schemas['PayoutRequestStatus'];
const STATUSES: readonly Status[] = ['REQUESTED', 'CHECKED', 'SENT', 'EXECUTED', 'REJECTED'];

/** Merchant payout requests: requests to check first, each opens its detail page. */
export default function AdminPayoutsPage() {
  const t = useTranslations('admin.payouts');
  const tRoot = useTranslations();
  const tTypes = useTranslations('ui.creditTypes');
  const locale = useLocale();
  const [filters, setFilters] = useState<Filters>({ q: '', status: '', creditType: '' });
  const pending = useApiQuery(
    () =>
      getApi().GET('/v1/admin/payout-requests', {
        params: { query: { status: 'REQUESTED', limit: 1, withCount: true } },
      }),
    [],
  );
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/payout-requests', {
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

  const columns: Column<Schemas['AdminPayoutRequest']>[] = [
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => (
        <Link
          href={`/admin/virements/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.reference}
        </Link>
      ),
      sortValue: (row) => row.reference,
    },
    {
      key: 'merchant',
      header: t('merchant'),
      cell: (row) => row.merchantName,
      sortValue: (row) => row.merchantName,
    },
    {
      key: 'creditType',
      header: tTypes('column'),
      cell: (row) => <CreditTypeBadge type={row.creditType} />,
      sortValue: (row) => row.creditType,
    },
    {
      key: 'date',
      header: t('requestedAt'),
      cell: (row) => formatDateTime(row.requestedAt, locale),
      sortValue: (row) => row.requestedAt,
    },
    {
      key: 'gross',
      header: t('gross'),
      align: 'end',
      cell: (row) => <Amount millimes={row.grossMillimes} />,
      sortValue: (row) => row.grossMillimes,
    },
    {
      key: 'net',
      header: t('net'),
      align: 'end',
      cell: (row) => <Amount millimes={row.netMillimes} />,
      sortValue: (row) => row.netMillimes,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} context="payout" />,
      sortValue: (row) => row.status,
    },
    {
      key: 'open',
      header: t('open'),
      align: 'end',
      cell: (row) => (
        <Link
          href={`/admin/virements/${row.id}`}
          className={buttonClasses(row.status === 'REQUESTED' ? 'primary' : 'ghost', 'sm')}
          aria-label={t('openPayout', { reference: row.reference })}
        >
          {t('open')}
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];

  const pendingCount =
    pending.status === 'success' ? (pending.data.page.count?.value ?? 0) : undefined;
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard
          label={t('kpiPending')}
          value={pendingCount ?? <Skeleton className="h-input-height w-full" />}
          icon={<ArrowLeftRight className="size-icon-md" />}
          tone={pendingCount !== undefined && pendingCount > 0 ? 'attention' : 'default'}
        />
      </div>
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
          highlightNew
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
