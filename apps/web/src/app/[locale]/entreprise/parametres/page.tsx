'use client';

import { AccountSettings } from '@/components/account/account-settings';
import { FamilyAccountsCard } from '@/components/account/family-accounts-card';

export default function AccountSettingsPage() {
  return (
    <>
      <AccountSettings />
      <FamilyAccountsCard />
    </>
  );
}
