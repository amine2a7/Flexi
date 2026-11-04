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
/**
 * Commission at a rate, VAT on the ROUNDED commission, stamp duty (decisions of 2026-11-03):
 * all in millimes, half up. Same rule as `orderBreakdown` / `payoutBreakdown` of the shared package.
 */
export function feesOf(
  amount: bigint,
  rateBps: number,
  taxes: { vatRateBps: number; stampDutyMillimes: bigint },
): { commission: bigint; vat: bigint; stamp: bigint } {
  const commission = commissionOf(amount, rateBps);
  return {
    commission,
    vat: commissionOf(commission, taxes.vatRateBps),
    stamp: taxes.stampDutyMillimes,
  };
}

export function commissionOf(gross: bigint, rateBps: number): bigint {
  if (!Number.isInteger(rateBps) || rateBps < 0 || rateBps > 10_000) throw new Error('bad rate');
  return (gross * BigInt(rateBps) + 5_000n) / 10_000n;
}
