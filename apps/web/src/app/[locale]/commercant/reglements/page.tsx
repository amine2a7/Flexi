'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { useState } from 'react';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatCalendarDate, formatDateTime, formatMonth } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader, Tabs } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

type Tab = 'settlements' | 'documents';

export default function SettlementsPage() {
  const t = useTranslations('merchant.settlements');
  const { settlementDays } = usePlatformTerms();
  const [tab, setTab] = useState<Tab>('settlements');
  return (
    <>
      <PageHeader title={t('title')} description={t('description', { days: settlementDays })} />
      <Card>
        <Tabs
          label={t('title')}
          tabs={[
            { key: 'settlements', label: t('tabSettlements') },
            { key: 'documents', label: t('tabDocuments') },
          ]}
          value={tab}
          onChange={setTab}
        />
        {tab === 'settlements' ? <SettlementList /> : <DocumentList />}
      </Card>
    </>
  );
}

function SettlementList() {
  const t = useTranslations('merchant.settlements');
  const locale = useLocale();
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/merchant/settlements', { params: { query: { cursor, withCount } } }),
    [],
  );
  const columns: Column<Schemas['Settlement']>[] = [
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatCalendarDate(row.settlementDate, locale),
      sortValue: (row) => row.settlementDate,
    },
    { key: 'reference', header: t('reference'), cell: (row) => row.reference },
    { key: 'count', header: t('count'), align: 'end', cell: (row) => row.paymentsCount },
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
      cell: (row) => (
        <StatusBadge
          status={row.status === 'PAID' ? 'SETTLED' : 'RECEIVABLE'}
          labelKey={row.status === 'SCHEDULED' ? 'statusLabel.merchantReceivable' : undefined}
        />
      ),
    },
  ];
  return (
    <DataTable
      caption={t('tabSettlements')}
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
  );
}

function DocumentList() {
  const t = useTranslations('merchant.settlements');
  const locale = useLocale();
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/merchant/documents', { params: { query: { cursor, withCount } } }),
    [],
  );
  const columns: Column<Schemas['MerchantDocument']>[] = [
    { key: 'type', header: t('docType'), cell: (row) => t(`docTypes.${row.type}`) },
    { key: 'period', header: t('period'), cell: (row) => formatMonth(row.period, locale) },
    { key: 'issuedAt', header: t('issuedAt'), cell: (row) => formatDateTime(row.issuedAt, locale) },
  ];
  return (
    <DataTable
      caption={t('tabDocuments')}
      columns={columns}
      rows={list.rows}
      rowKey={(row) => row.id}
      loading={list.loading}
      error={list.error}
      onRetry={list.reload}
      empty={{ title: t('emptyDocuments') }}
      page={list.page}
      pageNumber={list.pageNumber}
      onNext={list.next}
      onPrevious={list.previous}
    />
  );
}
