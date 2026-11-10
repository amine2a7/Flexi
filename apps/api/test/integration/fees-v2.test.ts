// Fees of processus v2 (Règles de frais) on a real order, over HTTP: example 1 of the spec.
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createUser, ledgerLines, sealed, seedSettings, signedIn } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';

// Smallest valid PNG (8-byte signature + IHDR + IEND).
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  'base64',
);

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

function declaration(amount: string, file: Buffer = PNG, name = 'avis.png'): FormData {
  const form = new FormData();
  form.set('transferReference', 'BIAT-778899');
  form.set('transferDate', new Date().toISOString().slice(0, 10));
  form.set('amountMillimes', amount);
  form.set('proof', new Blob([file]), name);
  return form;
}

const key = () => ({ 'Idempotency-Key': randomUUID() });

async function companyWithGrid(tiers: { rateBps: number; min?: bigint; max?: bigint }[]) {
  return db.system((tx) =>
    tx.company.create({
      data: {
        name: `Grille ${randomUUID().slice(0, 8)}`,
        city: 'Tunis',
        phone: sealed('+21671000000'),
        email: 'grille@societe.test',
        status: 'APPROVED',
        commissionGrids: {
          create: {
            tiers: {
              create: tiers.map((tier, position) => ({
                position,
                rateBps: tier.rateBps,
                minMillimes: tier.min ?? null,
                maxMillimes: tier.max ?? null,
              })),
            },
          },
        },
      },
    }),
  );
}

describe('fees of a credit order (processus v2)', () => {
  // TEST-FIRST (processus v2, Règles de frais, example 1).
  it('PM MF company, grid 3 %: 10 000 Restauration + 6 000 Carburant -> 16 581,000, one ledger line per fee', async () => {
    const company = await companyWithGrid([{ rateBps: 300 }]);
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Ahmed B.'),
    );
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Sarra F.'));
    const lines = [
      { creditType: 'RESTAURATION', amountMillimes: 10_000_000 },
      { creditType: 'CARBURANT', amountMillimes: 6_000_000 },
    ];
    const quote = await owner.call('POST', '/v1/company/order-quotes', { body: { lines } });
    expect(quote.body).toMatchObject({
      amountMillimes: 16_000_000,
      feesMillimes: 480_000,
      vatMillimes: 91_200,
      withholdingRateBps: 100,
      withholdingMillimes: 4_800,
      stampDutyMillimes: 1_000,
      transferFeeMillimes: 4_000,
      totalMillimes: 16_581_000,
    });
    const created = await owner.call('POST', '/v1/company/orders', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    expect(created.body.totalMillimes).toBe(16_581_000);
    const id = String(created.body.id);
    await db.system((tx) =>
      tx.creditOrder.update({ where: { id }, data: { secondValidationRequired: false } }),
    );
    await admin.call('POST', `/v1/admin/credit-orders/${id}/confirm`);
    await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form: declaration('16581000'),
      headers: key(),
    });
    expect(
      (await admin.call('POST', `/v1/admin/credit-orders/${id}/validate`, { headers: key() }))
        .status,
    ).toBe(200);
    const entries = await ledgerLines(db, String(created.body.reference));
    expect(entries).toEqual(
      expect.arrayContaining([
        { code: 'BANK_ESCROW', direction: 'D', amount: 16_581_000 },
        { code: 'REVENUE_COMPANY_FEES', direction: 'C', amount: 480_000 },
        { code: 'VAT_COLLECTED', direction: 'C', amount: 91_200 },
        { code: 'WITHHOLDING_TAX', direction: 'C', amount: 4_800 },
        { code: 'STAMP_DUTY', direction: 'C', amount: 1_000 },
        { code: 'REVENUE_TRANSFER_FEES', direction: 'C', amount: 4_000 },
      ]),
    );
  });
});
