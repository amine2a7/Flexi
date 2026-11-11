// Departments of a company (cahier ENT-04, request of 2026-11-05): each company sees only its own.
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

async function owner() {
  const company = await createCompany(db);
  const employee = await createEmployee(db, company.id);
  const client = await signedIn(
    base,
    await createUser(db, env, 'COMPANY', { companyId: company.id }, 'Leïla M.'),
  );
  return { company, employee, client };
}

describe('departments of a company', () => {
  it('creates, lists with counts and attaches an employee; names are unique per company', async () => {
    const { employee, client } = await owner();
    const created = await client.call('POST', '/v1/company/departments', {
      body: { name: 'Ressources humaines' },
    });
    expect(created.status).toBe(201);
    const id = String(created.body.id);
    expect(
      (
        await client.call('POST', '/v1/company/departments', {
          body: { name: 'ressources HUMAINES' },
        })
      ).status,
    ).toBe(409);
    const assigned = await client.call('PUT', `/v1/company/employees/${employee.id}/department`, {
      body: { departmentId: id },
    });
    expect(assigned.body).toEqual({ employeeId: employee.id, departmentId: id });
    const list = await client.call('GET', '/v1/company/departments');
    expect(list.body.data).toEqual([
      { id, name: 'Ressources humaines', employeeCount: 1, archived: false },
    ]);
    const employees = await client.call('GET', '/v1/company/employees');
    expect((employees.body.data as { departmentId?: string }[])[0]?.departmentId).toBe(id);
  });

  it('never shows nor uses the departments of another company', async () => {
    const first = await owner();
    const created = await first.client.call('POST', '/v1/company/departments', {
      body: { name: 'Finance' },
    });
    const other = await owner();
    expect((await other.client.call('GET', '/v1/company/departments')).body.data).toEqual([]);
    expect(
      (
        await other.client.call('PUT', `/v1/company/employees/${other.employee.id}/department`, {
          body: { departmentId: String(created.body.id) },
        })
      ).status,
    ).toBe(404);
    expect(
      (
        await other.client.call('PUT', `/v1/company/employees/${first.employee.id}/department`, {
          body: { departmentId: null },
        })
      ).status,
    ).toBe(404);
  });

  // TEST-FIRST (processus v2, bug 3): department (list) and position (free text), bulk change,
  // filters, positions suggested, archive refused while the department has employees.
  it('adds with department and position, moves 5 at once, filters, archives only when empty', async () => {
    const { company, client } = await owner();
    const make = async (name: string) =>
      String((await client.call('POST', '/v1/company/departments', { body: { name } })).body.id);
    const production = await make('Production');
    const commercial = await make('Commercial');
    const logistics = await make('Logistique');
    const added = await client.call('POST', '/v1/company/employees', {
      body: {
        employeeNumber: `M-${String(Date.now()).slice(-6)}`,
        firstName: 'Yasmine',
        lastName: 'Ben Ali',
        email: `yasmine-${String(Date.now())}@carthage.tn`,
        phone: '+21622123456',
        departmentId: production,
        position: ' Ouvrière ',
      },
    });
    expect(added.status).toBe(201);
    expect(added.body).toMatchObject({ departmentId: production, position: 'Ouvrière' });
    const others = await Promise.all([1, 2, 3, 4].map(() => createEmployee(db, company.id)));
    const five = [String(added.body.id), ...others.map((employee) => employee.id)];
    const moved = await client.call('POST', '/v1/company/employees/assignments', {
      body: { employeeIds: five, departmentId: commercial, position: 'Cadre' },
    });
    expect(moved.status).toBe(200);
    const inCommercial = await client.call(
      'GET',
      `/v1/company/employees?departmentId=${commercial}&withCount=true`,
    );
    expect(inCommercial.body.data).toHaveLength(5);
    const cadres = await client.call('GET', '/v1/company/employees?position=cadre');
    expect(
      (cadres.body.data as { position?: string }[]).every((row) => row.position === 'Cadre'),
    ).toBe(true);
    expect((await client.call('GET', '/v1/company/positions')).body.data).toContain('Cadre');
    // Nothing given: refused.
    expect(
      (
        await client.call('POST', '/v1/company/employees/assignments', {
          body: { employeeIds: five },
        })
      ).status,
    ).toBe(400);
    const refused = await client.call('POST', `/v1/company/departments/${commercial}/archive`);
    expect(refused.status).toBe(409);
    expect(refused.body.details).toMatchObject({
      reason: 'DEPARTMENT_NOT_EMPTY',
      employeeCount: 5,
    });
    const renamed = await client.call('PATCH', `/v1/company/departments/${logistics}`, {
      body: { name: 'Logistique & stocks' },
    });
    expect(renamed.body).toMatchObject({ name: 'Logistique & stocks' });
    const archived = await client.call('POST', `/v1/company/departments/${logistics}/archive`);
    expect(archived.body).toMatchObject({ archived: true });
    // An archived department takes no employee.
    expect(
      (
        await client.call('POST', '/v1/company/employees/assignments', {
          body: { employeeIds: [five[0]], departmentId: logistics },
        })
      ).status,
    ).toBe(409);
  });
});
