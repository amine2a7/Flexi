'use client';

import { ArrowLeft, Ban } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { useCallback, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { DeclareTransferForm } from '@/components/orders/declare-transfer-form';
import {
  DeclarationCard,
  FundingAccountCard,
  isStateConflict,
  OrderHistory,
  OrderStatusBadge,
  OrderSummaryCard,
  QuoteNotice,
  type Order,
} from '@/components/orders/order-parts';
import { Button, buttonClasses } from '@/components/ui/button';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

export default function CompanyOrderPage() {
  const { orderId } = useParams<{ orderId: string }>();
  const t = useTranslations('orders');
  const query = useApiQuery(
    () => getApi().GET('/v1/company/orders/{orderId}', { params: { path: { orderId } } }),
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
      <Link
        href="/entreprise/commandes"
        className={buttonClasses('ghost', 'sm', 'mb-4 self-start')}
      >
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {order === undefined && query.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {order === undefined && query.status === 'error' ? (
        <ErrorState error={query.error} onRetry={query.reload} />
      ) : null}
      {order !== undefined ? (
        <OrderView order={order} onChange={setUpdated} onConflict={reload} />
      ) : null}
    </>
  );
}

function OrderView({
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
  const canDeclare = useCan('orders.declareTransfer');
  const canCreateOrders = useCan('orders.create');
  const locale = useLocale();
  const toast = useToast();
  const [cancelling, setCancelling] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const loadProof = useCallback(
    () =>
      getApi().GET('/v1/company/orders/{orderId}/proof', {
        params: { path: { orderId: order.id } },
        parseAs: 'blob',
      }),
    [order.id],
  );
  const canCancel = order.status === 'AWAITING_CONFIRMATION' || order.status === 'AWAITING_PAYMENT';

  async function cancel() {
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/orders/{orderId}/cancel', {
        params: { path: { orderId: order.id } },
      });
      setCancelling(false);
      if (data !== undefined) {
        toast.notify('success', t('company.cancelledToast'));
        onChange(data);
      } else if (isStateConflict(problem)) {
        toast.notify('error', t('conflict'));
        onConflict();
      } else setError(problem);
    } finally {
      setSaving(false);
    }
  }

  const stateMessage = {
    AWAITING_CONFIRMATION: t('company.stateAwaitingConfirmation'),
    AWAITING_PAYMENT: t('company.stateAwaitingPayment'),
    AWAITING_VALIDATION: t('company.stateAwaitingValidation'),
    VALIDATED: t('company.stateValidated', {
      amount: formatMillimesWithCurrency(order.amountMillimes, locale),
    }),
    REFUSED: undefined,
    CANCELLED: t('company.stateCancelled'),
  }[order.status];

  return (
    <>
      <PageHeader
        title={t('company.detailTitle', { reference: order.reference })}
        description={order.companyName}
        actions={
          <div className="flex flex-wrap items-center gap-3">
            <OrderStatusBadge status={order.status} />
            {canCancel && canCreateOrders ? (
              <Button
                variant="secondary"
                icon={<Ban aria-hidden="true" className="size-icon-sm" />}
                onClick={() => {
                  setCancelling(true);
                }}
              >
                {t('company.cancel')}
              </Button>
            ) : null}
          </div>
        }
      />
      <div className="flex flex-col gap-6">
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <QuoteNotice order={order} />
        {order.status === 'REFUSED' ? (
          <Alert tone="danger" title={t('company.refusedTitle')}>
            <span dir="auto">{order.refusalReason}</span>
          </Alert>
        ) : null}
        {order.status === 'AWAITING_PAYMENT' && order.proofRejectionReason !== undefined ? (
          <Alert tone="warning" title={t('company.rejectedTitle')}>
            <span dir="auto">{order.proofRejectionReason}</span>
          </Alert>
        ) : null}
        {stateMessage !== undefined ? (
          <Alert tone={order.status === 'VALIDATED' ? 'success' : 'info'}>{stateMessage}</Alert>
        ) : null}
        <div className="grid gap-6 lg:grid-cols-2">
          <OrderSummaryCard order={order} showCompany={false} />
          <FundingAccountCard paymentReference={order.paymentReference} />
        </div>
        {order.status === 'AWAITING_PAYMENT' && canDeclare ? (
          <DeclareTransferForm order={order} onDeclared={onChange} />
        ) : null}
        <DeclarationCard order={order} loadProof={loadProof} warnOnMismatch={false} />
        <OrderHistory history={order.history} />
      </div>
      <ConfirmDialog
        open={cancelling}
        onOpenChange={setCancelling}
        title={t('company.cancelTitle', { reference: order.reference })}
        description={t('company.cancelMessage')}
        confirmLabel={t('company.cancelConfirm')}
        confirmVariant="danger"
        loading={saving}
        onConfirm={() => void cancel()}
      />
    </>
  );
}
