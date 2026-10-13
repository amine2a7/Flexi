'use client';

import type { Schemas } from '@flexipay/api-client';
import { ChevronRight, FileSearch, Search } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, StatCard } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField } from '@/components/ui/field';
import { PageHeader } from '@/components/ui/layout-blocks';
import { Skeleton } from '@/components/ui/states';
import { KycStatusBadge } from '@/components/admin/kyc-status-badge';

type Status = Schemas['KycStatus'];
type AccountType = Schemas['KycAccountType'];
interface Filters {
  status: Status | '';
  accountType: AccountType | '';
}
const NO_FILTER: Filters = { status: '', accountType: '' };
const STATUSES: readonly Status[] = ['PENDING', 'APPROVED', 'REJECTED'];
const TYPES: readonly AccountType[] = ['MERCHANT', 'COMPANY'];

export default function KycFilesPage() {
  const t = useTranslations('admin.kyc');
  const tFilters = useTranslations('ui.filters');
  const locale = useLocale();
  const [filters, setFilters] = useState<Filters>(NO_FILTER);
  const [draft, setDraft] = useState<Filters>(NO_FILTER);
  const pending = useApiQuery(
    () =>
      getApi().GET('/v1/admin/kyc-files', {
        params: { query: { status: 'PENDING', limit: 1, withCount: true } },
      }),
    [],
  );
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/kyc-files', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.status === '' ? {} : { status: filters.status }),
            ...(filters.accountType === '' ? {} : { accountType: filters.accountType }),
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

  const columns: Column<Schemas['KycFileSummary']>[] = [
    {
      key: 'account',
      header: t('account'),
      cell: (row) => (
        <Link
          href={`/admin/kyc/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
        >
          {row.accountName}
        </Link>
      ),
      sortValue: (row) => row.accountName,
    },
    {
      key: 'type',
      header: t('type'),
      cell: (row) => t(`types.${row.accountType}`),
      sortValue: (row) => row.accountType,
    },
    { key: 'city', header: t('city'), cell: (row) => row.city, sortValue: (row) => row.city },
    {
      key: 'submitted',
      header: t('submittedAt'),
      cell: (row) => formatDateTime(row.submittedAt, locale),
      sortValue: (row) => row.submittedAt,
    },
    {
      key: 'documents',
      header: t('documents'),
      align: 'end',
      cell: (row) => row.documentsCount,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <KycStatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
    {
      key: 'open',
      header: t('open'),
      align: 'end',
      cell: (row) => (
        <Link
          href={`/admin/kyc/${row.id}`}
          className={buttonClasses(row.status === 'PENDING' ? 'primary' : 'ghost', 'sm')}
          aria-label={t('openFile', { name: row.accountName })}
        >
          {t('open')}
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];

  const pendingCount =
    pending.status === 'success' ? (pending.data.page.count?.value ?? 0) : undefined;
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard
          label={t('kpiPending')}
          value={pendingCount ?? <Skeleton className="h-input-height w-full" />}
          icon={<FileSearch className="size-icon-md" />}
          tone={pendingCount !== undefined && pendingCount > 0 ? 'attention' : 'default'}
        />
      </div>
      <Card>
        <form
          onSubmit={onSubmit}
          role="search"
          className="mb-4 grid items-end gap-3 sm:grid-cols-2 lg:grid-cols-3"
        >
          <SelectField
            label={t('status')}
            options={STATUSES.map((value) => ({ value, label: t(`statuses.${value}`) }))}
            placeholder={tFilters('allStatuses')}
            value={draft.status}
            onChange={(event) => {
              setDraft((previous) => ({ ...previous, status: event.target.value as Status | '' }));
            }}
          />
          <SelectField
            label={t('filterType')}
            options={TYPES.map((value) => ({ value, label: t(`types.${value}`) }))}
            placeholder={t('allTypes')}
            value={draft.accountType}
            onChange={(event) => {
              setDraft((previous) => ({
                ...previous,
                accountType: event.target.value as AccountType | '',
              }));
            }}
          />
          <div className="flex gap-2">
            <Button
              type="submit"
              variant="secondary"
              icon={<Search aria-hidden="true" className="size-icon-sm" />}
            >
              {tFilters('apply')}
            </Button>
            <Button
              variant="ghost"
              onClick={() => {
                apply(NO_FILTER);
              }}
            >
              {tFilters('reset')}
            </Button>
          </div>
        </form>
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
