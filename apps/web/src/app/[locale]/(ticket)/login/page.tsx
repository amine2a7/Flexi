import { UtensilsCrossed, Zap } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Suspense } from 'react';
import { Link } from '@/i18n/navigation';
import { LoginForm } from '@/components/auth/login-form';
import { LocaleSwitcher } from '@/components/layout/locale-switcher';
import { SkipLink } from '@/components/layout/skip-link';
import { Barcode } from '@/components/public/ticket-book';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { CREDIT_TYPES } from '@/lib/credit-types';

/**
 * Sign-in as a "ticket" (docs/design/carnet-tickets/connexion-web): navy side panel, then the
 * ticket (navy stub, perforation, paper body holding the unchanged sign-in form, barcode).
 */
export default function LoginPage() {
  const t = useTranslations('auth.ticket');
  const tApp = useTranslations('app');
  return (
    <div className="flex min-h-screen flex-col bg-bg lg:flex-row">
      <SkipLink />
      <aside className="flex flex-col justify-between gap-8 bg-navy lg:sticky lg:top-0 lg:h-screen px-6 py-8 text-on-navy lg:w-sidebar-width lg:shrink-0 lg:px-10 lg:py-12 xl:w-auto xl:max-w-form-max-width xl:basis-1/3">
        <div className="flex items-center justify-between gap-3">
          <Link href="/" className="flex items-center gap-2 rounded-button">
            <span
              aria-hidden="true"
              className="flex size-avatar-md items-center justify-center rounded-button bg-emerald text-on-emerald"
            >
              <Zap className="size-icon-md" />
            </span>
            <span className="text-title-sm text-on-navy">{tApp('name')}</span>
          </Link>
          <LocaleSwitcher tone="dark" />
        </div>
        <div className="flex flex-col gap-4">
          <p className="font-display text-display-md lg:text-display">
            {t('title')} <span className="text-emerald">{t('highlight')}</span>
          </p>
          <p className="text-body-lg text-on-navy-muted">{t('lead')}</p>
          <ul className="flex flex-wrap gap-2">
            {CREDIT_TYPES.map((type) => (
              <li key={type}>
                <CreditTypeBadge type={type} />
              </li>
            ))}
          </ul>
        </div>
        <div className="hidden flex-col gap-1 border-t border-navy-deep pt-4 lg:flex">
          <p className="text-micro font-label uppercase tracking-widest text-emerald">
            {t('factTitle')}
          </p>
          <p className="text-body text-on-navy">{t('fact')}</p>
        </div>
      </aside>
      <main
        id="main-content"
        tabIndex={-1}
        className="flex flex-1 items-center justify-center px-4 py-12"
      >
        {/* The ticket is printed (connexion-web), then its badge peeks out above the stub. */}
        <div className="flex w-full max-w-auth-card-max-width flex-col items-center">
          <span
            aria-hidden="true"
            className="relative z-10 -mb-4 flex size-avatar-lg animate-peek items-center justify-center rounded-badge border-4 border-navy bg-paper text-navy"
          >
            <UtensilsCrossed className="size-icon-md" />
          </span>
          <div className="w-full animate-print overflow-hidden rounded-card-desktop bg-paper shadow-card">
            <div className="flex items-end justify-between gap-3 bg-navy px-6 pb-4 pt-6 text-on-navy">
              <div className="flex flex-col gap-1">
                <p className="font-display text-title uppercase">{t('label')}</p>
                <p className="text-caption text-on-navy-muted">{t('value')}</p>
              </div>
              <div className="flex flex-col items-end gap-1 text-end">
                <p className="font-ticket text-micro text-on-navy-muted">
                  {t('serial', { serial: '000 482 915' })}
                </p>
                <p className="text-caption text-on-navy-muted">{t('today')}</p>
              </div>
            </div>
            <div className="border-t-2 border-dashed border-paper-line [&>section]:rounded-none [&>section]:bg-paper [&>section]:shadow-none">
              <Suspense>
                <LoginForm />
              </Suspense>
            </div>
            <div className="flex items-center justify-between gap-3 border-t border-dashed border-paper-line px-6 py-4">
              <Barcode />
              <p className="text-end font-ticket text-micro text-paper-ink">{t('text')}</p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
