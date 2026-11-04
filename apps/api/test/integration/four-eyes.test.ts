// TEST-FIRST (decision of 2026-10-21, securite B5-S02-a): the author of a file or an operation
// never validates it, the super-admin included. Each refusal is audited.
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createUser, sealed, seedSettings, signedIn, oneLineGrid } =
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

const key = () => ({ 'Idempotency-Key': randomUUID() });
type Sub = 'SUPER_ADMIN' | 'FINANCE' | 'COMPLIANCE';
const admin = async (subRole: Sub, name = 'Test A.') => {
  const user = await createUser(db, env, 'ADMIN', {}, name, subRole);
  return { user, client: await signedIn(base, user) };
};
const refusals = (userId: string) =>
  db.system((tx) =>
    tx.auditLog.count({ where: { action: 'fourEyes.refused', actorUserId: userId } }),
  );

describe('four eyes', () => {
  it('the super-admin who created a merchant never validates its KYC file', async () => {
    const author = await admin('SUPER_ADMIN', 'Auteur A.');
    const created = await author.client.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Café ${randomUUID().slice(0, 6)}`,
        category: 'CAFE',
        acceptedCreditTypes: ['RESTAURATION'],
        commissionGrid: [{ rateBps: 200, minMillimes: null, maxMillimes: null }],
        city: 'Tunis',
        phone: '+21671222333',
        email: `kyc-${randomUUID().slice(0, 8)}@exemple.tn`,
      },
    });
    expect(created.status).toBe(201);
    // QY-03 b (securite QY-01): the creator is stored by the API itself, from the session.
    const merchant = await db.system((tx) =>
      tx.merchant.findUniqueOrThrow({ where: { id: String(created.body.id) } }),
    );
    expect(merchant.createdBy).toBe(author.user.id);
    const file = await db.system((tx) =>
      tx.kycFile.findFirstOrThrow({ where: { merchantId: String(created.body.id) } }),
    );
    const own = await author.client.call('POST', `/v1/admin/kyc-files/${file.id}/approve`);
    expect(own.status).toBe(403);
    const ownReject = await author.client.call('POST', `/v1/admin/kyc-files/${file.id}/reject`, {
      body: { reason: 'Pièce illisible' },
    });
    expect(ownReject.status).toBe(403);
    expect(await refusals(author.user.id)).toBe(2);
    const other = await admin('COMPLIANCE', 'Opérations B.');
    expect((await other.client.call('POST', `/v1/admin/kyc-files/${file.id}/approve`)).status).toBe(
      200,
    );
  });

  it('the super-admin who requested a rate change never approves it', async () => {
    const author = await admin('SUPER_ADMIN', 'Auteur C.');
    const company = await db.system((tx) =>
      tx.company.create({
        data: {
          name: `Société ${randomUUID().slice(0, 8)}`,
          city: 'Tunis',
          phone: sealed('+21671000000'),
          email: 'contact@societe.test',
          status: 'APPROVED',
          commissionGrids: { create: { tiers: { create: [{ position: 0, rateBps: 180 }] } } },
        },
      }),
    );
    const requested = await author.client.call(
      'POST',
      '/v1/admin/commission-grids/change-requests',
      {
        body: {
          companyId: company.id,
          tiers: [{ rateBps: 210, minMillimes: null, maxMillimes: null }],
          reason: 'Révision',
        },
      },
    );
    const id = String(requested.body.id);
    expect((await author.client.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(
      403,
    );
    expect(await refusals(author.user.id)).toBe(1);
    const finance = await admin('FINANCE', 'Finance D.');
    expect((await finance.client.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(
      200,
    );
  });

  it('the first validator of a large order never gives the second validation', async () => {
    const companyId = (
      await db.system((tx) =>
        tx.company.create({
          data: {
            name: `Société ${randomUUID().slice(0, 6)}`,
            city: 'Tunis',
            phone: sealed('+21671000000'),
            email: 'rh@societe.tn',
            status: 'APPROVED',
            commissionGrids: oneLineGrid(150),
          },
        }),
      )
    ).id;
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId }, 'Leïla M.', 'OWNER'),
    );
    const created = await owner.call('POST', '/v1/company/orders', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 12_000_000 }] },
      headers: key(),
    });
    const id = String(created.body.id);
    // Finance confirms the order (decision C); a third administrator confirms here.
    const confirmer = await admin('FINANCE', 'Finance E.');
    await confirmer.client.call('POST', `/v1/admin/credit-orders/${id}/confirm`);
    const form = new FormData();
    form.set('transferReference', 'BIAT-4E');
    form.set('transferDate', new Date().toISOString().slice(0, 10));
    form.set('amountMillimes', String(created.body.totalMillimes));
    form.set(
      'proof',
      new Blob([
        Buffer.from(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
          'base64',
        ),
      ]),
      'avis.png',
    );
    await owner.call('POST', `/v1/company/orders/${id}/transfer-declarations`, {
      form,
      headers: key(),
    });
    const first = await admin('FINANCE', 'Finance F.');
    const firstCall = await first.client.call('POST', `/v1/admin/credit-orders/${id}/validate`, {
      headers: key(),
    });
    expect(firstCall.status).toBe(200);
    const second = await first.client.call('POST', `/v1/admin/credit-orders/${id}/validate`, {
      headers: key(),
    });
    expect(second.status).toBe(403);
    expect(await refusals(first.user.id)).toBe(1);
    // Another administrator gives the second validation.
    const other = await admin('FINANCE', 'Finance J.');
    const done = await other.client.call('POST', `/v1/admin/credit-orders/${id}/validate`, {
      headers: key(),
    });
    expect(done.body.status).toBe('VALIDATED');
  });

  it('a KYC file always names its author (database constraint, migration 0013)', async () => {
    const company = await db.system((tx) =>
      tx.company.create({
        data: {
          name: `Société ${randomUUID().slice(0, 6)}`,
          city: 'Tunis',
          phone: sealed('+21671000000'),
          email: 'rh@societe.tn',
        },
      }),
    );
    // Without an author the four eyes could not be checked: the file cannot even be written (the
    // API also refuses to decide an older file without author, fail closed).
    await expect(
      db.system((tx) =>
        tx.kycFile.create({
          data: { accountType: 'COMPANY', companyId: company.id, status: 'PENDING' },
        }),
      ),
    ).rejects.toThrow();
  });

  it('the super-admin who requested a settings change never approves it', async () => {
    const author = await admin('SUPER_ADMIN', 'Auteur H.');
    const current = await author.client.call('GET', '/v1/admin/settings');
    const requested = await author.client.call('PUT', '/v1/admin/settings', {
      body: { settings: { ...current.body, maxFamilyMembers: 3 }, reason: 'Test' },
    });
    expect(requested.status).toBe(202);
    const id = String(requested.body.id);
    expect((await author.client.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(
      403,
    );
    // Withdrawn by another administrator so that no settings change stays pending.
    const other = await admin('FINANCE', 'Finance I.');
    expect(
      (
        await other.client.call('POST', `/v1/admin/approvals/${id}/reject`, {
          body: { reason: 'Test' },
        })
      ).status,
    ).toBe(200);
  });
});
