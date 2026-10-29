'use client';

import { TriangleAlert } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useId, useState, type ReactNode } from 'react';
import { errorMessageKey } from '@/lib/api/problem';
import { messageKey } from '@/i18n/keys';
import { Button, type ButtonVariant } from './button';
import { TextAreaField } from './field';
import { Alert, DescriptionList } from './layout-blocks';
import { Modal } from './modal';

/** Bounds of the contract (UserStatusChange.reason): 10 to 500 after trimming. */
export const REASON_MIN = 10;
export const REASON_MAX = 500;

interface ReasonDialogProps {
  readonly open: boolean;
  readonly onOpenChange: (open: boolean) => void;
  readonly title: string;
  readonly summary: readonly { readonly label: string; readonly value: ReactNode }[];
  /** Consequence lines, always shown (commun-statut-utilisateur.md §3.3). */
  readonly effects: readonly string[];
  /** Warning block (deactivation: grace period, irreversible). */
  readonly warnings?: readonly string[];
  readonly confirmLabel: string;
  readonly confirmVariant?: ButtonVariant;
  /** Reason the confirmation is impossible (grace period not loaded…), shown next to it. */
  readonly blockedReason?: string;
  /** Sends the change; resolves with the API error to show, or undefined when done. */
  readonly onConfirm: (reason: string) => Promise<unknown>;
}

/**
 * ReasonConfirmDialog (commun-statut-utilisateur.md §3.2): mandatory reason kept in the audit,
 * consequence always written, confirm disabled until the reason is long enough (the reason is
 * written next to the button), API error inline with the reason kept, no closing while sending.
 * Mounted only while open, so each opening starts with an empty reason.
 */
export function ReasonDialog({
  open,
  onOpenChange,
  title,
  summary,
  effects,
  warnings = [],
  confirmLabel,
  confirmVariant = 'danger',
  blockedReason,
  onConfirm,
}: ReasonDialogProps) {
  const t = useTranslations('common.reason');
  const tRoot = useTranslations();
  const [reason, setReason] = useState('');
  const [error, setError] = useState<unknown>(undefined);
  const [sending, setSending] = useState(false);
  const why = useId();

  const length = reason.trim().length;
  const tooShort = length < REASON_MIN;
  const tooLong = length > REASON_MAX;
  const blocked = blockedReason ?? (tooShort ? t('min', { min: REASON_MIN }) : undefined);

  async function confirm() {
    if (blocked !== undefined || tooLong) return;
    setSending(true);
    setError(undefined);
    try {
      const problem = await onConfirm(reason.trim());
      if (problem === undefined) onOpenChange(false);
      else setError(problem);
    } finally {
      setSending(false);
    }
  }

  return (
    <Modal
      open={open}
      onOpenChange={(next) => {
        if (!sending) onOpenChange(next);
      }}
      title={title}
      dismissible={!sending}
      footer={
        <div className="flex flex-col items-stretch gap-2 sm:flex-row sm:items-center sm:justify-end">
          {blocked !== undefined ? (
            <p id={why} className="text-caption text-text-muted">
              {blocked}
            </p>
          ) : null}
          <Button
            variant="ghost"
            disabled={sending}
            onClick={() => {
              onOpenChange(false);
            }}
          >
            {t('cancel')}
          </Button>
          <Button
            variant={confirmVariant}
            loading={sending}
            disabled={blocked !== undefined || tooLong}
            aria-describedby={blocked === undefined ? undefined : why}
            onClick={() => void confirm()}
          >
            {confirmLabel}
          </Button>
        </div>
      }
    >
      <div className="flex flex-col gap-4">
        <DescriptionList items={summary} />
        {effects.map((line) => (
          <p key={line} className="text-body text-text">
            {line}
          </p>
        ))}
        {warnings.length > 0 ? (
          <Alert tone="warning">
            <ul className="flex flex-col gap-2">
              {warnings.map((line) => (
                <li key={line} className="flex items-start gap-2">
                  <TriangleAlert aria-hidden="true" className="size-icon-sm shrink-0" />
                  {line}
                </li>
              ))}
            </ul>
          </Alert>
        ) : null}
        <TextAreaField
          label={t('label')}
          hint={`${t('hint')} ${t('counter', { count: length, max: REASON_MAX })}`}
          required
          autoFocus
          value={reason}
          disabled={sending}
          onChange={(event) => {
            setReason(event.target.value);
          }}
          {...(tooLong ? { error: t('tooLong', { max: REASON_MAX }) } : {})}
        />
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
      </div>
    </Modal>
  );
}
