import type { Metadata } from 'next';
import { hasLocale, NextIntlClientProvider } from 'next-intl';
import { getTranslations } from 'next-intl/server';
import { notFound } from 'next/navigation';
import { connection } from 'next/server';
import type { ReactNode } from 'react';
import { getDirection } from '@/i18n/direction';
import { routing } from '@/i18n/routing';
import { StyleNonce } from '@/components/layout/style-nonce';
import { cn } from '@/lib/cn';
import { fontArabic, fontDisplay, fontSans, fontTicket } from '../fonts';
import '../globals.css';

interface LocaleLayoutProps {
  readonly children: ReactNode;
  readonly params: Promise<{ locale: string }>;
}

export async function generateMetadata({
  params,
}: Pick<LocaleLayoutProps, 'params'>): Promise<Metadata> {
  const { locale } = await params;
  if (!hasLocale(routing.locales, locale)) return {};
  const t = await getTranslations({ locale, namespace: 'app' });
  return { title: t('name') };
}

export default async function LocaleLayout({ children, params }: LocaleLayoutProps) {
  const { locale } = await params;
  if (!hasLocale(routing.locales, locale)) notFound();
  // Pages are rendered per request: the CSP nonce (proxy) must reach the inline scripts of Next.
  await connection();

  return (
    <html
      lang={locale}
      dir={getDirection(locale)}
      className={cn(
        fontSans.variable,
        fontArabic.variable,
        fontDisplay.variable,
        fontTicket.variable,
      )}
    >
      <body>
        <StyleNonce />
        <NextIntlClientProvider>{children}</NextIntlClientProvider>
      </body>
    </html>
  );
}
