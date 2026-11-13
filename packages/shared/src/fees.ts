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
  /** Processus v2: withholding rate of the legal form, applied above the threshold. */
  readonly withholdingRateBps?: number;
  readonly withholdingThresholdMillimes?: number;
  readonly transferFeeMillimes?: number;
}

interface Lines {
  amountMillimes: number;
  rateBps: number;
  commissionMillimes: number;
  vatRateBps: number;
  vatMillimes: number;
  /** « Frais TTC » = commission + VAT (corrections of 2026-11-13). */
  feesTtcMillimes: number;
  withholdingRateBps: number;
  withholdingMillimes: number;
  stampDutyMillimes: number;
  transferFeeMillimes: number;
}

/** `amount × bps / 10 000`, half up, exact (BigInt) on any safe amount. */
export function rateOf(amountMillimes: number, rateBps: number): number {
  const units = BigInt(BPS_PER_UNIT);
  return Number((BigInt(amountMillimes) * BigInt(rateBps) + units / 2n) / units);
}

function lines(amountMillimes: number, tiers: readonly CommissionTier[], taxes: Taxes): Lines {
  const rateBps = tierFor(tiers, amountMillimes).rateBps;
  const commissionMillimes = rateOf(amountMillimes, rateBps);
  const vatMillimes = rateOf(commissionMillimes, taxes.vatRateBps);
  const feesTtcMillimes = commissionMillimes + vatMillimes;
  // Withholding: rate of the legal form x frais TTC, only above the threshold (1 000 TND).
  const withholdingRateBps =
    feesTtcMillimes > (taxes.withholdingThresholdMillimes ?? Number.MAX_SAFE_INTEGER)
      ? (taxes.withholdingRateBps ?? 0)
      : 0;
  return {
    amountMillimes,
    rateBps,
    commissionMillimes,
    vatRateBps: taxes.vatRateBps,
    vatMillimes,
    feesTtcMillimes,
    withholdingRateBps,
    withholdingMillimes: rateOf(feesTtcMillimes, withholdingRateBps),
    stampDutyMillimes: taxes.stampDutyMillimes,
    transferFeeMillimes: taxes.transferFeeMillimes ?? 0,
  };
}

/** Fees charged besides the credits, the withholding being deducted (never added). */
function chargedOf(found: Lines): number {
  return (
    found.feesTtcMillimes +
    found.stampDutyMillimes +
    found.transferFeeMillimes -
    found.withholdingMillimes
  );
}

/** Company order: total = amount + frais TTC + stamp duty + transfer fee - withholding. */
export function orderBreakdown(
  amountMillimes: number,
  tiers: readonly CommissionTier[],
  taxes: Taxes,
): Lines & { totalMillimes: number } {
  const found = lines(amountMillimes, tiers, taxes);
  return {
    ...found,
    totalMillimes: amountMillimes + chargedOf(found),
  };
}

/** Merchant payout: net = amount - frais TTC - stamp duty - transfer fee - withholding. */
export function payoutBreakdown(
  amountMillimes: number,
  tiers: readonly CommissionTier[],
  taxes: Taxes,
): Lines & { netMillimes: number } {
  const found = lines(amountMillimes, tiers, taxes);
  return {
    ...found,
    netMillimes:
      amountMillimes -
      found.feesTtcMillimes -
      found.stampDutyMillimes -
      found.transferFeeMillimes -
      found.withholdingMillimes,
  };
}
