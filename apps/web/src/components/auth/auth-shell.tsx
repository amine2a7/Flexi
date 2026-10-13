import { CircleHelp } from 'lucide-react';
import { useTranslations } from 'next-intl';
import type { ReactNode } from 'react';
import { Link } from '@/i18n/navigation';
import { LocaleSwitcher } from '@/components/layout/locale-switcher';
import { SkipLink } from '@/components/layout/skip-link';

/** Frame of the Commun screens: brand, language choice and a centred card. */
export function AuthShell({ children }: { children: ReactNode }) {
  const t = useTranslations();
  return (
    <div className="flex min-h-screen flex-col bg-bg">
      <SkipLink />
      <header className="flex items-center justify-between gap-3 px-4 py-4 lg:px-8">
        <Link href="/" className="rounded-button">
          <span className="text-title text-navy">{t('app.name')}</span>
        </Link>
        <div className="flex items-center gap-2">
          <Link
            href="/aide#compte"
            className="inline-flex min-h-touch-target-min items-center gap-2 rounded-button px-2 text-label text-text-muted hover:text-navy"
          >
            <CircleHelp aria-hidden="true" className="size-icon-md" />
            <span className="hidden sm:inline">{t('layout.help')}</span>
            <span className="sr-only sm:hidden">{t('layout.help')}</span>
          </Link>
          <LocaleSwitcher />
        </div>
      </header>
      <main
        id="main-content"
        tabIndex={-1}
        className="mx-auto flex w-full max-w-auth-card-max-width flex-1 flex-col justify-center px-4 pb-10"
      >
        {children}
      </main>
    </div>
  );
}

export function AuthCard({
  title,
  description,
  children,
}: {
  title: string;
  description?: string;
  children: ReactNode;
}) {
  return (
    <section className="flex flex-col gap-6 rounded-card-desktop bg-surface p-6 shadow-card lg:p-8">
      <div className="flex flex-col gap-2">
        <h1 className="text-headline text-text">{title}</h1>
        {description !== undefined ? (
          <p className="text-body text-text-muted">{description}</p>
        ) : null}
      </div>
      {children}
    </section>
  );
}
