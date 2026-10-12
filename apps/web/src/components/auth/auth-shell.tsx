import { useTranslations } from 'next-intl';
import type { ReactNode } from 'react';
import { LocaleSwitcher } from '@/components/layout/locale-switcher';
import { SkipLink } from '@/components/layout/skip-link';

/** Frame of the Commun screens: brand, language choice and a centred card. */
export function AuthShell({ children }: { children: ReactNode }) {
  const t = useTranslations();
  return (
    <div className="flex min-h-screen flex-col bg-bg">
      <SkipLink />
      <header className="flex items-center justify-between gap-3 px-4 py-4 lg:px-8">
        <span className="text-title text-navy">{t('app.name')}</span>
        <LocaleSwitcher />
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
