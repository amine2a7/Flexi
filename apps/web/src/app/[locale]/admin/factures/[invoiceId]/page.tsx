'use client';

import { useParams } from 'next/navigation';
import { useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { InvoiceDetailView } from '@/components/invoices/invoice-detail';

/** An invoice issued by FlexiPay (W-FIN): credits by type, frozen fees, PDF. */
export default function AdminInvoicePage() {
  const { invoiceId } = useParams<{ invoiceId: string }>();
  const t = useTranslations('admin.invoices');
  const query = useApiQuery(
    () => getApi().GET('/v1/admin/invoices/{invoiceId}', { params: { path: { invoiceId } } }),
    [invoiceId],
  );
  return (
    <InvoiceDetailView
      query={query}
      showCompany
      back={{ href: '/admin/factures', label: t('back') }}
      loadPdf={(id) =>
        getApi().GET('/v1/admin/invoices/{invoiceId}/pdf', {
          params: { path: { invoiceId: id } },
          parseAs: 'blob',
        })
      }
    />
  );
}
