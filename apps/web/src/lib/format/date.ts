import type { Locale } from '@/i18n/routing';

// Business dates (expiry, settlement day, limit periods, report bounds) are always shown in the
// business time zone; technical timestamps (time of a payment) in the device time zone
// (decision 3). Arabic keeps Western digits (decision of 2026-10-09).
export const BUSINESS_TIME_ZONE = 'Africa/Tunis';

const INTL_LOCALE: Record<Locale, string> = {
  fr: 'fr-TN',
  ar: 'ar-TN-u-nu-latn',
  en: 'en-GB',
};

/** `2026-10-11` (calendar date of the contract) -> `11/10/2026`, never shifted by the device zone. */
export function formatCalendarDate(date: string, locale: Locale): string {
  return new Intl.DateTimeFormat(INTL_LOCALE[locale], {
    dateStyle: 'medium',
    timeZone: 'UTC',
  }).format(new Date(`${date}T00:00:00.000Z`));
}

/** Business timestamp shown in Africa/Tunis (e.g. a due date). */
export function formatBusinessDateTime(timestamp: string, locale: Locale): string {
  return new Intl.DateTimeFormat(INTL_LOCALE[locale], {
    dateStyle: 'medium',
    timeStyle: 'short',
    // fr-TN defaults to a 12-hour clock: FlexiPay shows 24-hour times in every language.
    hourCycle: 'h23',
    timeZone: BUSINESS_TIME_ZONE,
  }).format(new Date(timestamp));
}

/** Technical timestamp (when something happened) in the device time zone. */
export function formatDateTime(timestamp: string, locale: Locale): string {
  return new Intl.DateTimeFormat(INTL_LOCALE[locale], {
    dateStyle: 'medium',
    timeStyle: 'short',
    // fr-TN defaults to a 12-hour clock: FlexiPay shows 24-hour times in every language.
    hourCycle: 'h23',
  }).format(new Date(timestamp));
}

/** `2026-10` -> `octobre 2026`. */
/** Short month of a period `AAAA-MM` (chart axis): `oct.`, `Oct`. */
export function formatShortMonth(period: string, locale: Locale): string {
  return new Intl.DateTimeFormat(INTL_LOCALE[locale], { month: 'short', timeZone: 'UTC' }).format(
    new Date(`${period}-01T00:00:00.000Z`),
  );
}

export function formatMonth(period: string, locale: Locale): string {
  return new Intl.DateTimeFormat(INTL_LOCALE[locale], {
    month: 'long',
    year: 'numeric',
    timeZone: 'UTC',
  }).format(new Date(`${period}-01T00:00:00.000Z`));
}
