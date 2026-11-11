'use client';

import type { Schemas } from '@flexipay/api-client';
import { Pencil, Repeat, Trash2 } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useMemo, useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { EMPTY_TEXTS, amountTexts, readAmounts } from '@/lib/allocation-amounts';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { Amount } from '@/components/ui/amount';
import { AmountField } from '@/components/ui/amount-field';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import {
  CREDIT_TYPES,
  CreditTypeBadge,
  useCreditTypeLabel,
  type CreditType,
} from '@/components/ui/credit-type';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { useToast } from '@/components/ui/toast';

type Template = Schemas['AllocationTemplate'];

/**
 * Crédits › Modèles (processus v2, processus 4): the saved allocations, each one its filters
 * (department, position) and its amount per type. « Relancer » opens the preview with the
 * current employees of the filters; « Modifier »; « Supprimer » (archived).
 */
export default function AllocationTemplatesPage() {
  const t = useTranslations('company.templates');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [refresh, setRefresh] = useState(0);
  const [editing, setEditing] = useState<Template | undefined>(undefined);
  const [deleting, setDeleting] = useState<Template | undefined>(undefined);
  const [busy, setBusy] = useState(false);
  const templates = useApiQuery(() => getApi().GET('/v1/company/allocation-templates'), [refresh]);

  async function remove(template: Template) {
    setBusy(true);
    try {
      const { response, error } = await getApi().DELETE(
        '/v1/company/allocation-templates/{templateId}',
        { params: { path: { templateId: template.id } } },
      );
      if (response.status === 204) {
        toast.notify('success', t('deleted', { name: template.name }));
        setRefresh((value) => value + 1);
      } else toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
    } finally {
      setBusy(false);
      setDeleting(undefined);
    }
  }

  const columns: Column<Template>[] = [
    {
      key: 'name',
      header: t('name'),
      cell: (row) => <span className="font-label">{row.name}</span>,
    },
    {
      key: 'filters',
      header: t('filters'),
      cell: (row) =>
        t('filtersValue', {
          department: row.departmentName ?? t('allDepartments'),
          position: row.position ?? t('allPositions'),
        }),
    },
    {
      key: 'amounts',
      header: t('amounts'),
      cell: (row) => (
        <span className="flex flex-wrap gap-2">
          {row.amounts.map((amount) => (
            <span key={amount.creditType} className="flex items-center gap-1">
              <CreditTypeBadge type={amount.creditType} />
              <Amount millimes={amount.amountMillimes} />
            </span>
          ))}
        </span>
      ),
    },
    {
      key: 'lastRun',
      header: t('lastRun'),
      cell: (row) => (row.lastRunAt === null ? t('never') : formatDateTime(row.lastRunAt, locale)),
    },
    {
      key: 'actions',
      header: t('actions'),
      cell: (row) => (
        <span className="flex flex-wrap gap-2">
          <Link
            href={`/entreprise/attribution?modele=${row.id}`}
            className={buttonClasses('primary', 'sm')}
          >
            <Repeat aria-hidden="true" className="size-icon-sm" />
            {t('relaunch')}
          </Link>
          <Button
            variant="secondary"
            size="sm"
            icon={<Pencil aria-hidden="true" className="size-icon-sm" />}
            onClick={() => {
              setEditing(row);
            }}
          >
            {t('edit')}
          </Button>
          <Button
            variant="ghost"
            size="sm"
            icon={<Trash2 aria-hidden="true" className="size-icon-sm" />}
            onClick={() => {
              setDeleting(row);
            }}
          >
            {t('delete')}
          </Button>
        </span>
      ),
    },
  ];

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <Link href="/entreprise/attribution" className={buttonClasses('secondary')}>
            {t('newAllocation')}
          </Link>
        }
      />
      <Card>
        <DataTable
          caption={t('title')}
          columns={columns}
          rows={templates.status === 'success' ? templates.data.data : undefined}
          rowKey={(row) => row.id}
          loading={templates.status === 'loading'}
          error={templates.status === 'error' ? templates.error : undefined}
          onRetry={() => {
            setRefresh((value) => value + 1);
          }}
          empty={{ title: t('emptyTitle'), message: t('emptyHint') }}
        />
      </Card>
      {editing !== undefined ? (
        <EditTemplate
          template={editing}
          onClose={() => {
            setEditing(undefined);
          }}
          onSaved={() => {
            setEditing(undefined);
            setRefresh((value) => value + 1);
          }}
        />
      ) : null}
      {deleting !== undefined ? (
        <ConfirmDialog
          open
          onOpenChange={(open) => {
            if (!open) setDeleting(undefined);
          }}
          title={t('deleteTitle')}
          description={t('deleteMessage', { name: deleting.name })}
          confirmLabel={t('delete')}
          confirmVariant="danger"
          loading={busy}
          onConfirm={() => void remove(deleting)}
        />
      ) : null}
    </>
  );
}

/** « Modifier »: name, filters and amounts; the next relaunch uses them. */
function EditTemplate({
  template,
  onClose,
  onSaved,
}: {
  template: Template;
  onClose: () => void;
  onSaved: () => void;
}) {
  const t = useTranslations('company.templates');
  const tRoot = useTranslations();
  const typeLabel = useCreditTypeLabel();
  const locale = useLocale();
  const toast = useToast();
  const [name, setName] = useState(template.name);
  const [departmentId, setDepartmentId] = useState(template.departmentId ?? '');
  const [position, setPosition] = useState(template.position ?? '');
  const [texts, setTexts] = useState<Record<CreditType, string>>(() =>
    template.amounts.length === 0 ? EMPTY_TEXTS : amountTexts(template.amounts, locale),
  );
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const departments = useApiQuery(() => getApi().GET('/v1/company/departments'), []);
  const positions = useApiQuery(() => getApi().GET('/v1/company/positions'), []);
  const { invalid, amounts } = useMemo(() => readAmounts(texts, locale), [texts, locale]);

  async function save() {
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().PUT(
        '/v1/company/allocation-templates/{templateId}',
        {
          params: { path: { templateId: template.id } },
          body: {
            name: name.trim(),
            departmentId: departmentId === '' ? null : departmentId,
            position: position === '' ? null : position,
            amounts,
          },
        },
      );
      if (data === undefined) setError(problem);
      else {
        toast.notify('success', t('saved', { name: data.name }));
        onSaved();
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open) onClose();
      }}
      title={t('editTitle')}
      description={t('editHint')}
      footer={
        <>
          <Button variant="secondary" onClick={onClose} disabled={saving}>
            {t('cancel')}
          </Button>
          <Button
            loading={saving}
            disabled={name.trim() === '' || invalid || amounts.length === 0}
            onClick={() => void save()}
          >
            {t('save')}
          </Button>
        </>
      }
    >
      <div className="flex flex-col gap-4">
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <TextField
          label={t('name')}
          maxLength={80}
          value={name}
          onChange={(event) => {
            setName(event.target.value);
          }}
        />
        <SelectField
          label={t('department')}
          placeholder={t('allDepartments')}
          options={(departments.status === 'success' ? departments.data.data : [])
            .filter((department) => !department.archived)
            .map((department) => ({ value: department.id, label: department.name }))}
          value={departmentId}
          onChange={(event) => {
            setDepartmentId(event.target.value);
          }}
        />
        <SelectField
          label={t('position')}
          placeholder={t('allPositions')}
          options={(positions.status === 'success' ? positions.data.data : []).map((item) => ({
            value: item,
            label: item,
          }))}
          value={position}
          onChange={(event) => {
            setPosition(event.target.value);
          }}
        />
        {CREDIT_TYPES.map((type) => (
          <AmountField
            key={type}
            label={t('amountOf', { type: typeLabel(type) })}
            value={texts[type]}
            onChange={(value) => {
              setTexts((current) => ({ ...current, [type]: value }));
            }}
          />
        ))}
      </div>
    </Modal>
  );
}
