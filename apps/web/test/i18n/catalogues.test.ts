import { describe, expect, it } from 'vitest';
import { getDirection } from '@/i18n/direction';
import { loadMessages } from '@/i18n/messages';
import { routing, type Locale } from '@/i18n/routing';

function flatten(value: unknown, prefix = ''): Record<string, string> {
  if (typeof value === 'string') return { [prefix]: value };
  if (typeof value !== 'object' || value === null) throw new Error(`Invalid message at ${prefix}`);
  return Object.entries(value).reduce<Record<string, string>>(
    (acc, [key, child]) => ({
      ...acc,
      ...flatten(child, prefix === '' ? key : `${prefix}.${key}`),
    }),
    {},
  );
}

const placeholders = (text: string): string[] =>
  [...text.matchAll(/\{(\w+)/g)].map((match) => match[1] ?? '').sort();

const reference = flatten(loadMessages('fr'));
const others = routing.locales.filter((locale) => locale !== 'fr');

describe('message catalogues', () => {
  it('serves exactly the locales FR (default), AR and EN', () => {
    expect([...routing.locales]).toEqual(['fr', 'ar', 'en']);
    expect(routing.defaultLocale).toBe('fr');
  });

  it.each(others)('%s has exactly the same keys as the French reference', (locale) => {
    expect(Object.keys(flatten(loadMessages(locale))).sort()).toEqual(
      Object.keys(reference).sort(),
    );
  });

  it.each(routing.locales)('%s has no empty message', (locale) => {
    for (const [key, text] of Object.entries(flatten(loadMessages(locale)))) {
      expect(text.trim(), `${locale}:${key}`).not.toBe('');
    }
  });

  it.each(others)('%s uses the same interpolation variables as French', (locale) => {
    const translated = flatten(loadMessages(locale));
    for (const [key, text] of Object.entries(reference)) {
      expect(placeholders(translated[key] ?? ''), `${locale}:${key}`).toEqual(placeholders(text));
    }
  });

  it('writes every language name in its own language (endonyms)', () => {
    for (const locale of routing.locales) {
      const names = loadMessages(locale).language;
      expect(names).toEqual({ fr: 'Français', ar: 'العربية', en: 'English' });
    }
  });
});

describe('text direction', () => {
  it.each<[Locale, 'ltr' | 'rtl']>([
    ['fr', 'ltr'],
    ['en', 'ltr'],
    ['ar', 'rtl'],
  ])('%s is %s', (locale, expected) => {
    expect(getDirection(locale)).toBe(expected);
  });
});
