'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatCalendarDate } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

export default function AdminSettlementsPage() {
  const t = useTranslations('admin.settlements');
  const locale = useLocale();
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/settlements', { params: { query: { cursor, withCount } } }),
    [],
  );
  const columns: Column<Schemas['SettlementBatch']>[] = [
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatCalendarDate(row.settlementDate, locale),
    },
    { key: 'reference', header: t('reference'), cell: (row) => row.reference },
    { key: 'merchants', header: t('merchants'), align: 'end', cell: (row) => row.merchantsCount },
    {
      key: 'gross',
      header: t('gross'),
      align: 'end',
      cell: (row) => <Amount millimes={row.grossMillimes} />,
    },
    {
      key: 'commission',
      header: t('commission'),
      align: 'end',
      cell: (row) => <Amount millimes={row.commissionMillimes} />,
    },
    {
      key: 'net',
      header: t('net'),
      align: 'end',
      cell: (row) => <Amount millimes={row.netMillimes} />,
    },
    { key: 'status', header: t('status'), cell: (row) => <StatusBadge status={row.status} /> },
  ];
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('emptyTitle') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}
