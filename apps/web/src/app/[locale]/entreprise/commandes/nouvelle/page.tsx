'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useMemo, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { useRouter } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { formatMillimesWithCurrency, formatRateBps } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { AmountBreakdown } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import {
  CREDIT_TYPES,
  CreditTypeIcon,
  useCreditTypeLabel,
  type CreditType,
} from '@/components/ui/credit-type';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { useToast } from '@/components/ui/toast';

type Line = Schemas['CreditOrderLine'];

/**
 * Credit order with one amount per credit type (decision of 2026-10-13): fees summary computed by
 * the server, confirmation, then the order page (bank details, transfer declaration).
 */
export default function NewOrderPage() {
  const t = useTranslations('company.newOrder');
  const tFees = useTranslations('ui.fees');
  const tRoot = useTranslations();
  const tOrders = useTranslations('orders');
  const tTypes = useTranslations('ui.creditTypes');
  const typeLabel = useCreditTypeLabel();
  const router = useRouter();
  const toast = useToast();
  const locale = useLocale();
  const [texts, setTexts] = useState<Record<CreditType, string>>({
    RESTAURATION: '',
    HABILLEMENT: '',
    CARBURANT: '',
    CADEAUX: '',
  });
  const [quote, setQuote] = useState<Schemas['CreditOrderQuote'] | undefined>(undefined);
  const [quoting, setQuoting] = useState(false);
  const [confirming, setConfirming] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);

  const parsed = useMemo(
    () =>
      CREDIT_TYPES.map((creditType) => ({
        creditType,
        text: texts[creditType],
        millimes: texts[creditType].trim() === '' ? 0 : parseMillimes(texts[creditType], locale),
      })),
    [texts, locale],
  );
  const invalid = parsed.some((item) => item.millimes === undefined);
  const lines: Line[] = parsed.flatMap((item) =>
    item.millimes !== undefined && item.millimes > 0
      ? [{ creditType: item.creditType, amountMillimes: item.millimes }]
      : [],
  );

  async function onQuote(event: SyntheticEvent) {
    event.preventDefault();
    if (invalid || lines.length === 0) return;
    setQuoting(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/order-quotes', {
        body: { lines },
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
        body: { quoteId: quote.quoteId },
      });
      setConfirming(false);
      if (data === undefined) setError(problem);
      else {
        toast.notify('success', tOrders('company.createdToast', { reference: data.reference }));
        router.push(`/entreprise/commandes/${data.id}`);
      }
    } finally {
      setSending(false);
    }
  }

  const breakdown =
    quote === undefined
      ? []
      : [
          ...quote.lines.map((line) => ({
            label: typeLabel(line.creditType),
            millimes: line.amountMillimes,
          })),
          {
            label: t('fees'),
            note: formatRateBps(quote.feeRateBps, locale),
            millimes: quote.feesMillimes,
          },
          {
            label: tFees('vat'),
            note: formatRateBps(quote.vatRateBps, locale),
            millimes: quote.vatMillimes,
          },
          ...(quote.withholdingMillimes > 0
            ? [
                {
                  label: tFees('withholding'),
                  note: formatRateBps(quote.withholdingRateBps, locale),
                  millimes: quote.withholdingMillimes,
                },
              ]
            : []),
          {
            label: tFees('stamp'),
            millimes: quote.stampDutyMillimes,
          },
          {
            label: tFees('transfer'),
            millimes: quote.transferFeeMillimes,
          },
        ];
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardTitle description={t('linesHint')}>{t('linesTitle')}</CardTitle>
          <form
            onSubmit={(event) => void onQuote(event)}
            className="flex flex-col gap-5"
            noValidate
          >
            {parsed.map((item) => (
              <div key={item.creditType} className="flex items-start gap-3">
                <span className="mt-10 shrink-0 text-text-muted">
                  <CreditTypeIcon type={item.creditType} className="size-icon-md" />
                </span>
                <div className="flex-1">
                  <TextField
                    label={t('lineAmount', { type: typeLabel(item.creditType) })}
                    hint={
                      item.millimes === undefined || item.millimes === 0
                        ? t('amountHint')
                        : t('amountPreview', {
                            amount: formatMillimesWithCurrency(item.millimes, locale),
                          })
                    }
                    error={item.millimes === undefined ? t('amountInvalid') : undefined}
                    inputMode="decimal"
                    dir="ltr"
                    value={item.text}
                    onChange={(event) => {
                      const value = event.target.value;
                      setTexts((previous) => ({ ...previous, [item.creditType]: value }));
                      setQuote(undefined);
                    }}
                  />
                </div>
              </div>
            ))}
            {lines.length === 0 && !invalid ? (
              <p className="text-caption text-text-muted">{t('noLine')}</p>
            ) : null}
            <p className="text-caption text-text-muted">{tTypes('noTransfer')}</p>
            <Button
              type="submit"
              variant="secondary"
              loading={quoting}
              disabled={invalid || lines.length === 0}
            >
              {t('quote')}
            </Button>
          </form>
        </Card>
        <Card>
          <CardTitle>{t('summary')}</CardTitle>
          {error !== undefined ? (
            <Alert tone="danger">
              {(asProblem(error)?.details as { reason?: unknown } | undefined)?.reason ===
              'KYC_NOT_APPROVED'
                ? tRoot('account.kyc.notApproved')
                : tRoot(messageKey(errorMessageKey(error)))}
            </Alert>
          ) : null}
          {quote === undefined ? (
            <p className="text-body text-text-muted">{t('summaryEmpty')}</p>
          ) : (
            <div className="flex flex-col gap-5">
              <AmountBreakdown
                lines={breakdown}
                total={{ label: t('total'), millimes: quote.totalMillimes }}
              />
              <Button
                onClick={() => {
                  setConfirming(true);
                }}
              >
                {t('confirm')}
              </Button>
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
            lines={breakdown}
            total={{ label: t('total'), millimes: quote.totalMillimes }}
          />
        </ConfirmDialog>
      ) : null}
    </>
  );
}
