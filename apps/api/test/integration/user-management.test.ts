// TEST-FIRST (decisions A to D of 2026-10-23, e3 of 2026-10-22; specs admin-utilisateurs,
// entreprise-employes, commun-statut-utilisateur): user management by the administrator and by
// the company. Immediate effect (no four eyes), reason in the audit, guards of decision B.
import { randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { verifySecret } = await import('../../src/auth/password.js');
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

const REASON = { reason: 'Départ de la société confirmé par les RH.' };
type Sub = 'SUPER_ADMIN' | 'FINANCE' | 'COMPLIANCE' | 'SUPPORT';
const admin = async (subRole: Sub) => {
  const user = await createUser(db, env, 'ADMIN', {}, `Admin ${subRole}`, subRole);
  return { user, client: await signedIn(base, user) };
};
const companyOwner = async (companyId: string) =>
  signedIn(base, await createUser(db, env, 'COMPANY', { companyId }, 'Leïla M.', 'OWNER'));
const employeeAccount = async () => {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  const user = await createUser(db, env, 'EMPLOYEE', { employeeId: employee.id }, 'Yasmine J.');
  return { company, employee, user };
};
const history = (subjectId: string) =>
  db.system((tx) => tx.auditLog.findMany({ where: { subjectId }, orderBy: { occurredAt: 'asc' } }));

describe('administrator: users', () => {
  it('lists and shows users; only the allowed sub-roles see a balance', async () => {
    const { user } = await employeeAccount();
    const finance = await admin('FINANCE');
    const support = await admin('SUPPORT');
    const list = await finance.client.call(
      'GET',
      `/v1/admin/users?q=${encodeURIComponent(user.email)}`,
    );
    expect(list.status).toBe(200);
    expect((list.body.data as { id: string }[]).map((row) => row.id)).toEqual([user.id]);
    const seen = await finance.client.call('GET', `/v1/admin/users/${user.id}`);
    expect(seen.body).toMatchObject({ id: user.id, role: 'EMPLOYEE', status: 'ACTIVE' });
    expect(typeof seen.body.balanceMillimes).toBe('number');
    const bySupport = await support.client.call('GET', `/v1/admin/users/${user.id}`);
    expect(bySupport.status).toBe(200);
    expect(bySupport.body).not.toHaveProperty('balanceMillimes');
    expect(JSON.stringify(bySupport.body)).not.toMatch(/phone/i);
  });

  it('the super-admin creates an administrator at once (no second validation)', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const email = `admin-${randomUUID().slice(0, 8)}@flexipay.tn`;
    const created = await superAdmin.client.call('POST', '/v1/admin/users', {
      body: { displayName: 'Nadia K.', email, subRole: 'FINANCE', ...REASON },
    });
    expect(created.status).toBe(202);
    const user = await db.system((tx) => tx.user.findUniqueOrThrow({ where: { email } }));
    expect(user).toMatchObject({ role: 'ADMIN', subRole: 'FINANCE', mustChangePassword: true });
    // Same answer for an address already registered (no enumeration), no second account.
    const again = await superAdmin.client.call('POST', '/v1/admin/users', {
      body: { displayName: 'Nadia K.', email, subRole: 'SUPPORT', ...REASON },
    });
    expect(again.status).toBe(202);
    expect(await db.system((tx) => tx.user.count({ where: { email } }))).toBe(1);
  });

  it('suspends at once with a reason, closes the sessions, reactivates; audit names it', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const company = await createCompany(db);
    const target = await createUser(
      db,
      env,
      'COMPANY',
      { companyId: company.id },
      'Sami B.',
      'MANAGER',
    );
    const targetClient = await signedIn(base, target);
    const suspended = await superAdmin.client.call('POST', `/v1/admin/users/${target.id}/suspend`, {
      body: REASON,
    });
    expect(suspended.status).toBe(200);
    expect(suspended.body.status).toBe('SUSPENDED');
    expect((await targetClient.call('GET', '/v1/me')).status).toBe(401);
    const twice = await superAdmin.client.call('POST', `/v1/admin/users/${target.id}/suspend`, {
      body: REASON,
    });
    expect(twice.status).toBe(409);
    const back = await superAdmin.client.call('POST', `/v1/admin/users/${target.id}/reactivate`, {
      body: REASON,
    });
    expect(back.body.status).toBe('ACTIVE');
    const entries = await history(target.id);
    expect(entries.map((entry) => entry.action)).toEqual(['users.suspend', 'users.reactivate']);
    expect(entries[0]?.reason).toBe(REASON.reason);
    expect(entries[0]?.actorUserId).toBe(superAdmin.user.id);
  });

  it('refuses a too short reason, a change of its own account, and a deactivated comeback', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const other = await admin('FINANCE');
    const short = await superAdmin.client.call('POST', `/v1/admin/users/${other.user.id}/suspend`, {
      body: { reason: 'Court' },
    });
    expect(short.status).toBe(400);
    const self = await superAdmin.client.call(
      'POST',
      `/v1/admin/users/${superAdmin.user.id}/suspend`,
      { body: REASON },
    );
    expect(self.status).toBe(403);
    const ownRole = await superAdmin.client.call(
      'POST',
      `/v1/admin/users/${superAdmin.user.id}/role`,
      {
        body: { subRole: 'FINANCE', ...REASON },
      },
    );
    expect(ownRole.status).toBe(403);
    const off = await superAdmin.client.call(
      'POST',
      `/v1/admin/users/${other.user.id}/deactivate`,
      {
        body: REASON,
      },
    );
    expect(off.body.status).toBe('DEACTIVATED');
    const comeback = await superAdmin.client.call(
      'POST',
      `/v1/admin/users/${other.user.id}/reactivate`,
      { body: REASON },
    );
    expect(comeback.status).toBe(409);
  });

  it('changes the sub-role of an administrator', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const other = await admin('SUPPORT');
    const changed = await superAdmin.client.call('POST', `/v1/admin/users/${other.user.id}/role`, {
      body: { subRole: 'COMPLIANCE', ...REASON },
    });
    expect(changed.status).toBe(200);
    expect(changed.body.subRole).toBe('COMPLIANCE');
    // An administrator sub-role is never given to a company user (and the reverse).
    const company = await createCompany(db);
    const hr = await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Rim T.', 'MANAGER');
    const wrong = await superAdmin.client.call('POST', `/v1/admin/users/${hr.id}/role`, {
      body: { subRole: 'SUPER_ADMIN', ...REASON },
    });
    expect(wrong.status).toBe(400);
  });

  it('only the super-admin resends an invitation or unlocks a PIN; support only reads (2026-11-17)', async () => {
    const support = await admin('SUPPORT');
    const superAdmin = await admin('SUPER_ADMIN');
    const { employee, user } = await employeeAccount();
    await db.system((tx) =>
      tx.employee.update({
        where: { id: employee.id },
        data: { pinFailures: 3, pinLockedUntil: new Date(Date.now() + 900_000), pinLockLevel: 1 },
      }),
    );
    const before = await support.client.call('GET', `/v1/admin/users/${user.id}`);
    expect(before.body.pinLocked).toBe(true);
    // Support, Finance and Opérations only read the users.
    for (const action of ['unlock-pin', 'reset-invitation'])
      expect(
        (await support.client.call('POST', `/v1/admin/users/${user.id}/${action}`)).status,
      ).toBe(403);
    const suspend = await support.client.call('POST', `/v1/admin/users/${user.id}/suspend`, {
      body: REASON,
    });
    expect(suspend.status).toBe(403);
    const unlocked = await superAdmin.client.call('POST', `/v1/admin/users/${user.id}/unlock-pin`);
    expect(unlocked.status).toBe(200);
    expect(unlocked.body.pinLocked).toBe(false);
    const hashBefore = (
      await db.system((tx) => tx.user.findUniqueOrThrow({ where: { id: user.id } }))
    ).passwordHash;
    // Processus v2: the administrator sees the new password, once; the previous one stops working.
    const generated = await superAdmin.client.call(
      'POST',
      `/v1/admin/users/${user.id}/reset-invitation`,
    );
    expect(generated.status).toBe(200);
    const credentials = generated.body.credentials as { email: string; temporaryPassword: string };
    expect(credentials.email).toBe(user.email);
    const stored = await db.system((tx) => tx.user.findUniqueOrThrow({ where: { id: user.id } }));
    expect(await verifySecret(stored.passwordHash, credentials.temporaryPassword)).toBe(true);
    expect(stored.passwordHash).not.toBe(hashBefore);
    expect(stored.mustChangePassword).toBe(true);
    expect(stored.tempPasswordExpiresAt?.getTime() ?? 0).toBeGreaterThan(Date.now());
  });
});

describe('company: employees', () => {
  it('suspends: balance kept but blocked (no allocation), reactivates', async () => {
    const company = await createCompany(db);
    const employee = await createEmployee(db, company.id);
    const owner = await companyOwner(company.id);
    const suspended = await owner.call('POST', `/v1/company/employees/${employee.id}/suspend`, {
      body: REASON,
    });
    expect(suspended.status).toBe(200);
    expect(suspended.body.status).toBe('SUSPENDED');
    const allocation = await owner.call('POST', '/v1/company/allocations', {
      body: {
        allocations: [
          { employeeId: employee.id, creditType: 'RESTAURATION', amountMillimes: 1_000 },
        ],
      },
      headers: { 'Idempotency-Key': randomUUID() },
    });
    expect(allocation.status).toBe(409);
    const back = await owner.call('POST', `/v1/company/employees/${employee.id}/reactivate`, {
      body: REASON,
    });
    expect(back.body.status).toBe('ACTIVE');
  });

  it('deactivates with a grace period: the employee still signs in, never receives', async () => {
    const { company, employee, user } = await employeeAccount();
    const owner = await companyOwner(company.id);
    const off = await owner.call('POST', `/v1/company/employees/${employee.id}/deactivate`, {
      body: REASON,
    });
    expect(off.status).toBe(200);
    expect(off.body.status).toBe('DEACTIVATED');
    const graceDays = (Date.parse(String(off.body.graceUntil)) - Date.now()) / 86_400_000;
    expect(graceDays).toBeGreaterThan(29);
    expect(graceDays).toBeLessThanOrEqual(30);
    // During the grace period the employee signs in to spend its balance.
    const spender = await signedIn(base, user);
    expect((await spender.call('GET', '/v1/me')).status).toBe(200);
    const allocation = await owner.call('POST', '/v1/company/allocations', {
      body: {
        allocations: [
          { employeeId: employee.id, creditType: 'RESTAURATION', amountMillimes: 1_000 },
        ],
      },
      headers: { 'Idempotency-Key': randomUUID() },
    });
    expect(allocation.status).toBe(409);
    const comeback = await owner.call('POST', `/v1/company/employees/${employee.id}/reactivate`, {
      body: REASON,
    });
    expect(comeback.status).toBe(409);
  });

  it('never acts on the employee of another company (404), bulk suspends a page', async () => {
    const mine = await createCompany(db);
    const other = await createCompany(db);
    const stranger = await createEmployee(db, other.id);
    const owner = await companyOwner(mine.id);
    const refused = await owner.call('POST', `/v1/company/employees/${stranger.id}/suspend`, {
      body: REASON,
    });
    expect(refused.status).toBe(404);
    const first = await createEmployee(db, mine.id);
    const second = await createEmployee(db, mine.id);
    const bulk = await owner.call('POST', '/v1/company/employees/status-changes', {
      body: { action: 'SUSPEND', employeeIds: [first.id, second.id, stranger.id], ...REASON },
    });
    expect(bulk.status).toBe(200);
    expect(bulk.body.results).toEqual([
      { employeeId: first.id, outcome: 'DONE' },
      { employeeId: second.id, outcome: 'DONE' },
      { employeeId: stranger.id, outcome: 'SKIPPED' },
    ]);
  });

  it('the company never sees the reason typed by an administrator (decision D7)', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const { company, employee, user } = await employeeAccount();
    await superAdmin.client.call('POST', `/v1/admin/users/${user.id}/suspend`, { body: REASON });
    const owner = await companyOwner(company.id);
    const list = await owner.call('GET', '/v1/company/employees');
    const row = (list.body.data as { id: string; status: string }[]).find(
      (item) => item.id === employee.id,
    );
    expect(row?.status).toBe('SUSPENDED');
    expect(JSON.stringify(list.body)).not.toContain(REASON.reason);
  });

  it('a suspension by an administrator is never lifted by the company (to confirm)', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const { company, employee, user } = await employeeAccount();
    await superAdmin.client.call('POST', `/v1/admin/users/${user.id}/suspend`, { body: REASON });
    const owner = await companyOwner(company.id);
    const lifted = await owner.call('POST', `/v1/company/employees/${employee.id}/reactivate`, {
      body: REASON,
    });
    expect(lifted.status).toBe(403);
  });
});

describe('support limits (securite S2-02, S2-03)', () => {
  it('support never resets anyone; unlocking a PIN closes the sessions', async () => {
    const support = await admin('SUPPORT');
    const superAdmin = await admin('SUPER_ADMIN');
    const other = await admin('FINANCE');
    expect(
      (await support.client.call('POST', `/v1/admin/users/${other.user.id}/reset-invitation`))
        .status,
    ).toBe(403);
    expect(
      (await support.client.call('POST', `/v1/admin/users/${support.user.id}/reset-invitation`))
        .status,
    ).toBe(403);
    const { employee, user } = await employeeAccount();
    const spender = await signedIn(base, user);
    await db.system((tx) =>
      tx.employee.update({ where: { id: employee.id }, data: { pinRequiresReauth: true } }),
    );
    expect(
      (await support.client.call('POST', `/v1/admin/users/${user.id}/unlock-pin`)).status,
    ).toBe(403);
    expect(
      (await superAdmin.client.call('POST', `/v1/admin/users/${user.id}/unlock-pin`)).status,
    ).toBe(200);
    expect((await spender.call('GET', '/v1/me')).status).toBe(401);
  });

  it('the last owner of a company is never demoted', async () => {
    const superAdmin = await admin('SUPER_ADMIN');
    const company = await createCompany(db);
    const owner = await createUser(
      db,
      env,
      'COMPANY',
      { companyId: company.id },
      'Seul P.',
      'OWNER',
    );
    const demoted = await superAdmin.client.call('POST', `/v1/admin/users/${owner.id}/role`, {
      body: { subRole: 'MANAGER', ...REASON },
    });
    expect(demoted.status).toBe(409);
  });
});
