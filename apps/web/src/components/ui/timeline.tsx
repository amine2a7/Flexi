import { CircleCheck, CircleX } from 'lucide-react';
import { cn } from '@/lib/cn';

export interface TimelineEntry {
  readonly key: string;
  readonly title: string;
  /** Date and author of the step. */
  readonly meta: string;
  /** Optional reason or detail (shown in full, user content). */
  readonly detail?: string;
  readonly tone?: 'default' | 'danger';
}

/** History of a request: who did what and when, oldest first. */
export function Timeline({ entries }: { entries: readonly TimelineEntry[] }) {
  return (
    <ol className="flex flex-col">
      {entries.map((entry, index) => {
        const Icon = entry.tone === 'danger' ? CircleX : CircleCheck;
        const last = index === entries.length - 1;
        return (
          <li key={entry.key} className="flex gap-3">
            <div className="flex flex-col items-center">
              <Icon
                aria-hidden="true"
                className={cn(
                  'size-icon-md shrink-0',
                  entry.tone === 'danger' ? 'text-danger' : 'text-emerald-text',
                )}
              />
              {!last ? <span aria-hidden="true" className="flex-1 border-s border-border" /> : null}
            </div>
            <div className={cn('flex flex-col gap-1', last ? '' : 'pb-5')}>
              <span className="text-label text-text">{entry.title}</span>
              <span className="text-caption text-text-muted">{entry.meta}</span>
              {entry.detail !== undefined ? (
                <span className="text-body text-text" dir="auto">
                  {entry.detail}
                </span>
              ) : null}
            </div>
          </li>
        );
      })}
    </ol>
  );
}
