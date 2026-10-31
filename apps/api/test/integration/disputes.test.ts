// TEST-FIRST N2 (decision of 2026-10-31): a dispute is opened by Opérations on a payment, the
// amount leaves the merchant wallet (excluded from any settlement), the case is investigated
// (notes), then rejected (amount back to the merchant) or accepted: Finance gives the second
// validation and the amount goes back to the employee (same credit lots), books balanced.
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
const { createCompany, createEmployee, createUser, sealed, seedSettings, signedIn } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
const ledger = new LedgerService();
const PIN = '4826';
let base = '';

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

const key = () => ({ 'Idempotency-Key': randomUUID() });
const REASON = { reason: 'Paiement contesté par le bénéficiaire.' };
const admin = async (subRole: 'SUPER_ADMIN' | 'COMPLIANCE' | 'FINANCE' | 'SUPPORT') => {
  const user = await createUser(db, env, 'ADMIN', {}, `Admin ${subRole}`, subRole);
  return { user, client: await signedIn(base, user) };
};
const balance = (account: ReturnType<typeof accounts.merchantWallet>) =>
  db.system((tx) => ledger.balance(tx, account));

/** A confirmed payment of `amount` RESTAURATION credits from a funded employee to a shop. */
async function confirmedPayment(amount: number) {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  await db.system(async (tx) => {
    await tx.employee.update({
      where: { id: employee.id },
      data: { pinHash: await hashSecret(PIN) },
    });
    const posted = await ledger.post(tx, {
      type: 'ALLOCATION',
      reference: 'TEST-N2',
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount: 100_000n },
        {
          account: accounts.employeeWallet(employee.id, 'RESTAURATION'),
          direction: 'C',
          amount: 100_000n,
        },
      ],
    });
    await ledger.addLot(tx, {
      account: accounts.employeeWallet(employee.id, 'RESTAURATION'),
      creditType: 'RESTAURATION',
      amount: 100_000n,
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
  const payer = await signedIn(
    base,
    await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.'),
  );
  const paid = await payer.call('POST', '/v1/employee/payments', {
    body: {
      merchantCode: merchant.paymentCode,
      creditType: 'RESTAURATION',
      amountMillimes: amount,
      pin: PIN,
    },
    headers: key(),
  });
  expect(paid.status).toBeLessThan(300);
  const payment = await db.system((tx) =>
    tx.payment.findFirstOrThrow({ where: { merchantId: merchant.id, status: 'CONFIRMED' } }),
  );
  return { employee, merchant, payment };
}

describe('disputes (N2)', () => {
  it('opening holds the amount out of the merchant wallet; rejecting gives it back', async () => {
    const ops = await admin('COMPLIANCE');
    const { merchant, payment } = await confirmedPayment(30_000);
    const wallet = accounts.merchantWallet(merchant.id, 'RESTAURATION');
    expect(await balance(wallet)).toBe(30_000n);
    const opened = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    expect(opened.status).toBe(201);
    expect(opened.body).toMatchObject({ status: 'OPEN', amountMillimes: 30_000 });
    expect(await balance(wallet)).toBe(0n);
    const id = String(opened.body.id);
    // Only one dispute per payment.
    const twice = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    expect(twice.status).toBe(409);
    // Investigation: a note.
    const note = await ops.client.call('POST', `/v1/admin/disputes/${id}/notes`, {
      body: { text: 'Ticket de caisse demandé au commerçant.' },
    });
    expect(note.status).toBe(201);
    const detail = await ops.client.call('GET', `/v1/admin/disputes/${id}`);
    expect((detail.body.notes as unknown[]).length).toBe(1);
    expect(typeof detail.body.dueAt).toBe('string');
    const rejected = await ops.client.call('POST', `/v1/admin/disputes/${id}/reject`, {
      body: { reason: 'Le paiement est conforme au ticket de caisse.' },
      headers: key(),
    });
    expect(rejected.body.status).toBe('REJECTED');
    expect(await balance(wallet)).toBe(30_000n);
  });

  it('accepting needs the second validation of Finance, then refunds the employee', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, merchant, payment } = await confirmedPayment(25_000);
    const employeeWallet = accounts.employeeWallet(employee.id, 'RESTAURATION');
    expect(await balance(employeeWallet)).toBe(75_000n);
    const opened = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    const id = String(opened.body.id);
    const accepted = await ops.client.call('POST', `/v1/admin/disputes/${id}/accept`, {
      body: { reason: 'Double débit confirmé par le commerçant.' },
      headers: key(),
    });
    expect(accepted.body.status).toBe('ACCEPTANCE_PENDING');
    const approval = await db.system((tx) =>
      tx.approval.findFirstOrThrow({
        where: {
          type: 'DISPUTE_REFUND',
          status: 'PENDING',
          subject: { contains: String(opened.body.reference) },
        },
      }),
    );
    // The one who accepted never gives the second validation (four eyes).
    expect(
      (await ops.client.call('POST', `/v1/admin/approvals/${approval.id}/approve`)).status,
    ).toBe(403);
    expect(await balance(employeeWallet)).toBe(75_000n);
    const approved = await finance.client.call(
      'POST',
      `/v1/admin/approvals/${approval.id}/approve`,
    );
    expect(approved.status).toBe(200);
    expect(await balance(employeeWallet)).toBe(100_000n);
    expect(await balance(accounts.merchantWallet(merchant.id, 'RESTAURATION'))).toBe(0n);
    const lots = await db.system(
      (tx) =>
        tx.$queryRaw<{ total: bigint }[]>`
        SELECT coalesce(sum(l.remaining_millimes), 0)::bigint AS total FROM credit_lots l
          JOIN ledger_accounts a ON a.id = l.account_id
         WHERE a.code = ${employeeWallet.code}`,
    );
    expect(lots[0]?.total).toBe(100_000n);
    const after = await ops.client.call('GET', `/v1/admin/disputes/${id}`);
    expect(after.body.status).toBe('ACCEPTED');
  });

  it('a refused second validation sends the dispute back to investigation', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { payment } = await confirmedPayment(10_000);
    const opened = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    await ops.client.call('POST', `/v1/admin/disputes/${String(opened.body.id)}/accept`, {
      body: { reason: 'Double débit confirmé par le commerçant.' },
      headers: key(),
    });
    const approval = await db.system((tx) =>
      tx.approval.findFirstOrThrow({
        where: {
          type: 'DISPUTE_REFUND',
          status: 'PENDING',
          subject: { contains: String(opened.body.reference) },
        },
      }),
    );
    await finance.client.call('POST', `/v1/admin/approvals/${approval.id}/reject`, {
      body: { reason: 'Pièces insuffisantes.' },
    });
    const after = await ops.client.call('GET', `/v1/admin/disputes/${String(opened.body.id)}`);
    expect(after.body.status).toBe('OPEN');
  });

  it('a payment already in a payout request cannot be disputed (to confirm by Amine)', async () => {
    const ops = await admin('COMPLIANCE');
    const { merchant, payment } = await confirmedPayment(30_000);
    await db.system((tx) =>
      tx.payment.update({ where: { id: payment.id }, data: { payoutId: randomUUID() } }),
    );
    const refused = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    expect(refused.status).toBe(409);
    expect(await balance(accounts.merchantWallet(merchant.id, 'RESTAURATION'))).toBe(30_000n);
  });
});
