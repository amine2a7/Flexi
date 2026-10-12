'use client';

import { FlaskConical } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { DEMO_ACCOUNTS_MARKER } from '@/mocks/fixtures/accounts';

const CODES = [
  { code: '12345678', key: 'confirmed' },
  { code: '12340000', key: 'refused' },
  { code: '00000000', key: 'declined' },
  { code: '99999999', key: 'serverError' },
] as const;

/** Development panel of the collect screen: customer codes of the mocked API. */
export function DemoCodes() {
  const t = useTranslations('dev.codes');
  return (
    <aside
      data-marker={DEMO_ACCOUNTS_MARKER}
      className="flex flex-col gap-2 rounded-card-desktop border border-warning bg-warning-soft p-4 text-warning-text"
    >
      <p className="flex items-center gap-2 text-label">
        <FlaskConical aria-hidden="true" className="size-icon-sm" />
        {t('title')}
      </p>
      <ul className="flex flex-col gap-1 text-caption">
        {CODES.map((item) => (
          <li key={item.code} className="flex gap-2">
            <span className="font-title tabular-nums" dir="ltr">
              {item.code}
            </span>
            <span>{t(item.key)}</span>
          </li>
        ))}
      </ul>
      <p className="text-caption">{t('scenarios')}</p>
    </aside>
  );
}
