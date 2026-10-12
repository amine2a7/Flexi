'use client';

import * as Dialog from '@radix-ui/react-dialog';
import { X } from 'lucide-react';
import { useTranslations } from 'next-intl';
import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';
import { Button, type ButtonVariant } from './button';

interface ModalProps {
  readonly open: boolean;
  readonly onOpenChange: (open: boolean) => void;
  readonly title: string;
  readonly description?: string;
  readonly children?: ReactNode;
  readonly footer?: ReactNode;
  readonly size?: 'md' | 'lg';
  /** A modal that must be answered (e.g. an irreversible confirmation) hides the close button. */
  readonly dismissible?: boolean;
}

/** Accessible dialog (focus trapped, Escape closes, title announced) built on Radix. */
export function Modal({
  open,
  onOpenChange,
  title,
  description,
  children,
  footer,
  size = 'md',
  dismissible = true,
}: ModalProps) {
  const t = useTranslations('ui.modal');
  return (
    <Dialog.Root open={open} onOpenChange={onOpenChange}>
      <Dialog.Portal>
        <Dialog.Overlay className="fixed inset-0 z-40 bg-overlay" />
        <Dialog.Content
          className={cn(
            'fixed start-1/2 top-1/2 z-50 flex max-h-screen w-full -translate-x-1/2 -translate-y-1/2 flex-col gap-4 overflow-y-auto rounded-card-desktop bg-surface p-6 shadow-raised rtl:translate-x-1/2',
            size === 'lg' ? 'max-w-modal-max-width-lg' : 'max-w-modal-max-width',
          )}
          onEscapeKeyDown={(event) => {
            if (!dismissible) event.preventDefault();
          }}
          onPointerDownOutside={(event) => {
            if (!dismissible) event.preventDefault();
          }}
        >
          <div className="flex items-start justify-between gap-4">
            <Dialog.Title className="text-title text-text">{title}</Dialog.Title>
            {dismissible ? (
              <Dialog.Close
                aria-label={t('close')}
                className="flex size-touch-target-min items-center justify-center rounded-button text-text-muted hover:bg-bg"
              >
                <X aria-hidden="true" className="size-icon-md" />
              </Dialog.Close>
            ) : null}
          </div>
          {description !== undefined ? (
            <Dialog.Description className="text-body text-text-muted">
              {description}
            </Dialog.Description>
          ) : (
            <Dialog.Description className="sr-only">{title}</Dialog.Description>
          )}
          {children}
          {footer !== undefined ? (
            <div className="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">{footer}</div>
          ) : null}
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
}

interface ConfirmDialogProps {
  readonly open: boolean;
  readonly onOpenChange: (open: boolean) => void;
  readonly title: string;
  readonly description?: string;
  /** Verb that says the result (UX: never « OK »). */
  readonly confirmLabel: string;
  readonly confirmVariant?: ButtonVariant;
  readonly onConfirm: () => void;
  readonly loading?: boolean;
  readonly children?: ReactNode;
}

/** Confirmation before a sensitive action, with a summary of what will happen (UX-01). */
export function ConfirmDialog({
  open,
  onOpenChange,
  title,
  description,
  confirmLabel,
  confirmVariant = 'primary',
  onConfirm,
  loading = false,
  children,
}: ConfirmDialogProps) {
  const t = useTranslations('common.button');
  return (
    <Modal
      open={open}
      onOpenChange={(next) => {
        if (!loading) onOpenChange(next);
      }}
      title={title}
      description={description}
      dismissible={!loading}
      footer={
        <>
          <Button variant="secondary" onClick={() => { onOpenChange(false); }} disabled={loading}>
            {t('cancel')}
          </Button>
          <Button variant={confirmVariant} onClick={onConfirm} loading={loading}>
            {confirmLabel}
          </Button>
        </>
      }
    >
      {children}
    </Modal>
  );
}
