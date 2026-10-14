// Administration over HTTP: KYC activation, four-eyes approvals, settings, contact messages, audit.
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { WebClient, listen } from './http.js';

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
  await db.system((tx) =>
    tx.commissionProfile.upsert({
      where: { name: 'Standard' },
      create: { name: 'Standard', rateBps: 250 },
      update: {},
    }),
  );
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

const admins = async () => ({
  first: await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.')),
  second: await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.')),
});

describe('accounts and KYC', () => {
  it('creates a merchant inactive until its KYC file is approved', async () => {
    const { first } = await admins();
    const profiles = await first.call('GET', '/v1/admin/commission-profiles');
    const profileId = (profiles.body.data as { id: string }[])[0]?.id;
    const created = await first.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Boulangerie ${String(Date.now())}`,
        category: 'BAKERY',
        city: 'Sousse',
        phone: '+21673000000',
        email: 'pain@test.tn',
        commissionProfileId: profileId,
        acceptedCreditTypes: ['RESTAURATION'],
      },
    });
    expect(created.status).toBe(201);
    expect(created.body).toMatchObject({
      status: 'PENDING_KYC',
      acceptedCreditTypes: ['RESTAURATION'],
    });
    const files = await first.call('GET', '/v1/admin/kyc-files?status=PENDING');
    const file = (files.body.data as { id: string; accountId: string }[]).find(
      (item) => item.accountId === created.body.id,
    );
    expect(file).toBeDefined();
    const empty = await first.call('POST', `/v1/admin/kyc-files/${file?.id ?? ''}/reject`, {
      body: { reason: '' },
    });
    expect(empty.status).toBe(400);
    const approved = await first.call('POST', `/v1/admin/kyc-files/${file?.id ?? ''}/approve`);
    expect(approved.body).toMatchObject({ status: 'APPROVED' });
    expect((approved.body.history as { action: string }[]).map((event) => event.action)).toEqual([
      'SUBMITTED',
      'APPROVED',
    ]);
    expect(
      (await first.call('GET', `/v1/admin/merchants/${String(created.body.id)}`)).body.status,
    ).toBe('APPROVED');
    expect((await first.call('POST', `/v1/admin/kyc-files/${file?.id ?? ''}/approve`)).status).toBe(
      409,
    );
    const types = await first.call(
      'PUT',
      `/v1/admin/merchants/${String(created.body.id)}/credit-types`,
      { body: { acceptedCreditTypes: ['RESTAURATION', 'CADEAUX'] } },
    );
    expect(types.body.acceptedCreditTypes).toEqual(['RESTAURATION', 'CADEAUX']);
  });
});

describe('four-eyes approvals', () => {
  it('applies a commission change only when another administrator approves it', async () => {
    const { first, second } = await admins();
    const profiles = await first.call('GET', '/v1/admin/commission-profiles');
    const profile = (profiles.body.data as { id: string; rateBps: number }[])[0];
    const requested = await first.call(
      'POST',
      `/v1/admin/commission-profiles/${profile?.id ?? ''}/change-requests`,
      { body: { newRateBps: 275, reason: 'Révision annuelle' } },
    );
    expect(requested.status).toBe(201);
    expect(requested.body).toMatchObject({
      status: 'PENDING',
      initiatedByMe: true,
      oldRateBps: profile?.rateBps,
      newRateBps: 275,
    });
    const id = String(requested.body.id);
    expect((await first.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(403);
    expect((await second.call('POST', `/v1/admin/approvals/${id}/approve`)).body.status).toBe(
      'APPROVED',
    );
    const after = await first.call('GET', '/v1/admin/commission-profiles');
    expect(
      (after.body.data as { id: string; rateBps: number }[]).find((item) => item.id === profile?.id)
        ?.rateBps,
    ).toBe(275);
  });

  it('applies a settings change after approval (202 = request only)', async () => {
    const { first, second } = await admins();
    const current = await first.call('GET', '/v1/admin/settings');
    const settings = { ...current.body, orderFeeRateBps: 175 };
    const requested = await first.call('PUT', '/v1/admin/settings', {
      body: { settings, reason: 'Nouvelle grille' },
    });
    expect(requested.status).toBe(202);
    expect((await first.call('GET', '/v1/admin/settings')).body.orderFeeRateBps).toBe(
      current.body.orderFeeRateBps,
    );
    expect(
      (await first.call('PUT', '/v1/admin/settings', { body: { settings, reason: 'Encore' } }))
        .status,
    ).toBe(409);
    await second.call('POST', `/v1/admin/approvals/${String(requested.body.id)}/approve`);
    expect((await first.call('GET', '/v1/admin/settings')).body.orderFeeRateBps).toBe(175);
    const audit = await first.call('GET', '/v1/admin/audit-logs?q=approvals');
    expect(
      (audit.body.data as { action: string }[]).some(
        (entry) => entry.action === 'approvals.approve',
      ),
    ).toBe(true);
  });
});

describe('contact messages', () => {
  it('receives a public message and lets an administrator handle it', async () => {
    const visitor = new WebClient(base);
    const sent = await visitor.call('POST', '/v1/public/contact-messages', {
      body: {
        name: 'Mehdi Jlassi',
        email: 'mehdi@cafe.tn',
        phone: '+21698765432',
        requesterType: 'MERCHANT',
        message: 'Je voudrais accepter FlexiPay à Sousse.',
      },
    });
    expect(sent.status).toBe(202);
    expect(String(sent.body.reference)).toMatch(/^MSG-\d+$/);
    const invalid = await visitor.call('POST', '/v1/public/contact-messages', {
      body: { name: 'M', email: 'x', requesterType: 'OTHER', message: 'court' },
    });
    expect(invalid.status).toBe(400);
    const { first } = await admins();
    const list = await first.call('GET', '/v1/admin/contact-messages?status=NEW');
    const message = (list.body.data as { id: string; reference: string }[]).find(
      (item) => item.reference === sent.body.reference,
    );
    const handled = await first.call(
      'POST',
      `/v1/admin/contact-messages/${message?.id ?? ''}/handle`,
      { body: { note: 'Rappelé.' } },
    );
    expect(handled.body).toMatchObject({
      status: 'HANDLED',
      handledBy: 'Amine K.',
      note: 'Rappelé.',
    });
  });
});

describe('access', () => {
  it('refuses the admin routes to a company user', async () => {
    const company = await createCompany(db);
    const user = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: company.id }),
    );
    expect((await user.call('GET', '/v1/admin/dashboard')).status).toBe(403);
    expect((await user.call('GET', '/v1/admin/kyc-files')).status).toBe(403);
  });
});
