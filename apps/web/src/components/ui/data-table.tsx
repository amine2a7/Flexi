'use client';

import type { Schemas } from '@flexipay/api-client';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { useTranslations } from 'next-intl';
import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';
import { Button } from './button';
import { EmptyState, ErrorState, LoadingBlock } from './states';

export interface Column<Row> {
  readonly key: string;
  readonly header: string;
  readonly cell: (row: Row) => ReactNode;
  /** Amounts and figures are aligned to the end of the cell. */
  readonly align?: 'start' | 'end';
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
}: DataTableProps<Row>) {
  const t = useTranslations('ui.table');
  if (loading) return <LoadingBlock lines={5} />;
  if (error !== undefined) return <ErrorState error={error} onRetry={onRetry} />;
  if (rows === undefined || rows.length === 0) return <EmptyState {...empty} />;

  const count = page?.count;
  return (
    <div className="flex flex-col gap-4">
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
                  className={cn(
                    'px-3 py-3 text-caption font-label text-text-muted',
                    column.align === 'end' ? 'text-end' : 'text-start',
                  )}
                >
                  {column.header}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr
                key={rowKey(row)}
                className="h-table-row-height border-b border-border last:border-b-0"
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
        {rows.map((row) => (
          <li key={rowKey(row)} className="rounded-card-mobile border border-border bg-surface p-4">
            <dl className="flex flex-col gap-2">
              {columns.map((column) => (
                <div key={column.key} className="flex items-center justify-between gap-3">
                  <dt className="text-caption text-text-muted">{column.header}</dt>
                  <dd className="text-end text-body">{column.cell(row)}</dd>
                </div>
              ))}
            </dl>
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
