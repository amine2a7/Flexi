'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatCalendarDate, formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

export default function ReceivablesPage() {
  const t = useTranslations('merchant.receivables');
  const locale = useLocale();
  const [total, setTotal] = useState<number | undefined>(undefined);
  const list = usePagedList(async (cursor, withCount) => {
    const result = await getApi().GET('/v1/merchant/receivables', {
      params: { query: { cursor, withCount } },
    });
    if (result.data !== undefined) setTotal(result.data.totalMillimes);
    return result;
  }, []);

  const columns: Column<Schemas['Receivable']>[] = [
    { key: 'reference', header: t('reference'), cell: (row) => row.reference },
    {
      key: 'confirmedAt',
      header: t('confirmedAt'),
      cell: (row) => formatDateTime(row.confirmedAt, locale),
    },
    {
      key: 'settlementDate',
      header: t('settlementDate'),
      cell: (row) => formatCalendarDate(row.settlementDate, locale),
    },
    {
      key: 'amount',
      header: t('amount'),
      align: 'end',
      cell: (row) => <Amount millimes={row.amountMillimes} />,
    },
    // Merchant wording of A_REGLER (decision 2).
    {
      key: 'status',
      header: t('status'),
      cell: () => <StatusBadge status="RECEIVABLE" labelKey="statusLabel.merchantReceivable" />,
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Link href="/commercant/virements" className={buttonClasses('primary')}>
            {t('requestPayout')}
          </Link>
        }
      />
      <div className="mb-6 grid gap-4 sm:grid-cols-2">
        <StatCard
          label={t('total')}
          value={total === undefined ? '…' : <Amount millimes={total} size="title" />}
          hint={t('totalHint')}
        />
      </div>
      <Card>
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.paymentId}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('emptyTitle'), message: t('emptyMessage') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}
