// TEST-FIRST, processus v2 (« Relancer chaque mois », à confirmer dans le PDF; décision du
// 2026-11-12): a template may relaunch itself on a day of the month (1 to 28), as its author, for
// the CURRENT employees of its filters; at most once a month (deterministic key); never over the
// balance (nothing moves, the template says « échec », the company relaunches by hand).
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { AllocationTemplatesService } =
  await import('../../src/company/allocation-templates.service.js');
const { createCompany, createUser, sealed, seedSettings, signedIn } = await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
const ledger = new LedgerService();
let base = '';

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

async function person(companyId: string, departmentId: string, position: string) {
  return db.system((tx) =>
    tx.employee.create({
      data: {
        companyId,
        employeeNumber: `E-${randomUUID().slice(0, 6)}`,
        firstName: 'Employé',
        lastName: randomUUID().slice(0, 6),
        email: `${randomUUID().slice(0, 8)}@salarie.test`,
        phone: sealed('+21698123456'),
        status: 'ACTIVE',
        departmentId,
        position,
      },
    }),
  );
}

const at = (iso: string) => new Date(iso);

describe('monthly relaunch of a template', () => {
  it('runs on its day once a month, as its author, and never over the balance', async () => {
    const company = await createCompany(db);
    const client = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Ahmed B.', 'OWNER'),
    );
    const production = String(
      (await client.call('POST', '/v1/company/departments', { body: { name: 'Production' } })).body
        .id,
    );
    const workers = [
      await person(company.id, production, 'Ouvrier'),
      await person(company.id, production, 'Ouvrier'),
    ];
    await db.system((tx) =>
      ledger.post(tx, {
        type: 'ALLOCATION',
        reference: `TEST-FUND-${randomUUID().slice(0, 6)}`,
        entries: [
          { account: accounts.bankEscrow(), direction: 'D', amount: 300_000n },
          {
            account: accounts.companyWallet(company.id, 'RESTAURATION'),
            direction: 'C',
            amount: 300_000n,
          },
        ],
      }),
    );

    // A day outside 1..28 is refused (every month has it).
    const invalid = await client.call('POST', '/v1/company/allocation-templates', {
      body: {
        name: 'Fin de mois',
        departmentId: production,
        position: 'Ouvrier',
        amounts: [{ creditType: 'RESTAURATION', amountMillimes: 100_000 }],
        autoMonthlyDay: 31,
      },
    });
    expect(invalid.status).toBe(400);

    const created = await client.call('POST', '/v1/company/allocation-templates', {
      body: {
        name: 'Tickets du mois',
        departmentId: production,
        position: 'Ouvrier',
        amounts: [{ creditType: 'RESTAURATION', amountMillimes: 100_000 }],
        autoMonthlyDay: 5,
      },
    });
    expect(created.status).toBe(201);
    expect(created.body).toMatchObject({ autoMonthlyDay: 5, lastAutoRun: null });

    const templates = app.get(AllocationTemplatesService);
    // Before its day: nothing. Its day: the 2 Ouvriers receive 100 TND each.
    expect(await templates.runMonthly(at('2026-12-04T09:00:00+01:00'))).toBe(0);
    expect(await templates.runMonthly(at('2026-12-05T09:00:00+01:00'))).toBe(1);
    // The job runs every 10 minutes: never twice in the same month.
    expect(await templates.runMonthly(at('2026-12-05T09:10:00+01:00'))).toBe(0);
    expect(await templates.runMonthly(at('2026-12-20T09:00:00+01:00'))).toBe(0);
    await db.system(async (tx) => {
      for (const worker of workers) {
        expect(await ledger.balance(tx, accounts.employeeWallet(worker.id, 'RESTAURATION'))).toBe(
          100_000n,
        );
      }
      expect(await ledger.balance(tx, accounts.companyWallet(company.id, 'RESTAURATION'))).toBe(
        100_000n,
      );
    });
    let list = await client.call('GET', '/v1/company/allocation-templates');
    expect((list.body.data as unknown[])[0]).toMatchObject({
      lastAutoRun: { month: '2026-12', status: 'DONE' },
    });

    // Next month: 200 TND needed, 100 left. Refused: nothing moves, the template says why.
    expect(await templates.runMonthly(at('2027-01-05T09:00:00+01:00'))).toBe(0);
    await db.system(async (tx) => {
      expect(await ledger.balance(tx, accounts.companyWallet(company.id, 'RESTAURATION'))).toBe(
        100_000n,
      );
      expect((await ledger.reconcile(tx)).ok).toBe(true);
    });
    list = await client.call('GET', '/v1/company/allocation-templates');
    expect((list.body.data as unknown[])[0]).toMatchObject({
      lastAutoRun: { month: '2027-01', status: 'INSUFFICIENT_FUNDS' },
    });

    // Switched off: never again.
    const id = String(created.body.id);
    const off = await client.call('PUT', `/v1/company/allocation-templates/${id}`, {
      body: {
        name: 'Tickets du mois',
        departmentId: production,
        position: 'Ouvrier',
        amounts: [{ creditType: 'RESTAURATION', amountMillimes: 100_000 }],
        autoMonthlyDay: null,
      },
    });
    expect(off.body).toMatchObject({ autoMonthlyDay: null });
    expect(await templates.runMonthly(at('2027-02-05T09:00:00+01:00'))).toBe(0);
  });
});
