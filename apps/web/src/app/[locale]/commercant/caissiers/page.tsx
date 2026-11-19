'use client';

import type { Schemas } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Card, CardTitle } from '@/components/ui/card';
import { DataTable } from '@/components/ui/data-table';
import { SelectField } from '@/components/ui/field';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';
import { TeamUsers } from '@/components/team/team-users';

type TeamUser = Schemas['TeamUser'];

/**
 * Cashiers of the shop (W-FIN), managed by its owner: create (temporary password shown once),
 * new password, deactivate, and the till each cashier collects on.
 */
export default function CashiersPage() {
  const t = useTranslations('merchant.cashiers');
  const users = useApiQuery(() => getApi().GET('/v1/team/users'), []);
  const registers = useApiQuery(() => getApi().GET('/v1/merchant/registers'), []);
  const cashiers =
    users.status === 'success' ? users.data.data.filter((user) => user.subRole === 'CASHIER') : [];
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      {users.status === 'loading' ? <LoadingBlock lines={4} /> : null}
      {users.status === 'error' ? <ErrorState error={users.error} onRetry={users.reload} /> : null}
      {users.status === 'success' ? (
        <div className="flex flex-col gap-6">
          <Card>
            <TeamUsers
              scope={{ kind: 'owner', tenant: 'MERCHANT' }}
              users={cashiers}
              canManage
              onChange={users.reload}
            />
          </Card>
          <Card>
            <CardTitle description={t('tillsHint')}>{t('tillsTitle')}</CardTitle>
            <DataTable<TeamUser>
              caption={t('tillsTitle')}
              rows={cashiers.filter((user) => user.status !== 'DEACTIVATED')}
              rowKey={(user) => user.id}
              loading={registers.status === 'loading'}
              error={registers.status === 'error' ? registers.error : undefined}
              onRetry={registers.reload}
              empty={{ title: t('empty') }}
              columns={[
                {
                  key: 'name',
                  header: t('cashier'),
                  card: 'title',
                  cell: (user) => <bdi>{user.displayName}</bdi>,
                },
                {
                  key: 'till',
                  header: t('till'),
                  cell: (user) => (
                    <TillSelect
                      user={user}
                      registers={registers.status === 'success' ? registers.data.data : []}
                      onSaved={users.reload}
                    />
                  ),
                },
              ]}
            />
          </Card>
        </div>
      ) : null}
    </>
  );
}

function TillSelect({
  user,
  registers,
  onSaved,
}: {
  user: TeamUser;
  registers: readonly Schemas['Register'][];
  onSaved: () => void;
}) {
  const t = useTranslations('merchant.cashiers');
  const tRoot = useTranslations();
  const toast = useToast();
  const [saving, setSaving] = useState(false);
  return (
    <SelectField
      label={t('tillOf', { name: user.displayName })}
      placeholder={t('noTill')}
      disabled={saving}
      options={registers
        .filter((register) => register.status === 'ACTIVE' || register.id === user.registerId)
        .map((register) => ({ value: register.id, label: register.name }))}
      value={user.registerId ?? ''}
      onChange={(event) => {
        const registerId = event.target.value === '' ? null : event.target.value;
        setSaving(true);
        void getApi()
          .PUT('/v1/merchant/cashiers/{userId}/register', {
            params: { path: { userId: user.id } },
            body: { registerId },
          })
          .then(({ error }) => {
            if (error === undefined) {
              toast.notify('success', t('saved', { name: user.displayName }));
              onSaved();
            } else {
              toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
            }
          })
          .finally(() => {
            setSaving(false);
          });
      }}
    />
  );
}
