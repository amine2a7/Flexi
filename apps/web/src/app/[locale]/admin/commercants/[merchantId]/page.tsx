'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowLeft, Save } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { Link } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatDateTime } from '@/lib/format/date';
import { Button, buttonClasses } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import {
  CommissionLabel,
  CreditTypeCheckboxes,
  type CreditType,
} from '@/components/ui/credit-type';
import { Alert, DescriptionList, PageHeader } from '@/components/ui/layout-blocks';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { StatusBadge } from '@/components/ui/status-badge';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

/** Merchant record: details and the credit types the merchant accepts (set by the admin). */
export default function MerchantRecordPage() {
  const { merchantId } = useParams<{ merchantId: string }>();
  const t = useTranslations('admin.merchants');
  const merchant = useApiQuery(
    () => getApi().GET('/v1/admin/merchants/{merchantId}', { params: { path: { merchantId } } }),
    [merchantId],
  );
  return (
    <>
      <Link href="/admin/commercants" className={buttonClasses('ghost', 'sm', 'mb-4')}>
        <ArrowLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
        {t('detailBack')}
      </Link>
      {merchant.status === 'loading' ? <LoadingBlock lines={6} /> : null}
      {merchant.status === 'error' ? (
        <ErrorState error={merchant.error} onRetry={merchant.reload} />
      ) : null}
      {merchant.status === 'success' ? <MerchantRecord merchant={merchant.data} /> : null}
    </>
  );
}

function MerchantRecord({ merchant }: { merchant: Schemas['MerchantAccount'] }) {
  const t = useTranslations('admin.merchants');
  const tTypes = useTranslations('ui.creditTypes');
  const tCategory = useTranslations('category');
  const tRoot = useTranslations();
  const canManage = useCan('merchants.manage');
  const locale = useLocale();
  const toast = useToast();
  const [types, setTypes] = useState<CreditType[]>([...merchant.acceptedCreditTypes]);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [typesError, setTypesError] = useState<string | undefined>(undefined);

  async function save() {
    if (types.length === 0) {
      setTypesError(tTypes('pickOne'));
      return;
    }
    setTypesError(undefined);
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().PUT(
        '/v1/admin/merchants/{merchantId}/credit-types',
        { params: { path: { merchantId: merchant.id } }, body: { acceptedCreditTypes: types } },
      );
      if (data !== undefined) toast.notify('success', t('typesSaved'));
      else setError(problem);
    } finally {
      setSaving(false);
    }
  }

  return (
    <>
      <PageHeader
        title={merchant.name}
        description={tCategory(merchant.category)}
        actions={<StatusBadge status={merchant.status} />}
      />
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardTitle>{t('detailInfo')}</CardTitle>
          <DescriptionList
            items={[
              { label: t('category'), value: tCategory(merchant.category) },
              { label: t('city'), value: merchant.city },
              {
                label: t('profile'),
                value: <CommissionLabel profile={merchant.commissionProfile} />,
              },
              { label: t('created'), value: formatDateTime(merchant.createdAt, locale) },
            ]}
          />
        </Card>
        <Card>
          <CardTitle>{t('typesTitle')}</CardTitle>
          <div className="flex flex-col gap-4">
            {error !== undefined ? (
              <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
            ) : null}
            <CreditTypeCheckboxes
              legend={t('types')}
              hint={t('typesHint')}
              {...(typesError === undefined ? {} : { error: typesError })}
              value={types}
              onChange={setTypes}
            />
            {canManage ? (
              <Button
                loading={saving}
                icon={<Save aria-hidden="true" className="size-icon-sm" />}
                className="self-start"
                onClick={() => void save()}
              >
                {t('typesSave')}
              </Button>
            ) : null}
          </div>
        </Card>
      </div>
    </>
  );
}
