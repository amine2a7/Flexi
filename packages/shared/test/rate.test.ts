import { describe, expect, it } from 'vitest';
import { BPS_PER_UNIT, MAX_RATE_BPS, MIN_RATE_BPS, rateBpsSchema } from '../src/index.js';

describe('rate constants', () => {
  it('100 % = 10 000 bps', () => {
    expect(BPS_PER_UNIT).toBe(10_000);
    expect(MIN_RATE_BPS).toBe(0);
    expect(MAX_RATE_BPS).toBe(10_000);
  });
});

describe('rateBpsSchema', () => {
  it.each([0, 50, 100, 150, 200, 10_000])('accepts %d bps', (v) => {
    expect(rateBpsSchema.safeParse(v).success).toBe(true);
  });

  it.each([-1, 10_001, 1.5, 0.02, Number.NaN])('refuses %d', (v) => {
    expect(rateBpsSchema.safeParse(v).success).toBe(false);
  });

  it.each(['200', '2%', null])('refuses non-number %s', (v) => {
    expect(rateBpsSchema.safeParse(v).success).toBe(false);
  });
});
