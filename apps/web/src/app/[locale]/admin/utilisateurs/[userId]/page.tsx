'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import { useParams } from 'next/navigation';
import { useState } from 'react';
import { CredentialsDialog, type Credentials } from '@/components/admin/credentials-dialog';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { useCan, useSession } from '@/lib/session/session-context';
import { Amount } from '@/components/ui/amount';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { SelectField } from '@/components/ui/field';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ReasonDialog } from '@/components/ui/reason-dialog';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { UserStatusBadge } from '@/components/ui/status-badge';
import { Timeline } from '@/components/ui/timeline';

type User = Schemas['AdminUserDetail'];
type Action = 'suspend' | 'reactivate' | 'deactivate' | 'role' | 'resend' | 'unlock';
type SubRole = Schemas['SubRole'];

const SUB_ROLES: Partial<Record<Schemas['Role'], readonly SubRole[]>> = {
  ADMIN: ['SUPER_ADMIN', 'COMPLIANCE', 'FINANCE', 'SUPPORT'],
  COMPANY: ['OWNER', 'MANAGER', 'ACCOUNTANT', 'READ_ONLY'],
  MERCHANT: ['OWNER', 'CASHIER', 'ACCOUNTANT'],
};
const HISTORY_KEYS = new Set([
  'users.create',
  'users.suspend',
  'users.reactivate',
  'users.deactivate',
  'users.role',
  'users.resendInvitation',
  'users.unlockPin',
]);

/** Admin › Utilisateurs › fiche (admin-utilisateurs.md, écran B). */
export default function AdminUserPage() {
  const { userId } = useParams<{ userId: string }>();
  const t = useTranslations('admin.users');
  const query = useApiQuery(
    () => getApi().GET('/v1/admin/users/{userId}', { params: { path: { userId } } }),
    [userId],
  );
  return (
    <>
      <Link href="/admin/utilisateurs" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:-scale-x-100" />
        {t('detail.back')}
      </Link>
      {query.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {query.status === 'error' ? <ErrorState error={query.error} onRetry={query.reload} /> : null}
      {query.status === 'success' ? <UserView user={query.data} onChange={query.reload} /> : null}
    </>
  );
}

function UserView({ user, onChange }: { user: User; onChange: () => void }) {
  const t = useTranslations('admin.users');
  const tReason = useTranslations('common.reason');
  const { invitationDays } = usePlatformTerms();
  const tRole = useTranslations('layout.role');
  const tSubRole = useTranslations('subRole');
  const locale = useLocale();
  const { me } = useSession();
  const canManage = useCan('users.manage');
  const canAdminRoles = useCan('users.adminRoles');
  const canSupport = useCan('users.support');
  const [dialog, setDialog] = useState<Action | undefined>(undefined);
  const [newRole, setNewRole] = useState<SubRole | ''>('');
  // Result of the last change, kept on the page (spec §6: persistent, never a toast).
  const [notice, setNotice] = useState<string | undefined>(undefined);
  // The new temporary password, shown once (processus v2).
  const [credentials, setCredentials] = useState<Credentials | undefined>(undefined);

  const self = user.id === me.id;
  const manage = !self && canManage;
  const roleChoices = SUB_ROLES[user.role] ?? [];
  const canRole =
    !self &&
    user.status !== 'DEACTIVATED' &&
    roleChoices.length > 0 &&
    (user.role === 'ADMIN' ? canAdminRoles : canManage);
  const isEmployee = user.role === 'EMPLOYEE';
  const name = user.displayName;

  const actions: { key: Action; show: boolean; variant: 'danger' | 'secondary' }[] = [
    {
      key: 'suspend',
      show: manage && (user.status === 'ACTIVE' || user.status === 'INVITED'),
      variant: 'secondary',
    },
    { key: 'reactivate', show: manage && user.status === 'SUSPENDED', variant: 'secondary' },
    { key: 'deactivate', show: manage && user.status !== 'DEACTIVATED', variant: 'danger' },
  ];
  const visible = actions.filter((item) => item.show);
  const showResend =
    !self &&
    canSupport &&
    user.role !== 'ADMIN' &&
    (user.status === 'ACTIVE' || user.status === 'INVITED');
  const showUnlock = canSupport && user.pinLocked;
  const nothing = visible.length === 0 && !canRole && !showResend && !showUnlock;

  async function send(action: Action, reason: string): Promise<unknown> {
    const path = { params: { path: { userId: user.id } } };
    const result =
      action === 'role'
        ? await getApi().POST('/v1/admin/users/{userId}/role', {
            ...path,
            body: { subRole: newRole as SubRole, reason },
          })
        : action === 'suspend'
          ? await getApi().POST('/v1/admin/users/{userId}/suspend', { ...path, body: { reason } })
          : action === 'reactivate'
            ? await getApi().POST('/v1/admin/users/{userId}/reactivate', {
                ...path,
                body: { reason },
              })
            : await getApi().POST('/v1/admin/users/{userId}/deactivate', {
                ...path,
                body: { reason },
              });
    if (result.error !== undefined) return result.error;
    setNotice(t(`toast.${action}`));
    onChange();
    return undefined;
  }

  async function support(kind: 'resend' | 'unlock'): Promise<unknown> {
    const path = { params: { path: { userId: user.id } } };
    const result =
      kind === 'resend'
        ? await getApi().POST('/v1/admin/users/{userId}/reset-invitation', path)
        : await getApi().POST('/v1/admin/users/{userId}/unlock-pin', path);
    if (result.error !== undefined) return result.error;
    setNotice(t(`toast.${kind}`));
    if ('credentials' in result.data) setCredentials(result.data.credentials);
    else onChange();
    return undefined;
  }

  const deactivateWarnings = isEmployee
    ? [
        ...(user.graceDays === undefined
          ? []
          : [tReason('deactivateEmployee.grace', { days: user.graceDays })]),
        tReason('deactivateEmployee.family'),
        tReason('deactivateEmployee.noCredit'),
        tReason('deactivate.irreversible'),
      ]
    : [tReason('deactivate.irreversible')];
  const effects: Record<Action, string[]> = {
    suspend: [
      tReason('suspend.effect'),
      ...(isEmployee ? [tReason('suspendEmployee.effect')] : []),
    ],
    reactivate: [
      tReason('reactivate.effect'),
      ...(isEmployee ? [tReason('reactivateEmployee.effect')] : []),
    ],
    deactivate: isEmployee ? [] : [tReason('deactivate.effect')],
    role: [tReason('role.effect')],
    resend: [tReason('resend.effect', { days: invitationDays })],
    unlock: [tReason('unlock.effect')],
  };

  return (
    <>
      <PageHeader
        title={user.displayName}
        description={user.email}
        actions={<UserStatusBadge status={user.status} graceUntil={user.graceUntil} />}
      />
      {notice !== undefined ? (
        <div role="status" className="mb-6">
          <Alert tone="success">{notice}</Alert>
        </div>
      ) : null}
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardTitle>{t('detail.account')}</CardTitle>
          <DescriptionList
            items={[
              { label: t('detail.role'), value: tRole(user.role) },
              ...(user.subRole === null
                ? []
                : [{ label: t('detail.subRole'), value: tSubRole(user.subRole) }]),
              { label: t('detail.space'), value: user.tenant?.name ?? t('platform') },
              { label: t('detail.createdAt'), value: formatDateTime(user.createdAt, locale) },
              {
                label: t('detail.mfa'),
                value: user.mfaEnabled ? t('detail.mfaOn') : t('detail.mfaOff'),
              },
              ...(isEmployee
                ? [
                    {
                      label: t('detail.pin'),
                      value: user.pinLocked ? t('detail.pinLocked') : t('detail.pinOk'),
                    },
                  ]
                : []),
              ...(user.balanceMillimes === undefined
                ? []
                : [
                    {
                      label: t('detail.balance'),
                      value: <Amount millimes={user.balanceMillimes} />,
                    },
                  ]),
            ]}
          />
        </Card>
        <Card>
          <CardTitle>{t('detail.actions')}</CardTitle>
          <div className="flex flex-col gap-4">
            {self ? <p className="text-body text-text-muted">{t('detail.self')}</p> : null}
            {nothing && !self ? (
              <p className="text-body text-text-muted">{t('detail.noAction')}</p>
            ) : null}
            {visible.length > 0 ? (
              <div className="flex flex-wrap gap-3">
                {visible.map((item) => (
                  <Button
                    key={item.key}
                    variant={item.variant}
                    onClick={() => {
                      setDialog(item.key);
                    }}
                  >
                    {t(`actions.${item.key}`)}
                  </Button>
                ))}
              </div>
            ) : null}
            {canRole ? (
              <div className="flex flex-wrap items-end gap-3">
                <SelectField
                  label={t('detail.newRole')}
                  value={newRole}
                  placeholder={tSubRole(user.subRole ?? roleChoices[0] ?? 'OWNER')}
                  onChange={(event) => {
                    setNewRole(event.target.value as SubRole);
                  }}
                  options={roleChoices
                    .filter((value) => value !== user.subRole)
                    .map((value) => ({ value, label: tSubRole(value) }))}
                />
                <Button
                  variant="secondary"
                  disabled={newRole === ''}
                  onClick={() => {
                    setDialog('role');
                  }}
                >
                  {t('actions.role')}
                </Button>
              </div>
            ) : null}
            {showResend || showUnlock ? (
              <div className="flex flex-wrap gap-3">
                {showResend ? (
                  <Button
                    variant="ghost"
                    onClick={() => {
                      setDialog('resend');
                    }}
                  >
                    {t('actions.resend')}
                  </Button>
                ) : null}
                {showUnlock ? (
                  <Button
                    variant="ghost"
                    onClick={() => {
                      setDialog('unlock');
                    }}
                  >
                    {t('actions.unlock')}
                  </Button>
                ) : null}
              </div>
            ) : null}
          </div>
        </Card>
      </div>
      <Card className="mt-6">
        <CardTitle>{t('detail.history')}</CardTitle>
        {user.history.length === 0 ? (
          <p className="text-body text-text-muted">{t('detail.historyEmpty')}</p>
        ) : (
          <Timeline
            entries={user.history.map((entry, index) => ({
              key: `${entry.occurredAt}-${String(index)}`,
              title: HISTORY_KEYS.has(entry.action)
                ? t(`history.${entry.action.replace('.', '_')}` as 'history.other')
                : t('history.other'),
              meta: `${formatDateTime(entry.occurredAt, locale)} · ${entry.actorName}`,
              ...(entry.reason === null ? {} : { detail: entry.reason }),
            }))}
          />
        )}
      </Card>
      {dialog !== undefined ? (
        <ReasonDialog
          open
          onOpenChange={(open) => {
            if (!open) setDialog(undefined);
          }}
          title={tReason(`${dialog}.title`, { name })}
          summary={[
            { label: tReason('person'), value: name },
            ...(dialog === 'resend' || dialog === 'unlock'
              ? []
              : [
                  dialog === 'role'
                    ? {
                        label: `${tReason('from')} → ${tReason('to')}`,
                        value: `${user.subRole === null ? '—' : tSubRole(user.subRole)} → ${newRole === '' ? '—' : tSubRole(newRole)}`,
                      }
                    : {
                        label: `${tReason('from')} → ${tReason('to')}`,
                        value: `${t(`statuses.${user.status}`)} → ${t(
                          `statuses.${dialog === 'reactivate' ? 'ACTIVE' : dialog === 'suspend' ? 'SUSPENDED' : 'DEACTIVATED'}`,
                        )}`,
                      },
                ]),
          ]}
          effects={effects[dialog]}
          {...(dialog === 'deactivate' ? { warnings: deactivateWarnings } : {})}
          {...(dialog === 'deactivate' && isEmployee && user.graceDays === undefined
            ? { blockedReason: tReason('graceUnavailable') }
            : {})}
          confirmLabel={
            dialog === 'deactivate' && isEmployee
              ? tReason('deactivateEmployee.confirm')
              : tReason(`${dialog}.confirm`)
          }
          confirmVariant={dialog === 'suspend' || dialog === 'deactivate' ? 'danger' : 'primary'}
          withoutReason={dialog === 'resend' || dialog === 'unlock'}
          onConfirm={(reason) =>
            dialog === 'resend' || dialog === 'unlock' ? support(dialog) : send(dialog, reason)
          }
        />
      ) : null}
      <CredentialsDialog
        credentials={credentials}
        onClose={() => {
          setCredentials(undefined);
          onChange();
        }}
      />
    </>
  );
}
