'use client';

import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import { KeyRound, LockKeyhole } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, setCsrfToken } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { PasswordFields } from '@/components/auth/password-fields';
import { Button } from '@/components/ui/button';
import { Card, CardTitle } from '@/components/ui/card';
import { TextField } from '@/components/ui/field';
import { Alert, PageHeader } from '@/components/ui/layout-blocks';
import { useToast } from '@/components/ui/toast';

/** Field code of a 400 VALIDATION_FAILED for one JSON pointer, if any. */
function fieldCode(error: unknown, pointer: string): string | undefined {
  const problem = asProblem(error) as
    { errors?: { pointer?: string; code?: string }[] } | undefined;
  return problem?.errors?.find((item) => item.pointer === pointer)?.code;
}

/** Security of the beneficiary: password, two-step verification (recovery codes), payment PIN. */
export default function BeneficiarySecurityPage() {
  const t = useTranslations('beneficiary.security');
  return (
    <>
      <PageHeader title={t('title')} description={t('description')} />
      <div className="grid gap-6 lg:grid-cols-2">
        <PasswordCard />
        <div className="flex flex-col gap-6">
          <PinCard />
          <MfaCard />
        </div>
      </div>
    </>
  );
}

function PasswordCard() {
  const t = useTranslations('beneficiary.security');
  const tRoot = useTranslations();
  const toast = useToast();
  const [current, setCurrent] = useState('');
  const [password, setPassword] = useState('');
  const [confirmation, setConfirmation] = useState('');
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/auth/password/change', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { currentPassword: current, newPassword: password },
      });
      if (data === undefined) {
        setError(problem);
        return;
      }
      setCsrfToken(data.csrfToken);
      setCurrent('');
      setPassword('');
      setConfirmation('');
      toast.notify('success', t('passwordChanged'));
    } finally {
      setSaving(false);
    }
  }

  const currentInvalid = fieldCode(error, '/currentPassword') === 'CURRENT_PASSWORD_INVALID';
  const policyError = fieldCode(error, '/newPassword') !== undefined;
  const otherError = error !== undefined && !currentInvalid && !policyError;
  return (
    <Card>
      <CardTitle>{t('passwordTitle')}</CardTitle>
      <form onSubmit={(event) => void submit(event)} className="flex flex-col gap-5" noValidate>
        {otherError ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <TextField
          label={t('currentPassword')}
          type="password"
          autoComplete="current-password"
          value={current}
          error={currentInvalid ? t('currentPasswordInvalid') : undefined}
          onChange={(event) => setCurrent(event.target.value)}
        />
        <PasswordFields
          password={password}
          confirmation={confirmation}
          onPassword={setPassword}
          onConfirmation={setConfirmation}
          serverError={policyError ? tRoot('auth.password.policyError') : undefined}
        />
        <Button
          type="submit"
          loading={saving}
          disabled={current === '' || password === '' || password !== confirmation}
          icon={<KeyRound aria-hidden="true" className="size-icon-md" />}
        >
          {t('changePassword')}
        </Button>
      </form>
    </Card>
  );
}

function PinCard() {
  const t = useTranslations('beneficiary.security');
  const tRoot = useTranslations();
  const toast = useToast();
  const [current, setCurrent] = useState('');
  const [next, setNext] = useState('');
  const [confirmation, setConfirmation] = useState('');
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const format = /^[0-9]{4}$/;
  const mismatch = confirmation !== '' && confirmation !== next;
  const digits = (value: string) => value.replace(/\D/g, '').slice(0, 4);

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    if (!format.test(current) || !format.test(next) || next !== confirmation) return;
    setSaving(true);
    setError(undefined);
    try {
      const { error: problem } = await getApi().POST('/v1/employee/pin', {
        body: { currentPin: current, newPin: next },
      });
      if (problem !== undefined) {
        setError(problem);
        return;
      }
      setNext('');
      setConfirmation('');
      toast.notify('success', t('pinChanged'));
    } finally {
      setCurrent('');
      setSaving(false);
    }
  }

  const pinField = {
    type: 'password',
    inputMode: 'numeric',
    autoComplete: 'off',
    maxLength: 4,
    dir: 'ltr',
  } as const;
  return (
    <Card>
      <CardTitle>{t('pinTitle')}</CardTitle>
      <form onSubmit={(event) => void submit(event)} className="flex flex-col gap-4" noValidate>
        {error !== undefined ? (
          <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
        ) : null}
        <TextField
          {...pinField}
          label={t('currentPin')}
          value={current}
          onChange={(event) => setCurrent(digits(event.target.value))}
        />
        <TextField
          {...pinField}
          label={t('newPin')}
          hint={t('pinFormat')}
          value={next}
          onChange={(event) => setNext(digits(event.target.value))}
        />
        <TextField
          {...pinField}
          label={t('confirmPin')}
          value={confirmation}
          error={mismatch ? t('pinMismatch') : undefined}
          onChange={(event) => setConfirmation(digits(event.target.value))}
        />
        <Button
          type="submit"
          loading={saving}
          disabled={!format.test(current) || !format.test(next) || next !== confirmation}
          icon={<LockKeyhole aria-hidden="true" className="size-icon-md" />}
        >
          {t('changePin')}
        </Button>
      </form>
    </Card>
  );
}

function MfaCard() {
  const t = useTranslations('beneficiary.security');
  const tRoot = useTranslations();
  const [password, setPassword] = useState('');
  const [code, setCode] = useState('');
  const [error, setError] = useState<unknown>(undefined);
  const [saving, setSaving] = useState(false);
  const [codes, setCodes] = useState<string[] | undefined>(undefined);

  async function submit(event: SyntheticEvent) {
    event.preventDefault();
    setSaving(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/auth/mfa/recovery-codes', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { currentPassword: password, currentCode: code },
      });
      if (data === undefined) {
        setError(problem);
        return;
      }
      setCodes(data.recoveryCodes);
    } finally {
      setPassword('');
      setCode('');
      setSaving(false);
    }
  }

  const currentInvalid = fieldCode(error, '/currentPassword') === 'CURRENT_PASSWORD_INVALID';
  return (
    <Card>
      <CardTitle>{t('mfaTitle')}</CardTitle>
      <div className="flex flex-col gap-4">
        <Alert tone="success">{t('mfaOn')}</Alert>
        {codes !== undefined ? (
          <div className="flex flex-col gap-3">
            <p className="text-label text-text">{t('newCodes')}</p>
            <Alert tone="warning">{t('newCodesHint')}</Alert>
            <ul className="grid grid-cols-2 gap-2 font-label tabular-nums" dir="ltr">
              {codes.map((item) => (
                <li key={item} className="rounded-button bg-bg px-3 py-2 text-center text-body">
                  {item}
                </li>
              ))}
            </ul>
          </div>
        ) : (
          <form onSubmit={(event) => void submit(event)} className="flex flex-col gap-4" noValidate>
            <p className="text-body text-text-muted">{t('recoveryHint')}</p>
            {error !== undefined && !currentInvalid ? (
              <Alert tone="danger">{tRoot(messageKey(errorMessageKey(error)))}</Alert>
            ) : null}
            <TextField
              label={t('currentPassword')}
              type="password"
              autoComplete="current-password"
              value={password}
              error={currentInvalid ? t('currentPasswordInvalid') : undefined}
              onChange={(event) => setPassword(event.target.value)}
            />
            <TextField
              label={t('currentCode')}
              inputMode="numeric"
              autoComplete="one-time-code"
              maxLength={10}
              dir="ltr"
              value={code}
              onChange={(event) => setCode(event.target.value.trim().toUpperCase())}
            />
            <Button
              type="submit"
              variant="secondary"
              loading={saving}
              disabled={password === '' || code === ''}
            >
              {t('regenerate')}
            </Button>
          </form>
        )}
      </div>
    </Card>
  );
}
