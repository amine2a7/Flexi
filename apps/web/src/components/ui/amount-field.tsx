'use client';

import { useLocale, useTranslations } from 'next-intl';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { TextField } from './field';

interface AmountFieldProps {
  readonly label: string;
  /** Text as typed (kept as text: the amount is only ever read as integer millimes). */
  readonly value: string;
  /** Typed text and its reading in millimes (undefined while empty or invalid). */
  readonly onChange: (text: string, millimes: number | undefined) => void;
  readonly disabled?: boolean;
}

/**
 * Amount input in TND: decimal keyboard, reading shown live under the field ("Amount read:
 * 18,500 TND", UX-05) and a clear message when the text is not an amount. Never a float.
 */
export function AmountField({ label, value, onChange, disabled }: AmountFieldProps) {
  const t = useTranslations('ui.amountField');
  const locale = useLocale();
  const millimes = parseMillimes(value, locale);
  const invalid = value.trim() !== '' && millimes === undefined;
  return (
    <TextField
      label={label}
      hint={
        millimes === undefined || millimes === 0
          ? t('hint')
          : t('preview', { amount: formatMillimesWithCurrency(millimes, locale) })
      }
      error={invalid ? t('invalid') : undefined}
      inputMode="decimal"
      autoComplete="off"
      dir="ltr"
      disabled={disabled}
      value={value}
      onChange={(event) => {
        onChange(event.target.value, parseMillimes(event.target.value, locale));
      }}
    />
  );
}
