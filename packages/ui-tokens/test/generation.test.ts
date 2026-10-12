import { readFileSync, readdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { camel } from '../src/naming.js';
import { quote, renderDart } from '../src/dart.js';
import { buildTailwindPreset, renderTailwindModule } from '../src/tailwind.js';
import { loadTokens, type Tokens } from '../src/tokens.js';

const here = dirname(fileURLToPath(import.meta.url));
const pkg = join(here, '..');
const tokens = loadTokens();
const darkEntries = Object.entries(tokens['color-dark'] ?? {}).flatMap(([k, v]) =>
  typeof v === 'object' ? [[k, v.value] as const] : [],
);

describe('determinism and freshness', () => {
  it('generates identical output twice', () => {
    expect(renderDart(loadTokens())).toBe(renderDart(loadTokens()));
    expect(renderTailwindModule(loadTokens())).toBe(renderTailwindModule(loadTokens()));
  });
  it('committed generated files are up to date (run `pnpm generate`)', () => {
    expect(readFileSync(join(pkg, 'dart/lib/flexipay_tokens.dart'), 'utf8')).toBe(
      renderDart(tokens),
    );
    expect(readFileSync(join(pkg, 'generated/tailwind-preset.cjs'), 'utf8')).toBe(
      renderTailwindModule(tokens),
    );
  });
});

describe('tailwind preset', () => {
  const preset = buildTailwindPreset(tokens);
  const theme = preset.theme as Record<string, Record<string, unknown>>;
  const rem = (n: number): string => `${n / 16}rem`;

  it('contains every colour', () => {
    for (const [k, v] of Object.entries(tokens.color)) expect(theme.colors?.[k]).toBe(v.value);
  });
  it('contains the dark palette', () => {
    expect(darkEntries.length).toBeGreaterThan(0);
    for (const [k, v] of darkEntries) {
      expect((theme.colors?.dark as Record<string, string>)[k]).toBe(v);
    }
  });
  it('contains space, radius, size, type-scale, breakpoints, motion, opacity, shadow, font', () => {
    for (const [k, v] of Object.entries(tokens.space)) expect(theme.spacing?.[k]).toBe(rem(v));
    for (const [k, v] of Object.entries(tokens.radius))
      expect(theme.borderRadius?.[k]).toBe(rem(v));
    for (const [k, v] of Object.entries(tokens.size)) expect(theme.size?.[k]).toBe(rem(v));
    for (const [k, v] of Object.entries(tokens['type-scale'])) {
      expect(theme.fontSize?.[k]).toEqual([
        rem(v.size),
        { lineHeight: rem(v.line), fontWeight: String(v.weight) },
      ]);
    }
    for (const [k, v] of Object.entries(tokens.breakpoint))
      expect(theme.screens?.[k]).toBe(`${v}px`);
    for (const [k, v] of Object.entries(tokens.motion)) expect(theme.motion?.[k]).toBe(v);
    for (const [k, v] of Object.entries(tokens.opacity)) expect(theme.opacity?.[k]).toBe(v);
    for (const [k, v] of Object.entries(tokens.shadow)) expect(theme.boxShadow?.[k]).toBe(v);
    for (const [k, v] of Object.entries(tokens.font.weight))
      expect(theme.fontWeight?.[k]).toBe(String(v));
    expect(JSON.stringify(theme.fontFamily)).toContain('Inter');
    expect(JSON.stringify(theme.fontFamily)).toContain('IBM Plex Sans Arabic');
    expect(theme.focus).toEqual(tokens.focus);
  });
  it('contains every status with existing colour references', () => {
    for (const [k, v] of Object.entries(tokens.status)) {
      expect(theme.status?.[k]).toEqual(v);
      expect(tokens.color[v.bg], `${k}.bg`).toBeDefined();
      expect(tokens.color[v.fg], `${k}.fg`).toBeDefined();
    }
  });
});

describe('dart output', () => {
  const dart = renderDart(tokens);
  it('has a generated header and imports flutter', () => {
    expect(dart.startsWith('// GENERATED FILE')).toBe(true);
    expect(dart).toContain("import 'package:flutter/material.dart';");
    expect(dart.endsWith('\n')).toBe(true);
  });
  it('has balanced brackets and no placeholder garbage', () => {
    for (const [o, cl] of [
      ['{', '}'],
      ['(', ')'],
      ['[', ']'],
    ] as const) {
      expect(dart.split(o).length, o).toBe(dart.split(cl).length);
    }
    expect(dart).not.toMatch(/undefined|NaN|\[object|\bnull\b/);
  });
  it('declares every colour with the exact ARGB value', () => {
    for (const [k, v] of Object.entries(tokens.color)) {
      const m = /^#([0-9A-F]{6})$/i.exec(v.value);
      if (m?.[1]) {
        expect(dart, k).toContain(
          `static const Color ${camel(k)} = Color(0xFF${m[1].toUpperCase()});`,
        );
      } else {
        expect(dart, k).toContain(`static const Color ${camel(k)} = Color.fromRGBO(`);
      }
    }
  });
  it('declares every other token group', () => {
    for (const [k] of darkEntries) {
      expect(dart, k).toContain(`static const Color ${camel(k)} = Color(0xFF`);
    }
    for (const [k, v] of Object.entries(tokens.space)) {
      expect(dart).toContain(`static const double space${k} = ${v};`);
    }
    for (const [k, v] of Object.entries(tokens.radius)) {
      expect(dart).toContain(`static const double ${camel(k)} = ${v};`);
    }
    for (const [k, v] of Object.entries(tokens.size)) {
      expect(dart).toContain(`static const double ${camel(k)} = ${v};`);
    }
    for (const k of Object.keys(tokens['type-scale'])) {
      expect(dart).toContain(`static const TextStyle ${camel(k)} = TextStyle(`);
    }
    for (const [k, v] of Object.entries(tokens.motion)) {
      expect(dart).toContain(`static const Duration ${camel(k)} = Duration(milliseconds: ${v});`);
    }
    for (const [k, v] of Object.entries(tokens.opacity)) {
      expect(dart).toContain(`static const double ${camel(k)} = ${v};`);
    }
    for (const [k, v] of Object.entries(tokens.breakpoint)) {
      expect(dart).toContain(`static const double ${camel(k)} = ${v};`);
    }
    for (const k of Object.keys(tokens.shadow)) {
      expect(dart).toContain(`static const List<BoxShadow> ${camel(k)} = [`);
    }
    for (const [k, v] of Object.entries(tokens.font.weight)) {
      expect(dart).toContain(`static const FontWeight ${camel(k)} = FontWeight.w${v};`);
    }
    expect(dart).toContain("'Inter'");
    expect(dart).toContain("'IBM Plex Sans Arabic'");
    expect(dart).toContain(`static const double focusWidth = ${tokens.focus.width};`);
    expect(dart).toContain(`static const double focusOffset = ${tokens.focus.offset};`);
  });
  it('declares every status with label key, icon and colours', () => {
    for (const [k, v] of Object.entries(tokens.status)) {
      expect(dart).toContain(`'${k}': FlexiStatusStyle(`);
      expect(dart).toContain(`labelKey: '${v.labelKey}'`);
      expect(dart).toContain(`icon: '${v.icon}'`);
      expect(dart).toContain(`bg: FlexiColors.${camel(v.bg)}`);
      expect(dart).toContain(`fg: FlexiColors.${camel(v.fg)}`);
    }
  });
  it('defines light ThemeData built from tokens', () => {
    expect(dart).toContain('class FlexiTheme');
    expect(dart).toContain('static ThemeData light()');
    expect(dart).toContain('ColorScheme.light(');
    expect(dart).toContain('useMaterial3: true');
  });
});

describe('no hard-coded values outside the JSON', () => {
  const srcDir = join(here, '..', 'src');
  it.each(readdirSync(srcDir).filter((f) => f.endsWith('.ts')))(
    'src/%s has no colour literal',
    (f) => {
      const text = readFileSync(join(srcDir, f), 'utf8');
      expect(text).not.toMatch(/#[0-9a-fA-F]{3,8}\b/);
      expect(text).not.toMatch(/0x[0-9A-Fa-f]{6,8}/);
      expect(text).not.toMatch(/\b(hsla?|rgba)\(\s*\d/);
    },
  );
  it('every colour in the JSON is a #RRGGBB or rgba() literal', () => {
    for (const [k, v] of Object.entries(tokens.color)) {
      expect(v.value, k).toMatch(/^(#[0-9A-Fa-f]{6}|rgba\(\d+,\s*\d+,\s*\d+,\s*[\d.]+\))$/);
    }
  });
});

describe('Dart generator output encoding (SC-9)', () => {
  const clone = (): Tokens => structuredClone(tokens);

  it('escapes quotes, dollar and line breaks in Dart strings', () => {
    const bs = String.fromCharCode(92);
    const nl = String.fromCharCode(10);
    const input = ['a', "'", 'b', '$', 'c', nl, 'd', bs, 'e'].join('');
    const expected = ["'a", bs + "'", 'b', bs + '$', 'c', bs + 'n', 'd', bs + bs, "e'"].join('');
    expect(quote(input)).toBe(expected);
  });
  it('rejects a key that is not a plain name', () => {
    const t = clone();
    t.color['x}; evil(); {'] = { value: '#000000' };
    expect(() => renderDart(t)).toThrow(/unsafe or invalid/);
  });
  it('rejects a trapped label key, icon or status key', () => {
    const a = clone();
    const first = Object.keys(a.status)[0] ?? '';
    const entry = a.status[first];
    if (!entry) throw new Error('no status');
    entry.labelKey = "x'${evil()}";
    expect(() => renderDart(a)).toThrow(/unsafe or invalid/);
    const b = clone();
    b.status['bad key'] = { ...entry };
    expect(() => renderDart(b)).toThrow(/unsafe or invalid/);
    const c = clone();
    const ce = c.status[first];
    if (!ce) throw new Error('no status');
    ce.icon = 'A$B';
    expect(() => renderDart(c)).toThrow(/unsafe or invalid/);
  });
  it('rejects a status referencing an unknown colour and a trapped font family', () => {
    const a = clone();
    const k = Object.keys(a.status)[0] ?? '';
    const e = a.status[k];
    if (!e) throw new Error('no status');
    e.bg = 'nope';
    expect(() => renderDart(a)).toThrow(/unsafe or invalid/);
    const b = clone();
    b.font.family.value = "Inter', evil: '${x}";
    expect(() => renderDart(b)).toThrow(/unsafe or invalid/);
  });
  it('rejects a token that FlexiTheme.light() depends on (rename of navy)', () => {
    const t = clone();
    const navy = t.color.navy;
    if (!navy) throw new Error('no navy');
    delete t.color.navy;
    t.color['navy-renamed'] = navy;
    expect(() => renderDart(t)).toThrow(/FlexiTheme requires token color.navy/);
  });
  it('generated Dart contains no dollar sign', () => {
    expect(renderDart(tokens)).not.toContain('$');
  });
});
