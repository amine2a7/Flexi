// TEST-FIRST (securite B5-S01, plan of 2026-10-21): the payment PIN resists simultaneous guesses.
// 3 wrong PINs lock it 15 min, then 30, then 60, then until a full sign-in (password + MFA). The
// attempt is reserved atomically in the database; wrong and locked answers look the same.
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv, ownerClient } from './setup.js';
import { listen, WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { PASSWORD, createCompany, createEmployee, createUser, sealed, seedSettings, signedIn } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const ledger = new LedgerService();
const app = await createApp(env, false);
let base = '';
const PIN = '4826';

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

const key = () => ({ 'Idempotency-Key': randomUUID() });

async function setup() {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  await db.system(async (tx) => {
    await tx.employee.update({
      where: { id: employee.id },
      data: { pinHash: await hashSecret(PIN) },
    });
    const posted = await ledger.post(tx, {
      type: 'ALLOCATION',
      reference: 'TEST',
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount: 50_000n },
        {
          account: accounts.employeeWallet(employee.id, 'RESTAURATION'),
          direction: 'C',
          amount: 50_000n,
        },
      ],
    });
    await ledger.addLot(tx, {
      account: accounts.employeeWallet(employee.id, 'RESTAURATION'),
      creditType: 'RESTAURATION',
      amount: 50_000n,
      expiresAt: new Date(Date.now() + 365 * 86_400_000),
      sourceTransactionId: posted.transactionId,
    });
  });
  const merchant = await db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Café ${randomUUID().slice(0, 5)}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: sealed('+21671000001'),
        email: 'cafe@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: ['RESTAURATION'],
        paymentCode: String(randomInt(100_000, 999_999)),
      },
    }),
  );
  const user = await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.');
  const client = await signedIn(base, user);
  const pay = (pin: string) =>
    client.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 1_000,
        pin,
      },
      headers: key(),
    });
  return { employee, user, client, pay };
}

const state = (employeeId: string) =>
  db.system((tx) => tx.employee.findUniqueOrThrow({ where: { id: employeeId } }));

/** Ends the current lock now (time passing), keeping its level. */
async function lockEnds(employeeId: string): Promise<void> {
  const owner = await ownerClient();
  await owner.query(
    `UPDATE employees SET pin_locked_until = now() - interval '1 second' WHERE id = $1`,
    [employeeId],
  );
  await owner.end();
}

const minutes = (seconds: unknown) => Math.round(Number(seconds) / 60);

describe('payment PIN', () => {
  it('evaluates at most 3 PINs out of 20 sent at the same time, then locks 15 min', async () => {
    const { employee, pay } = await setup();
    const results = await Promise.all(Array.from({ length: 20 }, () => pay('0000')));
    expect(results.every((result) => result.status === 403)).toBe(true);
    expect(new Set(results.map((result) => result.body.code))).toEqual(new Set(['PIN_INVALID']));
    const row = await state(employee.id);
    expect(row.pinLockLevel).toBe(1);
    expect(minutes(((row.pinLockedUntil?.getTime() ?? 0) - Date.now()) / 1000)).toBe(15);
    const failures = await db.system((tx) =>
      tx.auditLog.count({
        where: { action: 'pin.failed', target: { contains: employee.id } },
      }),
    );
    expect(failures).toBe(3);
  });

  it('answers the same way to a right PIN while locked, with the time left', async () => {
    const { pay } = await setup();
    await pay('0000');
    await pay('0000');
    const third = await pay('0000');
    const right = await pay(PIN);
    expect(right.status).toBe(403);
    expect(right.body.code).toBe('PIN_INVALID');
    expect(Object.keys(right.body).sort()).toEqual(Object.keys(third.body).sort());
    expect(minutes((right.body.details as { retryAfterSeconds?: number }).retryAfterSeconds)).toBe(
      15,
    );
  });

  it('locks 15, 30, then 60 minutes, then until a full sign-in (password + MFA)', async () => {
    const { employee, user, pay } = await setup();
    const lockFor = async () => {
      for (let attempt = 0; attempt < 3; attempt += 1) await pay('0000');
      return state(employee.id);
    };
    for (const expected of [15, 30, 60]) {
      const row = await lockFor();
      expect(minutes(((row.pinLockedUntil?.getTime() ?? 0) - Date.now()) / 1000)).toBe(expected);
      await lockEnds(employee.id);
    }
    const blocked = await lockFor();
    expect(blocked.pinRequiresReauth).toBe(true);
    await lockEnds(employee.id);
    // The session that made the guesses is closed (S24): even the right PIN goes nowhere.
    expect((await pay(PIN)).status).toBe(401);

    // A full sign-in (password + MFA) lifts the block and the progression.
    const again = await signedIn(base, user);
    const paid = await again.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: (
          await db.system((tx) =>
            tx.merchant.findFirstOrThrow({
              orderBy: { createdAt: 'desc' },
              select: { paymentCode: true },
            }),
          )
        ).paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 1_000,
        pin: PIN,
      },
      headers: key(),
    });
    expect(paid.status).toBe(201);
    const cleared = await state(employee.id);
    expect(cleared).toMatchObject({ pinLockLevel: 0, pinRequiresReauth: false, pinFailures: 0 });
  });

  /** Reaches the fourth lock (sign-in required): 4 x 3 wrong PINs, each lock ended. */
  async function untilSignIn(employeeId: string, pay: (pin: string) => Promise<unknown>) {
    for (let round = 0; round < 4; round += 1) {
      for (let attempt = 0; attempt < 3; attempt += 1) await pay('0000');
      if (round < 3) await lockEnds(employeeId);
    }
  }

  it('closes every session of the beneficiary at the fourth lock (securite S24)', async () => {
    const { employee, client, pay } = await setup();
    await untilSignIn(employee.id, pay);
    expect((await client.call('GET', '/v1/employee/wallet')).status).toBe(401);
  });

  it('a beneficiary without MFA lifts the block by signing in again with the password (S23)', async () => {
    const { employee, user, pay } = await setup();
    await untilSignIn(employee.id, pay);
    await db.system((tx) =>
      tx.user.update({ where: { id: user.id }, data: { mfaSecretEnc: null } }),
    );
    const again = new WebClient(base);
    const login = await again.call('POST', '/v1/auth/login', {
      body: { identifier: user.email, password: PASSWORD },
    });
    expect(login.body.nextStep).toBe('NONE');
    expect(await state(employee.id)).toMatchObject({ pinLockLevel: 0, pinRequiresReauth: false });
  });
});
