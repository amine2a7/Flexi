'use client';

import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import dynamic from 'next/dynamic';
import { useSearchParams } from 'next/navigation';
import { useTranslations } from 'next-intl';
import { useEffect, useState, type SyntheticEvent } from 'react';
import { Link, useRouter } from '@/i18n/navigation';
import { messageKey } from '@/i18n/keys';
import { getApi, setCsrfToken } from '@/lib/api/client';
import { asProblem, errorMessageKey } from '@/lib/api/problem';
import { getAuthFlow, resetAuthFlow, updateAuthFlow } from '@/lib/session/auth-flow';
import { safeReturnTo } from '@/lib/session/return-to';
import { Button } from '@/components/ui/button';
import { TextField } from '@/components/ui/field';
import { Alert } from '@/components/ui/layout-blocks';
import { AuthCard } from './auth-shell';
import { useEnterSpace } from './use-enter-space';

// Development only: the demo accounts panel is not even bundled in a production build
// (NODE_ENV is replaced at build time and the dynamic import becomes dead code; see test/build).
const DemoAccounts =
  process.env.NODE_ENV !== 'production'
    ? dynamic(() => import('@/components/dev/demo-accounts').then((module) => module.DemoAccounts))
    : null;

export function LoginForm() {
  const t = useTranslations();
  const router = useRouter();
  const searchParams = useSearchParams();
  const { enter, error: enterError } = useEnterSpace();
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [windowExpired] = useState(() => getAuthFlow().passwordWindowExpired === true);

  useEffect(() => {
    const returnTo = safeReturnTo(searchParams.get('returnTo'));
    resetAuthFlow();
    updateAuthFlow({ returnTo });
  }, [searchParams]);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    setSubmitting(true);
    setError(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/auth/login', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { identifier, password },
      });
      if (data === undefined) {
        setError(problem);
        setPassword('');
        return;
      }
      if (data.nextStep === 'MFA_CHALLENGE') {
        updateAuthFlow({
          challengeId: data.challengeId,
          challengeExpiresAt: data.challengeExpiresAt,
        });
        router.push('/login/mfa');
        return;
      }
      setCsrfToken(data.csrfToken);
      if (data.nextStep === 'PASSWORD_CHANGE') {
        updateAuthFlow({ restrictedUntil: data.restrictedUntil });
        router.push('/login/premiere-connexion');
      } else if (data.nextStep === 'MFA_ENROLL') {
        router.push('/login/mfa/activation');
      } else {
        await enter();
      }
    } catch (reason) {
      setError(reason);
    } finally {
      setSubmitting(false);
    }
  }

  const shownError = error ?? enterError;
  const code = asProblem(shownError)?.code;
  return (
    <AuthCard title={t('auth.login.title')} description={t('auth.login.description')}>
      {windowExpired ? <Alert tone="warning">{t('auth.firstLogin.windowExpired')}</Alert> : null}
      {shownError !== undefined ? (
        <Alert
          tone="danger"
          title={t(
            code === 'INVALID_CREDENTIALS' ? 'auth.login.invalidTitle' : 'common.state.error.title',
          )}
        >
          {code === 'INVALID_CREDENTIALS'
            ? t('auth.login.invalidMessage')
            : t(messageKey(errorMessageKey(shownError)))}
        </Alert>
      ) : null}
      <form onSubmit={(event) => void onSubmit(event)} className="flex flex-col gap-5" noValidate>
        <TextField
          label={t('auth.login.identifier')}
          hint={t('auth.login.identifierHint')}
          name="identifier"
          autoComplete="username"
          required
          value={identifier}
          onChange={(event) => { setIdentifier(event.target.value); }}
        />
        <TextField
          label={t('auth.login.password')}
          name="password"
          type="password"
          autoComplete="current-password"
          required
          value={password}
          onChange={(event) => { setPassword(event.target.value); }}
        />
        <Button
          type="submit"
          loading={submitting}
          disabled={identifier.trim() === '' || password === ''}
        >
          {t('auth.login.submit')}
        </Button>
      </form>
      <Link href="/mot-de-passe-oublie" className="text-label text-navy underline">
        {t('auth.login.forgot')}
      </Link>
      {DemoAccounts !== null ? (
        <DemoAccounts
          onPick={(account) => {
            setIdentifier(account.identifier);
            setPassword(account.password);
          }}
        />
      ) : null}
    </AuthCard>
  );
}
