'use client';

import type { Schemas } from '@flexipay/api-client';
import { FileUp, UserPlus, WalletCards } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey, fieldErrors as readFieldErrors } from '@/lib/api/problem';
import { usePagedList } from '@/lib/api/use-paged-list';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { FilterBar } from '@/components/ui/filter-bar';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';
import { useCan, useCanOpen } from '@/lib/session/session-context';

type Employee = Schemas['Employee'];
type Draft = Schemas['EmployeeCreate'];
const STATUSES: Schemas['EmployeeStatus'][] = ['ACTIVE', 'INVITED', 'SUSPENDED'];
const FIELDS = ['employeeNumber', 'firstName', 'lastName', 'email', 'phone'] as const;
const EMPTY: Draft = { employeeNumber: '', firstName: '', lastName: '', email: '', phone: '+216' };

export default function EmployeesPage() {
  const t = useTranslations('company.employees');
  const tDashboard = useTranslations('company.dashboard');
  const tStatus = useTranslations('statusLabel');
  const canManage = useCan('employees.manage');
  const canAllocate = useCanOpen('/entreprise/attribution');
  const canImport = useCanOpen('/entreprise/employes/import');
  const [filters, setFilters] = useState({ q: '', status: '' });
  const [adding, setAdding] = useState(false);
  const [refresh, setRefresh] = useState(0);
  const list = usePagedList(
    (cursor, withCount) =>
      getApi().GET('/v1/company/employees', {
        params: {
          query: {
            cursor,
            withCount,
            ...(filters.q === '' ? {} : { q: filters.q }),
            ...(filters.status === ''
              ? {}
              : { status: filters.status as Schemas['EmployeeStatus'] }),
          },
        },
      }),
    [filters, refresh],
  );

  const columns: Column<Employee>[] = [
    {
      key: 'name',
      header: t('name'),
      cell: (row) => (
        <span className="flex flex-col">
          <span className="font-label text-text">{`${row.firstName} ${row.lastName}`}</span>
          <span className="text-caption text-text-muted" dir="ltr">
            {row.employeeNumber}
          </span>
        </span>
      ),
      sortValue: (row) => `${row.lastName} ${row.firstName}`,
    },
    { key: 'email', header: t('fields.email'), cell: (row) => <span dir="ltr">{row.email}</span> },
    { key: 'phone', header: t('fields.phone'), cell: (row) => <span dir="ltr">{row.phone}</span> },
    {
      key: 'allocated',
      header: t('allocated'),
      align: 'end',
      cell: (row) => <Amount millimes={row.monthAllocatedMillimes} />,
      sortValue: (row) => row.monthAllocatedMillimes,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} />,
      sortValue: (row) => row.status,
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <>
            {canImport ? (
              <Link href="/entreprise/employes/import" className={buttonClasses('secondary')}>
                <FileUp aria-hidden="true" className="size-icon-sm" />
                {t('import')}
              </Link>
            ) : null}
            {canManage ? (
              <Button
                variant="secondary"
                icon={<UserPlus aria-hidden="true" className="size-icon-sm" />}
                onClick={() => {
                  setAdding(true);
                }}
              >
                {t('add')}
              </Button>
            ) : null}
            {canAllocate ? (
              <Link href="/entreprise/attribution" className={buttonClasses('primary')}>
                <WalletCards aria-hidden="true" className="size-icon-sm" />
                {tDashboard('allocate')}
              </Link>
            ) : null}
          </>
        }
      />
      <Card>
        <FilterBar
          searchLabel={t('search')}
          statusLabel={t('status')}
          statusOptions={STATUSES.map((value) => ({ value, label: tStatus(value) }))}
          onApply={setFilters}
        />
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
      <AddEmployee
        open={adding}
        onOpenChange={setAdding}
        onCreated={() => {
          setRefresh((value) => value + 1);
        }}
      />
    </>
  );
}

function AddEmployee({
  open,
  onOpenChange,
  onCreated,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCreated: () => void;
}) {
  const t = useTranslations('company.employees');
  const tRoot = useTranslations();
  const toast = useToast();
  const [draft, setDraft] = useState<Draft>(EMPTY);
  const [fieldErrors, setFieldErrors] = useState<Partial<Record<keyof Draft, string>>>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSaving(true);
    setError(undefined);
    setFieldErrors({});
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/employees', {
        body: draft,
      });
      if (data !== undefined) {
        toast.notify('success', t('created', { name: `${data.firstName} ${data.lastName}` }));
        setDraft(EMPTY);
        onOpenChange(false);
        onCreated();
        return;
      }
      const fields = readFieldErrors(problem);
      if (fields.length > 0) {
        setFieldErrors(
          Object.fromEntries(
            fields.map((item) => [
              item.pointer.slice(1),
              item.code === 'REQUIRED' ? t('required') : t('invalidFormat'),
            ]),
          ),
        );
      } else {
        setError(problem);
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open={open}
      onOpenChange={onOpenChange}
      title={t('formTitle')}
      description={t('formDescription')}
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('duplicate')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <div className="grid gap-4 sm:grid-cols-2">
          {FIELDS.map((field) => (
            <TextField
              key={field}
              label={t(`fields.${field}`)}
              hint={field === 'phone' ? t('phoneHint') : undefined}
              error={fieldErrors[field]}
              type={field === 'email' ? 'email' : field === 'phone' ? 'tel' : 'text'}
              dir={field === 'email' || field === 'phone' ? 'ltr' : undefined}
              value={draft[field]}
              onChange={(event) => {
                setDraft((current) => ({ ...current, [field]: event.target.value }));
              }}
            />
          ))}
        </div>
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {t('submit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
