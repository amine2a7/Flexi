import type { Config } from 'tailwindcss';
import plugin from 'tailwindcss/plugin';
import tokensPreset from '@flexipay/ui-tokens/tailwind-preset';
import { colorToken, readTokens } from './tailwind.tokens';

// Every value comes from @flexipay/ui-tokens (source: docs/design/design-tokens.json).
// This file only exposes token groups that Tailwind has no built-in key for.
const tokens = readTokens(tokensPreset.theme);
const { motion } = tokens;

const ms = (value: number) => `${String(value)}ms`;
const durations = Object.fromEntries(
  Object.entries(motion.duration).map(([name, value]) => [name, ms(value)]),
);
const easings = { ...motion.easing };
const scales = Object.fromEntries(
  Object.entries(motion.scale).map(([name, value]) => [name, String(value)]),
);

// Animations (docs/design/animations/animations.md): only transform and opacity move. Every
// distance and scale is a CSS variable from the tokens; "prefers-reduced-motion" sets them to
// neutral values, so each animation becomes a plain fade (no movement, no bounce). In Arabic
// (dir="rtl") --fp-dir is -1: horizontal movements are mirrored.
const d = (name: string) => `var(--fp-d-${name})`;
const e = (name: string) => `var(--fp-e-${name})`;
const animation = {
  rise: `fp-rise ${d('slow')} ${e('out')} both`,
  fade: `fp-fade ${d('base')} ${e('out')} both`,
  'fade-out': `fp-fade-out ${d('fast')} ${e('in')} both`,
  'zoom-in': `fp-zoom-in ${d('base')} ${e('out')} both`,
  'zoom-out': `fp-zoom-out ${d('fast')} ${e('in')} both`,
  'sheet-in': `fp-sheet-in ${d('slow')} ${e('out')} both`,
  'sheet-out': `fp-sheet-out ${d('fast')} ${e('in')} both`,
  'toast-in': `fp-toast-in ${d('slow')} ${e('out')} both`,
  'toast-timer': `fp-timer ${d('toast')} linear forwards`,
  shake: `fp-shake ${d('shake')} ${e('out')}`,
  pulse: `fp-pulse ${d('slow')} ${e('spring')}`,
  bounce: `fp-pulse ${d('bounce')} ${e('spring')}`,
  pop: `fp-pop ${d('emphasis')} ${e('spring')} both`,
  'pop-fast': `fp-pop ${d('base')} ${e('spring')} both`,
  'grow-x': `fp-grow-x ${d('bars')} ${e('out')} both`,
  'grow-y': `fp-grow-y ${d('slow')} ${e('out')} both`,
  shimmer: `fp-shimmer ${d('skeleton')} linear infinite`,
  flash: `fp-flash ${d('flash')} ${e('out')} forwards`,
  // Ticket book (docs/design/carnet-tickets): a ticket torn off the book, the scissors that
  // sway, the sign-in ticket printed then its badge peeking out.
  tear: `fp-tear ${d('tear')} ${e('in')} forwards`,
  wiggle: `fp-wiggle ${d('wiggle')} ${e('out')} infinite alternate`,
  print: `fp-print ${d('print')} ${e('out')} both`,
  peek: `fp-peek ${d('peek')} ${e('spring')} ${d('peek-delay')} both`,
};

const motionPlugin = plugin((api) => {
  const vars: Record<string, string> = { '--fp-dir': '1' };
  for (const [name, value] of Object.entries(motion.duration)) vars[`--fp-d-${name}`] = ms(value);
  for (const [name, value] of Object.entries(motion.easing)) vars[`--fp-e-${name}`] = value;
  vars['--fp-rise'] = `${String(motion.distance.rise)}px`;
  vars['--fp-shake'] = `${String(motion.distance.shake)}px`;
  vars['--fp-tear-x'] = `${String(motion.distance['tear-x'])}px`;
  vars['--fp-tear-y'] = `${String(motion.distance['tear-y'])}px`;
  vars['--fp-tear-rotate'] = `${String(motion.distance['tear-rotate'])}deg`;
  vars['--fp-wiggle-rotate'] = `${String(motion.distance['wiggle-rotate'])}deg`;
  vars['--fp-peek'] = `${String(motion.distance.peek)}px`;
  vars['--fp-print'] = `${String(motion.distance.print)}px`;
  for (const [name, value] of Object.entries(motion.scale))
    vars[`--fp-scale-${name}`] = String(value);
  vars['--fp-slide'] = '100%';
  vars['--fp-grow-from'] = '0';
  vars['--fp-shimmer'] = '1';
  const still: Record<string, string> = {
    '--fp-rise': '0px',
    '--fp-shake': '0px',
    '--fp-tear-x': '0px',
    '--fp-tear-y': '0px',
    '--fp-tear-rotate': '0deg',
    '--fp-wiggle-rotate': '0deg',
    '--fp-peek': '0px',
    '--fp-print': '0px',
    '--fp-slide': '0%',
    '--fp-grow-from': '1',
    '--fp-shimmer': '0',
    '--fp-e-spring': motion.easing.out ?? 'ease-out',
  };
  for (const name of Object.keys(motion.scale)) still[`--fp-scale-${name}`] = '1';

  const cascade: Record<string, Record<string, string>> = {
    '.fp-cascade > *': { animation: animation.rise },
  };
  for (let index = 2; index <= 12; index += 1) {
    cascade[`.fp-cascade > *:nth-child(${String(index)})`] = {
      'animation-delay': `calc(${d('cascade-step')} * ${String(index - 1)})`,
    };
  }

  api.addBase({
    ':root': vars,
    '[dir="rtl"]': { '--fp-dir': '-1' },
    '@media (prefers-reduced-motion: reduce)': { ':root': still },
    '@keyframes fp-rise': { from: { opacity: '0', transform: 'translateY(var(--fp-rise))' } },
    '@keyframes fp-fade': { from: { opacity: '0' } },
    '@keyframes fp-fade-out': { to: { opacity: '0' } },
    '@keyframes fp-zoom-in': { from: { opacity: '0', transform: 'scale(var(--fp-scale-modal))' } },
    '@keyframes fp-zoom-out': { to: { opacity: '0', transform: 'scale(var(--fp-scale-modal))' } },
    '@keyframes fp-sheet-in': { from: { opacity: '0', transform: 'translateY(var(--fp-slide))' } },
    '@keyframes fp-sheet-out': { to: { opacity: '0', transform: 'translateY(var(--fp-slide))' } },
    '@keyframes fp-toast-in': {
      from: { opacity: '0', transform: 'translateX(calc(var(--fp-slide) * var(--fp-dir)))' },
    },
    '@keyframes fp-timer': { from: { transform: 'scaleX(1)' }, to: { transform: 'scaleX(0)' } },
    '@keyframes fp-shake': {
      '20%': { transform: 'translateX(calc(var(--fp-shake) * -1 * var(--fp-dir)))' },
      '40%': { transform: 'translateX(calc(var(--fp-shake) * 6 / 7 * var(--fp-dir)))' },
      '60%': { transform: 'translateX(calc(var(--fp-shake) * -4 / 7 * var(--fp-dir)))' },
      '80%': { transform: 'translateX(calc(var(--fp-shake) * 2 / 7 * var(--fp-dir)))' },
    },
    '@keyframes fp-pulse': { '40%': { transform: 'scale(var(--fp-scale-pulse))' } },
    '@keyframes fp-pop': { from: { opacity: '0', transform: 'scale(var(--fp-scale-pop))' } },
    '@keyframes fp-grow-x': { from: { transform: 'scaleX(var(--fp-grow-from))' } },
    '@keyframes fp-grow-y': { from: { transform: 'scaleY(var(--fp-grow-from))' } },
    '@keyframes fp-shimmer': {
      from: { transform: 'translateX(calc(-100% * var(--fp-dir)))' },
      to: { transform: 'translateX(calc(100% * var(--fp-dir)))' },
    },
    '@keyframes fp-flash': {
      '0%': { opacity: '1' },
      '70%': { opacity: '1' },
      '100%': { opacity: '0' },
    },
    // Torn off: a small lift, then up and away (mirrored in Arabic); a fade when motion is reduced.
    '@keyframes fp-tear': {
      '0%': { opacity: '1', transform: 'none' },
      '25%': {
        transform:
          'rotate(calc(var(--fp-tear-rotate) / 9 * var(--fp-dir))) translateY(calc(var(--fp-rise) * -1))',
      },
      '100%': {
        opacity: '0',
        transform:
          'rotate(calc(var(--fp-tear-rotate) * var(--fp-dir))) translate(calc(var(--fp-tear-x) * var(--fp-dir)), calc(var(--fp-tear-y) * -1))',
      },
    },
    '@keyframes fp-wiggle': {
      from: { transform: 'rotate(calc(var(--fp-wiggle-rotate) * -1))' },
      to: { transform: 'rotate(var(--fp-wiggle-rotate))' },
    },
    '@keyframes fp-print': {
      from: { opacity: '0', transform: 'translateY(calc(var(--fp-print) * -1))' },
    },
    '@keyframes fp-peek': { from: { opacity: '0', transform: 'translateY(var(--fp-peek))' } },
    ...cascade,
  });

  // Open and close states of the Radix primitives (dialogs): state-open:animate-zoom-in.
  api.addVariant('state-open', '&[data-state="open"]');
  api.addVariant('state-closed', '&[data-state="closed"]');

  api.addUtilities({
    // SVG shapes transformed around their own box (bars that grow from their start).
    '.fp-box-fill': { 'transform-box': 'fill-box' },
    // Accordion of the side menu (request of 2026-11-05): the height of a category opens and
    // closes in the base duration (200 ms); no movement when motion is reduced.
    '.fp-accordion': {
      display: 'grid',
      'grid-template-rows': '0fr',
      transition: `grid-template-rows ${d('base')} ${e('out')}`,
    },
    '.fp-accordion[data-open="true"]': { 'grid-template-rows': '1fr' },
    '.fp-accordion > *': { overflow: 'hidden', 'min-height': '0' },
    '@media (prefers-reduced-motion: reduce)': { '.fp-accordion': { transition: 'none' } },
  });

  api.addComponents({
    // Skeleton: grey shapes and a light reflection crossing them (hidden when motion is reduced).
    '.fp-skeleton': { position: 'relative', overflow: 'hidden' },
    '.fp-skeleton::after': {
      content: '""',
      position: 'absolute',
      inset: '0',
      opacity: 'var(--fp-shimmer)',
      'background-image': `linear-gradient(90deg, transparent, ${colorToken(tokens, 'surface')}, transparent)`,
      animation: animation.shimmer,
    },
    // New row of a list to handle: pale green background that fades out (opacity of an overlay).
    '.fp-flash': { position: 'relative' },
    '.fp-flash::after': {
      content: '""',
      position: 'absolute',
      inset: '0',
      'pointer-events': 'none',
      'background-color': colorToken(tokens, 'emerald-soft'),
      'mix-blend-mode': 'multiply',
      animation: animation.flash,
    },
  });
});

// Status badges read their colours from the `status` token group at runtime (StatusBadge): the
// matching classes are generated here so that Tailwind emits them.
const statusTokens = (tokensPreset.theme as { status?: Record<string, { bg: string; fg: string }> })
  .status;
const statusClasses = Object.values(statusTokens ?? {}).flatMap(({ bg, fg }) => [
  `bg-${bg}`,
  `text-${fg}`,
]);

// Credit types (Restauration, Habillement, Carburant, Cadeaux): badges, cards, bars and charts.
const creditTypeTokens = (
  tokensPreset.theme as {
    creditType?: Record<string, { bg: string; fg: string; solid: string }>;
  }
).creditType;
const creditTypeClasses = Object.values(creditTypeTokens ?? {}).flatMap(({ bg, fg, solid }) => [
  `bg-${bg}`,
  `text-${fg}`,
  `bg-${solid}`,
  `fill-${solid}`,
  `text-${solid}`,
]);

const config: Config = {
  presets: [tokensPreset],
  content: ['./src/**/*.{ts,tsx}'],
  safelist: [...statusClasses, ...creditTypeClasses],
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
      // duration-fast/base/slow/emphasis, ease-out/in/spring, scale-press/modal/pulse/pop.
      transitionDuration: durations,
      transitionDelay: durations,
      transitionTimingFunction: easings,
      scale: scales,
      animation,
    },
  },
  plugins: [
    motionPlugin,
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
