'use client';

import { ArrowLeft } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatCalendarDate, formatDateTime } from '@/lib/format/date';
import { formatRateBps } from '@/lib/format/money';
import { Amount, AmountBreakdown } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';

/** Payment detail: customer, amount, frozen commission, D+2 settlement and steps (UX §6.7). */
export default function PaymentDetailPage() {
  const { paymentId } = useParams<{ paymentId: string }>();
  const t = useTranslations('merchant.paymentDetail');
  const tRoot = useTranslations();
  const locale = useLocale();
  const payment = useApiQuery(
    () => getApi().GET('/v1/merchant/payments/{paymentId}', { params: { path: { paymentId } } }),
    [paymentId],
  );

  return (
    <>
      <Link href="/commercant/historique" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {payment.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {payment.status === 'error' ? (
        <ErrorState error={payment.error} onRetry={payment.reload} />
      ) : null}
      {payment.status === 'success' ? (
        <>
          <PageHeader
            title={t('title', { reference: payment.data.reference })}
            actions={<StatusBadge status={payment.data.status} />}
          />
          <div className="grid gap-6 lg:grid-cols-2">
            <Card>
              <CardTitle>{t('summary')}</CardTitle>
              <div className="flex flex-col gap-5">
                <DescriptionList
                  items={[
                    {
                      label: t('customer'),
                      value: `${payment.data.customer.firstName} ${payment.data.customer.lastInitial}. · ${payment.data.customer.maskedEmployeeNumber}`,
                    },
                    {
                      label: t('createdAt'),
                      value: formatDateTime(payment.data.createdAt, locale),
                    },
                    {
                      label: t('category'),
                      value: tRoot(messageKey(`creditCategory.${payment.data.category}`)),
                    },
                    {
                      label: t('amount'),
                      value: <Amount millimes={payment.data.amountMillimes} size="title" />,
                    },
                    {
                      label: t('settlementDate'),
                      value:
                        payment.data.settlementDate === null
                          ? t('noSettlement')
                          : formatCalendarDate(payment.data.settlementDate, locale),
                    },
                  ]}
                />
                {payment.data.settlementDate === null ? (
                  <Alert tone="info">{t('noSettlement')}</Alert>
                ) : (
                  <AmountBreakdown
                    lines={[
                      { label: t('amount'), millimes: payment.data.amountMillimes },
                      {
                        label: t('commission'),
                        note: formatRateBps(payment.data.commissionRateBps, locale),
                        millimes: payment.data.commissionMillimes,
                        sign: 'debit',
                      },
                    ]}
                    total={{ label: t('net'), millimes: payment.data.netMillimes }}
                  />
                )}
              </div>
            </Card>
            <Card>
              <CardTitle>{t('historyTitle')}</CardTitle>
              <Timeline
                entries={payment.data.history.map((event) => ({
                  key: `${event.status}-${event.occurredAt}`,
                  title: t(`event.${event.status}`),
                  meta: formatDateTime(event.occurredAt, locale),
                  tone:
                    event.status === 'REFUSED' || event.status === 'DISPUTED'
                      ? 'danger'
                      : 'default',
                }))}
              />
            </Card>
          </div>
        </>
      ) : null}
    </>
  );
}
