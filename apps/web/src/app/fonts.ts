import { Barlow_Condensed, IBM_Plex_Mono, IBM_Plex_Sans_Arabic, Inter } from 'next/font/google';

// Self-hosted by Next at build time (no request to Google at runtime). Families mirror the tokens
// (font.family-sans: Inter, font.family-ar: IBM Plex Sans Arabic); see globals.css.
export const fontSans = Inter({ subsets: ['latin'], variable: '--font-sans', display: 'swap' });

export const fontArabic = IBM_Plex_Sans_Arabic({
  subsets: ['arabic'],
  weight: ['400', '500', '600', '700'],
  variable: '--font-ar',
  display: 'swap',
});

// Fonts of the "carnet de tickets" mockups (landing, sign-in): condensed titles, ticket numbers.
export const fontDisplay = Barlow_Condensed({
  subsets: ['latin'],
  weight: ['700'],
  variable: '--font-display',
  display: 'swap',
});

export const fontTicket = IBM_Plex_Mono({
  subsets: ['latin'],
  weight: ['400', '500'],
  variable: '--font-ticket',
  display: 'swap',
});
