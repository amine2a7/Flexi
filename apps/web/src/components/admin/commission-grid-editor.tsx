'use client';

import type { Schemas } from '@flexipay/api-client';
import {
  commissionGridSchema,
  orderBreakdown,
  payoutBreakdown,
  type CommissionTier,
  type Taxes,
} from '@flexipay/shared';
import { Plus, Trash2 } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import type { Locale } from '@/i18n/routing';
import { getApi } from '@/lib/api/client';
import { useApiQuery } from '@/lib/api/use-api-query';
import { formatMillimes, formatRateBps } from '@/lib/format/money';
import { parseBps, parseMillimes } from '@/lib/format/money-input';
import { AmountBreakdown } from '@/components/ui/amount';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { TextField } from '@/components/ui/field';

/** A line as typed: percent and TND texts (the first line is the default rate, no bounds). */
export interface GridRow {
  rate: string;
  from: string;
  to: string;
}

export const EMPTY_GRID: GridRow[] = [{ rate: '', from: '', to: '' }];

/** Field error of a line: the text field concerned or the whole line (overlap, bounds). */
export type RowErrors = Partial<Record<'rate' | 'from' | 'to' | 'line', string>>;

/** Grid error codes of the API and of the shared schema (decision of 2026-11-04). */
export type GridErrorCode =
  'GRID_OVERLAP' | 'GRID_BOUNDS' | 'GRID_DEFAULT_REQUIRED' | 'GRID_DEFAULT_DUPLICATE';

/**
 * Lines as the API wants them (the default line first), with the errors of each line: parsing of
 * the texts, then the shared rules (no overlap, bounds included). `tiers` only when all is valid.
 */
export function readGrid(
  rows: readonly GridRow[],
  locale: Locale,
): { tiers?: CommissionTier[]; errors: Map<number, GridErrorCode | 'rate' | 'from' | 'to'> } {
  const errors = new Map<number, GridErrorCode | 'rate' | 'from' | 'to'>();
  const tiers = rows.map((row, index): CommissionTier => {
    const rateBps = parseBps(row.rate, locale);
    if (rateBps === undefined || rateBps > 10_000) errors.set(index, 'rate');
    const bound = (text: string, field: 'from' | 'to') => {
      if (index === 0 || text.trim() === '') return null;
      const value = parseMillimes(text, locale);
      if (value === undefined) errors.set(index, field);
      return value ?? null;
    };
    return {
      rateBps: rateBps ?? 0,
      minMillimes: bound(row.from, 'from'),
      maxMillimes: bound(row.to, 'to'),
    };
  });
  // A tranche needs at least one bound, otherwise it is a second default line.
  rows.forEach((row, index) => {
    if (index > 0 && row.from.trim() === '' && row.to.trim() === '' && !errors.has(index))
      errors.set(index, 'GRID_DEFAULT_DUPLICATE');
  });
  if (errors.size > 0) return { errors };
  const checked = commissionGridSchema.safeParse(tiers);
  if (!checked.success) {
    for (const issue of checked.error.issues) {
      const code = (issue as { params?: { fieldCode?: GridErrorCode } }).params?.fieldCode;
      const index = typeof issue.path[0] === 'number' ? issue.path[0] : 0;
      if (code !== undefined && !errors.has(index)) errors.set(index, code);
    }
    return { errors };
  }
  return { tiers, errors };
}

/** Window « Commission » (step 2 of the creation of a company or a merchant), spec admin-fenetre-commission. */
export function CommissionGridEditor({
  kind,
  rows,
  onChange,
  errors,
  legalForm,
}: {
  kind: 'company' | 'merchant';
  rows: readonly GridRow[];
  onChange: (rows: GridRow[]) => void;
  errors: ReadonlyMap<number, GridErrorCode | 'rate' | 'from' | 'to'>;
  /** Legal form chosen at creation: the preview applies its withholding rate (processus v2). */
  legalForm?: Schemas['LegalForm'];
}) {
  const t = useTranslations('admin.commissionWindow');
  const locale = useLocale();
  const set = (index: number, field: keyof GridRow) => (value: string) => {
    onChange(rows.map((row, at) => (at === index ? { ...row, [field]: value } : row)));
  };
  const add = () => {
    // The next tranche starts 0,001 TND after the max of the previous one (decision 2026-11-04).
    const previous = rows.length > 1 ? rows[rows.length - 1] : undefined;
    const max = previous === undefined ? undefined : parseMillimes(previous.to, locale);
    const from = max === undefined ? '' : formatMillimes(max + 1, locale);
    onChange([...rows, { rate: '', from, to: '' }]);
  };
  const remove = (index: number) => {
    onChange(rows.filter((_, at) => at !== index));
  };
  const messageOf = (index: number, field: 'rate' | 'from' | 'to' | 'line'): string | undefined => {
    const error = errors.get(index);
    if (error === undefined) return undefined;
    if (field === 'line') {
      if (error === 'GRID_OVERLAP') return t('errors.overlap');
      if (error === 'GRID_BOUNDS') return t('errors.bounds');
      if (error === 'GRID_DEFAULT_DUPLICATE' || error === 'GRID_DEFAULT_REQUIRED')
        return t('errors.noBound');
      return undefined;
    }
    if (error !== field) return undefined;
    return field === 'rate' ? t('errors.rate') : t('errors.amount');
  };

  return (
    <div className="flex flex-col gap-5">
      <TextField
        label={t('defaultRate')}
        hint={t('defaultRateHint')}
        error={messageOf(0, 'rate')}
        inputMode="decimal"
        dir="ltr"
        value={rows[0]?.rate ?? ''}
        onChange={(event) => {
          set(0, 'rate')(event.target.value);
        }}
      />
      <section aria-labelledby="commission-tranches" className="flex flex-col gap-3">
        <h3 id="commission-tranches" className="text-label text-text">
          {t('tranches')}
        </h3>
        {rows.length > 1 ? (
          <ol className="flex flex-col gap-4">
            {rows.slice(1).map((row, offset) => {
              const index = offset + 1;
              const line = messageOf(index, 'line');
              return (
                <li key={index} aria-label={t('tranche', { number: index })}>
                  <div className="grid grid-cols-1 items-end gap-3 sm:grid-cols-4">
                    <TextField
                      label={t('rate')}
                      error={messageOf(index, 'rate')}
                      inputMode="decimal"
                      dir="ltr"
                      value={row.rate}
                      onChange={(event) => {
                        set(index, 'rate')(event.target.value);
                      }}
                    />
                    <TextField
                      label={t('from')}
                      error={messageOf(index, 'from')}
                      inputMode="decimal"
                      dir="ltr"
                      value={row.from}
                      onChange={(event) => {
                        set(index, 'from')(event.target.value);
                      }}
                    />
                    <TextField
                      label={t('to')}
                      hint={t('toHint')}
                      error={messageOf(index, 'to')}
                      inputMode="decimal"
                      dir="ltr"
                      value={row.to}
                      onChange={(event) => {
                        set(index, 'to')(event.target.value);
                      }}
                    />
                    <Button
                      type="button"
                      variant="secondary"
                      icon={<Trash2 aria-hidden="true" className="size-icon-sm" />}
                      aria-label={t('removeTranche', { number: index })}
                      onClick={() => {
                        remove(index);
                      }}
                    />
                  </div>
                  {line !== undefined ? (
                    <p role="alert" className="mt-2 text-caption text-danger-text">
                      {line}
                    </p>
                  ) : null}
                </li>
              );
            })}
          </ol>
        ) : null}
        <div>
          <Button
            type="button"
            variant="secondary"
            size="sm"
            icon={<Plus aria-hidden="true" className="size-icon-sm" />}
            onClick={add}
          >
            {t('addTranche')}
          </Button>
        </div>
      </section>
      <GridPreview kind={kind} rows={rows} legalForm={legalForm} />
    </div>
  );
}

/** Indicative example of the computation (shared rule); the official amount comes from the API. */
function GridPreview({
  kind,
  rows,
  legalForm,
}: {
  kind: 'company' | 'merchant';
  rows: readonly GridRow[];
  legalForm: Schemas['LegalForm'] | undefined;
}) {
  const t = useTranslations('admin.commissionWindow');
  const locale = useLocale();
  const [amountText, setAmountText] = useState('');
  const settings = useApiQuery(() => getApi().GET('/v1/admin/settings'), []);
  // The preview uses the taxes and fees of the settings only: never a value of its own.
  const taxes: Taxes | undefined =
    settings.status === 'success' ? taxesOf(settings.data, legalForm) : undefined;
  const { tiers } = readGrid(rows, locale);
  const amount = parseMillimes(amountText, locale);
  const shown = tiers !== undefined && taxes !== undefined && amount !== undefined && amount > 0;
  return (
    <Card>
      <CardTitle>{t('preview')}</CardTitle>
      <div className="flex flex-col gap-4">
        <TextField
          label={t('previewAmount')}
          inputMode="decimal"
          dir="ltr"
          value={amountText}
          onChange={(event) => {
            setAmountText(event.target.value);
          }}
        />
        {shown ? <PreviewLines kind={kind} amount={amount} tiers={tiers} taxes={taxes} /> : null}
        <p className="text-caption text-text-muted">{t('previewNote')}</p>
      </div>
    </Card>
  );
}

/** Taxes of the settings for a legal form (none chosen yet: no withholding in the preview). */
function taxesOf(
  settings: Schemas['PlatformSettings'],
  legalForm: Schemas['LegalForm'] | undefined,
): Taxes {
  const withholding = settings.withholding;
  const rates = {
    PP_CIN: withholding?.ppCinBps,
    PP_MF: withholding?.ppMfBps,
    PM_MF: withholding?.pmMfBps,
  };
  return {
    vatRateBps: settings.vatRateBps,
    stampDutyMillimes: settings.stampDutyMillimes,
    withholdingRateBps: legalForm === undefined ? 0 : (rates[legalForm] ?? 0),
    ...(withholding === undefined
      ? {}
      : { withholdingThresholdMillimes: withholding.thresholdMillimes }),
    transferFeeMillimes: settings.transferFeeMillimes ?? 0,
  };
}

function PreviewLines({
  kind,
  amount,
  tiers,
  taxes,
}: {
  kind: 'company' | 'merchant';
  amount: number;
  tiers: CommissionTier[];
  taxes: Taxes;
}) {
  const t = useTranslations('admin.commissionWindow');
  const locale = useLocale();
  const rate = (bps: number) => formatRateBps(bps, locale);
  const lines =
    kind === 'company'
      ? orderBreakdown(amount, tiers, taxes)
      : payoutBreakdown(amount, tiers, taxes);
  const common = [
    { label: t('lineAmount'), millimes: lines.amountMillimes },
    {
      label: t('lineCommission'),
      note: rate(lines.rateBps),
      millimes: lines.commissionMillimes,
      ...(kind === 'merchant' ? { sign: 'debit' as const } : {}),
    },
    {
      label: t('lineVat'),
      note: rate(lines.vatRateBps),
      millimes: lines.vatMillimes,
      ...(kind === 'merchant' ? { sign: 'debit' as const } : {}),
    },
    ...(lines.withholdingMillimes > 0
      ? [
          {
            label: t('lineWithholding'),
            note: rate(lines.withholdingRateBps),
            millimes: lines.withholdingMillimes,
            ...(kind === 'merchant' ? { sign: 'debit' as const } : {}),
          },
        ]
      : []),
    {
      label: t('lineStamp'),
      millimes: lines.stampDutyMillimes,
      ...(kind === 'merchant' ? { sign: 'debit' as const } : {}),
    },
    {
      label: t('lineTransfer'),
      millimes: lines.transferFeeMillimes,
      ...(kind === 'merchant' ? { sign: 'debit' as const } : {}),
    },
  ];
  return (
    <AmountBreakdown
      lines={common}
      total={
        'totalMillimes' in lines
          ? { label: t('lineTotal'), millimes: lines.totalMillimes }
          : { label: t('lineNet'), millimes: lines.netMillimes }
      }
    />
  );
}
