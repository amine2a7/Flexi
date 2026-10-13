'use client';

import * as Dialog from '@radix-ui/react-dialog';
import { CircleCheck, CircleX } from 'lucide-react';
import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';

/**
 * Full-screen result of an operation (collect: green accepted, red refused), readable from a
 * distance on a phone. Focus is trapped and the action closes it; never colour only (icon + text).
 */
export function ResultScreen({
  tone,
  title,
  description,
  children,
  actions,
}: {
  tone: 'success' | 'danger';
  title: string;
  description?: string;
  children?: ReactNode;
  actions: ReactNode;
}) {
  const Icon = tone === 'success' ? CircleCheck : CircleX;
  return (
    <Dialog.Root open>
      <Dialog.Portal>
        <Dialog.Content
          onEscapeKeyDown={(event) => {
            event.preventDefault();
          }}
          className={cn(
            'fixed inset-0 z-50 flex flex-col items-center justify-center gap-6 overflow-y-auto p-6 text-center',
            tone === 'success' ? 'bg-emerald text-on-emerald' : 'bg-danger text-on-danger',
          )}
        >
          <Icon aria-hidden="true" className="size-illustration" strokeWidth={1.5} />
          <Dialog.Title className="text-headline">{title}</Dialog.Title>
          {description !== undefined ? (
            <Dialog.Description className="max-w-form-max-width text-body-lg">
              {description}
            </Dialog.Description>
          ) : (
            <Dialog.Description className="sr-only">{title}</Dialog.Description>
          )}
          {children}
          <div className="flex w-full max-w-form-max-width flex-col gap-3 sm:flex-row sm:justify-center">
            {actions}
          </div>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
