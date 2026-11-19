// M5: the mobile apps on the API. Complete till payment (till -> customer -> till) with TWO copies
// of the API on the same database: the « paid » event written by one copy reaches the till
// listening on the other one (PostgreSQL LISTEN/NOTIFY). Status by Idempotency-Key after a
// network cut, and the PIN unlock of the app (15/30/60 locks).
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, afterEach, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { codeAt, currentStep } = await import('../../src/auth/totp.js');
const { PASSWORD, createCompany, createEmployee, createUser, oneLineGrid, sealed, seedSettings } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const ledger = new LedgerService();
// Two independent API processes (own pools, own LISTEN connection), one database.
const appA = await createApp(env, false);
const appB = await createApp(env, false);
let baseA = '';
let baseB = '';
const PIN = '4826';

beforeAll(async () => {
  await seedSettings(db);
  baseA = await listen(appA);
  baseB = await listen(appB);
});
afterAll(async () => {
  await appA.close();
  await appB.close();
  await db.onModuleDestroy();
});
afterEach(async () => {
  const result = await db.system((tx) => ledger.reconcile(tx));
  expect(result.ok).toBe(true);
});

type Json = Record<string, unknown>;

/** A mobile app: bearer token, JSON in and out, on one copy of the API or the other. */
class MobileApp {
  token = '';
  constructor(readonly deviceId = `device-${randomUUID()}`) {}

  async call(base: string, method: string, path: string, body?: unknown, key?: string) {
    const response = await fetch(base + path, {
      method,
      headers: {
        ...(this.token === '' ? {} : { Authorization: `Bearer ${this.token}` }),
        ...(body === undefined ? {} : { 'Content-Type': 'application/json' }),
        ...(key === undefined ? {} : { 'Idempotency-Key': key }),
      },
      ...(body === undefined ? {} : { body: JSON.stringify(body) }),
    });
    const text = await response.text();
    return {
      status: response.status,
      headers: response.headers,
      body: (text === '' ? {} : JSON.parse(text)) as Json,
    };
  }

  /** Password, then the TOTP code for a shop account (MFA required for the merchants). */
  async signIn(base: string, user: { email: string; secret: string }, mfa: boolean) {
    const login = await this.call(base, 'POST', '/v1/mobile/auth/login', {
      identifier: user.email,
      password: PASSWORD,
      deviceId: this.deviceId,
    });
    expect(login.status).toBe(200);
    let session = login.body;
    if (mfa) {
      const verified = await this.call(base, 'POST', '/v1/mobile/auth/mfa/verify', {
        challengeId: login.body.challengeId,
        code: codeAt(user.secret, currentStep()),
        deviceId: this.deviceId,
      });
      expect(verified.status).toBe(200);
      session = verified.body;
    }
    expect(session.nextStep).toBe('NONE');
    this.token = String(session.accessToken);
  }
}

async function shop() {
  const merchant = await db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Monoprix ${randomUUID().slice(0, 5)}`,
        category: 'RESTAURANT',
        city: 'Tunis',
        phone: sealed('+21671000002'),
        email: 'shop@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: ['RESTAURATION'],
        paymentCode: String(randomInt(100_000, 999_999)),
        iban: sealed('TN5910006035183598470014'),
        commissionGrids: oneLineGrid(200),
      },
    }),
  );
  const owner = new MobileApp();
  await owner.signIn(
    baseA,
    await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Patron'),
    true,
  );
  const register = await owner.call(baseA, 'POST', '/v1/merchant/registers', { name: 'Caisse 1' });
  expect(register.status).toBe(201);
  const cashierUser = await createUser(
    db,
    env,
    'MERCHANT',
    { merchantId: merchant.id },
    'Sami C.',
    'CASHIER',
  );
  const assigned = await owner.call(
    baseA,
    'PUT',
    `/v1/merchant/cashiers/${cashierUser.id}/register`,
    { registerId: register.body.id },
  );
  expect(assigned.status).toBe(204);
  const cashier = new MobileApp();
  await cashier.signIn(baseA, cashierUser, true);
  const sticker = await owner.call(
    baseA,
    'GET',
    `/v1/merchant/registers/${String(register.body.id)}/sticker`,
  );
  return {
    owner,
    cashier,
    registerId: String(register.body.id),
    stickerUrl: new URL(String(sticker.body.url)),
  };
}

/** A beneficiary with `amount` of RESTAURATION, its PIN set, signed in on the app. */
async function beneficiary(amount: bigint, base: string) {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  await db.system(async (tx) => {
    await tx.employee.update({
      where: { id: employee.id },
      data: { pinHash: await hashSecret(PIN) },
    });
    if (amount === 0n) return;
    const posted = await ledger.post(tx, {
      type: 'ALLOCATION',
      reference: 'TEST-M5',
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount },
        { account: accounts.employeeWallet(employee.id, 'RESTAURATION'), direction: 'C', amount },
      ],
    });
    await ledger.addLot(tx, {
      account: accounts.employeeWallet(employee.id, 'RESTAURATION'),
      creditType: 'RESTAURATION',
      amount,
      expiresAt: new Date(Date.now() + 365 * 86_400_000),
      sourceTransactionId: posted.transactionId,
    });
  });
  const user = await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.');
  await db.system((tx) => tx.user.update({ where: { id: user.id }, data: { mfaSecretEnc: null } }));
  const app = new MobileApp();
  await app.signIn(base, user, false);
  return { employee, app };
}

/** Reads the Server-Sent Events of a till until `until` appears (10 s at most). */
async function readUntil(stream: Response, until: string): Promise<string> {
  const body = stream.body;
  if (body === null) throw new Error('no stream');
  const reader = body.getReader();
  const decoder = new TextDecoder();
  let text = '';
  const deadline = Date.now() + 10_000;
  while (!text.includes(until) && Date.now() < deadline) {
    const chunk = await Promise.race([
      reader.read(),
      new Promise<{ done: true; value: undefined }>((resolve) =>
        setTimeout(() => {
          resolve({ done: true, value: undefined });
        }, deadline - Date.now()),
      ),
    ]);
    if (chunk.done) break;
    text += decoder.decode(chunk.value as Uint8Array);
  }
  await reader.cancel();
  return text;
}

describe('M5: complete till payment on two copies of the API', () => {
  it('till (copy A) -> customer (copy B) -> till (copy A): « paid » arrives with the first name', async () => {
    const { cashier, registerId, stickerUrl } = await shop();
    const { employee, app } = await beneficiary(100_000n, baseB);

    // The till listens on copy A.
    const stream = await fetch(`${baseA}/v1/merchant/registers/${registerId}/checkouts/events`, {
      headers: { Authorization: `Bearer ${cashier.token}` },
    });
    expect(stream.status).toBe(200);

    // The cashier asks for 23,500 on copy A; the network cuts before the answer: the app asks
    // the status by its key (here on copy B) and finds the request, never a second one.
    const tillKey = randomUUID();
    const created = await cashier.call(
      baseA,
      'POST',
      `/v1/merchant/registers/${registerId}/checkouts`,
      { amountMillimes: 23_500, creditType: 'RESTAURATION' },
      tillKey,
    );
    expect(created.status).toBe(201);
    const byTillKey = await cashier.call(
      baseB,
      'GET',
      `/v1/merchant/checkouts/by-idempotency-key/${tillKey}`,
    );
    expect(byTillKey.status).toBe(200);
    expect(byTillKey.body.id).toBe(created.body.id);

    // The customer reads the sticker on copy B, then confirms with the PIN and its own key.
    const read = await app.call(
      baseB,
      'GET',
      `/v1/employee/checkouts/sticker/${stickerUrl.pathname.split('/').at(-1) ?? ''}?s=${String(
        stickerUrl.searchParams.get('s'),
      )}`,
    );
    expect(read.status).toBe(200);
    expect(read.body).toMatchObject({ id: created.body.id, amountMillimes: 23_500 });
    const payKey = randomUUID();
    const before = await app.call(
      baseB,
      'GET',
      `/v1/employee/checkouts/by-idempotency-key/${payKey}`,
    );
    expect(before.status).toBe(404);
    const paid = await app.call(
      baseB,
      'POST',
      `/v1/employee/checkouts/${String(created.body.id)}/confirm`,
      { pin: PIN },
      payKey,
    );
    expect(paid.status).toBe(200);
    expect(paid.body).toMatchObject({ type: 'PAYMENT', amountMillimes: 23_500 });

    // « paid » reaches the till on copy A (the change was written by copy B).
    const events = await readUntil(stream, '"PAID"');
    expect(events).toContain('"status":"PAID"');
    expect(events).toContain('"customerFirstName":"Yasmine"');
    expect(events).not.toContain('balance');

    // After a cut the app asks the status by key (any copy): the same receipt; a new attempt
    // with the same key replays it. One debit only.
    const after = await app.call(
      baseA,
      'GET',
      `/v1/employee/checkouts/by-idempotency-key/${payKey}`,
    );
    expect(after.status).toBe(200);
    expect(after.body.reference).toBe(paid.body.reference);
    const again = await app.call(
      baseA,
      'POST',
      `/v1/employee/checkouts/${String(created.body.id)}/confirm`,
      { pin: PIN },
      payKey,
    );
    expect(again.status).toBe(200);
    expect(again.headers.get('idempotent-replayed')).toBe('true');
    expect(again.body.reference).toBe(paid.body.reference);
    const left = await db.system((tx) =>
      ledger.balance(tx, accounts.employeeWallet(employee.id, 'RESTAURATION')),
    );
    expect(left).toBe(76_500n);
  });

  it('a refusal is kept with its key: the app shows the right refused screen, nothing debited', async () => {
    const { cashier, registerId } = await shop();
    const { app } = await beneficiary(1_000n, baseB);
    const created = await cashier.call(
      baseA,
      'POST',
      `/v1/merchant/registers/${registerId}/checkouts`,
      { amountMillimes: 9_000, creditType: 'RESTAURATION' },
      randomUUID(),
    );
    const byCode = await app.call(
      baseB,
      'GET',
      `/v1/employee/checkouts/code/${String(created.body.shortCode)}`,
    );
    expect(byCode.status).toBe(200);
    const key = randomUUID();
    const refused = await app.call(
      baseB,
      'POST',
      `/v1/employee/checkouts/${String(created.body.id)}/confirm`,
      { pin: PIN },
      key,
    );
    expect(refused.status).toBe(422);
    expect(refused.body.code).toBe('INSUFFICIENT_FUNDS');
    const status = await app.call(baseA, 'GET', `/v1/employee/checkouts/by-idempotency-key/${key}`);
    expect(status.status).toBe(422);
    expect(status.body.code).toBe('INSUFFICIENT_FUNDS');
    // Another user never reads this key.
    const { app: other } = await beneficiary(0n, baseA);
    expect(
      (await other.call(baseA, 'GET', `/v1/employee/checkouts/by-idempotency-key/${key}`)).status,
    ).toBe(404);
  });
});

describe('M5: PIN unlock of the app', () => {
  it('a right PIN unlocks; 3 wrong PINs lock 15 min with the same answer', async () => {
    const { app } = await beneficiary(0n, baseA);
    const ok = await app.call(baseA, 'POST', '/v1/employee/pin/verify', { pin: PIN });
    expect(ok.status).toBe(204);
    for (let attempt = 1; attempt <= 3; attempt++) {
      const wrong = await app.call(baseB, 'POST', '/v1/employee/pin/verify', { pin: '1357' });
      expect(wrong.status).toBe(403);
      expect(wrong.body.code).toBe('PIN_INVALID');
    }
    const locked = await app.call(baseA, 'POST', '/v1/employee/pin/verify', { pin: PIN });
    expect(locked.status).toBe(403);
    const details = locked.body.details as { retryAfterSeconds: number };
    expect(details.retryAfterSeconds).toBeGreaterThan(14 * 60);
    expect(details.retryAfterSeconds).toBeLessThanOrEqual(15 * 60);
    const malformed = await app.call(baseA, 'POST', '/v1/employee/pin/verify', { pin: '12' });
    expect(malformed.status).toBe(400);
  });
});
