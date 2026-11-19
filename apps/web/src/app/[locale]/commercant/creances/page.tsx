'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatCalendarDate, formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { CreditTypeBadge, type CreditType } from '@/components/ui/credit-type';
import { FilterBar } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { StatusBadge } from '@/components/ui/status-badge';
import { useCanOpen } from '@/lib/session/session-context';

export default function ReceivablesPage() {
  const t = useTranslations('merchant.receivables');
  const { settlementDays } = usePlatformTerms();
  const locale = useLocale();
  const tTypes = useTranslations('ui.creditTypes');
  const canPayouts = useCanOpen('/commercant/virements');
  const [total, setTotal] = useState<number | undefined>(undefined);
  const [creditType, setCreditType] = useState<CreditType | ''>('');
  const [search, setSearch] = useState('');
  const list = usePagedList(
    async (cursor, withCount) => {
      const result = await getApi().GET('/v1/merchant/receivables', {
        params: {
          query: {
            cursor,
            withCount,
            ...(creditType === '' ? {} : { creditType }),
            ...(search === '' ? {} : { q: search }),
          },
        },
      });
      if (result.data !== undefined) setTotal(result.data.totalMillimes);
      return result;
    },
    [creditType, search],
  );

  const columns: Column<Schemas['Receivable']>[] = [
    {
      key: 'creditType',
      header: tTypes('column'),
      cell: (row) => <CreditTypeBadge type={row.creditType} />,
      sortValue: (row) => row.creditType,
    },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => row.reference,
      sortValue: (row) => row.reference,
    },
    {
      key: 'confirmedAt',
      header: t('confirmedAt'),
      cell: (row) => formatDateTime(row.confirmedAt, locale),
      sortValue: (row) => row.confirmedAt,
    },
    {
      key: 'settlementDate',
      header: t('settlementDate'),
      cell: (row) => formatCalendarDate(row.settlementDate, locale),
      sortValue: (row) => row.settlementDate,
    },
    {
      key: 'amount',
      header: t('amount'),
      align: 'end',
      cell: (row) => <Amount millimes={row.amountMillimes} />,
      sortValue: (row) => row.amountMillimes,
    },
    // Merchant wording of A_REGLER (decision 2).
    {
      key: 'status',
      header: t('status'),
      cell: () => <StatusBadge status="RECEIVABLE" labelKey="statusLabel.merchantReceivable" />,
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description', { days: settlementDays })}
        actions={
          canPayouts ? (
            <Link href="/commercant/virements" className={buttonClasses('primary')}>
              {t('requestPayout')}
            </Link>
          ) : null
        }
      />
      <div className="mb-6 grid gap-4 sm:grid-cols-2">
        <StatCard
          label={t('total')}
          value={total === undefined ? '…' : <Amount millimes={total} size="title" />}
          hint={t('totalHint', { days: settlementDays })}
        />
      </div>
      <Card>
        <FilterBar
          searchLabel={t('search')}
          withCreditType
          onApply={(filters) => {
            setSearch(filters.q);
            setCreditType(filters.creditType);
          }}
        />
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.paymentId}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('emptyTitle'), message: t('emptyMessage') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}
