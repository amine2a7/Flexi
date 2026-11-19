'use client';

import { useTranslations } from 'next-intl';
import { createContext, useContext, useMemo, useState, type ReactNode } from 'react';
import { cn } from '@/lib/cn';

/** Moods of the mascot (docs/design/carnet-tickets/connexion-web). */
export type MascotMood = 'idle' | 'covering' | 'loading' | 'happy' | 'sad';

const MOUTH: Record<MascotMood, string> = {
  idle: 'M68 83 Q80 92 92 83',
  covering: 'M68 83 Q80 92 92 83',
  loading: 'M75 84 a5 5 0 1 0 10 0 a5 5 0 1 0 -10 0',
  happy: 'M64 82 Q80 98 96 82 Z',
  sad: 'M68 90 Q80 80 92 90',
};

/**
 * The FlexiPay mascot (a plate holding a fork and a knife): it hides its eyes behind the cutlery
 * while the password is typed, waits during the check, smiles when the ticket is accepted and is
 * sad when it is refused. Colours from the design tokens; the moves are plain fades when the
 * motion is reduced.
 */
export function Mascot({ mood = 'idle', className }: { mood?: MascotMood; className?: string }) {
  const t = useTranslations('auth.mascot');
  const covering = mood === 'covering';
  const label = covering
    ? t('covering')
    : mood === 'happy'
      ? t('happy')
      : mood === 'sad'
        ? t('sad')
        : mood === 'loading'
          ? t('loading')
          : t('idle');
  const hand = 'transition-transform duration-slow ease-spring motion-reduce:transition-none';
  return (
    <svg
      viewBox="0 0 160 110"
      role="img"
      aria-label={label}
      className={cn('h-auto w-illustration', mood === 'sad' && 'animate-shake', className)}
    >
      <circle cx="80" cy="72" r="38" className="fill-surface stroke-navy" strokeWidth="4" />
      <circle cx="80" cy="72" r="28" fill="none" className="stroke-border" strokeWidth="2" />
      <circle cx="60" cy="82" r="5" className="fill-type-gift-soft" />
      <circle cx="100" cy="82" r="5" className="fill-type-gift-soft" />
      {mood === 'happy' ? (
        <path
          d="M62 67 Q68 59 74 67 M86 67 Q92 59 98 67"
          fill="none"
          className="stroke-navy"
          strokeWidth="3.2"
          strokeLinecap="round"
        />
      ) : (
        <g>
          <ellipse cx="68" cy="66" rx="4.2" ry="5.4" className="fill-navy" />
          <ellipse cx="92" cy="66" rx="4.2" ry="5.4" className="fill-navy" />
          <circle cx="69.4" cy="64.2" r="1.3" className="fill-surface" />
          <circle cx="93.4" cy="64.2" r="1.3" className="fill-surface" />
        </g>
      )}
      <path
        d={MOUTH[mood]}
        className={cn(
          'stroke-navy',
          mood === 'happy' || mood === 'loading' ? 'fill-navy' : 'fill-none',
        )}
        strokeWidth="3"
        strokeLinecap="round"
      />
      {/* The fork and the knife rise in front of the eyes while the password is typed. */}
      <g className={hand} transform={covering ? 'rotate(38 28 105) translate(0 -6)' : undefined}>
        <rect x="22" y="38" width="3" height="16" rx="1.5" className="fill-navy" />
        <rect x="27" y="38" width="3" height="16" rx="1.5" className="fill-navy" />
        <rect x="32" y="38" width="3" height="16" rx="1.5" className="fill-navy" />
        <rect x="22" y="52" width="13" height="7" rx="3" className="fill-navy" />
        <rect x="26.5" y="58" width="4" height="47" rx="2" className="fill-navy" />
      </g>
      <g className={hand} transform={covering ? 'rotate(-38 130 105) translate(0 -6)' : undefined}>
        <path
          d="M128 38 Q141 50 136 70 L128 70 Z"
          className="fill-border stroke-navy"
          strokeWidth="2"
          strokeLinejoin="round"
        />
        <rect x="128" y="69" width="5" height="36" rx="2" className="fill-navy" />
      </g>
    </svg>
  );
}

const MoodContext = createContext<{
  mood: MascotMood;
  setMood: (mood: MascotMood) => void;
} | null>(null);

/** Shares the mood between the sign-in form and the mascot above the ticket. */
export function MascotProvider({ children }: { children: ReactNode }) {
  const [mood, setMood] = useState<MascotMood>('idle');
  const value = useMemo(() => ({ mood, setMood }), [mood]);
  return <MoodContext.Provider value={value}>{children}</MoodContext.Provider>;
}

/** Changes the mood of the mascot of the page (no effect without a mascot). */
export function useMascotMood(): (mood: MascotMood) => void {
  return useContext(MoodContext)?.setMood ?? noop;
}

function noop(): void {
  // No mascot on this page.
}

/** The mascot of the page, with the mood set by the form. */
export function PageMascot({ className }: { className?: string }) {
  const mood = useContext(MoodContext)?.mood ?? 'idle';
  return <Mascot mood={mood} {...(className === undefined ? {} : { className })} />;
}
