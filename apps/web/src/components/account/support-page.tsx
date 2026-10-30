'use client';

import type { Schemas } from '@flexipay/api-client';
import { CircleHelp } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Link } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { ContactForm } from '@/components/public/contact-form';
import { HELP_ANCHORS, HELP_SECTIONS, type HelpSectionKey } from '@/components/public/help-topics';
import { Card, CardTitle } from '@/components/ui/card';
import { PageHeader } from '@/components/ui/layout-blocks';

/**
 * Support (commun-support.md), shared by the three spaces: the help topics of the role and of the
 * account, each linking to the help page, then the contact form (same channel as the home page).
 */
export function SupportPage({ role }: { role: Schemas['Role'] }) {
  const t = useTranslations('account.support');
  const tHelp = useTranslations();
  const keys: HelpSectionKey[] = [
    'account',
    ...(role in HELP_ANCHORS ? [role as HelpSectionKey] : []),
  ];
  const sections = HELP_SECTIONS.filter((section) => keys.includes(section.key));

  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardTitle description={t('helpHint')}>{t('help')}</CardTitle>
          <ul className="flex flex-col gap-2">
            {sections.flatMap((section) =>
              section.topics.map((topic) => (
                <li key={topic.key}>
                  <Link
                    href={`/aide#${HELP_ANCHORS[section.key]}`}
                    className="flex min-h-touch-target-min items-center gap-2 text-label text-navy underline-offset-2 hover:underline"
                  >
                    <CircleHelp aria-hidden="true" className="size-icon-sm shrink-0" />
                    {tHelp(messageKey(`help.topics.${topic.key}.title`))}
                  </Link>
                </li>
              )),
            )}
          </ul>
        </Card>
        <Card>
          <CardTitle description={t('contactHint')}>{t('contact')}</CardTitle>
          <ContactForm />
        </Card>
      </div>
    </>
  );
}
