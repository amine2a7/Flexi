'use client';

import type { Schemas } from '@flexipay/api-client';
import { ChevronRight, Store } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatCalendarDate } from '@/lib/format/date';
import { AccountForm } from '@/components/admin/account-form';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { CommissionLabel, CreditTypeBadges } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { FilterBar } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';
import { useCan } from '@/lib/session/session-context';

const STATUSES: Schemas['AccountStatus'][] = ['APPROVED', 'PENDING_KYC', 'SUSPENDED', 'REJECTED'];

export default function AdminMerchantsPage() {
  const t = useTranslations('admin.merchants');
  const tStatus = useTranslations('statusLabel');
  const tCategory = useTranslations('category');
  const canCreate = useCan('merchants.manage');
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
    {
      key: 'name',
      header: t('name'),
      cell: (row) => (
        <Link
          href={`/admin/commercants/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          aria-label={t('openMerchant', { name: row.name })}
        >
          {row.name}
        </Link>
      ),
      sortValue: (row) => row.name,
    },
    { key: 'category', header: t('category'), cell: (row) => tCategory(row.category) },
    {
      key: 'types',
      header: t('types'),
      cell: (row) => <CreditTypeBadges types={row.acceptedCreditTypes} />,
    },
    { key: 'city', header: t('city'), cell: (row) => row.city, sortValue: (row) => row.city },
    {
      key: 'profile',
      header: t('profile'),
      cell: (row) => <CommissionLabel grid={row.commissionGrid} />,
    },
    {
      key: 'created',
      header: t('created'),
      cell: (row) => formatCalendarDate(row.createdAt.slice(0, 10), locale),
      sortValue: (row) => row.createdAt,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
    {
      key: 'open',
      header: t('open'),
      align: 'end',
      card: 'footer',
      cell: (row) => (
        <Link
          href={`/admin/commercants/${row.id}`}
          className={buttonClasses('ghost', 'sm')}
          aria-label={t('openMerchant', { name: row.name })}
        >
          {t('open')}
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          !canCreate ? undefined : (
            <Button
              icon={<Store aria-hidden="true" className="size-icon-sm" />}
              onClick={() => {
                setCreating(true);
              }}
            >
              {t('create')}
            </Button>
          )
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
        onCreated={() => {
          setRefresh((value) => value + 1);
        }}
      />
    </>
  );
}
