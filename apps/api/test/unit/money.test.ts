import { describe, expect, it } from 'vitest';
import { commissionOf, fromMillimes, toMillimes } from '../../src/common/money.js';

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
