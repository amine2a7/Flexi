'use client';

import type { Schemas } from '@flexipay/api-client';
import { Download } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatMonth } from '@/lib/format/date';
import { formatMillimes } from '@/lib/format/money';
import { Amount } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { CreditTypeBreakdown } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';

/** Byte order mark: spreadsheets read the CSV as UTF-8 (accents, Arabic). */
const BOM = String.fromCharCode(0xfeff);

type Flow = Schemas['AdminDashboard']['monthlyFlows'][number];

/**
 * Administrateur › Reporting (admin-reporting.md): monthly credited and paid amounts of the platform and
 * the split of the month by credit type, as sent by the API, with a CSV export of the table (no computation).
 */
export default function AdminReportingPage() {
  const t = useTranslations('admin.reporting');
  const locale = useLocale();
  const dashboard = useApiQuery(() => getApi().GET('/v1/admin/dashboard'), []);

  const columns: Column<Flow>[] = [
    {
      key: 'month',
      header: t('month'),
      cell: (row) => formatMonth(row.month, locale),
      sortValue: (row) => row.month,
    },
    {
      key: 'credited',
      header: t('credited'),
      align: 'end',
      cell: (row) => <Amount millimes={row.creditedMillimes} />,
      sortValue: (row) => row.creditedMillimes,
    },
    {
      key: 'payments',
      header: t('payments'),
      align: 'end',
      cell: (row) => <Amount millimes={row.paymentsMillimes} />,
      sortValue: (row) => row.paymentsMillimes,
    },
  ];

  function exportCsv(flows: readonly Flow[]) {
    const lines = [
      [t('month'), t('credited'), t('payments')].join(';'),
      ...flows.map((flow) =>
        [
          flow.month,
          formatMillimes(flow.creditedMillimes, locale),
          formatMillimes(flow.paymentsMillimes, locale),
        ].join(';'),
      ),
    ];
    const url = URL.createObjectURL(
      new Blob([`${BOM}${lines.join('\n')}\n`], { type: 'text/csv;charset=utf-8' }),
    );
    const link = document.createElement('a');
    link.href = url;
    link.download = 'flexipay-plateforme.csv';
    link.click();
    URL.revokeObjectURL(url);
  }

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          dashboard.status === 'success' && dashboard.data.monthlyFlows.length > 0 ? (
            <Button
              variant="secondary"
              icon={<Download aria-hidden="true" className="size-icon-sm" />}
              onClick={() => {
                exportCsv(dashboard.data.monthlyFlows);
              }}
            >
              {t('export')}
            </Button>
          ) : undefined
        }
      />
      {dashboard.status === 'loading' ? <LoadingBlock lines={8} /> : null}
      {dashboard.status === 'error' ? (
        <ErrorState error={dashboard.error} onRetry={dashboard.reload} />
      ) : null}
      {dashboard.status === 'success' ? (
        <div className="grid gap-6 lg:grid-cols-3">
          <Card className="lg:col-span-2">
            <CardTitle description={t('flowsDescription')}>{t('flowsTitle')}</CardTitle>
            <DataTable
              caption={t('flowsTitle')}
              columns={columns}
              rows={dashboard.data.monthlyFlows}
              rowKey={(row) => row.month}
              empty={{ title: t('emptyTitle'), message: t('emptyMessage') }}
            />
          </Card>
          <Card>
            <CardTitle description={t('balanceDescription')}>{t('balanceTitle')}</CardTitle>
            <CreditTypeBreakdown items={dashboard.data.monthByCreditType} />
          </Card>
        </div>
      ) : null}
    </>
  );
}
