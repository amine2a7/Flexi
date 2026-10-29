'use client';

import type { Schemas } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { messageKey } from '@/i18n/keys';
import { Button } from '@/components/ui/button';
import { SelectField, TextAreaField, TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { REASON_MAX, REASON_MIN } from '@/components/ui/reason-dialog';
import { useToast } from '@/components/ui/toast';

const SUB_ROLES: Schemas['AdminUserCreate']['subRole'][] = [
  'SUPPORT',
  'COMPLIANCE',
  'FINANCE',
  'SUPER_ADMIN',
];

/**
 * Creation of an administrator (admin-utilisateurs.md, écran C): immediate, no second validation
 * (decision A); an address already registered gets the same answer (no enumeration). Mounted only
 * while open, so each opening starts with an empty form.
 */
export function CreateAdministrator({
  open,
  onOpenChange,
  onCreated,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCreated: () => void;
}) {
  const t = useTranslations('admin.users.createForm');
  const tToast = useTranslations('admin.users.toast');
  const tReason = useTranslations('common.reason');
  const tSubRole = useTranslations('subRole');
  const tRoot = useTranslations();
  const toast = useToast();
  const [form, setForm] = useState({
    displayName: '',
    email: '',
    subRole: 'SUPPORT' as Schemas['AdminUserCreate']['subRole'],
    reason: '',
  });
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  const reasonLength = form.reason.trim().length;
  const ready =
    form.displayName.trim() !== '' && form.email.trim() !== '' && reasonLength >= REASON_MIN;

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    if (!ready) return;
    setSaving(true);
    setError(undefined);
    try {
      const { error: problem } = await getApi().POST('/v1/admin/users', {
        body: { ...form, displayName: form.displayName.trim(), reason: form.reason.trim() },
      });
      if (problem !== undefined) {
        setError(problem);
        return;
      }
      toast.notify('success', tToast('created', { email: form.email.trim() }));
      onOpenChange(false);
      onCreated();
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open={open}
      onOpenChange={onOpenChange}
      title={t('title')}
      description={t('description')}
    >
      <form onSubmit={(event) => void submit(event)} className="flex flex-col gap-4" noValidate>
        <TextField
          label={t('name')}
          required
          autoFocus
          maxLength={120}
          value={form.displayName}
          onChange={(event) => {
            setForm({ ...form, displayName: event.target.value });
          }}
        />
        <TextField
          label={t('email')}
          type="email"
          required
          dir="ltr"
          autoComplete="off"
          maxLength={254}
          value={form.email}
          onChange={(event) => {
            setForm({ ...form, email: event.target.value });
          }}
        />
        <SelectField
          label={t('subRole')}
          value={form.subRole}
          onChange={(event) => {
            setForm({ ...form, subRole: event.target.value as typeof form.subRole });
          }}
          options={SUB_ROLES.map((value) => ({ value, label: tSubRole(value) }))}
        />
        <TextAreaField
          label={tReason('label')}
          hint={`${tReason('hint')} ${tReason('counter', { count: reasonLength, max: REASON_MAX })}`}
          required
          maxLength={REASON_MAX}
          value={form.reason}
          onChange={(event) => {
            setForm({ ...form, reason: event.target.value });
          }}
        />
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <div className="flex flex-wrap justify-end gap-3">
          <Button
            variant="ghost"
            onClick={() => {
              onOpenChange(false);
            }}
          >
            {tReason('cancel')}
          </Button>
          <Button type="submit" loading={saving} disabled={!ready}>
            {t('submit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
