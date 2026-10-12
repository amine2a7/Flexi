import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';

export default function NotFound() {
  const t = useTranslations();
  return (
    <main
      id="main-content"
      className="mx-auto flex max-w-toast-max-width flex-col items-center gap-4 px-4 py-12 text-center"
    >
      <h1 className="text-title text-text">{t('common.state.notFound.title')}</h1>
      <p className="text-body-lg text-text-muted">{t('errors.notFound')}</p>
      <Link
        href="/"
        className="inline-flex min-h-button-height items-center rounded-button bg-navy px-5 text-label text-on-navy"
      >
        {t('common.state.notFound.action')}
      </Link>
    </main>
  );
}
