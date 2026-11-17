// M4: payment by NFC sticker at the till (montage A) and mobile sessions, over HTTP, against the
// real PostgreSQL. The books are reconciled to the millime after each test.
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, afterEach, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen, type WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { encryptSecret } = await import('../../src/common/crypto.js');
const { newSecretBase32 } = await import('../../src/auth/totp.js');
const {
  PASSWORD,
  createCompany,
  createEmployee,
  createUser,
  oneLineGrid,
  sealed,
  seedSettings,
  signedIn,
} = await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const ledger = new LedgerService();
const app = await createApp(env, false);
let base = '';
const PIN = '4826';
const key = () => ({ 'Idempotency-Key': randomUUID() });

/** Item `index` of a list the test has just checked (fails loudly otherwise). */
function at<T>(list: readonly T[], index: number): T {
  const value = list[index];
  if (value === undefined) throw new Error(`missing item ${String(index)}`);
  return value;
}

beforeAll(async () => {
  await seedSettings(db);
  await db.system((tx) =>
    tx.platformSettings.update({ where: { id: 1 }, data: { maxFamilyMembers: 5 } }),
  );
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});
// The ledger stays balanced to the millime after every test (spec 02 §5).
afterEach(async () => {
  const result = await db.system((tx) => ledger.reconcile(tx));
  expect(result.totalDebits).toBe(result.totalCredits);
  expect(result.ok).toBe(true);
});

type Types = ('RESTAURATION' | 'CADEAUX' | 'CARBURANT')[];

async function createMerchant(types: Types = ['RESTAURATION']) {
  return db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Carrefour ${randomUUID().slice(0, 5)}`,
        category: 'RESTAURANT',
        city: 'La Marsa',
        phone: sealed('+21671000001'),
        email: 'shop@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: types,
        paymentCode: String(randomInt(100_000, 999_999)),
        iban: sealed('TN5910006035183598470014'),
        commissionGrids: oneLineGrid(200),
      },
    }),
  );
}

/** The owner of a new shop, signed in, with `count` tills. */
async function shopWithRegisters(count = 1, types: Types = ['RESTAURATION']) {
  const merchant = await createMerchant(types);
  const owner = await signedIn(
    base,
    await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Propriétaire'),
  );
  const registers: { id: string; publicId: string }[] = [];
  for (let i = 0; i < count; i++) {
    const created = await owner.call('POST', '/v1/merchant/registers', {
      body: { name: `Caisse ${String(i + 1)}` },
    });
    expect(created.status).toBe(201);
    registers.push({ id: String(created.body.id), publicId: String(created.body.publicId) });
  }
  return { merchant, owner, registers };
}

async function cashierOf(merchantId: string, owner: WebClient, registerId: string) {
  const user = await createUser(db, env, 'MERCHANT', { merchantId }, 'Sami C.', 'CASHIER');
  const assigned = await owner.call('PUT', `/v1/merchant/cashiers/${user.id}/register`, {
    body: { registerId },
  });
  expect(assigned.status).toBe(204);
  return signedIn(base, user);
}

/** A beneficiary with `amount` of RESTAURATION (one lot) and its PIN set. */
async function fundedEmployee(amount: bigint) {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  await db.system(async (tx) => {
    await tx.employee.update({
      where: { id: employee.id },
      data: { pinHash: await hashSecret(PIN) },
    });
    const posted = await ledger.post(tx, {
      type: 'ALLOCATION',
      reference: 'TEST-M4',
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
  return { company, employee, client: await signedIn(base, user) };
}

const balance = (employeeId: string) =>
  db.system((tx) => ledger.balance(tx, accounts.employeeWallet(employeeId, 'RESTAURATION')));

async function checkout(
  client: WebClient,
  registerId: string,
  amountMillimes: number,
  type = 'RESTAURATION',
) {
  return client.call('POST', `/v1/merchant/registers/${registerId}/checkouts`, {
    body: { amountMillimes, creditType: type },
    headers: key(),
  });
}

const confirm = (client: WebClient, checkoutId: string) =>
  client.call('POST', `/v1/employee/checkouts/${checkoutId}/confirm`, {
    body: { pin: PIN },
    headers: key(),
  });

describe('till checkout (NFC sticker)', () => {
  it('runs the circuit: sticker, request, confirmation, real-time result with the first name', async () => {
    const { merchant, owner, registers } = await shopWithRegisters();
    const register = at(registers, 0);
    const cashier = await cashierOf(merchant.id, owner, register.id);
    const { employee, client } = await fundedEmployee(100_000n);

    const sticker = await owner.call('GET', `/v1/merchant/registers/${register.id}/sticker`);
    expect(sticker.status).toBe(200);
    const url = new URL(String(sticker.body.url));
    expect(url.origin + url.pathname).toBe(`https://pay.flexipay.tn/c/${register.publicId}`);
    const pdf = await owner.call('GET', `/v1/merchant/registers/${register.id}/sticker/pdf`);
    expect(pdf.status).toBe(200);
    expect(pdf.headers.get('content-type')).toBe('application/pdf');

    // The cashier opens the real-time stream of its till, then asks for 57,500.
    const stream = await fetch(`${base}/v1/merchant/registers/${register.id}/checkouts/events`, {
      headers: { Cookie: cashier.cookieHeader('/v1/merchant'), Origin: 'http://localhost:3001' },
    });
    expect(stream.status).toBe(200);
    const streamBody = stream.body;
    if (streamBody === null) throw new Error('no stream');
    const reader = streamBody.getReader();
    const created = await checkout(cashier, register.id, 57_500);
    expect(created.status).toBe(201);
    expect(created.body).toMatchObject({ status: 'PENDING', amountMillimes: 57_500 });
    expect(String(created.body.shortCode)).toMatch(/^[0-9]{4}$/);
    const remaining = Date.parse(String(created.body.expiresAt)) - Date.now();
    expect(remaining).toBeGreaterThan(110_000);
    expect(remaining).toBeLessThanOrEqual(120_000);

    // The customer reads the sticker, or types the short code: same request, no balance shown.
    const read = await client.call(
      'GET',
      `/v1/employee/checkouts/sticker/${register.publicId}?s=${String(url.searchParams.get('s'))}`,
    );
    expect(read.status).toBe(200);
    expect(read.body).toMatchObject({
      id: created.body.id,
      merchantName: merchant.name,
      registerName: 'Caisse 1',
      amountMillimes: 57_500,
      creditType: 'RESTAURATION',
    });
    const typed = await client.call(
      'GET',
      `/v1/employee/checkouts/code/${String(created.body.shortCode)}`,
    );
    expect(typed.body.id).toBe(created.body.id);

    const paid = await confirm(client, String(created.body.id));
    expect(paid.status).toBe(200);
    expect(paid.body).toMatchObject({
      type: 'PAYMENT',
      amountMillimes: 57_500,
      balanceAfterMillimes: 42_500,
    });
    expect(await balance(employee.id)).toBe(42_500n);

    // Real time: the cashier sees PAID with the first name of the customer.
    const decoder = new TextDecoder();
    let text = '';
    const deadline = Date.now() + 10_000;
    while (!text.includes('"PAID"') && Date.now() < deadline) {
      const chunk = await reader.read();
      if (chunk.done) break;
      text += decoder.decode(chunk.value as Uint8Array);
    }
    await reader.cancel();
    expect(text).toContain('"status":"PAID"');
    expect(text).toContain('"customerFirstName":"Yasmine"');
    expect(text).not.toContain('balance');

    // Status by Idempotency-Key, and an outbox event written with the payment.
    const outbox = await db.system((tx) =>
      tx.outboxEvent.findMany({ where: { aggregateId: String(created.body.id) } }),
    );
    expect(outbox.map((event) => event.topic).sort()).toEqual([
      'checkout.created',
      'checkout.paid',
    ]);
  });

  it('20 confirmations in parallel on the same balance never make it negative', async () => {
    const { owner, registers } = await shopWithRegisters(20);
    const { employee, client } = await fundedEmployee(100_000n);
    const requests = await Promise.all(registers.map((r) => checkout(owner, r.id, 10_000)));
    expect(requests.every((r) => r.status === 201)).toBe(true);
    const results = await Promise.all(requests.map((r) => confirm(client, String(r.body.id))));
    const ok = results.filter((r) => r.status === 200).length;
    // At most 10 × 10 TND out of 100 TND; the others are refused (balance, or PIN attempts in flight).
    expect(ok).toBeGreaterThan(0);
    expect(ok).toBeLessThanOrEqual(10);
    for (const r of results.filter((x) => x.status !== 200)) {
      expect([403, 409, 422]).toContain(r.status);
    }
    const left = await balance(employee.id);
    expect(left).toBeGreaterThanOrEqual(0n);
    expect(left).toBe(100_000n - BigInt(ok) * 10_000n);
    const paidCount = await db.system((tx) =>
      tx.checkout.count({
        where: { registerId: { in: registers.map((r) => r.id) }, status: 'PAID' },
      }),
    );
    expect(paidCount).toBe(ok);
  });

  it('two customers confirm the same request at the same time: one pays, the other is told « already paid »', async () => {
    const { owner, registers } = await shopWithRegisters();
    const first = await fundedEmployee(100_000n);
    const second = await fundedEmployee(100_000n);
    const created = await checkout(owner, at(registers, 0).id, 30_000);
    const [a, b] = await Promise.all([
      confirm(first.client, String(created.body.id)),
      confirm(second.client, String(created.body.id)),
    ]);
    const statuses = [a.status, b.status].sort();
    expect(statuses).toEqual([200, 422]);
    const loser = a.status === 422 ? a : b;
    expect(loser.body).toMatchObject({
      code: 'CHECKOUT_REFUSED',
      details: { reason: 'ALREADY_PAID' },
    });
    const balances = [await balance(first.employee.id), await balance(second.employee.id)].sort();
    expect(balances).toEqual([70_000n, 100_000n]);
  });

  it('a refusal (insufficient balance) is shown to the till with the first name, the request stays open', async () => {
    const { owner, registers } = await shopWithRegisters();
    const { employee, client } = await fundedEmployee(20_000n);
    const headers = key();
    const created = await owner.call(
      'POST',
      `/v1/merchant/registers/${at(registers, 0).id}/checkouts`,
      {
        body: { amountMillimes: 50_000, creditType: 'RESTAURATION' },
        headers,
      },
    );
    const refusedPayment = await confirm(client, String(created.body.id));
    expect(refusedPayment.status).toBe(422);
    expect(refusedPayment.body).toMatchObject({
      code: 'INSUFFICIENT_FUNDS',
      details: { missingMillimes: 30_000 },
    });
    const status = await owner.call(
      'GET',
      `/v1/merchant/checkouts/by-idempotency-key/${headers['Idempotency-Key']}`,
    );
    expect(status.body).toMatchObject({
      status: 'PENDING',
      lastRefusal: { code: 'INSUFFICIENT_FUNDS', customerFirstName: 'Yasmine' },
    });
    // The till never learns the missing amount or the balance.
    expect(JSON.stringify(status.body)).not.toContain('30000');
    expect(await balance(employee.id)).toBe(20_000n);
  });

  it('the same Idempotency-Key twice creates one request', async () => {
    const { owner, registers } = await shopWithRegisters();
    const headers = key();
    const body = { amountMillimes: 12_000, creditType: 'RESTAURATION' };
    const path = `/v1/merchant/registers/${at(registers, 0).id}/checkouts`;
    const first = await owner.call('POST', path, { body, headers });
    const second = await owner.call('POST', path, { body, headers });
    expect(first.status).toBe(201);
    expect(second.status).toBe(201);
    expect(second.headers.get('idempotent-replayed')).toBe('true');
    expect(second.body.id).toBe(first.body.id);
    const count = await db.system((tx) =>
      tx.checkout.count({ where: { registerId: at(registers, 0).id } }),
    );
    expect(count).toBe(1);
    const status = await owner.call(
      'GET',
      `/v1/merchant/checkouts/by-idempotency-key/${headers['Idempotency-Key']}`,
    );
    expect(status.body).toMatchObject({ id: first.body.id, status: 'PENDING' });
  });

  it('a cancelled or expired request is refused, and a new request cancels the previous one', async () => {
    const { owner, registers } = await shopWithRegisters();
    const { employee, client } = await fundedEmployee(100_000n);
    const first = await checkout(owner, at(registers, 0).id, 10_000);
    const second = await checkout(owner, at(registers, 0).id, 11_000);
    // One active request per till: the first one is cancelled.
    const old = await confirm(client, String(first.body.id));
    expect(old.body).toMatchObject({
      code: 'CHECKOUT_REFUSED',
      details: { reason: 'CHECKOUT_EXPIRED' },
    });
    const cancelled = await owner.call(
      'POST',
      `/v1/merchant/checkouts/${String(second.body.id)}/cancel`,
    );
    expect(cancelled.body.status).toBe('CANCELLED');
    expect((await confirm(client, String(second.body.id))).body).toMatchObject({
      details: { reason: 'CHECKOUT_EXPIRED' },
    });
    const third = await checkout(owner, at(registers, 0).id, 12_000);
    await db.system((tx) =>
      tx.checkout.update({
        where: { id: String(third.body.id) },
        data: { expiresAt: new Date(Date.now() - 1_000) },
      }),
    );
    expect((await confirm(client, String(third.body.id))).body).toMatchObject({
      details: { reason: 'CHECKOUT_EXPIRED' },
    });
    expect(await balance(employee.id)).toBe(100_000n);
  });

  it('a sticker with a wrong signature, or the signature of another shop, is refused', async () => {
    const a = await shopWithRegisters();
    const b = await shopWithRegisters();
    const { client } = await fundedEmployee(10_000n);
    await checkout(a.owner, at(a.registers, 0).id, 5_000);
    const signatureOf = async (owner: WebClient, registerId: string) =>
      new URL(
        String((await owner.call('GET', `/v1/merchant/registers/${registerId}/sticker`)).body.url),
      ).searchParams.get('s') ?? '';
    const forged = await client.call(
      'GET',
      `/v1/employee/checkouts/sticker/${at(a.registers, 0).publicId}?s=${'A'.repeat(32)}`,
    );
    expect(forged.body).toMatchObject({
      code: 'CHECKOUT_REFUSED',
      details: { reason: 'STICKER_INVALID' },
    });
    const mixed = await client.call(
      'GET',
      `/v1/employee/checkouts/sticker/${at(a.registers, 0).publicId}?s=${await signatureOf(b.owner, at(b.registers, 0).id)}`,
    );
    expect(mixed.body).toMatchObject({ details: { reason: 'STICKER_INVALID' } });
  });

  it('refuses an amount of 0, negative or with a fraction of millime', async () => {
    const { owner, registers } = await shopWithRegisters();
    for (const amount of [0, -5_000, 57_500.5, 57.5005]) {
      const r = await owner.call(
        'POST',
        `/v1/merchant/registers/${at(registers, 0).id}/checkouts`,
        {
          body: { amountMillimes: amount, creditType: 'RESTAURATION' },
          headers: key(),
        },
      );
      expect(r.status).toBe(400);
      expect(r.body.code).toBe('VALIDATION_FAILED');
    }
  });

  it('two simultaneous payments over the family cap: only one goes through', async () => {
    const holder = await fundedEmployee(200_000n);
    const created = await holder.client.call('POST', '/v1/employee/family/members', {
      body: { firstName: 'Adam', lastName: 'Jebali', relationship: 'CHILD', phone: '+21698123456' },
    });
    const memberId = String(created.body.id);
    const transfer = await holder.client.call('POST', '/v1/employee/family/transfers', {
      headers: key(),
      body: {
        memberId,
        creditType: 'RESTAURATION',
        amountMillimes: 50_000,
        dailyLimitMillimes: 20_000,
        endsOn: null,
      },
    });
    expect(transfer.status).toBe(201);
    const secret = newSecretBase32();
    const user = await db.system(async (tx) => {
      await tx.employee.update({
        where: { id: memberId },
        data: { pinHash: await hashSecret(PIN) },
      });
      const found = await tx.user.findFirstOrThrow({ where: { employeeId: memberId } });
      return tx.user.update({
        where: { id: found.id },
        data: {
          passwordHash: await hashSecret(PASSWORD),
          mustChangePassword: false,
          tempPasswordExpiresAt: null,
          mfaSecretEnc: encryptSecret(Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64'), secret),
        },
      });
    });
    const adam = await signedIn(base, { email: user.email, secret, id: user.id });
    const { owner, registers } = await shopWithRegisters(2);
    const both = await Promise.all(registers.map((r) => checkout(owner, r.id, 15_000)));
    const results = await Promise.all(both.map((r) => confirm(adam, String(r.body.id))));
    expect(results.map((r) => r.status).sort()).toEqual([200, 422]);
    const refusedOne = at(
      results.filter((r) => r.status === 422),
      0,
    );
    expect(refusedOne.body).toMatchObject({
      code: 'LIMIT_EXCEEDED',
      details: { limitType: 'FAMILY_MEMBER', remainingMillimes: 5_000 },
    });
    expect(
      await db.system((tx) =>
        ledger.balance(tx, accounts.employeeWallet(memberId, 'RESTAURATION')),
      ),
    ).toBe(35_000n);
  });

  it('refuses a type the shop does not accept, and a deactivated shop', async () => {
    const { merchant, owner, registers } = await shopWithRegisters(1, ['RESTAURATION']);
    const wrongType = await checkout(owner, at(registers, 0).id, 10_000, 'CARBURANT');
    expect(wrongType.status).toBe(422);
    expect(wrongType.body).toMatchObject({
      code: 'CHECKOUT_REFUSED',
      details: { reason: 'CREDIT_TYPE_NOT_ACCEPTED' },
    });
    const { employee, client } = await fundedEmployee(50_000n);
    const open = await checkout(owner, at(registers, 0).id, 10_000);
    await db.system((tx) =>
      tx.merchant.update({ where: { id: merchant.id }, data: { status: 'SUSPENDED' } }),
    );
    expect((await confirm(client, String(open.body.id))).body).toMatchObject({
      details: { reason: 'MERCHANT_NOT_ACTIVE' },
    });
    expect((await checkout(owner, at(registers, 0).id, 10_000)).body).toMatchObject({
      details: { reason: 'MERCHANT_NOT_ACTIVE' },
    });
    expect(await balance(employee.id)).toBe(50_000n);
  });
});

describe('access control (M4)', () => {
  it('a cashier never reaches an owner route, an admin route, or another till', async () => {
    const { merchant, owner, registers } = await shopWithRegisters(2);
    const cashier = await cashierOf(merchant.id, owner, at(registers, 0).id);
    expect(
      (await cashier.call('POST', '/v1/merchant/registers', { body: { name: 'X' } })).status,
    ).toBe(403);
    expect(
      (await cashier.call('GET', `/v1/merchant/registers/${at(registers, 0).id}/sticker`)).status,
    ).toBe(403);
    expect((await cashier.call('GET', '/v1/merchant/payout-quotes')).status).toBe(403);
    expect((await cashier.call('GET', '/v1/admin/merchants')).status).toBe(403);
    // Its own till only.
    const list = await cashier.call('GET', '/v1/merchant/registers');
    expect((list.body.data as { id: string }[]).map((r) => r.id)).toEqual([at(registers, 0).id]);
    expect((await checkout(cashier, at(registers, 1).id, 5_000)).status).toBe(404);
    expect((await checkout(cashier, at(registers, 0).id, 5_000)).status).toBe(201);
  });

  it('a company never reads or changes the data of another company; a shop never sees another shop', async () => {
    const companyA = await createCompany(db);
    const companyB = await createCompany(db);
    const employeeB = await createEmployee(db, companyB.id);
    const ownerA = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: companyA.id }),
    );
    const list = await ownerA.call('GET', '/v1/company/employees');
    expect(JSON.stringify(list.body)).not.toContain(employeeB.id);
    const suspend = await ownerA.call('POST', `/v1/company/employees/${employeeB.id}/suspend`, {
      body: { reason: 'test' },
    });
    expect([403, 404]).toContain(suspend.status);

    const shopA = await shopWithRegisters();
    const shopB = await shopWithRegisters();
    const created = await checkout(shopA.owner, at(shopA.registers, 0).id, 5_000);
    expect(
      (await shopB.owner.call('POST', `/v1/merchant/checkouts/${String(created.body.id)}/cancel`))
        .status,
    ).toBe(404);
    expect(
      (await shopB.owner.call('GET', `/v1/merchant/registers/${at(shopA.registers, 0).id}/sticker`))
        .status,
    ).toBe(404);
  });
});

describe('mobile session (M4)', () => {
  const post = (path: string, body: unknown) =>
    fetch(base + path, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    }).then(async (r) => ({
      status: r.status,
      body: (await r.json().catch(() => ({}))) as Record<string, unknown>,
    }));
  const bearer = (token: unknown) => ({ Authorization: `Bearer ${String(token)}` });

  /** A beneficiary signs in by password (no MFA for beneficiaries: PIN + device). */
  async function mobileLogin(email: string, deviceId: string) {
    const login = await post('/v1/mobile/auth/login', {
      identifier: email,
      password: PASSWORD,
      deviceId,
    });
    expect(login.status).toBe(200);
    return login.body;
  }

  it('15-minute access token, rotating refresh token bound to the device, revoked at sign-out', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const user = await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id });
    await db.system((tx) =>
      tx.user.update({ where: { id: user.id }, data: { mfaSecretEnc: null } }),
    );
    const deviceId = `device-${randomUUID()}`;
    const session = await mobileLogin(user.email, deviceId);
    expect(session.nextStep).toBe('NONE');
    const access = Date.parse(String(session.accessExpiresAt)) - Date.now();
    expect(access).toBeGreaterThan(14 * 60_000);
    expect(access).toBeLessThanOrEqual(15 * 60_000);
    expect(
      (await fetch(`${base}/v1/employee/wallet`, { headers: bearer(session.accessToken) })).status,
    ).toBe(200);

    // Another device cannot use the refresh token: the whole session is revoked.
    const stolen = await post('/v1/mobile/auth/refresh', {
      refreshToken: session.refreshToken,
      deviceId: `other-${randomUUID()}`,
    });
    expect(stolen.status).toBe(401);
    expect(
      (await fetch(`${base}/v1/employee/wallet`, { headers: bearer(session.accessToken) })).status,
    ).toBe(401);

    // Rotation: the old refresh token is single use.
    const again = await mobileLogin(user.email, deviceId);
    const rotated = await post('/v1/mobile/auth/refresh', {
      refreshToken: again.refreshToken,
      deviceId,
    });
    expect(rotated.status).toBe(200);
    expect(rotated.body.refreshToken).not.toBe(again.refreshToken);
    const reused = await post('/v1/mobile/auth/refresh', {
      refreshToken: again.refreshToken,
      deviceId,
    });
    expect(reused.status).toBe(401);

    // Sign-out revokes.
    const third = await mobileLogin(user.email, deviceId);
    const out = await fetch(`${base}/v1/mobile/auth/logout`, {
      method: 'POST',
      headers: bearer(third.accessToken),
    });
    expect(out.status).toBe(204);
    expect(
      (await post('/v1/mobile/auth/refresh', { refreshToken: third.refreshToken, deviceId }))
        .status,
    ).toBe(401);
  });

  it('first sign-in: the password change is required before anything else', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const user = await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id });
    await db.system((tx) =>
      tx.user.update({
        where: { id: user.id },
        data: {
          mfaSecretEnc: null,
          mustChangePassword: true,
          tempPasswordExpiresAt: new Date(Date.now() + 3_600_000),
        },
      }),
    );
    const deviceId = `device-${randomUUID()}`;
    const session = await mobileLogin(user.email, deviceId);
    expect(session.nextStep).toBe('PASSWORD_CHANGE');
    const blocked = await fetch(`${base}/v1/employee/wallet`, {
      headers: bearer(session.accessToken),
    });
    expect(blocked.status).toBe(403);
    const changed = await fetch(`${base}/v1/mobile/auth/password/change`, {
      method: 'POST',
      headers: { ...bearer(session.accessToken), 'Content-Type': 'application/json' },
      body: JSON.stringify({ newPassword: 'Jasmin-du-Cap-Bon-2026' }), // gitleaks:allow (test-only value)
    });
    expect(changed.status).toBe(200);
    const next = (await changed.json()) as Record<string, unknown>;
    expect(next.nextStep).toBe('NONE');
    expect(
      (await fetch(`${base}/v1/employee/wallet`, { headers: bearer(next.accessToken) })).status,
    ).toBe(200);
  });
});
