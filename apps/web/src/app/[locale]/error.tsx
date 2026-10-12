'use client';

import { useTranslations } from 'next-intl';

interface ErrorPageProps {
  readonly reset: () => void;
}

// Render error boundary. Nothing is logged: error objects may carry sensitive data (CLAUDE.md rule 9).
export default function ErrorPage({ reset }: ErrorPageProps) {
  const t = useTranslations();
  return (
    <main
      id="main-content"
      className="mx-auto flex max-w-toast-max-width flex-col items-center gap-4 px-4 py-12 text-center"
    >
      <h1 className="text-title text-text">{t('common.state.error.title')}</h1>
      <p className="text-body-lg text-text-muted">{t('common.state.error.message')}</p>
      <button
        type="button"
        onClick={reset}
        className="inline-flex min-h-button-height items-center rounded-button bg-navy px-5 text-label text-on-navy"
      >
        {t('common.button.retry')}
      </button>
    </main>
  );
}
