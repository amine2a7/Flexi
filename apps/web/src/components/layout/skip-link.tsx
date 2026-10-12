import { useTranslations } from 'next-intl';

/** First focusable element of every page (navigation spec N.1): visible only when focused. */
export function SkipLink() {
  const t = useTranslations('nav');
  return (
    <a
      href="#main-content"
      className="sr-only rounded-button bg-navy px-5 py-3 text-label text-on-navy focus:not-sr-only focus:fixed focus:start-4 focus:top-4 focus:z-50"
    >
      {t('skip')}
    </a>
  );
}
