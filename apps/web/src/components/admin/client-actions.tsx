'use client';

import type { Schemas } from '@flexipay/api-client';
import { UserPlus } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey, fieldErrors as readFieldErrors } from '@/lib/api/problem';
import { Button } from '@/components/ui/button';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { useToast } from '@/components/ui/toast';
import { CredentialsDialog, type Credentials } from './credentials-dialog';

type Draft = Schemas['EmployeeCreate'];
const FIELDS = ['employeeNumber', 'firstName', 'lastName', 'email', 'phone'] as const;
const EMPTY: Draft = { employeeNumber: '', firstName: '', lastName: '', email: '', phone: '+216' };

/**
 * « Fiche client › Employés › Ajouter un employé » (processus v2): same form as the company's; the
 * temporary password is shown once to the administrator, who hands it over.
 */
export function AdminAddEmployee({
  companyId,
  departments,
  onCreated,
}: {
  companyId: string;
  departments: readonly Schemas['Department'][];
  onCreated: () => void;
}) {
  const t = useTranslations('company.employees');
  const tTabs = useTranslations('admin.clientTabs');
  const tRoot = useTranslations();
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [draft, setDraft] = useState<Draft>(EMPTY);
  const [fieldErrors, setFieldErrors] = useState<Partial<Record<keyof Draft, string>>>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const [credentials, setCredentials] = useState<Credentials | undefined>(undefined);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSaving(true);
    setError(undefined);
    setFieldErrors({});
    try {
      const position = (draft.position ?? '').trim();
      const { data, error: problem } = await getApi().POST(
        '/v1/admin/companies/{companyId}/employees',
        {
          params: { path: { companyId } },
          body: {
            ...draft,
            departmentId: draft.departmentId === '' ? null : (draft.departmentId ?? null),
            ...(position === '' ? { position: undefined } : { position }),
          },
        },
      );
      if (data !== undefined) {
        toast.notify('success', t('created', { name: `${data.firstName} ${data.lastName}` }));
        setDraft(EMPTY);
        setOpen(false);
        setCredentials(data.credentials);
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
    <>
      <Button
        variant="secondary"
        size="sm"
        onClick={() => {
          setOpen(true);
        }}
      >
        <UserPlus aria-hidden className="size-icon-sm" />
        {tTabs('addEmployee')}
      </Button>
      <Modal open={open} onOpenChange={setOpen} title={t('formTitle')}>
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
              options={departments
                .filter((department) => !department.archived)
                .map((department) => ({ value: department.id, label: department.name }))}
              value={draft.departmentId ?? ''}
              onChange={(event) => {
                setDraft((current) => ({ ...current, departmentId: event.target.value }));
              }}
            />
            <TextField
              label={t('fields.position')}
              value={draft.position ?? ''}
              onChange={(event) => {
                setDraft((current) => ({ ...current, position: event.target.value }));
              }}
            />
          </div>
          <div className="flex justify-end">
            <Button type="submit" loading={saving}>
              {t('submit')}
            </Button>
          </div>
        </form>
      </Modal>
      <CredentialsDialog
        credentials={credentials}
        onClose={() => {
          setCredentials(undefined);
        }}
      />
    </>
  );
}

/** « Désactiver » a template of the company (it disappears from Modèles; history kept). */
export function AdminArchiveTemplate({
  companyId,
  template,
  onDone,
}: {
  companyId: string;
  template: Schemas['AllocationTemplate'];
  onDone: () => void;
}) {
  const t = useTranslations('admin.clientTabs');
  const tRoot = useTranslations();
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [sending, setSending] = useState(false);

  async function confirm() {
    setSending(true);
    try {
      const { error } = await getApi().DELETE(
        '/v1/admin/companies/{companyId}/allocation-templates/{templateId}',
        { params: { path: { companyId, templateId: template.id } } },
      );
      if (error === undefined) {
        toast.notify('success', t('templateArchived', { name: template.name }));
        setOpen(false);
        onDone();
      } else {
        toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
      }
    } finally {
      setSending(false);
    }
  }

  return (
    <>
      <Button
        variant="secondary"
        size="sm"
        onClick={() => {
          setOpen(true);
        }}
      >
        {t('archiveTemplate')}
      </Button>
      <ConfirmDialog
        open={open}
        onOpenChange={setOpen}
        title={t('archiveTemplateTitle', { name: template.name })}
        description={t('archiveTemplateHint')}
        confirmLabel={t('archiveTemplate')}
        confirmVariant="danger"
        onConfirm={() => void confirm()}
        loading={sending}
      />
    </>
  );
}
