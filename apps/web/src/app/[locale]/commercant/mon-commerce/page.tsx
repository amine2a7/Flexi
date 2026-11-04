'use client';

import { MapPin, UserRound } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Card, CardTitle } from '@/components/ui/card';
import { CommissionLabel, CreditTypeBadges } from '@/components/ui/credit-type';
import { DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';

export default function ShopPage() {
  const t = useTranslations('merchant.shop');
  const tShop = useTranslations('merchant.shop');
  const tCategory = useTranslations('category');
  const tSubRole = useTranslations('subRole');
  const profile = useApiQuery(() => getApi().GET('/v1/merchant/profile'), []);

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      {profile.status === 'loading' ? <LoadingBlock lines={5} /> : null}
      {profile.status === 'error' ? (
        <ErrorState error={profile.error} onRetry={profile.reload} />
      ) : null}
      {profile.status === 'success' ? (
        <div className="grid gap-6 lg:grid-cols-2">
          <Card className="lg:col-span-2">
            <CardTitle>{profile.data.name}</CardTitle>
            <DescriptionList
              items={[
                { label: t('category'), value: tCategory(profile.data.category) },
                {
                  label: tShop('acceptedTypes'),
                  value: <CreditTypeBadges types={profile.data.acceptedCreditTypes} />,
                },
                { label: t('city'), value: profile.data.city },
                { label: t('address'), value: profile.data.address },
                { label: t('phone'), value: <span dir="ltr">{profile.data.phone}</span> },
                { label: t('iban'), value: <span dir="ltr">{profile.data.maskedIban}</span> },
                {
                  label: t('commission'),
                  value: <CommissionLabel grid={profile.data.commissionGrid} />,
                },
              ]}
            />
            <p className="mt-4 text-caption text-text-muted">{t('changeHint')}</p>
          </Card>
          <Card>
            <CardTitle>{t('pointsOfSale')}</CardTitle>
            <ul className="flex flex-col gap-3">
              {profile.data.pointsOfSale.map((point) => (
                <li key={point.id} className="flex items-center gap-3">
                  <MapPin aria-hidden="true" className="size-icon-md text-text-muted" />
                  <div className="flex flex-col">
                    <span className="text-body text-text">{point.name}</span>
                    <span className="text-caption text-text-muted">{point.city}</span>
                  </div>
                </li>
              ))}
            </ul>
          </Card>
          <Card>
            <CardTitle>{t('staff')}</CardTitle>
            <ul className="flex flex-col gap-3">
              {profile.data.staff.map((member) => (
                <li key={member.id} className="flex items-center gap-3">
                  <UserRound aria-hidden="true" className="size-icon-md text-text-muted" />
                  <div className="flex flex-col">
                    <span className="text-body text-text">{member.displayName}</span>
                    <span className="text-caption text-text-muted">{tSubRole(member.subRole)}</span>
                  </div>
                </li>
              ))}
            </ul>
          </Card>
        </div>
      ) : null}
    </>
  );
}
