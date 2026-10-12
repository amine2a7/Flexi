'use client';

import type { ReactNode } from 'react';
import { SpaceLayout } from '@/components/layout/space-layout';

export default function Layout({ children }: { children: ReactNode }) {
  return <SpaceLayout role="COMPANY">{children}</SpaceLayout>;
}
