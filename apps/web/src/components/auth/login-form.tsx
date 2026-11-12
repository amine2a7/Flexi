'use client';

import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import dynamic from 'next/dynamic';
import { useSearchParams } from 'next/navigation';
import { useTranslations } from 'next-intl';
import { useEffect, useState, type SyntheticEvent } from 'react';
import { cn } from '@/lib/cn';
import { useReplay } from '@/lib/motion';
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

/** Time to read the stamp before the next screen (none when animations are reduced). */
const STAMP_MS = 600;
function readStamp(): Promise<void> {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return Promise.resolve();
  return new Promise((resolve) => {
    window.setTimeout(resolve, STAMP_MS);
  });
}

export function LoginForm() {
  const t = useTranslations();
  const router = useRouter();
  const searchParams = useSearchParams();
  const { enter, error: enterError } = useEnterSpace();
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<unknown>(undefined);
  const [missing, setMissing] = useState({ identifier: false, password: false });
  const [stamp, setStamp] = useState<'ok' | 'refused' | undefined>(undefined);
  // Each refused attempt shakes the ticket (connexion-web), a fade when motion is reduced.
  const [refusals, setRefusals] = useState(0);
  const shake = useReplay(refusals);
  const [windowExpired] = useState(() => getAuthFlow().passwordWindowExpired === true);

  useEffect(() => {
    const returnTo = safeReturnTo(searchParams.get('returnTo'));
    resetAuthFlow();
    updateAuthFlow({ returnTo });
  }, [searchParams]);

  async function onSubmit(event: SyntheticEvent) {
    event.preventDefault();
    const empty = { identifier: identifier.trim() === '', password: password === '' };
    setMissing(empty);
    if (empty.identifier || empty.password) return;
    setSubmitting(true);
    setError(undefined);
    setStamp(undefined);
    try {
      const { data, error: problem } = await getApi().POST('/v1/auth/login', {
        params: { header: WEB_CHANNEL_HEADER },
        body: { identifier, password },
      });
      if (data === undefined) {
        setError(problem);
        setPassword('');
        if (asProblem(problem)?.code === 'INVALID_CREDENTIALS') {
          setStamp('refused');
          setRefusals((count) => count + 1);
        }
        return;
      }
      setStamp('ok');
      await readStamp();
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
      <form
        onSubmit={(event) => void onSubmit(event)}
        className={cn('relative flex flex-col gap-5', shake.active && 'animate-shake')}
        onAnimationEnd={shake.onAnimationEnd}
        noValidate
      >
        {stamp !== undefined ? (
          <p
            role="status"
            className={cn(
              'pointer-events-none absolute end-4 top-1/3 z-10 -rotate-6 rounded-button border-4 bg-paper px-3 py-1 font-ticket text-title uppercase animate-pop motion-reduce:animate-none',
              stamp === 'ok'
                ? 'border-emerald-text text-emerald-text'
                : 'border-danger-text text-danger-text',
            )}
          >
            {t(`auth.login.stamp.${stamp}`)}
          </p>
        ) : null}
        <TextField
          label={t('auth.login.identifier')}
          hint={t('auth.login.identifierHint')}
          name="identifier"
          autoComplete="username"
          required
          error={missing.identifier ? t('auth.login.identifierRequired') : undefined}
          value={identifier}
          onChange={(event) => {
            setIdentifier(event.target.value);
          }}
        />
        <TextField
          label={t('auth.login.password')}
          name="password"
          type="password"
          autoComplete="current-password"
          required
          error={missing.password ? t('auth.login.passwordRequired') : undefined}
          value={password}
          onChange={(event) => {
            setPassword(event.target.value);
          }}
        />
        <Button type="submit" loading={submitting}>
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
