import type { Config } from 'tailwindcss';
import plugin from 'tailwindcss/plugin';
import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { colorToken, readTokens } from './tailwind.tokens';

// Every value comes from @flexipay/ui-tokens (source: docs/design/design-tokens.json).
// This file only exposes token groups that Tailwind has no built-in key for.
const tokens = readTokens(tokensPreset.theme);

const durations = Object.fromEntries(
  Object.entries(tokens.motion).map(([name, ms]) => [name, `${String(ms)}ms`]),
);

// Status badges read their colours from the `status` token group at runtime (StatusBadge): the
// matching classes are generated here so that Tailwind emits them.
const statusTokens = (tokensPreset.theme as { status?: Record<string, { bg: string; fg: string }> })
  .status;
const statusClasses = Object.values(statusTokens ?? {}).flatMap(({ bg, fg }) => [
  `bg-${bg}`,
  `text-${fg}`,
]);

const config: Config = {
  presets: [tokensPreset],
  content: ['./src/**/*.{ts,tsx}'],
  safelist: statusClasses,
  theme: {
    extend: {
      // The token scale starts at 1: `0` (no space) is not a design value but is needed for resets.
      spacing: { 0: '0' },
      // h-input-height, min-h-touch-target-min, w-sidebar-width, max-w-toast-max-width...
      size: tokens.size,
      height: tokens.size,
      minHeight: tokens.size,
      minWidth: tokens.size,
      width: tokens.size,
      maxWidth: tokens.size,
      transitionDuration: durations,
      keyframes: {
        // Skeleton shimmer: moves from the start to the end of the reading direction.
        shimmer: {
          '0%': { backgroundPosition: '100% 0' },
          '100%': { backgroundPosition: '-100% 0' },
        },
      },
      animation: {
        skeleton: `shimmer ${String(tokens.motion.skeleton)}ms linear infinite`,
      },
    },
  },
  plugins: [
    plugin((api) => {
      const ring = (colorName: string) => ({
        outline: `${String(tokens.focus.width)}px solid ${colorToken(tokens, colorName)}`,
        'outline-offset': `${String(tokens.focus.offset)}px`,
      });
      api.addUtilities({
        // Focus ring (charte A.6): navy on light backgrounds, emerald on navy.
        '.focus-ring': ring(tokens.focus.onLight),
        '.focus-ring-on-dark': ring(tokens.focus.onDark),
      });
    }),
  ],
};

export default config;
