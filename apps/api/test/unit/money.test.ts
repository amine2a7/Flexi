import { describe, expect, it } from 'vitest';
import { commissionOf, feesOf, fromMillimes, toMillimes } from '../../src/common/money.js';

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

// TEST-FIRST (processus v2, Règles de frais): commission, VAT, withholding above 1 000 TND (rate
// of the legal form, on the commission, added like the VAT), stamp 1 DT, transfer fee 4 DT.
describe('fees of processus v2', () => {
  const taxes = (withholdingRateBps: number) => ({
    vatRateBps: 1_900,
    stampDutyMillimes: 1_000n,
    withholdingRateBps,
    withholdingThresholdMillimes: 1_000_000n,
    transferFeeMillimes: 4_000n,
  });

  it('example 1: order of a PM MF company, grid 3 %, 16 000 TND -> total 16 581,000', () => {
    const fees = feesOf(16_000_000n, 300, taxes(100));
    expect(fees).toEqual({
      commission: 480_000n,
      vat: 91_200n,
      withholding: 4_800n,
      withholdingRateBps: 100,
      stamp: 1_000n,
      transfer: 4_000n,
    });
    const total =
      16_000_000n + fees.commission + fees.vat + fees.withholding + fees.stamp + fees.transfer;
    expect(total).toBe(16_581_000n);
  });

  it('example 2: payout of a PP CIN merchant, grid 2 %, 1 250 TND -> net 1 214,500', () => {
    const fees = feesOf(1_250_000n, 200, taxes(300));
    const net =
      1_250_000n - fees.commission - fees.vat - fees.withholding - fees.stamp - fees.transfer;
    expect([fees.commission, fees.vat, fees.withholding]).toEqual([25_000n, 4_750n, 750n]);
    expect(net).toBe(1_214_500n);
  });

  it('no withholding up to the threshold; the stamp and the transfer fee stay due', () => {
    const fees = feesOf(1_000_000n, 300, taxes(300));
    expect(fees).toMatchObject({ withholding: 0n, withholdingRateBps: 0, stamp: 1_000n, transfer: 4_000n });
  });
});
