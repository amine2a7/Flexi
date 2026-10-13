'use client';

import type { Schemas } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { usePaymentColumns } from '@/components/commercant/payment-columns';
import { Card } from '@/components/ui/card';
import { DataTable } from '@/components/ui/data-table';
import { FilterBar, type Filters } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';

const STATUSES: Schemas['PaymentStatus'][] = [
  'CONFIRMED',
  'SETTLED',
  'REFUSED',
  'DISPUTED',
  'INITIATED',
];

export default function MerchantHistoryPage() {
  const t = useTranslations('merchant.history');
  const tStatus = useTranslations('statusLabel');
  const columns = usePaymentColumns();
  const [filters, setFilters] = useState<Filters>({ q: '', status: '', creditType: '' });
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/merchant/payments', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === ''
              ? {}
              : { status: filters.status as Schemas['PaymentStatus'] }),
            ...(filters.creditType === '' ? {} : { creditType: filters.creditType }),
          },
        },
      }),
    [filters],
  );

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <FilterBar
          searchLabel={t('search')}
          statusLabel={t('status')}
          statusOptions={STATUSES.map((value) => ({ value, label: tStatus(value) }))}
          withCreditType
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
