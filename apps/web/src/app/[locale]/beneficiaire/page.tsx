'use client';

import { Bell, History, QrCode } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatCalendarDate, formatDateTime } from '@/lib/format/date';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { ActivityList } from '@/components/ui/activity';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge, CreditTypeBalanceCards } from '@/components/ui/credit-type';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';

/** Beneficiary home (mobile first): one balance per credit type, requests to confirm, last operations. */
export default function BeneficiaryHomePage() {
  const t = useTranslations('beneficiary.home');
  const tTypes = useTranslations('ui.creditTypes');
  const locale = useLocale();
  const wallet = useApiQuery(() => getApi().GET('/v1/employee/wallet'), []);
  const requests = useApiQuery(() => getApi().GET('/v1/employee/payment-requests'), []);
  const operations = useApiQuery(
    () => getApi().GET('/v1/employee/operations', { params: { query: { limit: 5 } } }),
    [],
  );
  const pending = requests.status === 'success' ? requests.data.data.length : 0;

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <>
            <Link
              href="/beneficiaire/payer"
              className={buttonClasses('primary', 'md', 'flex-1 sm:flex-none')}
            >
              <QrCode aria-hidden="true" className="size-icon-md" />
              {t('pay')}
            </Link>
            <Link
              href="/beneficiaire/historique"
              className={buttonClasses('secondary', 'md', 'flex-1 sm:flex-none')}
            >
              <History aria-hidden="true" className="size-icon-md" />
              {t('history')}
            </Link>
          </>
        }
      />
      {wallet.status === 'loading' ? <LoadingBlock lines={5} /> : null}
      {wallet.status === 'error' ? (
        <ErrorState error={wallet.error} onRetry={wallet.reload} />
      ) : null}
      {wallet.status === 'success' ? (
        <div className="flex flex-col gap-6">
          {pending > 0 ? (
            <Alert tone="warning">
              <span className="flex flex-wrap items-center justify-between gap-3">
                <span className="flex items-center gap-2">
                  <Bell aria-hidden="true" className="size-icon-md" />
                  {t('requests', { count: pending })}
                </span>
                <Link href="/beneficiaire/payer" className={buttonClasses('secondary', 'sm')}>
                  {t('requestsAction')}
                </Link>
              </span>
            </Alert>
          ) : null}
          <CreditTypeBalanceCards
            balances={wallet.data.balances.map((item) => ({
              creditType: item.creditType,
              amountMillimes: item.balanceMillimes,
              disabled: !item.enabled,
              ratio:
                item.dailyLimitMillimes === 0
                  ? 0
                  : item.todaySpentMillimes / item.dailyLimitMillimes,
              note: tTypes('limitUsed', {
                spent: formatMillimesWithCurrency(item.todaySpentMillimes, locale),
                limit: formatMillimesWithCurrency(item.dailyLimitMillimes, locale),
              }),
            }))}
          />
          {wallet.data.balances
            .filter((item) => item.nextExpiryDate !== null && item.expiringMillimes > 0)
            .map((item) => (
              <Alert key={item.creditType} tone="info">
                <span className="flex flex-wrap items-center gap-2">
                  <CreditTypeBadge type={item.creditType} />
                  {t('expiring', {
                    amount: formatMillimesWithCurrency(item.expiringMillimes, locale),
                    date: formatCalendarDate(item.nextExpiryDate ?? '', locale),
                  })}
                </span>
              </Alert>
            ))}
          <Card>
            <div className="flex flex-wrap items-baseline justify-between gap-3">
              <p className="text-label text-text-muted">{tTypes('total')}</p>
              <Amount millimes={wallet.data.totalBalanceMillimes} size="title" />
            </div>
            <p className="mt-2 text-caption text-text-muted">
              {t('offeredBy', { company: wallet.data.companyName })}
            </p>
            <p className="text-caption text-text-muted">{tTypes('noTransfer')}</p>
          </Card>
          <Card>
            <CardTitle
              action={
                <Link href="/beneficiaire/historique" className="text-label text-navy underline">
                  {t('seeAll')}
                </Link>
              }
            >
              {t('recentTitle')}
            </CardTitle>
            <ActivityList
              empty={t('recentEmpty')}
              items={
                operations.status === 'success'
                  ? operations.data.data.map((operation) => ({
                      key: operation.id,
                      href: `/beneficiaire/historique/${operation.id}`,
                      title: operation.counterpartyName,
                      subtitle: formatDateTime(operation.occurredAt, locale),
                      end: (
                        <>
                          <Amount
                            millimes={operation.amountMillimes}
                            sign={operation.direction === 'CREDIT' ? 'credit' : 'debit'}
                          />
                          <CreditTypeBadge type={operation.creditType} />
                        </>
                      ),
                    }))
                  : []
              }
            />
          </Card>
        </div>
      ) : null}
    </>
  );
}
