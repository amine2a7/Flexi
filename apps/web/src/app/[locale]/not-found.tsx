import { SearchX } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { AuthShell } from '@/components/auth/auth-shell';
import { buttonClasses } from '@/components/ui/button';

/** 404 (commun-erreurs.md): same frame as the other Commun screens, a way home and to sign in. */
export default function NotFound() {
  const t = useTranslations();
  return (
    <AuthShell>
      <div className="flex flex-col items-center gap-4 rounded-card-desktop bg-surface p-6 text-center shadow-card">
        <SearchX aria-hidden="true" className="size-icon-lg text-text-muted" />
        <h1 className="text-headline text-text">{t('common.state.notFound.title')}</h1>
        <p className="text-body-lg text-text-muted">{t('errors.notFound')}</p>
        <div className="flex flex-wrap justify-center gap-3">
          <Link href="/" className={buttonClasses('primary')}>
            {t('common.state.notFound.action')}
          </Link>
          <Link href="/login" className={buttonClasses('secondary')}>
            {t('auth.login.submit')}
          </Link>
        </div>
      </div>
    </AuthShell>
  );
}
