'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { FilterBar } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';

export default function AuditPage() {
  const t = useTranslations('admin.audit');
  const locale = useLocale();
  const [q, setQ] = useState('');
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/audit-logs', {
        params: { query: { cursor, withCount, ...(q === '' ? {} : { q }) } },
      }),
    [q],
  );
  const columns: Column<Schemas['AuditLogEntry']>[] = [
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatDateTime(row.occurredAt, locale),
      sortValue: (row) => row.occurredAt,
    },
    {
      key: 'actor',
      header: t('actor'),
      cell: (row) => row.actorName,
      sortValue: (row) => row.actorName,
    },
    {
      key: 'action',
      header: t('action'),
      cell: (row) => (
        <code dir="ltr" className="text-caption">
          {row.action}
        </code>
      ),
    },
    {
      key: 'target',
      header: t('target'),
      cell: (row) => row.target,
      sortValue: (row) => row.target,
    },
  ];
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <FilterBar searchLabel={t('search')} onApply={(filters) => setQ(filters.q)} />
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
