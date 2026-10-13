'use client';

import { useTranslations } from 'next-intl';
import { cn } from '@/lib/cn';

export interface ChartSeries {
  readonly key: string;
  readonly label: string;
  /** Token classes of the bar (`fill-…`) and of its legend dot (`bg-…`). */
  readonly fillClass: string;
  readonly dotClass: string;
}

export interface ChartPoint {
  readonly key: string;
  readonly label: string;
  readonly values: readonly number[];
}

/**
 * Grouped bar chart (one group per period). Drawn with SVG attributes only (no inline style: strict
 * CSP), in token colours; the periods follow the reading direction (RTL). The figures are also
 * given in a visually hidden table for screen readers. An explicit empty state replaces an empty
 * chart (UX §6.5).
 */
export function BarChart({
  title,
  series,
  points,
  format,
}: {
  title: string;
  series: readonly ChartSeries[];
  points: readonly ChartPoint[];
  format: (value: number) => string;
}) {
  const t = useTranslations('ui.chart');
  const max = Math.max(0, ...points.flatMap((point) => point.values));
  if (points.length === 0 || max === 0) {
    return <p className="py-8 text-center text-body text-text-muted">{t('empty')}</p>;
  }
  const slot = 100 / series.length;
  return (
    <div className="flex flex-col gap-4">
      <ul className="flex flex-wrap gap-4" aria-hidden="true">
        {series.map((item) => (
          <li key={item.key} className="flex items-center gap-2 text-caption text-text-muted">
            <span className={cn('size-icon-sm rounded-badge', item.dotClass)} />
            {item.label}
          </li>
        ))}
      </ul>
      <div className="flex items-end gap-2 border-b border-border" aria-hidden="true">
        {points.map((point) => (
          <div key={point.key} className="flex flex-1 flex-col items-center gap-2">
            <svg
              viewBox="0 0 100 100"
              preserveAspectRatio="none"
              className="h-illustration w-full"
              focusable="false"
            >
              {point.values.map((value, index) => {
                const height = (value / max) * 100;
                const item = series[index];
                return (
                  <rect
                    key={item?.key ?? index}
                    x={index * slot + slot * 0.15}
                    y={100 - height}
                    width={slot * 0.7}
                    height={height}
                    rx={2}
                    className={item?.fillClass}
                  />
                );
              })}
            </svg>
          </div>
        ))}
      </div>
      <div className="flex gap-2" aria-hidden="true">
        {points.map((point) => (
          <span key={point.key} className="flex-1 text-center text-caption text-text-muted">
            {point.label}
          </span>
        ))}
      </div>
      <table className="sr-only">
        <caption>{t('data', { title })}</caption>
        <thead>
          <tr>
            <th scope="col">{t('month')}</th>
            {series.map((item) => (
              <th key={item.key} scope="col">
                {item.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {points.map((point) => (
            <tr key={point.key}>
              <th scope="row">{point.label}</th>
              {point.values.map((value, index) => (
                <td key={series[index]?.key ?? index}>{format(value)}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
