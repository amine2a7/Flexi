import { LogIn, Zap } from 'lucide-react';
import { useTranslations } from 'next-intl';
import type { ReactNode } from 'react';
import { Link } from '@/i18n/navigation';
import { buttonClasses } from '@/components/ui/button';
import { LocaleSwitcher } from '@/components/layout/locale-switcher';
import { SkipLink } from '@/components/layout/skip-link';

/** Frame of the public pages (home, help): brand, anchors, language, sign-in, footer. */
export function PublicShell({ children }: { children: ReactNode }) {
  const t = useTranslations('landing');
  const tApp = useTranslations('app');
  const anchor =
    'hidden min-h-touch-target-min items-center rounded-button px-3 text-label text-text-muted hover:text-navy md:inline-flex';
  return (
    <div className="flex min-h-screen flex-col bg-bg">
      <SkipLink />
      <header className="border-b border-border bg-surface">
        <div className="mx-auto flex w-full max-w-desktop-max-width items-center justify-between gap-3 px-4 py-2 lg:px-8">
          <Link href="/" className="flex items-center gap-2 rounded-button">
            <span
              aria-hidden="true"
              className="flex size-avatar-md items-center justify-center rounded-button bg-emerald text-on-emerald"
            >
              <Zap className="size-icon-md" />
            </span>
            <span className="text-title-sm text-navy">{tApp('name')}</span>
          </Link>
          <nav aria-label={t('nav.label')} className="flex items-center gap-1">
            <Link href="/#comment" className={anchor}>
              {t('nav.how')}
            </Link>
            <Link href="/#avantages" className={anchor}>
              {t('nav.benefits')}
            </Link>
            <Link href="/#contact" className={anchor}>
              {t('nav.contact')}
            </Link>
            <Link href="/aide" className={anchor}>
              {t('nav.help')}
            </Link>
          </nav>
          <div className="flex items-center gap-2">
            <LocaleSwitcher />
            <Link href="/login" className={buttonClasses('primary', 'sm')}>
              <LogIn aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
              <span className="hidden sm:inline">{t('nav.signIn')}</span>
              <span className="sr-only sm:hidden">{t('nav.signIn')}</span>
            </Link>
          </div>
        </div>
      </header>
      <main id="main-content" tabIndex={-1} className="fp-cascade flex-1">
        {children}
      </main>
      <footer className="border-t border-border bg-surface">
        <div className="mx-auto flex w-full max-w-desktop-max-width flex-col gap-3 px-4 py-6 text-caption text-text-muted md:flex-row md:items-center md:justify-between lg:px-8">
          <p>{t('footer.rights', { year: new Date().getFullYear() })}</p>
          <p>{t('footer.country')}</p>
          <div className="flex gap-4">
            <Link href="/aide" className="underline">
              {t('nav.help')}
            </Link>
            <Link href="/#contact" className="underline">
              {t('nav.contact')}
            </Link>
            <Link href="/login" className="underline">
              {t('nav.signIn')}
            </Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
