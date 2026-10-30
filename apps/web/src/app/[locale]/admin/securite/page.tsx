'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { Alert, PageHeader, Tabs } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

type Tab = 'alerts' | 'disputes';

/**
 * Administrateur › Sécurité & conformité (admin-securite.md): fraud alerts and disputes, read
 * only until the API serves them (N2, decision of 2026-10-21: disputes V1).
 */
export default function AdminSecurityPage() {
  const t = useTranslations('admin.security');
  const [tab, setTab] = useState<Tab>('alerts');
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="mb-6">
        <Alert tone="info">{t('readOnly')}</Alert>
      </div>
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
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/fraud-alerts', { params: { query: { cursor, withCount } } }),
    [],
  );
  const columns: Column<Schemas['FraudAlert']>[] = [
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
  ];
  return (
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
      header: t('payment'),
      card: 'title',
      cell: (row) => (
        <span className="font-label text-text" dir="ltr">
          {row.paymentReference}
        </span>
      ),
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
