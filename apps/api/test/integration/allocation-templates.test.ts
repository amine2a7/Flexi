// TEST-FIRST, processus v2 (processus 4 · Attribuer des crédits): filters by department and
// position, several credit types at once, a preview with the balance left per type, templates
// saved and relaunched with the CURRENT employees of their filters.
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
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

const key = () => ({ 'Idempotency-Key': randomUUID() });
type Type = 'RESTAURATION' | 'CARBURANT';

async function fund(companyId: string, creditType: Type, amount: bigint) {
  await db.system((tx) =>
    ledger.post(tx, {
      type: 'ALLOCATION',
      reference: `TEST-FUND-${randomUUID().slice(0, 6)}`,
      entries: [
        { account: accounts.bankEscrow(), direction: 'D', amount },
        { account: accounts.companyWallet(companyId, creditType), direction: 'C', amount },
      ],
    }),
  );
}

async function person(
  companyId: string,
  departmentId: string | null,
  position: string | null,
  status: 'ACTIVE' | 'SUSPENDED' = 'ACTIVE',
) {
  return db.system((tx) =>
    tx.employee.create({
      data: {
        companyId,
        employeeNumber: `E-${randomUUID().slice(0, 6)}`,
        firstName: 'Employé',
        lastName: randomUUID().slice(0, 6),
        email: `${randomUUID().slice(0, 8)}@salarie.test`,
        phone: sealed('+21698123456'),
        status,
        departmentId,
        position,
      },
    }),
  );
}

/** A company with Production (2 Ouvriers, 1 suspended Ouvrier, 1 Chef) and Commercial (1 Ouvrier). */
async function setUp() {
  const company = await createCompany(db);
  const client = await signedIn(
    base,
    await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Ahmed B.', 'OWNER'),
  );
  const production = String(
    (await client.call('POST', '/v1/company/departments', { body: { name: 'Production' } })).body
      .id,
  );
  const commercial = String(
    (await client.call('POST', '/v1/company/departments', { body: { name: 'Commercial' } })).body
      .id,
  );
  const workers = [
    await person(company.id, production, 'Ouvrier'),
    await person(company.id, production, 'Ouvrier'),
  ];
  await person(company.id, production, 'Ouvrier', 'SUSPENDED');
  await person(company.id, production, 'Chef d’équipe');
  await person(company.id, commercial, 'Ouvrier');
  return { company, client, production, commercial, workers };
}

describe('allocation with filters, several types and a preview', () => {
  it('previews the employees of the filters, the total, the balance left and what is missing', async () => {
    const { company, client, production, workers } = await setUp();
    await fund(company.id, 'RESTAURATION', 1_000_000n);
    await fund(company.id, 'CARBURANT', 100_000n);
    const preview = await client.call('POST', '/v1/company/allocation-previews', {
      body: {
        departmentId: production,
        position: 'ouvrier',
        amounts: [
          { creditType: 'RESTAURATION', amountMillimes: 150_000 },
          { creditType: 'CARBURANT', amountMillimes: 100_000 },
        ],
      },
    });
    expect(preview.status).toBe(200);
    // Only the ACTIVE Ouvriers of Production (never the suspended one, nor another department).
    expect(preview.body.employeeCount).toBe(2);
    expect(
      (preview.body.employees as { id: string }[]).map((employee) => employee.id).sort(),
    ).toEqual(workers.map((worker) => worker.id).sort());
    expect(preview.body.lines).toEqual([
      {
        creditType: 'RESTAURATION',
        perEmployeeMillimes: 150_000,
        totalMillimes: 300_000,
        balanceMillimes: 1_000_000,
        remainingMillimes: 700_000,
        missingMillimes: 0,
      },
      {
        creditType: 'CARBURANT',
        perEmployeeMillimes: 100_000,
        totalMillimes: 200_000,
        balanceMillimes: 100_000,
        remainingMillimes: 0,
        missingMillimes: 100_000,
      },
    ]);
    expect(preview.body.sufficient).toBe(false);

    // Over the balance of one type: refused, nothing is allocated (the other type neither).
    const lines = workers.flatMap((worker) => [
      { employeeId: worker.id, creditType: 'RESTAURATION', amountMillimes: 150_000 },
      { employeeId: worker.id, creditType: 'CARBURANT', amountMillimes: 100_000 },
    ]);
    const refused = await client.call('POST', '/v1/company/allocations', {
      headers: key(),
      body: { allocations: lines },
    });
    expect(refused.status).toBe(422);
    expect(refused.body.details).toMatchObject({ missingMillimes: 100_000 });
    await db.system(async (tx) => {
      expect(await ledger.balance(tx, accounts.companyWallet(company.id, 'RESTAURATION'))).toBe(
        1_000_000n,
      );
    });

    // Two types at once, within the balances: the balances move by exactly these amounts.
    await fund(company.id, 'CARBURANT', 100_000n);
    const done = await client.call('POST', '/v1/company/allocations', {
      headers: key(),
      body: { allocations: lines },
    });
    expect(done.status).toBe(201);
    await db.system(async (tx) => {
      expect(await ledger.balance(tx, accounts.companyWallet(company.id, 'RESTAURATION'))).toBe(
        700_000n,
      );
      expect(await ledger.balance(tx, accounts.companyWallet(company.id, 'CARBURANT'))).toBe(0n);
      for (const worker of workers) {
        expect(await ledger.balance(tx, accounts.employeeWallet(worker.id, 'RESTAURATION'))).toBe(
          150_000n,
        );
        expect(await ledger.balance(tx, accounts.employeeWallet(worker.id, 'CARBURANT'))).toBe(
          100_000n,
        );
      }
    });
  });

  it('« Tout sélectionner »: the preview without amounts lists every employee of the filters', async () => {
    const { client } = await setUp();
    const all = await client.call('POST', '/v1/company/allocation-previews', {
      body: { amounts: [] },
    });
    expect(all.status).toBe(200);
    // Every ACTIVE employee of the company: 2 Ouvriers + 1 Chef + 1 Ouvrier of Commercial.
    expect(all.body.employeeCount).toBe(4);
    expect(all.body.lines).toEqual([]);
    const ouvriers = await client.call('POST', '/v1/company/allocation-previews', {
      body: { position: 'Ouvrier', amounts: [] },
    });
    expect(ouvriers.body.employeeCount).toBe(3);
  });
});

describe('allocation templates', () => {
  it('saves, lists, edits and relaunches a template with the current employees', async () => {
    const { company, client, production } = await setUp();
    await fund(company.id, 'RESTAURATION', 2_000_000n);
    const created = await client.call('POST', '/v1/company/allocation-templates', {
      body: {
        name: 'Tickets mensuels Production',
        departmentId: production,
        position: 'Ouvrier',
        amounts: [{ creditType: 'RESTAURATION', amountMillimes: 150_000 }],
      },
    });
    expect(created.status).toBe(201);
    expect(created.body).toMatchObject({
      name: 'Tickets mensuels Production',
      departmentId: production,
      departmentName: 'Production',
      position: 'Ouvrier',
      amounts: [{ creditType: 'RESTAURATION', amountMillimes: 150_000 }],
      lastRunAt: null,
    });
    const templateId = String(created.body.id);
    expect(
      (
        await client.call('POST', '/v1/company/allocation-templates', {
          body: { ...created.body, id: undefined, departmentName: undefined },
        })
      ).status,
    ).toBe(400);
    expect(
      (
        await client.call('POST', '/v1/company/allocation-templates', {
          body: {
            name: 'tickets MENSUELS production',
            departmentId: null,
            position: null,
            amounts: [{ creditType: 'RESTAURATION', amountMillimes: 1_000 }],
          },
        })
      ).status,
    ).toBe(409);

    // A new Ouvrier joins Production: the relaunch includes him (filters, not a frozen list).
    const newcomer = await person(company.id, production, 'Ouvrier');
    const preview = await client.call('POST', '/v1/company/allocation-previews', {
      body: { templateId, amounts: [] },
    });
    expect(preview.body.employeeCount).toBe(3);
    expect((preview.body.employees as { id: string }[]).map((item) => item.id)).toContain(
      newcomer.id,
    );
    expect(preview.body.lines).toEqual([
      expect.objectContaining({ creditType: 'RESTAURATION', totalMillimes: 450_000 }),
    ]);

    // Edit the amount, then relaunch: the allocation carries the template.
    const edited = await client.call('PUT', `/v1/company/allocation-templates/${templateId}`, {
      body: {
        name: 'Tickets mensuels Production',
        departmentId: production,
        position: 'Ouvrier',
        amounts: [{ creditType: 'RESTAURATION', amountMillimes: 200_000 }],
      },
    });
    expect(edited.status).toBe(200);
    expect(edited.body.amounts).toEqual([{ creditType: 'RESTAURATION', amountMillimes: 200_000 }]);
    const relaunch = await client.call('POST', '/v1/company/allocation-previews', {
      body: { templateId, amounts: [] },
    });
    expect((relaunch.body.lines as unknown[])[0]).toMatchObject({
      totalMillimes: 600_000,
      remainingMillimes: 1_400_000,
    });
    const allocated = await client.call('POST', '/v1/company/allocations', {
      headers: key(),
      body: {
        templateId,
        allocations: (relaunch.body.employees as { id: string }[]).map((employee) => ({
          employeeId: employee.id,
          creditType: 'RESTAURATION',
          amountMillimes: 200_000,
        })),
      },
    });
    expect(allocated.status).toBe(201);
    const list = await client.call('GET', '/v1/company/allocation-templates');
    const templates = list.body.data as { lastRunAt: string | null }[];
    expect(templates).toHaveLength(1);
    expect(templates[0]?.lastRunAt).not.toBeNull();
    await db.system(async (tx) => {
      expect(await tx.allocation.count({ where: { templateId } })).toBe(3);
    });

    // Delete: gone from the list (archived, the history keeps it).
    expect(
      (await client.call('DELETE', `/v1/company/allocation-templates/${templateId}`)).status,
    ).toBe(204);
    expect((await client.call('GET', '/v1/company/allocation-templates')).body.data).toEqual([]);
    expect(
      (
        await client.call('POST', '/v1/company/allocation-previews', {
          body: { templateId, amounts: [] },
        })
      ).status,
    ).toBe(404);
  });

  it('a company never sees nor uses the templates or departments of another one', async () => {
    const first = await setUp();
    const created = await first.client.call('POST', '/v1/company/allocation-templates', {
      body: {
        name: 'Aïd',
        departmentId: null,
        position: null,
        amounts: [{ creditType: 'RESTAURATION', amountMillimes: 50_000 }],
      },
    });
    const other = await createCompany(db);
    const intruder = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: other.id }, 'Autre E.', 'OWNER'),
    );
    expect((await intruder.call('GET', '/v1/company/allocation-templates')).body.data).toEqual([]);
    const id = String(created.body.id);
    expect(
      (
        await intruder.call('PUT', `/v1/company/allocation-templates/${id}`, {
          body: {
            name: 'Volé',
            departmentId: null,
            position: null,
            amounts: [{ creditType: 'RESTAURATION', amountMillimes: 1_000 }],
          },
        })
      ).status,
    ).toBe(404);
    expect((await intruder.call('DELETE', `/v1/company/allocation-templates/${id}`)).status).toBe(
      404,
    );
    expect(
      (
        await intruder.call('POST', '/v1/company/allocation-templates', {
          body: {
            name: 'Production des autres',
            departmentId: first.production,
            position: null,
            amounts: [{ creditType: 'RESTAURATION', amountMillimes: 1_000 }],
          },
        })
      ).status,
    ).toBe(404);
    expect(
      (
        await intruder.call('POST', '/v1/company/allocation-previews', {
          body: { departmentId: first.production, amounts: [] },
        })
      ).status,
    ).toBe(404);
    expect(
      (
        await intruder.call('POST', '/v1/company/allocations', {
          headers: key(),
          body: {
            templateId: id,
            allocations: [
              {
                employeeId: first.workers[0]?.id ?? '',
                creditType: 'RESTAURATION',
                amountMillimes: 1_000,
              },
            ],
          },
        })
      ).status,
    ).toBe(404);
  });
});
