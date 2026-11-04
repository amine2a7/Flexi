'use client';

import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { CircleHelp, Fuel, Gift, Shirt, UtensilsCrossed, type LucideIcon } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { messageKey } from '@/i18n/keys';
import { cn } from '@/lib/cn';
import { Rate } from '@/components/ui/amount';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { Amount } from './amount';
import { SelectField } from './field';

import { CREDIT_TYPES, type CreditType } from '@/lib/credit-types';

export { CREDIT_TYPES, type CreditType };

interface CreditTypeToken {
  readonly labelKey: string;
  readonly icon: string;
  readonly bg: string;
  readonly fg: string;
  readonly solid: string;
}

const TOKENS = (tokensPreset.theme as { creditType: Record<string, CreditTypeToken> }).creditType;
// Icons named by the `credit-type` tokens; a type is never shown by colour only (icon + text).
const ICONS: Record<string, LucideIcon> = { UtensilsCrossed, Shirt, Fuel, Gift };

function token(type: CreditType): CreditTypeToken {
  return (
    TOKENS[type] ?? {
      labelKey: `creditType.${type}`,
      icon: '',
      bg: 'border',
      fg: 'neutral-text',
      solid: 'border-strong',
    }
  );
}

export function useCreditTypeLabel(): (type: CreditType) => string {
  const t = useTranslations();
  return (type) => t(messageKey(token(type).labelKey));
}

export function CreditTypeIcon({ type, className }: { type: CreditType; className?: string }) {
  const Icon = ICONS[token(type).icon] ?? CircleHelp;
  return <Icon aria-hidden="true" className={cn('size-icon-sm shrink-0', className)} />;
}

/** Type pill: token colours, icon and label, identical everywhere. */
export function CreditTypeBadge({ type }: { type: CreditType }) {
  const label = useCreditTypeLabel();
  const style = token(type);
  return (
    <span
      className={cn(
        'inline-flex min-h-chip-height items-center gap-1 whitespace-nowrap rounded-badge px-2 text-caption font-label',
        `bg-${style.bg}`,
        `text-${style.fg}`,
      )}
    >
      <CreditTypeIcon type={type} />
      {label(type)}
    </span>
  );
}

/** Several types (order lines, accepted types). */
export function CreditTypeBadges({ types }: { types: readonly CreditType[] }) {
  return (
    <span className="flex flex-wrap gap-1">
      {types.map((type) => (
        <CreditTypeBadge key={type} type={type} />
      ))}
    </span>
  );
}

/** Thin progress bar in the type colour (SVG attributes only: strict CSP). */
/**
 * Progress of a type. Animation 3: grows from 0 at the first display (700 ms), the n-th bar of a
 * group starting 80 ms after the previous one.
 */
export function CreditTypeBar({
  type,
  ratio,
  index = 0,
}: {
  type: CreditType;
  ratio: number;
  index?: number;
}) {
  const width = Math.max(0, Math.min(1, ratio)) * 100;
  return (
    <svg
      viewBox="0 0 100 4"
      preserveAspectRatio="none"
      aria-hidden="true"
      className="h-icon-sm w-full overflow-hidden rounded-badge"
    >
      <rect width={100} height={4} className="fill-border" />
      <rect
        width={width}
        height={4}
        className={cn(`fill-${token(type).solid}`, 'fp-box-fill origin-left animate-grow-x')}
        style={{ animationDelay: `calc(var(--fp-d-bars-step) * ${String(index)})` }}
      />
    </svg>
  );
}

/**
 * One card per credit type with its balance and a progress bar (share of the largest balance, or
 * of the daily limit when given). Never a single global balance: the total is informative only.
 */
export function CreditTypeBalanceCards({
  balances,
  progress,
}: {
  balances: readonly {
    creditType: CreditType;
    amountMillimes: number;
    note?: string;
    ratio?: number;
    disabled?: boolean;
  }[];
  progress?: 'share';
}) {
  const t = useTranslations('ui.creditTypes');
  const label = useCreditTypeLabel();
  const max = Math.max(1, ...balances.map((item) => item.amountMillimes));
  return (
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {balances.map((item, index) => {
        const style = token(item.creditType);
        return (
          <div
            key={item.creditType}
            className="flex flex-col gap-3 rounded-card-desktop border border-border bg-surface p-5 shadow-card"
          >
            <div className="flex items-start justify-between gap-3">
              <p className="text-label text-text-muted">
                {t('balanceOf', { type: label(item.creditType) })}
              </p>
              <span
                aria-hidden="true"
                className={cn(
                  'flex size-avatar-md shrink-0 items-center justify-center rounded-button',
                  `bg-${style.bg}`,
                  `text-${style.fg}`,
                )}
              >
                <CreditTypeIcon type={item.creditType} className="size-icon-md" />
              </span>
            </div>
            <div className="text-title text-text">
              <Amount millimes={item.amountMillimes} size="title" />
            </div>
            <CreditTypeBar
              index={index}
              type={item.creditType}
              ratio={
                progress === 'share' || item.ratio === undefined
                  ? item.amountMillimes / max
                  : item.ratio
              }
            />
            {item.disabled === true ? (
              <p className="text-caption text-text-muted">{t('disabled')}</p>
            ) : item.note !== undefined ? (
              <p className="text-caption text-text-muted">{item.note}</p>
            ) : null}
          </div>
        );
      })}
    </div>
  );
}

/**
 * Commission of a shop: its own profile (name and rate), or the rate of each credit type when it
 * has none (decision of 2026-10-14).
 */
/** Commission grid in short: default rate and number of tranches (decision of 2026-11-03). */
export function CommissionLabel({
  grid,
}: {
  grid: {
    tiers: readonly { rateBps: number; minMillimes: number | null; maxMillimes: number | null }[];
  } | null;
}) {
  const t = useTranslations('ui.creditTypes');
  if (grid === null) return <span>{t('rateByType')}</span>;
  const fallback = grid.tiers.find((tier) => tier.minMillimes === null && tier.maxMillimes === null);
  const tranches = grid.tiers.length - (fallback === undefined ? 0 : 1);
  return (
    <span className="flex flex-wrap items-baseline gap-2">
      {fallback === undefined ? null : (
        <span className="flex items-baseline gap-1">
          <Rate bps={fallback.rateBps} />
          {t('gridDefault')}
        </span>
      )}
      {tranches > 0 ? (
        <span className="text-caption text-text-secondary">
          {t('gridTranches', { count: tranches })}
        </span>
      ) : null}
    </span>
  );
}

/** Breakdown by credit type: stacked bar (SVG) and a legend with amounts and shares. */
export function CreditTypeBreakdown({
  items,
}: {
  items: readonly { creditType: CreditType; amountMillimes: number }[];
}) {
  const t = useTranslations('ui.creditTypes');
  const locale = useLocale();
  const total = items.reduce((sum, item) => sum + item.amountMillimes, 0);
  if (total === 0) return <p className="text-body text-text-muted">{t('breakdownEmpty')}</p>;
  // Start of each segment: running sum of the widths before it (computed once, no mutation).
  const widths = items.map((item) => (item.amountMillimes / total) * 100);
  const starts = widths.map((_, index) => widths.slice(0, index).reduce((sum, w) => sum + w, 0));
  return (
    <div className="flex flex-col gap-4">
      <svg
        viewBox="0 0 100 6"
        preserveAspectRatio="none"
        aria-hidden="true"
        className="h-avatar-md w-full origin-left animate-grow-x overflow-hidden rounded-button"
      >
        {items.map((item, index) => {
          return (
            <rect
              key={item.creditType}
              x={starts[index]}
              width={widths[index]}
              height={6}
              className={`fill-${token(item.creditType).solid}`}
            />
          );
        })}
      </svg>
      <ul className="flex flex-col gap-2">
        {items.map((item) => (
          <li key={item.creditType} className="flex items-center justify-between gap-3">
            <CreditTypeBadge type={item.creditType} />
            <span className="flex items-center gap-3 text-body">
              <span className="text-caption text-text-muted">
                {t('share', { percent: Math.round((item.amountMillimes * 100) / total) })}
              </span>
              <span className="font-label text-text" dir="ltr">
                {formatMillimesWithCurrency(item.amountMillimes, locale)}
              </span>
            </span>
          </li>
        ))}
      </ul>
    </div>
  );
}

/** Credit type select (forms and list filters). */
export function CreditTypeSelect({
  label,
  hint,
  value,
  onChange,
  types = CREDIT_TYPES,
  placeholder,
}: {
  label: string;
  hint?: string;
  value: CreditType | '';
  onChange: (value: CreditType | '') => void;
  types?: readonly CreditType[];
  placeholder?: string;
}) {
  const typeLabel = useCreditTypeLabel();
  return (
    <SelectField
      label={label}
      {...(hint === undefined ? {} : { hint })}
      {...(placeholder === undefined ? {} : { placeholder })}
      options={types.map((type) => ({ value: type, label: typeLabel(type) }))}
      value={value}
      onChange={(event) => {
        onChange(event.target.value as CreditType | '');
      }}
    />
  );
}

/** Multiple choice of types (types accepted by a merchant). */
export function CreditTypeCheckboxes({
  legend,
  hint,
  error,
  value,
  onChange,
}: {
  legend: string;
  hint?: string;
  error?: string;
  value: readonly CreditType[];
  onChange: (value: CreditType[]) => void;
}) {
  return (
    <fieldset className="flex flex-col gap-2">
      <legend className="mb-1 text-label text-text">{legend}</legend>
      {hint !== undefined ? <p className="text-caption text-text-muted">{hint}</p> : null}
      <div className="flex flex-wrap gap-2">
        {CREDIT_TYPES.map((type) => {
          const checked = value.includes(type);
          return (
            <label
              key={type}
              className={cn(
                'flex min-h-touch-target-min cursor-pointer items-center gap-2 rounded-button border px-3',
                checked ? 'border-navy bg-bg' : 'border-border',
              )}
            >
              <input
                type="checkbox"
                className="size-icon-sm accent-navy"
                checked={checked}
                onChange={() => {
                  onChange(checked ? value.filter((item) => item !== type) : [...value, type]);
                }}
              />
              <CreditTypeBadge type={type} />
            </label>
          );
        })}
      </div>
      {error !== undefined ? <p className="text-caption text-danger-text">{error}</p> : null}
    </fieldset>
  );
}
