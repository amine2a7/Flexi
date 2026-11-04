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
const { PayoutsService } = await import('../../src/payouts/payouts.service.js');
const { commissionOf } = await import('../../src/common/money.js');
const { JobsService } = await import('../../src/jobs/jobs.service.js');
const { ownerClient } = await import('./setup.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { createCompany, createEmployee, createUser, sealed, seedSettings, signedIn, oneLineGrid } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
let app = await createApp(env, false);
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
type SubRole = 'SUPER_ADMIN' | 'COMPLIANCE' | 'FINANCE' | 'SUPPORT';
const signIn = async (subRole: SubRole) => {
  const user = await createUser(db, env, 'ADMIN', {}, `Admin ${subRole}`, subRole);
  return { user, client: await signedIn(base, user) };
};
/** One session per role: signing in is limited per minute. */
const admins = new Map<SubRole, ReturnType<typeof signIn>>();
const admin = (subRole: SubRole) => {
  const known = admins.get(subRole);
  if (known !== undefined) return known;
  const client = signIn(subRole);
  admins.set(subRole, client);
  return client;
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
  return { employee, merchant, payment, payer };
}

/** Payment of the same employee at the same shop. */
const pay = async (
  payer: Awaited<ReturnType<typeof confirmedPayment>>['payer'],
  merchantCode: string,
  amount: number,
) => {
  const paid = await payer.call('POST', '/v1/employee/payments', {
    body: { merchantCode, creditType: 'RESTAURATION', amountMillimes: amount, pin: PIN },
    headers: key(),
  });
  expect(paid.status).toBeLessThan(300);
  return db.system((tx) =>
    tx.payment.findFirstOrThrow({
      where: { reference: String(paid.body.reference) },
    }),
  );
};
const shopOf = async (merchantId: string) =>
  signedIn(base, await createUser(db, env, 'MERCHANT', { merchantId }, 'Sami B.'));
type Shop = Awaited<ReturnType<typeof shopOf>>;
const requestPayout = async (shop: Shop, gross: number) => {
  const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
    body: { creditType: 'RESTAURATION', grossMillimes: gross },
  });
  const requested = await shop.call('POST', '/v1/merchant/payouts', {
    body: { quoteId: quote.body.quoteId },
    headers: key(),
  });
  expect(requested.status).toBeLessThan(300);
  return requested.body;
};
const approvePayout = async (finance: Awaited<ReturnType<typeof admin>>, payoutId: string) => {
  const approved = await finance.client.call(
    'POST',
    `/v1/admin/payout-requests/${payoutId}/approve`,
    {
      headers: key(),
    },
  );
  expect(approved.status).toBe(200);
  return String(approved.body.batchId);
};
/** The settlement date of the batch has come: the job executes it. */
const runBatch = async (batchId: string) => {
  const owner = await ownerClient();
  await owner.query('UPDATE settlement_batches SET settlement_date = current_date WHERE id = $1', [
    batchId,
  ]);
  await owner.end();
  await app.get(PayoutsService).executeDueBatches();
};
const openDispute = async (ops: Awaited<ReturnType<typeof admin>>, paymentId: string) => {
  const opened = await ops.client.call('POST', '/v1/admin/disputes', {
    body: { paymentId, ...REASON },
    headers: key(),
  });
  expect(opened.status).toBe(201);
  return opened.body;
};
const rejectDispute = async (ops: Awaited<ReturnType<typeof admin>>, id: string) => {
  const rejected = await ops.client.call('POST', `/v1/admin/disputes/${id}/reject`, {
    body: { reason: 'Le paiement est conforme au ticket de caisse.' },
    headers: key(),
  });
  expect(rejected.status).toBe(200);
};
/** Accepted by Opérations: the id of the approval waiting for Finance. */
const acceptDispute = async (
  ops: Awaited<ReturnType<typeof admin>>,
  dispute: Record<string, unknown>,
) => {
  const accepted = await ops.client.call(
    'POST',
    `/v1/admin/disputes/${String(dispute.id)}/accept`,
    {
      body: { reason: 'Double débit confirmé par le commerçant.' },
      headers: key(),
    },
  );
  expect(accepted.status).toBe(200);
  const approval = await db.system((tx) =>
    tx.approval.findFirstOrThrow({
      where: {
        type: 'DISPUTE_REFUND',
        status: 'PENDING',
        subject: { contains: String(dispute.reference) },
      },
    }),
  );
  return approval.id;
};
/** Accepted by Opérations, approved by Finance. */
const refundDispute = async (
  ops: Awaited<ReturnType<typeof admin>>,
  finance: Awaited<ReturnType<typeof admin>>,
  dispute: Record<string, unknown>,
) => {
  const approval = await acceptDispute(ops, dispute);
  const done = await finance.client.call('POST', `/v1/admin/approvals/${approval}/approve`, {
    headers: key(),
  });
  expect(done.status).toBe(200);
};
const reconciled = async () => {
  const report = await db.system((tx) => ledger.reconcile(tx));
  expect(report.mismatches).toEqual([]);
  expect(report.lotMismatches).toEqual([]);
  expect(report.holdMismatches).toEqual([]);
  expect(report.ok).toBe(true);
};

/** Signing in is limited per minute and per app: each group of tests gets its own app. */
const freshApp = async () => {
  await app.close();
  app = await createApp(env, false);
  base = await listen(app);
  admins.clear();
};

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
      (
        await ops.client.call('POST', `/v1/admin/approvals/${approval.id}/approve`, {
          headers: key(),
        })
      ).status,
    ).toBe(403);
    expect(await balance(employeeWallet)).toBe(75_000n);
    const approved = await finance.client.call(
      'POST',
      `/v1/admin/approvals/${approval.id}/approve`,
      { headers: key() },
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

  it('a payment is disputable for 30 days only', async () => {
    const ops = await admin('COMPLIANCE');
    const { payment } = await confirmedPayment(5_000);
    await db.system((tx) =>
      tx.payment.update({
        where: { id: payment.id },
        data: { confirmedAt: new Date(Date.now() - 31 * 86_400_000) },
      }),
    );
    const late = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    expect(late.status).toBe(409);
  });

  it('a payment in a payout not yet paid puts the payout on hold; accepted, the payout is rejected', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, merchant, payment } = await confirmedPayment(30_000);
    const shop = await signedIn(
      base,
      await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Sami B.'),
    );
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 30_000 },
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    const payoutId = String(requested.body.id);
    const opened = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    expect(opened.status).toBe(201);
    expect((await shop.call('GET', `/v1/merchant/payouts/${payoutId}`)).body.status).toBe(
      'ON_HOLD',
    );
    const approve = await finance.client.call(
      'POST',
      `/v1/admin/payout-requests/${payoutId}/approve`,
      { headers: key() },
    );
    expect(approve.status).toBe(409);
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
    const done = await finance.client.call('POST', `/v1/admin/approvals/${approval.id}/approve`, {
      headers: key(),
    });
    expect(done.status).toBe(200);
    expect((await shop.call('GET', `/v1/merchant/payouts/${payoutId}`)).body.status).toBe(
      'REJECTED',
    );
    expect(await balance(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(100_000n);
    expect(await balance(accounts.merchantWallet(merchant.id, 'RESTAURATION'))).toBe(0n);
  });

  it('a rejected dispute gives the held payout its status back', async () => {
    const ops = await admin('COMPLIANCE');
    const { merchant, payment } = await confirmedPayment(30_000);
    const shop = await signedIn(
      base,
      await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Sami B.'),
    );
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 30_000 },
    });
    const requested = await shop.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    const opened = await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    await ops.client.call('POST', `/v1/admin/disputes/${String(opened.body.id)}/reject`, {
      body: { reason: 'Le paiement est conforme au ticket de caisse.' },
      headers: key(),
    });
    const back = await shop.call('GET', `/v1/merchant/payouts/${String(requested.body.id)}`);
    expect(back.body.status).toBe('REQUESTED');
  });

  it('an accepted dispute on a paid payment cancels its commission; the rest is a debt deducted from the next settlement', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, merchant, payment, payer } = await confirmedPayment(20_000);
    const shop = await shopOf(merchant.id);
    const paid = await requestPayout(shop, 20_000);
    await runBatch(await approvePayout(finance, String(paid.id)));
    const commission = commissionOf(20_000n, Number(paid.commissionRateBps));
    expect(commission).toBeGreaterThan(0n);
    const revenue = () => db.system((tx) => ledger.balance(tx, accounts.merchantCommission()));
    const debt = () => db.system((tx) => ledger.balance(tx, accounts.merchantDebt(merchant.id)));
    const before = await revenue();
    const dispute = await openDispute(ops, payment.id);
    await refundDispute(ops, finance, dispute);
    expect(await balance(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(100_000n);
    expect(await revenue()).toBe(before - commission);
    expect(await debt()).toBe(20_000n - commission);
    await reconciled();
    // Next settlement of the merchant: the debt is deducted from what the bank sends.
    await pay(payer, merchant.paymentCode, 50_000);
    const next = await requestPayout(shop, 50_000);
    await runBatch(await approvePayout(finance, String(next.id)));
    expect(await debt()).toBe(0n);
    const settled = await shop.call('GET', `/v1/merchant/payouts/${String(next.id)}`);
    expect(settled.body.deductedMillimes).toBe(Number(20_000n - commission));
    await reconciled();
  });

  it('a debt larger than a settlement is deducted over two settlements', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment, payer } = await confirmedPayment(40_000);
    const shop = await shopOf(merchant.id);
    const paid = await requestPayout(shop, 40_000);
    await runBatch(await approvePayout(finance, String(paid.id)));
    const dispute = await openDispute(ops, payment.id);
    await refundDispute(ops, finance, dispute);
    const debt = () => db.system((tx) => ledger.balance(tx, accounts.merchantDebt(merchant.id)));
    const owed = await debt();
    await pay(payer, merchant.paymentCode, 20_000);
    const first = await requestPayout(shop, 20_000);
    await runBatch(await approvePayout(finance, String(first.id)));
    const firstPaid = await shop.call('GET', `/v1/merchant/payouts/${String(first.id)}`);
    expect(firstPaid.body.deductedMillimes).toBe(firstPaid.body.netMillimes);
    expect(await debt()).toBe(owed - BigInt(Number(firstPaid.body.netMillimes)));
    await pay(payer, merchant.paymentCode, 40_000);
    const second = await requestPayout(shop, 40_000);
    await runBatch(await approvePayout(finance, String(second.id)));
    expect(await debt()).toBe(0n);
    await reconciled();
  });
});

describe('disputes and payouts (N2)', () => {
  beforeAll(freshApp);

  it('a payout held after its check leaves its batch; rejected later, it joins the next batch and is paid', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment } = await confirmedPayment(30_000);
    const shop = await shopOf(merchant.id);
    const payout = await requestPayout(shop, 30_000);
    const batchId = await approvePayout(finance, String(payout.id));
    const dispute = await openDispute(ops, payment.id);
    // The batch goes out without the held payout.
    await runBatch(batchId);
    const held = await db.system((tx) =>
      tx.payoutRequest.findUniqueOrThrow({ where: { id: String(payout.id) } }),
    );
    expect(held.status).toBe('ON_HOLD');
    expect(held.batchId).toBeNull();
    await rejectDispute(ops, String(dispute.id));
    const back = await db.system((tx) =>
      tx.payoutRequest.findUniqueOrThrow({ where: { id: String(payout.id) } }),
    );
    expect(back.status).toBe('CHECKED');
    expect(back.batchId).not.toBeNull();
    expect(back.batchId).not.toBe(batchId);
    await runBatch(String(back.batchId));
    const done = await shop.call('GET', `/v1/merchant/payouts/${String(payout.id)}`);
    expect(done.body.status).toBe('EXECUTED');
    const settled = await db.system((tx) =>
      tx.payment.findUniqueOrThrow({ where: { id: payment.id } }),
    );
    expect(settled.status).toBe('SETTLED');
    await reconciled();
  });

  it('a payout stays held until the last open dispute on it is closed', async () => {
    const ops = await admin('COMPLIANCE');
    const { merchant, payment, payer } = await confirmedPayment(10_000);
    const other = await pay(payer, merchant.paymentCode, 20_000);
    const shop = await shopOf(merchant.id);
    const payout = await requestPayout(shop, 30_000);
    const first = await openDispute(ops, payment.id);
    const second = await openDispute(ops, other.id);
    await rejectDispute(ops, String(first.id));
    const stillHeld = await shop.call('GET', `/v1/merchant/payouts/${String(payout.id)}`);
    expect(stillHeld.body.status).toBe('ON_HOLD');
    await rejectDispute(ops, String(second.id));
    const released = await shop.call('GET', `/v1/merchant/payouts/${String(payout.id)}`);
    expect(released.body.status).toBe('REQUESTED');
    await reconciled();
  });

  it('two disputes on a payout: the first refund reverses it and holds the second amount, never a double debit', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, merchant, payment, payer } = await confirmedPayment(10_000);
    const other = await pay(payer, merchant.paymentCode, 20_000);
    const shop = await shopOf(merchant.id);
    const payout = await requestPayout(shop, 30_000);
    const first = await openDispute(ops, payment.id);
    const second = await openDispute(ops, other.id);
    await refundDispute(ops, finance, first);
    const wallet = accounts.merchantWallet(merchant.id, 'RESTAURATION');
    const hold = accounts.disputeHold(merchant.id, 'RESTAURATION');
    // Reversed payout: 30 000 back, 10 000 refunded, 20 000 held for the open dispute.
    expect((await shop.call('GET', `/v1/merchant/payouts/${String(payout.id)}`)).body.status).toBe(
      'REJECTED',
    );
    expect(await balance(wallet)).toBe(0n);
    expect(await balance(hold)).toBe(20_000n);
    await refundDispute(ops, finance, second);
    expect(await balance(hold)).toBe(0n);
    expect(await balance(wallet)).toBe(0n);
    expect(await balance(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(100_000n);
    const debt = await db.system((tx) => ledger.balance(tx, accounts.merchantDebt(merchant.id)));
    expect(debt).toBe(0n);
    await reconciled();
  });

  it('after the first refund, the second dispute rejected frees its amount for the merchant', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment, payer } = await confirmedPayment(10_000);
    const other = await pay(payer, merchant.paymentCode, 20_000);
    const shop = await shopOf(merchant.id);
    await requestPayout(shop, 30_000);
    const first = await openDispute(ops, payment.id);
    const second = await openDispute(ops, other.id);
    await refundDispute(ops, finance, first);
    await rejectDispute(ops, String(second.id));
    expect(await balance(accounts.merchantWallet(merchant.id, 'RESTAURATION'))).toBe(20_000n);
    const row = await db.system((tx) => tx.payment.findUniqueOrThrow({ where: { id: other.id } }));
    expect(row.status).toBe('CONFIRMED');
    expect(row.payoutId).toBeNull();
    await reconciled();
  });

  it('a rejected dispute on a paid payment leaves it settled', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment } = await confirmedPayment(20_000);
    const shop = await shopOf(merchant.id);
    const paid = await requestPayout(shop, 20_000);
    await runBatch(await approvePayout(finance, String(paid.id)));
    const dispute = await openDispute(ops, payment.id);
    await rejectDispute(ops, String(dispute.id));
    const row = await db.system((tx) =>
      tx.payment.findUniqueOrThrow({ where: { id: payment.id } }),
    );
    expect(row.status).toBe('SETTLED');
    await reconciled();
  });
});

describe('disputes: concurrency, cumul and reconciliation (N2)', () => {
  beforeAll(freshApp);

  it('two simultaneous approvals refund once', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, payment } = await confirmedPayment(10_000);
    const dispute = await openDispute(ops, payment.id);
    const approval = await acceptDispute(ops, dispute);
    const url = `/v1/admin/approvals/${approval}/approve`;
    const answers = await Promise.all([
      finance.client.call('POST', url, { headers: key() }),
      finance.client.call('POST', url, { headers: key() }),
    ]);
    expect(answers.filter((answer) => answer.status === 200).length).toBe(1);
    expect(await balance(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(100_000n);
    await reconciled();
  });

  it('the same key replays the answer of a refund without refunding twice', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, payment } = await confirmedPayment(10_000);
    const dispute = await openDispute(ops, payment.id);
    const approval = await acceptDispute(ops, dispute);
    const url = `/v1/admin/approvals/${approval}/approve`;
    const headers = key();
    const first = await finance.client.call('POST', url, { headers });
    const replay = await finance.client.call('POST', url, { headers });
    expect(first.status).toBe(200);
    expect(replay.status).toBe(200);
    expect(await balance(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(100_000n);
    await reconciled();
  });

  it('several refunds on a paid payout never cancel more than its commission', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment, payer } = await confirmedPayment(11_030);
    const other = await pay(payer, merchant.paymentCode, 11_030);
    const shop = await shopOf(merchant.id);
    const paid = await requestPayout(shop, 22_060);
    await runBatch(await approvePayout(finance, String(paid.id)));
    const commission = BigInt(Number(paid.commissionMillimes));
    const share = commissionOf(11_030n, Number(paid.commissionRateBps));
    // Rounded up twice: the two shares add up to more than the commission of the payout.
    expect(share * 2n).toBeGreaterThan(commission);
    const revenue = () => db.system((tx) => ledger.balance(tx, accounts.merchantCommission()));
    const before = await revenue();
    await refundDispute(ops, finance, await openDispute(ops, payment.id));
    await refundDispute(ops, finance, await openDispute(ops, other.id));
    expect(await revenue()).toBe(before - commission);
    const debt = await db.system((tx) => ledger.balance(tx, accounts.merchantDebt(merchant.id)));
    expect(debt).toBe(22_060n - commission);
    await reconciled();
  });

  it('the reversal of a held payout also holds a dispute awaiting Finance', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, merchant, payment, payer } = await confirmedPayment(10_000);
    const other = await pay(payer, merchant.paymentCode, 20_000);
    const shop = await shopOf(merchant.id);
    await requestPayout(shop, 30_000);
    const first = await openDispute(ops, payment.id);
    const second = await openDispute(ops, other.id);
    const waiting = await acceptDispute(ops, second);
    await refundDispute(ops, finance, first);
    expect(await balance(accounts.disputeHold(merchant.id, 'RESTAURATION'))).toBe(20_000n);
    await reconciled();
    const done = await finance.client.call('POST', `/v1/admin/approvals/${waiting}/approve`, {
      headers: key(),
    });
    expect(done.status).toBe(200);
    expect(await balance(accounts.disputeHold(merchant.id, 'RESTAURATION'))).toBe(0n);
    expect(await balance(accounts.employeeWallet(employee.id, 'RESTAURATION'))).toBe(100_000n);
    await reconciled();
  });

  it('a payment of a payout rejected by Finance is disputed like a free payment', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment } = await confirmedPayment(20_000);
    const shop = await shopOf(merchant.id);
    const payout = await requestPayout(shop, 20_000);
    const rejected = await finance.client.call(
      'POST',
      `/v1/admin/payout-requests/${String(payout.id)}/reject`,
      { body: { reason: 'RIB du commerçant à vérifier.' }, headers: key() },
    );
    expect(rejected.status).toBe(200);
    await openDispute(ops, payment.id);
    expect(await balance(accounts.merchantWallet(merchant.id, 'RESTAURATION'))).toBe(0n);
    expect(await balance(accounts.disputeHold(merchant.id, 'RESTAURATION'))).toBe(20_000n);
    await reconciled();
  });

  it('a refund refused by Finance keeps the payout held; rejected, it resumes', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment } = await confirmedPayment(20_000);
    const shop = await shopOf(merchant.id);
    const payout = await requestPayout(shop, 20_000);
    const dispute = await openDispute(ops, payment.id);
    const approval = await acceptDispute(ops, dispute);
    const refused = await finance.client.call('POST', `/v1/admin/approvals/${approval}/reject`, {
      body: { reason: 'Justificatif insuffisant au dossier.' },
    });
    expect(refused.status).toBe(200);
    const held = await shop.call('GET', `/v1/merchant/payouts/${String(payout.id)}`);
    expect(held.body.status).toBe('ON_HOLD');
    await rejectDispute(ops, String(dispute.id));
    const resumed = await shop.call('GET', `/v1/merchant/payouts/${String(payout.id)}`);
    expect(resumed.body.status).toBe('REQUESTED');
    await reconciled();
  });

  it('a dispute opened while the settlement job runs leaves the books balanced', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { merchant, payment } = await confirmedPayment(20_000);
    const shop = await shopOf(merchant.id);
    const payout = await requestPayout(shop, 20_000);
    const batchId = await approvePayout(finance, String(payout.id));
    const owner = await ownerClient();
    await owner.query(
      'UPDATE settlement_batches SET settlement_date = current_date WHERE id = $1',
      [batchId],
    );
    await owner.end();
    const [opened] = await Promise.all([
      ops.client.call('POST', '/v1/admin/disputes', {
        body: { paymentId: payment.id, ...REASON },
        headers: key(),
      }),
      app.get(PayoutsService).executeDueBatches(),
    ]);
    expect(opened.status).toBe(201);
    const after = await shop.call('GET', `/v1/merchant/payouts/${String(payout.id)}`);
    expect(['ON_HOLD', 'EXECUTED']).toContain(after.body.status);
    await reconciled();
  });

  it('a dispute hold without its dispute is a reconciliation alert', async () => {
    const { merchant } = await confirmedPayment(20_000);
    const hold = accounts.disputeHold(merchant.id, 'RESTAURATION');
    const posted = await db.system((tx) =>
      ledger.post(tx, {
        type: 'TEST_HOLD_GAP',
        reference: 'TEST-HOLD-GAP',
        entries: [
          { account: accounts.bankEscrow(), direction: 'D', amount: 5_000n },
          { account: hold, direction: 'C', amount: 5_000n },
        ],
      }),
    );
    const report = await db.system((tx) => ledger.reconcile(tx));
    expect(report.ok).toBe(false);
    expect(report.holdMismatches).toEqual([hold.code]);
    expect(await app.get(JobsService).reconcileBooks()).toBe(false);
    const alert = await db.system((tx) =>
      tx.auditLog.findFirst({
        where: { action: 'ledger.reconcileFailed' },
        orderBy: { occurredAt: 'desc' },
      }),
    );
    expect(alert?.target).toContain(hold.code.slice(0, 40));
    // The gap is removed: the other test files check that the books reconcile.
    await db.system((tx) => ledger.reverse(tx, posted.transactionId, 'TEST-HOLD-GAP-OUT'));
    await reconciled();
  });

  it('Finance reads the dispute file, read-only, and never the fraud alerts', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { payment } = await confirmedPayment(10_000);
    const dispute = await openDispute(ops, payment.id);
    const id = String(dispute.id);
    expect((await finance.client.call('GET', '/v1/admin/disputes')).status).toBe(200);
    expect((await finance.client.call('GET', `/v1/admin/disputes/${id}`)).status).toBe(200);
    expect((await finance.client.call('GET', '/v1/admin/fraud-alerts')).status).toBe(403);
    const note = await finance.client.call('POST', `/v1/admin/disputes/${id}/notes`, {
      body: { text: 'Essai de note.' },
    });
    expect(note.status).toBe(403);
    const reject = await finance.client.call('POST', `/v1/admin/disputes/${id}/reject`, {
      body: { reason: 'Le paiement est conforme au ticket de caisse.' },
      headers: key(),
    });
    expect(reject.status).toBe(403);
  });

  it('refunded credits are valid 30 days at least, even when their lot expired', async () => {
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    const { employee, payment } = await confirmedPayment(10_000);
    const code = accounts.employeeWallet(employee.id, 'RESTAURATION').code;
    await db.system(
      (tx) =>
        tx.$executeRaw`UPDATE credit_lots SET expires_at = now() - interval '1 day'
        WHERE account_id = (SELECT id FROM ledger_accounts WHERE code = ${code})`,
    );
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
    await finance.client.call('POST', `/v1/admin/approvals/${approval.id}/approve`, {
      headers: key(),
    });
    const lots = await db.system(
      (tx) =>
        tx.$queryRaw<{ expires_at: Date; remaining: bigint }[]>`
        SELECT l.expires_at, l.remaining_millimes AS remaining FROM credit_lots l
          JOIN ledger_accounts a ON a.id = l.account_id
         WHERE a.code = ${code} AND l.remaining_millimes > 0 AND l.expires_at > now()`,
    );
    expect(lots.reduce((sum, lot) => sum + lot.remaining, 0n)).toBe(10_000n);
    const soonest = Math.min(...lots.map((lot) => lot.expires_at.getTime()));
    expect(soonest).toBeGreaterThan(Date.now() + 29 * 86_400_000);
  });

  it('a disputed payment never joins a payout; the refunded payment is final', async () => {
    const ops = await admin('COMPLIANCE');
    const { merchant, payment } = await confirmedPayment(20_000);
    await ops.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    const disputed = await db.system((tx) =>
      tx.payment.findUniqueOrThrow({ where: { id: payment.id } }),
    );
    expect(disputed.status).toBe('DISPUTED');
    // Nothing left to request: the amount is held.
    const shop = await signedIn(
      base,
      await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Sami B.'),
    );
    const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: 20_000 },
    });
    expect(quote.status).toBeGreaterThanOrEqual(400);
  });

  it('a super-admin who accepted never approves the refund (four eyes), and it needs a key', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const finance = await admin('FINANCE');
    const { payment } = await confirmedPayment(5_000);
    const opened = await superAdmin.client.call('POST', '/v1/admin/disputes', {
      body: { paymentId: payment.id, ...REASON },
      headers: key(),
    });
    await superAdmin.client.call('POST', `/v1/admin/disputes/${String(opened.body.id)}/accept`, {
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
    const own = await superAdmin.client.call('POST', `/v1/admin/approvals/${approval.id}/approve`, {
      headers: key(),
    });
    expect(own.status).toBe(403);
    const noKey = await finance.client.call('POST', `/v1/admin/approvals/${approval.id}/approve`);
    expect(noKey.status).toBe(400);
    const done = await finance.client.call('POST', `/v1/admin/approvals/${approval.id}/approve`, {
      headers: key(),
    });
    expect(done.status).toBe(200);
    const refunded = await db.system((tx) =>
      tx.payment.findUniqueOrThrow({ where: { id: payment.id } }),
    );
    expect(refunded.status).toBe('REFUNDED');
  });
});
