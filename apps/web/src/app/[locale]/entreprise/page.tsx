'use client';

import { Landmark, ShoppingCart, Users, Wallet, WalletCards } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime, formatShortMonth } from '@/lib/format/date';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { OrderStatusBadge } from '@/components/orders/order-parts';
import { ActivityList, TodoPanel } from '@/components/ui/activity';
import { Amount } from '@/components/ui/amount';
import { BarChart } from '@/components/ui/bar-chart';
import { CreditTypeBalanceCards } from '@/components/ui/credit-type';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useCanOpen } from '@/lib/session/session-context';

export default function CompanyDashboardPage() {
  const t = useTranslations('company.dashboard');
  const tTypes = useTranslations('ui.creditTypes');
  const canAllocate = useCanOpen('/entreprise/attribution');
  const canOrder = useCanOpen('/entreprise/commandes/nouvelle');
  const locale = useLocale();
  const dashboard = useApiQuery(() => getApi().GET('/v1/company/dashboard'), []);
  // « À faire »: the orders waiting for the company's transfer (status from the server).
  const toPay = useApiQuery(
    () =>
      getApi().GET('/v1/company/orders', {
        params: { query: { status: 'AWAITING_PAYMENT', limit: 5 } },
      }),
    [],
  );

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <>
            {canOrder ? (
              <Link href="/entreprise/commandes/nouvelle" className={buttonClasses('primary')}>
                <ShoppingCart aria-hidden="true" className="size-icon-sm" />
                {t('order')}
              </Link>
            ) : null}
            {canAllocate ? (
              <Link href="/entreprise/attribution" className={buttonClasses('secondary')}>
                <WalletCards aria-hidden="true" className="size-icon-sm" />
                {t('allocate')}
              </Link>
            ) : null}
          </>
        }
      />
      {dashboard.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {dashboard.status === 'error' ? (
        <ErrorState error={dashboard.error} onRetry={dashboard.reload} />
      ) : null}
      {dashboard.status === 'success' ? (
        <div className="flex flex-col gap-6">
          <TodoPanel
            items={
              toPay.status === 'success'
                ? toPay.data.data.map((order) => ({
                    key: order.id,
                    icon: <Landmark className="size-icon-md" />,
                    text: t('todoPay', {
                      reference: order.reference,
                      amount: formatMillimesWithCurrency(order.totalMillimes, locale),
                    }),
                    href: `/entreprise/commandes/${order.id}`,
                    actionLabel: t('todoAction'),
                  }))
                : []
            }
          />
          <section className="flex flex-col gap-4" aria-labelledby="balances-title">
            <div className="flex flex-col gap-1">
              <h2 id="balances-title" className="text-title-sm text-text">
                {t('balancesTitle')}
              </h2>
              <p className="text-body text-text-muted">{t('balancesDescription')}</p>
            </div>
            <CreditTypeBalanceCards
              balances={dashboard.data.balances.map((item) => ({ ...item }))}
              progress="share"
            />
          </section>
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label={tTypes('total')}
              value={
                <Amount millimes={dashboard.data.walletBalanceMillimes} size="title" countUp />
              }
              hint={t('walletHint')}
              icon={<Wallet className="size-icon-md" />}
              tone="positive"
            />
            <StatCard
              label={t('allocated')}
              value={<Amount millimes={dashboard.data.monthAllocatedMillimes} size="title" />}
              icon={<WalletCards className="size-icon-md" />}
            />
            <StatCard
              label={t('employees')}
              value={dashboard.data.activeEmployeesCount}
              hint={t('employeesHint', { total: dashboard.data.employeesCount })}
              icon={<Users className="size-icon-md" />}
            />
            <StatCard
              label={t('pendingOrders')}
              value={dashboard.data.pendingOrdersCount}
              hint={t('pendingHint')}
              icon={<ShoppingCart className="size-icon-md" />}
              tone={dashboard.data.pendingOrdersCount > 0 ? 'attention' : 'default'}
            />
          </div>
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
                    key: 'allocated',
                    label: t('seriesAllocated'),
                    fillClass: 'fill-emerald',
                    dotClass: 'bg-emerald',
                  },
                ]}
                points={dashboard.data.monthlyFlows.map((flow) => ({
                  key: flow.month,
                  label: formatShortMonth(flow.month, locale),
                  values: [flow.creditedMillimes, flow.allocatedMillimes],
                }))}
                format={(value) => formatMillimesWithCurrency(value, locale)}
              />
            </Card>
            <Card>
              <CardTitle
                description={t('recentDescription')}
                action={
                  <Link href="/entreprise/commandes" className="text-label text-navy underline">
                    {t('seeOrders')}
                  </Link>
                }
              >
                {t('recent')}
              </CardTitle>
              <ActivityList
                empty={t('emptyMessage')}
                items={dashboard.data.recentOrders.map((order) => ({
                  key: order.id,
                  href: `/entreprise/commandes/${order.id}`,
                  title: order.reference,
                  subtitle: formatDateTime(order.createdAt, locale),
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
