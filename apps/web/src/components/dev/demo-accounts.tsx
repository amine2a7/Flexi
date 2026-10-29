'use client';

import { FlaskConical } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { DEMO_ACCOUNT_HINTS, DEMO_MFA_CODE } from '@/mocks/fixtures/accounts';

interface DemoAccountsProps {
  readonly onPick: (account: { identifier: string; password: string }) => void;
}

/** Development panel of /login: demo accounts of the mocked API (never in a production build). */
export function DemoAccounts({ onPick }: DemoAccountsProps) {
  const t = useTranslations('dev');
  return (
    <aside
      aria-labelledby="demo-accounts-title"
      className="flex flex-col gap-3 rounded-card-desktop border border-warning bg-warning-soft p-4 text-warning-text"
    >
      <p id="demo-accounts-title" className="flex items-center gap-2 text-label">
        <FlaskConical aria-hidden="true" className="size-icon-sm" />
        {t('accounts.title')}
      </p>
      <p className="text-caption">{t('accounts.hint', { code: DEMO_MFA_CODE })}</p>
      <ul className="flex flex-col gap-2">
        {DEMO_ACCOUNT_HINTS.map((account) => (
          <li key={account.identifier}>
            <button
              type="button"
              onClick={() => {
                onPick(account);
              }}
              className="flex w-full flex-col items-start rounded-button bg-surface px-3 py-2 text-start text-caption text-text hover:bg-bg"
            >
              <span className="font-title">{t(`accounts.${account.role}`)}</span>
              <span dir="ltr">{`${account.identifier} · ${account.password}`}</span>
            </button>
          </li>
        ))}
      </ul>
    </aside>
  );
}
