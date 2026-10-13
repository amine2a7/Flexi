import { Building2, Check, LogIn, Mail, Store, UserRound, type LucideIcon } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { ContactForm } from '@/components/public/contact-form';
import { buttonClasses } from '@/components/ui/button';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { CREDIT_TYPES } from '@/lib/credit-types';

const AUDIENCES: readonly { key: 'company' | 'merchant' | 'employee'; icon: LucideIcon }[] = [
  { key: 'company', icon: Building2 },
  { key: 'merchant', icon: Store },
  { key: 'employee', icon: UserRound },
];
const STEPS = ['s1', 's2', 's3'] as const;

/** Public home: presentation, credit types, benefits per audience, 3 steps, contact form. */
export default function LandingPage() {
  const t = useTranslations('landing');
  const tContact = useTranslations('contact');
  return (
    <>
      <section className="bg-navy text-on-navy">
        <div className="mx-auto flex w-full max-w-desktop-max-width flex-col gap-6 px-4 py-12 lg:px-8">
          <p className="text-micro uppercase tracking-widest text-emerald">{t('hero.eyebrow')}</p>
          <h1 className="max-w-form-max-width text-headline">{t('hero.title')}</h1>
          <p className="max-w-form-max-width text-body-lg text-on-navy-muted">{t('hero.text')}</p>
          <div className="flex flex-wrap gap-3">
            <Link href="/login" className={buttonClasses('success')}>
              <LogIn aria-hidden="true" className="size-icon-md rtl:rotate-180" />
              {t('hero.signIn')}
            </Link>
            <Link
              href="/#contact"
              className={buttonClasses('ghost', 'md', 'text-on-navy hover:bg-navy-deep')}
            >
              <Mail aria-hidden="true" className="size-icon-md" />
              {t('hero.contact')}
            </Link>
          </div>
        </div>
      </section>

      <section className="border-b border-border bg-surface">
        <div className="mx-auto flex w-full max-w-desktop-max-width flex-col gap-4 px-4 py-8 lg:flex-row lg:items-center lg:justify-between lg:px-8">
          <div className="flex flex-col gap-1">
            <h2 className="text-title-sm text-text">{t('types.title')}</h2>
            <p className="text-body text-text-muted">{t('types.text')}</p>
          </div>
          <ul className="flex flex-wrap gap-2">
            {CREDIT_TYPES.map((type) => (
              <li key={type}>
                <CreditTypeBadge type={type} />
              </li>
            ))}
          </ul>
        </div>
      </section>

      <section id="avantages" className="mx-auto w-full max-w-desktop-max-width px-4 py-12 lg:px-8">
        <h2 className="mb-6 text-title text-text">{t('benefits.title')}</h2>
        <ul className="grid gap-6 md:grid-cols-3">
          {AUDIENCES.map(({ key, icon: Icon }) => (
            <li
              key={key}
              className="flex flex-col gap-4 rounded-card-desktop bg-surface p-6 shadow-card"
            >
              <span
                aria-hidden="true"
                className="flex size-avatar-md items-center justify-center rounded-button bg-emerald-soft text-emerald-text"
              >
                <Icon className="size-icon-md" />
              </span>
              <h3 className="text-title-sm text-text">{t(`benefits.${key}.title`)}</h3>
              <ul className="flex flex-col gap-2">
                {(['p1', 'p2', 'p3'] as const).map((point) => (
                  <li key={point} className="flex gap-2 text-body text-text-muted">
                    <Check aria-hidden="true" className="size-icon-sm shrink-0 text-emerald-text" />
                    {t(`benefits.${key}.${point}`)}
                  </li>
                ))}
              </ul>
            </li>
          ))}
        </ul>
      </section>

      <section id="comment" className="bg-surface">
        <div className="mx-auto w-full max-w-desktop-max-width px-4 py-12 lg:px-8">
          <h2 className="mb-6 text-title text-text">{t('steps.title')}</h2>
          <ol className="grid gap-6 md:grid-cols-3">
            {STEPS.map((step, index) => (
              <li key={step} className="flex gap-4">
                <span
                  aria-hidden="true"
                  className="flex size-avatar-md shrink-0 items-center justify-center rounded-badge bg-navy text-title-sm text-on-navy"
                >
                  {index + 1}
                </span>
                <span className="flex flex-col gap-1">
                  <h3 className="text-title-sm text-text">{t(`steps.${step}.title`)}</h3>
                  <p className="text-body text-text-muted">{t(`steps.${step}.text`)}</p>
                </span>
              </li>
            ))}
          </ol>
        </div>
      </section>

      <section id="contact" className="mx-auto w-full max-w-desktop-max-width px-4 py-12 lg:px-8">
        <div className="grid gap-8 lg:grid-cols-3">
          <div className="flex flex-col gap-3">
            <h2 className="text-title text-text">{tContact('title')}</h2>
            <p className="text-body text-text-muted">{tContact('description')}</p>
            <p className="text-caption text-text-muted">{tContact('privacy')}</p>
          </div>
          <div className="lg:col-span-2">
            <ContactForm />
          </div>
        </div>
      </section>
    </>
  );
}
