'use client';

import type { Schemas } from '@flexipay/api-client';
import { Clock, Landmark, Plus, ShieldCheck, Wallet } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { useOrderColumns } from '@/components/entreprise/order-columns';
import { ORDER_STATUSES } from '@/components/orders/order-parts';
import { useOrderCount } from '@/components/orders/use-order-count';
import { Amount } from '@/components/ui/amount';
import { useApiQuery } from '@/lib/api/use-api-query';
import { buttonClasses } from '@/components/ui/button';
import { Card, StatCard } from '@/components/ui/card';
import { DataTable } from '@/components/ui/data-table';
import { FilterBar, type Filters } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { Skeleton } from '@/components/ui/states';
import { useCanOpen } from '@/lib/session/session-context';

export default function OrdersPage() {
  const t = useTranslations('company.orders');
  const tOrders = useTranslations('orders');
  const canOrder = useCanOpen('/entreprise/commandes/nouvelle');
  const columns = useOrderColumns();
  const [filters, setFilters] = useState<Filters>({ q: '', status: '', creditType: '' });
  const dashboard = useApiQuery(() => getApi().GET('/v1/company/dashboard'), []);
  const toConfirm = useOrderCount('company', 'AWAITING_CONFIRMATION');
  const toPay = useOrderCount('company', 'AWAITING_PAYMENT');
  const toValidate = useOrderCount('company', 'AWAITING_VALIDATION');
  const count = (value: number | undefined) =>
    value ?? <Skeleton className="h-input-height w-full" />;
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/company/orders', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.status === '' ? {} : { status: filters.status as Schemas['OrderStatus'] }),
            ...(filters.creditType === '' ? {} : { creditType: filters.creditType }),
          },
        },
      }),
    [filters],
  );

  return (
    <>
      <PageHeader
        title={tOrders('company.title')}
        description={tOrders('company.description')}
        actions={
          canOrder ? (
            <Link href="/entreprise/commandes/nouvelle" className={buttonClasses('primary')}>
              <Plus aria-hidden="true" className="size-icon-sm" />
              {t('new')}
            </Link>
          ) : null
        }
      />
      <div className="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard
          label={tOrders('company.kpiWallet')}
          value={
            dashboard.status === 'success' ? (
              <Amount millimes={dashboard.data.walletBalanceMillimes} size="title" />
            ) : (
              count(undefined)
            )
          }
          hint={tOrders('company.kpiWalletHint')}
          icon={<Wallet className="size-icon-md" />}
          tone="positive"
        />
        <StatCard
          label={tOrders('company.kpiConfirmation')}
          value={count(toConfirm)}
          hint={tOrders('company.kpiConfirmationHint')}
          icon={<Clock className="size-icon-md" />}
        />
        <StatCard
          label={tOrders('company.kpiPayment')}
          value={count(toPay)}
          hint={tOrders('company.kpiPaymentHint')}
          icon={<Landmark className="size-icon-md" />}
          tone={toPay !== undefined && toPay > 0 ? 'attention' : 'default'}
        />
        <StatCard
          label={tOrders('company.kpiValidation')}
          value={count(toValidate)}
          hint={tOrders('company.kpiValidationHint')}
          icon={<ShieldCheck className="size-icon-md" />}
        />
      </div>
      <Card>
        <FilterBar
          statusLabel={t('status')}
          statusOptions={ORDER_STATUSES.map((value) => ({
            value,
            label: tOrders(`status.${value}`),
          }))}
          withCreditType
          onApply={setFilters}
        />
        <DataTable
          caption={tOrders('company.title')}
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
