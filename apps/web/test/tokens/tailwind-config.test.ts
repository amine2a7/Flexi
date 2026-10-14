import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import resolveConfig from 'tailwindcss/resolveConfig';
import { describe, expect, it } from 'vitest';
import config from '../../tailwind.config';

interface TokenFile {
  color: Record<string, { value: string }>;
}

const tokenFile = JSON.parse(
  readFileSync(
    fileURLToPath(new URL('../../../../docs/design/design-tokens.json', import.meta.url)),
    'utf8',
  ),
) as TokenFile;

const theme = resolveConfig(config).theme as unknown as {
  colors: Record<string, string>;
  height: Record<string, string>;
  screens: Record<string, string>;
  spacing: Record<string, string>;
  transitionDuration: Record<string, string>;
  transitionTimingFunction: Record<string, string>;
};

describe('Tailwind theme comes from the design tokens', () => {
  it('exposes the brand colours of design-tokens.json', () => {
    expect(theme.colors.navy).toBe(tokenFile.color.navy?.value);
    expect(theme.colors['emerald-text']).toBe(tokenFile.color['emerald-text']?.value);
  });

  it('replaces Tailwind defaults (no default palette, no arbitrary spacing)', () => {
    expect(theme.colors.red).toBeUndefined();
    expect(theme.spacing['7']).toBeUndefined();
    expect(Object.keys(theme.screens)).toEqual(['sm', 'md', 'lg', 'xl']);
  });

  it('exposes token sizes as utilities (touch target 44 px = 2.75rem)', () => {
    expect(theme.height['touch-target-min']).toBe('2.75rem');
    expect(theme.height['header-height']).toBe('4rem');
  });

  it('exposes motion durations from the tokens', () => {
    expect(theme.transitionDuration.fast).toBe('120ms');
    expect(theme.transitionDuration.base).toBe('200ms');
  });

  it('exposes the motion curves from the tokens', () => {
    expect(theme.transitionTimingFunction.out).toBe('cubic-bezier(.2,0,0,1)');
    expect(theme.transitionTimingFunction.spring).toBe('cubic-bezier(.34,1.56,.64,1)');
  });
});

type Rules = Record<string, unknown>;

/** CSS rules the motion plugin adds to the base layer (first plugin of the config). */
function motionBase(): Rules {
  const base: Rules = {};
  const plugins = (config.plugins ?? []) as { handler: (api: unknown) => void }[];
  plugins[0]?.handler({
    addBase: (rules: Rules) => Object.assign(base, rules),
    addVariant: () => undefined,
    addUtilities: () => undefined,
    addComponents: () => undefined,
  });
  return base;
}

describe('Animations (docs/design/animations/animations.md)', () => {
  const base = motionBase();

  it('only animate transform and opacity', () => {
    const keyframes = Object.entries(base).filter(([name]) => name.startsWith('@keyframes'));
    expect(keyframes.length).toBeGreaterThan(10);
    for (const [, frames] of keyframes) {
      for (const declarations of Object.values(frames as Record<string, Rules>)) {
        for (const property of Object.keys(declarations)) {
          expect(['transform', 'opacity']).toContain(property);
        }
      }
    }
  });

  it('take no movement and no bounce when the system asks for reduced motion', () => {
    const reduced = (base['@media (prefers-reduced-motion: reduce)'] as Record<string, Rules>)[
      ':root'
    ];
    expect(reduced).toMatchObject({
      '--fp-rise': '0px',
      '--fp-shake': '0px',
      '--fp-slide': '0%',
      '--fp-scale-pulse': '1',
      '--fp-scale-pop': '1',
      '--fp-e-spring': 'cubic-bezier(.2,0,0,1)',
    });
  });

  it('mirror horizontal movements in Arabic (right to left)', () => {
    expect(base[':root']).toMatchObject({ '--fp-dir': '1' });
    expect(base['[dir="rtl"]']).toEqual({ '--fp-dir': '-1' });
  });
});
