// Authentication end to end over HTTP (spec 01 §8 tests 1-4, 7; contract §6, §10).
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { WebClient, listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { encryptSecret } = await import('../../src/common/crypto.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { codeAt, currentStep, newSecretBase32 } = await import('../../src/auth/totp.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';
const PASSWORD = 'Rose-des-sables-2026';
/** Test-only password (fresh database, never a real account). */
const NEW_PASSWORD = 'Nouveau-mot-de-passe-2026'; // gitleaks:allow (test-only value)

beforeAll(async () => {
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

async function createUser(
  options: { mfa?: boolean; temporary?: boolean; role?: 'ADMIN' | 'COMPANY' } = {},
) {
  const email = `user-${randomUUID().slice(0, 8)}@flexipay.test`;
  const secret = newSecretBase32();
  await db.system(async (tx) =>
    tx.user.create({
      data: {
        role: options.role ?? 'ADMIN',
        subRole: 'SUPER_ADMIN',
        displayName: 'Test U.',
        email,
        passwordHash: await hashSecret(PASSWORD),
        mustChangePassword: options.temporary ?? false,
        tempPasswordExpiresAt:
          options.temporary === true ? new Date(Date.now() + 72 * 3_600_000) : null,
        mfaSecretEnc:
          options.mfa === false
            ? null
            : encryptSecret(Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64'), secret),
      },
    }),
  );
  return { email, secret };
}

/** A valid code different from the fixed demo code (so the real TOTP path is exercised). */
const totp = (secret: string, offset = 0n) => codeAt(secret, currentStep() + offset);

async function signIn(client: WebClient, email: string, secret: string) {
  const login = await client.call('POST', '/v1/auth/login', {
    body: { identifier: email, password: PASSWORD },
  });
  expect(login.status).toBe(200);
  expect(login.body.nextStep).toBe('MFA_CHALLENGE');
  const verify = await client.call('POST', '/v1/auth/mfa/verify', {
    body: { challengeId: login.body.challengeId, code: totp(secret) },
  });
  expect(verify.status).toBe(200);
  return verify;
}

describe('sign-in', () => {
  it('answers the same INVALID_CREDENTIALS for an unknown account and a wrong password', async () => {
    const { email } = await createUser();
    const client = new WebClient(base);
    const unknown = await client.call('POST', '/v1/auth/login', {
      body: { identifier: 'nobody@flexipay.test', password: PASSWORD },
    });
    const wrong = await client.call('POST', '/v1/auth/login', {
      body: { identifier: email, password: 'Wrong-password-1' },
    });
    expect(unknown.status).toBe(401);
    expect(wrong.status).toBe(401);
    const strip = (body: Record<string, unknown>) => ({ ...body, requestId: undefined });
    expect(strip(unknown.body)).toEqual(strip(wrong.body));
    expect(unknown.body.code).toBe('INVALID_CREDENTIALS');
  });

  it('opens a session only after the MFA, with HttpOnly SameSite=Strict cookies and a CSRF token', async () => {
    const { email, secret } = await createUser();
    const client = new WebClient(base);
    const login = await client.call('POST', '/v1/auth/login', {
      body: { identifier: email, password: PASSWORD },
    });
    expect(login.headers.getSetCookie()).toEqual([]);
    const bad = await client.call('POST', '/v1/auth/mfa/verify', {
      body: { challengeId: login.body.challengeId, code: totp(secret, 10n) },
    });
    expect(bad.body.code).toBe('MFA_CODE_INVALID');
    const verify = await client.call('POST', '/v1/auth/mfa/verify', {
      body: { challengeId: login.body.challengeId, code: totp(secret) },
    });
    expect(verify.status).toBe(200);
    expect(verify.body).toMatchObject({ nextStep: 'NONE', idleTimeoutSeconds: 900 });
    const cookies = verify.headers.getSetCookie().join('\n');
    expect(cookies).toMatch(/__Host-fp_at=[^;]+; .*Path=\/; .*HttpOnly; Secure; SameSite=Strict/);
    expect(cookies).toMatch(
      /__Secure-fp_rt=[^;]+; .*Path=\/v1\/auth; .*HttpOnly; Secure; SameSite=Strict/,
    );
    const me = await client.call('GET', '/v1/me');
    expect(me.status).toBe(200);
    expect(me.body).toMatchObject({
      role: 'ADMIN',
      mfa: { required: true, enrolled: true },
      onboardingTourDone: false,
    });
    // The challenge is single use.
    const replay = await client.call('POST', '/v1/auth/mfa/verify', {
      body: { challengeId: login.body.challengeId, code: totp(secret, 1n) },
    });
    expect(replay.body.code).toBe('MFA_CHALLENGE_EXPIRED');
  });

  it('locks the (account, IP) couple after 5 failures: even the right password is refused', async () => {
    const { email } = await createUser();
    const client = new WebClient(base);
    for (let index = 0; index < 5; index += 1) {
      await client.call('POST', '/v1/auth/login', {
        body: { identifier: email, password: 'Wrong-password-1' },
      });
    }
    const right = await client.call('POST', '/v1/auth/login', {
      body: { identifier: email, password: PASSWORD },
    });
    expect(right.status).toBe(401);
    expect(right.body.code).toBe('INVALID_CREDENTIALS');
  });

  it('requires the web channel header and an allowed Origin', async () => {
    const client = new WebClient(base);
    const noChannel = await client.call('POST', '/v1/auth/login', {
      body: { identifier: 'x@y.z', password: 'x' },
      headers: { 'X-FlexiPay-Client': '' },
    });
    expect(noChannel.status).toBe(400);
    const foreign = await client.call('POST', '/v1/auth/login', {
      body: { identifier: 'x@y.z', password: 'x' },
      headers: { Origin: 'https://evil.example' },
    });
    expect(foreign.body.code).toBe('CSRF_TOKEN_INVALID');
  });
});

describe('session', () => {
  it('requires the CSRF token on unsafe methods', async () => {
    const { email, secret } = await createUser();
    const client = new WebClient(base);
    await signIn(client, email, secret);
    const without = await client.call('POST', '/v1/me/onboarding-tour', { csrf: false });
    expect(without.body.code).toBe('CSRF_TOKEN_INVALID');
    const withToken = await client.call('POST', '/v1/me/onboarding-tour');
    expect(withToken.status).toBe(204);
    expect((await client.call('GET', '/v1/me')).body.onboardingTourDone).toBe(true);
  });

  it('rotates the refresh token and revokes the family when an old one is reused', async () => {
    const { email, secret } = await createUser();
    const client = new WebClient(base);
    await signIn(client, email, secret);
    const oldRefresh = client.cookie('__Secure-fp_rt') ?? '';
    const refreshed = await client.call('POST', '/v1/auth/refresh');
    expect(refreshed.status).toBe(200);
    expect(client.cookie('__Secure-fp_rt')).not.toBe(oldRefresh);
    expect((await client.call('GET', '/v1/me')).status).toBe(200);
    // A thief replays the old refresh token: refused, and the whole family is revoked.
    const thief = new WebClient(base);
    const stolen = await fetch(`${base}/v1/auth/refresh`, {
      method: 'POST',
      headers: {
        Origin: 'http://localhost:3001',
        'X-FlexiPay-Client': 'web',
        Cookie: `__Secure-fp_rt=${oldRefresh}`,
      },
    });
    expect(stolen.status).toBe(401);
    expect(thief).toBeDefined();
    await new Promise((resolve) => setTimeout(resolve, 50));
    expect((await client.call('POST', '/v1/auth/refresh')).status).toBe(401);
  });

  it('closes the session at logout', async () => {
    const { email, secret } = await createUser();
    const client = new WebClient(base);
    await signIn(client, email, secret);
    const access = client.cookie('__Host-fp_at') ?? '';
    expect((await client.call('POST', '/v1/auth/logout')).status).toBe(204);
    const after = await fetch(`${base}/v1/me`, { headers: { Cookie: `__Host-fp_at=${access}` } });
    expect(after.status).toBe(401);
  });

  it('refuses a request carrying both a cookie and an Authorization header', async () => {
    const { email, secret } = await createUser();
    const client = new WebClient(base);
    await signIn(client, email, secret);
    const both = await client.call('GET', '/v1/me', {
      headers: { Authorization: `Bearer ${'a'.repeat(43)}` },
    });
    expect(both.status).toBe(401);
  });
});

describe('first sign-in (temporary password, MFA enrolment)', () => {
  it('goes PASSWORD_CHANGE -> MFA_ENROLL -> NONE and blocks the other routes meanwhile', async () => {
    const { email } = await createUser({ temporary: true, mfa: false });
    const client = new WebClient(base);
    const login = await client.call('POST', '/v1/auth/login', {
      body: { identifier: email, password: PASSWORD },
    });
    expect(login.body).toMatchObject({ nextStep: 'PASSWORD_CHANGE' });
    expect(typeof login.body.restrictedUntil).toBe('string');
    expect((await client.call('GET', '/v1/me')).body.code).toBe('PASSWORD_CHANGE_REQUIRED');

    const weak = await client.call('POST', '/v1/auth/password/change', {
      body: { newPassword: 'court' },
    });
    expect(weak.status).toBe(400);
    expect(JSON.stringify(weak.body)).toContain('PASSWORD_POLICY_VIOLATION');
    const changed = await client.call('POST', '/v1/auth/password/change', {
      body: { newPassword: NEW_PASSWORD },
    });
    expect(changed.body.nextStep).toBe('MFA_ENROLL');
    expect((await client.call('GET', '/v1/me')).body.code).toBe('MFA_ENROLLMENT_REQUIRED');

    const enrol = await client.call('POST', '/v1/auth/mfa/enroll');
    expect(enrol.status).toBe(200);
    const secret = String(enrol.body.secretBase32);
    expect(enrol.body.otpauthUri).toMatch(/^otpauth:\/\/totp\//);
    const confirm = await client.call('POST', '/v1/auth/mfa/enroll/confirm', {
      body: { code: totp(secret) },
    });
    expect(confirm.status).toBe(200);
    expect(confirm.body.nextStep).toBe('NONE');
    expect((confirm.body.recoveryCodes as string[]).length).toBe(10);
    expect((await client.call('GET', '/v1/me')).body).toMatchObject({
      mfa: { enrolled: true, recoveryCodesRemaining: 10 },
    });

    // A recovery code works once.
    const code = (confirm.body.recoveryCodes as string[])[0];
    const other = new WebClient(base);
    const second = await other.call('POST', '/v1/auth/login', {
      body: { identifier: email, password: NEW_PASSWORD },
    });
    expect(
      (
        await other.call('POST', '/v1/auth/mfa/verify', {
          body: { challengeId: second.body.challengeId, recoveryCode: code },
        })
      ).status,
    ).toBe(200);
    const third = await other.call('POST', '/v1/auth/login', {
      body: { identifier: email, password: NEW_PASSWORD },
    });
    expect(
      (
        await other.call('POST', '/v1/auth/mfa/verify', {
          body: { challengeId: third.body.challengeId, recoveryCode: code },
        })
      ).body.code,
    ).toBe('MFA_CODE_INVALID');
  });
});
