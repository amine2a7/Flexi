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
      <Languages aria-hidden="true" className="size-icon-md text-text-muted" />
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
                  'inline-flex min-h-touch-target-min min-w-touch-target-min items-center justify-center rounded-button px-3 text-label transition-colors duration-fast',
                  isCurrent ? 'bg-navy font-title text-on-navy' : 'text-navy hover:bg-border',
                )}
              >
                {t(`language.${locale}`)}
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
