'use client';

import { TeamPage } from '@/components/team/team-page';

/** Users of the company, managed by its owner (request of 2026-11-14). */
export default function CompanyUsersPage() {
  return <TeamPage tenant="COMPANY" />;
}
