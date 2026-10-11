import { describe, expect, it } from 'vitest';
import {
  MAX_AMOUNT_MILLIMES,
  MILLIMES_PER_TND,
  MIN_AMOUNT_MILLIMES,
  amountMillimesSchema,
  isAmountMillimes,
  positiveAmountMillimesSchema,
  tndToMillimes,
} from '../src/index.js';

describe('money constants', () => {
  it('1 TND = 1 000 millimes', () => {
    expect(MILLIMES_PER_TND).toBe(1000);
  });

  it('bounds match the contract (0 .. 2^53 - 1)', () => {
    expect(MIN_AMOUNT_MILLIMES).toBe(0);
    expect(MAX_AMOUNT_MILLIMES).toBe(9007199254740991);
    expect(MAX_AMOUNT_MILLIMES).toBe(Number.MAX_SAFE_INTEGER);
  });
});

describe('amountMillimesSchema', () => {
  it.each([0, 1, 45000, 50_000_000, Number.MAX_SAFE_INTEGER])('accepts integer %d', (v) => {
    expect(amountMillimesSchema.safeParse(v).success).toBe(true);
  });

  it('accepts 45000.0 (indistinguishable from 45000 after JSON parsing)', () => {
    expect(amountMillimesSchema.parse(JSON.parse('45000.0'))).toBe(45000);
  });

  it.each([45000.5, 0.1, 1e-3])('refuses fractional value %d', (v) => {
    expect(amountMillimesSchema.safeParse(v).success).toBe(false);
  });

  it.each(['45000', '45,000', null, undefined, true, {}, 45000n])('refuses non-number %s', (v) => {
    expect(amountMillimesSchema.safeParse(v).success).toBe(false);
  });

  it.each([-1, Number.MAX_SAFE_INTEGER + 1, Number.POSITIVE_INFINITY, Number.NaN])(
    'refuses out-of-range or non-finite value %d',
    (v) => {
      expect(amountMillimesSchema.safeParse(v).success).toBe(false);
    },
  );
});

describe('positiveAmountMillimesSchema', () => {
  it('refuses 0 and accepts 1', () => {
    expect(positiveAmountMillimesSchema.safeParse(0).success).toBe(false);
    expect(positiveAmountMillimesSchema.safeParse(1).success).toBe(true);
  });

  it('refuses fractional and string values', () => {
    expect(positiveAmountMillimesSchema.safeParse(1.5).success).toBe(false);
    expect(positiveAmountMillimesSchema.safeParse('1').success).toBe(false);
  });
});

describe('isAmountMillimes', () => {
  it('narrows valid amounts only', () => {
    expect(isAmountMillimes(45000)).toBe(true);
    expect(isAmountMillimes(45000.5)).toBe(false);
    expect(isAmountMillimes(-1)).toBe(false);
    expect(isAmountMillimes('45000')).toBe(false);
  });
});

describe('tndToMillimes', () => {
  it('converts whole TND to millimes (45 TND = 45000)', () => {
    expect(tndToMillimes(45)).toBe(45000);
    expect(tndToMillimes(0)).toBe(0);
    expect(tndToMillimes(100)).toBe(100_000);
  });

  it('refuses fractional TND (no decimal arithmetic on money)', () => {
    expect(() => tndToMillimes(45.5)).toThrow(RangeError);
  });

  it('refuses negative TND', () => {
    expect(() => tndToMillimes(-1)).toThrow(RangeError);
  });

  it('refuses a result above the exact-integer range', () => {
    const maxTnd = Math.floor(Number.MAX_SAFE_INTEGER / MILLIMES_PER_TND);
    expect(tndToMillimes(maxTnd)).toBe(maxTnd * MILLIMES_PER_TND);
    expect(() => tndToMillimes(maxTnd + 1)).toThrow(RangeError);
  });
});
