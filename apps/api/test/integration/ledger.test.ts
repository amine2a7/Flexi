// TEST-FIRST: ledger invariants (spec 02 §4, §5, §8; CLAUDE.md money rules 1, 3, 4).
import { randomUUID } from 'node:crypto';
import { afterAll, describe, expect, it } from 'vitest';
import { loadTestEnv, ownerClient, appClient } from './setup.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, InsufficientFundsError, accounts } =
  await import('../../src/ledger/ledger.service.js');

const db = new DbService(loadEnv());
const ledger = new LedgerService();
const system = <T>(fn: Parameters<typeof db.run<T>>[1]) => db.run({ role: 'SYSTEM' }, fn);

/** Funds a company wallet of `type` from the escrow (order validated, no fee). */
async function fundCompany(
  companyId: string,
  amount: bigint,
  type: 'RESTAURATION' | 'CADEAUX' = 'RESTAURATION',
) {
  return system((tx) =>
    ledger.post(tx, {
      type: 'ORDER_VALIDATED',
      reference: `TEST-${randomUUID().slice(0, 8)}`,
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount },
        { account: accounts.companyWallet(companyId, type), direction: 'C', amount },
      ],
    }),
  );
}

/** Allocates `amount` from the company wallet to an employee wallet, with one lot. */
async function allocate(companyId: string, employeeId: string, amount: bigint, expiresAt: Date) {
  return system(async (tx) => {
    const posted = await ledger.post(tx, {
      type: 'ALLOCATION',
      reference: `ALLOC-${randomUUID().slice(0, 8)}`,
      entries: [
        { account: accounts.companyWallet(companyId, 'RESTAURATION'), direction: 'D', amount },
        { account: accounts.employeeWallet(employeeId, 'RESTAURATION'), direction: 'C', amount },
      ],
    });
    await ledger.addLot(tx, {
      account: accounts.employeeWallet(employeeId, 'RESTAURATION'),
      creditType: 'RESTAURATION',
      amount,
      expiresAt,
      sourceTransactionId: posted.transactionId,
    });
    return posted;
  });
}

/** Employee pays a merchant: FEFO lots, then the double entry (one debit per lot). */
async function pay(employeeId: string, merchantId: string, amount: bigint) {
  return system(async (tx) => {
    const wallet = accounts.employeeWallet(employeeId, 'RESTAURATION');
    const consumed = await ledger.consumeFefo(tx, wallet, amount, new Date());
    return ledger.post(tx, {
      type: 'PAYMENT',
      reference: `PAY-${randomUUID().slice(0, 8)}`,
      entries: [
        ...consumed.map((part) => ({
          account: wallet,
          direction: 'D' as const,
          amount: part.amount,
          lotId: part.lotId,
        })),
        { account: accounts.merchantWallet(merchantId, 'RESTAURATION'), direction: 'C', amount },
      ],
    });
  });
}

const balance = (account: ReturnType<typeof accounts.bankEscrow>) =>
  system((tx) => ledger.balance(tx, account));
const inAYear = () => new Date(Date.now() + 365 * 86_400_000);

afterAll(async () => {
  await db.onModuleDestroy();
});

describe('double entry', () => {
  it('posts a balanced transaction and updates every balance', async () => {
    const company = randomUUID();
    const before = await balance(accounts.bankEscrow());
    const posted = await system((tx) =>
      ledger.post(tx, {
        type: 'ORDER_VALIDATED',
        reference: 'CMD-TEST-1',
        entries: [
          { account: accounts.bankEscrow(), direction: 'D', amount: 50_500_000n },
          {
            account: accounts.companyWallet(company, 'RESTAURATION'),
            direction: 'C',
            amount: 50_000_000n,
          },
          { account: accounts.companyFees(), direction: 'C', amount: 500_000n },
        ],
      }),
    );
    expect(posted.transactionId).toMatch(/^[0-9a-f-]{36}$/);
    expect(await balance(accounts.bankEscrow())).toBe(before + 50_500_000n);
    expect(await balance(accounts.companyWallet(company, 'RESTAURATION'))).toBe(50_000_000n);
    const owner = await ownerClient();
    const sums = await owner.query<{ d: string; c: string }>(
      `SELECT sum(amount_millimes) FILTER (WHERE direction = 'D') AS d,
              sum(amount_millimes) FILTER (WHERE direction = 'C') AS c
         FROM ledger_entries WHERE transaction_id = $1`,
      [posted.transactionId],
    );
    await owner.end();
    expect(sums.rows[0]).toEqual({ d: '50500000', c: '50500000' });
  });

  it('refuses an unbalanced transaction in the service', async () => {
    await expect(
      system((tx) =>
        ledger.post(tx, {
          type: 'BROKEN',
          reference: 'X',
          entries: [
            { account: accounts.bankEscrow(), direction: 'D', amount: 1_000n },
            { account: accounts.companyFees(), direction: 'C', amount: 999n },
          ],
        }),
      ),
    ).rejects.toThrow(/balanced/);
  });

  it('refuses non-positive or non-integer amounts', async () => {
    for (const amount of [0n, -5n]) {
      await expect(
        system((tx) =>
          ledger.post(tx, {
            type: 'BROKEN',
            reference: 'X',
            entries: [
              { account: accounts.bankEscrow(), direction: 'D', amount },
              { account: accounts.companyFees(), direction: 'C', amount },
            ],
          }),
        ),
      ).rejects.toThrow();
    }
  });

  it('rejects at COMMIT an unbalanced transaction written directly in SQL (deferred trigger)', async () => {
    const owner = await ownerClient();
    const account = (
      await owner.query<{ id: string }>(`SELECT id FROM ledger_accounts WHERE code = 'BANK_ESCROW'`)
    ).rows[0]?.id;
    const tx = randomUUID();
    await owner.query('BEGIN');
    await owner.query(
      `INSERT INTO ledger_transactions (id, type, reference) VALUES ($1, 'RAW', 'RAW')`,
      [tx],
    );
    await owner.query(
      `INSERT INTO ledger_entries (transaction_id, account_id, direction, amount_millimes, balance_after_millimes)
       VALUES ($1, $2, 'D', 100, 0)`,
      [tx, account],
    );
    await expect(owner.query('COMMIT')).rejects.toMatchObject({ code: '23514' });
    await owner.end();
  });
});

describe('append-only ledger', () => {
  it('forbids UPDATE and DELETE on entries and transactions, even for the owner', async () => {
    await fundCompany(randomUUID(), 10_000n);
    const owner = await ownerClient();
    await expect(owner.query('UPDATE ledger_entries SET amount_millimes = 1')).rejects.toThrow(
      /append-only/,
    );
    await expect(owner.query('DELETE FROM ledger_entries')).rejects.toMatchObject({
      code: '42501',
    });
    await expect(owner.query(`UPDATE ledger_transactions SET reference = 'x'`)).rejects.toThrow(
      /append-only/,
    );
    await expect(owner.query('DELETE FROM ledger_transactions')).rejects.toMatchObject({
      code: '42501',
    });
    await expect(owner.query('TRUNCATE ledger_entries CASCADE')).rejects.toMatchObject({
      code: '42501',
    });
    await owner.end();
  });

  it('gives the application role no UPDATE or DELETE right on the ledger', async () => {
    const app = await appClient();
    await expect(app.query('UPDATE ledger_entries SET amount_millimes = 1')).rejects.toMatchObject({
      code: '42501',
    });
    await expect(app.query('DELETE FROM ledger_transactions')).rejects.toMatchObject({
      code: '42501',
    });
    await app.end();
  });

  it('corrects by reversal: balances come back, a transaction is reversed once', async () => {
    const company = randomUUID();
    const posted = await fundCompany(company, 7_000n);
    await system((tx) => ledger.reverse(tx, posted.transactionId, 'TEST-REV'));
    expect(await balance(accounts.companyWallet(company, 'RESTAURATION'))).toBe(0n);
    await expect(
      system((tx) => ledger.reverse(tx, posted.transactionId, 'TEST-REV-2')),
    ).rejects.toThrow();
  });
});

describe('balances never negative', () => {
  it('refuses a debit beyond the balance, with the missing amount, and writes nothing', async () => {
    const company = randomUUID();
    const employee = randomUUID();
    await fundCompany(company, 30_000n);
    await allocate(company, employee, 30_000n, inAYear());
    const merchant = randomUUID();
    const error = await pay(employee, merchant, 45_000n).catch((caught: unknown) => caught);
    expect(error).toBeInstanceOf(InsufficientFundsError);
    expect((error as InstanceType<typeof InsufficientFundsError>).missing).toBe(15_000n);
    expect(await balance(accounts.employeeWallet(employee, 'RESTAURATION'))).toBe(30_000n);
    expect(await balance(accounts.merchantWallet(merchant, 'RESTAURATION'))).toBe(0n);
  });

  it('is also enforced by the database (CHECK on wallet balances)', async () => {
    const owner = await ownerClient();
    await expect(
      owner.query(
        `UPDATE account_balances SET balance_millimes = -1
          WHERE account_id = (SELECT id FROM ledger_accounts WHERE code LIKE 'COMPANY_WALLET:%' LIMIT 1)`,
      ),
    ).rejects.toMatchObject({ code: '23514', constraint: 'account_balances_non_negative' });
    await owner.end();
  });
});

describe('idempotency safety net', () => {
  it('refuses a second ledger transaction with the same (tenant, user, key)', async () => {
    const key = randomUUID();
    const tenant = randomUUID();
    const user = randomUUID();
    const post = () =>
      system((tx) =>
        ledger.post(tx, {
          type: 'ORDER_VALIDATED',
          reference: 'IDEM',
          tenantId: tenant,
          userId: user,
          idempotencyKey: key,
          entries: [
            { account: accounts.bankEscrow(), direction: 'D', amount: 100n },
            { account: accounts.companyFees(), direction: 'C', amount: 100n },
          ],
        }),
      );
    await post();
    await expect(post()).rejects.toThrow();
    // Same key, another user: a distinct key (never a replay of someone else's).
    await expect(
      system((tx) =>
        ledger.post(tx, {
          type: 'ORDER_VALIDATED',
          reference: 'IDEM',
          tenantId: tenant,
          userId: randomUUID(),
          idempotencyKey: key,
          entries: [
            { account: accounts.bankEscrow(), direction: 'D', amount: 100n },
            { account: accounts.companyFees(), direction: 'C', amount: 100n },
          ],
        }),
      ),
    ).resolves.toBeDefined();
  });
});

describe('credit lots (FEFO)', () => {
  it('consumes the lot expiring first, across lots, and never an expired lot', async () => {
    const company = randomUUID();
    const employee = randomUUID();
    await fundCompany(company, 100_000n);
    const soon = new Date(Date.now() + 2 * 86_400_000);
    const later = inAYear();
    await allocate(company, employee, 40_000n, later);
    await allocate(company, employee, 25_000n, soon);
    await pay(employee, randomUUID(), 30_000n);
    const lots = await system((tx) =>
      ledger.lots(tx, accounts.employeeWallet(employee, 'RESTAURATION')),
    );
    expect(lots.map((lot) => [lot.expiresAt.getTime() === soon.getTime(), lot.remaining])).toEqual([
      [true, 0n],
      [false, 35_000n],
    ]);

    // An expired lot is never consumed, even if the balance still includes it.
    const other = randomUUID();
    await allocate(company, other, 10_000n, new Date(Date.now() - 1_000));
    await expect(pay(other, randomUUID(), 5_000n)).rejects.toBeInstanceOf(InsufficientFundsError);
  });
});

describe('concurrency', () => {
  it('serves 200 concurrent payments on one wallet without ever going below zero', async () => {
    const company = randomUUID();
    const employee = randomUUID();
    const merchant = randomUUID();
    await fundCompany(company, 60_000n);
    await allocate(company, employee, 60_000n, inAYear());
    const results = await Promise.allSettled(
      Array.from({ length: 200 }, () => pay(employee, merchant, 1_000n)),
    );
    const ok = results.filter((result) => result.status === 'fulfilled').length;
    const refused = results.filter(
      (result) => result.status === 'rejected' && result.reason instanceof InsufficientFundsError,
    ).length;
    expect(ok).toBe(60);
    expect(refused).toBe(140);
    expect(await balance(accounts.employeeWallet(employee, 'RESTAURATION'))).toBe(0n);
    expect(await balance(accounts.merchantWallet(merchant, 'RESTAURATION'))).toBe(60_000n);
  });
});

describe('opening balances (development seed only, decision of 2026-10-14)', () => {
  const opening = (type: string) =>
    `INSERT INTO ledger_transactions (id, type, reference) VALUES ('${randomUUID()}', '${type}', 'SEED-TEST')`;

  it('are refused to the application role, even when it claims to be the seed', async () => {
    await expect(
      system((tx) =>
        ledger.post(tx, {
          type: 'OPENING_BALANCE',
          reference: 'SEED-TEST',
          entries: [
            { account: accounts.bankEscrow(), direction: 'D', amount: 1_000n },
            {
              account: accounts.companyWallet(randomUUID(), 'CADEAUX'),
              direction: 'C',
              amount: 1_000n,
            },
          ],
        }),
      ),
    ).rejects.toThrow(/OPENING_BALANCE/);
    const app = await appClient();
    await app.query('BEGIN');
    await app.query(`SELECT set_config('app.seed', 'on', true)`);
    await expect(app.query(opening('OPENING_BALANCE'))).rejects.toMatchObject({ code: '42501' });
    await app.query('ROLLBACK');
    await app.end();
  });

  it('are refused to the owner outside the seed, and their reversal too', async () => {
    const owner = await ownerClient();
    for (const type of ['OPENING_BALANCE', 'REVERSAL_OPENING_BALANCE']) {
      await owner.query('BEGIN');
      await expect(owner.query(opening(type))).rejects.toMatchObject({ code: '42501' });
      await owner.query('ROLLBACK');
    }
    await owner.end();
  });

  it('are refused in a production database, even to the seed', async () => {
    const owner = await ownerClient();
    await owner.query('BEGIN');
    await owner.query(`SELECT set_config('app.seed', 'on', true)`);
    await owner.query(`SELECT set_config('app.environment', 'production', true)`);
    await expect(owner.query(opening('OPENING_BALANCE'))).rejects.toMatchObject({ code: '42501' });
    await owner.query('ROLLBACK');
    await owner.end();
  });

  it('are accepted from the seed (owner, app.seed on, not production)', async () => {
    const owner = await ownerClient();
    await owner.query('BEGIN');
    await owner.query(`SELECT set_config('app.seed', 'on', true)`);
    await expect(owner.query(opening('OPENING_BALANCE'))).resolves.toBeDefined();
    await owner.query('ROLLBACK');
    await owner.end();
  });
});

describe('reconciliation', () => {
  it('finds the books balanced, then detects an injected gap', async () => {
    const clean = await system((tx) => ledger.reconcile(tx));
    expect(clean.ok).toBe(true);
    expect(clean.totalDebits).toBe(clean.totalCredits);

    const company = randomUUID();
    await fundCompany(company, 5_000n);
    const owner = await ownerClient();
    await owner.query(
      `UPDATE account_balances SET balance_millimes = balance_millimes + 1
        WHERE account_id = (SELECT id FROM ledger_accounts WHERE code = $1)`,
      [accounts.companyWallet(company, 'RESTAURATION').code],
    );
    await owner.end();
    const broken = await system((tx) => ledger.reconcile(tx));
    expect(broken.ok).toBe(false);
    expect(broken.mismatches).toContain(accounts.companyWallet(company, 'RESTAURATION').code);
  });
});
