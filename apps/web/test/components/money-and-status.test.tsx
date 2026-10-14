// @vitest-environment jsdom
import { cleanup, fireEvent, render, screen } from '@testing-library/react';
import { NextIntlClientProvider } from 'next-intl';
import { useState, type ReactNode } from 'react';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { loadMessages } from '@/i18n/messages';
import { routing, type Locale } from '@/i18n/routing';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { Amount } from '@/components/ui/amount';
import { AmountField } from '@/components/ui/amount-field';
import { Button } from '@/components/ui/button';
import { StatusBadge } from '@/components/ui/status-badge';

afterEach(cleanup);

function renderIn(locale: Locale, ui: ReactNode) {
  return render(
    <NextIntlClientProvider locale={locale} messages={loadMessages(locale)}>
      {ui}
    </NextIntlClientProvider>,
  );
}

/** Visible text with the (thin) no-break spaces of the formatter turned into plain spaces. */
const plain = (text: string | null | undefined): string =>
  (text ?? '').replace(/[\u00a0\u202f]/g, ' ');

describe('Amount', () => {
  it('shows integer millimes as dinars with 3 decimals and the currency (fr)', () => {
    const { container } = renderIn('fr', <Amount millimes={1_500_250} />);
    expect(plain(container.textContent)).toBe('1 500,250TND');
  });

  it('uses the English separators in en', () => {
    const { container } = renderIn('en', <Amount millimes={1_500_250} />);
    expect(plain(container.textContent)).toBe('1,500.250TND');
  });

  it('keeps Western digits and the decimal comma in ar', () => {
    const { container } = renderIn('ar', <Amount millimes={48_250_000} />);
    expect(plain(container.textContent)).toBe('48 250,000TND');
  });

  it('writes zero and small amounts with all their millimes', () => {
    const { container, rerender } = renderIn('fr', <Amount millimes={0} />);
    expect(plain(container.textContent)).toBe('0,000TND');
    rerender(
      <NextIntlClientProvider locale="fr" messages={loadMessages('fr')}>
        <Amount millimes={5} />
      </NextIntlClientProvider>,
    );
    expect(plain(container.textContent)).toBe('0,005TND');
  });

  it.each(routing.locales)(
    'gives the full amount with its currency as accessible name (%s)',
    (locale) => {
      renderIn(locale, <Amount millimes={18_500} />);
      expect(screen.getByRole('text').getAttribute('aria-label')).toBe(
        formatMillimesWithCurrency(18_500, locale),
      );
    },
  );

  it('writes the sign as text, never by colour only', () => {
    const messages = loadMessages('fr');
    const { container } = renderIn(
      'fr',
      <>
        <Amount millimes={6_500} sign="debit" />
        <Amount millimes={40_000} sign="credit" />
      </>,
    );
    const [debit, credit] = screen.getAllByRole('text');
    expect(plain(debit?.textContent)).toMatch(/^−6,500/);
    expect(plain(credit?.textContent)).toMatch(/^\+40,000/);
    expect(debit?.getAttribute('aria-label')).toBe(
      messages.ui.amount.debit.replace('{amount}', formatMillimesWithCurrency(6_500, 'fr')),
    );
    expect(container.querySelectorAll('[aria-hidden="true"]').length).toBe(4);
  });

  it('refuses a non-integer amount (money is never a float)', () => {
    vi.spyOn(console, 'error').mockImplementation(() => undefined);
    expect(() => renderIn('fr', <Amount millimes={1.5} />)).toThrow();
    vi.restoreAllMocks();
  });
});

function ControlledAmountField({ onRead }: { onRead: (millimes: number | undefined) => void }) {
  const [text, setText] = useState('');
  return (
    <AmountField
      label="amount"
      value={text}
      onChange={(next, millimes) => {
        setText(next);
        onRead(millimes);
      }}
    />
  );
}

describe('Amount counting up (main KPI)', () => {
  it('always gives the final amount to screen readers while it counts', () => {
    renderIn('fr', <Amount millimes={1_500_250} countUp />);
    expect(plain(screen.getByRole('text').getAttribute('aria-label'))).toBe(
      plain(formatMillimesWithCurrency(1_500_250, 'fr')),
    );
  });
});

describe('Button waiting and success', () => {
  it('keeps its label while waiting, is disabled and says it is busy', () => {
    render(<Button loading>Encaisser</Button>);
    const button = screen.getByRole('button', { name: 'Encaisser' });
    expect(button).toHaveProperty('disabled', true);
    expect(button.getAttribute('aria-busy')).toBe('true');
  });

  it('turns green with its label after a success, and stays usable', () => {
    render(<Button succeeded>Valider</Button>);
    const button = screen.getByRole('button', { name: 'Valider' });
    expect(button.className).toContain('bg-emerald');
    expect(button).toHaveProperty('disabled', false);
  });
});

describe('AmountField', () => {
  function setup(locale: Locale) {
    const onRead = vi.fn<(millimes: number | undefined) => void>();
    renderIn(locale, <ControlledAmountField onRead={onRead} />);
    const input = screen.getByLabelText('amount');
    return { input, onRead, messages: loadMessages(locale).ui.amountField };
  }

  it('opens the decimal keyboard and stays left-to-right, also in Arabic', () => {
    const { input } = setup('ar');
    expect(input.getAttribute('inputmode')).toBe('decimal');
    expect(input.getAttribute('dir')).toBe('ltr');
  });

  it('shows an example while empty', () => {
    const { messages } = setup('fr');
    expect(screen.getByText(messages.hint)).toBeTruthy();
  });

  it('reads the typed text as integer millimes and shows the reading (fr)', () => {
    const { input, onRead, messages } = setup('fr');
    fireEvent.change(input, { target: { value: '18,5' } });
    expect(onRead).toHaveBeenLastCalledWith(18_500);
    // The hint is linked to the input (aria-describedby) and gives the reading of the text.
    const hint = document.getElementById(input.getAttribute('aria-describedby') ?? '');
    expect(plain(hint?.textContent)).toBe(
      plain(messages.preview.replace('{amount}', formatMillimesWithCurrency(18_500, 'fr'))),
    );
    expect(input.getAttribute('aria-invalid')).toBeNull();
  });

  it('reads English input with its own separators', () => {
    const { input, onRead } = setup('en');
    fireEvent.change(input, { target: { value: '1,500.25' } });
    expect(onRead).toHaveBeenLastCalledWith(1_500_250);
  });

  it.each(['abc', '12,3456', '-5', '1e3'])('refuses %s with a clear message', (text) => {
    const { input, onRead, messages } = setup('fr');
    fireEvent.change(input, { target: { value: text } });
    expect(onRead).toHaveBeenLastCalledWith(undefined);
    expect(input.getAttribute('aria-invalid')).toBe('true');
    expect(screen.getByText(messages.invalid)).toBeTruthy();
  });
});

describe('StatusBadge', () => {
  const label = (ui: ReactNode, locale: Locale = 'fr') => {
    const { container } = renderIn(locale, ui);
    return plain(container.textContent);
  };

  it.each([
    ['CONFIRMED', 'Confirmé'],
    ['PENDING', 'En attente'],
    ['SETTLED', 'Réglé'],
    ['REFUSED', 'Refusé'],
    ['COMPLETED', 'Confirmé'],
  ])('translates the contract status %s (%s)', (status, expected) => {
    expect(label(<StatusBadge status={status} />)).toBe(expected);
  });

  it('uses the context to pick the glossary word', () => {
    expect(label(<StatusBadge status="REJECTED" context="approval" />)).toBe('Refusée');
    cleanup();
    expect(label(<StatusBadge status="REJECTED" context="payout" />)).toBe('Rejetée');
    cleanup();
    expect(label(<StatusBadge status="AWAITING_PAYMENT" context="order" />)).toBe(
      'En attente de paiement',
    );
  });

  it('accepts a wording of the screen (labelKey) with the colours of the status', () => {
    const { container } = renderIn(
      'fr',
      <StatusBadge status="PENDING" labelKey="adminMessages.status.NEW" />,
    );
    expect(plain(container.textContent)).toBe('Nouveau');
    expect(container.firstElementChild?.className).toContain('bg-warning-soft');
  });

  it('never shows a status by colour only: icon hidden from readers, text always present', () => {
    const { container } = renderIn('fr', <StatusBadge status="CONFIRMED" />);
    const badge = container.firstElementChild;
    expect(badge?.className).toContain('bg-emerald-soft');
    expect(badge?.className).toContain('text-emerald-text');
    expect(badge?.querySelector('svg')?.getAttribute('aria-hidden')).toBe('true');
  });

  it('falls back to "unknown status" for a value it does not know', () => {
    expect(label(<StatusBadge status="SOMETHING_NEW" />)).toBe('Statut inconnu');
  });

  it.each(routing.locales)('has a non-empty label for every known status in %s', (locale) => {
    for (const status of ['CONFIRMED', 'PENDING', 'SETTLED', 'REFUSED', 'REQUESTED', 'EXPIRED']) {
      const text = label(<StatusBadge status={status} />, locale);
      expect(text.trim(), `${locale}:${status}`).not.toBe('');
      cleanup();
    }
  });
});
