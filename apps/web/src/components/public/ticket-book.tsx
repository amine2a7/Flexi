'use client';

import { RotateCcw, Scissors } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState } from 'react';
import { buttonClasses } from '@/components/ui/button';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import type { CreditType } from '@/lib/credit-types';
import { cn } from '@/lib/cn';

/** The five tickets of the book (docs/design/carnet-tickets/accueil-carnet): the FlexiPay story. */
type TicketKey = 't1' | 't2' | 't3' | 't4' | 't5';
const FIRST: { key: TicketKey; types: readonly CreditType[] } = {
  key: 't1',
  types: ['RESTAURATION', 'CARBURANT'],
};
const TICKETS: readonly { key: TicketKey; types: readonly CreditType[] }[] = [
  FIRST,
  { key: 't2', types: ['RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX'] },
  { key: 't3', types: ['RESTAURATION'] },
  { key: 't4', types: ['RESTAURATION', 'CADEAUX'] },
  { key: 't5', types: [] },
];

/** Barcode of the tickets: decorative bars drawn from the navy token. */
export function Barcode({ className }: { className?: string }) {
  return (
    <span aria-hidden="true" className={cn('ticket-barcode block h-8 w-qr-code', className)} />
  );
}

/** Book of tickets of the hero: one ticket at a time, "detach" shows the next one. */
export function TicketBook() {
  const t = useTranslations('landing.book');
  const { settlementDays } = usePlatformTerms();
  const [index, setIndex] = useState(0);
  const ticket = TICKETS[index] ?? FIRST;
  const last = index === TICKETS.length - 1;
  return (
    <div className="flex flex-col items-center gap-6">
      <div className="relative w-full max-w-auth-card-max-width">
        <span
          aria-hidden="true"
          className="absolute inset-0 translate-x-3 translate-y-3 rounded-card-desktop bg-paper-line"
        />
        <span
          aria-hidden="true"
          className="absolute inset-0 translate-x-1 translate-y-1 rounded-card-desktop bg-paper"
        />
        <article
          key={ticket.key}
          aria-live="polite"
          className="fp-cascade relative flex flex-col rounded-card-desktop bg-paper text-navy shadow-card"
        >
          <div className="flex flex-1 flex-col gap-3 p-6">
            <p className="flex justify-between gap-3 font-ticket text-micro uppercase text-paper-ink">
              <span>{t('number', { n: index + 1, total: TICKETS.length })}</span>
              <span>{t(`${ticket.key}.tag`)}</span>
            </p>
            <h2 className="font-display text-display-md">{t(`${ticket.key}.title`, { days: settlementDays })}</h2>
            <p className="text-body-lg text-paper-ink">{t(`${ticket.key}.text`)}</p>
            <ul className="mt-auto flex flex-wrap gap-2 pt-4">
              {ticket.types.map((type) => (
                <li key={type}>
                  <CreditTypeBadge type={type} />
                </li>
              ))}
            </ul>
          </div>
          <div className="relative border-t-2 border-dashed border-paper-line">
            <span
              aria-hidden="true"
              className="absolute -top-2 start-0 size-4 -translate-x-1/2 rounded-badge bg-navy rtl:translate-x-1/2"
            />
            <span
              aria-hidden="true"
              className="absolute -top-2 end-0 size-4 translate-x-1/2 rounded-badge bg-navy rtl:-translate-x-1/2"
            />
          </div>
          <div className="flex items-center justify-between gap-3 px-6 py-4">
            <Barcode />
            <p className="text-end font-ticket text-micro text-paper-ink">
              {t(`${ticket.key}.fine`)}
            </p>
          </div>
        </article>
      </div>
      <div className="flex flex-wrap items-center justify-center gap-3">
        <button
          type="button"
          disabled={last}
          onClick={() => {
            setIndex((current) => Math.min(current + 1, TICKETS.length - 1));
          }}
          className={buttonClasses('secondary')}
        >
          <Scissors aria-hidden="true" className="size-icon-md" />
          {t('detach')}
        </button>
        <button
          type="button"
          onClick={() => {
            setIndex(0);
          }}
          className={buttonClasses(
            'ghost',
            'md',
            'border border-on-navy-muted text-on-navy hover:bg-navy-deep',
          )}
        >
          <RotateCcw aria-hidden="true" className="size-icon-md" />
          {t('reopen')}
        </button>
        <span className="text-caption text-on-navy-muted">
          {t('left', { count: TICKETS.length - index - 1 })}
        </span>
      </div>
    </div>
  );
}
