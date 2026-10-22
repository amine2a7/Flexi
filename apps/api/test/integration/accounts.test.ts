// TEST-FIRST: creating an employee, a merchant or a company creates its sign-in account and sends
// an invitation (temporary password, 72 h), through the local outbox for now (decision 2026-10-14).
import { randomUUID } from 'node:crypto';
import { readdir, readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { appClient, loadTestEnv } from './setup.js';
import { listen, WebClient } from './http.js';

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
const NEW_PASSWORD = 'Jasmin-du-Cap-Bon-2026'; // gitleaks:allow (test-only value)
const OUTBOX = join(env.uploadDir, '..', 'outbox');

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

/** Invitation written to the local outbox for `email` (the most recent one). */
async function invitationTo(email: string): Promise<{ text: string; password: string }> {
  const files = (await readdir(OUTBOX)).sort().reverse();
  for (const file of files) {
    const text = await readFile(join(OUTBOX, file), 'utf8');
    if (!text.includes(`To: ${email}`)) continue;
    const password = /Mot de passe temporaire : (\S+)/.exec(text)?.[1];
    if (password === undefined) throw new Error('invitation without temporary password');
    return { text, password };
  }
  throw new Error(`no invitation for ${email}`);
}

/** Latest message written to the local outbox for `email`. */
async function messageTo(email: string): Promise<string> {
  const files = (await readdir(OUTBOX)).sort().reverse();
  for (const file of files) {
    const text = await readFile(join(OUTBOX, file), 'utf8');
    if (text.includes(`To: ${email}`)) return text;
  }
  throw new Error(`no message for ${email}`);
}

const unique = (prefix: string) => `${prefix}-${randomUUID().slice(0, 8)}@exemple.tn`;

async function companyOwner() {
  const company = await createCompany(db);
  const owner = await signedIn(
    base,
    await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.'),
  );
  return { company, owner };
}

describe('sign-in accounts created with their owner', () => {
  it('invites an employee, who signs in with the temporary password and becomes active', async () => {
    const { owner } = await companyOwner();
    const email = unique('nour.trabelsi');
    const created = await owner.call('POST', '/v1/company/employees', {
      body: {
        employeeNumber: `E-${randomUUID().slice(0, 6)}`,
        firstName: 'Nour',
        lastName: 'Trabelsi',
        email,
        phone: '+21698111222',
      },
    });
    expect(created.status).toBe(201);
    expect(created.body.status).toBe('INVITED');

    const user = await db.system((tx) => tx.user.findUnique({ where: { email } }));
    expect(user).toMatchObject({
      role: 'EMPLOYEE',
      employeeId: created.body.id,
      mustChangePassword: true,
      mfaSecretEnc: null,
    });
    const hours = ((user?.tempPasswordExpiresAt?.getTime() ?? 0) - Date.now()) / 3_600_000;
    expect(hours).toBeGreaterThan(71);
    expect(hours).toBeLessThanOrEqual(72);

    const invitation = await invitationTo(email);
    expect(invitation.text).toContain('/fr/login');
    // Never stored in clear: the hash only.
    expect(user?.passwordHash).toMatch(/^\$argon2id\$/);
    expect(user?.passwordHash).not.toContain(invitation.password);

    const client = new WebClient(base);
    const login = await client.call('POST', '/v1/auth/login', {
      body: { identifier: email, password: invitation.password },
    });
    expect(login.body.nextStep).toBe('PASSWORD_CHANGE');
    const changed = await client.call('POST', '/v1/auth/password/change', {
      body: { newPassword: NEW_PASSWORD },
    });
    expect(changed.status).toBe(200);
    const employees = await owner.call('GET', '/v1/company/employees');
    const row = (employees.body.data as { id: string; status: string }[]).find(
      (item) => item.id === created.body.id,
    );
    expect(row?.status).toBe('ACTIVE');
  });

  it('invites every employee of a confirmed import', async () => {
    const { owner } = await companyOwner();
    const first = unique('sami.gharbi');
    const second = unique('rim.haddad');
    const csv = [
      'matricule;prenom;nom;email;telephone',
      `I-${randomUUID().slice(0, 5)};Sami;Gharbi;${first};+21620000001`,
      `I-${randomUUID().slice(0, 5)};Rim;Haddad;${second};+21620000002`,
    ].join('\n');
    const preview = await owner.call('POST', '/v1/company/employees/import-previews', {
      body: { csv },
    });
    expect(preview.body.validCount).toBe(2);
    const imported = await owner.call('POST', '/v1/company/employees/imports', {
      body: { previewId: preview.body.previewId },
    });
    expect(imported.body.createdCount).toBe(2);
    for (const email of [first, second]) {
      const user = await db.system((tx) => tx.user.findUnique({ where: { email } }));
      expect(user).toMatchObject({ role: 'EMPLOYEE', mustChangePassword: true });
      expect((await invitationTo(email)).password.length).toBeGreaterThanOrEqual(12);
    }
  });

  it('invites the owner of a new merchant and of a new company', async () => {
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
    const merchantEmail = unique('contact.cafe');
    const merchant = await admin.call('POST', '/v1/admin/merchants', {
      body: {
        name: `Café ${randomUUID().slice(0, 6)}`,
        category: 'CAFE',
        acceptedCreditTypes: ['RESTAURATION'],
        city: 'Tunis',
        phone: '+21671222333',
        email: merchantEmail,
      },
    });
    expect(merchant.status).toBe(201);
    expect(merchant.body.commissionProfile).toBeNull();
    expect(
      await db.system((tx) => tx.user.findUnique({ where: { email: merchantEmail } })),
    ).toMatchObject({
      role: 'MERCHANT',
      subRole: 'OWNER',
      merchantId: merchant.body.id,
      mustChangePassword: true,
    });
    await invitationTo(merchantEmail);

    const companyEmail = unique('rh.societe');
    const company = await admin.call('POST', '/v1/admin/companies', {
      body: {
        name: `Société ${randomUUID().slice(0, 6)}`,
        city: 'Sfax',
        phone: '+21674111222',
        email: companyEmail,
      },
    });
    expect(company.status).toBe(201);
    expect(
      await db.system((tx) => tx.user.findUnique({ where: { email: companyEmail } })),
    ).toMatchObject({ role: 'COMPANY', subRole: 'OWNER', companyId: company.body.id });
    await invitationTo(companyEmail);
  });

  // securite B5-S04: a company never learns whether an address signs in elsewhere (any tenant,
  // administrators included). Same answer as a fresh address; no account is created, and the
  // holder of the address is told that someone tried to register it.
  it('answers as for a fresh address when the e-mail already signs in elsewhere', async () => {
    const { owner } = await companyOwner();
    const taken = await createUser(db, env, 'ADMIN', {}, 'Hela R.');
    const employee = (email: string) => ({
      employeeNumber: `E-${randomUUID().slice(0, 6)}`,
      firstName: 'Ines',
      lastName: 'Ayari',
      email,
      phone: '+21698333444',
    });
    const fresh = await owner.call('POST', '/v1/company/employees', {
      body: employee(unique('ines.ayari')),
    });
    const created = await owner.call('POST', '/v1/company/employees', {
      body: employee(taken.email.toUpperCase()),
    });
    expect(created.status).toBe(fresh.status);
    expect(Object.keys(created.body).sort()).toEqual(Object.keys(fresh.body).sort());
    expect(created.body.status).toBe(fresh.body.status);
    const account = await db.system((tx) => tx.user.findUnique({ where: { email: taken.email } }));
    expect(account).toMatchObject({ id: taken.id, role: 'ADMIN', employeeId: null });
    const notice = await messageTo(taken.email);
    expect(notice).not.toContain('Mot de passe temporaire');
    expect(notice).toContain('déjà un compte');
  });

  it('never flags in an import an address that signs in elsewhere', async () => {
    const { owner } = await companyOwner();
    const taken = await createUser(db, env, 'ADMIN', {}, 'Mehdi S.');
    const fresh = unique('sami.gharbi');
    const csv = [
      'matricule;prenom;nom;email;telephone',
      `I-${randomUUID().slice(0, 5)};Sami;Gharbi;${fresh};+21620000001`,
      `I-${randomUUID().slice(0, 5)};Mehdi;Saidi;${taken.email};+21620000002`,
    ].join('\n');
    const preview = await owner.call('POST', '/v1/company/employees/import-previews', {
      body: { csv },
    });
    expect(preview.body).toMatchObject({ validCount: 2, errorCount: 0, duplicateCount: 0 });
    const imported = await owner.call('POST', '/v1/company/employees/imports', {
      body: { previewId: preview.body.previewId },
    });
    expect(imported.body.createdCount).toBe(2);
    expect(
      await db.system((tx) => tx.user.findUnique({ where: { email: taken.email } })),
    ).toMatchObject({ id: taken.id, employeeId: null });
    expect(await messageTo(taken.email)).toContain('déjà un compte');
    expect((await invitationTo(fresh)).password.length).toBeGreaterThanOrEqual(12);
  });

  it('still refuses an employee number or an e-mail already used in the same company', async () => {
    const { owner } = await companyOwner();
    const email = unique('rim.haddad');
    const body = {
      employeeNumber: `E-${randomUUID().slice(0, 6)}`,
      firstName: 'Rim',
      lastName: 'Haddad',
      email,
      phone: '+21698333445',
    };
    expect((await owner.call('POST', '/v1/company/employees', { body })).status).toBe(201);
    const again = await owner.call('POST', '/v1/company/employees', {
      body: { ...body, employeeNumber: `E-${randomUUID().slice(0, 6)}` },
    });
    expect(again.status).toBe(409);
  });

  it("never lets a company create the account of another company's employee (RLS)", async () => {
    const mine = await createCompany(db);
    const other = await createCompany(db);
    const stranger = await createEmployee(db, other.id);
    const app = await appClient();
    await app.query('BEGIN');
    await app.query(
      `SELECT set_config('app.role', 'COMPANY', true), set_config('app.company_id', $1, true)`,
      [mine.id],
    );
    await expect(
      app.query(
        `INSERT INTO users (id, role, display_name, email, password_hash, employee_id)
         VALUES ($1, 'EMPLOYEE', 'X', $2, 'x', $3)`,
        [randomUUID(), unique('intrus'), stranger.id],
      ),
    ).rejects.toMatchObject({ code: '42501' });
    await app.query('ROLLBACK');
    await app.end();
  });
});
