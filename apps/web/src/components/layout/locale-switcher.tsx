'use client';

import { Languages } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link, usePathname } from '@/i18n/navigation';
import { routing } from '@/i18n/routing';
import { cn } from '@/lib/cn';

/**
 * Language links (endonyms, each announced in its own language), as light pills: the current
 * language filled, the others discreet. `tone="dark"` on a navy band (home, sign-in): short codes
 * (FR · عربي · EN), no white box. Keyboard friendly, targets >= 44 px.
 */
export function LocaleSwitcher({ tone = 'light' }: { tone?: 'light' | 'dark' }) {
  const t = useTranslations();
  const current = useLocale();
  const pathname = usePathname();
  const dark = tone === 'dark';

  return (
    <nav aria-label={t('nav.language')} className="flex items-center gap-1">
      <Languages
        aria-hidden="true"
        className={cn(
          'hidden size-icon-sm md:block',
          dark ? 'text-on-navy-muted' : 'text-text-muted',
        )}
      />
      <ul className="flex items-center gap-1">
        {routing.locales.map((locale) => {
          const isCurrent = locale === current;
          return (
            <li key={locale}>
              <Link
                href={pathname}
                locale={locale}
                lang={locale}
                hrefLang={locale}
                aria-current={isCurrent ? 'true' : undefined}
                className={cn(
                  'inline-flex min-h-touch-target-min min-w-touch-target-min items-center justify-center rounded-badge px-3 text-label transition-colors duration-base ease-out',
                  dark
                    ? isCurrent
                      ? 'bg-on-navy font-title text-navy'
                      : 'text-on-navy-muted hover:bg-navy-deep hover:text-on-navy'
                    : isCurrent
                      ? 'bg-navy font-title text-on-navy'
                      : 'text-text-muted hover:bg-border hover:text-navy',
                )}
              >
                {/* Short code (always on a navy band, on phones elsewhere); the endonym stays
                    the accessible name. */}
                <span className={dark ? undefined : 'sm:hidden'} aria-hidden="true">
                  {t(`language.short.${locale}`)}
                </span>
                <span className={dark ? 'sr-only' : 'sr-only sm:not-sr-only'}>
                  {t(`language.${locale}`)}
                </span>
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
