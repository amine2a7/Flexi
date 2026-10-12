import { defineRouting } from 'next-intl/routing';

export const routing = defineRouting({
  locales: ['fr', 'ar', 'en'],
  defaultLocale: 'fr',
  // The locale is always in the URL (/fr, /ar, /en): bookmarkable, no hidden state.
  localePrefix: 'always',
  // Only non-sensitive cookie of the web app (remembers the language). Auth cookies are set by the API.
  localeCookie: {
    maxAge: 60 * 60 * 24 * 365,
    sameSite: 'strict',
    secure: process.env.NODE_ENV === 'production',
  },
});

export type Locale = (typeof routing.locales)[number];
