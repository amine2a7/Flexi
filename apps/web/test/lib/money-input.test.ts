import { describe, expect, it } from 'vitest';
import { parseBps, parseMillimes } from '@/lib/format/money-input';

describe('parseMillimes (what the user typed -> integer millimes)', () => {
  it.each([
    ['45', 45_000],
    ['45,5', 45_500],
    ['45,500', 45_500],
    ['0,001', 1],
    ['1 500,250', 1_500_250],
    [' 12 ', 12_000],
    [',5', 500],
  ])('FR %s -> %i', (text, expected) => {
    expect(parseMillimes(text, 'fr')).toBe(expected);
  });

  it('AR reads like FR (Western digits, decimal comma)', () => {
    expect(parseMillimes('48 250,000', 'ar')).toBe(48_250_000);
  });

  it.each([
    ['1,500', 1_500_000],
    ['1,500.250', 1_500_250],
    ['45.5', 45_500],
  ])('EN %s -> %i (comma groups, point is decimal: UX-05)', (text, expected) => {
    expect(parseMillimes(text, 'en')).toBe(expected);
  });

  it.each(['', 'abc', '1,2345', '1,2,3', '-5', '1e3', '12.5'])('rejects %s in FR', (text) => {
    expect(parseMillimes(text, 'fr')).toBeUndefined();
  });

  it('rejects amounts beyond the safe integer range', () => {
    expect(parseMillimes('99999999999999999', 'fr')).toBeUndefined();
  });
});

describe('parseBps (percent -> basis points)', () => {
  it.each([
    ['2', 200],
    ['1,75', 175],
    ['0,5', 50],
    ['100', 10_000],
  ])('FR %s %% -> %i bps', (text, expected) => {
    expect(parseBps(text, 'fr')).toBe(expected);
  });

  it.each(['100,01', '1,234', 'x'])('rejects %s', (text) => {
    expect(parseBps(text, 'fr')).toBeUndefined();
  });
});
