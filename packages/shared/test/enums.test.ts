import { describe, expect, it } from 'vitest';
import {
  BUSINESS_TIME_ZONE,
  CURRENCY,
  DIRECTIONS,
  currencySchema,
  directionSchema,
} from '../src/index.js';

describe('currency', () => {
  it('only TND exists', () => {
    expect(CURRENCY).toBe('TND');
    expect(currencySchema.safeParse('TND').success).toBe(true);
    expect(currencySchema.safeParse('EUR').success).toBe(false);
    expect(currencySchema.safeParse('tnd').success).toBe(false);
  });
});

describe('direction', () => {
  it('is DEBIT or CREDIT (amounts are never negative)', () => {
    expect(DIRECTIONS).toEqual(['DEBIT', 'CREDIT']);
    expect(directionSchema.safeParse('DEBIT').success).toBe(true);
    expect(directionSchema.safeParse('CREDIT').success).toBe(true);
    expect(directionSchema.safeParse('debit').success).toBe(false);
  });
});

describe('business time zone', () => {
  it('is Africa/Tunis and known to the runtime', () => {
    expect(BUSINESS_TIME_ZONE).toBe('Africa/Tunis');
    expect(() => new Intl.DateTimeFormat('fr-TN', { timeZone: BUSINESS_TIME_ZONE })).not.toThrow();
  });
});
