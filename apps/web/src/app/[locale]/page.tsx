import { redirect } from '@/i18n/navigation';
import type { Locale } from '@/i18n/routing';

interface HomeProps {
  readonly params: Promise<{ locale: Locale }>;
}

// The web app has no public home: every space starts at the sign-in page.
export default async function HomePage({ params }: HomeProps) {
  const { locale } = await params;
  redirect({ href: '/login', locale });
}
