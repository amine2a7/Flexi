import { IBM_Plex_Sans_Arabic, Inter } from 'next/font/google';

// Self-hosted by Next at build time (no request to Google at runtime). Families mirror the tokens
// (font.family-sans: Inter, font.family-ar: IBM Plex Sans Arabic); see globals.css.
export const fontSans = Inter({ subsets: ['latin'], variable: '--font-sans', display: 'swap' });

export const fontArabic = IBM_Plex_Sans_Arabic({
  subsets: ['arabic'],
  weight: ['400', '500', '600', '700'],
  variable: '--font-ar',
  display: 'swap',
});
