'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { FilterBar, type Filters } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { PdfDownloadButton } from '@/components/ui/pdf-download';
import { StatusBadge } from '@/components/ui/status-badge';

type Invoice = Schemas['AdminInvoice'];
type Status = Schemas['InvoiceStatus'];
const STATUSES: readonly Status[] = ['UNPAID', 'PAID', 'CANCELLED'];

/** Invoices issued by FlexiPay to the companies (W-FIN): search, status, detail and PDF. */
export default function AdminInvoicesPage() {
  const t = useTranslations('admin.invoices');
  const tRoot = useTranslations();
  const locale = useLocale();
  const [filters, setFilters] = useState<Filters>({ q: '', status: '', creditType: '' });
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/invoices', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === '' ? {} : { status: filters.status as Status }),
          },
        },
      }),
    [filters],
  );
  const columns: Column<Invoice>[] = [
    {
      key: 'number',
      header: t('number'),
      card: 'title',
      cell: (row) => (
        <Link
          href={`/admin/factures/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.number}
        </Link>
      ),
      sortValue: (row) => row.number,
    },
    {
      key: 'company',
      header: t('company'),
      cell: (row) => (
        <Link
          href={`/admin/entreprises/${row.companyId}`}
          className="underline-offset-2 hover:underline"
        >
          <bdi>{row.companyName}</bdi>
        </Link>
      ),
      sortValue: (row) => row.companyName,
    },
    {
      key: 'order',
      header: t('order'),
      cell: (row) => <span dir="ltr">{row.orderReference}</span>,
    },
    {
      key: 'date',
      header: t('date'),
      cell: (row) => formatDateTime(row.issuedAt, locale),
      sortValue: (row) => row.issuedAt,
    },
    {
      key: 'total',
      header: t('total'),
      align: 'end',
      cell: (row) => <Amount millimes={row.totalMillimes} />,
      sortValue: (row) => row.totalMillimes,
    },
    { key: 'status', header: t('status'), cell: (row) => <StatusBadge status={row.status} /> },
    {
      key: 'pdf',
      header: t('pdf'),
      align: 'end',
      card: 'footer',
      cell: (row) => (
        <PdfDownloadButton
          label={t('download')}
          fileName={`${row.number}.pdf`}
          load={() =>
            getApi().GET('/v1/admin/invoices/{invoiceId}/pdf', {
              params: { path: { invoiceId: row.id } },
              parseAs: 'blob',
            })
          }
        />
      ),
    },
  ];
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <FilterBar
          searchLabel={t('search')}
          statusLabel={t('status')}
          statusOptions={STATUSES.map((value) => ({
            value,
            label: tRoot(messageKey(`statusLabel.${value}`)),
          }))}
          onApply={setFilters}
        />
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('empty') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}
