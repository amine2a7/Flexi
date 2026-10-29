'use client';

import type { Schemas } from '@flexipay/api-client';
import { UserPlus } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { usePagedList } from '@/lib/api/use-paged-list';
import { useCan } from '@/lib/session/session-context';
import { CreateAdministrator } from '@/components/admin/create-administrator';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField } from '@/components/ui/field';
import { FilterBar } from '@/components/ui/filter-bar';
import { PageHeader } from '@/components/ui/layout-blocks';
import { UserStatusBadge } from '@/components/ui/status-badge';

const STATUSES: Schemas['UserStatus'][] = ['ACTIVE', 'INVITED', 'SUSPENDED', 'DEACTIVATED'];
const ROLES: Schemas['Role'][] = ['ADMIN', 'COMPANY', 'MERCHANT', 'EMPLOYEE'];

/** Admin › Utilisateurs (admin-utilisateurs.md, écran A): every account of the platform. */
export default function AdminUsersPage() {
  const t = useTranslations('admin.users');
  const tRole = useTranslations('layout.role');
  const tSubRole = useTranslations('subRole');
  const canCreate = useCan('users.adminRoles');
  const [filters, setFilters] = useState({ q: '', status: '' });
  const [role, setRole] = useState('');
  const [creating, setCreating] = useState(false);
  const [refresh, setRefresh] = useState(0);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/admin/users', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === '' ? {} : { status: filters.status as Schemas['UserStatus'] }),
            ...(role === '' ? {} : { role: role as Schemas['Role'] }),
          },
        },
      }),
    [filters, role, refresh],
  );

  const columns: Column<Schemas['AdminUser']>[] = [
    {
      key: 'name',
      header: t('columns.name'),
      cell: (row) => (
        <Link
          href={`/admin/utilisateurs/${row.id}`}
          className="font-label text-navy underline-offset-2 hover:underline"
        >
          {row.displayName}
        </Link>
      ),
      sortValue: (row) => row.displayName,
    },
    { key: 'email', header: t('columns.email'), cell: (row) => <span dir="ltr">{row.email}</span> },
    {
      key: 'role',
      header: t('columns.role'),
      cell: (row) =>
        row.subRole === null ? tRole(row.role) : `${tRole(row.role)} · ${tSubRole(row.subRole)}`,
    },
    {
      key: 'space',
      header: t('columns.space'),
      cell: (row) => row.tenant?.name ?? t('platform'),
    },
    {
      key: 'status',
      header: t('columns.status'),
      cell: (row) => <UserStatusBadge status={row.status} graceUntil={row.graceUntil} />,
      sortValue: (row) => row.status,
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          !canCreate ? undefined : (
            <Button
              icon={<UserPlus aria-hidden="true" className="size-icon-sm" />}
              onClick={() => {
                setCreating(true);
              }}
            >
              {t('create')}
            </Button>
          )
        }
      />
      <Card>
        <div className="mb-4 max-w-form-max-width">
          <SelectField
            label={t('role')}
            value={role}
            onChange={(event) => {
              setRole(event.target.value);
            }}
            options={[
              { value: '', label: t('roleAll') },
              ...ROLES.map((value) => ({ value, label: tRole(value) })),
            ]}
          />
        </div>
        <FilterBar
          searchLabel={t('search')}
          statusLabel={t('status')}
          statusOptions={STATUSES.map((value) => ({ value, label: t(`statuses.${value}`) }))}
          onApply={setFilters}
        />
        <DataTable
          caption={t('caption')}
          columns={columns}
          rows={list.rows}
          rowKey={(row) => row.id}
          loading={list.loading}
          error={list.error}
          onRetry={list.reload}
          empty={{ title: t('empty'), message: t('emptyMessage') }}
          page={list.page}
          pageNumber={list.pageNumber}
          onNext={list.next}
          onPrevious={list.previous}
        />
      </Card>
      {creating ? (
        <CreateAdministrator
          open
          onOpenChange={setCreating}
          onCreated={() => {
            setRefresh((value) => value + 1);
          }}
        />
      ) : null}
    </>
  );
}
