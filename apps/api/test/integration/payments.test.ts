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
const { createCompany, createEmployee, createUser, sealed, seedSettings, signedIn, oneLineGrid, ledgerLines } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const ledger = new LedgerService();
let app = await createApp(env, false);
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
  createdBy?: string,
) {
  return db.system(async (tx) => {
    return tx.merchant.create({
      data: {
        name: `Café ${randomUUID().slice(0, 5)}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: sealed('+21671000001'),
        email: 'cafe@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: types,
        paymentCode: String(randomInt(100_000, 999_999)),
        iban: sealed(
          `TN59${String(randomInt(10 ** 9, 10 ** 10 - 1))}${String(randomInt(10 ** 9, 10 ** 10 - 1))}12`.slice(
            0,
            24,
          ),
        ),
        commissionGrids: oneLineGrid(ownRateBps ?? 200),
        createdBy: createdBy ?? null,
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
      vatRateBps: 1_900,
      vatMillimes: 171,
      stampDutyMillimes: 1_000,
      netMillimes: 42_929,
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
      vatMillimes: 171,
      stampDutyMillimes: 1_000,
      netMillimes: 42_929,
    });
    expect(await ledgerLines(db, String(requested.body.reference))).toEqual([
      { code: 'MERCHANT_WALLET', direction: 'D', amount: 45_000 },
      { code: 'PAYOUT_PAYABLE', direction: 'C', amount: 42_929 },
      { code: 'REVENUE_MERCHANT_COMMISSION', direction: 'C', amount: 900 },
      { code: 'STAMP_DUTY', direction: 'C', amount: 1_000 },
      { code: 'VAT_COLLECTED', direction: 'C', amount: 171 },
    ]);
    expect(String(requested.body.maskedIban)).toMatch(/^•••• \d{4}$/);
    // Commission invoice of the payout in PDF (task 10): commission, VAT, stamp duty, net.
    const invoice = await fetch(`${base}/v1/merchant/payouts/${String(requested.body.id)}/invoice`, {
      headers: { Cookie: `__Host-fp_at=${shop.cookie('__Host-fp_at') ?? ''}` },
    });
    expect(invoice.status).toBe(200);
    const text = Buffer.from(await invoice.arrayBuffer()).toString('latin1');
    for (const expected of ['Commission FlexiPay (2 %)', '-0,171 TND', '-1,000 TND', '42,929 TND'])
      expect(text).toContain(expected);
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
      `UPDATE settlement_batches SET settlement_date = current_date, status = 'RELEASED' WHERE id = $1`,
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
    ).toMatchObject({ status: 'PAID', paymentsCount: 1, netMillimes: 42_929 });
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
      vatMillimes: 214,
      netMillimes: 42_661,
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    expect(requested.body).toMatchObject({ commissionRateBps: 250, netMillimes: 42_661 });
    // Every shop has a grid (decision of 2026-11-04): the dashboard shows its default rate.
    const plain = await merchantClient((await createMerchant()).id);
    expect((await plain.call('GET', '/v1/merchant/dashboard')).body.commissionRateBps).toBe(200);
  });

  it('refuses the request when the VAT or the stamp duty changed after the simulation', async () => {
    const { client: employee } = await fundedEmployee(60_000n);
    const merchant = await createMerchant();
    const shop = await merchantClient(merchant.id);
    await employee.call('POST', '/v1/employee/payments', {
      body: { merchantCode: merchant.paymentCode, creditType: 'RESTAURATION', amountMillimes: 45_000, pin: PIN },
      headers: key(),
    });
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 45_000 },
    });
    await db.system((tx) => tx.platformSettings.update({ where: { id: 1 }, data: { vatRateBps: 1_800 } }));
    try {
      const requested = await shop.call('POST', '/v1/merchant/payouts', {
        body: { quoteId: quote.body.quoteId },
        headers: key(),
      });
      expect(requested.status).toBe(409);
      const written = await db.system((tx) =>
        tx.payoutRequest.count({ where: { merchantId: merchant.id } }),
      );
      expect(written).toBe(0);
    } finally {
      await db.system((tx) => tx.platformSettings.update({ where: { id: 1 }, data: { vatRateBps: 1_900 } }));
    }
  });

  it('refuses a payout whose commission, VAT and stamp duty leave nothing to transfer', async () => {
    const { client: employee } = await fundedEmployee(60_000n);
    const merchant = await createMerchant(['RESTAURATION'], 10_000);
    const shop = await merchantClient(merchant.id);
    await employee.call('POST', '/v1/employee/payments', {
      body: { merchantCode: merchant.paymentCode, creditType: 'RESTAURATION', amountMillimes: 45_000, pin: PIN },
      headers: key(),
    });
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 45_000 },
    });
    expect(quote.status).toBe(400);
    expect(quote.body.details).toMatchObject({ fields: [{ pointer: '/grossMillimes', code: 'TOO_SMALL' }] });
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
    // The reversal gives the VAT and the stamp duty back too.
    const reversal = await ledgerLines(db, `${String(requested.body.reference)}-REJ`);
    expect(reversal.filter((line) => line.code === 'VAT_COLLECTED' || line.code === 'STAMP_DUTY')).toEqual([
      { code: 'STAMP_DUTY', direction: 'D', amount: 1_000 },
      { code: 'VAT_COLLECTED', direction: 'D', amount: Number(requested.body.vatMillimes) },
    ]);
    const books = await db.system((tx) => ledger.reconcile(tx));
    expect(books.taxMismatches).toEqual([]);
  });

  it('the administrator who created the merchant never approves its payouts (QY-03 b)', async () => {
    const { client: employee } = await fundedEmployee(20_000n);
    const creator = await createUser(db, env, 'ADMIN', {}, 'Créateur K.', 'SUPER_ADMIN');
    const merchant = await createMerchant(['RESTAURATION'], undefined, creator.id);
    const shop = await merchantClient(merchant.id);
    await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 20_000,
        pin: PIN,
      },
      headers: key(),
    });
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 20_000 },
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    const path = `/v1/admin/payout-requests/${String(requested.body.id)}/approve`;
    const own = await (await signedIn(base, creator)).call('POST', path, { headers: key() });
    expect(own.status).toBe(403);
    expect(
      await db.system((tx) =>
        tx.auditLog.count({ where: { action: 'fourEyes.refused', actorUserId: creator.id } }),
      ),
    ).toBe(1);
    const other = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Finance L.', 'FINANCE'),
    );
    expect((await other.call('POST', path, { headers: key() })).status).toBe(200);
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

/** A new app (its own sign-in rate limit: 30 per minute, src/common/http.ts). */
const freshApp = async () => {
  await app.close();
  app = await createApp(env, false);
  base = await listen(app);
};

describe('settlement batches: Finance release in four eyes, simulated bank (task 9)', () => {
  beforeAll(freshApp);

  /** A payout of 30 TND approved into its batch; the IBAN of the shop decides the bank return. */
  async function approvedPayout(iban?: string) {
    const { client: employee } = await fundedEmployee(30_000n);
    const merchant = await createMerchant();
    if (iban !== undefined)
      await db.system((tx) => tx.merchant.update({ where: { id: merchant.id }, data: { iban: sealed(iban) } }));
    const shop = await merchantClient(merchant.id);
    await employee.call('POST', '/v1/employee/payments', {
      body: { merchantCode: merchant.paymentCode, creditType: 'RESTAURATION', amountMillimes: 30_000, pin: PIN },
      headers: key(),
    });
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 30_000 },
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    const finance = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Finance A.', 'FINANCE'));
    const approved = await finance.call('POST', `/v1/admin/payout-requests/${String(requested.body.id)}/approve`, {
      headers: key(),
    });
    return { merchant, shop, finance, payoutId: String(requested.body.id), batchId: String(approved.body.batchId) };
  }

  const dueToday = async (batchId: string) => {
    const owner = await ownerClient();
    await owner.query('UPDATE settlement_batches SET settlement_date = current_date WHERE id = $1', [batchId]);
    await owner.end();
  };

  it('a batch leaves only once Finance released it in four eyes', async () => {
    const { finance, batchId, payoutId, shop } = await approvedPayout();
    await dueToday(batchId);
    // Not released: the job leaves it.
    await app.get(PayoutsService).executeDueBatches();
    expect((await shop.call('GET', `/v1/merchant/payouts/${payoutId}`)).body.status).toBe('CHECKED');
    const requested = await finance.call('POST', `/v1/admin/settlements/${batchId}/release-requests`, {
      body: { reason: 'Lot contrôlé' },
    });
    expect(requested.status).toBe(201);
    expect(requested.body).toMatchObject({ type: 'BATCH_RELEASE', status: 'PENDING' });
    const id = String(requested.body.id);
    expect((await finance.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(403);
    const second = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Finance B.', 'FINANCE'));
    expect((await second.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(200);
    expect((await finance.call('GET', `/v1/admin/settlements/${batchId}`)).body.status).toBe('RELEASED');
    await app.get(PayoutsService).executeDueBatches();
    const batch = await finance.call('GET', `/v1/admin/settlements/${batchId}`);
    expect(batch.body).toMatchObject({ status: 'PAID' });
    expect(String(batch.body.bankReference)).toMatch(/^SIM-/);
    expect((await shop.call('GET', `/v1/merchant/payouts/${payoutId}`)).body.status).toBe('EXECUTED');
    const books = await db.system((tx) => ledger.reconcile(tx));
    expect(books.ok).toBe(true);
  });

  it('a transfer rejected by the bank is reversed: the merchant gets its balance back and is told', async () => {
    const { merchant, shop, batchId, payoutId } = await approvedPayout('TN5912345678901234560000');
    const owner = await ownerClient();
    await owner.query(`UPDATE settlement_batches SET settlement_date = current_date, status = 'RELEASED' WHERE id = $1`, [batchId]);
    await owner.end();
    await app.get(PayoutsService).executeDueBatches();
    const detail = await shop.call('GET', `/v1/merchant/payouts/${payoutId}`);
    expect(detail.body.status).toBe('REJECTED');
    expect((detail.body.history as { status: string; reason?: string }[]).at(-1)).toMatchObject({
      status: 'REJECTED',
      reason: 'Compte clôturé',
    });
    expect(
      await db.system((tx) => ledger.balance(tx, accounts.merchantWallet(merchant.id, 'RESTAURATION'))),
    ).toBe(30_000n);
    expect((await shop.call('GET', '/v1/merchant/receivables')).body.totalMillimes).toBe(30_000);
    const books = await db.system((tx) => ledger.reconcile(tx));
    expect(books.ok).toBe(true);
  });

  it('a released batch cannot be released twice', async () => {
    const { finance, batchId } = await approvedPayout();
    const first = await finance.call('POST', `/v1/admin/settlements/${batchId}/release-requests`, {
      body: { reason: 'Lot contrôlé' },
    });
    expect(first.status).toBe(201);
    const again = await finance.call('POST', `/v1/admin/settlements/${batchId}/release-requests`, {
      body: { reason: 'Doublon' },
    });
    expect(again.status).toBe(409);
  });
});

describe('expired credits (destination set by the administrator, decision of 2026-10-14)', () => {
  beforeAll(freshApp);

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
      // R2: an alert in the Security screen, the balance itself is never corrected.
      const raised = await db.system((tx) =>
        tx.fraudAlert.findFirst({ where: { kind: 'LEDGER_MISMATCH' }, orderBy: { occurredAt: 'desc' } }),
      );
      expect(raised).toMatchObject({ severity: 'HIGH', status: 'OPEN' });
      expect(raised?.subject).toContain(wallet);
    } finally {
      await shift(1);
      await owner.end();
    }
    expect(await jobs.reconcileBooks()).toBe(true);
  });
});

// TEST-FIRST N4 (ledger-auditor): every financial route replays the same answer for the same
// Idempotency-Key and body, writes nothing more, and refuses the key reused with another body.
describe('replays (N4)', () => {
  beforeAll(freshApp);

  const entries = () => db.system((tx) => tx.ledgerEntry.count());

  it('a payment replayed with the same key is booked once', async () => {
    const { client: employee } = await fundedEmployee(40_000n);
    const merchant = await createMerchant();
    const body = {
      merchantCode: merchant.paymentCode,
      creditType: 'RESTAURATION',
      amountMillimes: 10_000,
      pin: PIN,
    };
    const headers = key();
    const first = await employee.call('POST', '/v1/employee/payments', { body, headers });
    expect(first.status).toBeLessThan(300);
    const before = await entries();
    const again = await employee.call('POST', '/v1/employee/payments', { body, headers });
    expect(again.status).toBe(first.status);
    expect(again.body).toEqual(first.body);
    expect(await entries()).toBe(before);
    const wallet = accounts.merchantWallet(merchant.id, 'RESTAURATION');
    expect(await db.system((tx) => ledger.balance(tx, wallet))).toBe(10_000n);
    const reused = await employee.call('POST', '/v1/employee/payments', {
      body: { ...body, amountMillimes: 9_000 },
      headers,
    });
    expect(reused.status).toBe(422);
    expect(reused.body.code).toBe('IDEMPOTENCY_KEY_REUSED');
  });

  it('a payout request replayed with the same key is booked once, even at the same time', async () => {
    const { client: employee } = await fundedEmployee(40_000n);
    const merchant = await createMerchant();
    const shop = await merchantClient(merchant.id);
    await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 20_000,
        pin: PIN,
      },
      headers: key(),
    });
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 20_000 },
    });
    const headers = key();
    const body = { quoteId: quote.body.quoteId };
    const [first, second] = await Promise.all([
      shop.call('POST', '/v1/merchant/payouts', { body, headers }),
      shop.call('POST', '/v1/merchant/payouts', { body, headers }),
    ]);
    // One books the payout; the other is the same answer replayed, or told to retry (409 with
    // Retry-After), never an error.
    const done = [first, second].filter((result) => result.status < 300);
    expect(done.length).toBeGreaterThanOrEqual(1);
    for (const result of done) expect(result.body.id).toBe(done[0]?.body.id);
    for (const result of [first, second].filter((item) => item.status >= 300)) {
      expect(result.status).toBe(409);
      expect(result.body.code).toBe('IDEMPOTENCY_REQUEST_IN_PROGRESS');
      expect(result.headers.get('retry-after')).not.toBeNull();
    }
    // Replayed later with the same key and body: the same answer, nothing more booked.
    const before = await entries();
    const later = await shop.call('POST', '/v1/merchant/payouts', { body, headers });
    expect(later.status).toBe(done[0]?.status);
    expect(later.body).toEqual(done[0]?.body);
    expect(await entries()).toBe(before);
    const wallet = accounts.merchantWallet(merchant.id, 'RESTAURATION');
    expect(await db.system((tx) => ledger.balance(tx, wallet))).toBe(0n);
    const payouts = await db.system((tx) =>
      tx.payoutRequest.count({ where: { merchantId: merchant.id } }),
    );
    expect(payouts).toBe(1);
    const reused = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: randomUUID() },
      headers,
    });
    expect(reused.status).toBe(422);
    expect(reused.body.code).toBe('IDEMPOTENCY_KEY_REUSED');
  });

  it('an allocation replayed with the same key credits the employee once', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    await db.system((tx) =>
      ledger.post(tx, {
        type: 'ALLOCATION',
        reference: 'TEST-N4',
        entries: [
          { account: accounts.bankEscrow(), direction: 'D', amount: 50_000n },
          {
            account: accounts.companyWallet(company.id, 'RESTAURATION'),
            direction: 'C',
            amount: 50_000n,
          },
        ],
      }),
    );
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.', 'OWNER'),
    );
    const body = {
      allocations: [
        { employeeId: employee.id, creditType: 'RESTAURATION', amountMillimes: 15_000 },
      ],
    };
    const headers = key();
    const first = await owner.call('POST', '/v1/company/allocations', { body, headers });
    expect(first.status).toBeLessThan(300);
    const before = await entries();
    const again = await owner.call('POST', '/v1/company/allocations', { body, headers });
    expect(again.body).toEqual(first.body);
    expect(await entries()).toBe(before);
    const wallet = accounts.employeeWallet(employee.id, 'RESTAURATION');
    expect(await db.system((tx) => ledger.balance(tx, wallet))).toBe(15_000n);
    const reused = await owner.call('POST', '/v1/company/allocations', {
      body: { allocations: [{ ...body.allocations[0], amountMillimes: 1_000 }] },
      headers,
    });
    expect(reused.status).toBe(422);
    expect(reused.body.code).toBe('IDEMPOTENCY_KEY_REUSED');
  });

  it('a financial route without Idempotency-Key is refused before anything', async () => {
    const { client: employee } = await fundedEmployee(10_000n);
    const merchant = await createMerchant();
    const before = await entries();
    const refused = await employee.call('POST', '/v1/employee/payments', {
      body: {
        merchantCode: merchant.paymentCode,
        creditType: 'RESTAURATION',
        amountMillimes: 1_000,
        pin: PIN,
      },
    });
    expect(refused.status).toBe(400);
    expect(refused.body.code).toBe('IDEMPOTENCY_KEY_REQUIRED');
    expect(await entries()).toBe(before);
  });
});
