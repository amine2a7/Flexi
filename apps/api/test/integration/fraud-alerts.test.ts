// TEST-FIRST fraud alerts (decision of 2026-10-31): starting rules, set by the super-admin,
// detected by the job, never blocking anything; Opérations handles them (open → in progress →
// closed with a reason).
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { FraudService } = await import('../../src/risk/fraud.service.js');
const { createCompany, createEmployee, createUser, sealed, seedSettings, signedIn } =
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

const admin = async (subRole: 'COMPLIANCE' | 'FINANCE') =>
  signedIn(base, await createUser(db, env, 'ADMIN', {}, `Admin ${subRole}`, subRole));

async function shopAndEmployee() {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  const merchant = await db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Café ${randomUUID().slice(0, 5)}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: sealed('+21671000001'),
        email: 'cafe@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: ['RESTAURATION'],
        paymentCode: String(randomInt(100_000, 999_999)),
      },
    }),
  );
  return { company, employee, merchant };
}

async function payments(
  count: number,
  input: { merchantId: string; employeeId: string; companyId: string },
  status: 'REFUSED' | 'CONFIRMED',
  amount = 1_000n,
) {
  await db.system((tx) =>
    tx.payment.createMany({
      data: Array.from({ length: count }, () => ({
        reference: `PAY-T-${randomUUID().slice(0, 12)}`,
        ...input,
        creditType: 'RESTAURATION' as const,
        amountMillimes: amount,
        status,
        channel: 'MERCHANT_CODE' as const,
      })),
    }),
  );
}

describe('fraud alerts', () => {
  it('raises one alert for more than 5 refused payments in 10 minutes, whatever the runs', async () => {
    const { company, employee, merchant } = await shopAndEmployee();
    const owner = { merchantId: merchant.id, employeeId: employee.id, companyId: company.id };
    await payments(6, owner, 'REFUSED');
    const fraud = app.get(FraudService);
    await fraud.detect();
    await fraud.detect();
    const alerts = await db.system((tx) =>
      tx.fraudAlert.findMany({
        where: { kind: 'REPEATED_REFUSALS', subjectKey: { startsWith: employee.id } },
      }),
    );
    expect(alerts.length).toBe(1);
    expect(alerts[0]?.severity).toBe('HIGH');
  });

  it('raises an alert for more than 3 payments at the same shop in 5 minutes, and near the daily limit', async () => {
    const { company, employee, merchant } = await shopAndEmployee();
    const owner = { merchantId: merchant.id, employeeId: employee.id, companyId: company.id };
    await payments(4, owner, 'CONFIRMED');
    const limit = await db.system((tx) =>
      tx.creditTypeSetting.findFirstOrThrow({ where: { creditType: 'RESTAURATION' } }),
    );
    await payments(1, owner, 'CONFIRMED', (limit.dailyLimitMillimes * 85n) / 100n);
    await app.get(FraudService).detect();
    const kinds = await db.system((tx) =>
      tx.fraudAlert.findMany({
        where: { subjectKey: { contains: employee.id } },
        select: { kind: true },
      }),
    );
    expect(kinds.map((row) => row.kind).sort()).toEqual(['MERCHANT_BURST', 'NEAR_DAILY_LIMIT']);
  });

  it('opérations handles an alert (in progress, then closed with a reason); finance cannot', async () => {
    const { company, employee, merchant } = await shopAndEmployee();
    await payments(
      6,
      { merchantId: merchant.id, employeeId: employee.id, companyId: company.id },
      'REFUSED',
    );
    await app.get(FraudService).detect();
    const alert = await db.system((tx) =>
      tx.fraudAlert.findFirstOrThrow({ where: { subjectKey: { startsWith: employee.id } } }),
    );
    const ops = await admin('COMPLIANCE');
    const finance = await admin('FINANCE');
    expect((await finance.call('POST', `/v1/admin/fraud-alerts/${alert.id}/start`)).status).toBe(
      403,
    );
    const started = await ops.call('POST', `/v1/admin/fraud-alerts/${alert.id}/start`);
    expect(started.body.status).toBe('IN_PROGRESS');
    const closed = await ops.call('POST', `/v1/admin/fraud-alerts/${alert.id}/close`, {
      body: { reason: 'Code client saisi trop vite, aucune fraude.' },
    });
    expect(closed.body.status).toBe('CLOSED');
    const list = await ops.call('GET', '/v1/admin/fraud-alerts');
    expect((list.body.data as { id: string }[]).some((row) => row.id === alert.id)).toBe(true);
  });
});
