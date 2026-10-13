'use client';

import type { Schemas } from '@flexipay/api-client';
import { HandCoins, Hourglass, Smartphone } from 'lucide-react';
import dynamic from 'next/dynamic';
import { useLocale, useTranslations } from 'next-intl';
import { useEffect, useMemo, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatMillimesWithCurrency, formatRateBps } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Countdown } from '@/components/ui/countdown';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { ResultScreen } from '@/components/ui/result-screen';
import { useToast } from '@/components/ui/toast';

const DemoCodes =
  process.env.NODE_ENV !== 'production'
    ? dynamic(() => import('@/components/dev/demo-codes').then((module) => module.DemoCodes))
    : null;

type Payment = Schemas['MerchantPayment'];
const POLL_MS = 1500;
const VALIDITY_SECONDS = 60;

/**
 * Collect a payment (decision 17): the merchant types the customer's 8-digit code and the amount,
 * the customer confirms on the phone, the merchant only sees « accepted » or « refused »
 * (no balance, no reason: COM-04). The result is shown full screen (green / red).
 */
export default function CollectPage() {
  const t = useTranslations('merchant.collect');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [code, setCode] = useState('');
  const [amountText, setAmountText] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [payment, setPayment] = useState<Payment | undefined>(undefined);
  const [declined, setDeclined] = useState(false);
  const [confirmCancel, setConfirmCancel] = useState(false);
  const [cancelling, setCancelling] = useState(false);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);
  const dashboard = useApiQuery(() => getApi().GET('/v1/merchant/dashboard'), []);

  const millimes = useMemo(() => parseMillimes(amountText, locale), [amountText, locale]);
  const codeValid = /^[0-9]{8}$/.test(code);

  useEffect(() => {
    if (payment?.status !== 'INITIATED') return undefined;
    const timer = setInterval(() => {
      void getApi()
        .GET('/v1/merchant/payments/{paymentId}', { params: { path: { paymentId: payment.id } } })
        .then(({ data }) => {
          if (data !== undefined && data.status !== 'INITIATED') setPayment(data);
        });
    }, POLL_MS);
    return () => {
      clearInterval(timer);
    };
  }, [payment]);

  function restart() {
    setPayment(undefined);
    setDeclined(false);
    setError(undefined);
    setCode('');
    setAmountText('');
    setIntentKey(newIdempotencyKey());
  }

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    if (millimes === undefined || !codeValid) return;
    setSubmitting(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/merchant/payments', {
        params: { header: { 'Idempotency-Key': intentKey } },
        body: { customerCode: code, amountMillimes: millimes },
      });
      if (data !== undefined) setPayment(data);
      else if (asProblem(problem)?.code === 'PAYMENT_DECLINED') setDeclined(true);
      else setError(problem);
    } catch (reason) {
      setError(reason);
    } finally {
      setSubmitting(false);
    }
  }

  async function onCancel() {
    if (payment === undefined) return;
    setCancelling(true);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/merchant/payments/{paymentId}/cancel',
        { params: { path: { paymentId: payment.id } } },
      );
      if (data !== undefined) {
        restart();
        toast.notify('info', t('cancelledToast'));
      } else setError(problem);
    } finally {
      setCancelling(false);
      setConfirmCancel(false);
    }
  }

  const result = declined ? 'REFUSED' : payment?.status;
  const rate =
    dashboard.status === 'success'
      ? formatRateBps(dashboard.data.commissionRateBps, locale)
      : undefined;
  const resultActions = (
    <>
      <Button variant="secondary" onClick={restart}>
        {t('again')}
      </Button>
      <Link href="/commercant" className={buttonClasses('ghost', 'md', 'text-current')}>
        {t('backToDashboard')}
      </Link>
    </>
  );

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <div className="grid gap-6 lg:grid-cols-2">
          <div className="flex flex-col items-center justify-center gap-4 rounded-card-desktop bg-bg p-6 text-center">
            <span
              aria-hidden="true"
              className="flex size-illustration items-center justify-center rounded-card-mobile bg-surface text-navy shadow-card"
            >
              <Smartphone className="size-avatar-lg" strokeWidth={1.5} />
            </span>
            <h2 className="text-title-sm text-text">{t('panelTitle')}</h2>
            <ol className="flex flex-col gap-2 text-start text-body text-text-muted">
              {(['step1', 'step2', 'step3'] as const).map((step, index) => (
                <li key={step} className="flex gap-3">
                  <span className="flex size-icon-lg shrink-0 items-center justify-center rounded-badge bg-navy text-micro text-on-navy">
                    {index + 1}
                  </span>
                  {t(step)}
                </li>
              ))}
            </ol>
          </div>

          {result === 'INITIATED' && payment !== undefined ? (
            <div aria-live="polite" className="flex flex-col items-center gap-4 py-4 text-center">
              <Hourglass aria-hidden="true" className="size-icon-lg text-info" />
              <h2 className="text-title text-text">{t('waitingTitle')}</h2>
              <p className="text-body text-text-muted">{t('waitingMessage')}</p>
              <dl className="flex w-full flex-col gap-2 rounded-card-desktop bg-bg p-4 text-start">
                <div className="flex justify-between gap-3">
                  <dt className="text-caption text-text-muted">{t('customer')}</dt>
                  <dd className="text-body">
                    {`${payment.customer.firstName} ${payment.customer.lastInitial}. · ${payment.customer.maskedEmployeeNumber}`}
                  </dd>
                </div>
                <div className="flex justify-between gap-3">
                  <dt className="text-caption text-text-muted">{t('amount')}</dt>
                  <dd>
                    <Amount millimes={payment.amountMillimes} size="title" />
                  </dd>
                </div>
              </dl>
              {payment.expiresAt !== null ? (
                <div className="w-full">
                  <Countdown expiresAt={payment.expiresAt} total={VALIDITY_SECONDS} />
                </div>
              ) : null}
              <Button
                variant="secondary"
                onClick={() => {
                  setConfirmCancel(true);
                }}
              >
                {t('cancel')}
              </Button>
            </div>
          ) : (
            <form
              onSubmit={(event) => void onSubmit(event)}
              className="flex flex-col justify-center gap-5"
              noValidate
            >
              {error !== undefined ? (
                <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
              ) : null}
              <TextField
                label={t('code')}
                hint={t('codeHint')}
                inputMode="numeric"
                autoComplete="off"
                maxLength={8}
                dir="ltr"
                value={code}
                onChange={(event) => {
                  setCode(event.target.value.replace(/\D/g, ''));
                }}
              />
              <TextField
                label={t('amount')}
                hint={
                  millimes === undefined
                    ? t('amountHint')
                    : t('amountPreview', { amount: formatMillimesWithCurrency(millimes, locale) })
                }
                error={amountText !== '' && millimes === undefined ? t('amountInvalid') : undefined}
                inputMode="decimal"
                autoComplete="off"
                dir="ltr"
                value={amountText}
                onChange={(event) => {
                  setAmountText(event.target.value);
                }}
              />
              <Button
                type="submit"
                loading={submitting}
                disabled={!codeValid || millimes === undefined || millimes === 0}
                icon={<HandCoins aria-hidden="true" className="size-icon-md" />}
              >
                {t('submit')}
              </Button>
              {rate !== undefined ? (
                <p className="text-caption text-text-muted">{t('ruleNote', { rate })}</p>
              ) : null}
            </form>
          )}
        </div>
      </Card>
      {DemoCodes !== null ? (
        <div className="mt-6">
          <DemoCodes />
        </div>
      ) : null}

      {result === 'CONFIRMED' && payment !== undefined ? (
        <ResultScreen
          tone="success"
          title={t('acceptedTitle')}
          description={t('acceptedMessage')}
          actions={resultActions}
        >
          <p className="text-amount-xl tabular-nums" dir="ltr">
            {formatMillimesWithCurrency(payment.amountMillimes, locale)}
          </p>
          <p className="text-body-lg">{t('acceptedReference', { reference: payment.reference })}</p>
        </ResultScreen>
      ) : null}
      {result === 'REFUSED' ? (
        <ResultScreen
          tone="danger"
          title={t('refusedTitle')}
          description={t('refusedMessage')}
          actions={resultActions}
        />
      ) : null}

      <ConfirmDialog
        open={confirmCancel}
        onOpenChange={setConfirmCancel}
        title={t('cancelTitle')}
        description={t('cancelMessage')}
        confirmLabel={t('cancelConfirm')}
        confirmVariant="danger"
        loading={cancelling}
        onConfirm={() => void onCancel()}
      />
    </>
  );
}
