'use client';

import type { Schemas } from '@flexipay/api-client';
import { Plus } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { useCan } from '@/lib/session/session-context';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { DataTable, type Column } from '@/components/ui/data-table';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';

type Department = Schemas['Department'];
type Dialog =
  | { readonly kind: 'create' }
  | { readonly kind: 'rename' | 'delete'; readonly department: Department };

/**
 * Departments of the company (cahier ENT-04): name and number of employees attached; create,
 * rename, delete when it has no employee (request of 2026-11-14), otherwise a clear message.
 */
export default function DepartmentsPage() {
  const t = useTranslations('company.departments');
  const canManage = useCan('employees.manage');
  const departments = useApiQuery(() => getApi().GET('/v1/company/departments'), []);
  const [dialog, setDialog] = useState<Dialog | undefined>(undefined);
  const close = () => {
    setDialog(undefined);
  };
  const columns: Column<Department>[] = [
    { key: 'name', header: t('name'), cell: (row) => <span dir="auto">{row.name}</span> },
    {
      key: 'count',
      header: t('employees'),
      align: 'end',
      cell: (row) => t('employeeCount', { count: row.employeeCount }),
    },
  ];
  if (canManage) {
    columns.push({
      key: 'actions',
      header: t('actions'),
      card: 'footer',
      cell: (row) => (
        <div className="flex flex-wrap justify-end gap-2">
          <Button
            size="sm"
            variant="secondary"
            onClick={() => {
              setDialog({ kind: 'rename', department: row });
            }}
          >
            {t('rename')}
          </Button>
          <Button
            size="sm"
            variant="ghost"
            onClick={() => {
              setDialog({ kind: 'delete', department: row });
            }}
          >
            {t('delete')}
          </Button>
        </div>
      ),
    });
  }
  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          canManage ? (
            <Button
              icon={<Plus aria-hidden="true" className="size-icon-sm" />}
              onClick={() => {
                setDialog({ kind: 'create' });
              }}
            >
              {t('create')}
            </Button>
          ) : null
        }
      />
      {departments.status === 'loading' ? <LoadingBlock lines={3} /> : null}
      {departments.status === 'error' ? (
        <ErrorState error={departments.error} onRetry={departments.reload} />
      ) : null}
      {departments.status === 'success' ? (
        <Card>
          <DataTable
            caption={t('title')}
            columns={columns}
            rows={departments.data.data.filter((row) => !row.archived)}
            rowKey={(row) => row.id}
            empty={{ title: t('emptyTitle'), message: t('emptyText') }}
          />
        </Card>
      ) : null}
      {dialog?.kind === 'create' || dialog?.kind === 'rename' ? (
        <DepartmentForm
          {...(dialog.kind === 'rename' ? { department: dialog.department } : {})}
          onClose={close}
          onSaved={departments.reload}
        />
      ) : null}
      {dialog?.kind === 'delete' ? (
        <DeleteDepartment
          department={dialog.department}
          onClose={close}
          onDeleted={departments.reload}
        />
      ) : null}
    </>
  );
}

function DepartmentForm({
  department,
  onClose,
  onSaved,
}: {
  department?: Department;
  onClose: () => void;
  onSaved: () => void;
}) {
  const t = useTranslations('company.departments');
  const tRoot = useTranslations();
  const toast = useToast();
  const [name, setName] = useState(department?.name ?? '');
  const [invalid, setInvalid] = useState<string | undefined>(undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    if (name.trim() === '') {
      setInvalid(t('required'));
      return;
    }
    if (name.trim() === department?.name) {
      onClose();
      return;
    }
    setSaving(true);
    setError(undefined);
    try {
      const body = { name: name.trim() };
      const { data, error: problem } =
        department === undefined
          ? await getApi().POST('/v1/company/departments', { body })
          : await getApi().PATCH('/v1/company/departments/{departmentId}', {
              params: { path: { departmentId: department.id } },
              body,
            });
      if (data !== undefined) {
        toast.notify(
          'success',
          department === undefined
            ? t('created', { name: data.name })
            : t('renamed', { name: data.name }),
        );
        onSaved();
        onClose();
        return;
      }
      setError(problem);
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
      title={department === undefined ? t('create') : t('renameTitle', { name: department.name })}
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('duplicate')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <TextField
          label={t('name')}
          error={invalid}
          value={name}
          maxLength={80}
          onChange={(event) => {
            setName(event.target.value);
            setInvalid(undefined);
          }}
        />
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {department === undefined ? t('submit') : t('renameSubmit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}

/** Employees still attached (409 DEPARTMENT_NOT_EMPTY), or undefined for another refusal. */
function employeesLeft(error: unknown): number | undefined {
  const details = asProblem(error)?.details as
    { reason?: unknown; employeeCount?: unknown } | undefined;
  return details?.reason === 'DEPARTMENT_NOT_EMPTY' && typeof details.employeeCount === 'number'
    ? details.employeeCount
    : undefined;
}

function DeleteDepartment({
  department,
  onClose,
  onDeleted,
}: {
  department: Department;
  onClose: () => void;
  onDeleted: () => void;
}) {
  const t = useTranslations('company.departments');
  const tRoot = useTranslations();
  const toast = useToast();
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  // Known before the call: a department with employees is refused with the same clear message.
  const left = department.employeeCount > 0 ? department.employeeCount : employeesLeft(error);

  async function confirm() {
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/company/departments/{departmentId}/archive',
        { params: { path: { departmentId: department.id } } },
      );
      if (data !== undefined) {
        toast.notify('success', t('deleted', { name: department.name }));
        onDeleted();
        onClose();
        return;
      }
      setError(problem);
    } finally {
      setSaving(false);
    }
  }

  return (
    <ConfirmDialog
      open
      onOpenChange={(open) => {
        if (!open) onClose();
      }}
      title={t('deleteTitle', { name: department.name })}
      description={t('deleteText')}
      confirmLabel={t('deleteConfirm')}
      confirmVariant="danger"
      loading={saving}
      onConfirm={() => void confirm()}
    >
      {left !== undefined ? (
        <Alert tone="warning">{t('notEmpty', { count: left })}</Alert>
      ) : error !== undefined ? (
        <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
      ) : null}
    </ConfirmDialog>
  );
}
