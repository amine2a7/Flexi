'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useMemo, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { formatMillimesWithCurrency, formatRateBps } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { AmountBreakdown } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';

/** Credit order: fees summary computed by the server, confirmation, then the transfer reference. */
export default function NewOrderPage() {
  const t = useTranslations('company.newOrder');
  const tRoot = useTranslations();
  const locale = useLocale();
  const [amountText, setAmountText] = useState('');
  const [quote, setQuote] = useState<Schemas['CreditOrderQuote'] | undefined>(undefined);
  const [quoting, setQuoting] = useState(false);
  const [confirming, setConfirming] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [order, setOrder] = useState<Schemas['CreditOrder'] | undefined>(undefined);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);
  const millimes = useMemo(() => parseMillimes(amountText, locale), [amountText, locale]);

  async function onQuote(event: SyntheticEvent) {
    event.preventDefault();
    if (millimes === undefined) return;
    setQuoting(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/order-quotes', {
        body: { amountMillimes: millimes },
      });
      if (data === undefined) setError(problem);
      else {
        setQuote(data);
        setIntentKey(newIdempotencyKey());
      }
    } finally {
      setQuoting(false);
    }
  }

  async function onOrder() {
    if (quote === undefined) return;
    setSending(true);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/orders', {
        params: { header: { 'Idempotency-Key': intentKey } },
        body: { amountMillimes: quote.amountMillimes },
      });
      setConfirming(false);
      if (data === undefined) setError(problem);
      else setOrder(data);
    } finally {
      setSending(false);
    }
  }

  if (order !== undefined) {
    return (
      <>
        <PageHeader title={t('doneTitle')} />
        <Card>
          <div className="flex flex-col gap-5">
            <Alert tone="success" title={t('doneTitle')}>
              {t('doneMessage', {
                amount: formatMillimesWithCurrency(order.totalMillimes, locale),
                reference: order.paymentReference,
              })}
            </Alert>
            <div className="flex flex-wrap gap-3">
              <Link href="/entreprise/commandes" className={buttonClasses('primary')}>
                {t('backToOrders')}
              </Link>
              <Button
                variant="secondary"
                onClick={() => {
                  setOrder(undefined);
                  setQuote(undefined);
                  setAmountText('');
                }}
              >
                {t('another')}
              </Button>
            </div>
          </div>
        </Card>
      </>
    );
  }

  const lines =
    quote === undefined
      ? []
      : [
          { label: t('credits'), millimes: quote.amountMillimes },
          {
            label: t('fees'),
            note: formatRateBps(quote.feeRateBps, locale),
            millimes: quote.feesMillimes,
          },
        ];
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <form
            onSubmit={(event) => void onQuote(event)}
            className="flex flex-col gap-5"
            noValidate
          >
            <TextField
              label={t('amount')}
              hint={
                millimes === undefined
                  ? t('amountHint')
                  : t('amountPreview', { amount: formatMillimesWithCurrency(millimes, locale) })
              }
              error={amountText !== '' && millimes === undefined ? t('amountInvalid') : undefined}
              inputMode="decimal"
              value={amountText}
              onChange={(event) => {
                setAmountText(event.target.value);
                setQuote(undefined);
              }}
            />
            <Button
              type="submit"
              variant="secondary"
              loading={quoting}
              disabled={millimes === undefined || millimes === 0}
            >
              {t('quote')}
            </Button>
          </form>
        </Card>
        <Card>
          <CardTitle>{t('summary')}</CardTitle>
          {error !== undefined ? (
            <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
          ) : null}
          {quote === undefined ? (
            <p className="text-body text-text-muted">{t('summaryEmpty')}</p>
          ) : (
            <div className="flex flex-col gap-5">
              <AmountBreakdown
                lines={lines}
                total={{ label: t('total'), millimes: quote.totalMillimes }}
              />
              <Button onClick={() => setConfirming(true)}>{t('confirm')}</Button>
            </div>
          )}
        </Card>
      </div>
      {quote !== undefined ? (
        <ConfirmDialog
          open={confirming}
          onOpenChange={setConfirming}
          title={t('confirmTitle')}
          description={t('confirmMessage')}
          confirmLabel={t('confirmSubmit', {
            amount: formatMillimesWithCurrency(quote.totalMillimes, locale),
          })}
          loading={sending}
          onConfirm={() => void onOrder()}
        >
          <AmountBreakdown
            lines={lines}
            total={{ label: t('total'), millimes: quote.totalMillimes }}
          />
        </ConfirmDialog>
      ) : null}
    </>
  );
}
