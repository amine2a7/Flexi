'use client';

import { RotateCcw, Scissors, Zap } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useState } from 'react';
import { buttonClasses } from '@/components/ui/button';
import { useCreditTypeLabel } from '@/components/ui/credit-type';
import type { CreditType } from '@/lib/credit-types';
import { cn } from '@/lib/cn';
import { motionMs, prefersReducedMotion } from '@/lib/motion';

/**
 * The five tickets of the book (maquette « Accueil · Le dernier carnet de tickets »): the FlexiPay
 * story, each ticket with its colour band and the credit types it speaks about.
 */
type TicketKey = 't1' | 't2' | 't3' | 't4' | 't5';
const TICKETS: readonly { key: TicketKey; band: string; types: readonly CreditType[] }[] = [
  { key: 't1', band: 'bg-emerald', types: ['RESTAURATION', 'CARBURANT'] },
  { key: 't2', band: 'bg-info', types: ['RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX'] },
  { key: 't3', band: 'bg-type-food', types: ['RESTAURATION'] },
  { key: 't4', band: 'bg-type-clothing', types: ['RESTAURATION', 'CADEAUX'] },
  { key: 't5', band: 'bg-navy', types: [] },
];
const DOT: Record<CreditType, string> = {
  RESTAURATION: 'bg-type-food',
  HABILLEMENT: 'bg-type-clothing',
  CARBURANT: 'bg-type-fuel',
  CADEAUX: 'bg-type-gift',
};

/** Barcode of the tickets: decorative bars drawn from the navy token. */
export function Barcode({ className }: { className?: string }) {
  return (
    <span aria-hidden="true" className={cn('ticket-barcode block h-8 w-qr-code', className)} />
  );
}

/**
 * Book of tickets of the hero. Its cover opens once on its spine; « Détacher le ticket » tears the
 * top ticket off (it flies away) onto the next one, already underneath; the last one offers
 * « Rouvrir le carnet ». Every ticket sits in the same grid cell, so the book keeps the height of
 * the tallest one. The book tears a ticket by itself every few seconds until the visitor touches
 * it; with reduced motion, no cover and nothing moves on its own.
 */
/** `settlementDays`: read on the server by the page (no API call from the browser). */
export function TicketBook({ settlementDays }: { settlementDays: number | string }) {
  const t = useTranslations('landing.book');
  const typeLabel = useCreditTypeLabel();
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
  const left = TICKETS.length - index;

  return (
    <div
      className="flex w-full flex-col items-center gap-5"
      onPointerEnter={stop}
      onFocusCapture={stop}
    >
      <div className="fp-book relative w-full max-w-auth-card-max-width">
        {/* The thickness of the book: it thins out as the tickets go. */}
        <span
          aria-hidden="true"
          className={cn(
            'absolute inset-0 translate-x-2 translate-y-4 rotate-3 rounded-card-desktop bg-book-edge rtl:-translate-x-2 rtl:-rotate-3',
          )}
        />
        <span
          aria-hidden="true"
          className={cn(
            'absolute inset-0 translate-x-1.5 translate-y-2.5 rotate-2 rounded-card-desktop bg-paper-edge rtl:-translate-x-1.5 rtl:-rotate-2',
            left <= 2 && 'opacity-0',
          )}
        />
        <span
          aria-hidden="true"
          className={cn(
            'absolute inset-0 translate-x-1 translate-y-1 rotate-1 rounded-card-desktop bg-paper-edge-light rtl:-translate-x-1 rtl:-rotate-1',
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
                  'relative col-start-1 row-start-1 flex flex-col overflow-hidden rounded-card-desktop bg-paper text-text',
                  current ? 'z-20 shadow-raised' : underneath ? 'z-10' : 'invisible',
                  current && tearing && 'pointer-events-none animate-tear',
                )}
              >
                <span aria-hidden="true" className={cn('block h-2.5', ticket.band)} />
                <div className="flex flex-1 flex-col gap-3 px-6 py-5">
                  <p className="flex justify-between gap-3 font-ticket text-micro uppercase text-paper-ink">
                    <span>{t('number', { n: position + 1, total: TICKETS.length })}</span>
                    <span>{t(`${ticket.key}.tag`)}</span>
                  </p>
                  <h2 className="font-display text-display-md leading-none">
                    {t(`${ticket.key}.title`, { days: settlementDays })}
                  </h2>
                  <p className="text-body text-neutral-text">{t(`${ticket.key}.text`)}</p>
                  <ul className="mt-auto flex flex-wrap gap-2 pt-2">
                    {ticket.types.map((type) => (
                      <li
                        key={type}
                        className="inline-flex items-center gap-1.5 rounded-badge border border-paper-border bg-surface px-2.5 py-1 text-caption font-label"
                      >
                        <span aria-hidden="true" className={cn('size-2 rounded-sm', DOT[type])} />
                        {typeLabel(type)}
                      </li>
                    ))}
                  </ul>
                </div>
                <div
                  aria-hidden="true"
                  className="relative mx-3.5 border-t-2 border-dashed border-paper-line"
                >
                  <span className="absolute -start-6 -top-3 size-5 rounded-badge bg-navy" />
                  <span className="absolute -end-6 -top-3 size-5 rounded-badge bg-navy" />
                </div>
                <div className="flex items-center justify-between gap-3 px-6 pb-4 pt-3">
                  <Barcode />
                  <p className="text-end text-micro text-paper-ink">{t(`${ticket.key}.fine`)}</p>
                </div>
              </article>
            );
          })}
        </div>
        {/* The cover opens once on its spine and turns away behind the book. */}
        <div
          aria-hidden="true"
          className="fp-backface-hidden pointer-events-none absolute inset-0 z-30 flex origin-left animate-cover flex-col justify-between rounded-card-desktop border-2 border-navy-line bg-navy-deep p-8 text-on-navy motion-reduce:hidden rtl:origin-right"
        >
          <p className="text-micro font-label uppercase tracking-widest text-emerald">
            {t('cover.edition')}
          </p>
          <p className="font-display text-display uppercase leading-none">{t('cover.title')}</p>
          <div className="flex items-end justify-between gap-3 text-caption text-on-navy-muted">
            <p>
              {t('cover.count')}
              <br />
              {t('cover.valid')}
            </p>
            <span className="flex size-avatar-lg items-center justify-center rounded-button bg-emerald text-on-emerald">
              <Zap className="size-icon-md" />
            </span>
          </div>
        </div>
      </div>
      <div className="flex flex-wrap items-center justify-center gap-3.5">
        {last ? (
          <button
            type="button"
            onClick={() => {
              setTearing(false);
              setIndex(0);
            }}
            className={buttonClasses(
              'ghost',
              'md',
              'border border-navy-line text-on-navy hover:bg-navy-deep',
            )}
          >
            <RotateCcw aria-hidden="true" className="size-icon-md" />
            {t('reopen')}
          </button>
        ) : (
          <button
            type="button"
            disabled={tearing}
            onClick={tear}
            className={buttonClasses('secondary', 'md', 'border-0 font-title')}
          >
            <Scissors aria-hidden="true" className="size-icon-md animate-wiggle" />
            {t('detach')}
          </button>
        )}
        <span className="text-caption text-on-navy-muted">
          {last ? t('empty') : t('left', { count: left })}
        </span>
      </div>
    </div>
  );
}
