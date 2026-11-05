'use client';

import { ArrowLeft, Undo2 } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { useCan } from '@/lib/session/session-context';
import { formatCalendarDate, formatDateTime } from '@/lib/format/date';
import { formatRateBps } from '@/lib/format/money';
import { Amount, AmountBreakdown } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { ConfirmDialog } from '@/components/ui/modal';
import { StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';
import { useToast } from '@/components/ui/toast';

/** Payment detail: customer, amount, frozen commission, settlement date and steps (UX §6.7). */
export default function PaymentDetailPage() {
  const { paymentId } = useParams<{ paymentId: string }>();
  const t = useTranslations('merchant.paymentDetail');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const canRefund = useCan('payments.refund');
  const { cancelHours } = usePlatformTerms();
  const payment = useApiQuery(
    () => getApi().GET('/v1/merchant/payments/{paymentId}', { params: { path: { paymentId } } }),
    [paymentId],
  );
  const [confirming, setConfirming] = useState(false);
  const [refundKey, setRefundKey] = useState(newIdempotencyKey);
  const [refunding, setRefunding] = useState(false);

  /** Cancellation within the window of the settings: the API checks the delay and the state. */
  async function refund() {
    setRefunding(true);
    try {
      const { data, error } = await getApi().POST('/v1/merchant/payments/{paymentId}/refund', {
        params: { path: { paymentId }, header: { 'Idempotency-Key': refundKey } },
      });
      setConfirming(false);
      setRefundKey(newIdempotencyKey());
      if (data !== undefined) {
        toast.notify('success', t('cancelled'));
        payment.reload();
        return;
      }
      toast.notify(
        'error',
        asProblem(error)?.code === 'CANCEL_WINDOW_OVER'
          ? t('cancelTooLate')
          : tRoot(messageKey(errorMessageKey(error))),
      );
    } finally {
      setRefunding(false);
    }
  }

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
            actions={
              <div className="flex flex-wrap items-center gap-3">
                <StatusBadge status={payment.data.status} />
                {canRefund && payment.data.status === 'CONFIRMED' ? (
                  <Button
                    variant="secondary"
                    size="sm"
                    icon={<Undo2 aria-hidden="true" className="size-icon-sm rtl:-scale-x-100" />}
                    onClick={() => {
                      setConfirming(true);
                    }}
                  >
                    {t('cancel')}
                  </Button>
                ) : null}
              </div>
            }
          />
          <ConfirmDialog
            open={confirming}
            onOpenChange={setConfirming}
            title={t('cancelTitle', { reference: payment.data.reference })}
            description={t('cancelText', { hours: cancelHours })}
            confirmLabel={t('cancelConfirm')}
            confirmVariant="danger"
            loading={refunding}
            onConfirm={() => void refund()}
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
                      value: <CreditTypeBadge type={payment.data.creditType} />,
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
                    event.status === 'REFUSED' ||
                    event.status === 'DISPUTED' ||
                    event.status === 'REFUNDED'
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
