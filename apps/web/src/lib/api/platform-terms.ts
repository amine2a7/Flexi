import type { Schemas } from '@flexipay/api-client';
import type { Locale } from '@/i18n/routing';
import { getApiOrigin } from '@/lib/env';
import { formatMillimesWithCurrency } from '@/lib/format/money';

export type PlatformTerms = Schemas['PlatformTerms'];

/** Shown in place of a value while the terms load (or when the API does not answer). */
const PENDING = '…';

/**
 * Values of the settings quoted by the texts of the pages (settlement cycle, validities, four-eyes
 * threshold): they come from the API (`GET /v1/public/terms`), never from the web (2026-11-05).
 */
export function termValues(terms: PlatformTerms | undefined, locale: Locale) {
  return {
    settlementDays: terms?.settlementDelayDays ?? PENDING,
    invitationDays: terms?.invitationValidityDays ?? PENDING,
    quoteDays: terms?.quoteValidityDays ?? PENDING,
    cancelHours: terms?.paymentCancelHours ?? PENDING,
    threshold:
      terms === undefined
        ? PENDING
        : formatMillimesWithCurrency(terms.secondValidationThresholdMillimes, locale),
  };
}

/** Server pages (landing, help): the terms read at request time, undefined when unreachable. */
export async function fetchPlatformTerms(): Promise<PlatformTerms | undefined> {
  const origin = getApiOrigin();
  if (origin === undefined) return undefined;
  try {
    const response = await fetch(`${origin}/v1/public/terms`, { cache: 'no-store' });
    return response.ok ? ((await response.json()) as PlatformTerms) : undefined;
  } catch {
    return undefined;
  }
}
