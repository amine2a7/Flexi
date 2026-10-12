'use client';

import type { Schemas } from '@flexipay/api-client';
import { CircleCheck, CircleX, Hourglass } from 'lucide-react';
import dynamic from 'next/dynamic';
import { useLocale, useTranslations } from 'next-intl';
import { useEffect, useMemo, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { Amount } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Countdown } from '@/components/ui/countdown';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';

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
 * (no balance, no reason: COM-04).
 */
export default function CollectPage() {
  const t = useTranslations('merchant.collect');
  const tRoot = useTranslations();
  const locale = useLocale();
  const [code, setCode] = useState('');
  const [amountText, setAmountText] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [payment, setPayment] = useState<Payment | undefined>(undefined);
  const [declined, setDeclined] = useState(false);
  const [confirmCancel, setConfirmCancel] = useState(false);
  const [cancelling, setCancelling] = useState(false);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);

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
    return () => { clearInterval(timer); };
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
        {
          params: { path: { paymentId: payment.id } },
        },
      );
      if (data !== undefined) setPayment(data);
      else setError(problem);
    } finally {
      setCancelling(false);
      setConfirmCancel(false);
    }
  }

  const result = declined ? 'REFUSED' : payment?.status;
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="grid gap-6 lg:grid-cols-2">
        {result === undefined ? (
          <Card>
            <form
              onSubmit={(event) => void onSubmit(event)}
              className="flex flex-col gap-5"
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
                value={code}
                onChange={(event) => { setCode(event.target.value.replace(/\D/g, '')); }}
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
                value={amountText}
                onChange={(event) => { setAmountText(event.target.value); }}
              />
              <Button
                type="submit"
                loading={submitting}
                disabled={!codeValid || millimes === undefined || millimes === 0}
              >
                {t('submit')}
              </Button>
            </form>
          </Card>
        ) : (
          <Card>
            <div aria-live="polite" className="flex flex-col items-center gap-4 py-4 text-center">
              {result === 'INITIATED' && payment !== undefined ? (
                <>
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
                  <Button variant="secondary" onClick={() => { setConfirmCancel(true); }}>
                    {t('cancel')}
                  </Button>
                </>
              ) : null}
              {result === 'CONFIRMED' && payment !== undefined ? (
                <>
                  <CircleCheck aria-hidden="true" className="size-icon-lg text-emerald" />
                  <h2 className="text-title text-text">{t('acceptedTitle')}</h2>
                  <Amount millimes={payment.amountMillimes} size="amount-xl" />
                  <p className="text-body text-text-muted">
                    {t('acceptedReference', { reference: payment.reference })}
                  </p>
                  <Button onClick={restart}>{t('again')}</Button>
                </>
              ) : null}
              {result === 'REFUSED' ? (
                <>
                  <CircleX aria-hidden="true" className="size-icon-lg text-danger" />
                  <h2 className="text-title text-text">{t('refusedTitle')}</h2>
                  <p className="text-body text-text-muted">{t('refusedMessage')}</p>
                  <Button onClick={restart}>{t('again')}</Button>
                </>
              ) : null}
            </div>
          </Card>
        )}
        <div className="flex flex-col gap-4">
          <Alert tone="info" title={t('howTitle')}>
            {t('howMessage')}
          </Alert>
          {DemoCodes !== null ? <DemoCodes /> : null}
        </div>
      </div>
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
