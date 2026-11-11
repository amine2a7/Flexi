// Processus v2, « Fiche client complète »: the tabs of a company record, and the legal form
// changed in four eyes (applied by another administrator, to the next operations only).
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

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

describe('full client record', () => {
  it('shows each tab of a company and changes its legal form in four eyes', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const author = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    const support = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Karim T.', 'SUPPORT'),
    );
    const finance = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Sarra F.', 'FINANCE'),
    );

    const overview = await support.call('GET', `/v1/admin/companies/${company.id}/overview`);
    expect(overview.status).toBe(200);
    expect(overview.body).toMatchObject({ employeeCount: 1, orders: [], invoices: [] });
    expect((overview.body.employees as { id: string }[])[0]?.id).toBe(employee.id);
    expect((overview.body.balances as unknown[]).length).toBe(4);

    // Support reads, never requests; the author requests, never approves; Finance approves.
    expect(
      (
        await support.call('POST', `/v1/admin/companies/${company.id}/legal-form-change-requests`, {
          body: { legalForm: 'PP_CIN', reason: 'Erreur à la création' },
        })
      ).status,
    ).toBe(403);
    const request = await author.call(
      'POST',
      `/v1/admin/companies/${company.id}/legal-form-change-requests`,
      { body: { legalForm: 'PP_CIN', reason: 'Erreur à la création' } },
    );
    expect(request.status).toBe(201);
    expect(request.body).toMatchObject({
      type: 'LEGAL_FORM_CHANGE',
      legalFormChange: { previous: 'PM_MF', proposed: 'PP_CIN' },
    });
    const again = await author.call(
      'POST',
      `/v1/admin/companies/${company.id}/legal-form-change-requests`,
      { body: { legalForm: 'PP_MF', reason: 'Encore' } },
    );
    expect(again.status).toBe(409);
    const id = String(request.body.id);
    expect((await author.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(403);
    expect((await finance.call('POST', `/v1/admin/approvals/${id}/approve`)).status).toBe(200);
    const record = await author.call('GET', `/v1/admin/companies/${company.id}/record`);
    expect(record.body.legalForm).toBe('PP_CIN');
    expect((record.body.history as { fields: string[] }[])[0]?.fields).toEqual(['legalForm']);
  });
});
