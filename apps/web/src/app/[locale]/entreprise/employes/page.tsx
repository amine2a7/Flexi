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
import { ReasonDialog } from '@/components/ui/reason-dialog';
import { UserStatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';
import { useCan, useCanOpen } from '@/lib/session/session-context';

type Employee = Schemas['Employee'];
type Draft = Schemas['EmployeeCreate'];
const STATUSES: Schemas['EmployeeStatus'][] = ['ACTIVE', 'INVITED', 'SUSPENDED', 'DEACTIVATED'];
type Lifecycle = 'suspend' | 'reactivate' | 'deactivate';

/** Transitions of an employee (commun-statut-utilisateur.md §3.1): none from DEACTIVATED. */
function transitions(status: Schemas['EmployeeStatus']): Lifecycle[] {
  if (status === 'DEACTIVATED') return [];
  return status === 'SUSPENDED' ? ['reactivate', 'deactivate'] : ['suspend', 'deactivate'];
}
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
  const [graceDays, setGraceDays] = useState<number | undefined>(undefined);
  // Result of the last status change, kept on the page (spec §6: persistent, never a toast).
  const [notice, setNotice] = useState<string | undefined>(undefined);
  const [target, setTarget] = useState<{ employee: Employee; action: Lifecycle } | undefined>(
    undefined,
  );
  const tLife = useTranslations('company.employees.lifecycle');
  const tReason = useTranslations('common.reason');
  const list = usePagedList(
    (cursor, withCount) =>
      getApi()
        .GET('/v1/company/employees', {
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
        })
        .then((result) => {
          // Grace period a deactivation would apply, sent with the list (never computed here).
          if (result.data?.graceDays !== undefined) setGraceDays(result.data.graceDays);
          return result;
        }),
    [filters, refresh],
  );

  const columns: Column<Employee>[] = [
    {
      key: 'name',
      header: t('name'),
      card: 'title',
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
    {
      key: 'phone',
      card: 'hidden',
      header: t('fields.phone'),
      cell: (row) => <span dir="ltr">{row.phone}</span>,
    },
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
      card: 'title',
      cell: (row) => <UserStatusBadge status={row.status} graceUntil={row.graceUntil} />,
      sortValue: (row) => row.status,
    },
    ...(canManage
      ? [
          {
            key: 'actions',
            header: tLife('actions'),
            card: 'footer' as const,
            align: 'end' as const,
            cell: (row: Employee) => {
              const available = transitions(row.status);
              if (available.length === 0)
                return <span className="text-caption text-text-muted">{tLife('none')}</span>;
              return (
                <span className="flex flex-wrap justify-end gap-2">
                  {available.map((action) => (
                    <Button
                      key={action}
                      size="sm"
                      variant="ghost"
                      aria-label={`${tLife(action)} ${row.firstName} ${row.lastName}`}
                      onClick={() => {
                        setTarget({ employee: row, action });
                      }}
                    >
                      {tLife(action)}
                    </Button>
                  ))}
                </span>
              );
            },
          },
        ]
      : []),
  ];

  async function changeStatus(employee: Employee, action: Lifecycle, reason: string) {
    const options = { params: { path: { employeeId: employee.id } }, body: { reason } };
    const result =
      action === 'suspend'
        ? await getApi().POST('/v1/company/employees/{employeeId}/suspend', options)
        : action === 'reactivate'
          ? await getApi().POST('/v1/company/employees/{employeeId}/reactivate', options)
          : await getApi().POST('/v1/company/employees/{employeeId}/deactivate', options);
    if (result.error !== undefined) return result.error;
    setNotice(tLife(`done.${action}`));
    setRefresh((value) => value + 1);
    return undefined;
  }

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
                variant="primary"
                icon={<UserPlus aria-hidden="true" className="size-icon-sm" />}
                onClick={() => {
                  setAdding(true);
                }}
              >
                {t('add')}
              </Button>
            ) : null}
            {canAllocate ? (
              <Link href="/entreprise/attribution" className={buttonClasses('secondary')}>
                <WalletCards aria-hidden="true" className="size-icon-sm" />
                {tDashboard('allocate')}
              </Link>
            ) : null}
          </>
        }
      />
      {notice !== undefined ? (
        <div role="status" className="mb-6">
          <Alert tone="success">{notice}</Alert>
        </div>
      ) : null}
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
      {target !== undefined ? (
        <ReasonDialog
          open
          onOpenChange={(open) => {
            if (!open) setTarget(undefined);
          }}
          title={tReason(`${target.action}.title`, {
            name: `${target.employee.firstName} ${target.employee.lastName}`,
          })}
          summary={[
            {
              label: tReason('person'),
              value: `${target.employee.firstName} ${target.employee.lastName} (${target.employee.employeeNumber})`,
            },
          ]}
          effects={
            target.action === 'suspend'
              ? [tReason('suspend.effect'), tReason('suspendEmployee.effect')]
              : target.action === 'reactivate'
                ? [tReason('reactivate.effect'), tReason('reactivateEmployee.effect')]
                : []
          }
          {...(target.action === 'deactivate'
            ? {
                warnings: [
                  ...(graceDays === undefined
                    ? []
                    : [tReason('deactivateEmployee.grace', { days: graceDays })]),
                  tReason('deactivateEmployee.family'),
                  tReason('deactivateEmployee.noCredit'),
                  tReason('deactivate.irreversible'),
                ],
              }
            : {})}
          {...(target.action === 'deactivate' && graceDays === undefined
            ? { blockedReason: tReason('graceUnavailable') }
            : {})}
          confirmLabel={
            target.action === 'deactivate'
              ? tReason('deactivateEmployee.confirm')
              : tReason(`${target.action}.confirm`)
          }
          confirmVariant={target.action === 'reactivate' ? 'primary' : 'danger'}
          onConfirm={(reason) => changeStatus(target.employee, target.action, reason)}
        />
      ) : null}
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
