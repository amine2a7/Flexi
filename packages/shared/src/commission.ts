import { z } from 'zod';
import { MAX_AMOUNT_MILLIMES } from './money.js';
import { MAX_RATE_BPS, MIN_RATE_BPS } from './rate.js';

/**
 * Commission grid of a company (applied to each order amount) or of a merchant (applied to each
 * payout amount), decisions of 2026-11-03 and 2026-11-04. A tranche covers [min, max]: both
 * bounds are included; a missing min is 0, a missing max is unbounded. The line without min nor max is
 * the default rate: required, unique, used when no tranche matches.
 */
export interface CommissionTier {
  readonly rateBps: number;
  readonly minMillimes: number | null;
  readonly maxMillimes: number | null;
}

export const MAX_COMMISSION_TIERS = 20;

/** Field error codes of the grid (contract `FieldErrorCode`). */
export type CommissionGridErrorCode =
  'GRID_DEFAULT_REQUIRED' | 'GRID_DEFAULT_DUPLICATE' | 'GRID_OVERLAP' | 'GRID_BOUNDS';

const bound = z.number().int().min(0).max(MAX_AMOUNT_MILLIMES).nullable();

export const commissionTierSchema = z.strictObject({
  rateBps: z.number().int().min(MIN_RATE_BPS).max(MAX_RATE_BPS),
  minMillimes: bound,
  maxMillimes: bound,
});

export const isDefaultTier = (tier: CommissionTier): boolean =>
  tier.minMillimes === null && tier.maxMillimes === null;

const lowOf = (tier: CommissionTier) => tier.minMillimes ?? 0;
const highOf = (tier: CommissionTier) => tier.maxMillimes ?? Number.POSITIVE_INFINITY;

export const commissionGridSchema = z
  .array(commissionTierSchema)
  .min(1)
  .max(MAX_COMMISSION_TIERS)
  .superRefine((tiers, ctx) => {
    const issue = (fieldCode: CommissionGridErrorCode, path: number[]) => {
      ctx.addIssue({ code: 'custom', path, params: { fieldCode }, message: fieldCode });
    };
    let defaults = 0;
    tiers.forEach((tier, index) => {
      if (isDefaultTier(tier)) {
        defaults += 1;
        if (defaults > 1) issue('GRID_DEFAULT_DUPLICATE', [index]);
        return;
      }
      if (lowOf(tier) > highOf(tier)) {
        issue('GRID_BOUNDS', [index]);
        return;
      }
      const overlaps = tiers
        .slice(0, index)
        .some(
          (other) =>
            !isDefaultTier(other) &&
            lowOf(other) <= highOf(other) &&
            lowOf(tier) <= highOf(other) &&
            lowOf(other) <= highOf(tier),
        );
      if (overlaps) issue('GRID_OVERLAP', [index]);
    });
    if (defaults === 0) issue('GRID_DEFAULT_REQUIRED', []);
  });

/** Tier of an amount: the tranche that contains it, else the default line. */
export function tierFor(tiers: readonly CommissionTier[], amountMillimes: number): CommissionTier {
  const tranche = tiers.find(
    (tier) =>
      !isDefaultTier(tier) && lowOf(tier) <= amountMillimes && amountMillimes <= highOf(tier),
  );
  const found = tranche ?? tiers.find(isDefaultTier);
  if (found === undefined) throw new Error('commission grid without a default line');
  return found;
}
