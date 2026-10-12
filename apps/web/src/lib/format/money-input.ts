import type { Locale } from '@/i18n/routing';
import { MAX_BPS, MAX_MILLIMES } from './money';

// Reading what the user typed. String handling only: no float, no parseFloat (CLAUDE.md rule 1).
// FR and AR: decimal comma, spaces as group separator (`1 500,250`). EN: decimal point, commas as
// group separator (`1,500.250`). A `1,500` typed in English is therefore 1 500 TND, and the live
// preview under the field shows how it was read (UX-05).

const DECIMAL: Record<Locale, string> = { fr: ',', ar: ',', en: '.' };
const GROUP = /[\s  ]/g;

function digitsOnly(value: string): boolean {
  return /^[0-9]+$/.test(value);
}

function parseFixed(text: string, locale: Locale, scaleDigits: number): number | undefined {
  const decimal = DECIMAL[locale];
  let cleaned = text.trim().replace(GROUP, '');
  if (locale === 'en') cleaned = cleaned.replaceAll(',', '');
  if (cleaned === '') return undefined;
  const parts = cleaned.split(decimal);
  if (parts.length > 2) return undefined;
  const [whole = '', fraction = ''] = parts;
  if (whole === '' && fraction === '') return undefined;
  if ((whole !== '' && !digitsOnly(whole)) || (fraction !== '' && !digitsOnly(fraction)))
    return undefined;
  if (fraction.length > scaleDigits) return undefined;
  const combined = `${whole === '' ? '0' : whole}${fraction.padEnd(scaleDigits, '0')}`.replace(
    /^0+(?=\d)/,
    '',
  );
  if (combined.length > 16) return undefined;
  const value = Number(combined);
  return Number.isSafeInteger(value) ? value : undefined;
}

/** `45,500` (FR) -> 45500 millimes; undefined if the text is not a valid amount. */
export function parseMillimes(text: string, locale: Locale): number | undefined {
  const value = parseFixed(text, locale, 3);
  return value === undefined || value > MAX_MILLIMES ? undefined : value;
}

/** `1,75` (FR, in percent) -> 175 basis points; undefined if invalid or above 100 %. */
export function parseBps(text: string, locale: Locale): number | undefined {
  const value = parseFixed(text, locale, 2);
  return value === undefined || value > MAX_BPS ? undefined : value;
}
