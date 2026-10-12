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
});
