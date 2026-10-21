// TEST-FIRST (securite B5-S02, step 3 of 2026-10-21): the sub-role is checked by the server on
// every route. A user with the wrong sub-role gets 403, whatever the web shows or the request says.
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen, type WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createCompany, createEmployee, createUser, seedSettings, signedIn } =
  await import('./fixtures.js');

type SubRole =
  | 'SUPER_ADMIN'
  | 'FINANCE'
  | 'SUPPORT'
  | 'COMPLIANCE'
  | 'OWNER'
  | 'MANAGER'
  | 'ACCOUNTANT'
  | 'READ_ONLY'
  | 'CASHIER';

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';
const ID = '0193a1c4-0000-7000-8000-000000000001';

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

const key = () => ({ 'Idempotency-Key': randomUUID() });

async function companyUser(subRole: SubRole, companyId?: string) {
  const id = companyId ?? (await createCompany(db)).id;
  return signedIn(
    base,
    await createUser(db, env, 'COMPANY', { companyId: id }, 'Test C.', subRole),
  );
}

async function merchantUser(subRole: SubRole, merchantId?: string) {
  if (merchantId !== undefined) {
    return signedIn(
      base,
      await createUser(db, env, 'MERCHANT', { merchantId }, 'Test M.', subRole),
    );
  }
  const merchant = await db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Café ${randomUUID().slice(0, 5)}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: '+21671000001',
        email: 'cafe@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: ['RESTAURATION'],
        paymentCode: String(randomInt(100_000, 999_999)),
      },
    }),
  );
  return signedIn(
    base,
    await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Test M.', subRole),
  );
}

const adminUser = async (subRole: SubRole) =>
  signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Test A.', subRole));

type Call = [method: string, path: string, body?: unknown];

/** Each call is refused with 403 FORBIDDEN (before any other check of the request). */
async function refused(client: WebClient, calls: Call[]): Promise<void> {
  for (const [method, path, body] of calls) {
    const result = await client.call(method, path, {
      ...(body === undefined ? {} : { body }),
      headers: key(),
    });
    expect({ method, path, status: result.status, code: result.body.code }).toEqual({
      method,
      path,
      status: 403,
      code: 'FORBIDDEN',
    });
  }
}

/** Each call goes past the permission check (any answer but 403 FORBIDDEN). */
async function allowed(client: WebClient, calls: Call[]): Promise<void> {
  for (const [method, path, body] of calls) {
    const result = await client.call(method, path, {
      ...(body === undefined ? {} : { body }),
      headers: key(),
    });
    expect({ method, path, code: result.body.code }).not.toEqual({
      method,
      path,
      code: 'FORBIDDEN',
    });
  }
}

const order = { lines: [{ creditType: 'RESTAURATION', amountMillimes: 1_000_000 }] };

describe('company sub-roles (Administrateur OWNER, RH MANAGER, Comptable ACCOUNTANT)', () => {
  it('HR manages employees and allocations, never orders, transfers nor invoices', async () => {
    const hr = await companyUser('MANAGER');
    await refused(hr, [
      ['POST', '/v1/company/order-quotes', order],
      ['POST', '/v1/company/orders', order],
      ['GET', '/v1/company/orders'],
      ['POST', `/v1/company/orders/${ID}/cancel`],
      ['GET', '/v1/company/invoices'],
      ['GET', '/v1/company/funding-account'],
    ]);
    await allowed(hr, [
      ['GET', '/v1/company/dashboard'],
      ['GET', '/v1/company/employees'],
      ['POST', '/v1/company/allocation-imports/previews', { csv: '' }],
    ]);
  });

  it('the accountant handles orders, transfers and invoices, never employees nor allocations', async () => {
    const accountant = await companyUser('ACCOUNTANT');
    await refused(accountant, [
      ['GET', '/v1/company/employees'],
      [
        'POST',
        '/v1/company/employees',
        {
          employeeNumber: 'X1',
          firstName: 'A',
          lastName: 'B',
          email: 'a@b.tn',
          phone: '+21620000000',
        },
      ],
      ['POST', '/v1/company/employees/import-previews', { csv: '' }],
      ['POST', '/v1/company/allocations', { allocations: [] }],
      ['POST', '/v1/company/allocation-imports/previews', { csv: '' }],
    ]);
    await allowed(accountant, [
      ['GET', '/v1/company/invoices'],
      ['GET', '/v1/company/orders'],
      ['GET', '/v1/company/funding-account'],
      ['POST', '/v1/company/order-quotes', order],
    ]);
  });

  it('read-only reads, never writes', async () => {
    const reader = await companyUser('READ_ONLY');
    await refused(reader, [
      ['POST', '/v1/company/orders', order],
      ['POST', '/v1/company/allocations', { allocations: [] }],
    ]);
    await allowed(reader, [['GET', '/v1/company/dashboard']]);
  });

  it('a user of company A never reads an order of company B', async () => {
    const b = await companyUser('OWNER');
    const created = await b.call('POST', '/v1/company/orders', { body: order, headers: key() });
    expect(created.status).toBe(201);
    const a = await companyUser('OWNER');
    const read = await a.call('GET', `/v1/company/orders/${String(created.body.id)}`);
    expect(read.status).toBe(404);
  });
});

describe('merchant sub-roles (Gérant OWNER, Caissier CASHIER)', () => {
  it('the cashier collects and sees the day, never payouts, receivables nor settlements', async () => {
    const cashier = await merchantUser('CASHIER');
    await refused(cashier, [
      ['GET', '/v1/merchant/dashboard'],
      ['GET', '/v1/merchant/receivables'],
      ['POST', '/v1/merchant/payout-quotes', { creditType: 'RESTAURATION', grossMillimes: 20_000 }],
      ['POST', '/v1/merchant/payouts', { quoteId: ID }],
      ['GET', '/v1/merchant/payouts'],
      ['GET', '/v1/merchant/settlements'],
      ['GET', '/v1/merchant/documents'],
    ]);
    await allowed(cashier, [
      [
        'POST',
        '/v1/merchant/payments',
        { customerCode: '12345678', creditType: 'RESTAURATION', amountMillimes: 1_000 },
      ],
      ['GET', '/v1/merchant/payments'],
      ['GET', '/v1/merchant/profile'],
    ]);
  });

  it("the cashier's history only holds the payments of the day", async () => {
    const owner = await merchantUser('OWNER');
    const merchantId = ((await owner.call('GET', '/v1/me')).body.tenant as { id: string }).id;
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const old = await db.system((tx) =>
      tx.payment.create({
        data: {
          reference: `PAY-OLD-${randomUUID().slice(0, 6)}`,
          merchantId,
          employeeId: employee.id,
          companyId: company.id,
          creditType: 'RESTAURATION',
          amountMillimes: 5_000n,
          status: 'REFUSED',
          channel: 'CUSTOMER_CODE',
          createdAt: new Date(Date.now() - 3 * 86_400_000),
        },
      }),
    );
    const cashier = await merchantUser('CASHIER', merchantId);
    const ids = (body: Record<string, unknown>) => (body.data as { id: string }[]).map((p) => p.id);
    expect(ids((await owner.call('GET', '/v1/merchant/payments')).body)).toContain(old.id);
    expect(ids((await cashier.call('GET', '/v1/merchant/payments')).body)).not.toContain(old.id);
    expect((await cashier.call('GET', `/v1/merchant/payments/${old.id}`)).status).toBe(404);
    // Asking for an earlier period does not widen it.
    const since = encodeURIComponent(new Date(Date.now() - 10 * 86_400_000).toISOString());
    const asked = await cashier.call('GET', `/v1/merchant/payments?createdFrom=${since}`);
    expect(asked.status).toBe(200);
    expect(ids(asked.body)).not.toContain(old.id);
  });

  it('a sub-role missing from the matrix (or none) gets nothing', async () => {
    const shopWithoutSubRole = await merchantUser(null as unknown as SubRole);
    await refused(shopWithoutSubRole, [
      ['GET', '/v1/merchant/profile'],
      ['GET', '/v1/merchant/payments'],
    ]);
    const companyCashier = await companyUser('CASHIER');
    await refused(companyCashier, [['GET', '/v1/company/dashboard']]);
  });
});

describe('admin sub-roles (Super-admin, Opérations COMPLIANCE, Finance, Support)', () => {
  it('support reads and handles messages, never decides', async () => {
    const support = await adminUser('SUPPORT');
    await refused(support, [
      ['POST', `/v1/admin/credit-orders/${ID}/confirm`],
      ['POST', `/v1/admin/credit-orders/${ID}/validate`],
      ['POST', `/v1/admin/payout-requests/${ID}/approve`],
      ['POST', `/v1/admin/payout-requests/${ID}/reject`, { reason: 'Non' }],
      ['POST', `/v1/admin/kyc-files/${ID}/approve`],
      ['POST', `/v1/admin/approvals/${ID}/approve`],
      [
        'POST',
        `/v1/admin/commission-profiles/${ID}/change-requests`,
        { newRateBps: 210, reason: 'R' },
      ],
      ['GET', `/v1/admin/kyc-files/${ID}/documents/${ID}`],
      [
        'POST',
        '/v1/admin/companies',
        { name: 'X', city: 'Tunis', phone: '+21671000000', email: 'x@y.tn' },
      ],
    ]);
    await allowed(support, [
      ['GET', '/v1/admin/dashboard'],
      ['GET', '/v1/admin/credit-orders'],
      ['GET', '/v1/admin/contact-messages'],
      ['POST', `/v1/admin/contact-messages/${ID}/handle`, { note: 'Rappelé' }],
    ]);
  });

  it('finance validates payments and payouts, never settings, KYC nor order confirmation', async () => {
    const finance = await adminUser('FINANCE');
    await refused(finance, [
      ['PUT', '/v1/admin/settings', {}],
      [
        'POST',
        `/v1/admin/commission-profiles/${ID}/change-requests`,
        { newRateBps: 210, reason: 'R' },
      ],
      ['POST', `/v1/admin/kyc-files/${ID}/approve`],
      ['POST', `/v1/admin/credit-orders/${ID}/confirm`],
    ]);
    await allowed(finance, [
      ['POST', `/v1/admin/credit-orders/${ID}/validate`],
      ['POST', `/v1/admin/payout-requests/${ID}/approve`],
      ['POST', `/v1/admin/approvals/${ID}/approve`],
    ]);
  });

  it('operations handle KYC and order confirmation, never payments nor settings', async () => {
    const operations = await adminUser('COMPLIANCE');
    await refused(operations, [
      [
        'POST',
        '/v1/admin/companies',
        { name: 'X', city: 'Tunis', phone: '+21671000000', email: 'x@y.tn' },
      ],
      ['POST', `/v1/admin/credit-orders/${ID}/validate`],
      ['POST', `/v1/admin/payout-requests/${ID}/approve`],
      ['PUT', '/v1/admin/settings', {}],
    ]);
    await allowed(operations, [
      ['POST', `/v1/admin/kyc-files/${ID}/approve`],
      ['POST', `/v1/admin/credit-orders/${ID}/confirm`],
    ]);
  });
});

describe('routes of the other spaces', () => {
  it('a company HR user never reaches an admin route (changing a commission rate)', async () => {
    const hr = await companyUser('MANAGER');
    await refused(hr, [
      [
        'POST',
        `/v1/admin/commission-profiles/${ID}/change-requests`,
        { newRateBps: 210, reason: 'R' },
      ],
    ]);
  });
});
