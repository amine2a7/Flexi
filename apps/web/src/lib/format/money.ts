// The ONE money formatter of the web app (CLAUDE.md rules 1-2, charte §3, fondations-composants A.1).
// Amounts are integer millimes (1 TND = 1 000 millimes) and rates are integer basis points.
// Everything here is integer arithmetic and string handling: no float, no Intl.NumberFormat,
// no toFixed/parseFloat. ESLint forbids number formatting anywhere else in src/ (eslint.config.mjs).
import type { Locale } from '@/i18n/routing';

/** Largest integer exactly representable in JavaScript, and the upper bound of the API contract. */
export const MAX_MILLIMES = Number.MAX_SAFE_INTEGER;
export const MAX_BPS = 10_000;
export const CURRENCY_CODE = 'TND';

const NO_BREAK_SPACE = ' ';
const THIN_NO_BREAK_SPACE = ' ';
const MILLIMES_PER_DINAR = 1_000;
const BPS_PER_PERCENT = 100;

interface Separators {
  readonly group: string;
  readonly decimal: string;
}

// FR and AR: `48 250,000` (Western digits in Arabic, decision of 2026-10-09). EN: `48,250.000`.
const SEPARATORS: Record<Locale, Separators> = {
  fr: { group: THIN_NO_BREAK_SPACE, decimal: ',' },
  ar: { group: THIN_NO_BREAK_SPACE, decimal: ',' },
  en: { group: ',', decimal: '.' },
};

function assertNonNegativeInteger(value: number, max: number, what: string): void {
  if (!Number.isInteger(value) || value < 0 || value > max) {
    throw new RangeError(`${what} must be an integer between 0 and ${String(max)}`);
  }
}

function groupThousands(digits: string, separator: string): string {
  let grouped = '';
  for (let index = 0; index < digits.length; index += 1) {
    const remaining = digits.length - index;
    if (index > 0 && remaining % 3 === 0) grouped += separator;
    grouped += digits.charAt(index);
  }
  return grouped;
}

/**
 * `48250000` -> `48 250,000` (FR/AR) or `48,250.000` (EN). Always 3 decimals, no currency.
 * Throws a RangeError for anything that is not a non-negative safe integer: the API never sends
 * a negative or fractional amount (the sign is carried by `direction`).
 */
export function formatMillimes(millimes: number, locale: Locale): string {
  assertNonNegativeInteger(millimes, MAX_MILLIMES, 'Amount in millimes');
  const { group, decimal } = SEPARATORS[locale];
  const remainder = millimes % MILLIMES_PER_DINAR;
  // (millimes - remainder) is an exact multiple of 1000: the division below is exact.
  const dinars = (millimes - remainder) / MILLIMES_PER_DINAR;
  return `${groupThousands(String(dinars), group)}${decimal}${String(remainder).padStart(3, '0')}`;
}

/** Text form with the currency, for sentences and accessible names: `48 250,000 TND`. */
export function formatMillimesWithCurrency(millimes: number, locale: Locale): string {
  return `${formatMillimes(millimes, locale)}${NO_BREAK_SPACE}${CURRENCY_CODE}`;
}

/** `200 -> 2 %`, `150 -> 1,5 %`, `50 -> 0,5 %` (FR/AR); `1.5%` (EN). Basis points in, no float. */
export function formatRateBps(bps: number, locale: Locale): string {
  assertNonNegativeInteger(bps, MAX_BPS, 'Rate in basis points');
  const { decimal } = SEPARATORS[locale];
  const fraction = bps % BPS_PER_PERCENT;
  const whole = (bps - fraction) / BPS_PER_PERCENT;
  const decimals = String(fraction).padStart(2, '0').replace(/0+$/, '');
  const number = decimals === '' ? String(whole) : `${String(whole)}${decimal}${decimals}`;
  return locale === 'en' ? `${number}%` : `${number}${NO_BREAK_SPACE}%`;
}
