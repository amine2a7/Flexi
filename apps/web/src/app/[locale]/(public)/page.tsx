import { getLocale, getTranslations } from 'next-intl/server';
import { Link } from '@/i18n/navigation';
import { ContactForm } from '@/components/public/contact-form';
import { buttonClasses } from '@/components/ui/button';
import { Mascot } from '@/components/public/mascot';
import { TicketBook } from '@/components/public/ticket-book';
import { fetchPlatformTerms, termValues } from '@/lib/api/platform-terms';

const AUDIENCES = ['company', 'employee', 'merchant'] as const;

/**
 * Public home (maquette « Accueil · Le dernier carnet de tickets »): the story told by the ticket
 * book, the three ways to use it, and a contact ticket.
 */
export default async function LandingPage() {
  const t = await getTranslations('landing');
  const tContact = await getTranslations('contact.ticket');
  const terms = termValues(await fetchPlatformTerms(), await getLocale());
  const days = { days: terms.settlementDays };
  return (
    <>
      <section id="histoire" className="scroll-mt-4 bg-navy text-on-navy">
        <div className="mx-auto grid w-full max-w-desktop-max-width items-center gap-12 px-6 pb-12 pt-10 lg:grid-cols-2 lg:pb-12">
          <div className="fp-cascade flex min-w-0 flex-col gap-5">
            <p className="text-micro font-label uppercase tracking-widest text-emerald">
              {t('hero.eyebrow')}
            </p>
            <h1 className="font-display text-display-md leading-none text-balance lg:text-display">
              {t('hero.title')}
              <br />
              <span className="text-emerald">{t('hero.highlight')}</span>
            </h1>
            <p className="max-w-form-max-width text-body-lg text-on-navy-muted">{t('hero.text')}</p>
            <div className="flex flex-wrap gap-3">
              <Link href="/#contact" className={buttonClasses('success', 'md', 'font-title')}>
                {t('hero.company')}
              </Link>
              <Link
                href="/#contact"
                className={buttonClasses(
                  'ghost',
                  'md',
                  'border border-navy-line text-on-navy hover:bg-navy-deep',
                )}
              >
                {t('hero.merchant')}
              </Link>
            </div>
          </div>
          {/* Accueil carnet: the mascot peeks over the book, its top ticket stamped « Approuvé ». */}
          <div className="flex min-w-0 flex-col items-center">
            <Mascot mood="happy" className="relative z-10 -mb-6 animate-peek" />
            <div className="relative">
              <TicketBook settlementDays={terms.settlementDays} />
              <p
                aria-hidden="true"
                className="pointer-events-none absolute end-4 top-1/4 z-10 -rotate-12 rounded-button border-4 border-emerald-text bg-paper px-3 py-1 font-ticket text-title uppercase text-emerald-text animate-pop motion-reduce:animate-none"
              >
                {t('hero.stamp')}
              </p>
            </div>
          </div>
        </div>
      </section>

      <section id="pour-qui" className="scroll-mt-4 px-6 py-12">
        <div className="mx-auto flex w-full max-w-desktop-max-width flex-col gap-8">
          <div>
            <p className="text-micro font-label uppercase tracking-widest text-emerald-text">
              {t('forWho.eyebrow')}
            </p>
            <h2 className="mt-2 font-display text-display-md leading-none text-navy">
              {t('forWho.title')}
            </h2>
          </div>
          <ul className="grid gap-4 md:grid-cols-3">
            {AUDIENCES.map((key) => (
              <li
                key={key}
                className="flex flex-col gap-3 rounded-card-desktop border border-paper-border bg-paper p-6 transition duration-base ease-out hover:-translate-y-1 hover:-rotate-1 hover:shadow-raised motion-reduce:transition-none motion-reduce:hover:translate-y-0 motion-reduce:hover:rotate-0"
              >
                <p className="font-ticket text-micro uppercase text-paper-ink">
                  {t(`forWho.${key}.tag`)}
                </p>
                <h3 className="text-title text-text">{t(`forWho.${key}.title`)}</h3>
                <p className="text-body text-neutral-text">{t(`forWho.${key}.text`, days)}</p>
                <Link
                  href={key === 'employee' ? '/login' : '/#contact'}
                  className="mt-auto inline-flex min-h-touch-target-min items-center font-label text-emerald-text underline-offset-4 hover:text-navy hover:underline"
                >
                  {t(`forWho.${key}.cta`)}
                </Link>
              </li>
            ))}
          </ul>
        </div>
      </section>

      <section id="contact" className="scroll-mt-4 px-6 pb-12 pt-4">
        <div className="mx-auto grid w-full max-w-desktop-max-width items-start gap-10 lg:grid-cols-5">
          <div className="flex min-w-0 flex-col gap-3 lg:col-span-2">
            <p className="text-micro font-label uppercase tracking-widest text-emerald-text">
              {tContact('eyebrow')}
            </p>
            <h2 className="font-display text-display-md leading-none text-navy">
              {tContact('title')}
            </h2>
            <p className="max-w-form-max-width text-body text-neutral-text">{tContact('text')}</p>
          </div>
          <div className="min-w-0 lg:col-span-3">
            <ContactForm variant="ticket" />
          </div>
        </div>
      </section>
    </>
  );
}
