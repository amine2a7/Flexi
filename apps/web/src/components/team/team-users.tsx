'use client';

import type { Schemas } from '@flexipay/api-client';
import { Plus } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { CredentialsDialog, type Credentials } from '@/components/admin/credentials-dialog';
import { Button } from '@/components/ui/button';
import { DataTable, type Column } from '@/components/ui/data-table';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { ConfirmDialog, Modal } from '@/components/ui/modal';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { formatDateTime } from '@/lib/format/date';
import { useSession } from '@/lib/session/session-context';

type TeamUser = Schemas['TeamUser'];
type TeamSubRole = Schemas['TeamSubRole'];
type Tenant = 'COMPANY' | 'MERCHANT';

/** Whose users: the owner's own tenant (session), or a tenant record of the administrator. */
export type TeamScope =
  | { readonly kind: 'owner'; readonly tenant: Tenant }
  | { readonly kind: 'admin'; readonly tenant: Tenant; readonly tenantId: string };

/** Sub-roles of the tenant (request of 2026-11-14); an owner never gives « Propriétaire ». */
const SUB_ROLES: Record<Tenant, readonly TeamSubRole[]> = {
  COMPANY: ['OWNER', 'MANAGER', 'FINANCE'],
  MERCHANT: ['OWNER', 'CASHIER'],
};
const REASON_MIN = 10;
const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function assignable(scope: TeamScope): readonly TeamSubRole[] {
  const all = SUB_ROLES[scope.tenant];
  return scope.kind === 'admin' ? all : all.filter((subRole) => subRole !== 'OWNER');
}

function isTeamSubRole(scope: TeamScope, subRole: string | null): subRole is TeamSubRole {
  return subRole !== null && (assignable(scope) as readonly string[]).includes(subRole);
}

type Dialog =
  | { readonly kind: 'create' }
  | { readonly kind: 'edit' | 'reset' | 'deactivate'; readonly user: TeamUser };

/**
 * Users of a company (Propriétaire, RH, Finance) or of a merchant (Propriétaire, Caissier):
 * create, edit (name, role), new temporary password shown once with « Copier », deactivate. The
 * owner manages its RH and Finance (or cashiers); the super-admin every account, with a reason
 * written to the audit log. Without `canManage` the list is read only.
 */
export function TeamUsers({
  scope,
  users,
  canManage,
  onChange,
}: {
  scope: TeamScope;
  users: readonly TeamUser[];
  canManage: boolean;
  onChange: () => void;
}) {
  const t = useTranslations('account.team');
  const tSub = useTranslations('subRole');
  const locale = useLocale();
  const { me } = useSession();
  const [dialog, setDialog] = useState<Dialog | undefined>(undefined);
  const [credentials, setCredentials] = useState<Credentials | undefined>(undefined);

  const manageable = (user: TeamUser) =>
    canManage &&
    user.status !== 'DEACTIVATED' &&
    (scope.kind === 'admin' || (user.id !== me.id && isTeamSubRole(scope, user.subRole)));

  const columns: Column<TeamUser>[] = [
    {
      key: 'name',
      header: t('name'),
      card: 'title',
      cell: (row) => (
        <span dir="auto">
          {row.displayName}
          {row.id === me.id ? <span className="text-text-muted">{` · ${t('you')}`}</span> : null}
        </span>
      ),
    },
    { key: 'email', header: t('email'), cell: (row) => <span dir="ltr">{row.email}</span> },
    {
      key: 'role',
      header: t('role'),
      cell: (row) => (row.subRole === null ? '—' : tSub(row.subRole)),
    },
    {
      key: 'status',
      header: t('status'),
      cell: (row) => <StatusBadge status={row.status} context="user" />,
    },
    { key: 'date', header: t('createdAt'), cell: (row) => formatDateTime(row.createdAt, locale) },
  ];
  if (canManage) {
    columns.push({
      key: 'actions',
      header: t('actions'),
      card: 'footer',
      cell: (row) =>
        manageable(row) ? (
          <div className="flex flex-wrap gap-2">
            <Button
              size="sm"
              variant="secondary"
              onClick={() => {
                setDialog({ kind: 'edit', user: row });
              }}
            >
              {t('edit')}
            </Button>
            {row.status === 'ACTIVE' || row.status === 'INVITED' ? (
              <Button
                size="sm"
                variant="secondary"
                onClick={() => {
                  setDialog({ kind: 'reset', user: row });
                }}
              >
                {t('resetPassword')}
              </Button>
            ) : null}
            <Button
              size="sm"
              variant="ghost"
              onClick={() => {
                setDialog({ kind: 'deactivate', user: row });
              }}
            >
              {t('deactivate')}
            </Button>
          </div>
        ) : null,
    });
  }

  const close = () => {
    setDialog(undefined);
  };
  // The list reloads through a loading state that unmounts this component: with a password to
  // show, the reload waits until its window is closed (otherwise the password is never seen).
  const done = (next?: Credentials) => {
    setDialog(undefined);
    if (next === undefined) onChange();
    else setCredentials(next);
  };

  return (
    <div className="flex flex-col gap-4">
      {canManage ? (
        <div className="flex justify-end">
          <Button
            icon={<Plus aria-hidden="true" className="size-icon-sm" />}
            onClick={() => {
              setDialog({ kind: 'create' });
            }}
          >
            {t('add')}
          </Button>
        </div>
      ) : null}
      <DataTable
        caption={t('title')}
        columns={columns}
        rows={[...users]}
        rowKey={(row) => row.id}
        empty={{ title: t('emptyTitle'), message: t('emptyText') }}
      />
      {dialog?.kind === 'create' || dialog?.kind === 'edit' ? (
        <UserForm
          scope={scope}
          {...(dialog.kind === 'edit' ? { user: dialog.user } : {})}
          onClose={close}
          onDone={done}
        />
      ) : null}
      {dialog?.kind === 'reset' ? (
        <ResetPassword scope={scope} user={dialog.user} onClose={close} onDone={done} />
      ) : null}
      {dialog?.kind === 'deactivate' ? (
        <Deactivate scope={scope} user={dialog.user} onClose={close} onDone={done} />
      ) : null}
      <CredentialsDialog
        credentials={credentials}
        notice={t('credentialsNotice')}
        onClose={() => {
          setCredentials(undefined);
          onChange();
        }}
      />
    </div>
  );
}

/** The message of a refusal: an address already used, the last owner, or the generic one. */
function useProblemText() {
  const t = useTranslations('account.team');
  const tRoot = useTranslations();
  return (error: unknown, conflict: 'emailInUse' | 'lastOwner') =>
    asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
      ? t(conflict)
      : tRoot(messageKey(errorMessageKey(error)));
}

function ReasonField({
  value,
  error,
  onChange,
}: {
  value: string;
  error: string | undefined;
  onChange: (value: string) => void;
}) {
  const t = useTranslations('account.team');
  return (
    <TextField
      label={t('reason')}
      hint={t('reasonHint')}
      error={error}
      value={value}
      maxLength={500}
      onChange={(event) => {
        onChange(event.target.value);
      }}
    />
  );
}

function UserForm({
  scope,
  user,
  onClose,
  onDone,
}: {
  scope: TeamScope;
  user?: TeamUser;
  onClose: () => void;
  onDone: (credentials?: Credentials) => void;
}) {
  const t = useTranslations('account.team');
  const tSub = useTranslations('subRole');
  const toast = useToast();
  const problemText = useProblemText();
  const roles = assignable(scope);
  const current = user !== undefined && isTeamSubRole(scope, user.subRole) ? user.subRole : '';
  const [name, setName] = useState(user?.displayName ?? '');
  const [email, setEmail] = useState('');
  const [subRole, setSubRole] = useState<string>(user === undefined ? (roles[0] ?? '') : current);
  const [reason, setReason] = useState('');
  const [invalid, setInvalid] = useState<
    Partial<Record<'name' | 'email' | 'role' | 'reason', string>>
  >({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const withReason = scope.kind === 'admin' && user !== undefined;

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const next: typeof invalid = {};
    if (name.trim() === '') next.name = t('required');
    if (user === undefined && !EMAIL.test(email.trim())) next.email = t('invalidEmail');
    if (!isTeamSubRole(scope, subRole)) next.role = t('required');
    if (withReason && reason.trim().length < REASON_MIN) next.reason = t('reasonShort');
    setInvalid(next);
    if (Object.keys(next).length > 0 || !isTeamSubRole(scope, subRole)) return;
    setSaving(true);
    setError(undefined);
    try {
      const api = getApi();
      if (user === undefined) {
        const body = { displayName: name.trim(), email: email.trim(), subRole };
        const result =
          scope.kind === 'owner'
            ? await api.POST('/v1/team/users', { body })
            : scope.tenant === 'COMPANY'
              ? await api.POST('/v1/admin/companies/{companyId}/users', {
                  params: { path: { companyId: scope.tenantId } },
                  body,
                })
              : await api.POST('/v1/admin/merchants/{merchantId}/users', {
                  params: { path: { merchantId: scope.tenantId } },
                  body,
                });
        if (result.data !== undefined) {
          toast.notify('success', t('created', { name: body.displayName }));
          onDone(result.data.credentials);
          return;
        }
        setError(result.error);
        return;
      }
      const change = {
        ...(name.trim() === user.displayName ? {} : { displayName: name.trim() }),
        ...(subRole === user.subRole ? {} : { subRole }),
      };
      if (Object.keys(change).length === 0) {
        onClose();
        return;
      }
      const path = { params: { path: { userId: user.id } } };
      const result =
        scope.kind === 'owner'
          ? await api.PATCH('/v1/team/users/{userId}', { ...path, body: change })
          : await api.PATCH('/v1/admin/users/{userId}', {
              ...path,
              body: { ...change, reason: reason.trim() },
            });
      if (result.data !== undefined) {
        toast.notify('success', t('updated', { name: result.data.displayName }));
        onDone();
        return;
      }
      setError(result.error);
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
      title={user === undefined ? t('createTitle') : t('editTitle', { name: user.displayName })}
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {problemText(error, user === undefined ? 'emailInUse' : 'lastOwner')}
          </Alert>
        ) : null}
        <TextField
          label={t('name')}
          error={invalid.name}
          value={name}
          maxLength={120}
          autoComplete="off"
          onChange={(event) => {
            setName(event.target.value);
          }}
        />
        {user === undefined ? (
          <TextField
            label={t('email')}
            type="email"
            dir="ltr"
            error={invalid.email}
            value={email}
            maxLength={254}
            autoComplete="off"
            onChange={(event) => {
              setEmail(event.target.value);
            }}
          />
        ) : null}
        <SelectField
          label={t('role')}
          error={invalid.role}
          value={subRole}
          options={roles.map((role) => ({ value: role, label: tSub(role) }))}
          {...(current === '' && user !== undefined ? { placeholder: '—' } : {})}
          onChange={(event) => {
            setSubRole(event.target.value);
          }}
        />
        {withReason ? (
          <ReasonField value={reason} error={invalid.reason} onChange={setReason} />
        ) : null}
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {user === undefined ? t('submitCreate') : t('submitEdit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}

function ResetPassword({
  scope,
  user,
  onClose,
  onDone,
}: {
  scope: TeamScope;
  user: TeamUser;
  onClose: () => void;
  onDone: (credentials?: Credentials) => void;
}) {
  const t = useTranslations('account.team');
  const problemText = useProblemText();
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function confirm() {
    setSaving(true);
    setError(undefined);
    try {
      const path = { params: { path: { userId: user.id } } };
      const api = getApi();
      const result =
        scope.kind === 'owner'
          ? await api.POST('/v1/team/users/{userId}/reset-password', path)
          : await api.POST('/v1/admin/users/{userId}/reset-invitation', path);
      if (result.data !== undefined) {
        onDone('credentials' in result.data ? result.data.credentials : undefined);
        return;
      }
      setError(result.error);
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
      title={t('resetTitle', { name: user.displayName })}
      description={t('resetText')}
      confirmLabel={t('resetConfirm')}
      loading={saving}
      onConfirm={() => void confirm()}
    >
      {error !== undefined ? <Alert tone="danger">{problemText(error, 'lastOwner')}</Alert> : null}
    </ConfirmDialog>
  );
}

function Deactivate({
  scope,
  user,
  onClose,
  onDone,
}: {
  scope: TeamScope;
  user: TeamUser;
  onClose: () => void;
  onDone: () => void;
}) {
  const t = useTranslations('account.team');
  const toast = useToast();
  const problemText = useProblemText();
  const [reason, setReason] = useState('');
  const [invalid, setInvalid] = useState<string | undefined>(undefined);
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function confirm() {
    if (scope.kind === 'admin' && reason.trim().length < REASON_MIN) {
      setInvalid(t('reasonShort'));
      return;
    }
    setSaving(true);
    setError(undefined);
    try {
      const path = { params: { path: { userId: user.id } } };
      const api = getApi();
      const result =
        scope.kind === 'owner'
          ? await api.POST('/v1/team/users/{userId}/deactivate', path)
          : await api.POST('/v1/admin/users/{userId}/deactivate', {
              ...path,
              body: { reason: reason.trim() },
            });
      if (result.data !== undefined) {
        toast.notify('success', t('deactivated', { name: user.displayName }));
        onDone();
        return;
      }
      setError(result.error);
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
      title={t('deactivateTitle', { name: user.displayName })}
      description={t('deactivateText')}
      confirmLabel={t('deactivateConfirm')}
      confirmVariant="danger"
      loading={saving}
      onConfirm={() => void confirm()}
    >
      <div className="flex flex-col gap-4">
        {error !== undefined ? (
          <Alert tone="danger">{problemText(error, 'lastOwner')}</Alert>
        ) : null}
        {scope.kind === 'admin' ? (
          <ReasonField
            value={reason}
            error={invalid}
            onChange={(value) => {
              setReason(value);
              setInvalid(undefined);
            }}
          />
        ) : null}
      </div>
    </ConfirmDialog>
  );
}
