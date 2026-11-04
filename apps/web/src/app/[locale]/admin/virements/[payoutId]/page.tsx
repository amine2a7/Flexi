'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft, Check, X } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { useCallback, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { formatMillimesWithCurrency, formatRateBps } from '@/lib/format/money';
import { isStateConflict, ReasonDialog } from '@/components/orders/order-parts';
import { AmountBreakdown } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

type Payout = Schemas['AdminPayoutRequestDetail'];

/** Merchant payout request: gross, commission, net and IBAN; approve (next batch) or reject. */
export default function AdminPayoutPage() {
  const { payoutId } = useParams<{ payoutId: string }>();
  const t = useTranslations('admin.payouts');
  const query = useApiQuery(
    () => getApi().GET('/v1/admin/payout-requests/{payoutId}', { params: { path: { payoutId } } }),
    [payoutId],
  );
  const [updated, setUpdated] = useState<Payout | undefined>(undefined);
  const payout = updated ?? (query.status === 'success' ? query.data : undefined);
  const { reload: reloadQuery } = query;
  const reload = useCallback(() => {
    setUpdated(undefined);
    reloadQuery();
  }, [reloadQuery]);

  return (
    <>
      <Link href="/admin/virements" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {payout === undefined && query.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {payout === undefined && query.status === 'error' ? (
        <ErrorState error={query.error} onRetry={query.reload} />
      ) : null}
      {payout !== undefined ? (
        <PayoutView payout={payout} onChange={setUpdated} onConflict={reload} />
      ) : null}
    </>
  );
}

function PayoutView({
  payout,
  onChange,
  onConflict,
}: {
  payout: Payout;
  onChange: (payout: Payout) => void;
  onConflict: () => void;
}) {
  const t = useTranslations('admin.payouts');
  const tTypes = useTranslations('ui.creditTypes');
  const tFees = useTranslations('ui.fees');
  const tRoot = useTranslations();
  const canDecide = useCan('payouts.decide');
  const locale = useLocale();
  const toast = useToast();
  const [dialog, setDialog] = useState<'approve' | 'reject' | undefined>(undefined);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);

  function settle(result: { data?: Payout; error?: unknown }, message: string): unknown {
    if (result.data !== undefined) {
      setDialog(undefined);
      toast.notify('success', message);
      onChange(result.data);
      return undefined;
    }
    if (isStateConflict(result.error)) {
      setDialog(undefined);
      toast.notify('error', tRoot('orders.conflict'));
      onConflict();
      return undefined;
    }
    return result.error;
  }

  async function approve() {
    setSaving(true);
    setError(undefined);
    try {
      const problem = settle(
        await getApi().POST('/v1/admin/payout-requests/{payoutId}/approve', {
          params: { path: { payoutId: payout.id }, header: { 'Idempotency-Key': intentKey } },
        }),
        t('approvedToast'),
      );
      if (problem !== undefined) {
        setDialog(undefined);
        setError(problem);
      }
    } finally {
      setSaving(false);
    }
  }

  const breakdown = (
    <AmountBreakdown
      lines={[
        { label: t('gross'), millimes: payout.grossMillimes },
        {
          label: t('commission'),
          note: formatRateBps(payout.commissionRateBps, locale),
          millimes: payout.commissionMillimes,
          sign: 'debit',
        },
        {
          label: tFees('vat'),
          note: formatRateBps(payout.vatRateBps, locale),
          millimes: payout.vatMillimes,
          sign: 'debit',
        },
        { label: tFees('stamp'), millimes: payout.stampDutyMillimes, sign: 'debit' },
      ]}
      total={{ label: t('net'), millimes: payout.netMillimes }}
    />
  );

  return (
    <>
      <PageHeader
        title={t('detailTitle', { reference: payout.reference })}
        description={payout.merchantName}
        actions={<StatusBadge status={payout.status} context="payout" />}
      />
      <div className="flex flex-col gap-6">
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        {payout.status === 'REQUESTED' && canDecide ? (
          <Card>
            <div className="flex flex-col gap-4">
              <Alert tone="warning">{t('pendingInfo')}</Alert>
              <div className="flex flex-wrap justify-end gap-3">
                <Button
                  variant="secondary"
                  icon={<X aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setIntentKey(newIdempotencyKey());
                    setDialog('reject');
                  }}
                >
                  {t('reject')}
                </Button>
                <Button
                  variant="success"
                  icon={<Check aria-hidden="true" className="size-icon-sm" />}
                  onClick={() => {
                    setIntentKey(newIdempotencyKey());
                    setDialog('approve');
                  }}
                >
                  {t('approve')}
                </Button>
              </div>
            </div>
          </Card>
        ) : null}
        {payout.batchId !== undefined && payout.batchReference !== undefined ? (
          <Alert tone="info">
            <span className="flex flex-wrap items-center gap-3">
              {t('batchInfo', { reference: payout.batchReference })}
              <Link href={`/admin/reglements/${payout.batchId}`} className="font-label underline">
                {t('seeBatch')}
              </Link>
            </span>
          </Alert>
        ) : null}
        <div className="grid gap-6 lg:grid-cols-2">
          <Card>
            <CardTitle>{t('detailTitle', { reference: payout.reference })}</CardTitle>
            <div className="flex flex-col gap-5">
              <DescriptionList
                items={[
                  { label: t('merchant'), value: payout.merchantName },
                  { label: tTypes('column'), value: <CreditTypeBadge type={payout.creditType} /> },
                  { label: t('requestedAt'), value: formatDateTime(payout.requestedAt, locale) },
                  {
                    label: t('iban'),
                    value: (
                      <code dir="ltr" className="break-all text-body font-label">
                        {payout.iban}
                      </code>
                    ),
                  },
                  { label: t('rate'), value: formatRateBps(payout.commissionRateBps, locale) },
                ]}
              />
              {breakdown}
            </div>
          </Card>
          <Card>
            <CardTitle>{t('historyTitle')}</CardTitle>
            <Timeline
              entries={payout.history.map((event, index) => ({
                key: `${event.status}-${String(index)}`,
                title: t(`event.${event.status}`),
                meta: formatDateTime(event.occurredAt, locale),
                ...(event.reason === undefined ? {} : { detail: event.reason }),
                tone: event.status === 'REJECTED' ? 'danger' : 'default',
              }))}
            />
          </Card>
        </div>
      </div>
      <ConfirmDialog
        open={dialog === 'approve'}
        onOpenChange={(open) => {
          setDialog(open ? 'approve' : undefined);
        }}
        title={t('approveTitle', { reference: payout.reference })}
        description={t('approveMessage', {
          net: formatMillimesWithCurrency(payout.netMillimes, locale),
          merchant: payout.merchantName,
          iban: payout.iban,
        })}
        confirmLabel={t('approve')}
        confirmVariant="success"
        loading={saving}
        onConfirm={() => void approve()}
      >
        {breakdown}
      </ConfirmDialog>
      {dialog === 'reject' ? (
        <ReasonDialog
          title={t('rejectTitle', { reference: payout.reference })}
          label={t('rejectReason')}
          confirmLabel={t('reject')}
          onClose={() => {
            setDialog(undefined);
          }}
          onSubmit={async (reason) =>
            settle(
              await getApi().POST('/v1/admin/payout-requests/{payoutId}/reject', {
                params: { path: { payoutId: payout.id }, header: { 'Idempotency-Key': intentKey } },
                body: { reason },
              }),
              t('rejectedToast'),
            )
          }
        />
      ) : null}
    </>
  );
}
