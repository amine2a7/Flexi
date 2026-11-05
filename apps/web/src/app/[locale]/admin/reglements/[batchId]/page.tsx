'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft, Banknote, Percent, Store, Wallet } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useState } from 'react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatCalendarDate } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { ReasonDialog } from '@/components/ui/reason-dialog';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';


/** Settlement batch: totals and the validated payouts that compose it. */
export default function SettlementBatchPage() {
  const { batchId } = useParams<{ batchId: string }>();
  const t = useTranslations('admin.settlements');
  const tPayouts = useTranslations('admin.payouts');
  const canRelease = useCan('payouts.decide');
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
            actions={
              <div className="flex items-center gap-3">
                <StatusBadge status={batch.data.status} />
                {batch.data.status === 'SCHEDULED' && canRelease ? (
                  <ReleaseButton batch={batch.data} onDone={batch.reload} />
                ) : null}
              </div>
            }
          />
          <p className="mb-6 text-body text-text-muted">
            {batch.data.status === 'SCHEDULED'
              ? t('releaseNeeded')
              : batch.data.bankReference !== null
                ? t('bankReturned', { reference: batch.data.bankReference })
                : t('released')}
          </p>
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
              label={t('taxes')}
              value={
                <Amount
                  millimes={batch.data.vatMillimes + batch.data.stampDutyMillimes}
                  size="title"
                />
              }
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

/** Finance asks the release of the batch; another administrator approves it (four eyes). */
function ReleaseButton({
  batch,
  onDone,
}: {
  batch: Schemas['SettlementBatchDetail'];
  onDone: () => void;
}) {
  const batchId = batch.id;
  const t = useTranslations('admin.settlements');
  const toast = useToast();
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button
        size="sm"
        onClick={() => {
          setOpen(true);
        }}
      >
        {t('release')}
      </Button>
      {open ? (
        <ReasonDialog
          open
          onOpenChange={setOpen}
          title={t('releaseTitle')}
          summary={[
            { label: t('reference'), value: batch.reference },
            { label: t('merchants'), value: batch.merchantsCount },
            { label: t('net'), value: <Amount millimes={batch.netMillimes} /> },
          ]}
          effects={[t('releaseDescription')]}
          confirmLabel={t('release')}
          confirmVariant="primary"
          onConfirm={async (reason) => {
            const { data, error } = await getApi().POST(
              '/v1/admin/settlements/{batchId}/release-requests',
              { params: { path: { batchId } }, body: { reason } },
            );
            if (data === undefined) return error;
            toast.notify('success', t('releaseRequested'));
            setOpen(false);
            onDone();
            return undefined;
          }}
        />
      ) : null}
    </>
  );
}
