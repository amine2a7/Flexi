'use client';

import { ArrowLeft } from 'lucide-react';
import { PdfDownloadButton } from '@/components/ui/pdf-download';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { AmountBreakdown, Rate } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';

/** Payout request detail: amounts, bank account and the steps reached (UX §6.7). */
export default function PayoutDetailPage() {
  const { payoutId } = useParams<{ payoutId: string }>();
  const t = useTranslations('merchant.payouts');
  const tFees = useTranslations('ui.fees');
  const tRoot = useTranslations();
  const locale = useLocale();
  const payout = useApiQuery(
    () => getApi().GET('/v1/merchant/payouts/{payoutId}', { params: { path: { payoutId } } }),
    [payoutId],
  );

  return (
    <>
      <Link href="/commercant/virements" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('back')}
      </Link>
      {payout.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {payout.status === 'error' ? (
        <ErrorState error={payout.error} onRetry={payout.reload} />
      ) : null}
      {payout.status === 'success' ? (
        <>
          <PageHeader
            title={t('detailTitle', { reference: payout.data.reference })}
            actions={<StatusBadge status={payout.data.status} context="payout" />}
          />
          <div className="grid gap-6 lg:grid-cols-2">
            <Card>
              <CardTitle>{t('summaryTitle')}</CardTitle>
              <div className="flex flex-col gap-5">
                <DescriptionList
                  items={[
                    {
                      label: t('creditType'),
                      value: <CreditTypeBadge type={payout.data.creditType} />,
                    },
                    {
                      label: t('requestedAt'),
                      value: formatDateTime(payout.data.requestedAt, locale),
                    },
                    {
                      label: t('iban'),
                      value: <span dir="ltr">{payout.data.maskedIban}</span>,
                    },
                    { label: t('rate'), value: <Rate bps={payout.data.commissionRateBps} /> },
                  ]}
                />
                {payout.data.status === 'REJECTED' ? null : (
                  <div className="mb-4 flex justify-end">
                    <PdfDownloadButton
                      label={t('invoice')}
                      fileName={`FAC-C-${payout.data.reference.slice(4)}.pdf`}
                      load={() =>
                        getApi().GET('/v1/merchant/payouts/{payoutId}/invoice', {
                          params: { path: { payoutId: payout.data.id } },
                          parseAs: 'blob',
                        })
                      }
                    />
                  </div>
                )}
                <AmountBreakdown
                  lines={[
                    { label: t('gross'), millimes: payout.data.grossMillimes },
                    {
                      label: t('commission'),
                      millimes: payout.data.commissionMillimes,
                      sign: 'debit',
                    },
                    {
                      label: tFees('vat'),
                      millimes: payout.data.vatMillimes,
                      sign: 'debit',
                    },
                    {
                      label: tFees('stamp'),
                      millimes: payout.data.stampDutyMillimes,
                      sign: 'debit',
                    },
                  ]}
                  total={{ label: t('net'), millimes: payout.data.netMillimes }}
                />
              </div>
            </Card>
            <Card>
              <CardTitle>{t('historyTitle')}</CardTitle>
              <Timeline
                entries={payout.data.history.map((event) => ({
                  key: `${event.status}-${event.occurredAt}`,
                  title: t(`event.${event.status}`),
                  meta: formatDateTime(event.occurredAt, locale),
                  ...(event.reason !== undefined
                    ? { detail: event.reason }
                    : event.reasonKey === undefined
                      ? {}
                      : { detail: tRoot(messageKey(`merchant.${event.reasonKey}`)) }),
                  tone: event.status === 'REJECTED' ? 'danger' : 'default',
                }))}
              />
            </Card>
          </div>
        </>
      ) : null}
    </>
  );
}
