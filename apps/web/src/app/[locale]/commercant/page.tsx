'use client';

import { ArrowLeftRight, CalendarClock, HandCoins, Percent, Wallet } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatCalendarDate, formatDateTime, formatShortMonth } from '@/lib/format/date';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { ActivityList, TodoPanel, type TodoItem } from '@/components/ui/activity';
import { Amount, Rate } from '@/components/ui/amount';
import { BarChart } from '@/components/ui/bar-chart';
import { CreditTypeBreakdown } from '@/components/ui/credit-type';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { useCan } from '@/lib/session/session-context';

export default function MerchantDashboardPage() {
  const t = useTranslations('merchant.dashboard');
  const { settlementDays } = usePlatformTerms();
  const tTypes = useTranslations('ui.creditTypes');
  const canCollect = useCan('payments.collect');
  const locale = useLocale();
  const dashboard = useApiQuery(() => getApi().GET('/v1/merchant/dashboard'), []);

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description', { days: settlementDays })}
        actions={
          !canCollect ? undefined : (
            <Link
              href="/commercant/encaissement"
              className={buttonClasses('primary', 'md', 'w-full sm:w-auto')}
            >
              <HandCoins aria-hidden="true" className="size-icon-md" />
              {t('collect')}
            </Link>
          )
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
              dashboard.data.receivablesMillimes > 0
                ? ([
                    {
                      key: 'payout',
                      icon: <ArrowLeftRight className="size-icon-md" />,
                      text: t('todoPayout', {
                        amount: formatMillimesWithCurrency(
                          dashboard.data.receivablesMillimes,
                          locale,
                        ),
                      }),
                      href: '/commercant/virements',
                      actionLabel: t('todoPayoutAction'),
                    },
                  ] satisfies TodoItem[])
                : []
            }
          />
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label={t('today')}
              value={
                <Amount millimes={dashboard.data.todayCollectedMillimes} size="title" countUp />
              }
              hint={t('todayCount', { count: dashboard.data.todayPaymentsCount })}
              icon={<HandCoins className="size-icon-md" />}
              tone="positive"
            />
            <StatCard
              label={t('receivables')}
              value={<Amount millimes={dashboard.data.receivablesMillimes} size="title" />}
              hint={
                <Link href="/commercant/creances" className="text-navy underline">
                  {t('seeReceivables')}
                </Link>
              }
              icon={<Wallet className="size-icon-md" />}
            />
            <StatCard
              label={t('nextSettlement')}
              value={
                dashboard.data.nextSettlementDate === null
                  ? t('noSettlement')
                  : formatCalendarDate(dashboard.data.nextSettlementDate, locale)
              }
              hint={t('settlementRule', { days: settlementDays })}
              icon={<CalendarClock className="size-icon-md" />}
            />
            <StatCard
              label={t('rate')}
              value={
                dashboard.data.commissionRateBps === null ? (
                  tTypes('rateByType')
                ) : (
                  <Rate bps={dashboard.data.commissionRateBps} />
                )
              }
              hint={t('rateHint')}
              icon={<Percent className="size-icon-md" />}
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
                    key: 'collected',
                    label: t('seriesCollected'),
                    fillClass: 'fill-navy',
                    dotClass: 'bg-navy',
                  },
                  {
                    key: 'settled',
                    label: t('seriesSettled'),
                    fillClass: 'fill-emerald',
                    dotClass: 'bg-emerald',
                  },
                ]}
                points={dashboard.data.monthlyFlows.map((flow) => ({
                  key: flow.month,
                  label: formatShortMonth(flow.month, locale),
                  values: [flow.collectedMillimes, flow.settledMillimes],
                }))}
                format={(value) => formatMillimesWithCurrency(value, locale)}
              />
            </Card>
            <Card>
              <CardTitle
                description={t('recentDescription')}
                action={
                  <Link href="/commercant/historique" className="text-label text-navy underline">
                    {t('seeHistory')}
                  </Link>
                }
              >
                {t('recent')}
              </CardTitle>
              <ActivityList
                empty={t('emptyMessage')}
                items={dashboard.data.recentPayments.map((payment) => ({
                  key: payment.id,
                  href: `/commercant/historique/${payment.id}`,
                  title: `${payment.customer.firstName} ${payment.customer.lastInitial}.`,
                  subtitle: `${payment.reference} · ${formatDateTime(payment.createdAt, locale)}`,
                  end: (
                    <>
                      <Amount millimes={payment.amountMillimes} />
                      <StatusBadge status={payment.status} />
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
