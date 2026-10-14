'use client';

import { useTranslations } from 'next-intl';
import { useEffect, useState } from 'react';
import { cn } from '@/lib/cn';

/** Last seconds shown in orange (animation 10). */
const LAST_SECONDS = 10;

function secondsLeft(expiresAt: string): number {
  return Math.max(0, Math.ceil((new Date(expiresAt).getTime() - Date.now()) / 1000));
}

/**
 * Time left before `expiresAt` (sent by the server). Display only: the server decides whether the
 * operation is still valid. Announced every 10 seconds, not every second.
 */
export function Countdown({ expiresAt, total }: { expiresAt: string; total: number }) {
  const t = useTranslations('ui.countdown');
  const [left, setLeft] = useState(() => secondsLeft(expiresAt));

  useEffect(() => {
    const timer = setInterval(() => {
      setLeft(secondsLeft(expiresAt));
    }, 1000);
    return () => {
      clearInterval(timer);
    };
  }, [expiresAt]);

  const ratio = total <= 0 ? 0 : Math.min(left / total, 1);
  return (
    <div className="flex flex-col gap-2">
      <div
        role="progressbar"
        aria-valuemin={0}
        aria-valuemax={total}
        aria-valuenow={left}
        aria-label={t('label')}
        className="h-1 w-full overflow-hidden rounded-badge bg-border"
      >
        {/* Animation 10: the bar empties (transform only), orange during the last 10 seconds. */}
        <div
          className={cn(
            'h-full w-full origin-left transition-transform duration-slow ease-out rtl:origin-right',
            left <= LAST_SECONDS ? 'bg-warning' : 'bg-emerald',
          )}
          style={{ transform: `scaleX(${String(ratio)})` }}
        />
      </div>
      <p className="text-caption text-text-muted">
        {left > 0 ? t('left', { seconds: left }) : t('expired')}
      </p>
      <p className="sr-only" aria-live="polite">
        {left % 10 === 0 ? t('left', { seconds: left }) : ''}
      </p>
    </div>
  );
}
