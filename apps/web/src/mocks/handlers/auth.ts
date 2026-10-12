import type { Schemas } from '@flexipay/api-client';
import { http, HttpResponse } from 'msw';
import { currentAccount, db, type MockSession } from '../db';
import { DEMO_MFA_CODE, DEMO_RECOVERY_CODES } from '../fixtures/accounts';
import { apiUrl, latency, problem, sessionCookie, validationProblem } from './util';

type S = Schemas;

const MFA_CHALLENGE_MS = 5 * 60 * 1000; // decision 23
const RESTRICTED_MS = 10 * 60 * 1000; // decision 20
const IDLE_SECONDS = 900; // decision 18

function sessionResult(session: MockSession, role: S['Role']): S['SessionResult'] {
  const absolute = role === 'ADMIN' ? 4 * 3600_000 : 8 * 3600_000;
  const result: S['SessionResult'] = {
    nextStep: session.step,
    csrfToken: crypto.randomUUID().replaceAll('-', '') + crypto.randomUUID().replaceAll('-', ''),
    idleTimeoutSeconds: IDLE_SECONDS,
    absoluteExpiresAt: new Date(session.restrictedUntil ?? Date.now() + absolute).toISOString(),
  };
  if (session.restrictedUntil !== undefined) {
    result.restrictedUntil = new Date(session.restrictedUntil).toISOString();
  }
  return result;
}

function openSession(accountId: string, step: MockSession['step']): MockSession {
  db.session = {
    accountId,
    step,
    ...(step === 'PASSWORD_CHANGE' ? { restrictedUntil: Date.now() + RESTRICTED_MS } : {}),
  };
  return db.session;
}

function passwordProblems(password: string, identifier: string) {
  const errors: { pointer: string; code: S['FieldErrorCode'] }[] = [];
  if (
    password.length < 12 ||
    password.length > 128 ||
    password.toLowerCase() === identifier.toLowerCase()
  ) {
    errors.push({ pointer: '/newPassword', code: 'PASSWORD_POLICY_VIOLATION' });
  }
  return errors;
}

export const authHandlers = [
  http.post(apiUrl('/v1/auth/login'), async ({ request }) => {
    await latency();
    const body = (await request.json()) as S['LoginRequest'];
    const account = db.accounts.find(
      (candidate) =>
        candidate.identifier === body.identifier.trim().toLowerCase() &&
        candidate.password === body.password,
    );
    if (account === undefined) return problem(401, 'INVALID_CREDENTIALS');
    if (account.role === 'EMPLOYEE' || account.role === 'FAMILY_MEMBER')
      return problem(403, 'FORBIDDEN');
    if (account.temporaryPassword) {
      const session = openSession(account.id, 'PASSWORD_CHANGE');
      return HttpResponse.json<S['LoginResult']>(sessionResult(session, account.role), { headers: sessionCookie(session) });
    }
    if (!account.mfaEnrolled) {
      const session = openSession(account.id, 'MFA_ENROLL');
      return HttpResponse.json<S['LoginResult']>(sessionResult(session, account.role), { headers: sessionCookie(session) });
    }
    const challengeId = crypto.randomUUID();
    const expiresAt = Date.now() + MFA_CHALLENGE_MS;
    db.challenges.set(challengeId, { accountId: account.id, expiresAt });
    return HttpResponse.json<S['LoginResult']>({
      nextStep: 'MFA_CHALLENGE',
      challengeId,
      challengeExpiresAt: new Date(expiresAt).toISOString(),
    });
  }),

  http.post(apiUrl('/v1/auth/mfa/verify'), async ({ request }) => {
    await latency();
    const body = (await request.json()) as {
      challengeId: string;
      code?: string;
      recoveryCode?: string;
    };
    const challenge = db.challenges.get(body.challengeId);
    if (challenge === undefined || challenge.expiresAt < Date.now()) {
      return problem(401, 'MFA_CHALLENGE_EXPIRED');
    }
    const account = db.accounts.find((candidate) => candidate.id === challenge.accountId);
    if (account === undefined) return problem(401, 'MFA_CHALLENGE_EXPIRED');
    const recoveryIndex =
      body.recoveryCode === undefined ? -1 : account.recoveryCodes.indexOf(body.recoveryCode);
    if (body.code !== DEMO_MFA_CODE && recoveryIndex < 0) return problem(401, 'MFA_CODE_INVALID');
    if (recoveryIndex >= 0) account.recoveryCodes.splice(recoveryIndex, 1);
    db.challenges.delete(body.challengeId);
    const session = openSession(account.id, 'NONE');
    return HttpResponse.json<S['SessionResult']>(sessionResult(session, account.role), { headers: sessionCookie(session) });
  }),

  http.post(apiUrl('/v1/auth/password/change'), async ({ request }) => {
    await latency();
    const account = currentAccount();
    if (account === undefined || db.session === null) return problem(401, 'UNAUTHENTICATED');
    if (db.session.restrictedUntil !== undefined && db.session.restrictedUntil < Date.now()) {
      db.session = null;
      return problem(401, 'UNAUTHENTICATED');
    }
    const body = (await request.json()) as S['PasswordChangeRequest'];
    if (db.session.step === 'NONE' && body.currentPassword !== account.password) {
      return validationProblem([{ pointer: '/currentPassword', code: 'CURRENT_PASSWORD_INVALID' }]);
    }
    const errors = passwordProblems(body.newPassword, account.identifier);
    if (errors.length > 0) return validationProblem(errors);
    account.password = body.newPassword;
    account.temporaryPassword = false;
    const session = openSession(account.id, account.mfaEnrolled ? 'NONE' : 'MFA_ENROLL');
    return HttpResponse.json<S['SessionResult']>(sessionResult(session, account.role), { headers: sessionCookie(session) });
  }),

  http.get(apiUrl('/v1/auth/password-policy'), async () => {
    await latency();
    return HttpResponse.json<S['PasswordPolicy']>({
      rules: [
        { code: 'MIN_LENGTH', params: { min: 12 } },
        { code: 'MAX_LENGTH', params: { max: 128 } },
        { code: 'NOT_COMPROMISED' },
        { code: 'NOT_IDENTIFIER' },
      ],
    });
  }),

  http.post(apiUrl('/v1/auth/mfa/enroll'), async () => {
    await latency();
    const account = currentAccount();
    if (account === undefined) return problem(401, 'UNAUTHENTICATED');
    return HttpResponse.json<S['MfaEnrollment']>({
      otpauthUri: `otpauth://totp/FlexiPay:${account.displayName.replaceAll(' ', '')}?secret=JBSWY3DPEHPK3PXPJBSWY3DP&issuer=FlexiPay&algorithm=SHA1&digits=6&period=30`,
      secretBase32: 'JBSWY3DPEHPK3PXPJBSWY3DP',
      expiresAt: new Date(Date.now() + 10 * 60_000).toISOString(),
    });
  }),

  http.post(apiUrl('/v1/auth/mfa/enroll/confirm'), async ({ request }) => {
    await latency();
    const account = currentAccount();
    if (account === undefined || db.session === null) return problem(401, 'UNAUTHENTICATED');
    const body = (await request.json()) as S['MfaEnrollmentConfirmRequest'];
    if (body.code !== DEMO_MFA_CODE) return problem(401, 'MFA_CODE_INVALID');
    account.mfaEnrolled = true;
    account.recoveryCodes = [...DEMO_RECOVERY_CODES];
    const session = openSession(account.id, 'NONE');
    return HttpResponse.json<S['MfaEnrollmentConfirmResult']>(
      {
      ...sessionResult(session, account.role),
      recoveryCodes: [...DEMO_RECOVERY_CODES],
    },
      { headers: sessionCookie(session) },
    );
  }),

  http.post(apiUrl('/v1/auth/refresh'), async () => {
    await latency();
    const account = currentAccount();
    if (account === undefined || db.session === null) return problem(401, 'UNAUTHENTICATED');
    return HttpResponse.json<S['SessionResult']>(sessionResult(db.session, account.role));
  }),

  http.post(apiUrl('/v1/auth/logout'), async () => {
    await latency();
    db.session = null;
    return new HttpResponse(null, { status: 204, headers: sessionCookie(null) });
  }),

  http.post(apiUrl('/v1/auth/password/forgot'), async () => {
    await latency();
    // Same answer whether the account exists or not (decision 11).
    return new HttpResponse(null, { status: 202 });
  }),

  http.post(apiUrl('/v1/auth/password/reset'), async ({ request }) => {
    await latency();
    const body = (await request.json()) as { newPassword: string };
    const errors = passwordProblems(body.newPassword, '');
    if (errors.length > 0) return validationProblem(errors);
    return new HttpResponse(null, { status: 204 });
  }),

  http.get(apiUrl('/v1/me'), async () => {
    await latency();
    const account = currentAccount();
    const session = db.session;
    if (account === undefined || session === null) return problem(401, 'UNAUTHENTICATED');
    if (session.step === 'PASSWORD_CHANGE') return problem(403, 'PASSWORD_CHANGE_REQUIRED');
    if (session.step === 'MFA_ENROLL') return problem(403, 'MFA_ENROLLMENT_REQUIRED');
    return HttpResponse.json<S['Me']>({
      id: account.id,
      displayName: account.displayName,
      role: account.role,
      subRole: account.subRole,
      permissions: [...account.permissions],
      tenant: account.tenant,
      mfa: {
        required: true,
        enrolled: account.mfaEnrolled,
        recoveryCodesRemaining: account.recoveryCodes.length,
      },
    });
  }),
];
