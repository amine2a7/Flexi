'use client';

import { CalendarClock, HandCoins, Percent, Wallet } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatCalendarDate } from '@/lib/format/date';
import { usePaymentColumns } from '@/components/commercant/payment-columns';
import { Amount, Rate } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { DataTable } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useSession } from '@/lib/session/session-context';

export default function MerchantDashboardPage() {
  const t = useTranslations('merchant.dashboard');
  const locale = useLocale();
  const { me } = useSession();
  const columns = usePaymentColumns();
  const dashboard = useApiQuery(() => getApi().GET('/v1/merchant/dashboard'), []);

  return (
    <>
      <PageHeader
        title={t('title', { name: me.displayName })}
        description={t('description')}
        actions={
          <Link href="/commercant/encaissement" className={buttonClasses('primary')}>
            <HandCoins aria-hidden="true" className="size-icon-sm" />
            {t('collect')}
          </Link>
        }
      />
      {dashboard.status === 'loading' ? <LoadingBlock lines={4} /> : null}
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
              hint={t('settlementRule')}
              icon={<CalendarClock className="size-icon-md" />}
            />
            <StatCard
              label={t('rate')}
              value={<Rate bps={dashboard.data.commissionRateBps} />}
              hint={t('rateHint')}
              icon={<Percent className="size-icon-md" />}
            />
          </div>
          <Card>
            <CardTitle
              action={
                <Link href="/commercant/historique" className="text-label text-navy underline">
                  {t('seeHistory')}
                </Link>
              }
            >
              {t('recent')}
            </CardTitle>
            <DataTable
              caption={t('recent')}
              columns={columns}
              rows={dashboard.data.recentPayments}
              rowKey={(row) => row.id}
              empty={{ title: t('emptyTitle'), message: t('emptyMessage') }}
            />
          </Card>
        </div>
      ) : null}
    </>
  );
}
