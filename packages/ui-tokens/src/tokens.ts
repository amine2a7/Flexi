import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

export interface ColorToken {
  value: string;
  usage?: string;
}
export interface TypeStyle {
  size: number;
  line: number;
  weight: number;
}
export interface StatusToken {
  label: string;
  labelKey: string;
  icon: string;
  bg: string;
  fg: string;
}

export interface Tokens {
  color: Record<string, ColorToken>;
  'color-dark'?: Record<string, ColorToken | string>;
  font: {
    family: { value: string };
    'family-ar': { value: string };
    weight: Record<string, number>;
  };
  'type-scale': Record<string, TypeStyle>;
  space: Record<string, number>;
  radius: Record<string, number>;
  size: Record<string, number>;
  focus: { width: number; offset: number; 'color-on-light': string; 'color-on-dark': string };
  opacity: Record<string, number>;
  breakpoint: Record<string, number>;
  shadow: Record<string, string>;
  motion: Record<string, number>;
  status: Record<string, StatusToken>;
}

const here = dirname(fileURLToPath(import.meta.url));

/** Single source of truth. */
export const TOKENS_PATH = join(here, '..', '..', '..', 'docs', 'design', 'design-tokens.json');

export function loadTokens(path: string = TOKENS_PATH): Tokens {
  return JSON.parse(readFileSync(path, 'utf8')) as Tokens;
}

/** Dark palette entries only (drops "$status"-style metadata keys). */
export function darkColors(t: Tokens): [string, string][] {
  return Object.entries(t['color-dark'] ?? {}).flatMap(([k, v]) =>
    typeof v === 'object' ? [[k, v.value] as [string, string]] : [],
  );
}

export function rem(px: number): string {
  return `${px / 16}rem`;
}
