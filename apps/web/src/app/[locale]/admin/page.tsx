'use client';

import {
  ArrowLeftRight,
  BadgeCheck,
  Building2,
  CalendarClock,
  ClipboardCheck,
  FileSearch,
  Landmark,
  ShoppingCart,
  Store,
  TrendingUp,
} from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime, formatShortMonth } from '@/lib/format/date';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { OrderStatusBadge } from '@/components/orders/order-parts';
import { useOrderCount } from '@/components/orders/use-order-count';
import { ActivityList, TodoPanel, type TodoItem } from '@/components/ui/activity';
import { Amount } from '@/components/ui/amount';
import { BarChart } from '@/components/ui/bar-chart';
import { CreditTypeBreakdown } from '@/components/ui/credit-type';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';

export default function AdminDashboardPage() {
  const t = useTranslations('admin.dashboard');
  const tTypes = useTranslations('ui.creditTypes');
  const locale = useLocale();
  const dashboard = useApiQuery(() => getApi().GET('/v1/admin/dashboard'), []);
  const toConfirm = useOrderCount('admin', 'AWAITING_CONFIRMATION');
  const toValidate = useOrderCount('admin', 'AWAITING_VALIDATION');
  const payouts = useApiQuery(
    () =>
      getApi().GET('/v1/admin/payout-requests', {
        params: { query: { status: 'REQUESTED', limit: 1, withCount: true } },
      }),
    [],
  );
  const payoutsToCheck = payouts.status === 'success' ? (payouts.data.page.count?.value ?? 0) : 0;
  // The list puts the orders waiting for an admin action first (contract).
  const orders = useApiQuery(
    () => getApi().GET('/v1/admin/credit-orders', { params: { query: { limit: 5 } } }),
    [],
  );

  const todos: TodoItem[] = [];
  if (toConfirm !== undefined && toConfirm > 0) {
    todos.push({
      key: 'confirm',
      icon: <ShoppingCart className="size-icon-md" />,
      text: t('todoConfirm', { count: toConfirm }),
      href: '/admin/commandes',
      actionLabel: t('todoOpen'),
    });
  }
  if (toValidate !== undefined && toValidate > 0) {
    todos.push({
      key: 'validate',
      icon: <Landmark className="size-icon-md" />,
      text: t('todoValidate', { count: toValidate }),
      href: '/admin/commandes',
      actionLabel: t('todoOpen'),
    });
  }
  if (payoutsToCheck > 0) {
    todos.push({
      key: 'payouts',
      icon: <ArrowLeftRight className="size-icon-md" />,
      text: t('todoPayouts', { count: payoutsToCheck }),
      href: '/admin/virements',
      actionLabel: t('todoOpen'),
    });
  }
  if (dashboard.status === 'success' && dashboard.data.pendingApprovalsCount > 0) {
    todos.push({
      key: 'approvals',
      icon: <ClipboardCheck className="size-icon-md" />,
      text: t('todoApprovals', { count: dashboard.data.pendingApprovalsCount }),
      href: '/admin/validations',
      actionLabel: t('todoOpen'),
    });
  }
  if (dashboard.status === 'success' && dashboard.data.pendingKycCount > 0) {
    todos.push({
      key: 'kyc',
      icon: <FileSearch className="size-icon-md" />,
      text: t('todoKyc', { count: dashboard.data.pendingKycCount }),
      href: '/admin/kyc',
      actionLabel: t('todoOpen'),
    });
  }

  const actionOrders =
    orders.status === 'success'
      ? orders.data.data.filter(
          (order) =>
            order.status === 'AWAITING_CONFIRMATION' || order.status === 'AWAITING_VALIDATION',
        )
      : [];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <>
            <Link href="/admin/commercants" className={buttonClasses('secondary')}>
              <Store aria-hidden="true" className="size-icon-sm" />
              {t('createMerchant')}
            </Link>
            <Link href="/admin/validations" className={buttonClasses('primary')}>
              <BadgeCheck aria-hidden="true" className="size-icon-sm" />
              {t('seeApprovals')}
            </Link>
          </>
        }
      />
      {dashboard.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {dashboard.status === 'error' ? (
        <ErrorState error={dashboard.error} onRetry={dashboard.reload} />
      ) : null}
      {dashboard.status === 'success' ? (
        <div className="flex flex-col gap-6">
          <TodoPanel items={todos} />
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label={t('volume')}
              value={<Amount millimes={dashboard.data.todayVolumeMillimes} size="title" />}
              hint={t('volumeHint')}
              icon={<TrendingUp className="size-icon-md" />}
              tone="positive"
            />
            <StatCard
              label={t('nextSettlement')}
              value={<Amount millimes={dashboard.data.nextSettlementNetMillimes} size="title" />}
              hint={t('nextSettlementHint')}
              icon={<CalendarClock className="size-icon-md" />}
            />
            <StatCard
              label={t('merchants')}
              value={dashboard.data.merchantsCount}
              hint={t('merchantsHint')}
              icon={<Store className="size-icon-md" />}
            />
            <StatCard
              label={t('companies')}
              value={dashboard.data.companiesCount}
              hint={t('companiesHint')}
              icon={<Building2 className="size-icon-md" />}
            />
          </div>
          <Card>
            <CardTitle description={t('breakdownDescription')}>
              {tTypes('breakdownTitle')}
            </CardTitle>
            <CreditTypeBreakdown items={dashboard.data.monthByCreditType} />
          </Card>
          <div className="grid gap-6 lg:grid-cols-3">
            <Card className="lg:col-span-2">
              <CardTitle description={t('flowsDescription')}>{t('flowsTitle')}</CardTitle>
              <BarChart
                title={t('flowsTitle')}
                series={[
                  {
                    key: 'credited',
                    label: t('seriesCredited'),
                    fillClass: 'fill-navy',
                    dotClass: 'bg-navy',
                  },
                  {
                    key: 'payments',
                    label: t('seriesPayments'),
                    fillClass: 'fill-emerald',
                    dotClass: 'bg-emerald',
                  },
                ]}
                points={dashboard.data.monthlyFlows.map((flow) => ({
                  key: flow.month,
                  label: formatShortMonth(flow.month, locale),
                  values: [flow.creditedMillimes, flow.paymentsMillimes],
                }))}
                format={(value) => formatMillimesWithCurrency(value, locale)}
              />
            </Card>
            <Card>
              <CardTitle
                description={t('ordersDescription')}
                action={
                  <Link href="/admin/commandes" className="text-label text-navy underline">
                    {t('seeOrders')}
                  </Link>
                }
              >
                {t('ordersTitle')}
              </CardTitle>
              <ActivityList
                empty={t('ordersEmpty')}
                items={actionOrders.map((order) => ({
                  key: order.id,
                  href: `/admin/commandes/${order.id}`,
                  title: order.companyName,
                  subtitle: `${order.reference} · ${formatDateTime(order.createdAt, locale)}`,
                  end: (
                    <>
                      <Amount millimes={order.totalMillimes} />
                      <OrderStatusBadge status={order.status} />
                    </>
                  ),
                }))}
              />
            </Card>
          </div>
        </div>
      ) : null}
    </>
  );
}
