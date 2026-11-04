'use client';

import type { Schemas } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import type { Locale } from '@/i18n/routing';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey, fieldErrors as readFieldErrors } from '@/lib/api/problem';
import { Button } from '@/components/ui/button';
import { SelectField, TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { CreditTypeCheckboxes, type CreditType } from '@/components/ui/credit-type';
import { useToast } from '@/components/ui/toast';
import {
  CommissionGridEditor,
  EMPTY_GRID,
  readGrid,
  type GridErrorCode,
  type GridRow,
} from './commission-grid-editor';

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
  /** Field errors only (the value lives in its own state). */
  acceptedCreditTypes?: never;
}

const EMPTY: Draft = {
  name: '',
  category: '',
  city: '',
  phone: '+216',
  email: '',
};

/**
 * Creation of a merchant or a company account (admin space), in 2 steps: the information, then
 * the window « Commission » (grid, decision of 2026-11-03; spec admin-fenetre-commission).
 */
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
  const tWindow = useTranslations('admin.commissionWindow');
  const tCategory = useTranslations('category');
  const toast = useToast();
  const locale = useLocale() as Locale;
  const [step, setStep] = useState<1 | 2>(1);
  const [draft, setDraft] = useState<Draft>(EMPTY);
  const [types, setTypes] = useState<CreditType[]>([]);
  const [grid, setGrid] = useState<GridRow[]>(EMPTY_GRID);
  const [gridErrors, setGridErrors] = useState<Map<number, GridErrorCode | 'rate' | 'from' | 'to'>>(
    new Map(),
  );
  const [fieldErrors, setFieldErrors] = useState<Partial<Record<keyof Draft, string>>>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const typesError = fieldErrors.acceptedCreditTypes;
  const set = (field: keyof Draft) => (value: string) => {
    setDraft((current) => ({ ...current, [field]: value }));
  };

  const reset = () => {
    setStep(1);
    setDraft(EMPTY);
    setTypes([]);
    setGrid(EMPTY_GRID);
    setGridErrors(new Map());
  };

  /** Step 1: the required fields before the commission (the API checks them again). */
  function onContinue(event: SyntheticEvent) {
    event.preventDefault();
    const required = t('form.required');
    const missing: Partial<Record<keyof Draft, string>> = {
      ...(draft.name.trim() === '' ? { name: required } : {}),
      ...(draft.city.trim() === '' ? { city: required } : {}),
      ...(draft.email.trim() === '' ? { email: required } : {}),
      ...(draft.phone.replaceAll(' ', '').length < 12 ? { phone: required } : {}),
      ...(kind === 'merchant' && draft.category === '' ? { category: required } : {}),
      ...(kind === 'merchant' && types.length === 0 ? { acceptedCreditTypes: required } : {}),
    };
    setFieldErrors(missing);
    if (Object.keys(missing).length === 0) setStep(2);
  }

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const { tiers, errors } = readGrid(grid, locale);
    setGridErrors(errors);
    if (tiers === undefined) return;
    setSaving(true);
    setError(undefined);
    try {
      const common = {
        name: draft.name,
        city: draft.city,
        phone: draft.phone.replaceAll(' ', ''),
        email: draft.email.trim(),
        commissionGrid: tiers,
      };
      const result =
        kind === 'merchant'
          ? await getApi().POST('/v1/admin/merchants', {
              body: {
                ...common,
                category: draft.category as Schemas['MerchantCategory'],
                acceptedCreditTypes: types,
              },
            })
          : await getApi().POST('/v1/admin/companies', { body: common });
      if (result.data !== undefined) {
        toast.notify('success', t('createdToast', { name: result.data.name }));
        reset();
        onOpenChange(false);
        onCreated();
        return;
      }
      const fields = readFieldErrors(result.error);
      const onGrid = fields.filter((item) => item.pointer.startsWith('/commissionGrid'));
      const onInfo = fields.filter((item) => !item.pointer.startsWith('/commissionGrid'));
      if (onGrid.length > 0) {
        // The API checks the grid again: its errors go on the lines (index of the tiers sent).
        setGridErrors(
          new Map(
            onGrid.map((item) => [
              Number(item.pointer.split('/')[2] ?? 0),
              (item.code.startsWith('GRID_') ? item.code : 'GRID_BOUNDS') as GridErrorCode,
            ]),
          ),
        );
      }
      if (onInfo.length > 0) {
        setFieldErrors(
          Object.fromEntries(
            onInfo.map((item) => [
              item.pointer.slice(1),
              item.code === 'REQUIRED' || item.code === 'INVALID_ENUM'
                ? t('form.required')
                : t('form.invalidFormat'),
            ]),
          ),
        );
        setStep(1);
      }
      if (fields.length === 0) setError(result.error);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open={open}
      onOpenChange={onOpenChange}
      title={t('formTitle')}
      description={tWindow('stepOf', {
        step,
        name: step === 1 ? tWindow('stepInfo') : tWindow('stepCommission'),
      })}
      size="lg"
    >
      <form
        onSubmit={(event) => {
          if (step === 1) onContinue(event);
          else void onSubmit(event);
        }}
        className="flex flex-col gap-4"
        noValidate
      >
        {error !== undefined ? (
          <Alert tone="danger">
            {asProblem(error)?.code === 'RESOURCE_STATE_CONFLICT'
              ? t('duplicate')
              : tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        {step === 1 ? (
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
          </div>
        ) : (
          <CommissionGridEditor
            kind={kind}
            rows={grid}
            onChange={(rows) => {
              setGrid(rows);
              setGridErrors(new Map());
            }}
            errors={gridErrors}
          />
        )}
        <div className="flex justify-end gap-3">
          {step === 2 ? (
            <Button
              type="button"
              variant="secondary"
              onClick={() => {
                setStep(1);
              }}
            >
              {tWindow('back')}
            </Button>
          ) : null}
          <Button type="submit" loading={saving}>
            {step === 1 ? tWindow('continue') : t('submit')}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
