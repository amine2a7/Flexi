'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { PdfDownloadButton } from '@/components/ui/pdf-download';
import { StatusBadge } from '@/components/ui/status-badge';

export default function InvoicesPage() {
  const t = useTranslations('company.invoices');
  const locale = useLocale();
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/company/invoices', { params: { query: { cursor, withCount } } }),
    [],
  );
  const columns: Column<Schemas['Invoice']>[] = [
    {
      key: 'number',
      header: t('number'),
      card: 'title',
      cell: (row) => (
        <Link
          href={`/entreprise/factures/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.number}
        </Link>
      ),
    },
    { key: 'order', header: t('order'), cell: (row) => row.orderReference },
    { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.issuedAt, locale) },
    {
      key: 'total',
      header: t('total'),
      align: 'end',
      cell: (row) => <Amount millimes={row.totalMillimes} />,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => (
        <span className="flex flex-col items-start gap-1">
          <StatusBadge status={row.status} />
          {row.creditNoteNumber === undefined ? null : (
            <span className="text-caption text-text-muted">
              {t('creditNote', { number: row.creditNoteNumber })}
            </span>
          )}
        </span>
      ),
    },
    {
      key: 'pdf',
      header: t('pdf'),
      align: 'end',
      cell: (row) => (
        <PdfDownloadButton
          label={t('download')}
          fileName={`${row.number}.pdf`}
          load={() =>
            getApi().GET('/v1/company/invoices/{invoiceId}/pdf', {
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
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('emptyTitle') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}
