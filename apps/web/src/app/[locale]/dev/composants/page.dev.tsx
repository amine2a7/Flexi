import type { Metadata } from 'next';
import { ComponentLibrary } from '@/components/dev/component-library';

// Development only: the `.dev.tsx` extension is a page for `next dev` alone (next.config.ts), so
// the route answers 404 in a build and its code is never bundled (dev-composants.md §2).
export const metadata: Metadata = { robots: { index: false, follow: false } };

export default function ComponentLibraryPage() {
  return <ComponentLibrary />;
}
