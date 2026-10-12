'use client';

import { BadgeCheck, Building2, CalendarClock, FileSearch, Store, TrendingUp } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Amount } from '@/components/ui/amount';
import { buttonClasses } from '@/components/ui/button';
import { StatCard } from '@/components/ui/card';
import { PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';

export default function AdminDashboardPage() {
  const t = useTranslations('admin.dashboard');
  const dashboard = useApiQuery(() => getApi().GET('/v1/admin/dashboard'), []);

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          <>
            <Link href="/admin/commercants" className={buttonClasses('secondary')}>
              <Store aria-hidden="true" className="size-icon-sm" />
              {t('createMerchant')}
            </Link>
            <Link href="/admin/validations" className={buttonClasses('primary')}>
              <BadgeCheck aria-hidden="true" className="size-icon-sm" />
              {t('seeApprovals')}
            </Link>
          </>
        }
      />
      {dashboard.status === 'loading' ? <LoadingBlock lines={4} /> : null}
      {dashboard.status === 'error' ? (
        <ErrorState error={dashboard.error} onRetry={dashboard.reload} />
      ) : null}
      {dashboard.status === 'success' ? (
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          <StatCard
            label={t('volume')}
            value={<Amount millimes={dashboard.data.todayVolumeMillimes} size="title" />}
            icon={<TrendingUp className="size-icon-md" />}
            tone="positive"
          />
          <StatCard
            label={t('approvals')}
            value={dashboard.data.pendingApprovalsCount}
            icon={<BadgeCheck className="size-icon-md" />}
            tone={dashboard.data.pendingApprovalsCount > 0 ? 'attention' : 'default'}
          />
          <StatCard
            label={t('nextSettlement')}
            value={<Amount millimes={dashboard.data.nextSettlementNetMillimes} size="title" />}
            icon={<CalendarClock className="size-icon-md" />}
          />
          <StatCard
            label={t('merchants')}
            value={dashboard.data.merchantsCount}
            icon={<Store className="size-icon-md" />}
          />
          <StatCard
            label={t('companies')}
            value={dashboard.data.companiesCount}
            icon={<Building2 className="size-icon-md" />}
          />
          <StatCard
            label={t('kyc')}
            value={dashboard.data.pendingKycCount}
            icon={<FileSearch className="size-icon-md" />}
            tone={dashboard.data.pendingKycCount > 0 ? 'attention' : 'default'}
          />
        </div>
      ) : null}
    </>
  );
}
