import { Building2, Store, UserRound, type LucideIcon } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { ContactForm } from '@/components/public/contact-form';
import { buttonClasses } from '@/components/ui/button';
import { TicketBook } from '@/components/public/ticket-book';
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
        <div className="mx-auto grid w-full max-w-desktop-max-width gap-12 px-4 py-12 lg:grid-cols-2 lg:items-center lg:px-8 lg:py-16">
          <div className="flex flex-col gap-6">
            <p className="text-micro font-label uppercase tracking-widest text-emerald">
              {t('hero.eyebrow')}
            </p>
            <h1 className="font-display text-display-md lg:text-display">
              {t('hero.title')} <span className="text-emerald">{t('hero.highlight')}</span>
            </h1>
            <p className="max-w-form-max-width text-body-lg text-on-navy-muted">{t('hero.text')}</p>
            <div className="flex flex-wrap gap-3">
              <Link href="/#contact" className={buttonClasses('success')}>
                {t('hero.company')}
              </Link>
              <Link
                href="/#contact"
                className={buttonClasses(
                  'ghost',
                  'md',
                  'border border-on-navy-muted text-on-navy hover:bg-navy-deep',
                )}
              >
                {t('hero.merchant')}
              </Link>
            </div>
          </div>
          <TicketBook />
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

      <section
        id="avantages"
        className="mx-auto w-full max-w-desktop-max-width px-4 py-12 lg:px-8 lg:py-16"
      >
        <p className="mb-2 text-micro font-label uppercase tracking-widest text-emerald-text">
          {t('forWho.eyebrow')}
        </p>
        <h2 className="mb-8 font-display text-display-md text-navy">{t('forWho.title')}</h2>
        <ul className="grid gap-6 md:grid-cols-3">
          {AUDIENCES.map(({ key, icon: Icon }) => (
            <li
              key={key}
              className="flex flex-col rounded-card-desktop border border-paper-line bg-paper text-navy shadow-card"
            >
              <div className="flex items-center justify-between gap-3 border-b-2 border-dashed border-paper-line px-6 py-4">
                <p className="font-ticket text-micro uppercase text-paper-ink">
                  {t(`forWho.${key}.tag`)}
                </p>
                <Icon aria-hidden="true" className="size-icon-md text-emerald-text" />
              </div>
              <div className="flex flex-1 flex-col gap-3 p-6">
                <h3 className="font-display text-display-md">{t(`forWho.${key}.title`)}</h3>
                <p className="text-body text-paper-ink">{t(`forWho.${key}.text`)}</p>
                <Link
                  href={key === 'employee' ? '/login' : '/#contact'}
                  className="mt-auto inline-flex min-h-touch-target-min items-center text-label text-emerald-text underline-offset-4 hover:underline"
                >
                  {t(`forWho.${key}.cta`)}
                </Link>
              </div>
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
