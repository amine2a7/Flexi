'use client';

import { useLocale, useTranslations } from 'next-intl';
import { asProblem } from '@/lib/api/problem';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { useCreditTypeLabel, type CreditType } from '@/components/ui/credit-type';

/**
 * Clear message when the balance of the chosen type cannot cover a payment (rule 5: no payment
 * with another type). Other problems keep their generic translation.
 */
export function useFundsMessage(): (error: unknown, type: CreditType) => string | undefined {
  const t = useTranslations('ui.creditTypes');
  const label = useCreditTypeLabel();
  const locale = useLocale();
  return (error, type) => {
    const problem = asProblem(error);
    if (problem?.code !== 'INSUFFICIENT_FUNDS') return undefined;
    const missing = (problem.details as { missingMillimes?: number } | undefined)?.missingMillimes;
    return t('insufficient', {
      type: label(type),
      missing: missing === undefined ? '' : formatMillimesWithCurrency(missing, locale),
    });
  };
}
