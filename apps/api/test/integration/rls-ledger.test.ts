// TEST-FIRST (securite B5-S10): the database itself isolates the ledger, the authentication
// secrets, the audit log and the idempotency registry of each tenant (defense in depth: a filter
// forgotten in a query never exposes another tenant). Checked with the application role.
import { randomUUID } from 'node:crypto';
import type pg from 'pg';
import { afterAll, describe, expect, it } from 'vitest';
import { appClient, loadTestEnv } from './setup.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { createCompany, createEmployee, createUser } = await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const ledger = new LedgerService();

afterAll(async () => {
  await db.onModuleDestroy();
});

/** Credits `amount` on `account` from the escrow (a wallet exists in the ledger afterwards). */
async function credit(account: ReturnType<typeof accounts.companyWallet>, amount: bigint) {
  await db.system((tx) =>
    ledger.post(tx, {
      type: 'TEST_RLS',
      reference: `RLS-${randomUUID().slice(0, 8)}`,
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount },
        { account, direction: 'C', amount },
      ],
    }),
  );
}

type Scope = Record<string, string>;

/** Runs `sql` as the application role inside a transaction with the RLS context `scope`. */
async function asApp<T extends pg.QueryResultRow>(
  scope: Scope,
  sql: string,
  values: unknown[] = [],
): Promise<pg.QueryResult<T>> {
  const client = await appClient();
  try {
    await client.query('BEGIN');
    for (const [name, value] of Object.entries(scope)) {
      await client.query(`SELECT set_config($1, $2, true)`, [`app.${name}`, value]);
    }
    return await client.query<T>(sql, values);
  } finally {
    await client.query('ROLLBACK');
    await client.end();
  }
}

const visibleAccounts = async (scope: Scope, codes: string[]) =>
  (
    await asApp<{ code: string }>(
      scope,
      `SELECT a.code FROM ledger_accounts a JOIN account_balances b ON b.account_id = a.id
        WHERE a.code = ANY($1::text[])`,
      [codes],
    )
  ).rows.map((row) => row.code);

describe('ledger isolated by the database (RLS)', () => {
  it('an employee sees its own wallet, never the wallet of another employee', async () => {
    const company = await createCompany(db);
    const mine = await createEmployee(db, company.id);
    const other = await createEmployee(db, company.id);
    const own = accounts.employeeWallet(mine.id, 'RESTAURATION');
    const theirs = accounts.employeeWallet(other.id, 'RESTAURATION');
    await credit(own, 1_000n);
    await credit(theirs, 2_000n);
    const scope = { role: 'EMPLOYEE', employee_id: mine.id, company_id: company.id };
    expect(await visibleAccounts(scope, [own.code, theirs.code])).toEqual([own.code]);
    const entries = await asApp<{ n: string }>(
      scope,
      `SELECT count(*)::text AS n FROM ledger_entries e JOIN ledger_accounts a ON a.id = e.account_id
        WHERE a.code = $1`,
      [theirs.code],
    );
    expect(entries.rows[0]?.n).toBe('0');
  });

  it('a company sees its wallet and those of its employees, never another company', async () => {
    const mine = await createCompany(db);
    const other = await createCompany(db);
    const employee = await createEmployee(db, mine.id);
    const stranger = await createEmployee(db, other.id);
    const codes = [
      accounts.companyWallet(mine.id, 'CADEAUX'),
      accounts.companyWallet(other.id, 'CADEAUX'),
      accounts.employeeWallet(employee.id, 'CADEAUX'),
      accounts.employeeWallet(stranger.id, 'CADEAUX'),
    ];
    for (const account of codes) await credit(account, 500n);
    const seen = await visibleAccounts(
      { role: 'COMPANY', company_id: mine.id },
      codes.map((account) => account.code),
    );
    expect(seen.sort()).toEqual([codes[0]?.code, codes[2]?.code].sort());
  });

  it('a merchant never sees the wallet of another merchant', async () => {
    const mine = randomUUID();
    const other = randomUUID();
    await credit(accounts.merchantWallet(mine, 'RESTAURATION'), 700n);
    await credit(accounts.merchantWallet(other, 'RESTAURATION'), 900n);
    const seen = await visibleAccounts({ role: 'MERCHANT', merchant_id: mine }, [
      accounts.merchantWallet(mine, 'RESTAURATION').code,
      accounts.merchantWallet(other, 'RESTAURATION').code,
    ]);
    expect(seen).toEqual([accounts.merchantWallet(mine, 'RESTAURATION').code]);
  });
});

describe('secrets, audit and registry isolated by the database (RLS)', () => {
  it('a tenant reads no session, recovery code, audit entry nor idempotency key of others', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const admin = await createUser(db, env, 'ADMIN', {}, 'Amine K.');
    // One row in each table (another user's), so that "nothing visible" proves something.
    await db.system(async (tx) => {
      const userId = admin.id;
      await tx.session.create({
        data: {
          familyId: randomUUID(),
          userId,
          step: 'NONE',
          accessTokenHash: randomUUID(),
          refreshTokenHash: randomUUID(),
          absoluteExpiresAt: new Date(Date.now() + 3_600_000),
        },
      });
      await tx.recoveryCode.create({ data: { userId, codeHash: randomUUID() } });
      await tx.mfaChallenge.create({
        data: { userId, expiresAt: new Date(Date.now() + 300_000) },
      });
      await tx.passwordResetToken.create({
        data: { userId, tokenHash: randomUUID(), expiresAt: new Date(Date.now() + 300_000) },
      });
      await tx.loginFailure.create({ data: { userId, ip: '203.0.113.7', count: 1 } });
      await tx.auditLog.create({
        data: { actorName: 'Amine K.', action: 'test.rls', target: 'x' },
      });
      await tx.idempotencyKey.create({
        data: {
          scope: 'test',
          userId,
          key: randomUUID(),
          fingerprint: '0'.repeat(64),
          state: 'IN_PROGRESS',
          fenceToken: randomUUID(),
          leaseUntil: new Date(Date.now() + 60_000),
        },
      });
    });
    const scope = { role: 'EMPLOYEE', employee_id: employee.id, company_id: company.id };
    for (const table of [
      'sessions',
      'recovery_codes',
      'mfa_challenges',
      'password_reset_tokens',
      'login_failures',
      'audit_log',
      'idempotency_keys',
    ]) {
      const rows = await asApp<{ n: string }>(scope, `SELECT count(*)::text AS n FROM ${table}`);
      expect({ table, n: rows.rows[0]?.n }).toEqual({ table, n: '0' });
    }
  });

  it('a beneficiary never changes the row of its company', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const updated = await asApp(
      { role: 'EMPLOYEE', employee_id: employee.id, company_id: company.id },
      `UPDATE companies SET name = 'Piratée' WHERE id = $1`,
      [company.id],
    );
    expect(updated.rowCount).toBe(0);
  });
});
