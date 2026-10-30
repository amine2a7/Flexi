'use client';

import { CalendarCheck, HandCoins, Percent, Receipt } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatCalendarDate, formatShortMonth } from '@/lib/format/date';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { Amount, Rate } from '@/components/ui/amount';
import { BarChart } from '@/components/ui/bar-chart';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { CreditTypeBreakdown } from '@/components/ui/credit-type';
import { PageHeader } from '@/components/ui/layout-blocks';
import { EmptyState, ErrorState, LoadingBlock } from '@/components/ui/states';

/**
 * Commerçant › Statistiques (commercant-statistiques.md): collected and settled amounts over the
 * last months and the split by credit type, as sent by the API (nothing computed here).
 */
export default function MerchantStatisticsPage() {
  const t = useTranslations('merchant.statistics');
  const locale = useLocale();
  const dashboard = useApiQuery(() => getApi().GET('/v1/merchant/dashboard'), []);

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      {dashboard.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {dashboard.status === 'error' ? (
        <ErrorState error={dashboard.error} onRetry={dashboard.reload} />
      ) : null}
      {dashboard.status === 'success' ? (
        <div className="flex flex-col gap-6">
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label={t('today')}
              value={<Amount millimes={dashboard.data.todayCollectedMillimes} size="title" />}
              hint={t('todayCount', { count: dashboard.data.todayPaymentsCount })}
              icon={<HandCoins className="size-icon-md" />}
              tone="positive"
            />
            <StatCard
              label={t('receivables')}
              value={<Amount millimes={dashboard.data.receivablesMillimes} size="title" />}
              icon={<Receipt className="size-icon-md" />}
            />
            <StatCard
              label={t('nextSettlement')}
              value={
                dashboard.data.nextSettlementDate === null
                  ? t('none')
                  : formatCalendarDate(dashboard.data.nextSettlementDate, locale)
              }
              icon={<CalendarCheck className="size-icon-md" />}
            />
            <StatCard
              label={t('rate')}
              value={
                dashboard.data.commissionRateBps === null ? (
                  t('none')
                ) : (
                  <Rate bps={dashboard.data.commissionRateBps} />
                )
              }
              icon={<Percent className="size-icon-md" />}
            />
          </div>
          {dashboard.data.monthlyFlows.length === 0 ? (
            <Card>
              <EmptyState title={t('emptyTitle')} message={t('emptyMessage')} />
            </Card>
          ) : (
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
                <CardTitle description={t('typesDescription')}>{t('typesTitle')}</CardTitle>
                <CreditTypeBreakdown items={dashboard.data.monthByCreditType} />
              </Card>
            </div>
          )}
        </div>
      ) : null}
    </>
  );
}
