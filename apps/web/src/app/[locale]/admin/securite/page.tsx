'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { useCan } from '@/lib/session/session-context';
import { Amount } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { Alert, PageHeader, Tabs } from '@/components/ui/layout-blocks';
import { ReasonDialog } from '@/components/ui/reason-dialog';
import { StatusBadge } from '@/components/ui/status-badge';

type Tab = 'alerts' | 'disputes';
type FraudAlert = Schemas['FraudAlert'];

/**
 * Administrateur › Sécurité & conformité (admin-securite.md): fraud alerts (super-admin,
 * Opérations) and disputes (also read by Finance, decision of 2026-11-02).
 */
export default function AdminSecurityPage() {
  const t = useTranslations('admin.security');
  const canReadAlerts = useCan('risk.read');
  const [tab, setTab] = useState<Tab>('alerts');
  if (!canReadAlerts) {
    return (
      <>
        <PageHeader title={t('tabDisputes')} description={t('descriptionFinance')} />
        <Card>
          <Disputes />
        </Card>
      </>
    );
  }
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Tabs
        label={t('title')}
        tabs={[
          { key: 'alerts', label: t('tabAlerts') },
          { key: 'disputes', label: t('tabDisputes') },
        ]}
        value={tab}
        onChange={setTab}
      />
      <Card className="mt-4">{tab === 'alerts' ? <Alerts /> : <Disputes />}</Card>
    </>
  );
}

function Alerts() {
  const t = useTranslations('admin.security');
  const locale = useLocale();
  const canManage = useCan('alerts.manage');
  const [closing, setClosing] = useState<FraudAlert | undefined>(undefined);
  const [failure, setFailure] = useState(false);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/fraud-alerts', { params: { query: { cursor, withCount } } }),
    [],
  );
  async function start(alert: FraudAlert) {
    setFailure(false);
    const { error } = await getApi().POST('/v1/admin/fraud-alerts/{alertId}/start', {
      params: { path: { alertId: alert.id } },
    });
    if (error !== undefined) setFailure(true);
    list.reload();
  }
  const columns: Column<FraudAlert>[] = [
    {
      key: 'kind',
      header: t('kind'),
      card: 'title',
      cell: (row) => <span className="font-label text-text">{t(`kinds.${row.kind}`)}</span>,
    },
    { key: 'subject', header: t('subject'), cell: (row) => <bdi>{row.subject}</bdi> },
    {
      key: 'severity',
      header: t('severity'),
      cell: (row) => (
        <StatusBadge
          context="risk"
          status={`SEVERITY_${row.severity}`}
          labelKey={`admin.security.severities.${row.severity}`}
        />
      ),
    },
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatDateTime(row.occurredAt, locale),
      sortValue: (row) => row.occurredAt,
    },
    {
      key: 'status',
      header: t('status'),
      card: 'title',
      cell: (row) => (
        <StatusBadge
          context="risk"
          status={row.status}
          labelKey={`admin.security.alertStatuses.${row.status}`}
        />
      ),
    },
    {
      key: 'handled',
      header: t('handledBy'),
      cell: (row) => (row.handledByName === null ? '—' : <bdi>{row.handledByName}</bdi>),
    },
    ...(canManage
      ? [
          {
            key: 'actions',
            header: t('actions'),
            card: 'footer' as const,
            cell: (row: FraudAlert) =>
              row.status === 'CLOSED' ? (
                row.closeReason
              ) : (
                <span className="flex flex-wrap gap-2">
                  {row.status === 'OPEN' ? (
                    <Button variant="secondary" size="sm" onClick={() => void start(row)}>
                      {t('alertStart')}
                    </Button>
                  ) : null}
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => {
                      setClosing(row);
                    }}
                  >
                    {t('alertClose')}
                  </Button>
                </span>
              ),
          },
        ]
      : []),
  ];
  return (
    <>
      {failure ? (
        <div className="mb-4">
          <Alert tone="danger">{t('alertFailed')}</Alert>
        </div>
      ) : null}
      <DataTable
        caption={t('tabAlerts')}
        columns={columns}
        rows={list.rows}
        rowKey={(row) => row.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.reload}
        empty={{ title: t('emptyAlerts') }}
        page={list.page}
        pageNumber={list.pageNumber}
        onNext={list.next}
        onPrevious={list.previous}
      />
      {closing !== undefined ? (
        <ReasonDialog
          open
          onOpenChange={(open) => {
            if (!open) setClosing(undefined);
          }}
          title={t('alertCloseTitle')}
          summary={[
            { label: t('kind'), value: t(`kinds.${closing.kind}`) },
            { label: t('subject'), value: <bdi>{closing.subject}</bdi> },
          ]}
          effects={[t('alertCloseEffect')]}
          confirmLabel={t('alertClose')}
          onConfirm={async (reason) => {
            const { error } = await getApi().POST('/v1/admin/fraud-alerts/{alertId}/close', {
              params: { path: { alertId: closing.id } },
              body: { reason },
            });
            if (error === undefined) {
              setClosing(undefined);
              list.reload();
            }
            return error;
          }}
        />
      ) : null}
    </>
  );
}

function Disputes() {
  const t = useTranslations('admin.security');
  const locale = useLocale();
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/disputes', { params: { query: { cursor, withCount } } }),
    [],
  );
  const columns: Column<Schemas['Dispute']>[] = [
    {
      key: 'reference',
      header: t('dispute'),
      card: 'title',
      cell: (row) => (
        <Link href={`/admin/securite/litiges/${row.id}`} className="font-label text-navy underline">
          <span dir="ltr">{row.reference}</span>
        </Link>
      ),
    },
    {
      key: 'payment',
      header: t('payment'),
      cell: (row) => <span dir="ltr">{row.paymentReference}</span>,
    },
    { key: 'merchant', header: t('merchant'), cell: (row) => <bdi>{row.merchantName}</bdi> },
    {
      key: 'amount',
      header: t('amount'),
      align: 'end',
      cell: (row) => <Amount millimes={row.amountMillimes} />,
      sortValue: (row) => row.amountMillimes,
    },
    { key: 'reason', header: t('reason'), cell: (row) => row.reason },
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatDateTime(row.openedAt, locale),
      sortValue: (row) => row.openedAt,
    },
    {
      key: 'status',
      header: t('status'),
      card: 'title',
      cell: (row) => (
        <StatusBadge
          context="risk"
          status={row.status}
          labelKey={`admin.security.disputeStatuses.${row.status}`}
        />
      ),
    },
  ];
  return (
    <DataTable
      caption={t('tabDisputes')}
      columns={columns}
      rows={list.rows}
      rowKey={(row) => row.id}
      loading={list.loading}
      error={list.error}
      onRetry={list.reload}
      empty={{ title: t('emptyDisputes') }}
      page={list.page}
      pageNumber={list.pageNumber}
      onNext={list.next}
      onPrevious={list.previous}
    />
  );
}
