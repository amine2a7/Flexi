'use client';

import { RotateCcw, Scissors } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useState } from 'react';
import { buttonClasses } from '@/components/ui/button';
import { CreditTypeBadge } from '@/components/ui/credit-type';
import { usePlatformTerms } from '@/lib/api/use-platform-terms';
import type { CreditType } from '@/lib/credit-types';
import { cn } from '@/lib/cn';
import { motionMs, prefersReducedMotion } from '@/lib/motion';

/** The five tickets of the book (docs/design/carnet-tickets/accueil-carnet): the FlexiPay story. */
type TicketKey = 't1' | 't2' | 't3' | 't4' | 't5';
const TICKETS: readonly { key: TicketKey; types: readonly CreditType[] }[] = [
  { key: 't1', types: ['RESTAURATION', 'CARBURANT'] },
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

/**
 * Book of tickets of the hero: « Détacher » tears the top ticket off (it flies away) and shows
 * the next one, already underneath. Every ticket sits in the same grid cell, so the book keeps the
 * height of the tallest one and nothing below it jumps. The book tears a ticket by itself every
 * few seconds until the visitor touches it; with reduced motion, nothing moves on its own.
 */
export function TicketBook() {
  const t = useTranslations('landing.book');
  const { settlementDays } = usePlatformTerms();
  const [index, setIndex] = useState(0);
  const [tearing, setTearing] = useState(false);
  const [auto, setAuto] = useState(true);
  const last = index === TICKETS.length - 1;

  function next() {
    setTearing(false);
    setIndex((current) => Math.min(current + 1, TICKETS.length - 1));
  }

  function tear() {
    if (tearing || last) return;
    if (prefersReducedMotion()) next();
    else setTearing(true);
  }

  useEffect(() => {
    if (!auto || last || prefersReducedMotion()) return undefined;
    const timer = window.setTimeout(() => {
      setTearing(true);
    }, motionMs('book-auto'));
    return () => {
      window.clearTimeout(timer);
    };
  }, [auto, last, index]);

  const stop = () => {
    setAuto(false);
  };

  return (
    <div className="flex flex-col items-center gap-8" onPointerEnter={stop} onFocusCapture={stop}>
      <div className="relative w-full max-w-auth-card-max-width">
        <span
          aria-hidden="true"
          className={cn(
            'absolute inset-0 translate-x-3 translate-y-3 rounded-card-desktop bg-paper-line rtl:-translate-x-3',
            index >= TICKETS.length - 2 && 'opacity-0',
          )}
        />
        <span
          aria-hidden="true"
          className={cn(
            'absolute inset-0 translate-x-1 translate-y-1 rounded-card-desktop bg-paper rtl:-translate-x-1',
            last && 'opacity-0',
          )}
        />
        <div className="grid" aria-live="polite">
          {TICKETS.map((ticket, position) => {
            const current = position === index;
            const underneath = tearing && position === index + 1;
            return (
              <article
                key={ticket.key}
                aria-hidden={!current}
                onAnimationEnd={(event) => {
                  if (current && event.animationName === 'fp-tear') next();
                }}
                className={cn(
                  'relative col-start-1 row-start-1 flex flex-col rounded-card-desktop bg-paper text-navy shadow-card',
                  current ? 'z-20' : underneath ? 'z-10' : 'invisible',
                  current && tearing && 'pointer-events-none animate-tear',
                )}
              >
                <div className="flex flex-1 flex-col gap-3 p-6">
                  <p className="flex justify-between gap-3 font-ticket text-micro uppercase text-paper-ink">
                    <span>{t('number', { n: position + 1, total: TICKETS.length })}</span>
                    <span>{t(`${ticket.key}.tag`)}</span>
                  </p>
                  <h2 className="font-display text-display-md">
                    {t(`${ticket.key}.title`, { days: settlementDays })}
                  </h2>
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
            );
          })}
        </div>
      </div>
      <div className="flex flex-wrap items-center justify-center gap-3">
        <button
          type="button"
          disabled={last || tearing}
          onClick={tear}
          className={buttonClasses('secondary')}
        >
          <Scissors aria-hidden="true" className={cn('size-icon-md', !last && 'animate-wiggle')} />
          {t('detach')}
        </button>
        <button
          type="button"
          onClick={() => {
            setTearing(false);
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
