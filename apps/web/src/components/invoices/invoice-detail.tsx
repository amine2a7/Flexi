'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import type { QueryState } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { PdfDownloadButton } from '@/components/ui/pdf-download';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';

type Detail = Schemas['InvoiceDetail'];

/** Rate in basis points as a percentage (200 bps = 2 %), integers only. */
function percent(bps: number, locale: string): string {
  return new Intl.NumberFormat(locale, { style: 'percent', maximumFractionDigits: 2 }).format(
    bps / 10_000,
  );
}

/**
 * Detail of an invoice (W-FIN), shared by FlexiPay and the company: the credits by type and the
 * fees frozen in the order, the total, the PDF. Amounts come from the server, never computed.
 */
export function InvoiceDetailView({
  query,
  back,
  loadPdf,
  showCompany = false,
}: {
  query: QueryState<Detail> & { readonly reload: () => void };
  back: { href: string; label: string };
  loadPdf: (id: string) => Promise<{ data?: Blob; error?: unknown }>;
  showCompany?: boolean;
}) {
  const t = useTranslations('ui.invoice');
  const locale = useLocale();
  return (
    <>
      <Link href={back.href} className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {back.label}
      </Link>
      {query.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {query.status === 'error' ? <ErrorState error={query.error} onRetry={query.reload} /> : null}
      {query.status === 'success' ? (
        <>
          <PageHeader
            title={t('title', { number: query.data.number })}
            description={t('order', { reference: query.data.orderReference })}
            actions={
              <div className="flex items-center gap-3">
                <StatusBadge status={query.data.status} />
                <PdfDownloadButton
                  label={t('download')}
                  fileName={`${query.data.number}.pdf`}
                  load={() => loadPdf(query.data.id)}
                />
              </div>
            }
          />
          <div className="flex flex-col gap-6">
            <Card>
              <DescriptionList
                items={[
                  ...(showCompany ? [{ label: t('company'), value: query.data.companyName }] : []),
                  { label: t('issuedAt'), value: formatDateTime(query.data.issuedAt, locale) },
                  {
                    label: t('paymentReference'),
                    value: <span dir="ltr">{query.data.paymentReference}</span>,
                  },
                  ...(query.data.creditNoteNumber === undefined
                    ? []
                    : [{ label: t('creditNote'), value: query.data.creditNoteNumber }]),
                ]}
              />
            </Card>
            <Card>
              <CardTitle>{t('detail')}</CardTitle>
              <dl className="flex flex-col gap-3">
                {query.data.lines.map((line) => (
                  <div key={line.creditType} className="flex items-center justify-between gap-3">
                    <dt>
                      <CreditTypeBadge type={line.creditType} />
                    </dt>
                    <dd>
                      <Amount millimes={line.amountMillimes} />
                    </dd>
                  </div>
                ))}
                <Line label={t('credits')} millimes={query.data.amountMillimes} strong />
                <Line
                  label={t('commission', { rate: percent(query.data.feeRateBps, locale) })}
                  millimes={query.data.feesMillimes}
                />
                <Line
                  label={t('vat', { rate: percent(query.data.vatRateBps, locale) })}
                  millimes={query.data.vatMillimes}
                />
                <Line label={t('stamp')} millimes={query.data.stampDutyMillimes} />
                <Line label={t('transferFee')} millimes={query.data.transferFeeMillimes} />
                {query.data.withholdingMillimes > 0 ? (
                  <Line
                    label={t('withholding', {
                      rate: percent(query.data.withholdingRateBps, locale),
                    })}
                    millimes={-query.data.withholdingMillimes}
                  />
                ) : null}
                <Line label={t('total')} millimes={query.data.totalMillimes} strong />
              </dl>
            </Card>
          </div>
        </>
      ) : null}
    </>
  );
}

function Line({
  label,
  millimes,
  strong = false,
}: {
  label: string;
  millimes: number;
  strong?: boolean;
}) {
  return (
    <div
      className={
        strong
          ? 'flex items-center justify-between gap-3 border-t border-border pt-3 font-label'
          : 'flex items-center justify-between gap-3'
      }
    >
      <dt className={strong ? 'text-text' : 'text-text-muted'}>{label}</dt>
      <dd>
        <Amount millimes={millimes} />
      </dd>
    </div>
  );
}
