// @vitest-environment jsdom
import { render, screen, within } from '@testing-library/react';
import { NextIntlClientProvider } from 'next-intl';
import type { AnchorHTMLAttributes, ReactNode } from 'react';
import { describe, expect, it, vi } from 'vitest';
import { loadMessages } from '@/i18n/messages';
import { routing, type Locale } from '@/i18n/routing';

vi.mock('@/i18n/navigation', () => ({
  usePathname: () => '/',
  Link: ({
    href,
    locale,
    children,
    ...rest
  }: AnchorHTMLAttributes<HTMLAnchorElement> & {
    href: string;
    locale?: string;
    children: ReactNode;
  }) => (
    <a href={`/${locale ?? ''}${href}`} {...rest}>
      {children}
    </a>
  ),
}));

const { LocaleSwitcher } = await import('@/components/layout/locale-switcher');
const { SkipLink } = await import('@/components/layout/skip-link');

function renderIn(locale: Locale, ui: ReactNode) {
  return render(
    <NextIntlClientProvider locale={locale} messages={loadMessages(locale)}>
      {ui}
    </NextIntlClientProvider>,
  );
}

describe.each(routing.locales)('layout pieces in %s', (locale) => {
  it('SkipLink targets the main content with a translated label', () => {
    renderIn(locale, <SkipLink />);
    const link = screen.getByRole('link', { name: loadMessages(locale).nav.skip });
    expect(link.getAttribute('href')).toBe('#main-content');
  });

  it('LocaleSwitcher lists the 3 languages as endonyms and flags the current one', () => {
    renderIn(locale, <LocaleSwitcher />);
    const nav = screen.getByRole('navigation', { name: loadMessages(locale).nav.language });
    const links = within(nav).getAllByRole('link');
    // Text read by assistive technologies: the short code shown on phones is aria-hidden.
    const spoken = (link: HTMLElement) =>
      [...link.children]
        .filter((child) => child.getAttribute('aria-hidden') !== 'true')
        .map((child) => child.textContent)
        .join('');
    expect(links.map(spoken)).toEqual(['Français', 'العربية', 'English']);
    expect(links.map((link) => link.getAttribute('lang'))).toEqual(['fr', 'ar', 'en']);
    const current = links.filter((link) => link.getAttribute('aria-current') === 'true');
    expect(current).toHaveLength(1);
    expect(current[0]?.getAttribute('lang')).toBe(locale);
  });
});
