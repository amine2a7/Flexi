'use client';

import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import { useTranslations } from 'next-intl';
import { useEffect, useState, type SyntheticEvent } from 'react';
import { Link } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { getApi } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { Button, buttonClasses } from '@/components/ui/button';
import { TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { AuthCard } from './auth-shell';
import { PasswordFields } from './password-fields';

/** « Mot de passe oublié » : same answer whether the account exists or not (decision 11). */
export function ForgotPasswordForm() {
  const t = useTranslations();
  const [identifier, setIdentifier] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [sent, setSent] = useState(false);
  const [error, setError] = useState<unknown>(undefined);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSubmitting(true);
    setError(undefined);
    try {
      const { response, error: problem } = await getApi().POST('/v1/auth/password/forgot', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { identifier },
      });
      if (response.ok) setSent(true);
      else setError(problem);
    } catch (reason) {
      setError(reason);
    } finally {
      setSubmitting(false);
    }
  }

  if (sent) {
    return (
      <AuthCard title={t('auth.forgot.sentTitle')} description={t('auth.forgot.sentMessage')}>
        <Link href="/login" className={buttonClasses('secondary')}>
          {t('auth.common.backToLogin')}
        </Link>
      </AuthCard>
    );
  }

  return (
    <AuthCard title={t('auth.forgot.title')} description={t('auth.forgot.description')}>
      {error !== undefined ? (
        <Alert tone="danger">{t(messageKey(errorMessageKey(error)))}</Alert>
      ) : null}
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-5" noValidate>
        <TextField
          label={t('auth.login.identifier')}
          hint={t('auth.login.identifierHint')}
          autoComplete="username"
          value={identifier}
          onChange={(event) => {
            setIdentifier(event.target.value);
          }}
        />
        <Button type="submit" loading={submitting} disabled={identifier.trim() === ''}>
          {t('auth.forgot.submit')}
        </Button>
      </form>
      <Link href="/login" className="text-label text-navy underline">
        {t('auth.common.backToLogin')}
      </Link>
    </AuthCard>
  );
}

/** New password from the e-mail link: the token is read from the URL fragment, never sent to the server in the URL. */
export function ResetPasswordForm() {
  const t = useTranslations();
  const [token, setToken] = useState<string | undefined>(undefined);
  const [ready, setReady] = useState(false);
  const [password, setPassword] = useState('');
  const [confirmation, setConfirmation] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState<unknown>(undefined);

  useEffect(() => {
    const value = new URLSearchParams(window.location.hash.slice(1)).get('token');
    // The URL fragment only exists in the browser: read once after mount.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setToken(value !== null && /^[A-Za-z0-9_-]{32,256}$/.test(value) ? value : undefined);
    // The token is no longer needed in the address bar.
    window.history.replaceState(null, '', window.location.pathname);
    setReady(true);
  }, []);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    if (token === undefined) return;
    setSubmitting(true);
    setError(undefined);
    try {
      const { response, error: problem } = await getApi().POST('/v1/auth/password/reset', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { token, newPassword: password },
      });
      if (response.ok) setDone(true);
      else setError(problem);
    } catch (reason) {
      setError(reason);
    } finally {
      setSubmitting(false);
    }
  }

  if (!ready) return null;
  if (done || token === undefined) {
    return (
      <AuthCard
        title={t(done ? 'auth.reset.doneTitle' : 'auth.reset.invalidTitle')}
        description={t(done ? 'auth.reset.doneMessage' : 'auth.reset.invalidMessage')}
      >
        <Link href={done ? '/login' : '/mot-de-passe-oublie'} className={buttonClasses('primary')}>
          {t(done ? 'auth.common.backToLogin' : 'auth.forgot.submit')}
        </Link>
      </AuthCard>
    );
  }

  const policyError = asProblem(error)?.code === 'VALIDATION_FAILED';
  return (
    <AuthCard title={t('auth.reset.title')} description={t('auth.reset.description')}>
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
          {t('auth.reset.submit')}
        </Button>
      </form>
    </AuthCard>
  );
}
