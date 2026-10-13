'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import type { Column } from '@/components/ui/data-table';
import { StatusBadge } from '@/components/ui/status-badge';

type Payment = Schemas['MerchantPayment'];

/** Columns shared by the dashboard and the history (customer, reference, amount, date, status). */
export function usePaymentColumns(): Column<Payment>[] {
  const t = useTranslations('merchant.payments');
  const tDetail = useTranslations('merchant.paymentDetail');
  const locale = useLocale();
  return [
    {
      key: 'customer',
      header: t('customer'),
      cell: (row) => (
        <span className="flex flex-col">
          <span className="font-label text-text">{`${row.customer.firstName} ${row.customer.lastInitial}.`}</span>
          <span className="text-caption text-text-muted" dir="ltr">
            {row.customer.maskedEmployeeNumber}
          </span>
        </span>
      ),
      sortValue: (row) => row.customer.firstName,
    },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => (
        <Link
          href={`/commercant/historique/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
          aria-label={tDetail('openPayment', { reference: row.reference })}
        >
          {row.reference}
        </Link>
      ),
      sortValue: (row) => row.reference,
    },
    {
      key: 'amount',
      header: t('amount'),
      align: 'end',
      cell: (row) => <Amount millimes={row.amountMillimes} />,
      sortValue: (row) => row.amountMillimes,
    },
    {
      key: 'date',
      header: t('date'),
      cell: (row) => (
        <span className="text-text-muted">{formatDateTime(row.createdAt, locale)}</span>
      ),
      sortValue: (row) => row.createdAt,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
  ];
}
