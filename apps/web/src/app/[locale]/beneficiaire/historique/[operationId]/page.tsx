'use client';

import { ArrowLeft, Printer } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';

/** Receipt of one operation; the balance after it is shown to the holder only. */
export default function OperationReceiptPage() {
  const { operationId } = useParams<{ operationId: string }>();
  const t = useTranslations('beneficiary.receipt');
  const tHistory = useTranslations('beneficiary.history');
  const locale = useLocale();
  const operation = useApiQuery(
    () =>
      getApi().GET('/v1/employee/operations/{operationId}', {
        params: { path: { operationId } },
      }),
    [operationId],
  );

  return (
    <>
      <Link href="/beneficiaire/historique" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {operation.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {operation.status === 'error' ? (
        <ErrorState error={operation.error} onRetry={operation.reload} />
      ) : null}
      {operation.status === 'success' ? (
        <>
          <PageHeader
            title={t('title', { reference: operation.data.reference })}
            actions={
              <StatusBadge
                status={operation.data.status}
                labelKey={`beneficiary.history.statuses.${operation.data.status}`}
              />
            }
          />
          <Card className="max-w-2xl">
            <div className="mb-6 flex flex-col items-center gap-2 text-center">
              <Amount
                millimes={operation.data.amountMillimes}
                sign={operation.data.direction === 'CREDIT' ? 'credit' : 'debit'}
                size="title"
              />
              <CreditTypeBadge type={operation.data.creditType} />
            </div>
            <DescriptionList
              items={[
                { label: t('type'), value: tHistory(`types.${operation.data.type}`) },
                { label: t('counterparty'), value: operation.data.counterpartyName },
                ...(operation.data.counterpartyCity === null
                  ? []
                  : [{ label: t('city'), value: operation.data.counterpartyCity }]),
                { label: t('date'), value: formatDateTime(operation.data.occurredAt, locale) },
                {
                  label: t('category'),
                  value: <CreditTypeBadge type={operation.data.creditType} />,
                },
                {
                  label: t('reference'),
                  value: <span dir="ltr">{operation.data.reference}</span>,
                },
                {
                  label: t('balanceAfter'),
                  value: <Amount millimes={operation.data.balanceAfterMillimes} />,
                },
              ]}
            />
            <Button
              variant="secondary"
              className="mt-6 w-full print:hidden sm:w-auto"
              icon={<Printer aria-hidden="true" className="size-icon-md" />}
              onClick={() => {
                window.print();
              }}
            >
              {t('print')}
            </Button>
          </Card>
        </>
      ) : null}
    </>
  );
}
