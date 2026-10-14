'use client';

import { LockKeyhole } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type ReactNode, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { errorMessageKey } from '@/lib/api/problem';
import { Button } from '@/components/ui/button';
import { TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';

/**
 * Money action of the beneficiary: recap (amount, merchant) then the 4-digit PIN. The PIN is only
 * kept in this component state and sent once; it is cleared after every attempt.
 */
export function PinDialog({
  title,
  description,
  recap,
  confirmLabel,
  onSubmit,
  onClose,
  describe,
}: {
  title: string;
  description?: string;
  recap: ReactNode;
  confirmLabel: string;
  /** Returns the API error, or undefined on success. */
  onSubmit: (pin: string) => Promise<unknown>;
  onClose: () => void;
  /** Precise message of a known problem (e.g. balance of the type), else the generic one. */
  describe?: (error: unknown) => string | undefined;
}) {
  const t = useTranslations('beneficiary.pin');
  const tRoot = useTranslations();
  const [pin, setPin] = useState('');
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const valid = /^[0-9]{4}$/.test(pin);

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    if (!valid) return;
    setSaving(true);
    setError(undefined);
    try {
      const problem = await onSubmit(pin);
      if (problem !== undefined) setError(problem);
    } finally {
      setPin('');
      setSaving(false);
    }
  }

  return (
    <Modal
      placement="sheet"
      open
      onOpenChange={(open) => {
        if (!open && !saving) onClose();
      }}
      title={title}
      {...(description === undefined ? {} : { description })}
    >
      <form onSubmit={(event) => void submit(event)} className="flex flex-col gap-4" noValidate>
        {recap}
        {error !== undefined ? (
          <Alert tone="danger">
            {describe?.(error) ?? tRoot(messageKey(errorMessageKey(error)))}
          </Alert>
        ) : null}
        <TextField
          label={t('label')}
          hint={t('hint')}
          type="password"
          inputMode="numeric"
          autoComplete="off"
          maxLength={4}
          dir="ltr"
          value={pin}
          onChange={(event) => {
            setPin(event.target.value.replace(/\D/g, ''));
          }}
        />
        <Button
          type="submit"
          loading={saving}
          disabled={!valid}
          icon={<LockKeyhole aria-hidden="true" className="size-icon-md" />}
        >
          {confirmLabel}
        </Button>
      </form>
    </Modal>
  );
}
