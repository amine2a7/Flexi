'use client';

import { Languages } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { Link, usePathname } from '@/i18n/navigation';
import { routing } from '@/i18n/routing';
import { cn } from '@/lib/cn';

/** Language links (endonyms, each announced in its own language). Keyboard friendly, targets >= 44 px. */
export function LocaleSwitcher() {
  const t = useTranslations();
  const current = useLocale();
  const pathname = usePathname();

  return (
    <nav aria-label={t('nav.language')} className="flex items-center gap-2">
      <Languages aria-hidden="true" className="hidden size-icon-md text-text-muted sm:block" />
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
                  'inline-flex min-h-touch-target-min min-w-touch-target-min items-center justify-center rounded-button px-2 text-label transition-colors duration-fast sm:px-3',
                  isCurrent ? 'bg-navy font-title text-on-navy' : 'text-navy hover:bg-border',
                )}
              >
                <span className="hidden sm:inline">{t(`language.${locale}`)}</span>
                {/* Short code on phones; the full endonym stays the accessible name. */}
                <span className="sm:hidden" aria-hidden="true">
                  {t(`language.short.${locale}`)}
                </span>
                <span className="sr-only sm:hidden">{t(`language.${locale}`)}</span>
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
