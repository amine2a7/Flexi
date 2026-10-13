import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';

/** White card with a thin border (no strong shadow). */
export function Card({ className, children }: { className?: string; children: ReactNode }) {
  return (
    <section
      className={cn(
        'rounded-card-desktop border border-border bg-surface p-5 shadow-card lg:p-6',
        className,
      )}
    >
      {children}
    </section>
  );
}

/** Card heading with an optional help sentence and an action at the end. */
export function CardTitle({
  children,
  action,
  description,
}: {
  children: ReactNode;
  action?: ReactNode;
  description?: string;
}) {
  return (
    <div className="mb-4 flex flex-wrap items-start justify-between gap-3">
      <div className="flex min-w-0 flex-col gap-1">
        <h2 className="text-title-sm text-text">{children}</h2>
        {description !== undefined ? (
          <p className="text-body text-text-muted">{description}</p>
        ) : null}
      </div>
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

/** KPI card: grey label, icon in a square at the end, large figure, short line of context. */
export function StatCard({ label, value, hint, icon, tone = 'default' }: StatCardProps) {
  return (
    <div className="flex flex-col gap-4 rounded-card-desktop border border-border bg-surface p-5 shadow-card">
      <div className="flex items-start justify-between gap-3">
        <p className="text-label text-text-muted">{label}</p>
        {icon !== undefined ? (
          <span
            aria-hidden="true"
            className={cn(
              'flex size-avatar-md shrink-0 items-center justify-center rounded-button',
              TONES[tone],
            )}
          >
            {icon}
          </span>
        ) : null}
      </div>
      <div className="flex min-w-0 flex-col gap-1">
        <div className="text-title text-text">{value}</div>
        {hint !== undefined ? <div className="text-caption text-text-muted">{hint}</div> : null}
      </div>
    </div>
  );
}
