'use client';

import { ShoppingCart, Users, Wallet, WalletCards } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { useSession } from '@/lib/session/session-context';
import { useOrderColumns } from '@/components/entreprise/order-columns';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle, StatCard } from '@/components/ui/card';
import { DataTable } from '@/components/ui/data-table';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';

export default function CompanyDashboardPage() {
  const t = useTranslations('company.dashboard');
  const { me } = useSession();
  const columns = useOrderColumns();
  const dashboard = useApiQuery(() => getApi().GET('/v1/company/dashboard'), []);

  return (
    <>
      <PageHeader
        title={t('title', { name: me.displayName })}
        description={t('description')}
        actions={
          <>
            <Link href="/entreprise/commandes/nouvelle" className={buttonClasses('secondary')}>
              <ShoppingCart aria-hidden="true" className="size-icon-sm" />
              {t('order')}
            </Link>
            <Link href="/entreprise/attribution" className={buttonClasses('primary')}>
              <WalletCards aria-hidden="true" className="size-icon-sm" />
              {t('allocate')}
            </Link>
          </>
        }
      />
      {dashboard.status === 'loading' ? <LoadingBlock lines={4} /> : null}
      {dashboard.status === 'error' ? (
        <ErrorState error={dashboard.error} onRetry={dashboard.reload} />
      ) : null}
      {dashboard.status === 'success' ? (
        <div className="flex flex-col gap-6">
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label={t('wallet')}
              value={<Amount millimes={dashboard.data.walletBalanceMillimes} size="title" />}
              hint={t('walletHint')}
              icon={<Wallet className="size-icon-md" />}
              tone="positive"
            />
            <StatCard
              label={t('employees')}
              value={dashboard.data.activeEmployeesCount}
              hint={t('employeesHint', { total: dashboard.data.employeesCount })}
              icon={<Users className="size-icon-md" />}
            />
            <StatCard
              label={t('allocated')}
              value={<Amount millimes={dashboard.data.monthAllocatedMillimes} size="title" />}
              icon={<WalletCards className="size-icon-md" />}
            />
            <StatCard
              label={t('pendingOrders')}
              value={dashboard.data.pendingOrdersCount}
              hint={t('pendingHint')}
              icon={<ShoppingCart className="size-icon-md" />}
              tone={dashboard.data.pendingOrdersCount > 0 ? 'attention' : 'default'}
            />
          </div>
          <Card>
            <CardTitle
              action={
                <Link href="/entreprise/commandes" className="text-label text-navy underline">
                  {t('seeOrders')}
                </Link>
              }
            >
              {t('recent')}
            </CardTitle>
            <DataTable
              caption={t('recent')}
              columns={columns}
              rows={dashboard.data.recentOrders}
              rowKey={(row) => row.id}
              empty={{ title: t('emptyTitle'), message: t('emptyMessage') }}
            />
          </Card>
        </div>
      ) : null}
    </>
  );
}
