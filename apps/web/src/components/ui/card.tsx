import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';

export function Card({ className, children }: { className?: string; children: ReactNode }) {
  return (
    <section className={cn('rounded-card-desktop bg-surface p-5 shadow-card lg:p-6', className)}>
      {children}
    </section>
  );
}

export function CardTitle({ children, action }: { children: ReactNode; action?: ReactNode }) {
  return (
    <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
      <h2 className="text-title-sm text-text">{children}</h2>
      {action}
    </div>
  );
}

interface StatCardProps {
  readonly label: string;
  readonly value: ReactNode;
  readonly hint?: ReactNode;
  readonly icon?: ReactNode;
  readonly tone?: 'default' | 'positive' | 'attention';
}

const TONES = {
  default: 'bg-bg text-navy',
  positive: 'bg-emerald-soft text-emerald-text',
  attention: 'bg-warning-soft text-warning-text',
};

/** Key figure of a dashboard: label, value (often an <Amount />) and an optional hint. */
export function StatCard({ label, value, hint, icon, tone = 'default' }: StatCardProps) {
  return (
    <div className="flex items-start gap-4 rounded-card-desktop bg-surface p-5 shadow-card">
      {icon !== undefined ? (
        <span
          aria-hidden="true"
          className={cn(
            'flex size-avatar-md shrink-0 items-center justify-center rounded-avatar',
            TONES[tone],
          )}
        >
          {icon}
        </span>
      ) : null}
      <div className="flex min-w-0 flex-col gap-1">
        <p className="text-caption text-text-muted">{label}</p>
        <div className="text-title text-text">{value}</div>
        {hint !== undefined ? <div className="text-caption text-text-muted">{hint}</div> : null}
      </div>
    </div>
  );
}
