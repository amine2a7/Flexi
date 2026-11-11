// Processus v2, « Comptes famille » (scénarios du PDF): Sami (enfant) reçoit 50 TND de
// Restauration avec un plafond de 20 TND par jour ; il paie 15 TND (accepté) puis 10 TND le même
// jour (refusé) ; le bénéficiaire reprend les 35 TND ; un 6e membre est refusé. La société ne voit
// jamais les membres. Grand livre rapproché à la fin.
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

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
const app = await createApp(env, false);
const ledger = new LedgerService();
let base = '';
const PIN = '4826';
const key = () => ({ 'Idempotency-Key': randomUUID() });

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

async function fundedHolder(amount: bigint) {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  await db.system(async (tx) => {
    const posted = await ledger.post(tx, {
      type: 'ALLOCATION',
      reference: 'TEST-FAMILY',
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount },
        { account: accounts.employeeWallet(employee.id, 'RESTAURATION'), direction: 'C', amount },
      ],
    });
    await ledger.addLot(tx, {
      account: accounts.employeeWallet(employee.id, 'RESTAURATION'),
      creditType: 'RESTAURATION',
      amount,
      expiresAt: new Date(Date.now() + 200 * 86_400_000),
      sourceTransactionId: posted.transactionId,
    });
  });
  const client = await signedIn(
    base,
    await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.'),
  );
  return { company, employee, client };
}

/** The member's account made usable by the test (known password and TOTP, PIN set). */
async function memberClient(memberId: string) {
  const secret = newSecretBase32();
  const user = await db.system(async (tx) => {
    await tx.employee.update({ where: { id: memberId }, data: { pinHash: await hashSecret(PIN) } });
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
  return signedIn(base, { email: user.email, secret, id: user.id });
}

describe('family accounts', () => {
  it('creates Sami, transfers 50 TND capped at 20 a day, and takes the rest back', async () => {
    const { company, employee, client } = await fundedHolder(200_000n);
    const created = await client.call('POST', '/v1/employee/family/members', {
      body: { firstName: 'Sami', lastName: 'Jebali', relationship: 'CHILD', phone: '+21698123456' },
    });
    expect(created.status).toBe(201);
    expect(created.body.credentials).toMatchObject({
      email: expect.stringMatching(/@famille\.flexipay\.tn$/) as string,
      temporaryPassword: expect.any(String) as string,
    });
    const memberId = String(created.body.id);

    const transfer = await client.call('POST', '/v1/employee/family/transfers', {
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
    await db.system(async (tx) => {
      expect(await ledger.balance(tx, accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(
        150_000n,
      );
      expect(await ledger.balance(tx, accounts.employeeWallet(memberId, 'RESTAURATION'))).toBe(
        50_000n,
      );
    });
    // Over the holder's balance: refused, nothing moves.
    const tooMuch = await client.call('POST', '/v1/employee/family/transfers', {
      headers: key(),
      body: {
        memberId,
        creditType: 'RESTAURATION',
        amountMillimes: 500_000,
        dailyLimitMillimes: null,
        endsOn: null,
      },
    });
    expect(tooMuch.status).toBe(422);

    // Sami pays 15 TND (accepted), then 10 TND the same day (refused: cap of 20 TND).
    const merchant = await db.system((tx) =>
      tx.merchant.create({
        data: {
          name: `Cantine ${randomUUID().slice(0, 6)}`,
          category: 'RESTAURANT',
          city: 'Tunis',
          phone: sealed('+21671000002'),
          email: 'cantine@test.tn',
          status: 'APPROVED',
          acceptedCreditTypes: ['RESTAURATION'],
          paymentCode: String(randomInt(100_000, 999_999)),
          iban: sealed('TN5910006035183598470014'),
          commissionGrids: oneLineGrid(200),
        },
      }),
    );
    const sami = await memberClient(memberId);
    const pay = (amountMillimes: number) =>
      sami.call('POST', '/v1/employee/payments', {
        headers: key(),
        body: {
          merchantCode: merchant.paymentCode,
          creditType: 'RESTAURATION',
          amountMillimes,
          pin: PIN,
        },
      });
    expect((await pay(15_000)).status).toBe(201);
    const refused = await pay(10_000);
    expect(refused.status).toBe(422);
    expect(refused.body).toMatchObject({
      code: 'LIMIT_EXCEEDED',
      details: { remainingMillimes: 5_000 },
    });
    // A member never manages a family, and sees only its own wallet.
    expect((await sami.call('GET', '/v1/employee/family')).status).toBe(403);
    const wallet = await sami.call('GET', '/v1/employee/wallet');
    // Only its own 35 TND: never the holder's 150 TND.
    expect(wallet.body.totalBalanceMillimes).toBe(35_000);

    // The company never sees the member.
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Ahmed B.'),
    );
    const employees = await owner.call('GET', '/v1/company/employees');
    expect((employees.body.data as { id: string }[]).map((row) => row.id)).not.toContain(memberId);

    // Take back: the 35 TND left come back to the holder.
    const reclaimed = await client.call('POST', `/v1/employee/family/members/${memberId}/reclaim`, {
      headers: key(),
      body: { creditType: null },
    });
    expect(reclaimed.body).toEqual({ memberId, reclaimedMillimes: 35_000 });
    await db.system(async (tx) => {
      expect(await ledger.balance(tx, accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(
        185_000n,
      );
      expect(await ledger.balance(tx, accounts.employeeWallet(memberId, 'RESTAURATION'))).toBe(0n);
      expect((await ledger.reconcile(tx)).ok).toBe(true);
    });
  });

  it('refuses a 6th member, and deletes a member after giving its credit back', async () => {
    const { employee, client } = await fundedHolder(100_000n);
    const ids: string[] = [];
    for (const name of ['Amel', 'Rania', 'Omar', 'Lina', 'Adam']) {
      const created = await client.call('POST', '/v1/employee/family/members', {
        body: { firstName: name, lastName: 'B', relationship: 'CHILD', phone: '+21698123456' },
      });
      expect(created.status).toBe(201);
      ids.push(String(created.body.id));
    }
    const sixth = await client.call('POST', '/v1/employee/family/members', {
      body: { firstName: 'Nour', lastName: 'B', relationship: 'CHILD', phone: '+21698123456' },
    });
    expect(sixth.status).toBe(409);
    expect(sixth.body.details).toMatchObject({ reason: 'FAMILY_LIMIT_REACHED' });

    const first = ids[0] ?? '';
    await client.call('POST', '/v1/employee/family/transfers', {
      headers: key(),
      body: {
        memberId: first,
        creditType: 'RESTAURATION',
        amountMillimes: 30_000,
        dailyLimitMillimes: null,
        endsOn: null,
      },
    });
    const removed = await client.call('DELETE', `/v1/employee/family/members/${first}`, {
      headers: key(),
    });
    expect(removed.body).toEqual({ memberId: first, reclaimedMillimes: 30_000 });
    const list = await client.call('GET', '/v1/employee/family');
    expect((list.body.data as unknown[]).length).toBe(4);
    await db.system(async (tx) => {
      expect(await ledger.balance(tx, accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(
        100_000n,
      );
      const user = await tx.user.findFirstOrThrow({ where: { employeeId: first } });
      expect(user.status).toBe('DEACTIVATED');
    });
  });

  it('a company that switches family accounts off blocks new members', async () => {
    const { company, client } = await fundedHolder(10_000n);
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Ahmed B.'),
    );
    expect(
      (await owner.call('PUT', '/v1/company/family-accounts', { body: { enabled: false } })).body,
    ).toEqual({ enabled: false });
    const refused = await client.call('POST', '/v1/employee/family/members', {
      body: { firstName: 'Sami', lastName: 'B', relationship: 'CHILD', phone: '+21698123456' },
    });
    expect(refused.status).toBe(409);
    expect((await client.call('GET', '/v1/employee/family')).body.enabled).toBe(false);
  });
});
