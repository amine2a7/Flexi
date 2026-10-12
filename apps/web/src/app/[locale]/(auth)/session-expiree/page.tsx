import { useTranslations } from 'next-intl';
import { AuthCard } from '@/components/auth/auth-shell';
import { buttonClasses } from '@/components/ui/button';
import { Link } from '@/i18n/navigation';

export default function SessionExpiredPage() {
  const t = useTranslations('auth.sessionExpired');
  return (
    <AuthCard title={t('title')} description={t('message')}>
      <Link href="/login" className={buttonClasses('primary')}>
        {t('action')}
      </Link>
    </AuthCard>
  );
}
