import { z } from 'zod';

/**
 * Money is always an integer number of millimes (1 TND = 1 000 millimes).
 * Never a decimal, never a string (contract §2, CLAUDE.md rule 1).
 */
export const MILLIMES_PER_TND = 1000;

/** Amounts are never negative: the sign is carried by `Direction`. */
export const MIN_AMOUNT_MILLIMES = 0;

/** Largest integer exactly representable in JavaScript (2^53 - 1), contract upper bound. */
export const MAX_AMOUNT_MILLIMES = Number.MAX_SAFE_INTEGER;

/** Amount in millimes, 0 .. 2^53 - 1 (contract schema `AmountMillimes`). */
export const amountMillimesSchema = z
  .number()
  .int()
  .min(MIN_AMOUNT_MILLIMES)
  .max(MAX_AMOUNT_MILLIMES)
  .brand<'Millimes'>();

/** Strictly positive amount in millimes (contract schema `PositiveAmountMillimes`). */
export const positiveAmountMillimesSchema = z
  .number()
  .int()
  .min(1)
  .max(MAX_AMOUNT_MILLIMES)
  .brand<'Millimes'>();

export type AmountMillimes = z.infer<typeof amountMillimesSchema>;
export type PositiveAmountMillimes = z.infer<typeof positiveAmountMillimesSchema>;

export function isAmountMillimes(value: unknown): value is AmountMillimes {
  return amountMillimesSchema.safeParse(value).success;
}

/**
 * Converts a whole number of TND to millimes (e.g. a configured limit of 100 TND).
 * Fractional TND is refused: decimal amounts must never be computed in code.
 */
export function tndToMillimes(tnd: number): AmountMillimes {
  if (!Number.isSafeInteger(tnd) || tnd < 0) {
    throw new RangeError('tnd must be a non-negative integer');
  }
  const millimes = tnd * MILLIMES_PER_TND;
  if (!Number.isSafeInteger(millimes)) {
    throw new RangeError('amount exceeds the exact integer range');
  }
  return amountMillimesSchema.parse(millimes);
}
