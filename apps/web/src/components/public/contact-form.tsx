'use client';

import type { Schemas } from '@flexipay/api-client';
import { Check, CheckCircle2, Send } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useId, useState, type ReactNode, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { errorMessageKey, fieldErrors as readFieldErrors } from '@/lib/api/problem';
import { Button } from '@/components/ui/button';
import { SelectField, TextAreaField, TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { cn } from '@/lib/cn';

type Requester = Schemas['ContactRequesterType'];
type Field = 'name' | 'email' | 'phone' | 'requesterType' | 'message';
const REQUESTERS: readonly Requester[] = ['COMPANY', 'MERCHANT', 'OTHER'];
const INVALID = {
  name: 'invalidName',
  email: 'invalidEmail',
  phone: 'invalidPhone',
  requesterType: 'required',
  message: 'invalidMessage',
} as const;
const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/** "98 123 456" or "+216 98 123 456" -> "+21698123456" (E.164); undefined when not a number. */
export function normalizePhone(text: string): string | undefined {
  const compact = text.replace(/[\s.-]/g, '');
  const full = /^[0-9]{8}$/.test(compact) ? `+216${compact}` : compact.replace(/^00/, '+');
  return /^\+[1-9][0-9]{7,14}$/.test(full) ? full : undefined;
}

/**
 * Public "Contact us" form; the message lands in the admin "Messages" page. `ticket`: the home
 * page's « Ticket de contact » (maquette Accueil), which slides into the box once sent.
 */
export function ContactForm({ variant = 'default' }: { variant?: 'default' | 'ticket' }) {
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
  // The ticket slides into the box before the confirmation (reference kept meanwhile).
  const [slotting, setSlotting] = useState<string | undefined>(undefined);
  const set = (field: keyof typeof draft) => (value: string) => {
    setDraft((previous) => ({ ...previous, [field]: value }));
  };

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
        const fields = readFieldErrors(error);
        if (fields.length > 0) {
          const server: Partial<Record<Field, string>> = {};
          for (const item of fields) {
            const field = item.pointer.replace('/', '') as Field;
            server[field] = item.code === 'REQUIRED' ? t('required') : t(INVALID[field]);
          }
          setErrors(server);
        } else setFailure(error);
        return;
      }
      if (variant === 'ticket') setSlotting(data.reference);
      else setReference(data.reference);
    } catch (reason) {
      setFailure(reason);
    } finally {
      setSending(false);
    }
  }

  const reset = () => {
    setReference(undefined);
    setDraft({
      name: '',
      email: '',
      phone: '',
      companyName: '',
      requesterType: '',
      message: '',
    });
  };

  if (variant === 'ticket') {
    if (reference !== undefined) {
      return (
        <div
          role="status"
          className="flex animate-pop flex-col items-center gap-2.5 rounded-card-desktop border border-border bg-surface px-6 py-9 text-center"
        >
          <span className="flex size-20 items-center justify-center rounded-badge bg-emerald-soft text-emerald-text">
            <Check aria-hidden="true" className="size-10" strokeWidth={2.4} />
          </span>
          <p className="text-title text-text">{t('ticket.sentTitle')}</p>
          <p className="text-body text-text-muted">{t('ticket.sentText', { reference })}</p>
          <Button variant="secondary" className="mt-1.5" onClick={reset}>
            {t('ticket.another')}
          </Button>
        </div>
      );
    }
    return (
      <form
        onSubmit={(event) => void submit(event)}
        onAnimationEnd={(event) => {
          if (event.animationName === 'fp-slot' && slotting !== undefined) {
            setReference(slotting);
            setSlotting(undefined);
          }
        }}
        className={cn(
          'overflow-hidden rounded-card-desktop border border-paper-border bg-paper',
          slotting !== undefined && 'animate-slot',
        )}
        noValidate
      >
        <div className="flex justify-between gap-3 bg-navy px-5 py-3.5 text-on-navy">
          <span className="font-display text-title uppercase tracking-wide">
            {t('ticket.label')}
          </span>
          <span className="self-center font-ticket text-micro text-on-navy-muted">
            {t('ticket.serial')}
          </span>
        </div>
        <div className="grid gap-3.5 px-5 py-5 sm:grid-cols-2">
          {failure !== undefined ? (
            <div className="sm:col-span-2">
              <Alert tone="danger">{tRoot(messageKey(errorMessageKey(failure)))}</Alert>
            </div>
          ) : null}
          <TicketField label={t('ticket.name')} error={errors.name}>
            {(props) => (
              <input
                {...props}
                autoComplete="name"
                value={draft.name}
                onChange={(event) => {
                  set('name')(event.target.value);
                }}
              />
            )}
          </TicketField>
          <TicketField label={t('ticket.email')} error={errors.email}>
            {(props) => (
              <input
                {...props}
                type="email"
                dir="ltr"
                autoComplete="email"
                value={draft.email}
                onChange={(event) => {
                  set('email')(event.target.value);
                }}
              />
            )}
          </TicketField>
          <TicketField label={t('ticket.company')}>
            {(props) => (
              <input
                {...props}
                autoComplete="organization"
                value={draft.companyName}
                onChange={(event) => {
                  set('companyName')(event.target.value);
                }}
              />
            )}
          </TicketField>
          <TicketField label={t('ticket.type')} error={errors.requesterType}>
            {(props) => (
              <select
                {...props}
                value={draft.requesterType}
                onChange={(event) => {
                  set('requesterType')(event.target.value);
                }}
              >
                <option value="">{t('typePlaceholder')}</option>
                {REQUESTERS.map((value) => (
                  <option key={value} value={value}>
                    {t(`types.${value}`)}
                  </option>
                ))}
              </select>
            )}
          </TicketField>
          <div className="sm:col-span-2">
            <TicketField label={t('ticket.message')} error={errors.message}>
              {(props) => (
                <textarea
                  {...props}
                  rows={3}
                  maxLength={2000}
                  className={cn(props.className, 'h-auto resize-y py-2')}
                  value={draft.message}
                  onChange={(event) => {
                    set('message')(event.target.value);
                  }}
                />
              )}
            </TicketField>
          </div>
        </div>
        <div className="flex flex-wrap items-center justify-between gap-3 px-5 pb-5">
          <span className="text-caption text-paper-ink">{t('ticket.noSpam')}</span>
          <Button type="submit" loading={sending || slotting !== undefined}>
            {t('ticket.submit')}
          </Button>
        </div>
      </form>
    );
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
        <Button variant="secondary" onClick={reset}>
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
        onChange={(event) => {
          set('name')(event.target.value);
        }}
      />
      <TextField
        label={t('email')}
        type="email"
        autoComplete="email"
        dir="ltr"
        value={draft.email}
        error={errors.email}
        onChange={(event) => {
          set('email')(event.target.value);
        }}
      />
      <TextField
        label={t('phone')}
        hint={t('phoneHint')}
        type="tel"
        autoComplete="tel"
        dir="ltr"
        value={draft.phone}
        error={errors.phone}
        onChange={(event) => {
          set('phone')(event.target.value);
        }}
      />
      <TextField
        label={t('company')}
        autoComplete="organization"
        value={draft.companyName}
        onChange={(event) => {
          set('companyName')(event.target.value);
        }}
      />
      <div className="sm:col-span-2">
        <SelectField
          label={t('type')}
          placeholder={t('typePlaceholder')}
          options={REQUESTERS.map((value) => ({ value, label: t(`types.${value}`) }))}
          value={draft.requesterType}
          error={errors.requesterType}
          onChange={(event) => {
            set('requesterType')(event.target.value);
          }}
        />
      </div>
      <div className="sm:col-span-2">
        <TextAreaField
          label={t('message')}
          hint={t('messageHint')}
          maxLength={2000}
          value={draft.message}
          error={errors.message}
          onChange={(event) => {
            set('message')(event.target.value);
          }}
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

interface TicketFieldProps {
  id: string;
  className: string;
  'aria-invalid'?: true;
  'aria-describedby'?: string;
}

/** A field of the contact ticket: small capitals label, underlined control, error under it. */
function TicketField({
  label,
  error,
  children,
}: {
  label: string;
  error?: string | undefined;
  children: (props: TicketFieldProps) => ReactNode;
}) {
  const id = useId();
  const errorId = `${id}-error`;
  return (
    <div className="flex flex-col gap-1">
      <label
        htmlFor={id}
        className="text-micro font-label uppercase tracking-widest text-neutral-text"
      >
        {label}
      </label>
      {children({
        id,
        className: cn(
          'h-10 w-full border-0 border-b-2 bg-transparent text-body text-text focus:border-emerald-text focus:outline-none',
          error === undefined ? 'border-paper-ink' : 'border-danger',
        ),
        ...(error === undefined ? {} : { 'aria-invalid': true, 'aria-describedby': errorId }),
      })}
      {error === undefined ? null : (
        <p id={errorId} className="text-caption text-danger-text">
          {error}
        </p>
      )}
    </div>
  );
}
