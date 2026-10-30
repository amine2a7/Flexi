'use client';

import type { Schemas } from '@flexipay/api-client';
import { ArrowDown, ArrowUp, ArrowUpDown, ChevronLeft, ChevronRight } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { cn } from '@/lib/cn';
import { Button } from './button';
import { EmptyState, ErrorState, LoadingBlock } from './states';

export interface Column<Row> {
  readonly key: string;
  readonly header: string;
  readonly cell: (row: Row) => ReactNode;
  /** Amounts and figures are aligned to the end of the cell. */
  readonly align?: 'start' | 'end';
  /** Makes the column sortable (on the rows shown): ISO dates, amounts in millimes, references. */
  readonly sortValue?: (row: Row) => string | number;
  /**
   * Place in the mobile card: `title` (top line, no label: name, status), `footer` (bottom, no
   * label: row actions), `hidden` (table only). Default: a label / value line.
   */
  readonly card?: 'title' | 'footer' | 'hidden';
}

interface Sort {
  readonly key: string;
  readonly direction: 'ascending' | 'descending';
}

interface DataTableProps<Row> {
  readonly caption: string;
  readonly columns: readonly Column<Row>[];
  readonly rows: readonly Row[] | undefined;
  readonly rowKey: (row: Row) => string;
  readonly loading?: boolean;
  readonly error?: unknown;
  readonly onRetry?: () => void;
  readonly empty: { title: string; message?: string; action?: ReactNode };
  readonly page?: Schemas['PageInfo'];
  readonly pageNumber?: number;
  readonly onPrevious?: () => void;
  readonly onNext?: () => void;
  /** Lists to handle (admin): a row that appears when the list is refreshed is highlighted. */
  readonly highlightNew?: boolean;
}

/**
 * Table on large screens, list of cards below 768 px (UX-02). Handles loading, error and empty
 * states, the bounded result counter (contract §7) and cursor pagination.
 */
export function DataTable<Row>({
  caption,
  columns,
  rows,
  rowKey,
  loading = false,
  error,
  onRetry,
  empty,
  page,
  pageNumber = 1,
  onPrevious,
  onNext,
  highlightNew = false,
}: DataTableProps<Row>) {
  const t = useTranslations('ui.table');
  const [sort, setSort] = useState<Sort | undefined>(undefined);
  const sortedRows = useMemo(() => {
    const column = columns.find((item) => item.key === sort?.key);
    if (rows === undefined || sort === undefined || column?.sortValue === undefined) return rows;
    const value = column.sortValue;
    const factor = sort.direction === 'ascending' ? 1 : -1;
    return [...rows].sort((a, b) => {
      const left = value(a);
      const right = value(b);
      return (left < right ? -1 : left > right ? 1 : 0) * factor;
    });
  }, [columns, rows, sort]);
  const toggle = (key: string) => {
    setSort((current) =>
      current?.key === key && current.direction === 'ascending'
        ? { key, direction: 'descending' }
        : { key, direction: 'ascending' },
    );
  };
  // Animation 12: rows absent from the previous load of the same list get a fading pale green.
  const previous = useRef<Set<string> | undefined>(undefined);
  const [fresh, setFresh] = useState<ReadonlySet<string>>(new Set());
  useEffect(() => {
    if (rows === undefined) return;
    const keys = new Set(rows.map(rowKey));
    const before = previous.current;
    previous.current = keys;
    if (!highlightNew || before === undefined || ![...keys].some((key) => before.has(key))) return;
    // Rows that came with this load of the server data.

    setFresh(new Set([...keys].filter((key) => !before.has(key))));
  }, [rows, rowKey, highlightNew]);

  if (loading) return <LoadingBlock lines={5} />;
  if (error !== undefined) return <ErrorState error={error} onRetry={onRetry} />;
  if (sortedRows === undefined || sortedRows.length === 0) return <EmptyState {...empty} />;

  const count = page?.count;
  return (
    // Animation 4: the content replaces the skeleton with a fade (same layout).
    <div className="flex animate-fade flex-col gap-4">
      {count !== undefined ? (
        <p className="text-caption text-text-muted" aria-live="polite">
          {count.isLowerBound
            ? t('countMore', { count: count.value })
            : t('count', { count: count.value })}
        </p>
      ) : null}

      <div className="hidden overflow-x-auto md:block">
        <table className="w-full border-collapse text-body">
          <caption className="sr-only">{caption}</caption>
          <thead>
            <tr className="border-b border-border">
              {columns.map((column) => (
                <th
                  key={column.key}
                  scope="col"
                  aria-sort={sort?.key === column.key ? sort.direction : undefined}
                  className={cn(
                    'px-3 py-3 text-caption font-label uppercase tracking-wide text-text-muted',
                    column.align === 'end' ? 'text-end' : 'text-start',
                  )}
                >
                  {column.sortValue === undefined ? (
                    column.header
                  ) : (
                    <button
                      type="button"
                      onClick={() => {
                        toggle(column.key);
                      }}
                      aria-label={t('sortBy', { column: column.header })}
                      className={cn(
                        'inline-flex min-h-touch-target-min items-center gap-1 rounded-button uppercase tracking-wide hover:text-text',
                        column.align === 'end' ? 'flex-row-reverse' : '',
                      )}
                    >
                      {column.header}
                      {sort?.key !== column.key ? (
                        <ArrowUpDown aria-hidden="true" className="size-icon-sm" />
                      ) : sort.direction === 'ascending' ? (
                        <ArrowUp aria-hidden="true" className="size-icon-sm" />
                      ) : (
                        <ArrowDown aria-hidden="true" className="size-icon-sm" />
                      )}
                    </button>
                  )}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {sortedRows.map((row) => (
              <tr
                key={rowKey(row)}
                className={cn(
                  'h-table-row-height border-b border-border last:border-b-0 hover:bg-bg',
                  fresh.has(rowKey(row)) && 'fp-flash',
                )}
              >
                {columns.map((column) => (
                  <td
                    key={column.key}
                    className={cn('px-3 py-2', column.align === 'end' ? 'text-end' : 'text-start')}
                  >
                    {column.cell(row)}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <ul className="flex flex-col gap-3 md:hidden" aria-label={caption}>
        {sortedRows.map((row) => (
          <li
            key={rowKey(row)}
            className={cn(
              'rounded-card-mobile border border-border bg-surface p-4',
              fresh.has(rowKey(row)) && 'fp-flash',
            )}
          >
            {columns.some((column) => column.card === 'title') ? (
              <div className="mb-3 flex flex-wrap items-start justify-between gap-2">
                {columns
                  .filter((column) => column.card === 'title')
                  .map((column) => (
                    <div key={column.key}>{column.cell(row)}</div>
                  ))}
              </div>
            ) : null}
            <dl className="flex flex-col gap-2">
              {columns
                .filter((column) => column.card === undefined)
                .map((column) => (
                  <div key={column.key} className="flex items-center justify-between gap-3">
                    <dt className="text-caption text-text-muted">{column.header}</dt>
                    <dd className="text-end text-body">{column.cell(row)}</dd>
                  </div>
                ))}
            </dl>
            {columns
              .filter((column) => column.card === 'footer')
              .map((column) => (
                <div key={column.key} className="mt-3 border-t border-border pt-3">
                  {column.cell(row)}
                </div>
              ))}
          </li>
        ))}
      </ul>

      {page !== undefined && (page.hasMore || pageNumber > 1) ? (
        <nav aria-label={t('pagination')} className="flex items-center justify-between gap-3">
          <Button
            variant="secondary"
            size="sm"
            onClick={onPrevious}
            disabled={pageNumber <= 1}
            icon={<ChevronLeft aria-hidden="true" className="size-icon-sm rtl:rotate-180" />}
          >
            {t('previous')}
          </Button>
          <span className="text-caption text-text-muted">{t('page', { page: pageNumber })}</span>
          <Button
            variant="secondary"
            size="sm"
            onClick={onNext}
            disabled={!page.hasMore}
            icon={<ChevronRight aria-hidden="true" className="size-icon-sm rtl:rotate-180" />}
          >
            {t('next')}
          </Button>
        </nav>
      ) : null}
    </div>
  );
}
