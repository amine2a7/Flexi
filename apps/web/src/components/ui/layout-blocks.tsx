'use client';

import { AlertTriangle, CircleCheck, Info, OctagonAlert } from 'lucide-react';
import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';

export function PageHeader({
  title,
  description,
  actions,
}: {
  title: string;
  description?: string;
  actions?: ReactNode;
}) {
  return (
    <header className="mb-6 flex flex-wrap items-end justify-between gap-4">
      <div className="flex flex-col gap-1">
        <h1 className="text-headline text-text">{title}</h1>
        {description !== undefined ? (
          <p className="text-body text-text-muted">{description}</p>
        ) : null}
      </div>
      {actions !== undefined ? <div className="flex flex-wrap gap-3">{actions}</div> : null}
    </header>
  );
}

const ALERT_TONES = {
  info: { classes: 'bg-info-soft text-info-text', Icon: Info },
  success: { classes: 'bg-emerald-soft text-emerald-text', Icon: CircleCheck },
  warning: { classes: 'bg-warning-soft text-warning-text', Icon: AlertTriangle },
  danger: { classes: 'bg-danger-soft text-danger-text', Icon: OctagonAlert },
};

/** Inline message (never colour only: icon + text). */
export function Alert({
  tone = 'info',
  title,
  children,
}: {
  tone?: keyof typeof ALERT_TONES;
  title?: string;
  children?: ReactNode;
}) {
  const { classes, Icon } = ALERT_TONES[tone];
  return (
    <div
      role={tone === 'danger' ? 'alert' : 'status'}
      className={cn('flex items-start gap-3 rounded-card-desktop p-4', classes)}
    >
      <Icon aria-hidden="true" className="size-icon-md shrink-0" />
      <div className="flex flex-col gap-1 text-body">
        {title !== undefined ? <p className="font-title">{title}</p> : null}
        {children}
      </div>
    </div>
  );
}

/** Two-column list of facts (label / value). */
export function DescriptionList({
  items,
}: {
  items: readonly { readonly label: string; readonly value: ReactNode }[];
}) {
  return (
    <dl className="grid gap-4 sm:grid-cols-2">
      {items.map((item) => (
        <div key={item.label} className="flex flex-col gap-1">
          <dt className="text-caption text-text-muted">{item.label}</dt>
          <dd className="text-body text-text">{item.value}</dd>
        </div>
      ))}
    </dl>
  );
}

interface TabsProps<Key extends string> {
  readonly label: string;
  readonly tabs: readonly { readonly key: Key; readonly label: string }[];
  readonly value: Key;
  readonly onChange: (key: Key) => void;
}

/** Simple tabs (buttons with aria-pressed): content is rendered by the caller. */
export function Tabs<Key extends string>({ label, tabs, value, onChange }: TabsProps<Key>) {
  return (
    <div
      role="group"
      aria-label={label}
      className="mb-4 flex flex-wrap gap-2 border-b border-border"
    >
      {tabs.map((tab) => (
        <button
          key={tab.key}
          type="button"
          aria-pressed={tab.key === value}
          onClick={() => { onChange(tab.key); }}
          className={cn(
            'min-h-touch-target-min border-b-2 px-4 text-label',
            tab.key === value
              ? 'border-navy text-navy'
              : 'border-transparent text-text-muted hover:text-text',
          )}
        >
          {tab.label}
        </button>
      ))}
    </div>
  );
}
