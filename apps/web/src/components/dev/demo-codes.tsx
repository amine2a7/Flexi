'use client';

import { FlaskConical } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { DEV_PANEL_MARKER } from './demo-accounts-data';

/** Development panel of the collect screen: how to get a customer code from the demo beneficiary. */
export function DemoCodes() {
  const t = useTranslations('dev.codes');
  return (
    <aside
      data-marker={DEV_PANEL_MARKER}
      className="flex flex-col gap-2 rounded-card-desktop border border-warning bg-warning-soft p-4 text-warning-text"
    >
      <p className="flex items-center gap-2 text-label">
        <FlaskConical aria-hidden="true" className="size-icon-sm" />
        {t('realTitle')}
      </p>
      <p className="text-caption">{t('realSteps')}</p>
    </aside>
  );
}
