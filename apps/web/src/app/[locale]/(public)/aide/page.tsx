import { LifeBuoy } from 'lucide-react';
import Image from 'next/image';
import { getLocale, getTranslations } from 'next-intl/server';
import { Link } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { fetchPlatformTerms, termValues } from '@/lib/api/platform-terms';
import { cn } from '@/lib/cn';
import { HELP_ANCHORS, HELP_SECTIONS } from '@/components/public/help-topics';

/** Help centre, public and reachable from every space (/aide#<space>). */
export default async function HelpPage() {
  const t = await getTranslations('help');
  const tRoot = await getTranslations();
  const terms = termValues(await fetchPlatformTerms(), (await getLocale()));
  const values = {
    days: terms.invitationDays,
    settlementDays: terms.settlementDays,
    threshold: terms.threshold,
  };
  return (
    <div className="mx-auto flex w-full max-w-desktop-max-width flex-col gap-8 px-4 py-8 lg:flex-row lg:px-8">
      <nav aria-label={t('toc')} className="lg:sticky lg:top-12 lg:w-sidebar-width lg:self-start">
        <p className="mb-3 text-micro uppercase tracking-widest text-text-muted">{t('toc')}</p>
        <ol className="flex flex-col gap-1">
          {HELP_SECTIONS.map((section) => (
            <li key={section.key}>
              <a
                href={`#${HELP_ANCHORS[section.key]}`}
                className="flex min-h-touch-target-min items-center rounded-button px-3 text-label text-text hover:bg-surface"
              >
                {t(`sections.${section.key}`)}
              </a>
            </li>
          ))}
        </ol>
      </nav>

      <div className="flex min-w-0 flex-1 flex-col gap-10">
        <header className="flex flex-col gap-2">
          <h1 className="text-headline text-text">{t('title')}</h1>
          <p className="text-body-lg text-text-muted">{t('description')}</p>
          <p className="text-caption text-text-muted">{t('captureNote')}</p>
        </header>

        {HELP_SECTIONS.map((section) => (
          <section
            key={section.key}
            id={HELP_ANCHORS[section.key]}
            aria-labelledby={`${HELP_ANCHORS[section.key]}-title`}
            className="flex scroll-mt-12 flex-col gap-6"
          >
            <h2 id={`${HELP_ANCHORS[section.key]}-title`} className="text-title text-text">
              {t(`sections.${section.key}`)}
            </h2>
            {section.topics.map((topic) => {
              const title = tRoot(messageKey(`help.topics.${topic.key}.title`));
              return (
                <article
                  key={topic.key}
                  id={topic.key}
                  className={cn(
                    'grid scroll-mt-12 gap-4 rounded-card-desktop bg-surface p-6 shadow-card',
                    topic.capture !== undefined && 'lg:grid-cols-2',
                  )}
                >
                  <div className="flex flex-col gap-2">
                    <h3 className="text-title-sm text-text">{title}</h3>
                    <p className="text-body text-text-muted">
                      {tRoot(messageKey(`help.topics.${topic.key}.text`), values)}
                    </p>
                  </div>
                  {topic.capture !== undefined ? (
                    <Image
                      src={topic.capture}
                      alt={t('capture', { title })}
                      sizes="(min-width: 1024px) 40vw, 100vw"
                      className={cn(
                        'h-auto rounded-button border border-border',
                        topic.mobile === true ? 'mx-auto w-1/2' : 'w-full',
                      )}
                    />
                  ) : null}
                </article>
              );
            })}
          </section>
        ))}

        <aside className="flex items-start gap-3 rounded-card-desktop bg-info-soft p-6 text-info-text">
          <LifeBuoy aria-hidden="true" className="size-icon-md shrink-0" />
          <div className="flex flex-col gap-1">
            <h2 className="text-title-sm">{t('stillStuck')}</h2>
            <p className="text-body">
              {t('stillStuckText')}{' '}
              <Link href="/#contact" className="underline">
                {tRoot('landing.nav.contact')}
              </Link>
            </p>
          </div>
        </aside>
      </div>
    </div>
  );
}
