// Money crosses the API as integer millimes (JSON numbers, contract §2) and lives in PostgreSQL as
// BIGINT. Conversions are exact or fail: no float, no rounding hidden here.

/** BIGINT from the database -> JSON integer. Fails beyond Number.MAX_SAFE_INTEGER. */
export function toMillimes(value: bigint): number {
  if (value > BigInt(Number.MAX_SAFE_INTEGER) || value < BigInt(Number.MIN_SAFE_INTEGER)) {
    throw new Error('amount out of the safe integer range');
  }
  return Number(value);
}

/** JSON integer -> BIGINT. The validation layer has already checked it is a safe integer. */
export function fromMillimes(value: number): bigint {
  if (!Number.isSafeInteger(value)) throw new Error('amount must be a safe integer');
  return BigInt(value);
}

/**
 * Commission of `gross` at `rateBps` basis points, rounded half up to the millime, in integers
 * only (spec 03): 45 000 at 200 bps -> 900. Same rule everywhere (quote, request, display).
 */
/** Taxes and fees of the settings, the withholding rate being the one of the client's legal form. */
export interface Taxes {
  vatRateBps: number;
  stampDutyMillimes: bigint;
  withholdingRateBps: number;
  withholdingThresholdMillimes: bigint;
  transferFeeMillimes: bigint;
}

/**
 * Fees of an order or a payout (processus v2, Règles de frais): commission at the grid rate, VAT on
 * the ROUNDED commission, withholding tax on the commission when the amount is above the threshold
 * (rate of the legal form, added like the VAT), stamp duty and transfer fee. All in millimes, half
 * up. Same rule as `orderBreakdown` / `payoutBreakdown` of the shared package.
 */
export function feesOf(
  amount: bigint,
  rateBps: number,
  taxes: Taxes,
): {
  commission: bigint;
  vat: bigint;
  withholding: bigint;
  withholdingRateBps: number;
  stamp: bigint;
  transfer: bigint;
} {
  const commission = commissionOf(amount, rateBps);
  const withholdingRateBps =
    amount > taxes.withholdingThresholdMillimes ? taxes.withholdingRateBps : 0;
  return {
    commission,
    vat: commissionOf(commission, taxes.vatRateBps),
    withholding: commissionOf(commission, withholdingRateBps),
    withholdingRateBps,
    stamp: taxes.stampDutyMillimes,
    transfer: taxes.transferFeeMillimes,
  };
}

/** Sum of the fees added to an order or taken from a payout. */
export function feesTotal(fees: ReturnType<typeof feesOf>): bigint {
  return fees.commission + fees.vat + fees.withholding + fees.stamp + fees.transfer;
}

export function commissionOf(gross: bigint, rateBps: number): bigint {
  if (!Number.isInteger(rateBps) || rateBps < 0 || rateBps > 10_000) throw new Error('bad rate');
  return (gross * BigInt(rateBps) + 5_000n) / 10_000n;
}
