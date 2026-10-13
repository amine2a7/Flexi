'use client';

import type { Schemas } from '@flexipay/api-client';
import { CheckCircle2, Send } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { Button } from '@/components/ui/button';
import { SelectField, TextAreaField, TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';

type Requester = Schemas['ContactRequesterType'];
type Field = 'name' | 'email' | 'phone' | 'requesterType' | 'message';
const REQUESTERS: readonly Requester[] = ['COMPANY', 'MERCHANT', 'OTHER'];
const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/** "98 123 456" or "+216 98 123 456" -> "+21698123456" (E.164); undefined when not a number. */
export function normalizePhone(text: string): string | undefined {
  const compact = text.replace(/[\s.-]/g, '');
  const full = /^[0-9]{8}$/.test(compact) ? `+216${compact}` : compact.replace(/^00/, '+');
  return /^\+[1-9][0-9]{7,14}$/.test(full) ? full : undefined;
}

/** Public "Contact us" form; the message lands in the admin "Messages" page. */
export function ContactForm() {
  const t = useTranslations('contact');
  const tRoot = useTranslations();
  const [draft, setDraft] = useState({
    name: '',
    email: '',
    phone: '',
    companyName: '',
    requesterType: '' as Requester | '',
    message: '',
  });
  const [errors, setErrors] = useState<Partial<Record<Field, string>>>({});
  const [failure, setFailure] = useState<unknown>(undefined);
  const [sending, setSending] = useState(false);
  const [reference, setReference] = useState<string | undefined>(undefined);
  const set = (field: keyof typeof draft) => (value: string) =>
    setDraft((previous) => ({ ...previous, [field]: value }));

  function validate(): Partial<Record<Field, string>> {
    const next: Partial<Record<Field, string>> = {};
    const name = draft.name.trim();
    if (name === '') next.name = t('required');
    else if (name.length < 2 || name.length > 120) next.name = t('invalidName');
    if (draft.email.trim() === '') next.email = t('required');
    else if (!EMAIL.test(draft.email.trim())) next.email = t('invalidEmail');
    if (draft.phone.trim() !== '' && normalizePhone(draft.phone) === undefined) {
      next.phone = t('invalidPhone');
    }
    if (draft.requesterType === '') next.requesterType = t('required');
    const message = draft.message.trim();
    if (message === '') next.message = t('required');
    else if (message.length < 10 || message.length > 2000) next.message = t('invalidMessage');
    return next;
  }

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    const found = validate();
    setErrors(found);
    setFailure(undefined);
    if (Object.keys(found).length > 0 || draft.requesterType === '') return;
    setSending(true);
    try {
      const phone = normalizePhone(draft.phone);
      const companyName = draft.companyName.trim();
      const { data, error } = await getApi().POST('/v1/public/contact-messages', {
        body: {
          name: draft.name.trim(),
          email: draft.email.trim(),
          requesterType: draft.requesterType,
          message: draft.message.trim(),
          ...(phone === undefined ? {} : { phone }),
          ...(companyName === '' ? {} : { companyName }),
        },
      });
      if (data === undefined) {
        const fields = (asProblem(error) as { errors?: { pointer?: string }[] } | undefined)
          ?.errors;
        if (fields !== undefined && fields.length > 0) {
          const server: Partial<Record<Field, string>> = {};
          for (const item of fields) {
            const field = item.pointer?.replace('/', '') as Field | undefined;
            if (field !== undefined) server[field] = t('required');
          }
          setErrors(server);
        } else setFailure(error);
        return;
      }
      setReference(data.reference);
    } catch (reason) {
      setFailure(reason);
    } finally {
      setSending(false);
    }
  }

  if (reference !== undefined) {
    return (
      <div
        role="status"
        className="flex flex-col items-start gap-4 rounded-card-desktop bg-surface p-6 shadow-card"
      >
        <CheckCircle2 aria-hidden="true" className="size-icon-lg text-emerald-text" />
        <h3 className="text-title-sm text-text">{t('sentTitle')}</h3>
        <p className="text-body text-text-muted">{t('sentText', { reference })}</p>
        <Button
          variant="secondary"
          onClick={() => {
            setReference(undefined);
            setDraft({
              name: '',
              email: '',
              phone: '',
              companyName: '',
              requesterType: '',
              message: '',
            });
          }}
        >
          {t('another')}
        </Button>
      </div>
    );
  }

  return (
    <form
      onSubmit={(event) => void submit(event)}
      className="grid gap-4 rounded-card-desktop bg-surface p-6 shadow-card sm:grid-cols-2"
      noValidate
    >
      {failure !== undefined ? (
        <div className="sm:col-span-2">
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(failure)))}</Alert>
        </div>
      ) : null}
      <TextField
        label={t('name')}
        autoComplete="name"
        value={draft.name}
        error={errors.name}
        onChange={(event) => set('name')(event.target.value)}
      />
      <TextField
        label={t('email')}
        type="email"
        autoComplete="email"
        dir="ltr"
        value={draft.email}
        error={errors.email}
        onChange={(event) => set('email')(event.target.value)}
      />
      <TextField
        label={t('phone')}
        hint={t('phoneHint')}
        type="tel"
        autoComplete="tel"
        dir="ltr"
        value={draft.phone}
        error={errors.phone}
        onChange={(event) => set('phone')(event.target.value)}
      />
      <TextField
        label={t('company')}
        autoComplete="organization"
        value={draft.companyName}
        onChange={(event) => set('companyName')(event.target.value)}
      />
      <div className="sm:col-span-2">
        <SelectField
          label={t('type')}
          placeholder={t('typePlaceholder')}
          options={REQUESTERS.map((value) => ({ value, label: t(`types.${value}`) }))}
          value={draft.requesterType}
          error={errors.requesterType}
          onChange={(event) => set('requesterType')(event.target.value)}
        />
      </div>
      <div className="sm:col-span-2">
        <TextAreaField
          label={t('message')}
          hint={t('messageHint')}
          maxLength={2000}
          value={draft.message}
          error={errors.message}
          onChange={(event) => set('message')(event.target.value)}
        />
      </div>
      <div className="sm:col-span-2">
        <Button
          type="submit"
          loading={sending}
          icon={<Send aria-hidden="true" className="size-icon-md rtl:-scale-x-100" />}
        >
          {t('submit')}
        </Button>
      </div>
    </form>
  );
}
