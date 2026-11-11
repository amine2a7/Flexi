import type { Schemas } from '@flexipay/api-client';
import type { Locale } from '@/i18n/routing';
import { formatMillimes } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { CREDIT_TYPES, type CreditType } from '@/lib/credit-types';

type TypeAmount = Schemas['AllocationTypeAmount'];

/** Amount fields of an allocation or a template (processus v2): one per credit type. */
export const EMPTY_TEXTS: Record<CreditType, string> = {
  RESTAURATION: '',
  HABILLEMENT: '',
  CARBURANT: '',
  CADEAUX: '',
};

/** Amount texts of a template, written back in the fields (« Relancer », « Modifier »). */
export function amountTexts(amounts: readonly TypeAmount[], locale: Locale) {
  const texts = { ...EMPTY_TEXTS };
  for (const amount of amounts)
    texts[amount.creditType] = formatMillimes(amount.amountMillimes, locale);
  return texts;
}

/** The amounts typed per type: the valid ones, and whether one of them is invalid. */
export function readAmounts(texts: Record<CreditType, string>, locale: Locale) {
  const parsed = CREDIT_TYPES.map((creditType) => ({
    creditType,
    millimes: texts[creditType].trim() === '' ? 0 : parseMillimes(texts[creditType], locale),
  }));
  return {
    invalid: parsed.some((item) => item.millimes === undefined),
    amounts: parsed.flatMap((item): TypeAmount[] =>
      item.millimes !== undefined && item.millimes > 0
        ? [{ creditType: item.creditType, amountMillimes: item.millimes }]
        : [],
    ),
  };
}
