'use client';

import { ArrowLeft } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { AccountRecordPanel } from '@/components/admin/account-record';
import { CompanyTabs } from '@/components/admin/client-tabs';
import { buttonClasses } from '@/components/ui/button';

/** Company record: every information editable, grid in four eyes, history (decision of 2026-11-03). */
export default function CompanyRecordPage() {
  const { companyId } = useParams<{ companyId: string }>();
  const t = useTranslations('admin.record');
  return (
    <>
      <Link href="/admin/entreprises" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('backCompanies')}
      </Link>
      <AccountRecordPanel
        owner={{ companyId }}
        withHeader
        wrap={(record) => <CompanyTabs companyId={companyId} info={record} />}
      />
    </>
  );
}
