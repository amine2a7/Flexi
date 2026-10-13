'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft, Banknote, Percent, Store, Wallet } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatCalendarDate } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';

/** Settlement batch: totals and the validated payouts that compose it. */
export default function SettlementBatchPage() {
  const { batchId } = useParams<{ batchId: string }>();
  const t = useTranslations('admin.settlements');
  const tPayouts = useTranslations('admin.payouts');
  const locale = useLocale();
  const batch = useApiQuery(
    () => getApi().GET('/v1/admin/settlements/{batchId}', { params: { path: { batchId } } }),
    [batchId],
  );

  const columns: Column<Schemas['AdminPayoutRequest']>[] = [
    {
      key: 'reference',
      header: tPayouts('reference'),
      cell: (row) => (
        <span dir="ltr" className="font-label">
          {row.reference}
        </span>
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
      key: 'iban',
      header: t('iban'),
      cell: (row) => (
        <code dir="ltr" className="text-caption">
          {row.iban}
        </code>
      ),
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
      cell: (row) => <Amount millimes={row.commissionMillimes} sign="debit" />,
      sortValue: (row) => row.commissionMillimes,
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
    },
  ];

  return (
    <>
      <Link href="/admin/reglements" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {batch.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {batch.status === 'error' ? <ErrorState error={batch.error} onRetry={batch.reload} /> : null}
      {batch.status === 'success' ? (
        <>
          <PageHeader
            title={t('detailTitle', { reference: batch.data.reference })}
            description={formatCalendarDate(batch.data.settlementDate, locale)}
            actions={<StatusBadge status={batch.data.status} />}
          />
          <div className="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label={t('merchants')}
              value={batch.data.merchantsCount}
              icon={<Store className="size-icon-md" />}
            />
            <StatCard
              label={t('gross')}
              value={<Amount millimes={batch.data.grossMillimes} size="title" />}
              icon={<Banknote className="size-icon-md" />}
            />
            <StatCard
              label={t('commission')}
              value={<Amount millimes={batch.data.commissionMillimes} size="title" />}
              icon={<Percent className="size-icon-md" />}
            />
            <StatCard
              label={t('net')}
              value={<Amount millimes={batch.data.netMillimes} size="title" />}
              icon={<Wallet className="size-icon-md" />}
              tone="positive"
            />
          </div>
          <Card>
            <CardTitle>{t('payoutsTitle')}</CardTitle>
            <DataTable
              caption={t('payoutsTitle')}
              columns={columns}
              rows={batch.data.payouts}
              rowKey={(row) => row.id}
              empty={{ title: t('emptyTitle') }}
            />
          </Card>
        </>
      ) : null}
    </>
  );
}
