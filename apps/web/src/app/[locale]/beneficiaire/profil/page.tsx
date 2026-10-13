'use client';

import { ShieldCheck } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { LocaleSwitcher } from '@/components/layout/locale-switcher';
import { buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';

/** Profile of the beneficiary: details provided by the company (read only), language, security. */
export default function BeneficiaryProfilePage() {
  const t = useTranslations('beneficiary.profile');
  const profile = useApiQuery(() => getApi().GET('/v1/employee/profile'), []);

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      {profile.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {profile.status === 'error' ? (
        <ErrorState error={profile.error} onRetry={profile.reload} />
      ) : null}
      {profile.status === 'success' ? (
        <div className="grid gap-6 lg:grid-cols-2">
          <Card>
            <DescriptionList
              items={[
                {
                  label: t('name'),
                  value: `${profile.data.firstName} ${profile.data.lastName}`,
                },
                {
                  label: t('employeeNumber'),
                  value: <span dir="ltr">{profile.data.employeeNumber}</span>,
                },
                { label: t('email'), value: <span dir="ltr">{profile.data.email}</span> },
                { label: t('phone'), value: <span dir="ltr">{profile.data.phone}</span> },
                { label: t('company'), value: profile.data.companyName },
              ]}
            />
            <div className="mt-4">
              <Alert tone="info">{t('note')}</Alert>
            </div>
          </Card>
          <div className="flex flex-col gap-6">
            <Card>
              <CardTitle description={t('languageHint')}>{t('language')}</CardTitle>
              <LocaleSwitcher />
            </Card>
            <Card>
              <CardTitle description={t('securityHint')}>{t('security')}</CardTitle>
              <Link href="/beneficiaire/securite" className={buttonClasses('secondary')}>
                <ShieldCheck aria-hidden="true" className="size-icon-md" />
                {t('openSecurity')}
              </Link>
            </Card>
          </div>
        </div>
      ) : null}
    </>
  );
}
