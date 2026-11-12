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
    'hidden min-h-touch-target-min items-center rounded-button px-3 text-label text-on-navy-muted hover:text-on-navy md:inline-flex';
  return (
    <div className="flex min-h-screen flex-col bg-bg">
      <SkipLink />
      <header className="bg-navy">
        <div className="mx-auto flex w-full max-w-desktop-max-width flex-wrap items-center justify-between gap-3 px-6 py-4">
          <Link href="/" className="flex items-center gap-2 rounded-button">
            <span
              aria-hidden="true"
              className="flex size-avatar-md items-center justify-center rounded-button bg-emerald text-on-emerald"
            >
              <Zap className="size-icon-md" />
            </span>
            <span className="text-title-sm text-on-navy">{tApp('name')}</span>
          </Link>
          <nav aria-label={t('nav.label')} className="flex items-center gap-1">
            <Link href="/#histoire" className={anchor}>
              {t('nav.how')}
            </Link>
            <Link href="/#pour-qui" className={anchor}>
              {t('nav.forWho')}
            </Link>
            <Link href="/#contact" className={anchor}>
              {t('nav.contact')}
            </Link>
          </nav>
          <div className="flex items-center gap-2">
            <div className="rounded-button bg-surface px-2">
              <LocaleSwitcher />
            </div>
            <Link href="/login" className={buttonClasses('success', 'sm', 'font-title')}>
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
      <footer className="bg-navy">
        <div className="mx-auto flex w-full max-w-desktop-max-width flex-wrap justify-between gap-4 px-6 py-6 text-caption text-on-navy-muted">
          <p>{t('footer.short', { year: new Date().getFullYear() })}</p>
          <div className="flex flex-wrap gap-4">
            <Link href="/aide" className="text-on-navy underline-offset-4 hover:underline">
              {t('nav.help')}
            </Link>
            <Link href="/#contact" className="text-on-navy underline-offset-4 hover:underline">
              {t('nav.contact')}
            </Link>
            <Link href="/login" className="text-on-navy underline-offset-4 hover:underline">
              {t('nav.signIn')}
            </Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
