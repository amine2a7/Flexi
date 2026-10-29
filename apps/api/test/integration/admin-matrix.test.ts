// TEST-FIRST (decision C of 2026-10-23, securite): every administrator route, called over HTTP by
// every administrator sub-role, answers 403 exactly when the matrix denies it. A new admin route
// without an entry here fails, so no route escapes the matrix.
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { routes } from '../routes.js';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createUser, seedSettings, signedIn } = await import('./fixtures.js');

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

type Sub = 'SUPER_ADMIN' | 'COMPLIANCE' | 'FINANCE' | 'SUPPORT';
const ALL: Sub[] = ['SUPER_ADMIN', 'COMPLIANCE', 'FINANCE', 'SUPPORT'];
const BACK_OFFICE: Sub[] = ['SUPER_ADMIN', 'COMPLIANCE', 'FINANCE'];
const MONEY: Sub[] = ['SUPER_ADMIN', 'FINANCE'];
const KYC: Sub[] = ['SUPER_ADMIN', 'COMPLIANCE'];
const SUPER: Sub[] = ['SUPER_ADMIN'];
const MESSAGES: Sub[] = ['SUPER_ADMIN', 'SUPPORT'];

/** Who may call each admin route (decision C). */
const EXPECTED: Record<string, Sub[]> = {
  'AdminController.dashboard': BACK_OFFICE,
  'AdminController.merchants': ALL,
  'AdminController.merchant': ALL,
  'AdminController.createMerchant': SUPER,
  'AdminController.setTypes': SUPER,
  'AdminController.companies': ALL,
  'AdminController.createCompany': SUPER,
  'AdminController.profiles': BACK_OFFICE,
  'AdminController.changeRequest': MONEY,
  'AdminController.approvals': BACK_OFFICE,
  'AdminController.approve': MONEY,
  'AdminController.reject': MONEY,
  'AdminController.transactions': ALL,
  'AdminController.audit': BACK_OFFICE,
  'AdminController.settings': MONEY,
  'AdminController.changeSettings': SUPER,
  'AdminController.kycFiles': BACK_OFFICE,
  'AdminController.kycFile': BACK_OFFICE,
  'AdminController.kycDocument': KYC,
  'AdminController.approveKyc': KYC,
  'AdminController.rejectKyc': KYC,
  'AdminController.messages': MESSAGES,
  'AdminController.message': MESSAGES,
  'AdminController.handle': MESSAGES,
  'AdminOrdersController.list': BACK_OFFICE,
  'AdminOrdersController.get': BACK_OFFICE,
  'AdminOrdersController.confirm': MONEY,
  'AdminOrdersController.refuse': MONEY,
  'AdminOrdersController.validate': MONEY,
  'AdminOrdersController.rejectProof': MONEY,
  'AdminOrdersController.proof': BACK_OFFICE,
  'AdminPayoutsController.list': BACK_OFFICE,
  'AdminPayoutsController.get': BACK_OFFICE,
  'AdminPayoutsController.approve': MONEY,
  'AdminPayoutsController.reject': MONEY,
  'AdminPayoutsController.batches': BACK_OFFICE,
  'AdminPayoutsController.batch': BACK_OFFICE,
};

const adminRoutes = (await routes()).filter(
  (route) =>
    (route.path.startsWith('/v1/admin') || route.roles.includes('ADMIN')) && !route.isPublic,
);

describe('administrator matrix over HTTP (decision C)', () => {
  it('every admin route has an expected entry, and every entry a route', () => {
    expect(adminRoutes.map((route) => route.name).sort()).toEqual(Object.keys(EXPECTED).sort());
  });

  it('answers 403 exactly where the matrix denies, for each sub-role', async () => {
    const table: string[] = [];
    for (const subRole of ALL) {
      const client = await signedIn(
        base,
        await createUser(db, env, 'ADMIN', {}, `Matrice ${subRole}`, subRole),
      );
      for (const route of adminRoutes) {
        const path = route.path.replace(/:[A-Za-z]+/g, randomUUID());
        const result = await client.call(route.method, path, {
          ...(route.method === 'GET' ? {} : { body: {} }),
          headers: { 'Idempotency-Key': randomUUID() },
        });
        const denied = result.status === 403 && result.body.code === 'FORBIDDEN';
        const expected = EXPECTED[route.name]?.includes(subRole) === true ? 'allowed' : 'denied';
        const obtained = denied ? 'denied' : 'allowed';
        if (expected !== obtained) {
          table.push(
            `${route.method} ${route.path} | ${subRole} | ${expected} | ${obtained} (${String(result.status)})`,
          );
        }
      }
    }
    expect(table).toEqual([]);
  }, 120_000);
});
