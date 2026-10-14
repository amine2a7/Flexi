'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey, fieldErrors as readFieldErrors } from '@/lib/api/problem';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatRateBps } from '@/lib/format/money';
import { Button } from '@/components/ui/button';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { CreditTypeCheckboxes, type CreditType } from '@/components/ui/credit-type';
import { useToast } from '@/components/ui/toast';

export type AccountKind = 'merchant' | 'company';

const CATEGORIES: Schemas['MerchantCategory'][] = [
  'RESTAURANT',
  'CAFE',
  'GROCERY',
  'BAKERY',
  'FAST_FOOD',
  'CLOTHING',
  'FUEL_STATION',
  'GIFT_SHOP',
];

interface Draft {
  name: string;
  category: string;
  city: string;
  phone: string;
  email: string;
  commissionProfileId: string;
  /** Field errors only (the value lives in its own state). */
  acceptedCreditTypes?: never;
}

const EMPTY: Draft = {
  name: '',
  category: '',
  city: '',
  phone: '+216',
  email: '',
  commissionProfileId: '',
};

/** Creation form of a merchant or a company account (admin space). */
export function AccountForm({
  kind,
  open,
  onOpenChange,
  onCreated,
}: {
  kind: AccountKind;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCreated: () => void;
}) {
  const ns = kind === 'merchant' ? 'admin.merchants' : 'admin.companies';
  const tRoot = useTranslations();
  const t = (key: string, values?: Record<string, string>) =>
    tRoot(messageKey(`${ns}.${key}`), values);
  const tCategory = useTranslations('category');
  const locale = useLocale();
  const toast = useToast();
  const [draft, setDraft] = useState<Draft>(EMPTY);
  const [types, setTypes] = useState<CreditType[]>([]);
  const [fieldErrors, setFieldErrors] = useState<Partial<Record<keyof Draft, string>>>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const profiles = useApiQuery(
    () =>
      kind === 'merchant'
        ? getApi().GET('/v1/admin/commission-profiles')
        : Promise.resolve({ data: { data: [] }, error: undefined }),
    [kind],
  );

  const typesError = fieldErrors.acceptedCreditTypes;
  const set = (field: keyof Draft) => (value: string) => {
    setDraft((current) => ({ ...current, [field]: value }));
  };

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSaving(true);
    setError(undefined);
    setFieldErrors({});
    try {
      const common = {
        name: draft.name,
        city: draft.city,
        phone: draft.phone.replaceAll(' ', ''),
        email: draft.email.trim(),
      };
      const result =
        kind === 'merchant'
          ? await getApi().POST('/v1/admin/merchants', {
              body: {
                ...common,
                category: draft.category as Schemas['MerchantCategory'],
                acceptedCreditTypes: types,
                // Optional: without a profile the rate of each credit type applies.
                ...(draft.commissionProfileId === ''
                  ? {}
                  : { commissionProfileId: draft.commissionProfileId }),
              },
            })
          : await getApi().POST('/v1/admin/companies', { body: common });
      if (result.data !== undefined) {
        toast.notify('success', t('createdToast', { name: result.data.name }));
        setDraft(EMPTY);
        setTypes([]);
        onOpenChange(false);
        onCreated();
        return;
      }
      const fields = readFieldErrors(result.error);
      if (fields.length > 0) {
        setFieldErrors(
          Object.fromEntries(
            fields.map((item) => [
              item.pointer.slice(1),
              item.code === 'REQUIRED' || item.code === 'INVALID_ENUM'
                ? t('form.required')
                : t('form.invalidFormat'),
            ]),
          ),
        );
      } else {
        setError(result.error);
      }
    } finally {
      setSaving(false);
    }
  }

  const profileOptions =
    profiles.status === 'success'
      ? profiles.data.data.map((profile) => ({
          value: profile.id,
          label: t('profileOption', {
            name: profile.name,
            rate: formatRateBps(profile.rateBps, locale),
          }),
        }))
      : [];

  return (
    <Modal
      open={open}
      onOpenChange={onOpenChange}
      title={t('formTitle')}
      description={t('formDescription')}
      size="lg"
    >
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('duplicate')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <div className="grid gap-4 sm:grid-cols-2">
          <TextField
            label={kind === 'merchant' ? t('fieldName') : t('name')}
            error={fieldErrors.name}
            value={draft.name}
            onChange={(event) => {
              set('name')(event.target.value);
            }}
            autoComplete="organization"
          />
          {kind === 'merchant' ? (
            <SelectField
              label={t('category')}
              placeholder={t('categoryPlaceholder')}
              error={fieldErrors.category}
              options={CATEGORIES.map((value) => ({ value, label: tCategory(value) }))}
              value={draft.category}
              onChange={(event) => {
                set('category')(event.target.value);
              }}
            />
          ) : null}
          <TextField
            label={t('form.city')}
            error={fieldErrors.city}
            value={draft.city}
            onChange={(event) => {
              set('city')(event.target.value);
            }}
          />
          <TextField
            label={t('form.phone')}
            hint={t('form.phoneHint')}
            error={fieldErrors.phone}
            type="tel"
            dir="ltr"
            value={draft.phone}
            onChange={(event) => {
              set('phone')(event.target.value);
            }}
          />
          <TextField
            label={t('form.email')}
            error={fieldErrors.email}
            type="email"
            dir="ltr"
            value={draft.email}
            onChange={(event) => {
              set('email')(event.target.value);
            }}
          />
          {kind === 'merchant' ? (
            <div className="sm:col-span-2">
              <CreditTypeCheckboxes
                legend={t('typesTitle')}
                hint={t('typesHint')}
                error={typesError}
                value={types}
                onChange={setTypes}
              />
            </div>
          ) : null}
          {kind === 'merchant' ? (
            <SelectField
              label={t('profile')}
              hint={t('profileHint')}
              placeholder={t('profilePlaceholder')}
              error={fieldErrors.commissionProfileId}
              options={profileOptions}
              value={draft.commissionProfileId}
              onChange={(event) => {
                set('commissionProfileId')(event.target.value);
              }}
            />
          ) : null}
        </div>
        <div className="flex justify-end">
          <Button type="submit" loading={saving}>
            {t('submit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
