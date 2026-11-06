'use client';

import { ChevronRight } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useRef, useState, type KeyboardEvent } from 'react';
import { Link } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { cn } from '@/lib/cn';
import { readOpenCategories, writeOpenCategories } from '@/lib/ui/menu-state';
import { CounterBadge } from './counter-badge';
import { isActive, isGroup, type NavEntry, type NavItem } from './nav-config';
import type { NavCounter } from './nav-counters';

const ROW =
  'flex min-h-touch-target-mobile w-full items-center gap-3 rounded-button px-3 text-label transition-colors duration-fast focus-visible:focus-ring-on-dark lg:min-h-touch-target-min';
const BADGE =
  'flex min-w-icon-lg items-center justify-center rounded-badge bg-emerald px-2 text-micro font-label text-on-emerald';

interface SideNavProps {
  /** Entries the session may open (empty categories already removed). */
  readonly entries: readonly NavEntry[];
  readonly pathname: string;
  readonly home: string;
  readonly counts: Partial<Record<NavCounter, number>>;
  readonly userId: string;
  readonly onNavigate: () => void;
}

/**
 * Side menu by categories (request of 2026-11-05): a category is a button that opens or closes
 * its entries (height in 200 ms, closed by default), the category of the current page opens by
 * itself, a closed category shows the sum of its counters, and the open ones are remembered per
 * user in this browser. Keyboard: Enter and Space toggle, Up and Down move, Right opens and Left
 * closes (mirrored in Arabic).
 */
export function SideNav({ entries, pathname, home, counts, userId, onNavigate }: SideNavProps) {
  const t = useTranslations();
  const list = useRef<HTMLUListElement>(null);
  const [open, setOpen] = useState<ReadonlySet<string>>(() => new Set(readOpenCategories(userId)));
  const activeGroup = entries.find(
    (entry) => isGroup(entry) && entry.items.some((item) => isActive(item, pathname, home)),
  );
  const activeKey = activeGroup !== undefined && isGroup(activeGroup) ? activeGroup.key : undefined;

  // The category of the page shown opens by itself (navigation, deep link).
  useEffect(() => {
    if (activeKey === undefined) return;
    // Follows the page (an external change), not a derived state.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setOpen((current) => (current.has(activeKey) ? current : new Set([...current, activeKey])));
  }, [activeKey]);

  const toggle = (key: string, force?: boolean) => {
    setOpen((current) => {
      const next = new Set(current);
      const shown = force ?? !next.has(key);
      if (shown) next.add(key);
      else next.delete(key);
      writeOpenCategories(userId, [...next]);
      return next;
    });
  };

  const countOf = (item: NavItem) => (item.counter === undefined ? 0 : (counts[item.counter] ?? 0));

  /** Up and Down move between the visible rows; Right and Left open and close a category. */
  function onKeyDown(event: KeyboardEvent<HTMLUListElement>) {
    const rows = [
      ...(list.current?.querySelectorAll<HTMLElement>('[data-nav-row]:not([inert] *)') ?? []),
    ];
    const index = rows.findIndex((row) => row === document.activeElement);
    if (index === -1) return;
    const rtl = document.documentElement.dir === 'rtl';
    const opens = rtl ? 'ArrowLeft' : 'ArrowRight';
    const closes = rtl ? 'ArrowRight' : 'ArrowLeft';
    const key = rows[index]?.dataset.navGroup;
    if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
      event.preventDefault();
      const step = event.key === 'ArrowDown' ? 1 : -1;
      rows[(index + step + rows.length) % rows.length]?.focus();
    } else if (event.key === 'Home' || event.key === 'End') {
      event.preventDefault();
      rows[event.key === 'Home' ? 0 : rows.length - 1]?.focus();
    } else if (key !== undefined && (event.key === opens || event.key === closes)) {
      event.preventDefault();
      toggle(key, event.key === opens);
    }
  }

  const link = (item: NavItem, nested: boolean) => {
    const active = isActive(item, pathname, home);
    const Icon = item.icon;
    const label = t(messageKey(item.labelKey));
    const count = countOf(item);
    return (
      <li key={item.href}>
        <Link
          href={item.href}
          data-nav-row=""
          onClick={onNavigate}
          aria-current={active ? 'page' : undefined}
          className={cn(
            ROW,
            nested && 'ps-6',
            active
              ? 'bg-navy-deep text-on-navy'
              : 'text-on-navy-muted hover:bg-navy-deep hover:text-on-navy',
          )}
        >
          <Icon aria-hidden="true" className="size-icon-md shrink-0" />
          <span className="flex-1">{label}</span>
          {count > 0 ? (
            <CounterBadge
              count={count}
              label={t('layout.counter', { label, count })}
              className={BADGE}
            />
          ) : null}
        </Link>
      </li>
    );
  };

  return (
    <ul ref={list} className="flex flex-col gap-1" onKeyDown={onKeyDown}>
      {entries.map((entry) => {
        if (!isGroup(entry)) return link(entry, false);
        const shown = open.has(entry.key);
        const panel = `nav-group-${entry.key}`;
        const label = t(messageKey(entry.labelKey));
        const total = entry.items.reduce((sum, item) => sum + countOf(item), 0);
        const Icon = entry.icon;
        return (
          <li key={entry.key}>
            <button
              type="button"
              data-nav-row=""
              data-nav-group={entry.key}
              aria-expanded={shown}
              aria-controls={panel}
              onClick={() => {
                toggle(entry.key);
              }}
              className={cn(
                ROW,
                entry.key === activeKey ? 'text-on-navy' : 'text-on-navy-muted',
                'hover:bg-navy-deep hover:text-on-navy',
              )}
            >
              <Icon aria-hidden="true" className="size-icon-md shrink-0" />
              <span className="flex-1 text-start">{label}</span>
              {!shown && total > 0 ? (
                <CounterBadge
                  count={total}
                  label={t('nav.groupCounter', { label, count: total })}
                  className={BADGE}
                />
              ) : null}
              <ChevronRight
                aria-hidden="true"
                className={cn(
                  'size-icon-sm shrink-0 transition-transform duration-base motion-reduce:transition-none',
                  shown ? 'rotate-90' : 'rtl:rotate-180',
                )}
              />
            </button>
            <div id={panel} className="fp-accordion" data-open={shown} inert={!shown}>
              <ul className="flex flex-col gap-1 pt-1">
                {entry.items.map((item) => link(item, true))}
              </ul>
            </div>
          </li>
        );
      })}
    </ul>
  );
}
