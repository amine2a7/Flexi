import { Ticket } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Suspense } from 'react';
import { LoginForm } from '@/components/auth/login-form';

/** Sign-in as a "ticket" (docs/design/carnet-tickets): navy stub, perforation, then the form. */
export default function LoginPage() {
  const t = useTranslations('auth.ticket');
  return (
    <div className="flex flex-col">
      <div className="flex flex-col gap-2 rounded-t-card-desktop border-b-2 border-dashed border-on-navy-muted bg-navy p-6 text-on-navy">
        <p className="flex items-center gap-2 text-micro uppercase tracking-widest text-emerald">
          <Ticket aria-hidden="true" className="size-icon-sm" />
          {t('label')}
        </p>
        <p className="text-title">
          {t('title')} <span className="text-emerald">{t('highlight')}</span>
        </p>
        <p className="text-caption text-on-navy-muted">{t('text')}</p>
      </div>
      <div className="[&>section]:rounded-t-none">
        <Suspense>
          <LoginForm />
        </Suspense>
      </div>
    </div>
  );
}
