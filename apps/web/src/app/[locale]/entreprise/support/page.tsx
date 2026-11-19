'use client';

import { SupportPage } from '@/components/account/support-page';

/** Support (W-SUP): the tickets of the user and the help topics. */
export default function SpaceSupportPage() {
  return <SupportPage role="COMPANY" base="/entreprise/support" />;
}
