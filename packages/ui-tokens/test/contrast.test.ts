import { describe, expect, it } from 'vitest';
import { loadTokens } from '../src/tokens.js';
import { contrastRatio, parseHex, relativeLuminance } from './wcag.js';

const tokens = loadTokens();
const c = (name: string): string => {
  const entry = tokens.color[name];
  if (!entry) throw new Error(`unknown color token ${name}`);
  return entry.value;
};
const ratioOf = (fg: string, bg: string): number => contrastRatio(parseHex(c(fg)), parseHex(c(bg)));

type Pair = readonly [fg: string, bg: string];

// Normal text: 4.5:1 (WCAG 1.4.3).
const TEXT_PAIRS: readonly Pair[] = [
  ['text', 'bg'],
  ['text', 'surface'],
  ['text-muted', 'surface'],
  ['text-muted', 'bg'],
  ['emerald-text', 'surface'],
  ['emerald-text', 'bg'],
  ['emerald-text', 'emerald-soft'],
  ['on-emerald', 'emerald'],
  ['on-navy', 'navy'],
  ['on-navy', 'navy-deep'],
  ['on-navy-muted', 'navy'],
  ['on-navy-muted', 'navy-deep'],
  ['on-danger', 'danger'],
  ['danger', 'surface'],
  ['danger', 'bg'],
  ['danger-text', 'surface'],
  ['danger-text', 'bg'],
  ['danger-text', 'danger-soft'],
  ['info', 'surface'],
  ['info-text', 'surface'],
  ['info-text', 'info-soft'],
  ['warning-text', 'surface'],
  ['warning-text', 'warning-soft'],
  ['neutral-text', 'surface'],
  ['neutral-text', 'border'],
];

// Non-text components and focus indicators: 3:1 (WCAG 1.4.11).
const COMPONENT_PAIRS: readonly Pair[] = [
  ['border-strong', 'surface'],
  ['border-strong', 'bg'],
  ['danger', 'surface'],
  ['navy', 'surface'],
  ['navy', 'bg'],
  ['emerald', 'navy'],
  ['emerald', 'navy-deep'],
];

describe('WCAG helpers', () => {
  it('computes known reference ratios', () => {
    expect(contrastRatio(parseHex('#000000'), parseHex('#FFFFFF'))).toBeCloseTo(21, 5);
    expect(contrastRatio(parseHex('#FFFFFF'), parseHex('#FFFFFF'))).toBeCloseTo(1, 5);
    expect(relativeLuminance(parseHex('#FFFFFF'))).toBeCloseTo(1, 5);
  });
});

describe('contrast AA: text pairs >= 4.5', () => {
  it.each(TEXT_PAIRS)('%s on %s', (fg, bg) => {
    const ratio = ratioOf(fg, bg);
    expect(ratio, `${fg} on ${bg} = ${Math.round(ratio * 100) / 100}`).toBeGreaterThanOrEqual(4.5);
  });
});

describe('contrast AA: components >= 3', () => {
  it.each(COMPONENT_PAIRS)('%s on %s', (fg, bg) => {
    const ratio = ratioOf(fg, bg);
    expect(ratio, `${fg} on ${bg} = ${Math.round(ratio * 100) / 100}`).toBeGreaterThanOrEqual(3);
  });
});

describe('contrast AA: every status badge (fg on bg) >= 4.5', () => {
  it.each(Object.entries(tokens.status))('%s', (key, s) => {
    const ratio = ratioOf(s.fg, s.bg);
    expect(
      ratio,
      `${key}: ${s.fg} on ${s.bg} = ${Math.round(ratio * 100) / 100}`,
    ).toBeGreaterThanOrEqual(4.5);
  });
});

describe('dark palette text (optional MVP) >= 4.5', () => {
  const d = (n: string): string => {
    const e = tokens['color-dark']?.[n];
    if (!e || typeof e === 'string') throw new Error(`unknown dark token ${n}`);
    return e.value;
  };
  const dark: readonly Pair[] = [
    ['text', 'bg'],
    ['text', 'surface'],
    ['text-muted', 'bg'],
    ['text-muted', 'surface'],
  ];
  it.each(dark)('dark %s on %s', (fg, bg) => {
    const ratio = contrastRatio(parseHex(d(fg)), parseHex(d(bg)));
    expect(ratio, `${fg} on ${bg} = ${Math.round(ratio * 100) / 100}`).toBeGreaterThanOrEqual(4.5);
  });
});
