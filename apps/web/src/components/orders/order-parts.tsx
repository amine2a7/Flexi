'use client';

import type { Schemas } from '@flexipay/api-client';
import { Copy, Download, FileText } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useEffect, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { getApi } from '@/lib/api/client';
import { formatCalendarDate, formatDateTime } from '@/lib/format/date';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { TextField } from '@/components/ui/field';
import { Alert, DescriptionList } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';

export type Order = Schemas['CreditOrderDetail'];

export const ORDER_STATUSES: readonly Schemas['OrderStatus'][] = [
  'AWAITING_CONFIRMATION',
  'AWAITING_PAYMENT',
  'AWAITING_VALIDATION',
  'VALIDATED',
  'REFUSED',
  'CANCELLED',
];

/** Statuses waiting for an admin action (highlighted in the admin list). */
export const ADMIN_ACTION_STATUSES: readonly Schemas['OrderStatus'][] = [
  'AWAITING_CONFIRMATION',
  'AWAITING_VALIDATION',
];

export function OrderStatusBadge({ status }: { status: Schemas['OrderStatus'] }) {
  return <StatusBadge status={status} context="order" />;
}

/** True when the server answered that the order changed meanwhile (409). */
export function isStateConflict(error: unknown): boolean {
  return asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT';
}

export function OrderSummaryCard({ order, showCompany }: { order: Order; showCompany: boolean }) {
  const t = useTranslations('orders.fields');
  const tOrders = useTranslations('orders');
  const locale = useLocale();
  return (
    <Card>
      <CardTitle action={<OrderStatusBadge status={order.status} />}>
        {tOrders('summary')}
      </CardTitle>
      <DescriptionList
        items={[
          { label: t('reference'), value: <span dir="ltr">{order.reference}</span> },
          ...(showCompany ? [{ label: t('company'), value: order.companyName }] : []),
          { label: t('createdAt'), value: formatDateTime(order.createdAt, locale) },
          { label: t('credits'), value: <Amount millimes={order.amountMillimes} /> },
          { label: t('fees'), value: <Amount millimes={order.feesMillimes} /> },
          {
            label: t('total'),
            value: <Amount millimes={order.totalMillimes} size="title" />,
          },
          {
            label: t('paymentReference'),
            value: (
              <code dir="ltr" className="text-body font-label">
                {order.paymentReference}
              </code>
            ),
          },
        ]}
      />
    </Card>
  );
}

/** FlexiPay bank account (server configuration) with a copy button on each value. */
export function FundingAccountCard({ paymentReference }: { paymentReference: string }) {
  const t = useTranslations('orders.bank');
  const toast = useToast();
  const account = useApiQuery(() => getApi().GET('/v1/company/funding-account'), []);

  async function copy(label: string, value: string) {
    try {
      await navigator.clipboard.writeText(value);
      toast.notify('success', t('copied', { field: label }));
    } catch {
      toast.notify('error', t('copyFailed'));
    }
  }

  const rows =
    account.status === 'success'
      ? [
          { key: 'bankName', label: t('bankName'), value: account.data.bankName, copy: false },
          { key: 'holder', label: t('holder'), value: account.data.holder, copy: true },
          { key: 'rib', label: t('rib'), value: account.data.rib, copy: true },
          { key: 'iban', label: t('iban'), value: account.data.iban, copy: true },
        ]
      : [];
  return (
    <Card>
      <CardTitle>{t('title')}</CardTitle>
      <p className="mb-4 text-body text-text-muted">
        {t('description', { reference: paymentReference })}
      </p>
      {account.status === 'loading' ? <LoadingBlock lines={4} /> : null}
      {account.status === 'error' ? <Alert tone="danger">{t('copyFailed')}</Alert> : null}
      <dl className="flex flex-col gap-3">
        {rows.map((row) => (
          <div
            key={row.key}
            className="flex flex-wrap items-center justify-between gap-2 border-b border-border pb-3"
          >
            <div className="flex min-w-0 flex-col gap-1">
              <dt className="text-caption text-text-muted">{row.label}</dt>
              <dd className="break-all text-body font-label text-text" dir="ltr">
                {row.value}
              </dd>
            </div>
            {row.copy ? (
              <Button
                variant="secondary"
                size="sm"
                icon={<Copy aria-hidden="true" className="size-icon-sm" />}
                aria-label={t('copyLabel', { field: row.label })}
                onClick={() => void copy(row.label, row.value)}
              >
                {t('copy')}
              </Button>
            ) : null}
          </div>
        ))}
      </dl>
    </Card>
  );
}

type ProofLoader = () => Promise<{ data?: Blob; error?: unknown }>;

/** Transfer proof: inline preview of an image, download link for every type. */
function ProofViewer({
  load,
  proof,
  reference,
}: {
  load: ProofLoader;
  proof: Schemas['TransferProof'];
  reference: string;
}) {
  const t = useTranslations('orders.proof');
  const [state, setState] = useState<
    { status: 'loading' } | { status: 'error' } | { status: 'ready'; url: string; image: boolean }
  >({ status: 'loading' });

  useEffect(() => {
    let active = true;
    let url: string | undefined;
    load()
      .then(({ data }) => {
        if (!active) return;
        if (data === undefined) {
          setState({ status: 'error' });
          return;
        }
        url = URL.createObjectURL(data);
        setState({ status: 'ready', url, image: data.type.startsWith('image/') });
      })
      .catch(() => {
        if (active) setState({ status: 'error' });
      });
    return () => {
      active = false;
      if (url !== undefined) URL.revokeObjectURL(url);
    };
  }, [load]);

  const sizeKb = Math.max(1, Math.round(proof.sizeBytes / 1024));
  return (
    <div className="flex flex-col gap-3">
      <p className="flex items-center gap-2 text-caption text-text-muted">
        <FileText aria-hidden="true" className="size-icon-sm" />
        <span dir="ltr">{t('size', { name: proof.fileName, size: sizeKb })}</span>
      </p>
      {state.status === 'loading' ? (
        <p className="text-body text-text-muted">{t('loading')}</p>
      ) : null}
      {state.status === 'error' ? <Alert tone="danger">{t('error')}</Alert> : null}
      {state.status === 'ready' ? (
        <>
          {!state.image ? (
            <p className="text-body text-text-muted">{t('pdf')}</p>
          ) : (
            // eslint-disable-next-line @next/next/no-img-element -- local blob, not optimisable
            <img
              src={state.url}
              alt={t('alt', { reference })}
              className="w-full max-w-form-max-width rounded-card-desktop border border-border object-contain"
            />
          )}
          <a
            href={state.url}
            download={proof.fileName}
            className={buttonClasses('secondary', 'sm')}
          >
            <Download aria-hidden="true" className="size-icon-sm" />
            {t('download')}
          </a>
        </>
      ) : null}
    </div>
  );
}

/** Declared transfer with its proof; the amount gap is highlighted for the admin. */
export function DeclarationCard({
  order,
  loadProof,
  warnOnMismatch,
}: {
  order: Order;
  loadProof: ProofLoader;
  warnOnMismatch: boolean;
}) {
  const t = useTranslations('orders.declaration');
  const tAdmin = useTranslations('orders.admin');
  const tProof = useTranslations('orders.proof');
  const locale = useLocale();
  const declaration = order.declaration;
  if (declaration === undefined) return null;
  const gap = declaration.amountMillimes - order.totalMillimes;
  return (
    <Card>
      <CardTitle>{t('title')}</CardTitle>
      <div className="flex flex-col gap-5">
        {warnOnMismatch && gap !== 0 ? (
          <Alert tone="warning" title={tAdmin('mismatchTitle')}>
            {tAdmin('mismatch', {
              declared: formatMillimesWithCurrency(declaration.amountMillimes, locale),
              expected: formatMillimesWithCurrency(order.totalMillimes, locale),
              gap: `${gap > 0 ? '+' : '−'}${formatMillimesWithCurrency(Math.abs(gap), locale)}`,
            })}
          </Alert>
        ) : null}
        <DescriptionList
          items={[
            {
              label: t('transferReference'),
              value: <span dir="ltr">{declaration.transferReference}</span>,
            },
            {
              label: t('transferDate'),
              value: formatCalendarDate(declaration.transferDate, locale),
            },
            {
              label: t('amount'),
              value: <Amount millimes={declaration.amountMillimes} size="title" />,
            },
            { label: t('declaredAt'), value: formatDateTime(declaration.declaredAt, locale) },
          ]}
        />
        <div className="flex flex-col gap-2">
          <h3 className="text-label font-title text-text">{tProof('title')}</h3>
          <ProofViewer load={loadProof} proof={declaration.proof} reference={order.reference} />
        </div>
      </div>
    </Card>
  );
}

/** Who did what, and when (oldest first). */
export function OrderHistory({ history }: { history: readonly Schemas['CreditOrderEvent'][] }) {
  const t = useTranslations('orders');
  const tRoot = useTranslations();
  const locale = useLocale();
  return (
    <Card>
      <CardTitle>{t('history.title')}</CardTitle>
      <ol className="flex flex-col gap-4">
        {history.map((event, index) => (
          <li
            key={`${event.action}-${event.occurredAt}-${String(index)}`}
            className="flex flex-col gap-1 border-s border-border ps-4"
          >
            <span className="text-body font-title text-text">
              {tRoot(messageKey(`orders.event.${event.action}`))}
            </span>
            <span className="text-caption text-text-muted">
              {formatDateTime(event.occurredAt, locale)} ·{' '}
              {t('history.by', {
                name: event.actorName,
                role: event.actorRole === 'ADMIN' ? t('role.ADMIN') : t('role.COMPANY'),
              })}
            </span>
            {event.reason !== undefined ? (
              <span className="text-body text-text" dir="auto">
                {t('history.reason', { reason: event.reason })}
              </span>
            ) : null}
          </li>
        ))}
      </ol>
    </Card>
  );
}

/** Mandatory reason (refusal of an order, rejection of a proof). */
export function ReasonDialog({
  title,
  description,
  label,
  hint,
  confirmLabel,
  onSubmit,
  onClose,
}: {
  title: string;
  description?: string;
  label: string;
  hint?: string;
  confirmLabel: string;
  /** Returns the API error, or undefined on success. */
  onSubmit: (reason: string) => Promise<unknown>;
  onClose: () => void;
}) {
  const t = useTranslations('orders');
  const tRoot = useTranslations();
  const [reason, setReason] = useState('');
  const [reasonError, setReasonError] = useState<string | undefined>(undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    if (reason.trim() === '') {
      setReasonError(t('reasonRequired'));
      return;
    }
    setReasonError(undefined);
    setSaving(true);
    setError(undefined);
    try {
      const problem = await onSubmit(reason.trim());
      if (problem !== undefined) setError(problem);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open && !saving) onClose();
      }}
      title={title}
      {...(description === undefined ? {} : { description })}
    >
      <form onSubmit={(event) => void submit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <TextField
          label={label}
          {...(hint === undefined ? {} : { hint })}
          error={reasonError}
          value={reason}
          maxLength={500}
          dir="auto"
          onChange={(event) => setReason(event.target.value)}
        />
        <div className="flex justify-end">
          <Button type="submit" variant="danger" loading={saving}>
            {confirmLabel}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
