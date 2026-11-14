'use client';

import { useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Card } from '@/components/ui/card';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { TeamUsers } from './team-users';

/** « Utilisateurs » page of an owner: its RH and Finance, or its cashiers (2026-11-14). */
export function TeamPage({ tenant }: { tenant: 'COMPANY' | 'MERCHANT' }) {
  const t = useTranslations('account.team');
  const users = useApiQuery(() => getApi().GET('/v1/team/users'), []);
  return (
    <>
      <PageHeader
        title={t('title')}
        description={tenant === 'COMPANY' ? t('descriptionCompany') : t('descriptionMerchant')}
      />
      {users.status === 'loading' ? <LoadingBlock lines={4} /> : null}
      {users.status === 'error' ? <ErrorState error={users.error} onRetry={users.reload} /> : null}
      {users.status === 'success' ? (
        <Card>
          <TeamUsers
            scope={{ kind: 'owner', tenant }}
            users={users.data.data}
            canManage
            onChange={users.reload}
          />
        </Card>
      ) : null}
    </>
  );
}
