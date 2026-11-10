'use client';

import { useLocale, useTranslations } from 'next-intl';
import { useState } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { formatMillimes } from '@/lib/format/money';
import { Amount } from '@/components/ui/amount';
import { AmountField } from '@/components/ui/amount-field';
import { Button } from '@/components/ui/button';
import { TextAreaField, TextField } from '@/components/ui/field';
import { Alert, DescriptionList } from '@/components/ui/layout-blocks';
import { Modal } from '@/components/ui/modal';
import { useToast } from '@/components/ui/toast';

function today(): string {
  const now = new Date();
  return `${String(now.getFullYear())}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
}

/**
 * Finance records the bank transfer made outside the platform (processus 6): reference, date and
 * amount, prefilled with the net; another amount needs a reason. For one payout or a whole batch
 * (every payout of the batch is then paid, bug 6).
 */
export function RecordPaymentButton({
  target,
  reference,
  netMillimes,
  onDone,
}: {
  target: { payoutId: string } | { batchId: string };
  reference: string;
  netMillimes: number;
  onDone: () => void;
}) {
  const t = useTranslations('admin.payment');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [bankReference, setBankReference] = useState('');
  const [paidOn, setPaidOn] = useState(today);
  const [amountText, setAmountText] = useState('');
  const [amount, setAmount] = useState<number | undefined>(undefined);
  const [reason, setReason] = useState('');
  const [error, setError] = useState<unknown>(undefined);
  const [sending, setSending] = useState(false);
  const [key, setKey] = useState(newIdempotencyKey);

  const differs = amount !== undefined && amount !== netMillimes;
  const missing =
    bankReference.trim() === '' ||
    paidOn === '' ||
    amount === undefined ||
    amount === 0 ||
    (differs && reason.trim() === '');

  async function confirm() {
    if (missing) return;
    setSending(true);
    setError(undefined);
    try {
      const body = {
        bankReference: bankReference.trim(),
        paidOn,
        amountMillimes: amount,
        ...(differs ? { reason: reason.trim() } : {}),
      };
      const headers = { 'Idempotency-Key': key };
      const { error: problem } =
        'batchId' in target
          ? await getApi().POST('/v1/admin/settlements/{batchId}/payment', {
              params: { path: { batchId: target.batchId }, header: headers },
              body,
            })
          : await getApi().POST('/v1/admin/payout-requests/{payoutId}/payment', {
              params: { path: { payoutId: target.payoutId }, header: headers },
              body,
            });
      if (problem !== undefined) {
        setError(problem);
        setKey(newIdempotencyKey());
        return;
      }
      toast.notify('success', t('done', { reference }));
      setOpen(false);
      onDone();
    } finally {
      setSending(false);
    }
  }

  return (
    <>
      <Button
        size="sm"
        onClick={() => {
          setAmountText(formatMillimes(netMillimes, locale));
          setAmount(netMillimes);
          setOpen(true);
        }}
      >
        {t('record')}
      </Button>
      {open ? (
        <Modal
          open
          onOpenChange={(next) => {
            if (!sending) setOpen(next);
          }}
          title={t('title', { reference })}
          dismissible={!sending}
          footer={
            <div className="flex justify-end gap-2">
              <Button
                variant="ghost"
                disabled={sending}
                onClick={() => {
                  setOpen(false);
                }}
              >
                {t('cancel')}
              </Button>
              <Button loading={sending} disabled={missing} onClick={() => void confirm()}>
                {t('confirm')}
              </Button>
            </div>
          }
        >
          <div className="flex flex-col gap-4">
            <DescriptionList
              items={[{ label: t('net'), value: <Amount millimes={netMillimes} /> }]}
            />
            {error !== undefined ? (
              <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
            ) : null}
            <TextField
              label={t('bankReference')}
              value={bankReference}
              maxLength={40}
              dir="ltr"
              autoComplete="off"
              onChange={(event) => {
                setBankReference(event.target.value);
              }}
            />
            <TextField
              label={t('paidOn')}
              type="date"
              max={today()}
              value={paidOn}
              dir="ltr"
              onChange={(event) => {
                setPaidOn(event.target.value);
              }}
            />
            <AmountField
              label={t('amount')}
              value={amountText}
              onChange={(text, millimes) => {
                setAmountText(text);
                setAmount(millimes);
              }}
            />
            {differs ? (
              <>
                <Alert tone="warning">{t('differs')}</Alert>
                <TextAreaField
                  label={t('reason')}
                  value={reason}
                  maxLength={500}
                  onChange={(event) => {
                    setReason(event.target.value);
                  }}
                />
              </>
            ) : null}
          </div>
        </Modal>
      ) : null}
    </>
  );
}
