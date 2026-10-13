'use client';

import type { Schemas } from '@flexipay/api-client';
import { ChevronRight, Search } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { formatDateTime } from '@/lib/format/date';
import { ContactStatusBadge } from '@/components/admin/contact-status-badge';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextField } from '@/components/ui/field';
import { PageHeader } from '@/components/ui/layout-blocks';

type Status = Schemas['ContactMessageStatus'];
type Requester = Schemas['ContactRequesterType'];
interface Filters {
  q: string;
  status: Status | '';
  requesterType: Requester | '';
}
const NO_FILTER: Filters = { q: '', status: '', requesterType: '' };
const STATUSES: readonly Status[] = ['NEW', 'HANDLED'];
const REQUESTERS: readonly Requester[] = ['COMPANY', 'MERCHANT', 'OTHER'];

/** Messages of the public "Contact us" form, newest first. */
export default function ContactMessagesPage() {
  const t = useTranslations('adminMessages');
  const tContact = useTranslations('contact');
  const tFilters = useTranslations('ui.filters');
  const locale = useLocale();
  const [filters, setFilters] = useState<Filters>(NO_FILTER);
  const [draft, setDraft] = useState<Filters>(NO_FILTER);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/contact-messages', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === '' ? {} : { status: filters.status }),
            ...(filters.requesterType === '' ? {} : { requesterType: filters.requesterType }),
          },
        },
      }),
    [filters],
  );

  const onSubmit = (event: SyntheticEvent) => {
    event.preventDefault();
    setFilters({ ...draft, q: draft.q.trim() });
  };

  const columns: Column<Schemas['ContactMessage']>[] = [
    {
      key: 'requester',
      header: t('requester'),
      cell: (row) => (
        <Link
          href={`/admin/messages/${row.id}`}
          className="flex flex-col font-label text-navy underline-offset-2 hover:underline"
        >
          <span>{row.name}</span>
          {row.companyName !== null ? (
            <span className="text-caption text-text-muted">{row.companyName}</span>
          ) : null}
        </Link>
      ),
      sortValue: (row) => row.name,
    },
    {
      key: 'type',
      header: t('type'),
      cell: (row) => tContact(`types.${row.requesterType}`),
      sortValue: (row) => row.requesterType,
    },
    {
      key: 'reference',
      header: t('reference'),
      cell: (row) => <span dir="ltr">{row.reference}</span>,
      sortValue: (row) => row.reference,
    },
    {
      key: 'received',
      header: t('received'),
      cell: (row) => (
        <span className="text-text-muted">{formatDateTime(row.receivedAt, locale)}</span>
      ),
      sortValue: (row) => row.receivedAt,
    },
    {
      key: 'status',
      header: t('statusLabel'),
      cell: (row) => <ContactStatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
    {
      key: 'open',
      header: t('message'),
      align: 'end',
      cell: (row) => (
        <Link
          href={`/admin/messages/${row.id}`}
          className={buttonClasses(row.status === 'NEW' ? 'primary' : 'ghost', 'sm')}
          aria-label={t('open', { reference: row.reference })}
        >
          <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        </Link>
      ),
    },
  ];

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <Card>
        <form
          onSubmit={onSubmit}
          role="search"
          className="mb-4 grid items-end gap-3 sm:grid-cols-2 lg:grid-cols-4"
        >
          <TextField
            label={t('search')}
            type="search"
            value={draft.q}
            onChange={(event) => setDraft((previous) => ({ ...previous, q: event.target.value }))}
          />
          <SelectField
            label={t('statusLabel')}
            options={STATUSES.map((value) => ({ value, label: t(`status.${value}`) }))}
            placeholder={tFilters('allStatuses')}
            value={draft.status}
            onChange={(event) =>
              setDraft((previous) => ({ ...previous, status: event.target.value as Status | '' }))
            }
          />
          <SelectField
            label={t('type')}
            options={REQUESTERS.map((value) => ({ value, label: tContact(`types.${value}`) }))}
            placeholder={tFilters('allTypes')}
            value={draft.requesterType}
            onChange={(event) =>
              setDraft((previous) => ({
                ...previous,
                requesterType: event.target.value as Requester | '',
              }))
            }
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
                setDraft(NO_FILTER);
                setFilters(NO_FILTER);
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
