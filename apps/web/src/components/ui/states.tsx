'use client';

import { AlertTriangle, Inbox } from 'lucide-react';
import { useTranslations } from 'next-intl';
import type { ReactNode } from 'react';
import { messageKey } from '@/i18n/keys';
import { errorMessageKey } from '@/lib/api/problem';
import { cn } from '@/lib/cn';
import { Button } from './button';

export function Skeleton({ className }: { className?: string }) {
  return (
    <span
      aria-hidden="true"
      className={cn('fp-skeleton block rounded-input bg-border', className)}
    />
  );
}

/** Loading placeholder announced once to screen readers. */
export function LoadingBlock({ lines = 3 }: { lines?: number }) {
  const t = useTranslations('common.state');
  return (
    <div role="status" aria-live="polite" className="flex flex-col gap-3">
      <span className="sr-only">{t('loading')}</span>
      {Array.from({ length: lines }, (_, index) => (
        <Skeleton key={index} className="h-input-height w-full" />
      ))}
    </div>
  );
}

interface EmptyStateProps {
  readonly title: string;
  readonly message?: string;
  readonly action?: ReactNode;
  readonly icon?: ReactNode;
}

/** Empty list that tells the user what to do next (UX: empty states guide). */
export function EmptyState({ title, message, action, icon }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center gap-3 px-4 py-10 text-center">
      <span aria-hidden="true" className="text-text-faint">
        {icon ?? <Inbox className="size-icon-lg" />}
      </span>
      <p className="text-title-sm text-text">{title}</p>
      {message !== undefined ? (
        <p className="max-w-form-max-width text-body text-text-muted">{message}</p>
      ) : null}
      {action}
    </div>
  );
}

/** API error with an explanation and a retry button (persistent, never auto-dismissed). */
export function ErrorState({ error, onRetry }: { error: unknown; onRetry?: () => void }) {
  const t = useTranslations();
  return (
    <div role="alert" className="flex flex-col items-center gap-3 px-4 py-10 text-center">
      <AlertTriangle aria-hidden="true" className="size-icon-lg text-danger" />
      <p className="text-title-sm text-text">{t('common.state.error.title')}</p>
      <p className="max-w-form-max-width text-body text-text-muted">
        {t(messageKey(errorMessageKey(error)))}
      </p>
      {onRetry !== undefined ? (
        <Button variant="secondary" onClick={onRetry}>
          {t('common.button.retry')}
        </Button>
      ) : null}
    </div>
  );
}
