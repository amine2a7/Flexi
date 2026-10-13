'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowDownLeft, ChevronRight, Percent, Send, Wallet } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useMemo, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { formatMillimesWithCurrency, formatRateBps } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { Amount, AmountBreakdown } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { CreditTypeBadge, CreditTypeSelect, type CreditType } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { FilterBar } from '@/components/ui/filter-bar';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';

type Quote = Schemas['PayoutQuote'];
type Status = Schemas['PayoutRequestStatus'];
const STATUSES: readonly Status[] = ['REQUESTED', 'CHECKED', 'SENT', 'EXECUTED', 'REJECTED'];

/**
 * Payout request: simulation by the server (gross -> commission -> net, rate frozen until
 * `expiresAt`, rule 5), shown as three figures, confirmation with a recap, then the request
 * (Idempotency-Key). Each request opens its detail page with its history.
 */
export default function PayoutsPage() {
  const t = useTranslations('merchant.payouts');
  const tRoot = useTranslations();
  const tTypes = useTranslations('ui.creditTypes');
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
  const [status, setStatus] = useState('');
  const [typeFilter, setTypeFilter] = useState<CreditType | ''>('');
  const [creditType, setCreditType] = useState<CreditType>('RESTAURATION');
  const profile = useApiQuery(() => getApi().GET('/v1/merchant/profile'), []);
  const accepted = profile.status === 'success' ? profile.data.acceptedCreditTypes : [];
  const receivables = useApiQuery(
    () =>
      getApi().GET('/v1/merchant/receivables', {
        params: { query: { creditType, limit: 1 } },
      }),
    [creditType, refresh],
  );

  const millimes = useMemo(() => parseMillimes(amountText, locale), [amountText, locale]);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/merchant/payouts', {
        params: {
          query: {
            cursor,
            withCount,
            ...(status === '' ? {} : { status: status as Status }),
            ...(typeFilter === '' ? {} : { creditType: typeFilter }),
          },
        },
      }),
    [refresh, status, typeFilter],
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
        body: { creditType, grossMillimes: millimes },
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
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatDateTime(row.requestedAt, locale),
      sortValue: (row) => row.requestedAt,
    },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => (
        <Link
          href={`/commercant/virements/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.reference}
        </Link>
      ),
      sortValue: (row) => row.reference,
    },
    {
      key: 'creditType',
      header: tTypes('column'),
      cell: (row) => <CreditTypeBadge type={row.creditType} />,
      sortValue: (row) => row.creditType,
    },
    {
      key: 'gross',
      header: t('gross'),
      align: 'end',
      cell: (row) => <Amount millimes={row.grossMillimes} />,
      sortValue: (row) => row.grossMillimes,
    },
    {
      key: 'net',
      header: t('net'),
      align: 'end',
      cell: (row) => <Amount millimes={row.netMillimes} />,
      sortValue: (row) => row.netMillimes,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} context="payout" />,
      sortValue: (row) => row.status,
    },
    {
      key: 'open',
      header: t('action'),
      align: 'end',
      cell: (row) => (
        <Link
          href={`/commercant/virements/${row.id}`}
          className={buttonClasses('ghost', 'sm')}
          aria-label={t('openPayout', { reference: row.reference })}
        >
          {t('open')}
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];

  const conflict = asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT';
  const pending = <span className="text-body text-text-muted">{t('pending')}</span>;
  const available =
    quote?.availableMillimes ??
    (receivables.status === 'success' ? receivables.data.totalMillimes : undefined);
  const breakdown =
    quote === undefined
      ? []
      : [
          { label: t('gross'), millimes: quote.grossMillimes },
          {
            label: t('commission'),
            note: formatRateBps(quote.commissionRateBps, locale),
            millimes: quote.commissionMillimes,
            sign: 'debit' as const,
          },
        ];

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="mb-6 grid gap-4 md:grid-cols-3">
        <StatCard
          label={t('available')}
          value={available === undefined ? pending : <Amount millimes={available} size="title" />}
          hint={t('availableHint')}
          icon={<Wallet className="size-icon-md" />}
          tone="positive"
        />
        <StatCard
          label={t('commission')}
          value={
            quote === undefined ? (
              pending
            ) : (
              <Amount millimes={quote.commissionMillimes} size="title" />
            )
          }
          hint={
            quote === undefined
              ? undefined
              : t('commissionHint', {
                  rate: formatRateBps(quote.commissionRateBps, locale),
                  time: formatDateTime(quote.expiresAt, locale),
                })
          }
          icon={<Percent className="size-icon-md" />}
        />
        <StatCard
          label={t('net')}
          value={
            quote === undefined ? pending : <Amount millimes={quote.netMillimes} size="title" />
          }
          hint={t('netHintNoIban')}
          icon={<ArrowDownLeft className="size-icon-md rtl:-scale-x-100" />}
        />
      </div>

      <Card className="mb-6">
        <CardTitle>{t('simulate')}</CardTitle>
        <div className="grid gap-6 lg:grid-cols-2">
          <form
            onSubmit={(event) => void onSimulate(event)}
            className="flex flex-col gap-5"
            noValidate
          >
            <CreditTypeSelect
              label={t('creditType')}
              hint={t('creditTypeHint')}
              types={accepted.length === 0 ? undefined : accepted}
              value={creditType}
              onChange={(value) => {
                if (value !== '') setCreditType(value);
                setQuote(undefined);
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
              dir="ltr"
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
          <div className="flex flex-col gap-4">
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
              <>
                <AmountBreakdown
                  lines={breakdown}
                  total={{ label: t('net'), millimes: quote.netMillimes }}
                />
                <Button
                  icon={<Send aria-hidden="true" className="size-icon-sm rtl:-scale-x-100" />}
                  onClick={() => {
                    setConfirming(true);
                  }}
                >
                  {t('request')}
                </Button>
              </>
            ) : null}
          </div>
        </div>
      </Card>

      <Card>
        <CardTitle>{t('listTitle')}</CardTitle>
        <FilterBar
          statusLabel={t('filterStatus')}
          statusOptions={STATUSES.map((value) => ({
            value,
            label: tRoot(messageKey(`statusLabel.${value}`)),
          }))}
          withCreditType
          onApply={(filters) => {
            setStatus(filters.status);
            setTypeFilter(filters.creditType);
          }}
        />
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
            lines={breakdown}
            total={{ label: t('net'), millimes: quote.netMillimes }}
          />
        </ConfirmDialog>
      ) : null}
    </>
  );
}
