'use client';

import { Send } from 'lucide-react';
import { useLocale, useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, newIdempotencyKey } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { formatMillimesWithCurrency } from '@/lib/format/money';
import { parseMillimes } from '@/lib/format/money-input';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { useToast } from '@/components/ui/toast';
import type { Order } from './order-parts';

const MAX_PROOF_BYTES = 5 * 1024 * 1024;
const PROOF_TYPES = ['image/jpeg', 'image/png', 'application/pdf'];
type Field = 'transferReference' | 'transferDate' | 'amountMillimes' | 'proof';

/** Today in the user's calendar (`YYYY-MM-DD`), upper bound of the transfer date. */
function today(): string {
  const now = new Date();
  return `${String(now.getFullYear())}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
}

/** Company declares its transfer: reference, date, amount and proof (multipart, contract). */
export function DeclareTransferForm({
  order,
  onDeclared,
}: {
  order: Order;
  onDeclared: (order: Order) => void;
}) {
  const t = useTranslations('orders.declare');
  const tRoot = useTranslations();
  const locale = useLocale();
  const toast = useToast();
  const [reference, setReference] = useState('');
  const [date, setDate] = useState('');
  const [amountText, setAmountText] = useState('');
  const [file, setFile] = useState<File | undefined>(undefined);
  const [errors, setErrors] = useState<Partial<Record<Field, string>>>({});
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  // One key per intention: any change of the declaration starts a new one.
  const [intentKey, setIntentKey] = useState(newIdempotencyKey);
  const changed = () => {
    setIntentKey(newIdempotencyKey());
  };

  function validate(): Partial<Record<Field, string>> {
    const found: Partial<Record<Field, string>> = {};
    if (reference.trim() === '') found.transferReference = t('required');
    else if (reference.trim().length > 64) found.transferReference = t('tooLong');
    if (date === '') found.transferDate = t('required');
    else if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) found.transferDate = t('dateInvalid');
    else if (date > today()) found.transferDate = t('dateInFuture');
    const millimes = parseMillimes(amountText, locale);
    if (amountText.trim() === '') found.amountMillimes = t('required');
    else if (millimes === undefined || millimes === 0) found.amountMillimes = t('amountInvalid');
    if (file === undefined) found.proof = t('required');
    else if (!PROOF_TYPES.includes(file.type)) found.proof = t('fileType');
    else if (file.size > MAX_PROOF_BYTES) found.proof = t('fileTooLarge');
    return found;
  }

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const found = validate();
    setErrors(found);
    const millimes = parseMillimes(amountText, locale);
    if (Object.keys(found).length > 0 || file === undefined || millimes === undefined) return;
    const form = new FormData();
    form.set('transferReference', reference.trim());
    form.set('transferDate', date);
    form.set('amountMillimes', String(millimes));
    form.set('proof', file, file.name);
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST(
        '/v1/company/orders/{orderId}/transfer-declarations',
        {
          params: { path: { orderId: order.id }, header: { 'Idempotency-Key': intentKey } },
          // Multipart body (contract exception): the browser sets the boundary.
          body: form as never,
          bodySerializer: (body: unknown) => body as FormData,
        },
      );
      if (data !== undefined) {
        toast.notify('success', t('sentToast'));
        onDeclared(data);
        return;
      }
      const parsed = asProblem(problem);
      const details = parsed?.details as
        { errors?: { pointer: string; code: string }[] } | undefined;
      if (parsed?.code === 'PAYLOAD_TOO_LARGE') setErrors({ proof: t('fileTooLarge') });
      else if (parsed?.code === 'UNSUPPORTED_MEDIA_TYPE') setErrors({ proof: t('fileType') });
      else if (details?.errors !== undefined) {
        setErrors(
          Object.fromEntries(
            details.errors.map((item) => [
              item.pointer.slice(1),
              item.code === 'REQUIRED'
                ? t('required')
                : item.code === 'IN_FUTURE'
                  ? t('dateInFuture')
                  : item.code === 'TOO_LONG'
                    ? t('tooLong')
                    : t('amountInvalid'),
            ]),
          ),
        );
      } else setError(problem);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Card>
      <CardTitle>
        {order.proofRejectionReason === undefined ? t('title') : t('redeclare')}
      </CardTitle>
      <p className="mb-4 text-body text-text-muted">{t('description')}</p>
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <div className="grid gap-4 sm:grid-cols-2">
          <TextField
            label={t('transferReference')}
            hint={t('transferReferenceHint')}
            error={errors.transferReference}
            value={reference}
            maxLength={64}
            dir="ltr"
            autoComplete="off"
            onChange={(event) => {
              setReference(event.target.value);
              changed();
            }}
          />
          <TextField
            label={t('transferDate')}
            type="date"
            max={today()}
            error={errors.transferDate}
            value={date}
            dir="ltr"
            onChange={(event) => {
              setDate(event.target.value);
              changed();
            }}
          />
          <TextField
            label={t('amount')}
            hint={t('amountHint', {
              amount: formatMillimesWithCurrency(order.totalMillimes, locale),
            })}
            error={errors.amountMillimes}
            inputMode="decimal"
            dir="ltr"
            value={amountText}
            onChange={(event) => {
              setAmountText(event.target.value);
              changed();
            }}
          />
          <TextField
            label={t('proof')}
            hint={t('proofHint')}
            error={errors.proof}
            type="file"
            accept=".jpg,.jpeg,.png,.pdf,image/jpeg,image/png,application/pdf"
            onChange={(event) => {
              setFile(event.target.files?.[0]);
              changed();
            }}
          />
        </div>
        <div className="flex justify-end">
          <Button
            type="submit"
            loading={saving}
            icon={<Send aria-hidden="true" className="size-icon-sm" />}
          >
            {t('submit')}
          </Button>
        </div>
      </form>
    </Card>
  );
}
