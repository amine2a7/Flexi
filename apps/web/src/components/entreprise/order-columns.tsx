'use client';

import type { Schemas } from '@flexipay/api-client';
import { ChevronRight } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import type { Column } from '@/components/ui/data-table';
import { OrderStatusBadge } from '@/components/orders/order-parts';

/** Columns of a credit order list (dashboard and orders page); each order opens its detail. */
export function useOrderColumns(): Column<Schemas['CreditOrder']>[] {
  const t = useTranslations('company.orders');
  const tOrders = useTranslations('orders');
  const locale = useLocale();
  return [
    { key: 'date', header: t('date'), cell: (row) => formatDateTime(row.createdAt, locale) },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => (
        <Link
          href={`/entreprise/commandes/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.reference}
        </Link>
      ),
    },
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
    { key: 'status', header: t('status'), cell: (row) => <OrderStatusBadge status={row.status} /> },
    {
      key: 'open',
      header: tOrders('fields.action'),
      align: 'end',
      cell: (row) => (
        <Link
          href={`/entreprise/commandes/${row.id}`}
          className={buttonClasses('ghost', 'sm')}
          aria-label={tOrders('openOrder', { reference: row.reference })}
        >
          {tOrders('open')}
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];
}
