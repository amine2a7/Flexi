'use client';

import type { Schemas } from '@flexipay/api-client';
import { Plus } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { useOrderColumns } from '@/components/entreprise/order-columns';
import { buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable } from '@/components/ui/data-table';
import { FilterBar } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';

const STATUSES: Schemas['OrderStatus'][] = [
  'CREATED',
  'PAID',
  'RECONCILED',
  'CREDITED',
  'CANCELLED',
];

export default function OrdersPage() {
  const t = useTranslations('company.orders');
  const tStatus = useTranslations('statusLabel');
  const columns = useOrderColumns();
  const [filters, setFilters] = useState({ q: '', status: '' });
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/company/orders', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.status === '' ? {} : { status: filters.status as Schemas['OrderStatus'] }),
          },
        },
      }),
    [filters],
  );

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Link href="/entreprise/commandes/nouvelle" className={buttonClasses('primary')}>
            <Plus aria-hidden="true" className="size-icon-sm" />
            {t('new')}
          </Link>
        }
      />
      <Card>
        <FilterBar
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
    </>
  );
}
