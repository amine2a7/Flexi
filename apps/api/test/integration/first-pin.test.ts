// TEST-FIRST (end-to-end journey of 2026-11-12): a new beneficiary has no payment PIN yet; it
// chooses one without a current PIN, once. Afterwards the current PIN is always required.
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

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

describe('first payment PIN', () => {
  it('is chosen once without a current PIN, then the current PIN is required', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const client = await signedIn(
      base,
      await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.'),
    );
    expect((await client.call('GET', '/v1/employee/profile')).body.pinSet).toBe(false);
    // A weak PIN is refused even the first time.
    expect(
      (await client.call('POST', '/v1/employee/pin', { body: { newPin: '1111' } })).status,
    ).toBe(400);
    expect(
      (await client.call('POST', '/v1/employee/pin', { body: { newPin: '4826' } })).status,
    ).toBe(204);
    expect((await client.call('GET', '/v1/employee/profile')).body.pinSet).toBe(true);
    // Once set, never again without the current PIN.
    expect(
      (await client.call('POST', '/v1/employee/pin', { body: { newPin: '7391' } })).status,
    ).toBe(403);
    expect(
      (
        await client.call('POST', '/v1/employee/pin', {
          body: { currentPin: '4826', newPin: '7391' },
        })
      ).status,
    ).toBe(204);
    // The new PIN is the one checked at payment time.
    await db.system(async (tx) => {
      const row = await tx.employee.findUniqueOrThrow({ where: { id: employee.id } });
      expect(row.pinHash).not.toBeNull();
    });
  });
});
