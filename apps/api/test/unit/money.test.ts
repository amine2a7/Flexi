import { describe, expect, it } from 'vitest';
import {
  commissionOf,
  feesOf,
  fromMillimes,
  orderTotal,
  payoutNet,
  toMillimes,
} from '../../src/common/money.js';

describe('money in integer millimes', () => {
  it('computes the commission in integers, half up to the millime (spec 03 example)', () => {
    expect(commissionOf(45_000n, 200)).toBe(900n);
    expect(commissionOf(1n, 5_000)).toBe(1n); // 0.5 millime -> 1
    expect(commissionOf(1n, 4_999)).toBe(0n);
    expect(commissionOf(18_500n, 250)).toBe(463n); // 462.5 -> 463
    expect(commissionOf(0n, 300)).toBe(0n);
    expect(commissionOf(123_456_789n, 10_000)).toBe(123_456_789n);
  });

  it('refuses rates outside 0..10 000 bps and non-integer rates', () => {
    expect(() => commissionOf(1_000n, -1)).toThrow();
    expect(() => commissionOf(1_000n, 10_001)).toThrow();
    expect(() => commissionOf(1_000n, 2.5)).toThrow();
  });

  it('converts BIGINT <-> JSON integers exactly, or fails', () => {
    expect(toMillimes(9_007_199_254_740_991n)).toBe(Number.MAX_SAFE_INTEGER);
    expect(() => toMillimes(9_007_199_254_740_992n)).toThrow();
    expect(fromMillimes(48_250_000)).toBe(48_250_000n);
    expect(() => fromMillimes(1.5)).toThrow();
  });
});

// TEST-FIRST (corrections after the demo, 2026-11-13, Règles de frais): « Frais TTC » =
// commission + VAT; withholding = rate of the legal form x frais TTC, only when the frais TTC are
// above 1 000 TND; it is DEDUCTED from the total (order) or from the net (payout), never added.
describe('fees of processus v2', () => {
  const taxes = (withholdingRateBps: number) => ({
    vatRateBps: 1_900,
    stampDutyMillimes: 1_000n,
    withholdingRateBps,
    withholdingThresholdMillimes: 1_000_000n,
    transferFeeMillimes: 4_000n,
  });

  it('order of a PM MF company, grid 3 %, 16 000 TND -> total 16 576,200 (no withholding)', () => {
    const fees = feesOf(16_000_000n, 300, taxes(100));
    expect(fees).toEqual({
      commission: 480_000n,
      vat: 91_200n,
      feesTtc: 571_200n,
      withholding: 0n,
      withholdingRateBps: 0,
      stamp: 1_000n,
      transfer: 4_000n,
    });
    expect(orderTotal(16_000_000n, fees)).toBe(16_576_200n);
  });

  it('order of 40 000 TND, PM MF 3 %: frais TTC 1 428 > 1 000, withholding 14,280 deducted', () => {
    const fees = feesOf(40_000_000n, 300, taxes(100));
    expect([fees.commission, fees.vat, fees.feesTtc, fees.withholding]).toEqual([
      1_200_000n,
      228_000n,
      1_428_000n,
      14_280n,
    ]);
    expect(orderTotal(40_000_000n, fees)).toBe(41_418_720n);
  });

  it('payout of a PP CIN merchant, grid 2 %, 1 250 TND -> net 1 215,250 (no withholding)', () => {
    const fees = feesOf(1_250_000n, 200, taxes(300));
    expect([fees.commission, fees.vat, fees.feesTtc, fees.withholding]).toEqual([
      25_000n,
      4_750n,
      29_750n,
      0n,
    ]);
    expect(payoutNet(1_250_000n, fees)).toBe(1_215_250n);
  });

  it('withholding only when the frais TTC are strictly above 1 000 TND', () => {
    // Just under 1 000 TND of frais TTC: no withholding.
    const exact = feesOf(10_000_000n, 840, taxes(300));
    expect(exact.feesTtc).toBe(999_600n);
    expect(exact.withholding).toBe(0n);
    const above = feesOf(50_000_000n, 300, taxes(300));
    expect(above.feesTtc).toBe(1_785_000n);
    expect(above.withholding).toBe(53_550n);
    expect(payoutNet(50_000_000n, above)).toBe(
      50_000_000n - 1_785_000n - 1_000n - 4_000n - 53_550n,
    );
  });
});
