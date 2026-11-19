'use client';

import type { Schemas } from '@flexipay/api-client';
import * as Dialog from '@radix-ui/react-dialog';
import { CornerDownLeft, Search, X } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import {
  useCallback,
  useEffect,
  useId,
  useMemo,
  useRef,
  useState,
  type KeyboardEvent,
} from 'react';
import { messageKey } from '@/i18n/keys';
import { useRouter } from '@/i18n/navigation';
import { getApi } from '@/lib/api/client';
import { cn } from '@/lib/cn';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { SEARCH_DELAY_MS } from '@/components/ui/filter-bar';
import type { NavItem } from './nav-config';

type Role = Schemas['Role'];
type SearchItem = Schemas['SearchItem'];
type SearchType = Schemas['SearchType'];

/** Characters typed before a search (W-SUP). */
export const SEARCH_MIN_LENGTH = 2;
const PAGE_GROUP_SIZE = 5;

interface Option {
  readonly key: string;
  readonly group: SearchType | 'PAGE';
  readonly title: string;
  readonly subtitle: string | null;
  readonly href: string;
}

/** Lower case, without accents: the menu pages are matched like the server search. */
export function normalise(text: string): string {
  return text
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .toLowerCase();
}

/** Page of an item for the session's space (a list filtered by the item when it has no page). */
export function itemHref(role: Role, item: SearchItem): string {
  const q = (text: string) => `?q=${encodeURIComponent(text)}`;
  if (role === 'ADMIN') {
    switch (item.type) {
      case 'COMPANY':
        return `/admin/entreprises/${item.id}`;
      case 'MERCHANT':
        return `/admin/commercants/${item.id}`;
      case 'USER':
        return `/admin/utilisateurs/${item.id}`;
      case 'EMPLOYEE':
        return item.parentId === null
          ? `/admin/entreprises${q(item.title)}`
          : `/admin/entreprises/${item.parentId}`;
      case 'ORDER':
        return `/admin/commandes/${item.id}`;
      case 'PAYMENT':
        return `/admin/transactions${q(item.title)}`;
      case 'PAYOUT':
        return `/admin/virements/${item.id}`;
      case 'INVOICE':
        return `/admin/factures/${item.id}`;
      case 'TICKET':
        return `/admin/support/${item.id}`;
    }
  }
  if (role === 'COMPANY') {
    switch (item.type) {
      case 'USER':
        return '/entreprise/utilisateurs';
      case 'EMPLOYEE':
        return `/entreprise/employes${q(item.title)}`;
      case 'ORDER':
        return `/entreprise/commandes/${item.id}`;
      case 'INVOICE':
        return `/entreprise/factures/${item.id}`;
      default:
        return `/entreprise/support/${item.id}`;
    }
  }
  switch (item.type) {
    case 'USER':
      return '/commercant/utilisateurs';
    case 'PAYMENT':
      return `/commercant/historique/${item.id}`;
    case 'PAYOUT':
      return `/commercant/virements/${item.id}`;
    default:
      return `/commercant/support/${item.id}`;
  }
}

type State =
  | { readonly status: 'idle' }
  | { readonly status: 'loading' }
  | { readonly status: 'error' }
  | { readonly status: 'ready'; readonly query: string; readonly result: Schemas['SearchResult'] };

/**
 * Global search of the header (W-SUP): Ctrl+K (or ⌘K) opens it; the results come while typing
 * (300 ms after the last key, 2 characters at least), grouped by kind, 5 per group, with the menu
 * pages the session may open; ↑ ↓ choose, Entrée opens, Échap closes. A complete reference
 * (CMD-, TX-, RV-, TK-) opens its item directly. The server only returns what the session may see.
 */
export function GlobalSearch({ role, pages }: { role: Role; pages: readonly NavItem[] }) {
  const t = useTranslations('support.search');
  const tRoot = useTranslations();
  const locale = useLocale();
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [text, setText] = useState('');
  const [state, setState] = useState<State>({ status: 'idle' });
  const [active, setActive] = useState(0);
  const listId = useId();
  const latest = useRef('');

  useEffect(() => {
    const onKey = (event: globalThis.KeyboardEvent) => {
      if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k') {
        event.preventDefault();
        setOpen(true);
      }
    };
    window.addEventListener('keydown', onKey);
    return () => {
      window.removeEventListener('keydown', onKey);
    };
  }, []);

  const go = useCallback(
    (href: string) => {
      setOpen(false);
      setText('');
      setState({ status: 'idle' });
      router.push(href);
    },
    [router],
  );

  // The search runs 300 ms after the last key; an older answer never replaces a newer one.
  useEffect(() => {
    const query = text.trim();
    latest.current = query;
    if (query.length < SEARCH_MIN_LENGTH) {
      // Below 2 characters there is nothing to search (no request).
      // eslint-disable-next-line react-hooks/set-state-in-effect
      setState({ status: 'idle' });
      return;
    }
    setState({ status: 'loading' });
    const timer = setTimeout(() => {
      getApi()
        .GET('/v1/search', { params: { query: { q: query } } })
        .then(({ data }) => {
          if (latest.current !== query) return;
          if (data === undefined) {
            setState({ status: 'error' });
            return;
          }
          if (data.exact !== null) {
            go(itemHref(role, data.exact));
            return;
          }
          setActive(0);
          setState({ status: 'ready', query, result: data });
        })
        .catch(() => {
          if (latest.current === query) setState({ status: 'error' });
        });
    }, SEARCH_DELAY_MS);
    return () => {
      clearTimeout(timer);
    };
  }, [text, role, go]);

  const options = useMemo((): Option[] => {
    const query = normalise(text.trim());
    if (query.length < SEARCH_MIN_LENGTH) return [];
    const menu = pages
      .map((page) => ({ page, label: tRoot(messageKey(page.labelKey)) }))
      .filter(({ label }) => normalise(label).includes(query))
      .slice(0, PAGE_GROUP_SIZE)
      .map(({ page, label }): Option => ({
        key: `PAGE:${page.href}`,
        group: 'PAGE',
        title: label,
        subtitle: null,
        href: page.href,
      }));
    const found =
      state.status === 'ready'
        ? state.result.groups.flatMap((group) =>
            group.items.map((item): Option => ({
              key: `${item.type}:${item.id}`,
              group: group.type,
              title: item.title,
              subtitle: [
                item.subtitle,
                item.amountMillimes === null
                  ? null
                  : formatMillimesWithCurrency(item.amountMillimes, locale),
              ]
                .filter((part): part is string => part !== null && part !== '')
                .join(' · '),
              href: itemHref(role, item),
            })),
          )
        : [];
    return [...menu, ...found];
  }, [text, pages, state, role, locale, tRoot]);

  const groups = useMemo(() => {
    const byGroup = new Map<Option['group'], Option[]>();
    for (const option of options)
      byGroup.set(option.group, [...(byGroup.get(option.group) ?? []), option]);
    return [...byGroup.entries()];
  }, [options]);

  function onKeyDown(event: KeyboardEvent<HTMLInputElement>) {
    if (event.key === 'ArrowDown') {
      event.preventDefault();
      setActive((index) => (options.length === 0 ? 0 : (index + 1) % options.length));
    } else if (event.key === 'ArrowUp') {
      event.preventDefault();
      setActive((index) =>
        options.length === 0 ? 0 : (index - 1 + options.length) % options.length,
      );
    } else if (event.key === 'Enter') {
      event.preventDefault();
      const option = options[active];
      if (option !== undefined) go(option.href);
    }
  }

  const query = text.trim();
  const activeOption = options[active];

  return (
    <Dialog.Root
      open={open}
      onOpenChange={(next) => {
        setOpen(next);
        if (!next) setText('');
      }}
    >
      <Dialog.Trigger
        className="flex min-h-touch-target-mobile items-center gap-2 rounded-button border border-border bg-bg px-3 text-label text-text-muted hover:border-border-strong focus-visible:focus-ring lg:min-h-touch-target-min"
        aria-label={t('label')}
        aria-keyshortcuts="Control+K Meta+K"
      >
        <Search aria-hidden="true" className="size-icon-sm" />
        <span className="hidden md:inline">{t('placeholder')}</span>
        <kbd className="hidden rounded-badge border border-border px-1 text-micro text-text-faint lg:inline">
          {t('shortcut')}
        </kbd>
      </Dialog.Trigger>
      <Dialog.Portal>
        <Dialog.Overlay className="fixed inset-0 z-40 flex items-start justify-center overflow-y-auto bg-overlay p-4 backdrop-blur-sm state-open:animate-fade sm:pt-16">
          <Dialog.Content
            className="z-50 flex w-full max-w-modal-max-width-lg flex-col gap-3 rounded-card-desktop bg-surface p-4 shadow-raised state-open:animate-zoom-in"
            aria-describedby={`${listId}-hint`}
          >
            <div className="flex items-center justify-between gap-3">
              <Dialog.Title className="text-title-sm text-text">{t('dialogTitle')}</Dialog.Title>
              <Dialog.Close
                aria-label={t('close')}
                className="flex size-touch-target-min items-center justify-center rounded-button text-text-muted hover:bg-bg focus-visible:focus-ring"
              >
                <X aria-hidden="true" className="size-icon-md" />
              </Dialog.Close>
            </div>
            <div className="flex items-center gap-2 rounded-input border border-border-strong px-3 focus-within:focus-ring">
              <Search aria-hidden="true" className="size-icon-sm text-text-muted" />
              <input
                type="search"
                role="combobox"
                aria-label={t('inputLabel')}
                aria-expanded={options.length > 0}
                aria-controls={listId}
                aria-autocomplete="list"
                aria-activedescendant={
                  activeOption === undefined ? undefined : `${listId}-${activeOption.key}`
                }
                autoComplete="off"
                maxLength={100}
                placeholder={t('placeholder')}
                className="h-input-height w-full bg-transparent text-body text-text outline-none placeholder:text-text-faint"
                value={text}
                onChange={(event) => {
                  setText(event.target.value);
                }}
                onKeyDown={onKeyDown}
              />
            </div>
            <p id={`${listId}-hint`} className="text-caption text-text-muted">
              {query.length < SEARCH_MIN_LENGTH ? t('hint') : t('keyboard')}
            </p>
            <p role="status" aria-live="polite" className="sr-only">
              {state.status === 'ready' ? t('results', { count: options.length }) : ''}
            </p>
            <div
              id={listId}
              role="listbox"
              aria-label={t('dialogTitle')}
              className="flex flex-col gap-3 overflow-y-auto"
            >
              {groups.map(([group, items]) => (
                <div key={group} role="group" aria-labelledby={`${listId}-g-${group}`}>
                  <p
                    id={`${listId}-g-${group}`}
                    className="px-2 pb-1 text-micro uppercase tracking-widest text-text-faint"
                  >
                    {t(`groups.${group}`)}
                  </p>
                  {items.map((option) => {
                    const selected = option === activeOption;
                    return (
                      <div
                        key={option.key}
                        id={`${listId}-${option.key}`}
                        role="option"
                        aria-selected={selected}
                        tabIndex={-1}
                        onMouseEnter={() => {
                          setActive(options.indexOf(option));
                        }}
                        onClick={() => {
                          go(option.href);
                        }}
                        className={cn(
                          'flex min-h-touch-target-min cursor-pointer items-center justify-between gap-3 rounded-button px-2 py-1',
                          selected ? 'bg-emerald-soft text-emerald-text' : 'text-text hover:bg-bg',
                        )}
                      >
                        <span className="flex min-w-0 flex-col">
                          <bdi className="truncate text-label">{option.title}</bdi>
                          {option.subtitle === null || option.subtitle === '' ? null : (
                            <bdi className="truncate text-caption text-text-muted">
                              {option.subtitle}
                            </bdi>
                          )}
                        </span>
                        {selected ? (
                          <CornerDownLeft
                            aria-hidden="true"
                            className="size-icon-sm shrink-0 rtl:-scale-x-100"
                          />
                        ) : null}
                      </div>
                    );
                  })}
                </div>
              ))}
              {query.length >= SEARCH_MIN_LENGTH &&
              state.status === 'loading' &&
              options.length === 0 ? (
                <p className="px-2 text-body text-text-muted">{t('loading')}</p>
              ) : null}
              {state.status === 'ready' && options.length === 0 ? (
                <p className="px-2 text-body text-text-muted">
                  {t('empty', { query: state.query })}
                </p>
              ) : null}
              {state.status === 'error' ? (
                <p className="px-2 text-body text-danger-text">{t('error')}</p>
              ) : null}
            </div>
          </Dialog.Content>
        </Dialog.Overlay>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
