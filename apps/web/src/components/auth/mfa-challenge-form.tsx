'use client';

import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useEffect, useState, type SyntheticEvent } from 'react';
import { Link, useRouter } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { getApi, setCsrfToken } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { getAuthFlow, updateAuthFlow } from '@/lib/session/auth-flow';
import { Button } from '@/components/ui/button';
import { TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { AuthCard } from './auth-shell';
import { useEnterSpace } from './use-enter-space';

/** Recovery code as typed: upper case, without spaces nor dashes (contract `RecoveryCode`). */
function normaliseRecoveryCode(value: string): string {
  return value.toUpperCase().replace(/[\s-]/g, '');
}

export function MfaChallengeForm() {
  const t = useTranslations();
  const router = useRouter();
  const { enter, error: enterError } = useEnterSpace();
  const [useRecovery, setUseRecovery] = useState(false);
  const [code, setCode] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  // Read once: entering the space resets the flow before the route changes, and a re-render must
  // not then send the user back to /login.
  const [challengeId] = useState(() => getAuthFlow().challengeId);

  useEffect(() => {
    if (challengeId === undefined) router.replace('/login');
  }, [challengeId, router]);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    if (challengeId === undefined) return;
    setSubmitting(true);
    setError(undefined);
    const body = useRecovery
      ? { challengeId, recoveryCode: normaliseRecoveryCode(code) }
      : { challengeId, code: code.trim() };
    try {
      const { data, error: problem } = await getApi().POST('/v1/auth/mfa/verify', {
        params: { header: WEB_CHANNEL_HEADER },
        body,
      });
      if (data === undefined) {
        setCode('');
        if (asProblem(problem)?.code === 'MFA_CHALLENGE_EXPIRED') {
          updateAuthFlow({ challengeId: undefined });
          router.replace('/login');
          return;
        }
        setError(problem);
        return;
      }
      setCsrfToken(data.csrfToken);
      await enter();
    } catch (reason) {
      setError(reason);
    } finally {
      setSubmitting(false);
    }
  }

  const shownError = error ?? enterError;
  const valid = useRecovery
    ? /^[A-HJ-NP-Z2-9]{10}$/.test(normaliseRecoveryCode(code))
    : /^[0-9]{6}$/.test(code.trim());
  return (
    <AuthCard
      title={t('auth.mfa.title')}
      description={t(useRecovery ? 'auth.mfa.recoveryDescription' : 'auth.mfa.description')}
    >
      {shownError !== undefined ? (
        <Alert tone="danger">{t(messageKey(errorMessageKey(shownError)))}</Alert>
      ) : null}
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-5" noValidate>
        {useRecovery ? (
          <TextField
            key="recovery"
            label={t('auth.mfa.recoveryLabel')}
            hint={t('auth.mfa.recoveryHint')}
            autoComplete="off"
            autoCapitalize="characters"
            spellCheck={false}
            value={code}
            onChange={(event) => {
              setCode(event.target.value);
            }}
          />
        ) : (
          <TextField
            key="totp"
            label={t('auth.mfa.codeLabel')}
            hint={t('auth.mfa.codeHint')}
            inputMode="numeric"
            autoComplete="one-time-code"
            maxLength={6}
            value={code}
            onChange={(event) => {
              setCode(event.target.value.replace(/\D/g, ''));
            }}
          />
        )}
        <Button type="submit" loading={submitting} disabled={!valid}>
          {t('auth.mfa.submit')}
        </Button>
      </form>
      <div className="flex flex-col gap-3">
        <button
          type="button"
          className="self-start text-label text-navy underline"
          onClick={() => {
            setUseRecovery((value) => !value);
            setCode('');
            setError(undefined);
          }}
        >
          {t(useRecovery ? 'auth.mfa.useTotp' : 'auth.mfa.useRecovery')}
        </button>
        <p className="text-caption text-text-muted">{t('auth.mfa.lostDevice')}</p>
        <Link href="/login" className="text-label text-navy underline">
          {t('auth.common.backToLogin')}
        </Link>
      </div>
    </AuthCard>
  );
}
