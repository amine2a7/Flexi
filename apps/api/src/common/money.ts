// Money crosses the API as integer millimes (JSON numbers, contract §2) and lives in PostgreSQL as
// BIGINT. Conversions are exact or fail: no float, no rounding hidden here.

/** BIGINT from the database -> JSON integer. Fails beyond Number.MAX_SAFE_INTEGER. */
export function toMillimes(value: bigint): number {
  if (value > BigInt(Number.MAX_SAFE_INTEGER) || value < BigInt(Number.MIN_SAFE_INTEGER)) {
    throw new Error('amount out of the safe integer range');
  }
  return Number(value);
}

/**
 * Amount typed in a search box, in dinars (« 12 », « 12,5 », « 12.500 »): exact millimes, or null
 * when the text is not an amount (W-SUP, search by amount in the apps). Never a float.
 */
export function searchedMillimes(text: string): bigint | null {
  const match = /^(\d{1,9})(?:[.,](\d{1,3}))?$/.exec(text.trim().replace(/\s+/g, ''));
  if (match === null) return null;
  const dinars = BigInt(match[1] ?? '0');
  const fraction = BigInt((match[2] ?? '').padEnd(3, '0') || '0');
  return dinars * 1000n + fraction;
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
 * Fees of an order or a payout (Règles de frais, corrections of 2026-11-13): commission at the grid
 * rate, VAT on the ROUNDED commission, « frais TTC » = commission + VAT, withholding tax = rate of
 * the legal form x frais TTC only when the frais TTC are above the threshold (1 000 TND), stamp
 * duty and transfer fee. The withholding is always DEDUCTED (orderTotal, payoutNet). All in
 * millimes, half up. Same rule as `orderBreakdown` / `payoutBreakdown` of the shared package.
 */
export function feesOf(
  amount: bigint,
  rateBps: number,
  taxes: Taxes,
): {
  commission: bigint;
  vat: bigint;
  feesTtc: bigint;
  withholding: bigint;
  withholdingRateBps: number;
  stamp: bigint;
  transfer: bigint;
} {
  const commission = commissionOf(amount, rateBps);
  const vat = commissionOf(commission, taxes.vatRateBps);
  const feesTtc = commission + vat;
  const withholdingRateBps =
    feesTtc > taxes.withholdingThresholdMillimes ? taxes.withholdingRateBps : 0;
  return {
    commission,
    vat,
    feesTtc,
    withholding: commissionOf(feesTtc, withholdingRateBps),
    withholdingRateBps,
    stamp: taxes.stampDutyMillimes,
    transfer: taxes.transferFeeMillimes,
  };
}

/** Total of an order: credits + frais TTC + stamp + transfer fee - withholding. */
export function orderTotal(amount: bigint, fees: ReturnType<typeof feesOf>): bigint {
  return amount + fees.feesTtc + fees.stamp + fees.transfer - fees.withholding;
}

/** Net of a payout: gross - frais TTC - stamp - transfer fee - withholding. */
export function payoutNet(gross: bigint, fees: ReturnType<typeof feesOf>): bigint {
  return gross - fees.feesTtc - fees.stamp - fees.transfer - fees.withholding;
}

export function commissionOf(gross: bigint, rateBps: number): bigint {
  if (!Number.isInteger(rateBps) || rateBps < 0 || rateBps > 10_000) throw new Error('bad rate');
  return (gross * BigInt(rateBps) + 5_000n) / 10_000n;
}
