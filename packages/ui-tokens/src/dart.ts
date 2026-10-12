import { camel } from './naming.js';
import { GENERATED_NOTICE } from './tailwind.js';
import { darkColors, type Tokens } from './tokens.js';

const HEX = /^#([0-9a-fA-F]{6})$/;
const RGBA = /^rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)$/;

export function dartColor(value: string): string {
  const hex = HEX.exec(value);
  if (hex?.[1]) return `Color(0xFF${hex[1].toUpperCase()})`;
  const rgba = RGBA.exec(value);
  if (rgba) return `Color.fromRGBO(${rgba[1]}, ${rgba[2]}, ${rgba[3]}, ${rgba[4]})`;
  throw new Error(`unsupported colour value: ${value}`);
}

/** Split on commas that are not inside parentheses. */
function splitTopLevel(value: string): string[] {
  const parts: string[] = [];
  let depth = 0;
  let current = '';
  for (const ch of value) {
    if (ch === '(') depth++;
    if (ch === ')') depth--;
    if (ch === ',' && depth === 0) {
      parts.push(current.trim());
      current = '';
    } else {
      current += ch;
    }
  }
  if (current.trim()) parts.push(current.trim());
  return parts;
}

function dartShadow(css: string): string {
  const layers = splitTopLevel(css).map((layer) => {
    const m = /^(.*?)\s+(rgba?\(.*\)|#[^\s]+)$/.exec(layer);
    if (!m?.[1] || !m[2]) throw new Error(`unsupported shadow: ${layer}`);
    const nums = m[1].split(/\s+/).map((n) => Number(n.replace('px', '')));
    const [x, y, blur, spread] = nums;
    const spreadArg = spread ? `, spreadRadius: ${spread}` : '';
    return `    BoxShadow(color: ${dartColor(m[2])}, offset: Offset(${x}, ${y}), blurRadius: ${blur}${spreadArg}),`;
  });
  return `[\n${layers.join('\n')}\n  ]`;
}

/** Dart single-quoted literal: also neutralises `$` (interpolation) and line breaks. */
export function quote(s: string): string {
  return `'${s
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/\$/g, '\\$')
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '\\r')}'`;
}

const KEY = /^[a-z0-9][a-z0-9-]*$/;
const STATUS_KEY = /^[A-Z][A-Z_]*$/;
const ICON = /^[A-Za-z][A-Za-z0-9]*$/;
const I18N_KEY = /^[A-Za-z][A-Za-z0-9_.]*$/;
const FAMILY = /^[A-Za-z0-9 ,_-]+$/;

function check(ok: boolean, what: string): void {
  if (!ok) throw new Error(`unsafe or invalid design token for Dart generation: ${what}`);
}

/** Token keys become Dart identifiers and strings: reject anything that is not a plain name. */
export function assertSafeTokens(t: Tokens): void {
  const groups: Record<string, object> = {
    color: t.color,
    'color-dark': Object.fromEntries(darkColors(t)),
    space: t.space,
    radius: t.radius,
    size: t.size,
    'type-scale': t['type-scale'],
    opacity: t.opacity,
    breakpoint: t.breakpoint,
    shadow: t.shadow,
    motion: t.motion,
    'font.weight': t.font.weight,
  };
  for (const [group, entries] of Object.entries(groups)) {
    for (const key of Object.keys(entries)) check(KEY.test(key), `${group}.${key}`);
  }
  for (const [k, v] of Object.entries(t.status)) {
    check(STATUS_KEY.test(k), `status.${k}`);
    check(ICON.test(v.icon), `status.${k}.icon`);
    check(I18N_KEY.test(v.labelKey), `status.${k}.labelKey`);
    check(
      Object.hasOwn(t.color, v.bg) && Object.hasOwn(t.color, v.fg),
      `status.${k} colour reference`,
    );
  }
  check(FAMILY.test(t.font.family.value), 'font.family');
  check(FAMILY.test(t.font['family-ar'].value), 'font.family-ar');
}

/**
 * Tokens referenced by name in the generated `FlexiTheme.light()`. A renamed or removed token would
 * break the Dart build without any Node test noticing (Flutter is not installed), so fail here.
 */
const THEME_REQUIRED: Record<string, readonly string[]> = {
  color: [
    'navy',
    'on-navy',
    'emerald',
    'on-emerald',
    'danger',
    'on-danger',
    'surface',
    'bg',
    'text',
    'text-muted',
    'border',
    'border-strong',
    'overlay',
  ],
  'type-scale': [
    'amount-xl',
    'amount',
    'headline',
    'title',
    'title-sm',
    'body-lg',
    'body',
    'caption',
    'label',
    'micro',
  ],
  radius: ['input', 'button', 'card-mobile'],
  size: ['border-width', 'header-height', 'touch-target-mobile'],
};

export function assertThemeTokens(t: Tokens): void {
  const groups: Record<string, object> = {
    color: t.color,
    'type-scale': t['type-scale'],
    radius: t.radius,
    size: t.size,
  };
  for (const [group, keys] of Object.entries(THEME_REQUIRED)) {
    for (const key of keys) {
      check(Object.hasOwn(groups[group] ?? {}, key), `FlexiTheme requires token ${group}.${key}`);
    }
  }
}

function family(value: string): { primary: string; fallback: string[] } {
  const [primary = '', ...fallback] = value.split(',').map((s) => s.trim());
  return { primary, fallback };
}

const num = (n: number): string => String(n);

export function renderDart(t: Tokens): string {
  assertSafeTokens(t);
  assertThemeTokens(t);
  const out: string[] = [];
  const w = (s = ''): void => {
    out.push(s);
  };
  const doubles = (cls: string, doc: string, entries: [string, number][]): void => {
    w(`/// ${doc}`);
    w(`abstract final class ${cls} {`);
    for (const [k, v] of entries) w(`  static const double ${k} = ${num(v)};`);
    w('}');
    w();
  };

  w(`// ${GENERATED_NOTICE}`);
  w('// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars');
  w();
  w("import 'package:flutter/material.dart';");
  w();

  w('/// Colour tokens (`color.*`).');
  w('abstract final class FlexiColors {');
  for (const [k, v] of Object.entries(t.color)) {
    w(`  static const Color ${camel(k)} = ${dartColor(v.value)};`);
  }
  w('}');
  w();

  w('/// Optional dark palette (`color-dark.*`), to be validated before use.');
  w('abstract final class FlexiColorsDark {');
  for (const [k, v] of darkColors(t)) w(`  static const Color ${camel(k)} = ${dartColor(v)};`);
  w('}');
  w();

  doubles(
    'FlexiSpace',
    'Spacing tokens (`space.*`), logical pixels.',
    Object.entries(t.space).map(([k, v]) => [`space${k}`, v]),
  );
  doubles(
    'FlexiRadius',
    'Radius tokens (`radius.*`).',
    Object.entries(t.radius).map(([k, v]) => [camel(k), v]),
  );

  const sizes: [string, number][] = Object.entries(t.size).map(([k, v]) => [camel(k), v]);
  sizes.push(['focusWidth', t.focus.width], ['focusOffset', t.focus.offset]);
  doubles('FlexiSize', 'Size tokens (`size.*`) and focus ring (`focus.*`).', sizes);
  doubles(
    'FlexiOpacity',
    'Opacity tokens (`opacity.*`).',
    Object.entries(t.opacity).map(([k, v]) => [camel(k), v]),
  );
  doubles(
    'FlexiBreakpoint',
    'Breakpoint tokens (`breakpoint.*`).',
    Object.entries(t.breakpoint).map(([k, v]) => [camel(k), v]),
  );

  w('/// Motion tokens (`motion.*`).');
  w('abstract final class FlexiMotion {');
  for (const [k, v] of Object.entries(t.motion)) {
    w(`  static const Duration ${camel(k)} = Duration(milliseconds: ${num(v)});`);
  }
  w('}');
  w();

  w('/// Shadow tokens (`shadow.*`).');
  w('abstract final class FlexiShadow {');
  for (const [k, v] of Object.entries(t.shadow)) {
    w(`  static const List<BoxShadow> ${camel(k)} = ${dartShadow(v)};`);
  }
  w('}');
  w();

  const fr = family(t.font.family.value);
  const ar = family(t.font['family-ar'].value);
  w('/// Font tokens (`font.*`).');
  w('abstract final class FlexiFont {');
  w(`  static const String family = ${quote(fr.primary)};`);
  w(`  static const List<String> familyFallback = [${fr.fallback.map(quote).join(', ')}];`);
  w(`  static const String familyAr = ${quote(ar.primary)};`);
  w(`  static const List<String> familyArFallback = [${ar.fallback.map(quote).join(', ')}];`);
  for (const [k, v] of Object.entries(t.font.weight)) {
    w(`  static const FontWeight ${camel(k)} = FontWeight.w${v};`);
  }
  w('}');
  w();

  w('/// Type scale (`type-scale.*`). Line height is expressed as a ratio of the font size.');
  w('abstract final class FlexiTypeScale {');
  for (const [k, v] of Object.entries(t['type-scale'])) {
    w(`  static const TextStyle ${camel(k)} = TextStyle(`);
    w(`    fontFamily: FlexiFont.family,`);
    w(`    fontFamilyFallback: FlexiFont.familyFallback,`);
    w(`    fontSize: ${num(v.size)},`);
    w(`    height: ${num(v.line)} / ${num(v.size)},`);
    w(`    fontWeight: FontWeight.w${v.weight},`);
    w('  );');
  }
  w('}');
  w();

  w('/// Status badge style (`status.*`): icon name is a Lucide name, label is an i18n key.');
  w('class FlexiStatusStyle {');
  w(
    '  const FlexiStatusStyle({required this.labelKey, required this.icon, required this.bg, required this.fg});',
  );
  w('  final String labelKey;');
  w('  final String icon;');
  w('  final Color bg;');
  w('  final Color fg;');
  w('}');
  w();
  w('abstract final class FlexiStatus {');
  w('  static const Map<String, FlexiStatusStyle> all = {');
  for (const [k, s] of Object.entries(t.status)) {
    w(`    ${quote(k)}: FlexiStatusStyle(`);
    w(`      labelKey: ${quote(s.labelKey)},`);
    w(`      icon: ${quote(s.icon)},`);
    w(`      bg: FlexiColors.${camel(s.bg)},`);
    w(`      fg: FlexiColors.${camel(s.fg)},`);
    w('    ),');
  }
  w('  };');
  w('}');
  w();

  const T = 'FlexiTypeScale';
  const C = 'FlexiColors';
  w('/// Light theme built only from the tokens above.');
  w('abstract final class FlexiTheme {');
  w('  static ThemeData light() {');
  w('    const scheme = ColorScheme.light(');
  w(`      primary: ${C}.navy,`);
  w(`      onPrimary: ${C}.onNavy,`);
  w(`      secondary: ${C}.emerald,`);
  w(`      onSecondary: ${C}.onEmerald,`);
  w(`      error: ${C}.danger,`);
  w(`      onError: ${C}.onDanger,`);
  w(`      surface: ${C}.surface,`);
  w(`      onSurface: ${C}.text,`);
  w(`      onSurfaceVariant: ${C}.textMuted,`);
  w(`      outline: ${C}.borderStrong,`);
  w(`      outlineVariant: ${C}.border,`);
  w(`      scrim: ${C}.overlay,`);
  w('    );');
  w('    const textTheme = TextTheme(');
  w(`      displayMedium: ${T}.amountXl,`);
  w(`      displaySmall: ${T}.amount,`);
  w(`      headlineMedium: ${T}.headline,`);
  w(`      titleLarge: ${T}.title,`);
  w(`      titleMedium: ${T}.titleSm,`);
  w(`      bodyLarge: ${T}.bodyLg,`);
  w(`      bodyMedium: ${T}.body,`);
  w(`      bodySmall: ${T}.caption,`);
  w(`      labelLarge: ${T}.label,`);
  w(`      labelMedium: ${T}.label,`);
  w(`      labelSmall: ${T}.micro,`);
  w('    );');
  w('    final inputRadius = BorderRadius.circular(FlexiRadius.input);');
  w('    OutlineInputBorder border(Color color, [double width = FlexiSize.borderWidth]) =>');
  w(
    '        OutlineInputBorder(borderRadius: inputRadius, borderSide: BorderSide(color: color, width: width));',
  );
  w('    return ThemeData(');
  w('      useMaterial3: true,');
  w('      colorScheme: scheme,');
  w(`      scaffoldBackgroundColor: ${C}.bg,`);
  w('      fontFamily: FlexiFont.family,');
  w('      fontFamilyFallback: FlexiFont.familyFallback,');
  w(`      textTheme: textTheme.apply(bodyColor: ${C}.text, displayColor: ${C}.text),`);
  w('      appBarTheme: const AppBarTheme(');
  w(`        backgroundColor: ${C}.navy,`);
  w(`        foregroundColor: ${C}.onNavy,`);
  w('        elevation: 0,');
  w('        toolbarHeight: FlexiSize.headerHeight,');
  w('      ),');
  w('      cardTheme: CardThemeData(');
  w(`        color: ${C}.surface,`);
  w('        elevation: 0,');
  w(
    `        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FlexiRadius.cardMobile)),`,
  );
  w('      ),');
  w('      elevatedButtonTheme: ElevatedButtonThemeData(');
  w('        style: ElevatedButton.styleFrom(');
  w(`          backgroundColor: ${C}.navy,`);
  w(`          foregroundColor: ${C}.onNavy,`);
  w('          minimumSize: const Size(FlexiSize.touchTargetMobile, FlexiSize.touchTargetMobile),');
  w('          textStyle: FlexiTypeScale.label,');
  w(
    '          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FlexiRadius.button)),',
  );
  w('        ),');
  w('      ),');
  w('      inputDecorationTheme: InputDecorationTheme(');
  w('        filled: true,');
  w(`        fillColor: ${C}.surface,`);
  w(`        border: border(${C}.borderStrong),`);
  w(`        enabledBorder: border(${C}.borderStrong),`);
  w(`        focusedBorder: border(${C}.navy, FlexiSize.focusWidth),`);
  w(`        errorBorder: border(${C}.danger),`);
  w(`        focusedErrorBorder: border(${C}.danger, FlexiSize.focusWidth),`);
  w('      ),');
  w('      dividerTheme: const DividerThemeData(');
  w(`        color: ${C}.border,`);
  w('        thickness: FlexiSize.borderWidth,');
  w('      ),');
  w('    );');
  w('  }');
  w('}');

  return out.join('\n') + '\n';
}
