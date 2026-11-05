'use client';

import type { Schemas } from '@flexipay/api-client';
import { ChevronRight } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatCalendarDate } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

export default function AdminSettlementsPage() {
  const t = useTranslations('admin.settlements');
  const { settlementDays } = usePlatformTerms();
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
      sortValue: (row) => row.settlementDate,
    },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => (
        <Link
          href={`/admin/reglements/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.reference}
        </Link>
      ),
      sortValue: (row) => row.reference,
    },
    {
      key: 'merchants',
      header: t('merchants'),
      align: 'end',
      cell: (row) => row.merchantsCount,
      sortValue: (row) => row.merchantsCount,
    },
    {
      key: 'gross',
      header: t('gross'),
      align: 'end',
      cell: (row) => <Amount millimes={row.grossMillimes} />,
      sortValue: (row) => row.grossMillimes,
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
      sortValue: (row) => row.netMillimes,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
    {
      key: 'open',
      header: t('action'),
      align: 'end',
      cell: (row) => (
        <Link
          href={`/admin/reglements/${row.id}`}
          className={buttonClasses('ghost', 'sm')}
          aria-label={t('openBatch', { reference: row.reference })}
        >
          {t('open')}
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];
  return (
    <>
      <PageHeader title={t('title')} description={t('description', { days: settlementDays })} />
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
