'use client';

import type { Schemas } from '@flexipay/api-client';
import { CalendarClock, Percent, SlidersHorizontal, Users, Wallet } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import type { Locale } from '@/i18n/routing';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatMillimes } from '@/lib/format/money';
import { parseBps, parseMillimes } from '@/lib/format/money-input';
import { Amount, Rate } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { StatCard } from '@/components/ui/card';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { ErrorState, LoadingBlock } from '@/components/ui/states';
import { useToast } from '@/components/ui/toast';

type Settings = Schemas['PlatformSettings'];

/** Basis points as the user types them (percent, locale decimal separator), integers only. */
function bpsToText(bps: number, locale: Locale): string {
  const fraction = bps % 100;
  if (fraction === 0) return String(Math.trunc(bps / 100));
  return `${Math.trunc(bps / 100)}${locale === 'en' ? '.' : ','}${String(fraction).padStart(2, '0')}`;
}

function integerIn(text: string, min: number, max: number): number | undefined {
  if (!/^[0-9]{1,3}$/.test(text.trim())) return undefined;
  const value = Number(text.trim());
  return value >= min && value <= max ? value : undefined;
}

export default function SettingsPage() {
  const t = useTranslations('admin.settings');
  const locale = useLocale();
  const settings = useApiQuery(() => getApi().GET('/v1/admin/settings'), []);
  const [editing, setEditing] = useState(false);

  return (
    <>
      <PageHeader
        title={t('title')}
        description={t('description')}
        actions={
          settings.status === 'success' ? (
            <Button
              icon={<SlidersHorizontal aria-hidden="true" className="size-icon-sm" />}
              onClick={() => setEditing(true)}
            >
              {t('request')}
            </Button>
          ) : null
        }
      />
      {settings.status === 'loading' ? <LoadingBlock lines={4} /> : null}
      {settings.status === 'error' ? (
        <ErrorState error={settings.error} onRetry={settings.reload} />
      ) : null}
      {settings.status === 'success' ? (
        <>
          <h2 className="mb-4 text-title-sm text-text">{t('current')}</h2>
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label={t('orderFee')}
              value={<Rate bps={settings.data.orderFeeRateBps} />}
              icon={<Percent className="size-icon-md" />}
            />
            <StatCard
              label={t('creditValidity')}
              value={t('creditValidityValue', { months: settings.data.creditValidityMonths })}
              icon={<CalendarClock className="size-icon-md" />}
            />
            <StatCard
              label={t('payoutMinimum')}
              value={<Amount millimes={settings.data.payoutMinimumMillimes} size="title" />}
              icon={<Wallet className="size-icon-md" />}
            />
            <StatCard
              label={t('maxFamily')}
              value={settings.data.maxFamilyMembers}
              icon={<Users className="size-icon-md" />}
            />
          </div>
          {editing ? (
            <ChangeSettings
              current={settings.data}
              locale={locale}
              onClose={() => setEditing(false)}
            />
          ) : null}
        </>
      ) : null}
    </>
  );
}

function ChangeSettings({
  current,
  locale,
  onClose,
}: {
  current: Settings;
  locale: Locale;
  onClose: () => void;
}) {
  const t = useTranslations('admin.settings');
  const tRoot = useTranslations();
  const toast = useToast();
  const [draft, setDraft] = useState({
    payoutMinimum: formatMillimes(current.payoutMinimumMillimes, locale),
    creditValidity: String(current.creditValidityMonths),
    maxFamily: String(current.maxFamilyMembers),
    orderFee: bpsToText(current.orderFeeRateBps, locale),
    reason: '',
  });
  const [invalid, setInvalid] = useState<Partial<Record<keyof typeof draft, string>>>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  const set = (field: keyof typeof draft) => (value: string) =>
    setDraft((previous) => ({ ...previous, [field]: value }));

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const settings = {
      payoutMinimumMillimes: parseMillimes(draft.payoutMinimum, locale),
      creditValidityMonths: integerIn(draft.creditValidity, 1, 60),
      maxFamilyMembers: integerIn(draft.maxFamily, 0, 10),
      orderFeeRateBps: parseBps(draft.orderFee, locale),
    };
    const message = t('invalid');
    const errors: Partial<Record<keyof typeof draft, string>> = {
      ...(settings.payoutMinimumMillimes === undefined ? { payoutMinimum: message } : {}),
      ...(settings.creditValidityMonths === undefined ? { creditValidity: message } : {}),
      ...(settings.maxFamilyMembers === undefined ? { maxFamily: message } : {}),
      ...(settings.orderFeeRateBps === undefined ? { orderFee: message } : {}),
      ...(draft.reason.trim() === '' ? { reason: tRoot('admin.merchants.form.required') } : {}),
    };
    setInvalid(errors);
    if (
      Object.keys(errors).length > 0 ||
      settings.payoutMinimumMillimes === undefined ||
      settings.creditValidityMonths === undefined ||
      settings.maxFamilyMembers === undefined ||
      settings.orderFeeRateBps === undefined
    ) {
      return;
    }
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().PUT('/v1/admin/settings', {
        body: {
          settings: {
            payoutMinimumMillimes: settings.payoutMinimumMillimes,
            creditValidityMonths: settings.creditValidityMonths,
            maxFamilyMembers: settings.maxFamilyMembers,
            orderFeeRateBps: settings.orderFeeRateBps,
          },
          reason: draft.reason.trim(),
        },
      });
      if (data !== undefined) {
        toast.notify('success', t('createdToast'));
        onClose();
        return;
      }
      setError(problem);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open
      onOpenChange={(open) => {
        if (!open && !saving) onClose();
      }}
      title={t('formTitle')}
      description={t('description')}
      size="lg"
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('pending')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <div className="grid gap-4 sm:grid-cols-2">
          <TextField
            label={t('payoutMinimumLabel')}
            error={invalid.payoutMinimum}
            inputMode="decimal"
            dir="ltr"
            value={draft.payoutMinimum}
            onChange={(event) => set('payoutMinimum')(event.target.value)}
          />
          <TextField
            label={t('creditValidityLabel')}
            error={invalid.creditValidity}
            inputMode="numeric"
            dir="ltr"
            value={draft.creditValidity}
            onChange={(event) => set('creditValidity')(event.target.value)}
          />
          <TextField
            label={t('maxFamilyLabel')}
            error={invalid.maxFamily}
            inputMode="numeric"
            dir="ltr"
            value={draft.maxFamily}
            onChange={(event) => set('maxFamily')(event.target.value)}
          />
          <TextField
            label={t('orderFeeLabel')}
            error={invalid.orderFee}
            inputMode="decimal"
            dir="ltr"
            value={draft.orderFee}
            onChange={(event) => set('orderFee')(event.target.value)}
          />
        </div>
        <TextField
          label={t('reason')}
          error={invalid.reason}
          value={draft.reason}
          maxLength={500}
          onChange={(event) => set('reason')(event.target.value)}
        />
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {t('submit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
