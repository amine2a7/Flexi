// TEST-FIRST (ledger-auditor C1-C4, C6): two concurrent decisions on the same financial object
// give one success, one 409, and books that match the final state (no money created or lost).
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv, ownerClient } from './setup.js';
import { listen, type WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { PayoutsService } = await import('../../src/payouts/payouts.service.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { createCompany, createEmployee, createUser, sealed, seedSettings, signedIn, oneLineGrid } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const ledger = new LedgerService();
const app = await createApp(env, false);
let base = '';
const PIN = '4826';
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  'base64',
);

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

const key = () => ({ 'Idempotency-Key': randomUUID() });
const statuses = (results: { status: number }[]) => results.map((r) => r.status).sort();
const balance = (account: Parameters<typeof ledger.balance>[1]) =>
  db.system((tx) => ledger.balance(tx, account));
const posted = (type: string, reference: string) =>
  db.system((tx) => tx.ledgerTransaction.count({ where: { type, reference } }));

async function createMerchant() {
  return db.system((tx) =>
    tx.merchant.create({
      data: {
        commissionGrids: oneLineGrid(),
        name: `Café ${randomUUID().slice(0, 5)}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: sealed('+21671000001'),
        email: 'cafe@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: ['RESTAURATION'],
        paymentCode: String(randomInt(100_000, 999_999)),
        iban: sealed(
          `TN59${String(randomInt(10 ** 9, 10 ** 10 - 1))}${String(randomInt(10 ** 9, 10 ** 10 - 1))}12`.slice(
            0,
            24,
          ),
        ),
      },
    }),
  );
}

/** An employee with `amount` Restauration credits, its PIN, and its signed-in client. */
async function fundedEmployee(amount: bigint) {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  await db.system(async (tx) => {
    await tx.employee.update({
      where: { id: employee.id },
      data: { pinHash: await hashSecret(PIN) },
    });
    const done = await ledger.post(tx, {
      type: 'ALLOCATION',
      reference: 'TEST',
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
      sourceTransactionId: done.transactionId,
    });
  });
  const client = await signedIn(
    base,
    await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.'),
  );
  return { employee, client };
}

/** A shop with `amount` Restauration receivables (one payment) and its signed-in client. */
async function shopWithReceivables(amount: number): Promise<{ id: string; shop: WebClient }> {
  const { client: employee } = await fundedEmployee(BigInt(amount) * 3n);
  const merchant = await createMerchant();
  const paid = await employee.call('POST', '/v1/employee/payments', {
    body: {
      merchantCode: merchant.paymentCode,
      creditType: 'RESTAURATION',
      amountMillimes: amount,
      pin: PIN,
    },
    headers: key(),
  });
  expect(paid.status).toBe(201);
  const shop = await signedIn(
    base,
    await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Sami B.'),
  );
  return { id: merchant.id, shop };
}

async function payoutRequested(gross: number) {
  const { id, shop } = await shopWithReceivables(gross);
  const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
    body: { creditType: 'RESTAURATION', grossMillimes: gross },
  });
  const requested = await shop.call('POST', '/v1/merchant/payouts', {
    body: { quoteId: quote.body.quoteId },
    headers: key(),
  });
  expect(requested.status).toBe(201);
  return { merchantId: id, shop, payout: requested.body };
}

describe('concurrent decisions on one financial object', () => {
  it('validates an order once when two administrators validate it at the same time (C1)', async () => {
    const company = await createCompany(db);
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.'),
    );
    const adminA = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    const adminB = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.'));
    const created = await owner.call('POST', '/v1/company/orders', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 1_000_000 }] },
      headers: key(),
    });
    const id = String(created.body.id);
    await adminA.call('POST', `/v1/admin/credit-orders/${id}/confirm`);
    const form = new FormData();
    form.set('transferReference', 'BIAT-1');
    form.set('transferDate', new Date().toISOString().slice(0, 10));
    form.set('amountMillimes', String(created.body.totalMillimes));
    form.set('proof', new Blob([PNG]), 'avis.png');
    await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form,
      headers: key(),
    });

    const results = await Promise.all([
      adminA.call('POST', `/v1/admin/credit-orders/${id}/validate`, { headers: key() }),
      adminB.call('POST', `/v1/admin/credit-orders/${id}/validate`, { headers: key() }),
    ]);
    expect(statuses(results)).toEqual([200, 409]);
    expect(await balance(accounts.companyWallet(company.id, 'RESTAURATION'))).toBe(1_000_000n);
    expect(await posted('ORDER_VALIDATED', String(created.body.reference))).toBe(1);
  });

  it('either approves or rejects a payout, never both (C2)', async () => {
    const { merchantId, payout } = await payoutRequested(30_000);
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    const id = String(payout.id);
    const results = await Promise.all([
      admin.call('POST', `/v1/admin/payout-requests/${id}/approve`, { headers: key() }),
      admin.call('POST', `/v1/admin/payout-requests/${id}/reject`, {
        body: { reason: 'IBAN à vérifier' },
        headers: key(),
      }),
    ]);
    expect(statuses(results)).toEqual([200, 409]);
    const row = await db.system((tx) => tx.payoutRequest.findUniqueOrThrow({ where: { id } }));
    const wallet = await balance(accounts.merchantWallet(merchantId, 'RESTAURATION'));
    if (row.status === 'REJECTED') {
      expect(row.batchId).toBeNull();
      expect(wallet).toBe(30_000n);
    } else {
      expect(row.status).toBe('CHECKED');
      expect(wallet).toBe(0n);
    }
    expect((await db.system((tx) => ledger.reconcile(tx))).ok).toBe(true);
  });

  it('executes a settlement batch once when the job runs twice at the same time (C3)', async () => {
    const { payout } = await payoutRequested(20_000);
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.'));
    const approved = await admin.call(
      'POST',
      `/v1/admin/payout-requests/${String(payout.id)}/approve`,
      { headers: key() },
    );
    const owner = await ownerClient();
    await owner.query(
      `UPDATE settlement_batches SET settlement_date = current_date WHERE id = $1`,
      [approved.body.batchId],
    );
    await owner.end();
    const job = app.get(PayoutsService);
    await Promise.all([job.executeDueBatches(), job.executeDueBatches()]);
    expect(await posted('PAYOUT_EXECUTED', String(payout.reference))).toBe(1);
    expect((await db.system((tx) => ledger.reconcile(tx))).ok).toBe(true);
  });

  it('never shows as refused a payment that the PIN confirmed (C4)', async () => {
    const { employee, client } = await fundedEmployee(60_000n);
    const merchant = await createMerchant();
    const shop = await signedIn(
      base,
      await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Sami B.'),
    );
    const code = await client.call('POST', '/v1/employee/payment-codes');
    const initiated = await shop.call('POST', '/v1/merchant/payments', {
      body: { customerCode: code.body.code, creditType: 'RESTAURATION', amountMillimes: 18_500 },
      headers: key(),
    });
    const id = String(initiated.body.id);
    const results = await Promise.all([
      client.call('POST', `/v1/employee/payment-requests/${id}/confirm`, {
        body: { pin: PIN },
        headers: key(),
      }),
      shop.call('POST', `/v1/merchant/payments/${id}/cancel`),
    ]);
    expect(statuses(results).filter((status) => status === 409)).toHaveLength(1);
    const row = await db.system((tx) => tx.payment.findUniqueOrThrow({ where: { id } }));
    const left = await balance(accounts.employeeWallet(employee.id, 'RESTAURATION'));
    if (row.status === 'CONFIRMED') {
      expect(row.transactionId).not.toBeNull();
      expect(left).toBe(41_500n);
    } else {
      expect(row.transactionId).toBeNull();
      expect(left).toBe(60_000n);
    }
  });

  it('uses a payout quote once even with two requests at the same time (C6)', async () => {
    const { shop } = await shopWithReceivables(40_000);
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 20_000 },
    });
    const results = await Promise.all([
      shop.call('POST', '/v1/merchant/payouts', {
        body: { quoteId: quote.body.quoteId },
        headers: key(),
      }),
      shop.call('POST', '/v1/merchant/payouts', {
        body: { quoteId: quote.body.quoteId },
        headers: key(),
      }),
    ]);
    expect(statuses(results)).toEqual([201, 409]);
  });

  it('either approves or rejects a four-eyes request, never both (securite S03)', async () => {
    const initiator = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    const second = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.'));
    const third = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Mehdi S.'));
    const company = await db.system((tx) =>
      tx.company.create({
        data: {
          name: `Société ${randomUUID().slice(0, 8)}`,
          city: 'Tunis',
          phone: sealed('+21671000000'),
          email: 'contact@societe.test',
          status: 'APPROVED',
          commissionGrids: { create: { tiers: { create: [{ position: 0, rateBps: 180 }] } } },
        },
      }),
    );
    const requested = await initiator.call(
      'POST',
      '/v1/admin/commission-grids/change-requests',
      {
        body: {
          companyId: company.id,
          tiers: [{ rateBps: 210, minMillimes: null, maxMillimes: null }],
          reason: 'Révision',
        },
      },
    );
    expect(requested.status).toBe(201);
    const id = String(requested.body.id);
    const results = await Promise.all([
      second.call('POST', `/v1/admin/approvals/${id}/approve`),
      third.call('POST', `/v1/admin/approvals/${id}/reject`, { body: { reason: 'Non' } }),
    ]);
    expect(statuses(results)).toEqual([200, 409]);
    const row = await db.system((tx) => tx.approval.findUniqueOrThrow({ where: { id } }));
    const rate = (
      await db.system((tx) =>
        tx.commissionGrid.findFirstOrThrow({
          where: { companyId: company.id },
          orderBy: [{ effectiveFrom: 'desc' }, { id: 'desc' }],
          include: { tiers: true },
        }),
      )
    ).tiers[0]?.rateBps;
    expect(row.status === 'APPROVED' ? rate : 180).toBe(row.status === 'APPROVED' ? 210 : rate);
  });
});
