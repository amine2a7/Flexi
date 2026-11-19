// W-FIN: the last web pages on the API. Only a frozen quote of the company makes an order (the
// former `{ lines }` body is refused, a quote of another company is unknown); the general ledger
// (Finance, Super-admin), the invoices (FlexiPay and company), the full client record (audit,
// tills, commission invoices), users, cashiers and tills: each with an allowed role and a refused
// one.
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen, type WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const {
  createCompany,
  createEmployee,
  createUser,
  oneLineGrid,
  quoted,
  sealed,
  seedSettings,
  signedIn,
} = await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';
const key = () => ({ 'Idempotency-Key': randomUUID() });
const LINES = [{ creditType: 'RESTAURATION', amountMillimes: 500_000 }];

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

const admin = async (subRole: 'SUPER_ADMIN' | 'FINANCE' | 'COMPLIANCE' | 'SUPPORT') =>
  signedIn(base, await createUser(db, env, 'ADMIN', {}, `Admin ${subRole}`, subRole));

async function companyOwner() {
  const company = await createCompany(db);
  await createEmployee(db, company.id);
  const owner = await signedIn(
    base,
    await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.'),
  );
  return { company, owner };
}

async function shop() {
  const merchant = await db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Géant ${randomUUID().slice(0, 5)}`,
        category: 'GROCERY',
        city: 'Sousse',
        phone: sealed('+21673000001'),
        email: 'shop@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: ['RESTAURATION'],
        paymentCode: String(randomInt(100_000, 999_999)),
        iban: sealed('TN5910006035183598470014'),
        commissionGrids: oneLineGrid(200),
      },
    }),
  );
  const owner = await signedIn(
    base,
    await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Patron'),
  );
  const cashierUser = await createUser(
    db,
    env,
    'MERCHANT',
    { merchantId: merchant.id },
    'Sami C.',
    'CASHIER',
  );
  return { merchant, owner, cashierUser, cashier: await signedIn(base, cashierUser) };
}

/** An order of the company, confirmed by FlexiPay: its invoice is issued. */
async function invoicedOrder(owner: WebClient) {
  const created = await owner.call('POST', '/v1/company/orders', {
    body: await quoted(owner, LINES),
    headers: key(),
  });
  expect(created.status).toBe(201);
  const confirmed = await (
    await admin('SUPER_ADMIN')
  ).call('POST', `/v1/admin/credit-orders/${String(created.body.id)}/confirm`);
  expect(confirmed.status).toBe(200);
  const invoice = await db.system((tx) =>
    tx.invoice.findUniqueOrThrow({ where: { orderId: String(created.body.id) } }),
  );
  return { orderId: String(created.body.id), invoice };
}

describe('credit orders: the frozen quote only', () => {
  it('the former { lines } body is refused (400) and creates nothing', async () => {
    const { company, owner } = await companyOwner();
    const refused = await owner.call('POST', '/v1/company/orders', {
      body: { lines: LINES },
      headers: key(),
    });
    expect(refused.status).toBe(400);
    expect(refused.body.code).toBe('VALIDATION_FAILED');
    expect(
      await db.system((tx) => tx.creditOrder.count({ where: { companyId: company.id } })),
    ).toBe(0);
  });

  it('a quote is usable only by the company that made it', async () => {
    const first = await companyOwner();
    const other = await companyOwner();
    const quote = await quoted(first.owner, LINES);
    const stolen = await other.owner.call('POST', '/v1/company/orders', {
      body: quote,
      headers: key(),
    });
    expect(stolen.status).toBe(404);
    expect(
      await db.system((tx) => tx.creditOrder.count({ where: { companyId: other.company.id } })),
    ).toBe(0);
    // Still intact for its own company.
    const own = await first.owner.call('POST', '/v1/company/orders', {
      body: quote,
      headers: key(),
    });
    expect(own.status).toBe(201);
    expect(own.body.companyId).toBe(first.company.id);
  });
});

describe('general ledger (Finance and Super-admin)', () => {
  it('Finance lists the entries of one client, filtered by type, and exports them as CSV', async () => {
    const { company, owner } = await companyOwner();
    await invoicedOrder(owner);
    const finance = await admin('FINANCE');
    const types = await finance.call('GET', '/v1/admin/ledger-entries/types');
    expect(types.status).toBe(200);
    expect(Array.isArray(types.body.data)).toBe(true);

    const all = await finance.call(
      'GET',
      `/v1/admin/ledger-entries?clientType=COMPANY&clientId=${company.id}&withCount=true`,
    );
    expect(all.status).toBe(200);
    const rows = all.body.data as { ownerName: string | null; direction: string }[];
    for (const row of rows) expect(row.ownerName ?? '').toContain(company.name);

    const csv = await fetch(
      `${base}/v1/admin/ledger-entries/export?clientType=COMPANY&clientId=${company.id}`,
      { headers: { Cookie: finance.cookieHeader('/v1/admin'), Origin: 'http://localhost:3001' } },
    );
    expect(csv.status).toBe(200);
    expect(csv.headers.get('content-type')).toContain('text/csv');
    const text = await csv.text();
    expect(text).toContain('"date";"reference";"type";"compte"');
    expect(text.split('\r\n').length).toBeGreaterThanOrEqual(2);

    const unknown = await finance.call(
      'GET',
      `/v1/admin/ledger-entries?clientType=MERCHANT&clientId=${randomUUID()}`,
    );
    expect(unknown.status).toBe(404);
    const half = await finance.call('GET', `/v1/admin/ledger-entries?clientId=${randomUUID()}`);
    expect(half.status).toBe(400);
  });

  it('the super-admin reads it; Opérations, Support and a company never', async () => {
    expect(
      (await (await admin('SUPER_ADMIN')).call('GET', '/v1/admin/ledger-entries')).status,
    ).toBe(200);
    for (const subRole of ['COMPLIANCE', 'SUPPORT'] as const) {
      const refused = await (await admin(subRole)).call('GET', '/v1/admin/ledger-entries');
      expect({ subRole, status: refused.status }).toEqual({ subRole, status: 403 });
    }
    const { owner } = await companyOwner();
    expect((await owner.call('GET', '/v1/admin/ledger-entries')).status).toBe(403);
  });
});

describe('invoices (FlexiPay and company)', () => {
  it('FlexiPay lists, opens and downloads every invoice; Support and a company never', async () => {
    const { company, owner } = await companyOwner();
    const { invoice } = await invoicedOrder(owner);
    const finance = await admin('FINANCE');
    const list = await finance.call('GET', `/v1/admin/invoices?companyId=${company.id}`);
    expect(list.status).toBe(200);
    expect(list.body.data).toEqual([
      expect.objectContaining({ id: invoice.id, companyName: company.name, status: 'UNPAID' }),
    ]);
    const detail = await finance.call('GET', `/v1/admin/invoices/${invoice.id}`);
    expect(detail.status).toBe(200);
    expect(detail.body).toMatchObject({
      number: invoice.number,
      lines: [{ creditType: 'RESTAURATION', amountMillimes: 500_000 }],
      amountMillimes: 500_000,
    });
    const pdf = await finance.call('GET', `/v1/admin/invoices/${invoice.id}/pdf`);
    expect(pdf.status).toBe(200);
    expect(pdf.headers.get('content-type')).toBe('application/pdf');

    expect((await (await admin('SUPPORT')).call('GET', '/v1/admin/invoices')).status).toBe(403);
    expect((await owner.call('GET', '/v1/admin/invoices')).status).toBe(403);
  });

  it('a company opens its own invoice, never the invoice of another one', async () => {
    const { owner } = await companyOwner();
    const { invoice } = await invoicedOrder(owner);
    const own = await owner.call('GET', `/v1/company/invoices/${invoice.id}`);
    expect(own.status).toBe(200);
    expect(own.body).toMatchObject({
      id: invoice.id,
      totalMillimes: Number(invoice.totalMillimes),
    });
    const other = await companyOwner();
    expect((await other.owner.call('GET', `/v1/company/invoices/${invoice.id}`)).status).toBe(404);
    const hr = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: other.company.id }, 'RH', 'MANAGER'),
    );
    expect((await hr.call('GET', `/v1/company/invoices/${invoice.id}`)).status).toBe(403);
  });
});

describe('full client record', () => {
  it('Audit tab: the entries of the client only; Support has no audit', async () => {
    const { company, owner } = await companyOwner();
    await invoicedOrder(owner);
    const other = await companyOwner();
    await invoicedOrder(other.owner);
    const finance = await admin('FINANCE');
    const audit = await finance.call(
      'GET',
      `/v1/admin/audit-logs?clientType=COMPANY&clientId=${company.id}&limit=100`,
    );
    expect(audit.status).toBe(200);
    const entries = audit.body.data as { action: string; target: string }[];
    expect(entries.some((entry) => entry.action === 'orders.create')).toBe(true);
    expect(entries.some((entry) => entry.target.includes(other.company.name))).toBe(false);
    expect(
      (
        await (
          await admin('SUPPORT')
        ).call('GET', `/v1/admin/audit-logs?clientType=COMPANY&clientId=${company.id}`)
      ).status,
    ).toBe(403);
  });

  it('merchant record: tills and commission invoices tabs', async () => {
    const { merchant, owner } = await shop();
    const till = await owner.call('POST', '/v1/merchant/registers', { body: { name: 'Caisse 1' } });
    expect(till.status).toBe(201);
    const support = await admin('SUPPORT');
    const overview = await support.call('GET', `/v1/admin/merchants/${merchant.id}/overview`);
    expect(overview.status).toBe(200);
    expect(overview.body.registers).toEqual([
      expect.objectContaining({ id: till.body.id, name: 'Caisse 1', status: 'ACTIVE' }),
    ]);
    expect(overview.body.invoices).toEqual([]);
    const { owner: companyAccount } = await companyOwner();
    expect(
      (await companyAccount.call('GET', `/v1/admin/merchants/${merchant.id}/overview`)).status,
    ).toBe(403);
  });
});

describe('users, cashiers and tills (owners only)', () => {
  it('Utilisateurs: the company owner lists its team, its HR never', async () => {
    const { company, owner } = await companyOwner();
    expect((await owner.call('GET', '/v1/team/users')).status).toBe(200);
    const hr = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'RH', 'MANAGER'),
    );
    expect((await hr.call('GET', '/v1/team/users')).status).toBe(403);
  });

  it('Caissiers: the shop owner sees the till of each cashier and assigns it; a cashier never', async () => {
    const { owner, cashier, cashierUser } = await shop();
    const till = await owner.call('POST', '/v1/merchant/registers', { body: { name: 'Drive' } });
    const assigned = await owner.call('PUT', `/v1/merchant/cashiers/${cashierUser.id}/register`, {
      body: { registerId: till.body.id },
    });
    expect(assigned.status).toBe(204);
    const team = await owner.call('GET', '/v1/team/users');
    expect(team.status).toBe(200);
    expect(team.body.data).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          id: cashierUser.id,
          subRole: 'CASHIER',
          registerId: till.body.id,
        }),
      ]),
    );
    expect((await cashier.call('GET', '/v1/team/users')).status).toBe(403);
    expect(
      (
        await cashier.call('PUT', `/v1/merchant/cashiers/${cashierUser.id}/register`, {
          body: { registerId: null },
        })
      ).status,
    ).toBe(403);
  });

  it('Caisses: the owner adds, renames, switches off a till and reads its sticker; a cashier never', async () => {
    const { owner, cashier } = await shop();
    const created = await owner.call('POST', '/v1/merchant/registers', {
      body: { name: 'Caisse 2' },
    });
    expect(created.status).toBe(201);
    const id = String(created.body.id);
    const renamed = await owner.call('PATCH', `/v1/merchant/registers/${id}`, {
      body: { name: 'Caisse Drive' },
    });
    expect(renamed.body.name).toBe('Caisse Drive');
    const sticker = await owner.call('GET', `/v1/merchant/registers/${id}/sticker`);
    expect(String(sticker.body.url)).toMatch(/^https:\/\/pay\.flexipay\.tn\/c\//);
    const off = await owner.call('PATCH', `/v1/merchant/registers/${id}`, {
      body: { status: 'DISABLED' },
    });
    expect(off.body.status).toBe('DISABLED');
    expect(
      (await cashier.call('POST', '/v1/merchant/registers', { body: { name: 'Pirate' } })).status,
    ).toBe(403);
    expect((await cashier.call('GET', `/v1/merchant/registers/${id}/sticker`)).status).toBe(403);
  });
});
