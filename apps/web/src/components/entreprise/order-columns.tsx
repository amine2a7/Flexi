'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import type { Column } from '@/components/ui/data-table';
import { StatusBadge } from '@/components/ui/status-badge';

/** Columns of a credit order list (dashboard and orders page). */
export function useOrderColumns(): Column<Schemas['CreditOrder']>[] {
  const t = useTranslations('company.orders');
  const locale = useLocale();
  return [
    { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.createdAt, locale) },
    { key: 'reference', header: t('reference'), cell: (row) => row.reference },
    {
      key: 'credits',
      header: t('credits'),
      align: 'end',
      cell: (row) => <Amount millimes={row.amountMillimes} />,
    },
    {
      key: 'total',
      header: t('total'),
      align: 'end',
      cell: (row) => <Amount millimes={row.totalMillimes} />,
    },
    {
      key: 'paymentReference',
      header: t('paymentReference'),
      cell: (row) => <span dir="ltr">{row.paymentReference}</span>,
    },
    { key: 'status', header: t('status'), cell: (row) => <StatusBadge status={row.status} /> },
  ];
}
