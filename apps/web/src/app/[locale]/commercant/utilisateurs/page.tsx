'use client';

import { TeamPage } from '@/components/team/team-page';

/** Cashiers of the merchant, managed by its owner (request of 2026-11-14). */
export default function MerchantUsersPage() {
  return <TeamPage tenant="MERCHANT" />;
}
