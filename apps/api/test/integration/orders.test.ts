// Credit order circuit and allocation, over HTTP (financial: idempotency, ledger, four-eyes, RLS).
import { randomUUID } from 'node:crypto';
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

async function setup() {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  const owner = await signedIn(
    base,
    await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.'),
  );
  const adminA = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
  const adminB = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.'));
  return { company, employee, owner, adminA, adminB };
}

const key = () => ({ 'Idempotency-Key': randomUUID() });

describe('credit order circuit', () => {
  it('orders, confirms, declares the transfer, validates: each type is credited', async () => {
    const { owner, adminA } = await setup();
    const quote = await owner.call('POST', '/v1/company/order-quotes', {
      body: {
        lines: [
          { creditType: 'RESTAURATION', amountMillimes: 1_000_000 },
          { creditType: 'CADEAUX', amountMillimes: 500_000 },
        ],
      },
    });
    expect(quote.body).toMatchObject({
      amountMillimes: 1_500_000,
      feeRateBps: 150,
      feesMillimes: 22_500,
      totalMillimes: 1_522_500,
    });

    const headers = key();
    const body = {
      lines: [
        { creditType: 'CADEAUX', amountMillimes: 500_000 },
        { creditType: 'RESTAURATION', amountMillimes: 1_000_000 },
      ],
    };
    const created = await owner.call('POST', '/v1/company/orders', { body, headers });
    expect(created.status).toBe(201);
    expect(created.body).toMatchObject({
      status: 'AWAITING_CONFIRMATION',
      totalMillimes: 1_522_500,
    });
    expect((created.body.lines as { creditType: string }[]).map((line) => line.creditType)).toEqual(
      ['RESTAURATION', 'CADEAUX'],
    );
    // Same key, same body: the same answer, replayed. Same key, other body: refused.
    const replay = await owner.call('POST', '/v1/company/orders', { body, headers });
    expect(replay.body.id).toBe(created.body.id);
    expect(replay.headers.get('idempotent-replayed')).toBe('true');
    const reused = await owner.call('POST', '/v1/company/orders', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 900_000 }] },
      headers,
    });
    expect(reused.body.code).toBe('IDEMPOTENCY_KEY_REUSED');
    expect((await owner.call('POST', '/v1/company/orders', { body })).body.code).toBe(
      'IDEMPOTENCY_KEY_REQUIRED',
    );

    const id = String(created.body.id);
    expect((await adminA.call('POST', `/v1/admin/credit-orders/${id}/confirm`)).body.status).toBe(
      'AWAITING_PAYMENT',
    );
    const invoices = await owner.call('GET', '/v1/company/invoices');
    expect((invoices.body.data as { status: string; totalMillimes: number }[])[0]).toMatchObject({
      status: 'UNPAID',
      totalMillimes: 1_522_500,
    });

    const declared = await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form: declaration('1522500'),
      headers: key(),
    });
    expect(declared.status).toBe(201);
    expect(declared.body).toMatchObject({
      status: 'AWAITING_VALIDATION',
      declaration: { proof: { contentType: 'image/png' } },
    });
    const proof = await fetch(`${base}/v1/admin/credit-orders/${id}/proof`, {
      headers: { Cookie: `__Host-fp_at=${adminA.cookie('__Host-fp_at') ?? ''}` },
    });
    expect(proof.headers.get('content-disposition')).toMatch(/^attachment/);
    expect(Buffer.from(await proof.arrayBuffer()).equals(PNG)).toBe(true);

    const validated = await adminA.call('POST', `/v1/admin/credit-orders/${id}/validate`, {
      headers: key(),
    });
    expect(validated.body.status).toBe('VALIDATED');
    const dashboard = await owner.call('GET', '/v1/company/dashboard');
    expect(dashboard.body.balances).toEqual([
      { creditType: 'RESTAURATION', amountMillimes: 1_000_000 },
      { creditType: 'HABILLEMENT', amountMillimes: 0 },
      { creditType: 'CARBURANT', amountMillimes: 0 },
      { creditType: 'CADEAUX', amountMillimes: 500_000 },
    ]);
    expect(dashboard.body.walletBalanceMillimes).toBe(1_500_000);
    expect(
      ((await owner.call('GET', '/v1/company/invoices')).body.data as { status: string }[])[0]
        ?.status,
    ).toBe('PAID');
  });

  it('refuses a proof that is not a JPG, PNG or PDF (content sniffed, not the name)', async () => {
    const { owner, adminA } = await setup();
    const created = await owner.call('POST', '/v1/company/orders', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 200_000 }] },
      headers: key(),
    });
    const id = String(created.body.id);
    await adminA.call('POST', `/v1/admin/credit-orders/${id}/confirm`);
    const fake = await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form: declaration('203000', Buffer.from('<script>alert(1)</script>'), 'avis.png'),
      headers: key(),
    });
    expect(fake.status).toBe(415);
    const future = declaration('203000');
    future.set('transferDate', '2999-01-01');
    const inFuture = await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form: future,
      headers: key(),
    });
    expect(JSON.stringify(inFuture.body)).toContain('IN_FUTURE');
  });

  it('needs two different administrators above 10 000,000 TND (four-eyes)', async () => {
    const { owner, adminA, adminB } = await setup();
    const created = await owner.call('POST', '/v1/company/orders', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 12_000_000 }] },
      headers: key(),
    });
    const id = String(created.body.id);
    await adminA.call('POST', `/v1/admin/credit-orders/${id}/confirm`);
    await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form: declaration('12180000'),
      headers: key(),
    });
    const first = await adminA.call('POST', `/v1/admin/credit-orders/${id}/validate`, {
      headers: key(),
    });
    expect(first.body).toMatchObject({
      status: 'AWAITING_VALIDATION',
      requiresSecondValidation: true,
      firstValidation: { actorName: 'Amine K.', byMe: true },
    });
    const same = await adminA.call('POST', `/v1/admin/credit-orders/${id}/validate`, {
      headers: key(),
    });
    expect(same.status).toBe(403);
    const second = await adminB.call('POST', `/v1/admin/credit-orders/${id}/validate`, {
      headers: key(),
    });
    expect(second.body.status).toBe('VALIDATED');
    expect((second.body.history as { action: string }[]).map((event) => event.action)).toEqual([
      'CREATED',
      'CONFIRMED',
      'TRANSFER_DECLARED',
      'FIRST_VALIDATION',
      'VALIDATED',
    ]);
  });

  it('keeps each company in its own orders (another tenant gets 404)', async () => {
    const first = await setup();
    const created = await first.owner.call('POST', '/v1/company/orders', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 100_000 }] },
      headers: key(),
    });
    const other = await setup();
    expect(
      (await other.owner.call('GET', `/v1/company/orders/${String(created.body.id)}`)).status,
    ).toBe(404);
    const list = await other.owner.call('GET', '/v1/company/orders');
    expect((list.body.data as { id: string }[]).some((order) => order.id === created.body.id)).toBe(
      false,
    );
    // A company cannot reach the admin routes.
    expect((await first.owner.call('GET', '/v1/admin/credit-orders')).status).toBe(403);
  });
});

describe('allocation', () => {
  it('debits only the type allocated and refuses beyond its balance with the missing amount', async () => {
    const { owner, adminA, employee } = await setup();
    const created = await owner.call('POST', '/v1/company/orders', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 300_000 }] },
      headers: key(),
    });
    const id = String(created.body.id);
    await adminA.call('POST', `/v1/admin/credit-orders/${id}/confirm`);
    await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form: declaration('304500'),
      headers: key(),
    });
    await adminA.call('POST', `/v1/admin/credit-orders/${id}/validate`, { headers: key() });

    const ok = await owner.call('POST', '/v1/company/allocations', {
      body: {
        allocations: [
          { employeeId: employee.id, creditType: 'RESTAURATION', amountMillimes: 120_000 },
        ],
      },
      headers: key(),
    });
    expect(ok.status).toBe(201);
    expect(ok.body).toMatchObject({
      allocatedCount: 1,
      allocatedMillimes: 120_000,
      walletBalanceMillimes: 180_000,
    });
    // No transfer between types: CADEAUX has no balance, whatever RESTAURATION holds.
    const otherType = await owner.call('POST', '/v1/company/allocations', {
      body: {
        allocations: [{ employeeId: employee.id, creditType: 'CADEAUX', amountMillimes: 10_000 }],
      },
      headers: key(),
    });
    expect(otherType.body).toMatchObject({
      code: 'INSUFFICIENT_FUNDS',
      details: { missingMillimes: 10_000 },
    });
    const tooMuch = await owner.call('POST', '/v1/company/allocations', {
      body: {
        allocations: [
          { employeeId: employee.id, creditType: 'RESTAURATION', amountMillimes: 200_000 },
        ],
      },
      headers: key(),
    });
    expect(tooMuch.body).toMatchObject({
      code: 'INSUFFICIENT_FUNDS',
      details: { missingMillimes: 20_000 },
    });
    const employees = await owner.call('GET', '/v1/company/employees');
    expect(
      (employees.body.data as { id: string; monthAllocatedMillimes: number }[]).find(
        (row) => row.id === employee.id,
      )?.monthAllocatedMillimes,
    ).toBe(120_000);
  });
});
