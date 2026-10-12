import { useTranslations } from 'next-intl';
import { LocaleSwitcher } from '@/components/layout/locale-switcher';
import { SkipLink } from '@/components/layout/skip-link';

// Placeholder of the P0-F1 skeleton: replaced by the navigation shell (P0-F2).
export default function HomePage() {
  const t = useTranslations();
  return (
    <>
      <SkipLink />
      <header className="mx-auto flex w-full max-w-desktop-max-width items-center justify-between px-5 py-4 lg:px-8">
        <span className="text-title-sm text-navy">{t('app.name')}</span>
        <LocaleSwitcher />
      </header>
      <main
        id="main-content"
        tabIndex={-1}
        className="mx-auto w-full max-w-desktop-max-width px-5 py-8 lg:px-8"
      >
        <h1 className="text-headline text-text">{t('shell.placeholder.title')}</h1>
        <p className="mt-3 text-body-lg text-text-muted">{t('shell.placeholder.message')}</p>
      </main>
    </>
  );
}
