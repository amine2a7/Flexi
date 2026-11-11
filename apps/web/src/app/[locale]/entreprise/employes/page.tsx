'use client';

import type { Schemas } from '@flexipay/api-client';
import { FileUp, UserPlus, WalletCards } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey, fieldErrors as readFieldErrors } from '@/lib/api/problem';
import { usePagedList } from '@/lib/api/use-paged-list';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextField } from '@/components/ui/field';
import { FilterBar } from '@/components/ui/filter-bar';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { ReasonDialog } from '@/components/ui/reason-dialog';
import { StatusBadge, UserStatusBadge } from '@/components/ui/status-badge';
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
type Department = Schemas['Department'];

/** Departments and positions in use, for the filters and the forms (processus v2). */
function useOrganisation(refresh: number) {
  const departments = useApiQuery(() => getApi().GET('/v1/company/departments'), [refresh]);
  const positions = useApiQuery(() => getApi().GET('/v1/company/positions'), [refresh]);
  return {
    all: departments.status === 'success' ? departments.data.data : ([] as Department[]),
    positions: positions.status === 'success' ? positions.data.data : ([] as string[]),
  };
}

/** Free-text position with the positions already used suggested while typing (processus v2). */
function PositionField({
  label,
  value,
  onChange,
  positions,
  id,
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
  positions: readonly string[];
  id: string;
}) {
  return (
    <>
      <TextField
        label={label}
        value={value}
        maxLength={80}
        list={id}
        autoComplete="off"
        onChange={(event) => {
          onChange(event.target.value);
        }}
      />
      <datalist id={id}>
        {positions.map((position) => (
          <option key={position} value={position} />
        ))}
      </datalist>
    </>
  );
}
const EMPTY: Draft = { employeeNumber: '', firstName: '', lastName: '', email: '', phone: '+216' };

export default function EmployeesPage() {
  const t = useTranslations('company.employees');
  const tDashboard = useTranslations('company.dashboard');
  const tStatus = useTranslations('statusLabel');
  const canManage = useCan('employees.manage');
  const canAllocate = useCanOpen('/entreprise/attribution');
  const canImport = useCanOpen('/entreprise/employes/import');
  const [filters, setFilters] = useState({ q: '', status: '' });
  const [departmentFilter, setDepartmentFilter] = useState('');
  const [positionFilter, setPositionFilter] = useState('');
  const [selected, setSelected] = useState<ReadonlySet<string>>(new Set());
  const [editing, setEditing] = useState<Employee[] | undefined>(undefined);
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
              ...(departmentFilter === '' ? {} : { departmentId: departmentFilter }),
              ...(positionFilter === '' ? {} : { position: positionFilter }),
            },
          },
        })
        .then((result) => {
          // Grace period a deactivation would apply, sent with the list (never computed here).
          if (result.data?.graceDays !== undefined) setGraceDays(result.data.graceDays);
          return result;
        }),
    [filters, departmentFilter, positionFilter, refresh],
  );
  const organisation = useOrganisation(refresh);
  const departmentName = (id: string | undefined) =>
    organisation.all.find((department) => department.id === id)?.name;
  const toggle = (id: string) => {
    setSelected((current) => {
      const next = new Set(current);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const columns: Column<Employee>[] = [
    ...(canManage
      ? [
          {
            key: 'select',
            header: t('select'),
            card: 'hidden' as const,
            cell: (row: Employee) => (
              <input
                type="checkbox"
                className="size-icon-md"
                aria-label={t('selectOne', { name: `${row.firstName} ${row.lastName}` })}
                checked={selected.has(row.id)}
                onChange={() => {
                  toggle(row.id);
                }}
              />
            ),
          },
        ]
      : []),
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
    {
      key: 'department',
      header: t('fields.department'),
      cell: (row) => departmentName(row.departmentId) ?? '—',
      sortValue: (row) => departmentName(row.departmentId) ?? '',
    },
    {
      key: 'position',
      header: t('fields.position'),
      cell: (row) => row.position ?? '—',
      sortValue: (row) => row.position ?? '',
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
      cell: (row) =>
        row.invitationExpired === true ? (
          <StatusBadge status="EXPIRED" labelKey="company.employees.invitationExpired" />
        ) : (
          <UserStatusBadge status={row.status} graceUntil={row.graceUntil} />
        ),
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
              return (
                <span className="flex flex-wrap justify-end gap-2">
                  <Button
                    size="sm"
                    variant="ghost"
                    aria-label={`${t('edit')} ${row.firstName} ${row.lastName}`}
                    onClick={() => {
                      setEditing([row]);
                    }}
                  >
                    {t('edit')}
                  </Button>
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
        <div className="mb-4 grid gap-4 sm:grid-cols-2">
          <SelectField
            label={t('fields.department')}
            placeholder={t('allDepartments')}
            options={organisation.all.map((department) => ({
              value: department.id,
              label: department.archived
                ? t('archivedDepartment', { name: department.name })
                : department.name,
            }))}
            value={departmentFilter}
            onChange={(event) => {
              setDepartmentFilter(event.target.value);
            }}
          />
          <SelectField
            label={t('fields.position')}
            placeholder={t('allPositions')}
            options={organisation.positions.map((position) => ({
              value: position,
              label: position,
            }))}
            value={positionFilter}
            onChange={(event) => {
              setPositionFilter(event.target.value);
            }}
          />
        </div>
        {canManage && selected.size > 0 ? (
          <div className="mb-4 flex flex-wrap items-center gap-3 rounded-card-desktop border border-border p-3">
            <span className="text-body text-text">
              {t('selectedCount', { count: selected.size })}
            </span>
            <Button
              size="sm"
              onClick={() => {
                setEditing((list.rows ?? []).filter((row) => selected.has(row.id)));
              }}
            >
              {t('bulkChange')}
            </Button>
            <Button
              size="sm"
              variant="ghost"
              onClick={() => {
                setSelected(new Set());
              }}
            >
              {t('clearSelection')}
            </Button>
          </div>
        ) : null}
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
        departments={organisation.all.filter((department) => !department.archived)}
        positions={organisation.positions}
        onCreated={() => {
          setRefresh((value) => value + 1);
        }}
      />
      {editing !== undefined ? (
        <AssignEmployees
          employees={editing}
          departments={organisation.all.filter((department) => !department.archived)}
          positions={organisation.positions}
          onClose={() => {
            setEditing(undefined);
          }}
          onDone={(message) => {
            setEditing(undefined);
            setSelected(new Set());
            setNotice(message);
            setRefresh((value) => value + 1);
          }}
        />
      ) : null}
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

/**
 * « Modifier » (one employee) or « Changer de département / de poste » (the selected ones):
 * an unchecked field is left as it is (processus v2).
 */
function AssignEmployees({
  employees,
  departments,
  positions,
  onClose,
  onDone,
}: {
  employees: readonly Employee[];
  departments: readonly Department[];
  positions: readonly string[];
  onClose: () => void;
  onDone: (message: string) => void;
}) {
  const t = useTranslations('company.employees');
  const tRoot = useTranslations();
  const single = employees.length === 1 ? employees[0] : undefined;
  const [departmentId, setDepartmentId] = useState(single?.departmentId ?? '');
  const [position, setPosition] = useState(single?.position ?? '');
  const [changeDepartment, setChangeDepartment] = useState(single !== undefined);
  const [changePosition, setChangePosition] = useState(single !== undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function save() {
    if (!changeDepartment && !changePosition) return;
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/employees/assignments', {
        body: {
          employeeIds: employees.map((employee) => employee.id),
          ...(changeDepartment ? { departmentId: departmentId === '' ? null : departmentId } : {}),
          ...(changePosition ? { position: position.trim() === '' ? null : position.trim() } : {}),
        },
      });
      if (data === undefined) setError(problem);
      else onDone(t('assigned', { count: employees.length }));
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open && !saving) onClose();
      }}
      title={
        single === undefined
          ? t('bulkTitle', { count: employees.length })
          : t('editTitle', { name: `${single.firstName} ${single.lastName}` })
      }
      footer={
        <div className="flex justify-end gap-2">
          <Button variant="ghost" disabled={saving} onClick={onClose}>
            {t('cancel')}
          </Button>
          <Button
            loading={saving}
            disabled={!changeDepartment && !changePosition}
            onClick={() => void save()}
          >
            {t('save')}
          </Button>
        </div>
      }
    >
      <div className="flex flex-col gap-4">
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        {single === undefined ? (
          <label className="flex items-center gap-2 text-body text-text">
            <input
              type="checkbox"
              className="size-icon-md"
              checked={changeDepartment}
              onChange={(event) => {
                setChangeDepartment(event.target.checked);
              }}
            />
            {t('changeDepartment')}
          </label>
        ) : null}
        {changeDepartment ? (
          <SelectField
            label={t('fields.department')}
            placeholder={t('noDepartment')}
            options={departments.map((department) => ({
              value: department.id,
              label: department.name,
            }))}
            value={departmentId}
            onChange={(event) => {
              setDepartmentId(event.target.value);
            }}
          />
        ) : null}
        {single === undefined ? (
          <label className="flex items-center gap-2 text-body text-text">
            <input
              type="checkbox"
              className="size-icon-md"
              checked={changePosition}
              onChange={(event) => {
                setChangePosition(event.target.checked);
              }}
            />
            {t('changePosition')}
          </label>
        ) : null}
        {changePosition ? (
          <PositionField
            id="assign-positions"
            label={t('fields.position')}
            value={position}
            onChange={setPosition}
            positions={positions}
          />
        ) : null}
      </div>
    </Modal>
  );
}

function AddEmployee({
  open,
  onOpenChange,
  onCreated,
  departments,
  positions,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCreated: () => void;
  departments: readonly Department[];
  positions: readonly string[];
}) {
  const t = useTranslations('company.employees');
  const tRoot = useTranslations();
  const toast = useToast();
  const { invitationDays } = usePlatformTerms();
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
        body: {
          ...draft,
          departmentId: draft.departmentId === '' ? null : (draft.departmentId ?? null),
          ...((draft.position ?? '').trim() === ''
            ? {}
            : { position: (draft.position ?? '').trim() }),
        },
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
      description={t('formDescription', { days: invitationDays })}
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
          <SelectField
            label={t('fields.department')}
            placeholder={t('noDepartment')}
            error={fieldErrors.departmentId}
            options={departments.map((department) => ({
              value: department.id,
              label: department.name,
            }))}
            value={draft.departmentId ?? ''}
            onChange={(event) => {
              setDraft((current) => ({ ...current, departmentId: event.target.value }));
            }}
          />
          <PositionField
            id="add-positions"
            label={t('fields.position')}
            value={draft.position ?? ''}
            onChange={(value) => {
              setDraft((current) => ({ ...current, position: value }));
            }}
            positions={positions}
          />
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
