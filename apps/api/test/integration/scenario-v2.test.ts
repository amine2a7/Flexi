// « Scénario complet tracé » of processus v2, replayed on the real API: from the creation of
// Carthage Industries to Karim's payout, 16 576,200 TND come in and every millime is found at the
// end (balances, payout, fees), with the books reconciled.
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { hashSecret } = await import('../../src/auth/password.js');
const { createUser, sealed, seedSettings, signedIn } = await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
const ledger = new LedgerService();
let base = '';
const PIN = '4826';
const TND = (dinars: number) => dinars * 1_000;
const key = () => ({ 'Idempotency-Key': crypto.randomUUID() });
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  'base64',
);
let previousLimit = 0n;

beforeAll(async () => {
  await seedSettings(db);
  // The demo limit of Restauration (150 TND a day): each worker eats for 125 TND in one day.
  await db.system(async (tx) => {
    previousLimit = (
      await tx.creditTypeSetting.findUniqueOrThrow({ where: { creditType: 'RESTAURATION' } })
    ).dailyLimitMillimes;
    await tx.creditTypeSetting.update({
      where: { creditType: 'RESTAURATION' },
      data: { dailyLimitMillimes: 150_000n },
    });
  });
  base = await listen(app);
});
afterAll(async () => {
  await db.system((tx) =>
    tx.creditTypeSetting.update({
      where: { creditType: 'RESTAURATION' },
      data: { dailyLimitMillimes: previousLimit },
    }),
  );
  await app.close();
  await db.onModuleDestroy();
});

function form(fields: Record<string, string>, fileField: string, name: string): FormData {
  const data = new FormData();
  for (const [field, value] of Object.entries(fields)) data.set(field, value);
  data.set(fileField, new Blob([PNG]), name);
  return data;
}

describe('scénario complet tracé (processus v2)', () => {
  it('16 576,200 TND come in, and every millime is found at the end', async () => {
    const stamp = String(Date.now()).slice(-6);
    // 1. Amine (Operations, here the super-admin who creates clients) creates Carthage.
    const amine = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Amine', 'SUPER_ADMIN'),
    );
    const created = await amine.call('POST', '/v1/admin/companies', {
      body: {
        name: `Carthage Industries ${stamp}`,
        legalForm: 'PM_MF',
        city: 'Tunis',
        phone: '+21671000001',
        email: `ahmed-${stamp}@carthage.tn`,
        commissionGrid: [{ rateBps: 300, minMillimes: null, maxMillimes: null }],
      },
    });
    expect(created.status).toBe(201);
    expect(created.body.credentials).toBeDefined();
    const companyId = String(created.body.id);
    // 2-3. Ahmed signs in and files RNE, tax card, CIN (front and back) and RIB.
    const ahmed = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId }, 'Ahmed'),
    );
    for (const type of [
      'REGISTRY_EXTRACT',
      'TAX_CERTIFICATE',
      'MANAGER_ID_FRONT',
      'MANAGER_ID_BACK',
      'BANK_DETAILS',
    ])
      expect(
        (
          await ahmed.call('POST', '/v1/account/kyc/documents', {
            form: form({ type }, 'document', `${type}.png`),
          })
        ).status,
      ).toBe(201);
    // 4. Another administrator validates the file (the creator never decides it).
    const operations = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Sonia', 'COMPLIANCE'),
    );
    const fileId = String((await ahmed.call('GET', '/v1/account/kyc')).body.id);
    expect((await operations.call('POST', `/v1/admin/kyc-files/${fileId}/approve`)).status).toBe(
      200,
    );
    // 5. Production department and 10 employees, among them Yasmine.
    const department = await ahmed.call('POST', '/v1/company/departments', {
      body: { name: 'Production' },
    });
    const pinHash = await hashSecret(PIN);
    const workers = await db.system((tx) =>
      Promise.all(
        Array.from({ length: 10 }, (_, index) =>
          tx.employee.create({
            data: {
              companyId,
              employeeNumber: `PRD-${String(index + 1)}`,
              firstName: index === 0 ? 'Yasmine' : `Ouvrier${String(index)}`,
              lastName: 'Production',
              email: `prd-${stamp}-${String(index)}@carthage.tn`,
              phone: sealed('+21622123456'),
              status: 'ACTIVE',
              departmentId: String(department.body.id),
              position: index === 0 ? 'Ouvrière' : 'Ouvrier',
              pinHash,
            },
          }),
        ),
      ),
    );
    // 6. Order: Restauration 10 000 + Carburant 6 000, frozen quote 16 576,200 (corrections of 13/11: no withholding, frais TTC under 1 000).
    const quote = await ahmed.call('POST', '/v1/company/order-quotes', {
      body: {
        lines: [
          { creditType: 'RESTAURATION', amountMillimes: TND(10_000) },
          { creditType: 'CARBURANT', amountMillimes: TND(6_000) },
        ],
      },
    });
    expect(quote.body.totalMillimes).toBe(16_576_200);
    const order = await ahmed.call('POST', '/v1/company/orders', {
      body: { quoteId: quote.body.quoteId },
      headers: key(),
    });
    const orderId = String(order.body.id);
    // 7. Amine confirms.
    expect((await amine.call('POST', `/v1/admin/credit-orders/${orderId}/confirm`)).status).toBe(
      200,
    );
    // 8. Ahmed transfers 16 576,200 and declares VIR-BIAT-778213.
    const declared = await ahmed.call(
      'POST',
      `/v1/company/orders/${orderId}/transfer-declarations`,
      {
        form: form(
          {
            transferReference: 'VIR-BIAT-778213',
            transferDate: new Date().toISOString().slice(0, 10),
            amountMillimes: '16576200',
          },
          'proof',
          'avis.png',
        ),
        headers: key(),
      },
    );
    expect(declared.status).toBe(201);
    // 9-10. Sarra validates (1/2), Nour confirms (2/2): Restauration +10 000, Carburant +6 000.
    const sarra = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Sarra', 'FINANCE'));
    const nour = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Nour', 'FINANCE'));
    const first = await sarra.call('POST', `/v1/admin/credit-orders/${orderId}/validate`, {
      headers: key(),
    });
    expect(first.body.status).toBe('AWAITING_VALIDATION');
    const second = await nour.call('POST', `/v1/admin/credit-orders/${orderId}/validate`, {
      headers: key(),
    });
    expect(second.body.status).toBe('VALIDATED');
    // 11. Ahmed gives 150 TND of Restauration to the 10 employees of Production.
    const allocated = await ahmed.call('POST', '/v1/company/allocations', {
      headers: key(),
      body: {
        allocations: workers.map((worker) => ({
          employeeId: worker.id,
          creditType: 'RESTAURATION',
          amountMillimes: TND(150),
        })),
      },
    });
    expect(allocated.status).toBe(201);
    // 12. Meals at Le Jasmin (Karim, PP CIN, grid 2 %): 1 250 TND in all.
    const jasmin = await db.system((tx) =>
      tx.merchant.create({
        data: {
          name: `Restaurant Le Jasmin ${stamp}`,
          category: 'RESTAURANT',
          city: 'Tunis',
          phone: sealed('+21671000002'),
          email: `karim-${stamp}@lejasmin.tn`,
          status: 'APPROVED',
          legalForm: 'PP_CIN',
          acceptedCreditTypes: ['RESTAURATION'],
          paymentCode: stamp,
          iban: sealed('TN5910006035183598470014'),
          commissionGrids: { create: { tiers: { create: [{ position: 0, rateBps: 200 }] } } },
        },
      }),
    );
    for (const worker of workers) {
      const client = await signedIn(
        base,
        await createUser(db, env, 'EMPLOYEE', { employeeId: worker.id }, worker.firstName),
      );
      const paid = await client.call('POST', '/v1/employee/payments', {
        headers: key(),
        body: {
          merchantCode: jasmin.paymentCode,
          creditType: 'RESTAURATION',
          amountMillimes: TND(125),
          pin: PIN,
        },
      });
      expect(paid.status).toBe(201);
    }
    // 13. Karim asks the payout of his 1 250,000: net announced 1 215,250.
    const karim = await signedIn(
      base,
      await createUser(db, env, 'MERCHANT', { merchantId: jasmin.id }, 'Karim'),
    );
    const payoutQuote = await karim.call('POST', '/v1/merchant/payout-quotes', {
      body: { creditType: 'RESTAURATION', grossMillimes: TND(1_250) },
    });
    expect(payoutQuote.body.netMillimes).toBe(1_215_250);
    const requested = await karim.call('POST', '/v1/merchant/payouts', {
      body: { quoteId: payoutQuote.body.quoteId },
      headers: key(),
    });
    const payoutId = String(requested.body.id);
    // 14. Sarra accepts; 15. transfers from FlexiPay's bank; 16. records VIR-FP-000231.
    expect(
      (
        await sarra.call('POST', `/v1/admin/payout-requests/${payoutId}/approve`, {
          headers: key(),
        })
      ).status,
    ).toBe(200);
    const recorded = await sarra.call('POST', `/v1/admin/payout-requests/${payoutId}/payment`, {
      headers: key(),
      body: { bankReference: 'VIR-FP-000231', paidOn: '2026-11-16', amountMillimes: 1_215_250 },
    });
    expect(recorded.body).toMatchObject({ status: 'EXECUTED' });
    expect((await karim.call('GET', `/v1/merchant/payouts/${payoutId}`)).body).toMatchObject({
      status: 'EXECUTED',
      payment: { bankReference: 'VIR-FP-000231' },
    });

    // The final check: no millime lost.
    await db.system(async (tx) => {
      const balance = (account: Parameters<typeof ledger.balance>[1]) =>
        ledger.balance(tx, account);
      const carthage =
        (await balance(accounts.companyWallet(companyId, 'RESTAURATION'))) +
        (await balance(accounts.companyWallet(companyId, 'CARBURANT')));
      expect(carthage).toBe(14_500_000n);
      let employees = 0n;
      for (const worker of workers)
        employees += await balance(accounts.employeeWallet(worker.id, 'RESTAURATION'));
      expect(employees).toBe(250_000n);
      const fees = await tx.creditOrder.findUniqueOrThrow({ where: { id: orderId } });
      const carthageFees = fees.totalMillimes - fees.amountMillimes;
      expect(carthageFees).toBe(576_200n);
      const payout = await tx.payoutRequest.findUniqueOrThrow({ where: { id: payoutId } });
      expect(payout.paidAmountMillimes).toBe(1_215_250n);
      const karimFees = payout.grossMillimes - payout.netMillimes;
      expect(karimFees).toBe(34_750n);
      expect(carthage + employees + payout.netMillimes + carthageFees + karimFees).toBe(
        16_576_200n,
      );
      const books = await ledger.reconcile(tx);
      expect(books.ok).toBe(true);
    });
  });
});
