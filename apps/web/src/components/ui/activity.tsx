'use client';

import { ChevronRight, ListTodo } from 'lucide-react';
import { useTranslations } from 'next-intl';
import type { ReactNode } from 'react';
import { Link } from '@/i18n/navigation';
import { buttonClasses } from './button';
import { Card, CardTitle } from './card';

export interface TodoItem {
  readonly key: string;
  readonly icon?: ReactNode;
  readonly text: string;
  readonly href?: string;
  readonly actionLabel?: string;
}

/** « À faire » zone at the top of a dashboard: what waits for the user, each with its action. */
export function TodoPanel({ items }: { items: readonly TodoItem[] }) {
  const t = useTranslations('ui.todo');
  return (
    <Card>
      <CardTitle>{t('title')}</CardTitle>
      {items.length === 0 ? (
        <p className="text-body text-text-muted">{t('empty')}</p>
      ) : (
        <ul className="flex flex-col gap-3">
          {items.map((item) => (
            <li
              key={item.key}
              className="flex flex-wrap items-center justify-between gap-3 rounded-button bg-warning-soft p-3"
            >
              <span className="flex min-w-0 items-center gap-3 text-label text-warning-text">
                <span aria-hidden="true" className="shrink-0">
                  {item.icon ?? <ListTodo className="size-icon-md" />}
                </span>
                {item.text}
              </span>
              {item.href !== undefined && item.actionLabel !== undefined ? (
                <Link href={item.href} className={buttonClasses('secondary', 'sm')}>
                  {item.actionLabel}
                  <ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />
                </Link>
              ) : null}
            </li>
          ))}
        </ul>
      )}
    </Card>
  );
}

export interface ActivityItem {
  readonly key: string;
  readonly title: ReactNode;
  readonly subtitle?: ReactNode;
  /** Amount and/or status badge shown at the end of the line. */
  readonly end?: ReactNode;
  readonly href?: string;
}

/** Compact list of the last operations (dashboard side column). */
export function ActivityList({ items, empty }: { items: readonly ActivityItem[]; empty: string }) {
  if (items.length === 0) return <p className="text-body text-text-muted">{empty}</p>;
  return (
    <ul className="flex flex-col">
      {items.map((item) => {
        const content = (
          <>
            <span className="flex min-w-0 flex-col gap-1">
              {/* Isolated: a reference or a Latin name keeps its order in an Arabic page. */}
              <bdi className="truncate text-label text-text">{item.title}</bdi>
              {item.subtitle !== undefined ? (
                <bdi className="text-caption text-text-muted">{item.subtitle}</bdi>
              ) : null}
            </span>
            <span className="flex shrink-0 flex-col items-end gap-1 text-label text-text">
              {item.end}
            </span>
          </>
        );
        return (
          <li key={item.key} className="border-b border-border last:border-b-0">
            {item.href === undefined ? (
              <div className="flex items-center justify-between gap-3 py-3">{content}</div>
            ) : (
              <Link
                href={item.href}
                className="flex items-center justify-between gap-3 rounded-button py-3 hover:bg-bg"
              >
                {content}
              </Link>
            )}
          </li>
        );
      })}
    </ul>
  );
}
