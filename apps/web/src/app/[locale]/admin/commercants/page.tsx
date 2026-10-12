'use client';

import type { Schemas } from '@flexipay/api-client';
import { Store } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { AccountForm } from '@/components/admin/account-form';
import { Rate } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { FilterBar } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

const STATUSES: Schemas['AccountStatus'][] = ['APPROVED', 'PENDING_KYC', 'SUSPENDED', 'REJECTED'];

export default function AdminMerchantsPage() {
  const t = useTranslations('admin.merchants');
  const tStatus = useTranslations('statusLabel');
  const tCategory = useTranslations('category');
  const locale = useLocale();
  const [filters, setFilters] = useState({ q: '', status: '' });
  const [creating, setCreating] = useState(false);
  const [refresh, setRefresh] = useState(0);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/merchants', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === ''
              ? {}
              : { status: filters.status as Schemas['AccountStatus'] }),
          },
        },
      }),
    [filters, refresh],
  );

  const columns: Column<Schemas['MerchantAccount']>[] = [
    { key: 'name', header: t('name'), cell: (row) => row.name },
    { key: 'category', header: t('category'), cell: (row) => tCategory(row.category) },
    { key: 'city', header: t('city'), cell: (row) => row.city },
    {
      key: 'profile',
      header: t('profile'),
      cell: (row) => (
        <span className="flex flex-wrap items-baseline gap-2">
          {row.commissionProfile.name}
          <Rate bps={row.commissionProfile.rateBps} />
        </span>
      ),
    },
    { key: 'created', header: t('created'), cell: (row) => formatDateTime(row.createdAt, locale) },
    { key: 'status', header: t('status'), cell: (row) => <StatusBadge status={row.status} /> },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Button
            icon={<Store aria-hidden="true" className="size-icon-sm" />}
            onClick={() => setCreating(true)}
          >
            {t('create')}
          </Button>
        }
      />
      <Card>
        <FilterBar
          searchLabel={t('search')}
          statusLabel={t('status')}
          statusOptions={STATUSES.map((value) => ({ value, label: tStatus(value) }))}
          onApply={setFilters}
        />
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
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
      <AccountForm
        kind="merchant"
        open={creating}
        onOpenChange={setCreating}
        onCreated={() => setRefresh((value) => value + 1)}
      />
    </>
  );
}
