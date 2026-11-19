'use client';

import type { Schemas } from '@flexipay/api-client';
import { BellRing, ChevronRight, Search } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { useDebounced, useUrlFilterState } from '@/lib/ui/use-url-filters';
import {
  ADMIN_ACTION_STATUSES,
  ORDER_STATUSES,
  OrderStatusBadge,
} from '@/components/orders/order-parts';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, StatCard } from '@/components/ui/card';
import { CreditTypeBadges, CreditTypeSelect, type CreditType } from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextField } from '@/components/ui/field';
import { PageHeader } from '@/components/ui/layout-blocks';
import { Skeleton } from '@/components/ui/states';

type Status = Schemas['OrderStatus'];
interface Filters {
  q: string;
  status: Status | '';
  companyId: string;
  creditType: CreditType | '';
}
const NO_FILTER: Filters = { q: '', status: '', companyId: '', creditType: '' };
/** Filters in the URL (W-SUP): shared links, reload, back button. */
const URL_NAMES = { q: 'q', status: 'statut', companyId: 'entreprise', creditType: 'type' } as const;

/** Number of orders in a status (bounded counter of the contract), for the action tiles. */
function useStatusCount(status: Status) {
  const query = useApiQuery(
    () =>
      getApi().GET('/v1/admin/credit-orders', {
        params: { query: { status, limit: 1, withCount: true } },
      }),
    [status],
  );
  return query.status === 'success' ? (query.data.page.count?.value ?? 0) : undefined;
}

export default function AdminOrdersPage() {
  const t = useTranslations('orders');
  const tFilters = useTranslations('ui.filters');
  const tTypes = useTranslations('ui.creditTypes');
  const locale = useLocale();
  const [filters, setFilters] = useUrlFilterState(NO_FILTER, URL_NAMES);
  const [draft, setDraft] = useState<Filters>(filters);
  const companies = useApiQuery(
    () => getApi().GET('/v1/admin/companies', { params: { query: { limit: 100 } } }),
    [],
  );
  const toConfirm = useStatusCount('AWAITING_CONFIRMATION');
  const toValidate = useStatusCount('AWAITING_VALIDATION');
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/credit-orders', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === '' ? {} : { status: filters.status }),
            ...(filters.companyId === '' ? {} : { companyId: filters.companyId }),
            ...(filters.creditType === '' ? {} : { creditType: filters.creditType }),
          },
        },
      }),
    [filters],
  );

  const apply = (next: Filters) => {
    setDraft(next);
    setFilters(next);
  };
  const onSubmit = (event: SyntheticEvent) => {
    event.preventDefault();
    setFilters(draft);
  };
  // W-SUP: the reference typed is searched 300 ms after the last key.
  useDebounced(draft.q, filters.q, (q) => {
    setFilters({ ...filters, q });
  });

  const columns: Column<Schemas['CreditOrder']>[] = [
    {
      key: 'attention',
      header: t('admin.needsAction'),
      cell: (row) =>
        ADMIN_ACTION_STATUSES.includes(row.status) ? (
          <span className="inline-flex min-h-chip-height items-center gap-1 whitespace-nowrap rounded-badge bg-warning-soft px-2 text-caption font-label text-warning-text">
            <BellRing aria-hidden="true" className="size-icon-sm" />
            {t('admin.needsAction')}
          </span>
        ) : null,
    },
    {
      key: 'reference',
      header: t('fields.reference'),
      cell: (row) => (
        <Link
          href={`/admin/commandes/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
          dir="ltr"
        >
          {row.reference}
        </Link>
      ),
      sortValue: (row) => row.reference,
    },
    {
      key: 'types',
      header: tTypes('column'),
      cell: (row) => <CreditTypeBadges types={row.lines.map((line) => line.creditType)} />,
    },
    {
      key: 'company',
      header: t('fields.company'),
      cell: (row) => row.companyName,
      sortValue: (row) => row.companyName,
    },
    {
      key: 'created',
      header: t('fields.createdAt'),
      cell: (row) => formatDateTime(row.createdAt, locale),
      sortValue: (row) => row.createdAt,
    },
    {
      key: 'total',
      header: t('fields.total'),
      align: 'end',
      cell: (row) => <Amount millimes={row.totalMillimes} />,
      sortValue: (row) => row.totalMillimes,
    },
    {
      key: 'declared',
      header: t('fields.declared'),
      align: 'end',
      cell: (row) =>
        row.declaredAmountMillimes === undefined ? null : (
          <Amount millimes={row.declaredAmountMillimes} />
        ),
    },
    {
      key: 'status',
      header: t('fields.status'),
      cell: (row) => <OrderStatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
    {
      key: 'open',
      header: t('fields.action'),
      align: 'end',
      cell: (row) => (
        <Link
          href={`/admin/commandes/${row.id}`}
          className={buttonClasses(
            ADMIN_ACTION_STATUSES.includes(row.status) ? 'primary' : 'ghost',
            'sm',
          )}
          aria-label={t('openOrder', { reference: row.reference })}
        >
          {t('open')}
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];

  const companyOptions =
    companies.status === 'success'
      ? companies.data.data.map((company) => ({ value: company.id, label: company.name }))
      : [];

  return (
    <>
      <PageHeader title={t('admin.title')} description={t('admin.description')} />
      <div className="mb-6 grid gap-4 sm:grid-cols-2">
        <ActionTile
          label={t('status.AWAITING_CONFIRMATION')}
          hint={t('admin.toConfirm')}
          count={toConfirm}
          onShow={() => {
            apply({ ...NO_FILTER, status: 'AWAITING_CONFIRMATION' });
          }}
        />
        <ActionTile
          label={t('status.AWAITING_VALIDATION')}
          hint={t('admin.toValidate')}
          count={toValidate}
          onShow={() => {
            apply({ ...NO_FILTER, status: 'AWAITING_VALIDATION' });
          }}
        />
      </div>
      <Card>
        <form
          onSubmit={onSubmit}
          role="search"
          className="mb-4 grid items-end gap-3 sm:grid-cols-2 lg:grid-cols-4"
        >
          <TextField
            label={t('admin.search')}
            type="search"
            value={draft.q}
            onChange={(event) => {
              setDraft((previous) => ({ ...previous, q: event.target.value }));
            }}
          />
          <SelectField
            label={t('fields.status')}
            options={ORDER_STATUSES.map((value) => ({ value, label: t(`status.${value}`) }))}
            placeholder={tFilters('allStatuses')}
            value={draft.status}
            onChange={(event) => {
              apply({ ...draft, status: event.target.value as Status | '' });
            }}
          />
          <SelectField
            label={t('fields.company')}
            options={companyOptions}
            placeholder={t('admin.allCompanies')}
            value={draft.companyId}
            onChange={(event) => {
              apply({ ...draft, companyId: event.target.value });
            }}
          />
          <CreditTypeSelect
            label={tFilters('creditType')}
            placeholder={tFilters('allTypes')}
            value={draft.creditType}
            onChange={(value) => {
              apply({ ...draft, creditType: value });
            }}
          />
          <div className="flex gap-2">
            <Button
              type="submit"
              variant="secondary"
              icon={<Search aria-hidden="true" className="size-icon-sm" />}
            >
              {t('admin.apply')}
            </Button>
            <Button
              variant="ghost"
              onClick={() => {
                apply(NO_FILTER);
              }}
            >
              {t('admin.reset')}
            </Button>
          </div>
        </form>
        <DataTable
          highlightNew
          caption={t('admin.title')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('admin.emptyTitle') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
    </>
  );
}

function ActionTile({
  label,
  hint,
  count,
  onShow,
}: {
  label: string;
  hint: string;
  count: number | undefined;
  onShow: () => void;
}) {
  const t = useTranslations('orders.admin');
  return (
    <div className="flex flex-col gap-3">
      <StatCard
        label={label}
        value={count ?? <Skeleton className="h-input-height w-full" />}
        hint={hint}
        icon={<BellRing aria-hidden="true" className="size-icon-md" />}
        tone={count !== undefined && count > 0 ? 'attention' : 'default'}
      />
      <Button variant="secondary" size="sm" className="self-start" onClick={onShow}>
        {t('showOnly')}
      </Button>
    </div>
  );
}
