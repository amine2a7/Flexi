// Runtime-checked view of the groups of @flexipay/ui-tokens that Tailwind has no built-in key for.
// The generated typings are deliberately loose (`Record<string, unknown>`): a renamed or removed
// token must fail loudly here instead of producing `undefinedpx` in the CSS.

export interface FocusTokens {
  readonly width: number;
  readonly offset: number;
  readonly onLight: string;
  readonly onDark: string;
}

export interface TokenTheme {
  readonly size: Readonly<Record<string, string>>;
  readonly motion: Readonly<Record<string, number>>;
  readonly focus: FocusTokens;
  readonly colors: Readonly<Record<string, unknown>>;
}

function fail(path: string, expected: string): never {
  throw new Error(`Design token ${path} is missing or invalid (expected ${expected})`);
}

function record(value: unknown, path: string): Record<string, unknown> {
  if (typeof value !== 'object' || value === null || Array.isArray(value)) fail(path, 'an object');
  return value as Record<string, unknown>;
}

function stringAt(source: Record<string, unknown>, key: string, path: string): string {
  const value = source[key];
  return typeof value === 'string' && value !== '' ? value : fail(`${path}.${key}`, 'a string');
}

function numberAt(source: Record<string, unknown>, key: string, path: string): number {
  const value = source[key];
  return typeof value === 'number' && Number.isFinite(value)
    ? value
    : fail(`${path}.${key}`, 'a finite number');
}

function mapOf<T>(
  value: unknown,
  path: string,
  check: (entry: unknown, entryPath: string) => T,
): Record<string, T> {
  return Object.fromEntries(
    Object.entries(record(value, path)).map(([key, entry]) => [
      key,
      check(entry, `${path}.${key}`),
    ]),
  );
}

/** Validates the `theme` object of the generated Tailwind preset. Throws on any missing token. */
export function readTokens(theme: Record<string, unknown>): TokenTheme {
  const focus = record(theme.focus, 'focus');
  const colors = record(theme.colors, 'colors');
  const tokens: TokenTheme = {
    size: mapOf(theme.size, 'size', (entry, path) =>
      typeof entry === 'string' ? entry : fail(path, 'a CSS length string'),
    ),
    motion: mapOf(theme.motion, 'motion', (entry, path) =>
      typeof entry === 'number' ? entry : fail(path, 'a number of milliseconds'),
    ),
    focus: {
      width: numberAt(focus, 'width', 'focus'),
      offset: numberAt(focus, 'offset', 'focus'),
      onLight: stringAt(focus, 'color-on-light', 'focus'),
      onDark: stringAt(focus, 'color-on-dark', 'focus'),
    },
    colors,
  };
  // The focus ring colours name colour tokens: they must exist.
  for (const name of [tokens.focus.onLight, tokens.focus.onDark]) stringAt(colors, name, 'colors');
  // Tokens referenced by name elsewhere in this app.
  if (tokens.motion.skeleton === undefined) fail('motion.skeleton', 'a number of milliseconds');
  return tokens;
}

/** Colour token by name (flat string colours only). */
export function colorToken(tokens: TokenTheme, name: string): string {
  return stringAt(tokens.colors, name, 'colors');
}
