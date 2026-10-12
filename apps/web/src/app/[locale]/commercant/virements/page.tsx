'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useMemo, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { formatMillimesWithCurrency, formatRateBps } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { Amount, AmountBreakdown } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';

type Quote = Schemas['PayoutQuote'];

/**
 * Payout request: simulation by the server (gross -> commission -> net, rate frozen until
 * `expiresAt`, rule 5), confirmation with a recap, then the request (Idempotency-Key).
 */
export default function PayoutsPage() {
  const t = useTranslations('merchant.payouts');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [amountText, setAmountText] = useState('');
  const [quote, setQuote] = useState<Quote | undefined>(undefined);
  const [quoting, setQuoting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [confirming, setConfirming] = useState(false);
  const [sending, setSending] = useState(false);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);
  const [created, setCreated] = useState<Schemas['PayoutRequest'] | undefined>(undefined);
  const [refresh, setRefresh] = useState(0);

  const millimes = useMemo(() => parseMillimes(amountText, locale), [amountText, locale]);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/merchant/payouts', { params: { query: { cursor, withCount } } }),
    [refresh],
  );

  async function onSimulate(event: SyntheticEvent) {
    event.preventDefault();
    if (millimes === undefined) return;
    setQuoting(true);
    setError(undefined);
    setQuote(undefined);
    setCreated(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/merchant/payout-quotes', {
        body: { grossMillimes: millimes },
      });
      if (data !== undefined) {
        setQuote(data);
        setIntentKey(newIdempotencyKey());
      } else {
        setError(problem);
      }
    } finally {
      setQuoting(false);
    }
  }

  async function onRequest() {
    if (quote === undefined) return;
    setSending(true);
    try {
      const { data, error: problem } = await getApi().POST('/v1/merchant/payouts', {
        params: { header: { 'Idempotency-Key': intentKey } },
        body: { quoteId: quote.quoteId },
      });
      setConfirming(false);
      if (data === undefined) {
        setError(problem);
        if (asProblem(problem)?.code === 'RESOURCE_STATE_CONFLICT') setQuote(undefined);
        return;
      }
      setCreated(data);
      setQuote(undefined);
      setAmountText('');
      setRefresh((value) => value + 1);
      toast.notify('success', t('createdToast', { reference: data.reference }));
    } finally {
      setSending(false);
    }
  }

  const columns: Column<Schemas['PayoutRequest']>[] = [
    { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.requestedAt, locale) },
    { key: 'reference', header: t('reference'), cell: (row) => row.reference },
    {
      key: 'gross',
      header: t('gross'),
      align: 'end',
      cell: (row) => <Amount millimes={row.grossMillimes} />,
    },
    {
      key: 'net',
      header: t('net'),
      align: 'end',
      cell: (row) => <Amount millimes={row.netMillimes} />,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} context="payout" />,
    },
  ];

  const conflict = asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT';
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="mb-6 grid gap-6 lg:grid-cols-2">
        <Card>
          <CardTitle>{t('simulate')}</CardTitle>
          <form
            onSubmit={(event) => void onSimulate(event)}
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
              {t('simulateSubmit')}
            </Button>
          </form>
        </Card>
        <Card>
          <CardTitle>{t('summary')}</CardTitle>
          {error !== undefined ? (
            <Alert tone="danger">
              {conflict ? t('conflict') : tRoot(messageKey(errorMessageKey(error)))}
            </Alert>
          ) : null}
          {created !== undefined ? (
            <Alert tone="success" title={t('createdTitle')}>
              {t('createdMessage', { reference: created.reference })}
            </Alert>
          ) : null}
          {quote === undefined && created === undefined && error === undefined ? (
            <p className="text-body text-text-muted">{t('summaryEmpty')}</p>
          ) : null}
          {quote !== undefined ? (
            <div className="flex flex-col gap-5">
              <AmountBreakdown
                lines={[
                  { label: t('gross'), millimes: quote.grossMillimes },
                  {
                    label: t('commission'),
                    note: formatRateBps(quote.commissionRateBps, locale),
                    millimes: quote.commissionMillimes,
                    sign: 'debit',
                  },
                ]}
                total={{ label: t('net'), millimes: quote.netMillimes }}
              />
              <p className="text-caption text-text-muted">
                {t('frozen', { time: formatDateTime(quote.expiresAt, locale) })}
              </p>
              <Button onClick={() => { setConfirming(true); }}>{t('request')}</Button>
            </div>
          ) : null}
        </Card>
      </div>
      <Card>
        <CardTitle>{t('listTitle')}</CardTitle>
        <DataTable
          caption={t('listTitle')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('emptyTitle'), message: t('emptyMessage') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
      {quote !== undefined ? (
        <ConfirmDialog
          open={confirming}
          onOpenChange={setConfirming}
          title={t('confirmTitle')}
          description={t('confirmMessage')}
          confirmLabel={t('confirmSubmit', {
            amount: formatMillimesWithCurrency(quote.netMillimes, locale),
          })}
          loading={sending}
          onConfirm={() => void onRequest()}
        >
          <AmountBreakdown
            lines={[
              { label: t('gross'), millimes: quote.grossMillimes },
              {
                label: t('commission'),
                note: formatRateBps(quote.commissionRateBps, locale),
                millimes: quote.commissionMillimes,
                sign: 'debit',
              },
            ]}
            total={{ label: t('net'), millimes: quote.netMillimes }}
          />
        </ConfirmDialog>
      ) : null}
    </>
  );
}
