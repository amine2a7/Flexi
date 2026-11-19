// Administration over HTTP: KYC activation, four-eyes approvals, settings, contact messages, audit.
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { WebClient, listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const {
  createCompany,
  createUser,
  seedSettings,
  signedIn,
  createEmployee,
  sealed,
  fileKycDocuments,
} = await import('./fixtures.js');
const { SettingsService } = await import('../../src/platform/settings.service.js');

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

const tier = (rateBps: number, minMillimes: number | null, maxMillimes: number | null) => ({
  rateBps,
  minMillimes,
  maxMillimes,
});
/** Default 5 %, 4 % up to 14 999,999 TND, 3 % from 15 000 to 18 000 TND (bounds included). */
const GRID = [tier(500, null, null), tier(400, 0, 14_999_999), tier(300, 15_000_000, 18_000_000)];

/** Two administrators signed in once for the file (30 sign-ins per minute, src/common/http.ts). */
let signedAdmins: Promise<{ first: WebClient; second: WebClient }> | undefined;
const admins = () =>
  (signedAdmins ??= (async () => ({
    first: await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.')),
    second: await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Hela R.')),
  }))());

describe('accounts and KYC', () => {
  it('creates a merchant inactive until its KYC file is approved (by another administrator)', async () => {
    const { first, second } = await admins();
    const created = await first.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Boulangerie ${String(Date.now())}`,
        category: 'BAKERY',
        city: 'Sousse',
        phone: '+21673000000',
        email: 'pain@test.tn',
        legalForm: 'PM_MF',
        commissionGrid: GRID,
        acceptedCreditTypes: ['RESTAURATION'],
      },
    });
    expect(created.status).toBe(201);
    expect(created.body).toMatchObject({
      status: 'PENDING_KYC',
      acceptedCreditTypes: ['RESTAURATION'],
      commissionGrid: { tiers: GRID },
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
    await fileKycDocuments(db, file?.id ?? '');
    const approved = await second.call('POST', `/v1/admin/kyc-files/${file?.id ?? ''}/approve`);
    expect(approved.body).toMatchObject({ status: 'APPROVED' });
    expect((approved.body.history as { action: string }[]).map((event) => event.action)).toEqual([
      'SUBMITTED',
      'APPROVED',
    ]);
    expect(
      (await first.call('GET', `/v1/admin/merchants/${String(created.body.id)}`)).body.status,
    ).toBe('APPROVED');
    expect(
      (await second.call('POST', `/v1/admin/kyc-files/${file?.id ?? ''}/approve`)).status,
    ).toBe(409);
    const types = await first.call(
      'PUT',
      `/v1/admin/merchants/${String(created.body.id)}/credit-types`,
      { body: { acceptedCreditTypes: ['RESTAURATION', 'CADEAUX'] } },
    );
    expect(types.body.acceptedCreditTypes).toEqual(['RESTAURATION', 'CADEAUX']);
  });
});

describe('commission grids', () => {
  const company = (grid: unknown) => ({
    name: `Société ${String(Date.now())}-${String(Math.random()).slice(2, 6)}`,
    city: 'Tunis',
    phone: '+21671000001',
    email: `rh-${String(Math.random()).slice(2, 10)}@societe.tn`,
    legalForm: 'PM_MF',
    commissionGrid: grid,
  });

  it('a company is created with its grid', async () => {
    const { first } = await admins();
    const created = await first.call('POST', '/v1/admin/companies', { body: company(GRID) });
    expect(created.status).toBe(201);
    expect(created.body).toMatchObject({ commissionGrid: { tiers: GRID }, legalForm: 'PM_MF' });
    // The temporary password of the owner is shown once to the administrator (processus v2).
    const credentials = created.body.credentials as { temporaryPassword?: unknown } | undefined;
    expect(typeof credentials?.temporaryPassword).toBe('string');
    // The legal form is required (processus v2): it drives the withholding tax.
    const refused = await first.call('POST', '/v1/admin/companies', {
      body: { ...company(GRID), legalForm: undefined },
    });
    expect(refused.status).toBe(400);
    expect(refused.body.details).toMatchObject({ fields: [{ pointer: '/legalForm' }] });
  });

  it.each([
    [
      'overlapping tranches',
      [...GRID, tier(250, 16_000_000, 20_000_000)],
      '/commissionGrid/3',
      'GRID_OVERLAP',
    ],
    ['no default line', [tier(300, 0, 1_000_000)], '/commissionGrid', 'GRID_DEFAULT_REQUIRED'],
    [
      'two default lines',
      [...GRID, tier(100, null, null)],
      '/commissionGrid/3',
      'GRID_DEFAULT_DUPLICATE',
    ],
    [
      'min above max',
      [tier(500, null, null), tier(300, 5_001, 5_000)],
      '/commissionGrid/1',
      'GRID_BOUNDS',
    ],
    [
      'a shared bound',
      [...GRID.slice(0, 2), tier(300, 14_999_999, 18_000_000)],
      '/commissionGrid/2',
      'GRID_OVERLAP',
    ],
    ['no grid at all', undefined, '/commissionGrid', 'REQUIRED'],
  ])('refuses %s with a clear field error', async (_label, grid, pointer, code) => {
    const { first } = await admins();
    const refused = await first.call('POST', '/v1/admin/companies', { body: company(grid) });
    expect(refused.status).toBe(400);
    expect(refused.body.details).toMatchObject({ fields: [{ pointer, code }] });
  });

  it('a grid change applies only when another administrator approves it, as a new version', async () => {
    const { first, second } = await admins();
    const created = await first.call('POST', '/v1/admin/companies', { body: company(GRID) });
    const companyId = String(created.body.id);
    const proposed = [tier(450, null, null)];
    const requested = await first.call('POST', '/v1/admin/commission-grids/change-requests', {
      body: { companyId, tiers: proposed, reason: 'Révision annuelle' },
    });
    expect(requested.status).toBe(201);
    expect(requested.body).toMatchObject({
      type: 'COMMISSION_GRID_CHANGE',
      status: 'PENDING',
      initiatedByMe: true,
      commissionGrid: { previous: GRID, proposed },
    });
    const again = await second.call('POST', '/v1/admin/commission-grids/change-requests', {
      body: { companyId, tiers: proposed, reason: 'Doublon' },
    });
    expect(again.status).toBe(409);
    const id = String(requested.body.id);
    expect((await first.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(403);
    expect((await second.call('POST', `/v1/admin/approvals/${id}/approve`)).body.status).toBe(
      'APPROVED',
    );
    const list = await first.call(
      'GET',
      `/v1/admin/companies?q=${encodeURIComponent(String(created.body.name))}`,
    );
    expect((list.body.data as { commissionGrid: unknown }[])[0]?.commissionGrid).toMatchObject({
      tiers: proposed,
    });
    const versions = await db.system((tx) => tx.commissionGrid.count({ where: { companyId } }));
    expect(versions).toBe(2);
  });

  it('a grid change request is validated like a creation', async () => {
    const { first } = await admins();
    const created = await first.call('POST', '/v1/admin/companies', { body: company(GRID) });
    const refused = await first.call('POST', '/v1/admin/commission-grids/change-requests', {
      body: { companyId: created.body.id, tiers: [tier(300, 0, 1_000)], reason: 'Essai' },
    });
    expect(refused.status).toBe(400);
    const unknown = await first.call('POST', '/v1/admin/commission-grids/change-requests', {
      body: { merchantId: '0193a000-0000-7000-8000-000000000000', tiers: GRID, reason: 'Essai' },
    });
    expect(unknown.status).toBe(404);
  });
});

describe('grid rules of 2026-11-04', () => {
  it('a beneficiary never reads the grid of a shop (row security)', async () => {
    const { first } = await admins();
    const shop = await first.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Épicerie ${String(Date.now())}`,
        category: 'GROCERY',
        city: 'Sfax',
        phone: '+21674000000',
        email: `epicerie-${String(Math.random()).slice(2, 10)}@test.tn`,
        legalForm: 'PM_MF',
        commissionGrid: GRID,
        acceptedCreditTypes: ['RESTAURATION'],
      },
    });
    const merchantId = String(shop.body.id);
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const seen = await db.run({ role: 'EMPLOYEE', employeeId: employee.id }, async (tx) => ({
      grids: await tx.commissionGrid.findMany({ where: { merchantId } }),
      tiers: await tx.commissionTier.findMany({ where: { grid: { merchantId } } }),
    }));
    expect(seen).toEqual({ grids: [], tiers: [] });
    // The server computes the rate for the payment under its internal service role.
    const rate = await db.run({ role: 'EMPLOYEE', employeeId: employee.id }, (tx) =>
      app.get(SettingsService).commissionRate(tx, { merchantId }, 16_000_000n),
    );
    expect(rate).toBe(300);
    const after = await db.run({ role: 'EMPLOYEE', employeeId: employee.id }, (tx) =>
      tx.commissionGrid.findMany({ where: { merchantId } }),
    );
    expect(after).toEqual([]);
  });

  it('the beneficiary role comes back in the same transaction, after a rate and after a refusal', async () => {
    const { first } = await admins();
    const shop = await first.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Kiosque ${String(Date.now())}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: '+21671000002',
        email: `kiosque-${String(Math.random()).slice(2, 10)}@test.tn`,
        legalForm: 'PM_MF',
        commissionGrid: GRID,
        acceptedCreditTypes: ['RESTAURATION'],
      },
    });
    const merchantId = String(shop.body.id);
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const role = (tx: Parameters<Parameters<typeof db.system>[0]>[0]) =>
      tx.$queryRaw<{ role: string }[]>`SELECT current_setting('app.role', true) AS role`;
    const seen = await db.run({ role: 'EMPLOYEE', employeeId: employee.id }, async (tx) => {
      const rate = await app.get(SettingsService).commissionRate(tx, { merchantId }, 1_000_000n);
      const afterRate = (await role(tx))[0]?.role;
      const refused = await app
        .get(SettingsService)
        .commissionRate(tx, { merchantId: '0193a000-0000-7000-8000-00000000abcd' }, 1_000n)
        .catch((error: unknown) => (error as { code?: string }).code);
      return {
        rate,
        afterRate,
        refused,
        afterRefusal: (await role(tx))[0]?.role,
        grids: await tx.commissionGrid.count(),
      };
    });
    expect(seen).toEqual({
      rate: 400,
      afterRate: 'EMPLOYEE',
      refused: 'COMMISSION_GRID_MISSING',
      afterRefusal: 'EMPLOYEE',
      grids: 0,
    });
  });

  it('a company or a shop reads its own grid only, never another one, and never writes', async () => {
    const a = await createCompany(db);
    const b = await createCompany(db);
    const own = await db.run({ role: 'COMPANY', companyId: a.id }, (tx) =>
      tx.commissionGrid.findMany({ where: { companyId: { in: [a.id, b.id] } } }),
    );
    expect(own.map((grid) => grid.companyId)).toEqual([a.id]);
    await expect(
      db.run({ role: 'COMPANY', companyId: b.id }, (tx) =>
        tx.commissionGrid.create({
          data: { companyId: b.id, tiers: { create: [{ position: 0, rateBps: 0 }] } },
        }),
      ),
    ).rejects.toThrow();
    const shops = await db.run(
      { role: 'MERCHANT', merchantId: '0193a000-0000-7000-8000-00000000abcd' },
      (tx) => tx.commissionGrid.findMany({ where: { companyId: a.id } }),
    );
    expect(shops).toEqual([]);
  });

  it('two simultaneous change requests for one grid: one is created, the other refused', async () => {
    const { first, second } = await admins();
    const company = await createCompany(db);
    const body = { companyId: company.id, tiers: [tier(420, null, null)], reason: 'Révision' };
    const results = await Promise.all([
      first.call('POST', '/v1/admin/commission-grids/change-requests', { body }),
      second.call('POST', '/v1/admin/commission-grids/change-requests', { body }),
    ]);
    expect(results.map((result) => result.status).sort()).toEqual([201, 409]);
  });

  it('support reads the accounts without their commission grids (S-GC-04)', async () => {
    const support = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Sami S.', 'SUPPORT'),
    );
    const list = await support.call('GET', '/v1/admin/companies');
    expect(list.status).toBe(200);
    expect(
      (list.body.data as { commissionGrid: unknown }[]).every((row) => row.commissionGrid === null),
    ).toBe(true);
  });

  it('without a grid the operation is refused and Opérations and Finance are told', async () => {
    const orphan = await db.system((tx) =>
      tx.merchant.create({
        data: {
          name: `Sans grille ${String(Date.now())}`,
          category: 'CAFE',
          city: 'Tunis',
          phone: sealed('+21671000009'),
          email: 'sans-grille@test.tn',
          status: 'APPROVED',
          acceptedCreditTypes: ['RESTAURATION'],
          paymentCode: String(100_000 + Math.floor(Math.random() * 899_999)),
        },
      }),
    );
    await expect(
      db.system((tx) =>
        app.get(SettingsService).commissionRate(tx, { merchantId: orphan.id }, 20_000n),
      ),
    ).rejects.toMatchObject({ status: 422, code: 'COMMISSION_GRID_MISSING' });
    const alert = await db.system((tx) =>
      tx.fraudAlert.findFirst({
        where: { kind: 'COMMISSION_GRID_MISSING', subjectKey: orphan.id },
      }),
    );
    expect(alert).toMatchObject({ subject: orphan.name, severity: 'HIGH', status: 'OPEN' });
    const audit = await db.system((tx) =>
      tx.auditLog.findFirst({ where: { action: 'commissions.gridMissing', target: orphan.name } }),
    );
    expect(audit).not.toBeNull();
  });
});

describe('records editable at any time (decision of 2026-11-03)', () => {
  const shop = async (client: WebClient) => {
    const created = await client.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Fiche ${String(Date.now())}`,
        category: 'CAFE',
        city: 'Tunis',
        phone: '+21671000003',
        email: `fiche-${String(Math.random()).slice(2, 10)}@test.tn`,
        legalForm: 'PM_MF',
        commissionGrid: GRID,
        acceptedCreditTypes: ['RESTAURATION'],
      },
    });
    return String(created.body.id);
  };

  it('the administrator changes the information; the history names the fields, never the values', async () => {
    const { first } = await admins();
    const merchantId = await shop(first);
    const updated = await first.call('PATCH', `/v1/admin/merchants/${merchantId}`, {
      body: { city: 'Sousse', phone: '+21673000099', reason: 'Déménagement' },
    });
    expect(updated.status).toBe(200);
    expect(updated.body).toMatchObject({ city: 'Sousse', phone: '+21673000099' });
    expect(updated.body.history).toEqual([
      expect.objectContaining({
        fields: ['city', 'phone'],
        reason: 'Déménagement',
        actorName: 'Amine K.',
      }),
    ]);
    expect(JSON.stringify(updated.body.history)).not.toContain('21673000099');
    const company = await createCompany(db);
    const renamed = await first.call('PATCH', `/v1/admin/companies/${company.id}`, {
      body: { name: `Renommée ${String(Date.now())}` },
    });
    expect(renamed.body.history).toEqual([expect.objectContaining({ fields: ['name'] })]);
  });

  it('a RIB change applies only when another administrator approves it', async () => {
    const { first, second } = await admins();
    const merchantId = await shop(first);
    const iban = 'TN5901234567890123456789';
    const requested = await first.call(
      'POST',
      `/v1/admin/merchants/${merchantId}/iban-change-requests`,
      {
        body: { iban, reason: 'Nouveau compte bancaire' },
      },
    );
    expect(requested.status).toBe(201);
    expect(requested.body).toMatchObject({ type: 'IBAN_CHANGE', maskedIban: '••••6789' });
    expect(JSON.stringify(requested.body)).not.toContain(iban);
    const again = await second.call(
      'POST',
      `/v1/admin/merchants/${merchantId}/iban-change-requests`,
      {
        body: { iban, reason: 'Doublon' },
      },
    );
    expect(again.status).toBe(409);
    const record = await first.call('GET', `/v1/admin/merchants/${merchantId}/record`);
    expect(record.body.requests).toHaveLength(1);
    const id = String(requested.body.id);
    expect((await first.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(403);
    expect((await second.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(200);
    const after = await first.call('GET', `/v1/admin/merchants/${merchantId}/record`);
    expect(after.body).toMatchObject({ maskedIban: '••••6789', requests: [] });
    expect((after.body.history as { fields: string[] }[])[0]?.fields).toEqual(['iban']);
    const refused = await first.call(
      'POST',
      `/v1/admin/merchants/${merchantId}/iban-change-requests`,
      {
        body: { iban: 'FR7612345', reason: 'Essai' },
      },
    );
    expect(refused.status).toBe(400);
  });

  it('support reads a record without the phone nor the grid', async () => {
    const { first } = await admins();
    const merchantId = await shop(first);
    const support = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Sami S.', 'SUPPORT'),
    );
    const record = await support.call('GET', `/v1/admin/merchants/${merchantId}/record`);
    expect(record.status).toBe(200);
    expect(record.body).toMatchObject({ phone: null, commissionGrid: null, gridVersions: [] });
    expect(
      (
        await support.call('PATCH', `/v1/admin/merchants/${merchantId}`, {
          body: { city: 'Nabeul' },
        })
      ).status,
    ).toBe(403);
  });
});

describe('four-eyes approvals', () => {
  it('applies a settings change after approval (202 = request only)', async () => {
    const { first, second } = await admins();
    const current = await first.call('GET', '/v1/admin/settings');
    expect(current.body.expiredCreditsDestination).toBe('PLATFORM_REVENUE');
    const settings = {
      ...current.body,
      orderFeeRateBps: 175,
      expiredCreditsDestination: 'COMPANY_RETURN',
    };
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
    expect((await first.call('GET', '/v1/admin/settings')).body).toMatchObject({
      orderFeeRateBps: 175,
      expiredCreditsDestination: 'COMPANY_RETURN',
    });
    const audit = await first.call('GET', '/v1/admin/audit-logs?q=approvals');
    expect(
      (audit.body.data as { action: string }[]).some(
        (entry) => entry.action === 'approvals.approve',
      ),
    ).toBe(true);
    // Settings are global to the test database: the other test files expect the defaults.
    await db.system((tx) =>
      tx.platformSettings.update({
        where: { id: 1 },
        data: { orderFeeRateBps: 150, expiredCreditsDestination: 'PLATFORM_REVENUE' },
      }),
    );
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
