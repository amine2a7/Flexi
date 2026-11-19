'use client';

import { useParams } from 'next/navigation';
import { useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { InvoiceDetailView } from '@/components/invoices/invoice-detail';

/** An invoice of the company (W-FIN): credits by type, frozen fees, PDF. */
export default function CompanyInvoicePage() {
  const { invoiceId } = useParams<{ invoiceId: string }>();
  const t = useTranslations('company.invoices');
  const query = useApiQuery(
    () => getApi().GET('/v1/company/invoices/{invoiceId}', { params: { path: { invoiceId } } }),
    [invoiceId],
  );
  return (
    <InvoiceDetailView
      query={query}
      back={{ href: '/entreprise/factures', label: t('back') }}
      loadPdf={(id) =>
        getApi().GET('/v1/company/invoices/{invoiceId}/pdf', {
          params: { path: { invoiceId: id } },
          parseAs: 'blob',
        })
      }
    />
  );
}
