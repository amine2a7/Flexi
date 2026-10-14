import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { describe, expect, it } from 'vitest';
import { colorToken, readTokens } from '../../tailwind.tokens';

const valid = (): Record<string, unknown> => structuredClone(tokensPreset.theme);

describe('readTokens', () => {
  it('reads the real preset', () => {
    const tokens = readTokens(tokensPreset.theme);
    expect(tokens.focus.width).toBeGreaterThan(0);
    expect(colorToken(tokens, tokens.focus.onLight)).toMatch(/^#/);
    expect(tokens.size['touch-target-min']).toBe('2.75rem');
    expect(tokens.motion.duration.fast).toBe(120);
    expect(tokens.motion.easing.spring).toBe('cubic-bezier(.34,1.56,.64,1)');
  });

  it.each([
    ['a missing focus group', (theme: Record<string, unknown>) => delete theme.focus, 'focus'],
    [
      'a renamed focus width',
      (theme: Record<string, unknown>) => {
        const focus = theme.focus as Record<string, unknown>;
        focus.thickness = focus.width;
        delete focus.width;
      },
      'focus.width',
    ],
    [
      'a focus colour that is not a colour token',
      (theme: Record<string, unknown>) => {
        (theme.focus as Record<string, unknown>)['color-on-dark'] = 'no-such-colour';
      },
      'colors.no-such-colour',
    ],
    [
      'a non-numeric duration',
      (theme: Record<string, unknown>) => {
        ((theme.motion as Record<string, unknown>).duration as Record<string, unknown>).fast =
          '120ms';
      },
      'motion.duration.fast',
    ],
    [
      'a numeric size',
      (theme: Record<string, unknown>) => {
        (theme.size as Record<string, unknown>)['header-height'] = 64;
      },
      'size.header-height',
    ],
    [
      'a missing skeleton duration',
      (theme: Record<string, unknown>) => {
        delete ((theme.motion as Record<string, unknown>).duration as Record<string, unknown>)
          .skeleton;
      },
      'motion.duration.skeleton',
    ],
  ])('throws on %s', (_name, mutate, path) => {
    const theme = valid();
    mutate(theme);
    expect(() => readTokens(theme)).toThrow(path);
  });
});
