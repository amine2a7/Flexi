// TEST-FIRST (securite B5-S11): IBAN and phone numbers are stored encrypted (AES-256-GCM); the
// database never holds them in clear, the API shows them to whom may see them.
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv, ownerClient } from './setup.js';
import { listen, WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createCompany, createUser, seedSettings, signedIn } = await import('./fixtures.js');

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

const phone = () => `+2169${String(randomInt(1_000_000, 9_999_999))}`;

/** Raw value of a column, read as the database owner (what a stolen backup would show). */
async function raw(table: string, column: string, id: string): Promise<string> {
  const owner = await ownerClient();
  try {
    const result = await owner.query<{ value: string }>(
      `SELECT ${column}::text AS value FROM ${table} WHERE id = $1`,
      [id],
    );
    return result.rows[0]?.value ?? '';
  } finally {
    await owner.end();
  }
}

describe('personal data encrypted at rest', () => {
  it('the phone of a merchant is stored encrypted and shown to the shop', async () => {
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    const number = phone();
    const created = await admin.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Café ${randomUUID().slice(0, 6)}`,
        category: 'CAFE',
        acceptedCreditTypes: ['RESTAURATION'],
        legalForm: 'PM_MF',
        commissionGrid: [{ rateBps: 200, minMillimes: null, maxMillimes: null }],
        city: 'Tunis',
        phone: number,
        email: `pii-${randomUUID().slice(0, 8)}@exemple.tn`,
      },
    });
    const id = String(created.body.id);
    expect(await raw('merchants', 'phone', id)).not.toContain(number.slice(4));
    const shop = await signedIn(
      base,
      await createUser(db, env, 'MERCHANT', { merchantId: id }, 'Sami B.'),
    );
    expect((await shop.call('GET', '/v1/merchant/profile')).body.phone).toBe(number);
  });

  it('the phone of an employee is stored encrypted and shown to its company', async () => {
    const company = await createCompany(db);
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.'),
    );
    const number = phone();
    const created = await owner.call('POST', '/v1/company/employees', {
      body: {
        employeeNumber: `E-${randomUUID().slice(0, 6)}`,
        firstName: 'Rim',
        lastName: 'Haddad',
        email: `pii-${randomUUID().slice(0, 8)}@exemple.tn`,
        phone: number,
      },
    });
    const id = String(created.body.id);
    expect(await raw('employees', 'phone', id)).not.toContain(number.slice(4));
    const list = await owner.call('GET', '/v1/company/employees');
    const row = (list.body.data as { id: string; phone: string }[]).find((item) => item.id === id);
    expect(row?.phone).toBe(number);
  });

  it('the phone of a contact message is stored encrypted and shown to the platform', async () => {
    const number = phone();
    const visitor = new WebClient(base);
    const sent = await visitor.call('POST', '/v1/public/contact-messages', {
      body: {
        name: 'Rim Haddad',
        email: `pii-${randomUUID().slice(0, 8)}@exemple.tn`,
        phone: number,
        requesterType: 'MERCHANT',
        message: 'Bonjour, je souhaite accepter FlexiPay.',
      },
    });
    expect(sent.status).toBe(202);
    const stored = await db.system((tx) =>
      tx.contactMessage.findFirstOrThrow({ orderBy: { receivedAt: 'desc' } }),
    );
    expect(await raw('contact_messages', 'phone', stored.id)).not.toContain(number.slice(4));
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.'));
    const detail = await admin.call('GET', `/v1/admin/contact-messages/${stored.id}`);
    expect(detail.body.phone).toBe(number);
  });
});
