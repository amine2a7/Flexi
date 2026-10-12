import type { Locale } from './routing';

export type Direction = 'ltr' | 'rtl';

const RTL_LOCALES: readonly Locale[] = ['ar'];

/** Text direction of a locale: drives `<html dir>`; components use logical (start/end) classes only. */
export function getDirection(locale: Locale): Direction {
  return RTL_LOCALES.includes(locale) ? 'rtl' : 'ltr';
}
