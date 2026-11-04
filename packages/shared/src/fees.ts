import { tierFor, type CommissionTier } from './commission.js';
import { BPS_PER_UNIT } from './rate.js';

/**
 * Commission, VAT and stamp duty of an order or a payout (decisions of 2026-11-03): the rate of
 * the grid tranche, rounded half up to the millime; the VAT is computed on the rounded
 * commission. The web uses it for the preview only: the official amounts come from the API.
 */
export interface Taxes {
  readonly vatRateBps: number;
  readonly stampDutyMillimes: number;
}

interface Lines {
  amountMillimes: number;
  rateBps: number;
  commissionMillimes: number;
  vatRateBps: number;
  vatMillimes: number;
  stampDutyMillimes: number;
}

/** `amount × bps / 10 000`, half up, exact (BigInt) on any safe amount. */
export function rateOf(amountMillimes: number, rateBps: number): number {
  const units = BigInt(BPS_PER_UNIT);
  return Number((BigInt(amountMillimes) * BigInt(rateBps) + units / 2n) / units);
}

function lines(amountMillimes: number, tiers: readonly CommissionTier[], taxes: Taxes): Lines {
  const rateBps = tierFor(tiers, amountMillimes).rateBps;
  const commissionMillimes = rateOf(amountMillimes, rateBps);
  return {
    amountMillimes,
    rateBps,
    commissionMillimes,
    vatRateBps: taxes.vatRateBps,
    vatMillimes: rateOf(commissionMillimes, taxes.vatRateBps),
    stampDutyMillimes: taxes.stampDutyMillimes,
  };
}

/** Company order: total = amount + commission + VAT + stamp duty. */
export function orderBreakdown(
  amountMillimes: number,
  tiers: readonly CommissionTier[],
  taxes: Taxes,
): Lines & { totalMillimes: number } {
  const found = lines(amountMillimes, tiers, taxes);
  return {
    ...found,
    totalMillimes:
      amountMillimes + found.commissionMillimes + found.vatMillimes + found.stampDutyMillimes,
  };
}

/** Merchant payout: net = amount − commission − VAT − stamp duty. */
export function payoutBreakdown(
  amountMillimes: number,
  tiers: readonly CommissionTier[],
  taxes: Taxes,
): Lines & { netMillimes: number } {
  const found = lines(amountMillimes, tiers, taxes);
  return {
    ...found,
    netMillimes:
      amountMillimes - found.commissionMillimes - found.vatMillimes - found.stampDutyMillimes,
  };
}
