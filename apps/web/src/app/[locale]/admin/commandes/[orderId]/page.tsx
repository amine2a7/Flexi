'use client';

import { ArrowLeft, Check, CircleCheck, FileX, X } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { useCallback, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import {
  DeclarationCard,
  isStateConflict,
  OrderHistory,
  OrderStatusBadge,
  OrderSummaryCard,
  ReasonDialog,
  type Order,
} from '@/components/orders/order-parts';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';

type Dialog = 'confirm' | 'refuse' | 'validate' | 'reject' | undefined;

export default function AdminOrderPage() {
  const { orderId } = useParams<{ orderId: string }>();
  const t = useTranslations('orders');
  const query = useApiQuery(
    () => getApi().GET('/v1/admin/credit-orders/{orderId}', { params: { path: { orderId } } }),
    [orderId],
  );
  const [updated, setUpdated] = useState<Order | undefined>(undefined);
  const order = updated ?? (query.status === 'success' ? query.data : undefined);
  const { reload: reloadQuery } = query;
  const reload = useCallback(() => {
    setUpdated(undefined);
    reloadQuery();
  }, [reloadQuery]);

  return (
    <>
      <Link href="/admin/commandes" className={buttonClasses('ghost', 'sm', 'mb-4 self-start')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {order === undefined && query.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {order === undefined && query.status === 'error' ? (
        <ErrorState error={query.error} onRetry={query.reload} />
      ) : null}
      {order !== undefined ? (
        <AdminOrderView order={order} onChange={setUpdated} onConflict={reload} />
      ) : null}
    </>
  );
}

function AdminOrderView({
  order,
  onChange,
  onConflict,
}: {
  order: Order;
  onChange: (order: Order) => void;
  onConflict: () => void;
}) {
  const t = useTranslations('orders');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [dialog, setDialog] = useState<Dialog>(undefined);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [validateKey, setValidateKey] = useState(newIdempotencyKey);
  const loadProof = useCallback(
    () =>
      getApi().GET('/v1/admin/credit-orders/{orderId}/proof', {
        params: { path: { orderId: order.id } },
        parseAs: 'blob',
      }),
    [order.id],
  );
  const path = { params: { path: { orderId: order.id } } };
  const total = formatMillimesWithCurrency(order.totalMillimes, locale);
  const declared = order.declaration?.amountMillimes;
  const gap = declared === undefined ? 0 : declared - order.totalMillimes;
  const mismatchText =
    declared === undefined || gap === 0
      ? undefined
      : t('admin.mismatch', {
          declared: formatMillimesWithCurrency(declared, locale),
          expected: total,
          gap: `${gap > 0 ? '+' : '−'}${formatMillimesWithCurrency(Math.abs(gap), locale)}`,
        });

  /** Applies the result of an action: new order, conflict (reload) or error. */
  function settle(
    result: { data?: Order; error?: unknown },
    successMessage: string | ((order: Order) => string),
  ): unknown {
    if (result.data !== undefined) {
      setDialog(undefined);
      toast.notify(
        'success',
        typeof successMessage === 'string' ? successMessage : successMessage(result.data),
      );
      onChange(result.data);
      return undefined;
    }
    if (isStateConflict(result.error)) {
      setDialog(undefined);
      toast.notify('error', t('conflict'));
      onConflict();
      return undefined;
    }
    return result.error;
  }

  async function run(
    action: () => Promise<{ data?: Order; error?: unknown }>,
    message: string | ((order: Order) => string),
  ) {
    setSaving(true);
    setError(undefined);
    try {
      const problem = settle(await action(), message);
      if (problem !== undefined) {
        setDialog(undefined);
        setError(problem);
      }
    } finally {
      setSaving(false);
    }
  }

  const validateLabel = !order.requiresSecondValidation
    ? t('admin.validate')
    : order.firstValidation === undefined
      ? t('admin.firstValidate')
      : t('admin.secondValidate');

  const step = {
    AWAITING_CONFIRMATION: t('admin.stepConfirm'),
    AWAITING_PAYMENT: t('admin.stepWaitPayment'),
    AWAITING_VALIDATION: t('admin.stepValidate'),
    VALIDATED: undefined,
    REFUSED: undefined,
    CANCELLED: undefined,
  }[order.status];

  return (
    <>
      <PageHeader
        title={t('admin.detailTitle', { reference: order.reference })}
        description={order.companyName}
        actions={<OrderStatusBadge status={order.status} />}
      />
      <div className="flex flex-col gap-6">
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        {step !== undefined ? (
          <Card>
            <div className="flex flex-col gap-4">
              <Alert tone={order.status === 'AWAITING_PAYMENT' ? 'info' : 'warning'}>{step}</Alert>
              {order.status === 'AWAITING_CONFIRMATION' ? (
                <div className="flex flex-wrap justify-end gap-3">
                  <Button
                    variant="secondary"
                    icon={<X aria-hidden="true" className="size-icon-sm" />}
                    onClick={() => {
                      setDialog('refuse');
                    }}
                  >
                    {t('admin.refuse')}
                  </Button>
                  <Button
                    icon={<Check aria-hidden="true" className="size-icon-sm" />}
                    onClick={() => {
                      setDialog('confirm');
                    }}
                  >
                    {t('admin.confirm')}
                  </Button>
                </div>
              ) : null}
              {order.status === 'AWAITING_VALIDATION' ? (
                <>
                  {order.requiresSecondValidation ? (
                    <Alert
                      tone={order.firstValidation?.byMe === true ? 'warning' : 'info'}
                      title={t('admin.fourEyesTitle')}
                    >
                      {order.firstValidation === undefined
                        ? t('admin.fourEyesInfo')
                        : order.firstValidation.byMe
                          ? t('admin.firstByMe', {
                              date: formatDateTime(order.firstValidation.occurredAt, locale),
                            })
                          : t('admin.firstDone', {
                              name: order.firstValidation.actorName,
                              date: formatDateTime(order.firstValidation.occurredAt, locale),
                            })}
                    </Alert>
                  ) : null}
                  {mismatchText !== undefined ? (
                    <Alert tone="warning" title={t('admin.mismatchTitle')}>
                      {mismatchText}
                    </Alert>
                  ) : null}
                  <div className="flex flex-wrap justify-end gap-3">
                    <Button
                      variant="secondary"
                      icon={<FileX aria-hidden="true" className="size-icon-sm" />}
                      onClick={() => {
                        setDialog('reject');
                      }}
                    >
                      {t('admin.rejectProof')}
                    </Button>
                    {order.firstValidation?.byMe === true ? null : (
                      <Button
                        variant="success"
                        icon={<CircleCheck aria-hidden="true" className="size-icon-sm" />}
                        onClick={() => {
                          setValidateKey(newIdempotencyKey());
                          setDialog('validate');
                        }}
                      >
                        {validateLabel}
                      </Button>
                    )}
                  </div>
                </>
              ) : null}
            </div>
          </Card>
        ) : null}
        {order.status === 'REFUSED' && order.refusalReason !== undefined ? (
          <Alert tone="danger">
            <span dir="auto">{t('admin.refusedInfo', { reason: order.refusalReason })}</span>
          </Alert>
        ) : null}
        {order.status === 'AWAITING_PAYMENT' && order.proofRejectionReason !== undefined ? (
          <Alert tone="info">
            <span dir="auto">
              {t('admin.lastRejection', { reason: order.proofRejectionReason })}
            </span>
          </Alert>
        ) : null}
        <OrderSummaryCard order={order} showCompany />
        {order.declaration !== undefined ? (
          <DeclarationCard order={order} loadProof={loadProof} warnOnMismatch={false} />
        ) : (
          <Card>
            <p className="text-body text-text-muted">{t('admin.noDeclaration')}</p>
          </Card>
        )}
        <OrderHistory history={order.history} />
      </div>

      <ConfirmDialog
        open={dialog === 'confirm'}
        onOpenChange={(open) => {
          setDialog(open ? 'confirm' : undefined);
        }}
        title={t('admin.confirmTitle', { reference: order.reference })}
        description={t('admin.confirmMessage', { amount: total })}
        confirmLabel={t('admin.confirm')}
        loading={saving}
        onConfirm={() =>
          void run(
            () => getApi().POST('/v1/admin/credit-orders/{orderId}/confirm', path),
            t('admin.confirmedToast'),
          )
        }
      />
      <ConfirmDialog
        open={dialog === 'validate'}
        onOpenChange={(open) => {
          setDialog(open ? 'validate' : undefined);
        }}
        title={t('admin.validateTitle', { reference: order.reference })}
        description={t('admin.validateMessage', {
          amount: formatMillimesWithCurrency(declared ?? order.totalMillimes, locale),
          credits: formatMillimesWithCurrency(order.amountMillimes, locale),
          company: order.companyName,
        })}
        confirmLabel={validateLabel}
        confirmVariant="success"
        loading={saving}
        onConfirm={() =>
          void run(
            () =>
              getApi().POST('/v1/admin/credit-orders/{orderId}/validate', {
                params: {
                  path: { orderId: order.id },
                  header: { 'Idempotency-Key': validateKey },
                },
              }),
            (updated) =>
              updated.status === 'VALIDATED'
                ? t('admin.validatedToast')
                : t('admin.firstValidatedToast'),
          )
        }
      >
        {mismatchText !== undefined ? (
          <Alert tone="warning" title={t('admin.mismatchTitle')}>
            {mismatchText}
          </Alert>
        ) : null}
      </ConfirmDialog>
      {dialog === 'refuse' ? (
        <ReasonDialog
          title={t('admin.refuseTitle', { reference: order.reference })}
          label={t('admin.refuseReason')}
          confirmLabel={t('admin.refuse')}
          onClose={() => {
            setDialog(undefined);
          }}
          onSubmit={async (reason) =>
            settle(
              await getApi().POST('/v1/admin/credit-orders/{orderId}/refuse', {
                ...path,
                body: { reason },
              }),
              t('admin.refusedToast'),
            )
          }
        />
      ) : null}
      {dialog === 'reject' ? (
        <ReasonDialog
          title={t('admin.rejectTitle', { reference: order.reference })}
          description={t('admin.rejectMessage')}
          label={t('admin.rejectReason')}
          hint={t('admin.rejectReasonHint')}
          confirmLabel={t('admin.rejectProof')}
          onClose={() => {
            setDialog(undefined);
          }}
          onSubmit={async (reason) =>
            settle(
              await getApi().POST('/v1/admin/credit-orders/{orderId}/reject-proof', {
                ...path,
                body: { reason },
              }),
              t('admin.rejectedToast'),
            )
          }
        />
      ) : null}
    </>
  );
}
