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
    expect(list.body.data).toEqual([{ id, name: 'Ressources humaines', employeeCount: 1 }]);
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
});
