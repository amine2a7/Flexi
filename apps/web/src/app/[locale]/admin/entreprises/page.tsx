'use client';

import type { Schemas } from '@flexipay/api-client';
import { Building2 } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { AccountForm } from '@/components/admin/account-form';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { FilterBar } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';

const STATUSES: Schemas['AccountStatus'][] = ['APPROVED', 'PENDING_KYC', 'SUSPENDED', 'REJECTED'];

export default function AdminCompaniesPage() {
  const t = useTranslations('admin.companies');
  const tStatus = useTranslations('statusLabel');
  const locale = useLocale();
  const [filters, setFilters] = useState({ q: '', status: '' });
  const [creating, setCreating] = useState(false);
  const [refresh, setRefresh] = useState(0);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/companies', {
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

  const columns: Column<Schemas['CompanyAccount']>[] = [
    { key: 'name', header: t('name'), cell: (row) => row.name, sortValue: (row) => row.name },
    { key: 'city', header: t('city'), cell: (row) => row.city, sortValue: (row) => row.city },
    {
      key: 'employees',
      header: t('employees'),
      align: 'end',
      cell: (row) => row.employeesCount,
      sortValue: (row) => row.employeesCount,
    },
    {
      key: 'created',
      header: t('created'),
      cell: (row) => formatDateTime(row.createdAt, locale),
      sortValue: (row) => row.createdAt,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Button
            icon={<Building2 aria-hidden="true" className="size-icon-sm" />}
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
        kind="company"
        open={creating}
        onOpenChange={setCreating}
        onCreated={() => setRefresh((value) => value + 1)}
      />
    </>
  );
}
