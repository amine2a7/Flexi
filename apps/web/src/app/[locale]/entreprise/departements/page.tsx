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
import { Modal } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';

type Department = Schemas['Department'];

/** Departments of the company (cahier ENT-04): name and number of employees attached. */
export default function DepartmentsPage() {
  const t = useTranslations('company.departments');
  const canManage = useCan('employees.manage');
  const departments = useApiQuery(() => getApi().GET('/v1/company/departments'), []);
  const [creating, setCreating] = useState(false);
  const columns: Column<Department>[] = [
    { key: 'name', header: t('name'), cell: (row) => <span dir="auto">{row.name}</span> },
    {
      key: 'count',
      header: t('employees'),
      align: 'end',
      cell: (row) => t('employeeCount', { count: row.employeeCount }),
    },
  ];
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
                setCreating(true);
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
            rows={departments.data.data}
            rowKey={(row) => row.id}
            empty={{ title: t('emptyTitle'), message: t('emptyText') }}
          />
        </Card>
      ) : null}
      {creating ? (
        <CreateDepartment
          onClose={() => {
            setCreating(false);
          }}
          onCreated={departments.reload}
        />
      ) : null}
    </>
  );
}

function CreateDepartment({ onClose, onCreated }: { onClose: () => void; onCreated: () => void }) {
  const t = useTranslations('company.departments');
  const tRoot = useTranslations();
  const toast = useToast();
  const [name, setName] = useState('');
  const [invalid, setInvalid] = useState<string | undefined>(undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    if (name.trim() === '') {
      setInvalid(t('required'));
      return;
    }
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/company/departments', {
        body: { name: name.trim() },
      });
      if (data !== undefined) {
        toast.notify('success', t('created', { name: data.name }));
        onCreated();
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
      title={t('create')}
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
            {t('submit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
