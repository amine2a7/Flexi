import { describe, expect, it } from 'vitest';
import {
  CURRENCY_CODE,
  formatMillimes,
  formatMillimesWithCurrency,
  formatRateBps,
  MAX_MILLIMES,
} from '@/lib/format/money';

const THIN = ' ';
const NBSP = ' ';

describe('formatMillimes (the only money formatter)', () => {
  it.each([
    // fondations-composants.md A.1 and glossary E1 / E4
    [48_250_000, `48${THIN}250,000`],
    [45_000, '45,000'],
    [44_100, '44,100'],
    [900, '0,900'],
    [0, '0,000'],
    [1, '0,001'],
    [999, '0,999'],
    [1_000, '1,000'],
    [50_500_000, `50${THIN}500,000`],
    [MAX_MILLIMES, `9${THIN}007${THIN}199${THIN}254${THIN}740,991`],
  ])('FR %i -> %s', (millimes, expected) => {
    expect(formatMillimes(millimes, 'fr')).toBe(expected);
  });

  it('AR uses the same separators and Western digits as FR (decision of 2026-10-09)', () => {
    expect(formatMillimes(48_250_000, 'ar')).toBe(`48${THIN}250,000`);
    expect(formatMillimes(900, 'ar')).toBe('0,900');
  });

  it.each([
    [48_250_000, '48,250.000'],
    [900, '0.900'],
    [0, '0.000'],
    [MAX_MILLIMES, '9,007,199,254,740.991'],
  ])('EN %i -> %s', (millimes, expected) => {
    expect(formatMillimes(millimes, 'en')).toBe(expected);
  });

  it('is exact on the whole safe integer range (no floating point)', () => {
    for (const value of [MAX_MILLIMES - 1, MAX_MILLIMES - 999, 4_503_599_627_370_497]) {
      const text = formatMillimes(value, 'en').replaceAll(',', '').replace('.', '');
      expect(text).toBe(String(value).padStart(4, '0'));
    }
  });

  it.each([-1, 1.5, 0.1, Number.NaN, Number.POSITIVE_INFINITY, MAX_MILLIMES + 1, 1e21])(
    'refuses %s (amounts are non-negative safe integers)',
    (value) => {
      expect(() => formatMillimes(value, 'fr')).toThrow(RangeError);
    },
  );
});

describe('formatMillimesWithCurrency', () => {
  it('appends TND after a non-breaking space', () => {
    expect(CURRENCY_CODE).toBe('TND');
    expect(formatMillimesWithCurrency(48_250_000, 'fr')).toBe(`48${THIN}250,000${NBSP}TND`);
    expect(formatMillimesWithCurrency(48_250_000, 'en')).toBe(`48,250.000${NBSP}TND`);
  });
});

describe('formatRateBps', () => {
  it.each([
    [200, `2${NBSP}%`],
    [150, `1,5${NBSP}%`],
    [50, `0,5${NBSP}%`],
    [5, `0,05${NBSP}%`],
    [0, `0${NBSP}%`],
    [10_000, `100${NBSP}%`],
    [125, `1,25${NBSP}%`],
  ])('FR/AR %i bps -> %s', (bps, expected) => {
    expect(formatRateBps(bps, 'fr')).toBe(expected);
    expect(formatRateBps(bps, 'ar')).toBe(expected);
  });

  it.each([
    [200, '2%'],
    [150, '1.5%'],
    [50, '0.5%'],
  ])('EN %i bps -> %s', (bps, expected) => {
    expect(formatRateBps(bps, 'en')).toBe(expected);
  });

  it.each([-1, 10_001, 1.5, Number.NaN])('refuses %s', (value) => {
    expect(() => formatRateBps(value, 'fr')).toThrow(RangeError);
  });
});
