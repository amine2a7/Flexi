'use client';

import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import { useLocale, useTranslations } from 'next-intl';
import { useEffect, useState, type SyntheticEvent } from 'react';
import { useRouter } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { getApi, setCsrfToken } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { formatDateTime } from '@/lib/format/date';
import { getAuthFlow, updateAuthFlow } from '@/lib/session/auth-flow';
import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/layout-blocks';
import { AuthCard } from './auth-shell';
import { PasswordFields } from './password-fields';
import { useEnterSpace } from './use-enter-space';

const WARNING_MS = 2 * 60 * 1000;

/**
 * Forced change of the temporary password (decision 4). The temporary password is not asked
 * again (decision 20): the restricted session lasts 10 minutes, whose deadline is shown from the
 * start and announced 2 minutes before (WCAG 2.2.1).
 */
export function FirstLoginForm() {
  const t = useTranslations();
  const locale = useLocale();
  const router = useRouter();
  const { enter } = useEnterSpace();
  const [password, setPassword] = useState('');
  const [confirmation, setConfirmation] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [soon, setSoon] = useState(false);
  const restrictedUntil = getAuthFlow().restrictedUntil;

  useEffect(() => {
    if (restrictedUntil === undefined) return undefined;
    const deadline = new Date(restrictedUntil).getTime();
    const timer = setInterval(() => {
      const left = deadline - Date.now();
      if (left <= 0) {
        updateAuthFlow({ passwordWindowExpired: true });
        router.replace('/login');
      } else if (left <= WARNING_MS) {
        setSoon(true);
      }
    }, 1000);
    return () => { clearInterval(timer); };
  }, [restrictedUntil, router]);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSubmitting(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/auth/password/change', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { newPassword: password },
      });
      if (data === undefined) {
        if (asProblem(problem)?.status === 401) {
          updateAuthFlow({ passwordWindowExpired: true });
          router.replace('/login');
          return;
        }
        setError(problem);
        return;
      }
      setCsrfToken(data.csrfToken);
      if (data.nextStep === 'MFA_ENROLL') router.replace('/login/mfa/activation');
      else await enter();
    } catch (reason) {
      setError(reason);
    } finally {
      setSubmitting(false);
    }
  }

  const policyError = asProblem(error)?.code === 'VALIDATION_FAILED';
  return (
    <AuthCard title={t('auth.firstLogin.title')} description={t('auth.firstLogin.description')}>
      {restrictedUntil !== undefined ? (
        <Alert tone={soon ? 'warning' : 'info'}>
          {t(soon ? 'auth.firstLogin.deadlineSoon' : 'auth.firstLogin.deadline', {
            time: formatDateTime(restrictedUntil, locale),
          })}
        </Alert>
      ) : null}
      {error !== undefined && !policyError ? (
        <Alert tone="danger">{t(messageKey(errorMessageKey(error)))}</Alert>
      ) : null}
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-5" noValidate>
        <PasswordFields
          password={password}
          confirmation={confirmation}
          onPassword={setPassword}
          onConfirmation={setConfirmation}
          serverError={policyError ? t('auth.password.policyError') : undefined}
        />
        <Button
          type="submit"
          loading={submitting}
          disabled={password === '' || password !== confirmation}
        >
          {t('auth.firstLogin.submit')}
        </Button>
      </form>
    </AuthCard>
  );
}
