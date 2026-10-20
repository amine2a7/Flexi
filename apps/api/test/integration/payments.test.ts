// Payments (beneficiary and merchant), payouts and settlement, over HTTP and the ledger.
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
const { JobsService } = await import('../../src/jobs/jobs.service.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { createCompany, createEmployee, createUser, seedSettings, signedIn } =
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

/** A shop; with `ownRateBps`, its own commission profile (otherwise the credit type rate). */
async function createMerchant(
  types: ('RESTAURATION' | 'CADEAUX')[] = ['RESTAURATION'],
  ownRateBps?: number,
) {
  return db.system(async (tx) => {
    const profile =
      ownRateBps === undefined
        ? null
        : await tx.commissionProfile.create({
            data: { name: `Profil ${randomUUID().slice(0, 8)}`, rateBps: ownRateBps },
          });
    return tx.merchant.create({
      data: {
        name: `Café ${randomUUID().slice(0, 5)}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: '+21671000001',
        email: 'cafe@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: types,
        paymentCode: String(randomInt(100_000, 999_999)),
        iban: `TN59${String(randomInt(10 ** 9, 10 ** 10 - 1))}${String(randomInt(10 ** 9, 10 ** 10 - 1))}12`.slice(
          0,
          24,
        ),
        commissionProfileId: profile?.id ?? null,
      },
    });
  });
}

/** An employee with `amount` RESTAURATION credits (one lot, one year) and the PIN set. */
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
      sourceTransactionId: posted.transactionId,
    });
  });
  const client = await signedIn(
    base,
    await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.'),
  );
  return { company, employee, client };
}

async function merchantClient(merchantId: string): Promise<WebClient> {
  return signedIn(base, await createUser(db, env, 'MERCHANT', { merchantId }, 'Sami B.'));
}

describe('payment by the customer code (merchant initiates, beneficiary confirms with the PIN)', () => {
  it('runs the whole circuit and credits the merchant wallet of the type', async () => {
    const { client: employee } = await fundedEmployee(60_000n);
    const merchant = await createMerchant();
    const shop = await merchantClient(merchant.id);

    const code = await employee.call('POST', '/v1/employee/payment-codes');
    expect(code.status).toBe(201);
    expect(code.body).toMatchObject({
      validitySeconds: 60,
      qrPayload: `flexipay:pay:${String(code.body.code)}`,
    });
    const initiated = await shop.call('POST', '/v1/merchant/payments', {
      body: { customerCode: code.body.code, creditType: 'RESTAURATION', amountMillimes: 18_500 },
      headers: key(),
    });
    expect(initiated.status).toBe(201);
    expect(initiated.body).toMatchObject({
      status: 'INITIATED',
      customer: { firstName: 'Yasmine', lastInitial: 'J' },
    });
    expect(JSON.stringify(initiated.body)).not.toContain('balance');
    // One initiation per code (E12): the same code again is declined, like an unknown one.
    const again = await shop.call('POST', '/v1/merchant/payments', {
      body: { customerCode: code.body.code, creditType: 'RESTAURATION', amountMillimes: 1_000 },
      headers: key(),
    });
    const unknown = await shop.call('POST', '/v1/merchant/payments', {
      body: { customerCode: '12345678', creditType: 'RESTAURATION', amountMillimes: 1_000 },
      headers: key(),
    });
    expect(again.body.code).toBe('PAYMENT_DECLINED');
    expect(unknown.body.code).toBe('PAYMENT_DECLINED');
    expect(again.body.details).toBeUndefined();

    const requests = await employee.call('GET', '/v1/employee/payment-requests');
    const request = (requests.body.data as { id: string; merchantName: string }[])[0];
    expect(request?.merchantName).toBe(merchant.name);
    const wrong = await employee.call(
      'POST',
      `/v1/employee/payment-requests/${request?.id ?? ''}/confirm`,
      { body: { pin: '0000' }, headers: key() },
    );
    expect(wrong.body.code).toBe('PIN_INVALID');
    const confirmed = await employee.call(
      'POST',
      `/v1/employee/payment-requests/${request?.id ?? ''}/confirm`,
      { body: { pin: PIN }, headers: key() },
    );
    expect(confirmed.status).toBe(200);
    expect(confirmed.body).toMatchObject({
      type: 'PAYMENT',
      amountMillimes: 18_500,
      balanceAfterMillimes: 41_500,
      counterpartyName: merchant.name,
    });

    const detail = await shop.call('GET', `/v1/merchant/payments/${String(initiated.body.id)}`);
    expect(detail.body).toMatchObject({
      status: 'CONFIRMED',
      commissionRateBps: 200,
      commissionMillimes: 370,
      netMillimes: 18_130,
    });
    expect(typeof detail.body.settlementDate).toBe('string');
    const receivables = await shop.call('GET', '/v1/merchant/receivables');
    expect(receivables.body.totalMillimes).toBe(18_500);
    expect(
      await db.system((tx) =>
        ledger.balance(tx, accounts.merchantWallet(merchant.id, 'RESTAURATION')),
      ),
    ).toBe(18_500n);
    const wallet = await employee.call('GET', '/v1/employee/wallet');
    expect(
      (
        wallet.body.balances as {
          creditType: string;
          balanceMillimes: number;
          todaySpentMillimes: number;
        }[]
      )[0],
    ).toMatchObject({
      creditType: 'RESTAURATION',
      balanceMillimes: 41_500,
      todaySpentMillimes: 18_500,
    });
    const history = await employee.call('GET', '/v1/employee/operations');
    expect((history.body.data as { type: string }[]).map((operation) => operation.type)).toContain(
      'PAYMENT',
    );
  });

  it('locks the PIN after 3 failures', async () => {
    const { client: employee } = await fundedEmployee(10_000n);
    const merchant = await createMerchant();
    const body = {
      merchantCode: merchant.paymentCode,
      creditType: 'RESTAURATION',
      amountMillimes: 1_000,
      pin: '0000',
    };
    expect(
      (await employee.call('POST', '/v1/employee/payments', { body, headers: key() })).body.code,
    ).toBe('PIN_INVALID');
    expect(
      (await employee.call('POST', '/v1/employee/payments', { body, headers: key() })).body.code,
    ).toBe('PIN_INVALID');
    // Third failure: locked, same code, with the time left (securite S01).
    const third = await employee.call('POST', '/v1/employee/payments', { body, headers: key() });
    expect(third.body.code).toBe('PIN_INVALID');
    expect(third.body.details).toMatchObject({ retryAfterSeconds: expect.any(Number) as number });
    const right = await employee.call('POST', '/v1/employee/payments', {
      body: { ...body, pin: PIN },
      headers: key(),
    });
    expect(right.body.code).toBe('PIN_INVALID');
  });
});

describe('payment of a merchant by its code', () => {
  it('pays only with a type the merchant accepts, within balance and daily limit', async () => {
    const { client: employee } = await fundedEmployee(100_000n);
    const merchant = await createMerchant(['RESTAURATION']);
    const pay = (creditType: string, amountMillimes: number) =>
      employee.call('POST', '/v1/employee/payments', {
        body: { merchantCode: merchant.paymentCode, creditType, amountMillimes, pin: PIN },
        headers: key(),
      });

    const lookup = await employee.call('GET', `/v1/employee/merchants/${merchant.paymentCode}`);
    expect(lookup.body).toMatchObject({
      merchantName: merchant.name,
      acceptedCreditTypes: ['RESTAURATION'],
    });
    expect((await pay('CADEAUX', 1_000)).status).toBe(400);
    const ok = await pay('RESTAURATION', 50_000);
    expect(ok.status).toBe(201);
    expect(ok.body.balanceAfterMillimes).toBe(50_000);
    // Daily limit of RESTAURATION: 80 000 (50 000 spent): 40 000 more is over by 10 000.
    expect((await pay('RESTAURATION', 40_000)).body).toMatchObject({
      code: 'LIMIT_EXCEEDED',
      details: { limitType: 'DAILY', remainingMillimes: 30_000 },
    });
    expect((await employee.call('GET', '/v1/employee/merchants/000000')).status).toBe(404);
  });

  it('refuses beyond the balance with the missing amount (payer only)', async () => {
    const { client: employee } = await fundedEmployee(30_000n);
    const merchant = await createMerchant();
    const refused = await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 45_000,
        pin: PIN,
      },
      headers: key(),
    });
    expect(refused.body).toMatchObject({
      code: 'INSUFFICIENT_FUNDS',
      details: { missingMillimes: 15_000 },
    });
  });
});

describe('payout and settlement', () => {
  it('freezes the rate in the request, settles the batch at its date, keeps the books balanced', async () => {
    const { client: employee } = await fundedEmployee(80_000n);
    const merchant = await createMerchant();
    const shop = await merchantClient(merchant.id);
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 45_000,
        pin: PIN,
      },
      headers: key(),
    });

    expect(
      (
        await shop.call('POST', '/v1/merchant/payout-quotes', {
          body: { creditType: 'RESTAURATION', grossMillimes: 5_000 },
        })
      ).status,
    ).toBe(400);
    const tooMuch = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 50_000 },
    });
    expect(tooMuch.body.code).toBe('INSUFFICIENT_FUNDS');
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 45_000 },
    });
    expect(quote.body).toMatchObject({
      grossMillimes: 45_000,
      commissionRateBps: 200,
      commissionMillimes: 900,
      netMillimes: 44_100,
      availableMillimes: 45_000,
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    expect(requested.status).toBe(201);
    expect(requested.body).toMatchObject({
      status: 'REQUESTED',
      commissionRateBps: 200,
      netMillimes: 44_100,
    });
    expect(String(requested.body.maskedIban)).toMatch(/^•••• \d{4}$/);
    expect((await shop.call('GET', '/v1/merchant/receivables')).body.totalMillimes).toBe(0);
    // A quote is used once.
    expect(
      (
        await shop.call('POST', '/v1/merchant/payouts', {
          body: { quoteId: quote.body.quoteId },
          headers: key(),
        })
      ).status,
    ).toBe(409);

    const id = String(requested.body.id);
    const approved = await admin.call('POST', `/v1/admin/payout-requests/${id}/approve`, {
      headers: key(),
    });
    expect(approved.body).toMatchObject({ status: 'CHECKED', merchantName: merchant.name });
    expect(String(approved.body.iban)).toMatch(/^TN\d{22}$/);

    // The batch date comes: the settlement job executes it.
    const owner = await ownerClient();
    await owner.query(
      `UPDATE settlement_batches SET settlement_date = current_date WHERE id = $1`,
      [approved.body.batchId],
    );
    await owner.end();
    await app.get(PayoutsService).executeDueBatches();
    const detail = await shop.call('GET', `/v1/merchant/payouts/${id}`);
    expect((detail.body.history as { status: string }[]).map((event) => event.status)).toEqual([
      'REQUESTED',
      'CHECKED',
      'SENT',
      'EXECUTED',
    ]);
    const payments = await shop.call('GET', '/v1/merchant/payments');
    expect((payments.body.data as { status: string }[])[0]?.status).toBe('SETTLED');
    const settlements = await shop.call('GET', '/v1/merchant/settlements');
    expect(
      (
        settlements.body.data as { status: string; paymentsCount: number; netMillimes: number }[]
      )[0],
    ).toMatchObject({ status: 'PAID', paymentsCount: 1, netMillimes: 44_100 });
    const books = await db.system((tx) => ledger.reconcile(tx));
    expect(books.ok).toBe(true);
  });

  it("applies the merchant's own rate when it has one (decision of 2026-10-14)", async () => {
    const { client: employee } = await fundedEmployee(80_000n);
    const merchant = await createMerchant(['RESTAURATION'], 250);
    const shop = await merchantClient(merchant.id);
    await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 45_000,
        pin: PIN,
      },
      headers: key(),
    });
    expect((await shop.call('GET', '/v1/merchant/dashboard')).body.commissionRateBps).toBe(250);
    const payments = await shop.call('GET', '/v1/merchant/payments');
    const paymentId = String((payments.body.data as { id: string }[])[0]?.id);
    expect(
      (await shop.call('GET', `/v1/merchant/payments/${paymentId}`)).body.commissionRateBps,
    ).toBe(250);
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 45_000 },
    });
    expect(quote.body).toMatchObject({
      commissionRateBps: 250,
      commissionMillimes: 1_125,
      netMillimes: 43_875,
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    expect(requested.body).toMatchObject({ commissionRateBps: 250, netMillimes: 43_875 });
    // Without its own profile, a shop gets the rate of the credit type (200 for Restauration).
    const plain = await merchantClient((await createMerchant()).id);
    expect((await plain.call('GET', '/v1/merchant/dashboard')).body.commissionRateBps).toBeNull();
  });

  it('gives the balance back when the request is rejected (reversal)', async () => {
    const { client: employee } = await fundedEmployee(50_000n);
    const merchant = await createMerchant();
    const shop = await merchantClient(merchant.id);
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.'));
    await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 30_000,
        pin: PIN,
      },
      headers: key(),
    });
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 30_000 },
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    const wallet = accounts.merchantWallet(merchant.id, 'RESTAURATION');
    expect(await db.system((tx) => ledger.balance(tx, wallet))).toBe(0n);
    const rejected = await admin.call(
      'POST',
      `/v1/admin/payout-requests/${String(requested.body.id)}/reject`,
      { body: { reason: 'IBAN non conforme au KYC' }, headers: key() },
    );
    expect(rejected.body.status).toBe('REJECTED');
    expect(await db.system((tx) => ledger.balance(tx, wallet))).toBe(30_000n);
    expect((await shop.call('GET', '/v1/merchant/receivables')).body.totalMillimes).toBe(30_000);
  });

  it('keeps each merchant in its own payments (404 for another merchant)', async () => {
    const { client: employee } = await fundedEmployee(20_000n);
    const merchant = await createMerchant();
    const paid = await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 5_000,
        pin: PIN,
      },
      headers: key(),
    });
    expect(paid.status).toBe(201);
    const shop = await merchantClient(merchant.id);
    const paymentId = String(
      ((await shop.call('GET', '/v1/merchant/payments')).body.data as { id: string }[])[0]?.id,
    );
    const other = await merchantClient((await createMerchant()).id);
    expect((await other.call('GET', `/v1/merchant/payments/${paymentId}`)).status).toBe(404);
    expect((await other.call('GET', '/v1/merchant/payments')).body.data).toEqual([]);
  });
});

describe('expired credits (destination set by the administrator, decision of 2026-10-14)', () => {
  /** An employee of a new company with an already expired lot of `amount` Restauration credits. */
  async function expiredLot(amount: bigint) {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    await db.system(async (tx) => {
      const posted = await ledger.post(tx, {
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
        expiresAt: new Date(Date.now() - 86_400_000),
        sourceTransactionId: posted.transactionId,
      });
    });
    return { company, employee };
  }
  const destination = (value: 'PLATFORM_REVENUE' | 'COMPANY_RETURN') =>
    db.system((tx) =>
      tx.platformSettings.update({ where: { id: 1 }, data: { expiredCreditsDestination: value } }),
    );
  const balanceOf = (account: Parameters<typeof ledger.balance>[1]) =>
    db.system((tx) => ledger.balance(tx, account));

  it('go back to the company wallet of the same type when so set', async () => {
    const { company, employee } = await expiredLot(7_000n);
    await destination('COMPANY_RETURN');
    try {
      await app.get(JobsService).expireLots();
    } finally {
      await destination('PLATFORM_REVENUE');
    }
    expect(await balanceOf(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(0n);
    expect(await balanceOf(accounts.companyWallet(company.id, 'RESTAURATION'))).toBe(7_000n);
    const traced = await db.system((tx) =>
      tx.creditExpiry.findMany({ where: { employeeId: employee.id } }),
    );
    expect(traced.map((row) => row.amountMillimes)).toEqual([7_000n]);
  });

  it('go to the provisional REVENUE_EXPIRED account by default', async () => {
    await destination('PLATFORM_REVENUE');
    const { company, employee } = await expiredLot(3_000n);
    const before = await balanceOf(accounts.expiredCredits());
    await app.get(JobsService).expireLots();
    expect(await balanceOf(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(0n);
    expect(await balanceOf(accounts.companyWallet(company.id, 'RESTAURATION'))).toBe(0n);
    expect((await balanceOf(accounts.expiredCredits())) - before).toBe(3_000n);
    expect((await db.system((tx) => ledger.reconcile(tx))).ok).toBe(true);
  });
});

describe('daily reconciliation (ledger-auditor C8)', () => {
  it('raises an audited alert naming the account when the books do not reconcile', async () => {
    const jobs = app.get(JobsService);
    expect(await jobs.reconcileBooks()).toBe(true);
    const { employee } = await fundedEmployee(5_000n);
    const wallet = accounts.employeeWallet(employee.id, 'RESTAURATION').code;
    const owner = await ownerClient();
    const shift = (delta: number) =>
      owner.query(
        `UPDATE credit_lots SET remaining_millimes = remaining_millimes + $2
          WHERE account_id = (SELECT id FROM ledger_accounts WHERE code = $1)`,
        [wallet, delta],
      );
    await shift(-1);
    try {
      expect(await jobs.reconcileBooks()).toBe(false);
      const alert = await db.system((tx) =>
        tx.auditLog.findFirst({
          where: { action: 'ledger.reconcileFailed' },
          orderBy: { occurredAt: 'desc' },
        }),
      );
      expect(alert?.target).toContain(wallet);
    } finally {
      await shift(1);
      await owner.end();
    }
    expect(await jobs.reconcileBooks()).toBe(true);
  });
});
