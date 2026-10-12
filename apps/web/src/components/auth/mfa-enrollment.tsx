'use client';

import { WEB_CHANNEL_HEADER, type Schemas } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useEffect, useState, type SyntheticEvent } from 'react';
import { messageKey } from '@/i18n/keys';
import { getApi, setCsrfToken } from '@/lib/api/client';
import { errorMessageKey } from '@/lib/api/problem';
import { Button } from '@/components/ui/button';
import { TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { LoadingBlock } from '@/components/ui/states';
import { AuthCard } from './auth-shell';
import { useEnterSpace } from './use-enter-space';

/** Groups of 4 characters for manual entry (`JBSW Y3DP …`). */
function grouped(secret: string): string {
  return secret.replace(/(.{4})/g, '$1 ').trim();
}

/**
 * MFA enrolment: what an authenticator app is and examples (decision 19), the key to enter, the
 * confirmation code, then the 10 recovery codes shown a single time (decision 10).
 */
export function MfaEnrollment() {
  const t = useTranslations();
  const { enter } = useEnterSpace();
  const [enrollment, setEnrollment] = useState<Schemas['MfaEnrollment'] | undefined>(undefined);
  const [code, setCode] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [recoveryCodes, setRecoveryCodes] = useState<readonly string[] | undefined>(undefined);
  const [noted, setNoted] = useState(false);

  useEffect(() => {
    let active = true;
    getApi()
      .POST('/v1/auth/mfa/enroll', { params: { header: WEB_CHANNEL_HEADER } })
      .then(({ data, error: problem }) => {
        if (!active) return;
        if (data === undefined) setError(problem);
        else setEnrollment(data);
      })
      .catch((reason: unknown) => {
        if (active) setError(reason);
      });
    return () => {
      active = false;
    };
  }, []);

  async function onConfirm(event: SyntheticEvent) {
    event.preventDefault();
    setSubmitting(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/auth/mfa/enroll/confirm', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { code: code.trim() },
      });
      if (data === undefined) {
        setError(problem);
        setCode('');
        return;
      }
      setCsrfToken(data.csrfToken);
      setRecoveryCodes(data.recoveryCodes);
    } catch (reason) {
      setError(reason);
    } finally {
      setSubmitting(false);
    }
  }

  if (recoveryCodes !== undefined) {
    return (
      <AuthCard title={t('auth.recovery.title')} description={t('auth.recovery.description')}>
        <ol className="grid grid-cols-2 gap-2 rounded-card-desktop bg-bg p-4" dir="ltr">
          {recoveryCodes.map((recoveryCode) => (
            <li key={recoveryCode} className="font-title tabular-nums text-text">
              {`${recoveryCode.slice(0, 5)}-${recoveryCode.slice(5)}`}
            </li>
          ))}
        </ol>
        <Alert tone="warning">{t('auth.recovery.warning')}</Alert>
        <label className="flex items-center gap-3 text-body text-text">
          <input
            type="checkbox"
            checked={noted}
            onChange={(event) => { setNoted(event.target.checked); }}
            className="size-icon-md"
          />
          {t('auth.recovery.noted')}
        </label>
        <Button disabled={!noted} onClick={() => void enter()}>
          {t('auth.recovery.continue')}
        </Button>
      </AuthCard>
    );
  }

  return (
    <AuthCard title={t('auth.enroll.title')} description={t('auth.enroll.description')}>
      {error !== undefined ? (
        <Alert tone="danger">{t(messageKey(errorMessageKey(error)))}</Alert>
      ) : null}
      <ol className="flex flex-col gap-5">
        <li className="flex flex-col gap-2">
          <p className="text-label text-text">{t('auth.enroll.step1')}</p>
          <p className="text-body text-text-muted">{t('auth.enroll.appsExample')}</p>
        </li>
        <li className="flex flex-col gap-2">
          <p className="text-label text-text">{t('auth.enroll.step2')}</p>
          {enrollment === undefined ? (
            <LoadingBlock lines={1} />
          ) : (
            <p
              className="rounded-input bg-bg px-4 py-3 text-title-sm tabular-nums text-text"
              dir="ltr"
            >
              {grouped(enrollment.secretBase32)}
            </p>
          )}
          <p className="text-caption text-text-muted">{t('auth.enroll.keyHint')}</p>
        </li>
        <li>
          <form
            onSubmit={(event) => void onConfirm(event)}
            className="flex flex-col gap-4"
            noValidate
          >
            <TextField
              label={t('auth.enroll.step3')}
              hint={t('auth.mfa.codeHint')}
              inputMode="numeric"
              autoComplete="one-time-code"
              maxLength={6}
              value={code}
              onChange={(event) => { setCode(event.target.value.replace(/\D/g, '')); }}
            />
            <Button type="submit" loading={submitting} disabled={!/^[0-9]{6}$/.test(code)}>
              {t('auth.enroll.submit')}
            </Button>
          </form>
        </li>
      </ol>
    </AuthCard>
  );
}
