'use client';

import { useLocale, useTranslations } from 'next-intl';
import { cn } from '@/lib/cn';
import { useCountUp } from '@/lib/motion';
import {
  CURRENCY_CODE,
  formatMillimes,
  formatMillimesWithCurrency,
  formatRateBps,
} from '@/lib/format/money';

interface AmountProps {
  /** Integer millimes from the API (never computed in the client). */
  readonly millimes: number;
  readonly size?: 'body' | 'title' | 'amount' | 'amount-xl';
  /** Sign written as text, never conveyed by colour only (charte A.5). */
  readonly sign?: 'credit' | 'debit';
  readonly className?: string;
  /** Counts from 0 to the amount at the first display (main KPI of a dashboard only). */
  readonly countUp?: boolean;
}

const SIZES = {
  body: 'text-body',
  title: 'text-title',
  amount: 'text-amount',
  'amount-xl': 'text-amount-xl',
};

/** Amount in TND with 3 decimals; the accessible name includes the currency and the sign. */
export function Amount({ millimes, size = 'body', sign, className, countUp = false }: AmountProps) {
  const locale = useLocale();
  const t = useTranslations('ui.amount');
  // Main KPI of a dashboard: counts up at the first display only (animation 2). The accessible
  // name always carries the final amount.
  const shown = useCountUp(millimes, countUp);
  const text = formatMillimesWithCurrency(millimes, locale);
  const label = sign === undefined ? text : t(sign, { amount: text });
  const prefix = sign === 'debit' ? '−' : sign === 'credit' ? '+' : '';
  return (
    <span
      aria-label={label}
      role="text"
      className={cn(
        'inline-flex items-baseline gap-1 whitespace-nowrap tabular-nums',
        SIZES[size],
        className,
      )}
    >
      {/* Amounts always stand out (charte §3): bold number, smaller muted currency. */}
      <span aria-hidden="true" className="font-title">
        {prefix}
        {formatMillimes(shown, locale)}
      </span>
      <span aria-hidden="true" className="text-currency text-text-muted">
        {CURRENCY_CODE}
      </span>
    </span>
  );
}

/** Commission rate from basis points (`200` -> `2 %`). */
export function Rate({ bps }: { bps: number }) {
  const locale = useLocale();
  return <span className="tabular-nums">{formatRateBps(bps, locale)}</span>;
}

interface BreakdownLine {
  readonly label: string;
  readonly millimes: number;
  readonly sign?: 'credit' | 'debit';
  readonly note?: string;
  /** A subtotal of the lines above (« Frais TTC »): set apart, never added again. */
  readonly subtotal?: boolean;
}

/** Gross -> deductions -> net, every figure from the API (charte A.5, UX-04). */
export function AmountBreakdown({
  lines,
  total,
}: {
  lines: readonly BreakdownLine[];
  total: BreakdownLine;
}) {
  return (
    <dl className="flex flex-col gap-3">
      {lines.map((line) => (
        <div
          key={line.label}
          className={cn(
            'flex items-baseline justify-between gap-4',
            line.subtotal === true && 'border-t border-dashed border-border pt-3',
          )}
        >
          <dt
            className={
              line.subtotal === true ? 'text-label text-text' : 'text-body text-text-muted'
            }
          >
            {line.label}
            {line.note !== undefined ? (
              <span className="ms-2 text-caption">{line.note}</span>
            ) : null}
          </dt>
          <dd>
            <Amount millimes={line.millimes} sign={line.sign} className="font-semibold" />
          </dd>
        </div>
      ))}
      <div className="flex items-baseline justify-between gap-4 border-t border-border pt-3">
        <dt className="text-label text-text">{total.label}</dt>
        <dd>
          <Amount millimes={total.millimes} size="amount" className="text-navy" />
        </dd>
      </div>
    </dl>
  );
}
