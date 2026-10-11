import { darkColors, rem, type Tokens } from './tokens.js';

export interface TailwindPreset {
  theme: Record<string, unknown>;
}

function splitFamily(value: string): string[] {
  return value.split(',').map((s) => s.trim());
}

/**
 * Tailwind preset: `theme.colors`, `spacing`, `borderRadius`, `fontSize`... REPLACE the Tailwind
 * defaults (no value outside the tokens). Non-standard keys (size, motion, focus, status) are
 * exposed for components; sizes are in rem to follow the user's font size.
 */
export function buildTailwindPreset(t: Tokens): TailwindPreset {
  const colors: Record<string, unknown> = {
    transparent: 'transparent',
    current: 'currentColor',
  };
  for (const [k, v] of Object.entries(t.color)) colors[k] = v.value;
  colors.dark = Object.fromEntries(darkColors(t));

  const fontSize = Object.fromEntries(
    Object.entries(t['type-scale']).map(([k, v]) => [
      k,
      [rem(v.size), { lineHeight: rem(v.line), fontWeight: String(v.weight) }],
    ]),
  );

  return {
    theme: {
      colors,
      spacing: Object.fromEntries(Object.entries(t.space).map(([k, v]) => [k, rem(v)])),
      borderRadius: Object.fromEntries(Object.entries(t.radius).map(([k, v]) => [k, rem(v)])),
      fontSize,
      fontFamily: {
        sans: splitFamily(t.font.family.value),
        ar: splitFamily(t.font['family-ar'].value),
      },
      fontWeight: Object.fromEntries(Object.entries(t.font.weight).map(([k, v]) => [k, String(v)])),
      boxShadow: { ...t.shadow },
      screens: Object.fromEntries(Object.entries(t.breakpoint).map(([k, v]) => [k, `${v}px`])),
      opacity: { ...t.opacity },
      size: Object.fromEntries(Object.entries(t.size).map(([k, v]) => [k, rem(v)])),
      motion: { ...t.motion },
      focus: { ...t.focus },
      status: Object.fromEntries(Object.entries(t.status).map(([k, v]) => [k, { ...v }])),
    },
  };
}

export const GENERATED_NOTICE =
  'GENERATED FILE - DO NOT EDIT. Source: docs/design/design-tokens.json. Run `pnpm --filter @flexipay/ui-tokens generate`.';

export function renderTailwindModule(t: Tokens): string {
  const json = JSON.stringify(buildTailwindPreset(t), null, 2);
  return `// ${GENERATED_NOTICE}\n'use strict';\nmodule.exports = ${json};\n`;
}

export function renderTailwindTypes(): string {
  return `// ${GENERATED_NOTICE}\ndeclare const preset: { theme: Record<string, unknown> };\nexport = preset;\n`;
}
