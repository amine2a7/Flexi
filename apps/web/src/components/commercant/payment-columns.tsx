'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import type { Column } from '@/components/ui/data-table';
import { StatusBadge } from '@/components/ui/status-badge';

type Payment = Schemas['MerchantPayment'];

/** Columns shared by the dashboard and the history (date, reference, customer, amount, status). */
export function usePaymentColumns(): Column<Payment>[] {
  const t = useTranslations('merchant.payments');
  const locale = useLocale();
  return [
    { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.createdAt, locale) },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => <span className="tabular-nums">{row.reference}</span>,
    },
    {
      key: 'customer',
      header: t('customer'),
      cell: (row) =>
        `${row.customer.firstName} ${row.customer.lastInitial}. · ${row.customer.maskedEmployeeNumber}`,
    },
    {
      key: 'amount',
      header: t('amount'),
      align: 'end',
      cell: (row) => <Amount millimes={row.amountMillimes} />,
    },
    { key: 'status', header: t('status'), cell: (row) => <StatusBadge status={row.status} /> },
  ];
}
