// TEST-FIRST: one SQL transaction = one connection, used by one query at a time. pg warns (and will
// fail in pg 9) when a query starts while another one runs on the same client (Promise.all on tx).
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createCompany, createEmployee, createUser, seedSettings, signedIn } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';
const warnings: string[] = [];
const onWarning = (warning: Error) => {
  warnings.push(warning.message);
};

beforeAll(async () => {
  process.on('warning', onWarning);
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  process.off('warning', onWarning);
  await app.close();
  await db.onModuleDestroy();
});

describe('one query at a time on a transaction', () => {
  it('serves the dashboards and the wallet without concurrent queries on one client', async () => {
    const company = await createCompany(db, `Société ${randomUUID().slice(0, 6)}`);
    const employee = await createEmployee(db, company.id);
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.'),
    );
    const beneficiary = await signedIn(
      base,
      await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.'),
    );
    expect((await admin.call('GET', '/v1/admin/dashboard')).status).toBe(200);
    // Lists with several relations (includes): one query each (relationJoins, no parallel reads).
    expect((await owner.call('GET', '/v1/company/dashboard')).status).toBe(200);
    expect((await owner.call('GET', '/v1/company/orders')).status).toBe(200);
    expect((await admin.call('GET', '/v1/admin/credit-orders')).status).toBe(200);
    expect((await admin.call('GET', '/v1/admin/payout-requests')).status).toBe(200);
    expect((await beneficiary.call('GET', '/v1/employee/wallet')).status).toBe(200);
    // Warnings are emitted on the next tick.
    await new Promise((resolve) => setImmediate(resolve));
    expect(warnings.filter((message) => message.includes('already executing a query'))).toEqual([]);
  });

  it('reads and writes timestamps in UTC, whatever the time zone of the server', async () => {
    const company = await createCompany(db, `Société ${randomUUID().slice(0, 6)}`);
    const employee = await createEmployee(db, company.id);
    const written = new Date();
    const [row] = await db.system(async (tx) => {
      await tx.employee.update({ where: { id: employee.id }, data: { pinLockedUntil: written } });
      return tx.$queryRaw<{ zone: string; gap: number }[]>`
        SELECT current_setting('TimeZone') AS zone,
               extract(epoch FROM (now() - pin_locked_until))::float8 AS gap
          FROM employees WHERE id = ${employee.id}::uuid`;
    });
    expect(row?.zone).toBe('UTC');
    // The same instant on both sides (JS Date written by Prisma, now() of PostgreSQL).
    expect(Math.abs(row?.gap ?? 999)).toBeLessThan(5);
    const read = await db.system((tx) =>
      tx.employee.findUniqueOrThrow({ where: { id: employee.id } }),
    );
    expect(read.pinLockedUntil?.toISOString()).toBe(written.toISOString());
  });
});
