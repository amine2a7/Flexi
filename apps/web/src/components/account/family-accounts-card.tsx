'use client';

import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { Card, CardTitle } from '@/components/ui/card';
import { useToast } from '@/components/ui/toast';
import { useCan } from '@/lib/session/session-context';

/** Company parameter (processus v2): family accounts allowed or not for its employees. */
export function FamilyAccountsCard() {
  const t = useTranslations('company.familyAccounts');
  const tRoot = useTranslations();
  const toast = useToast();
  const canManage = useCan('employees.manage');
  const [refresh, setRefresh] = useState(0);
  const [saving, setSaving] = useState(false);
  const setting = useApiQuery(() => getApi().GET('/v1/company/family-accounts'), [refresh]);
  if (setting.status !== 'success') return null;

  async function toggle(enabled: boolean) {
    setSaving(true);
    try {
      const { data, error } = await getApi().PUT('/v1/company/family-accounts', {
        body: { enabled },
      });
      if (data === undefined) toast.notify('error', tRoot(messageKey(errorMessageKey(error))));
      else toast.notify('success', data.enabled ? t('on') : t('off'));
      setRefresh((value) => value + 1);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Card className="mt-6">
      <CardTitle description={t('hint')}>{t('title')}</CardTitle>
      <label className="flex items-center gap-3 text-body text-text">
        <input
          type="checkbox"
          className="size-icon-sm accent-navy"
          checked={setting.data.enabled}
          disabled={!canManage || saving}
          onChange={(event) => void toggle(event.target.checked)}
        />
        {t('label')}
      </label>
    </Card>
  );
}
