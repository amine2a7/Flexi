// W-SUP-bis: review of cf1ad79. The search function (SECURITY DEFINER) checks the tenant of the
// session itself, has a fixed search_path and is executed by the API role only; a cashier never
// sees its owner's tickets; an internal note leaves by no route; the last lists have a search.
import { randomInt, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen, type WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createCompany, createEmployee, createUser, oneLineGrid, sealed, seedSettings, signedIn } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';
const PDF = Buffer.from('%PDF-1.4\n% note interne\n%%EOF\n');

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

const SIGNATURE = 'text, text, text, text, text[], text, uuid';

/** Direct call of the function, as fp_app, in the RLS context of a session. */
function candidates(
  scope: Parameters<typeof db.run>[0],
  table: string,
  text: string,
  narrow: { column: string; id: string } | null = null,
) {
  return db.run(
    scope,
    (tx) =>
      tx.$queryRaw<{ id: string; score: number }[]>`
      SELECT * FROM fp_search_candidates(${table}, ${text}, ${`%${text}%`}, NULL, NULL,
        ${narrow?.column ?? null}, ${narrow?.id ?? null}::uuid)`,
  );
}

async function shop() {
  const merchant = await db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Boutique ${randomUUID().slice(0, 5)}`,
        category: 'GROCERY',
        city: 'Nabeul',
        phone: sealed('+21672000001'),
        email: 'boutique@test.tn',
        status: 'APPROVED',
        acceptedCreditTypes: ['RESTAURATION'],
        paymentCode: String(randomInt(100_000, 999_999)),
        commissionGrids: oneLineGrid(200),
      },
    }),
  );
  const owner = await signedIn(
    base,
    await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Patron'),
  );
  const cashier = await signedIn(
    base,
    await createUser(db, env, 'MERCHANT', { merchantId: merchant.id }, 'Caissier', 'CASHIER'),
  );
  return { merchant, owner, cashier };
}

async function openTicket(client: WebClient, subject = 'Question de caisse') {
  const created = await client.call('POST', '/v1/support/tickets', {
    body: { category: 'OTHER', subject, description: 'Une question sur la caisse du jour.' },
  });
  expect(created.status).toBe(201);
  return created.body;
}

describe('fp_search_candidates: the session tenant, checked by the function itself', () => {
  it('a BIAT user never gets another company’s employee, even calling the function in SQL', async () => {
    const token = `Zebulon${randomUUID().slice(0, 5)}`;
    const biat = await createCompany(db, `BIAT ${token}`);
    const other = await createCompany(db, `Autre ${token}`);
    const stranger = await db.system((tx) =>
      tx.employee.create({
        data: {
          companyId: other.id,
          employeeNumber: `E-${randomUUID().slice(0, 6)}`,
          firstName: 'Hela',
          lastName: token,
          email: `${randomUUID().slice(0, 8)}@autre.test`,
          phone: sealed('+21698000001'),
          status: 'ACTIVE',
        },
      }),
    );
    const session = { role: 'COMPANY' as const, companyId: biat.id };
    // No scope, the other company's scope, the employees' own table: nothing.
    expect(await candidates(session, 'employees', token)).toEqual([]);
    expect(
      await candidates(session, 'employees', token, { column: 'company_id', id: other.id }),
    ).toEqual([]);
    expect(await candidates(session, 'users', token)).toEqual([]);
    expect(await candidates(session, 'merchants', 'Boutique')).toEqual([]);
    // A merchant, a beneficiary or no session at all: nothing either.
    expect(
      await candidates({ role: 'MERCHANT', merchantId: randomUUID() }, 'employees', token),
    ).toEqual([]);
    expect(
      await candidates({ role: 'EMPLOYEE', employeeId: randomUUID() }, 'employees', token),
    ).toEqual([]);
    expect(
      await db.prisma.$queryRaw<unknown[]>`
        SELECT * FROM fp_search_candidates('employees', ${token}, ${`%${token}%`}, NULL, NULL, NULL, NULL)`,
    ).toEqual([]);
    // The platform finds it; only ids and scores come out.
    const found = await candidates({ role: 'ADMIN' }, 'employees', token);
    expect(found.map((row) => row.id)).toContain(stranger.id);
    expect(Object.keys(found[0] ?? {}).sort()).toEqual(['id', 'score']);
    // Its own employee is found by the BIAT session.
    const own = await createEmployee(db, biat.id);
    await db.system((tx) =>
      tx.employee.update({ where: { id: own.id }, data: { lastName: token } }),
    );
    expect((await candidates(session, 'employees', token)).map((row) => row.id)).toEqual([own.id]);

    // Same over HTTP: the owner of BIAT searching the name sees its employee only.
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: biat.id }, 'Patron BIAT'),
    );
    const result = await owner.call('GET', `/v1/search?q=${token}`);
    const ids = (result.body.groups as { items: { id: string }[] }[]).flatMap((g) =>
      g.items.map((i) => i.id),
    );
    expect(ids).toContain(own.id);
    expect(ids).not.toContain(stranger.id);
  });

  it('fixed search_path, security definer, EXECUTE for the API role only', async () => {
    const [fn] = await db.system((tx) =>
      tx.$queryRawUnsafe<{ secdef: boolean; config: string[]; acl: string[] }[]>(
        `SELECT p.prosecdef AS secdef, p.proconfig AS config, p.proacl::text[] AS acl
           FROM pg_proc p WHERE p.proname = 'fp_search_candidates'`,
      ),
    );
    expect(fn?.secdef).toBe(true);
    expect(fn?.config).toContain('search_path=pg_catalog, public, pg_temp');
    // No grant to PUBLIC (an ACL entry « =X/… »), the worker nor the reporting role.
    expect((fn?.acl ?? []).some((entry) => entry.startsWith('='))).toBe(false);
    const [rights] = await db.system((tx) =>
      tx.$queryRawUnsafe<{ app: boolean; worker: boolean; report: boolean }[]>(
        `SELECT has_function_privilege('flexipay_app', 'fp_search_candidates(${SIGNATURE})', 'EXECUTE') AS app,
                has_function_privilege('fp_worker', 'fp_search_candidates(${SIGNATURE})', 'EXECUTE') AS worker,
                has_function_privilege('fp_report', 'fp_search_candidates(${SIGNATURE})', 'EXECUTE') AS report`,
      ),
    );
    expect(rights).toEqual({ app: true, worker: false, report: false });
  });

  it('the typed text is a parameter, never SQL', async () => {
    const injection = `x'); DROP TABLE employees; --`;
    expect(await candidates({ role: 'ADMIN' }, 'employees', injection)).toEqual([]);
    expect(await db.system((tx) => tx.employee.count())).toBeGreaterThan(0);
    await expect(
      candidates({ role: 'ADMIN' }, 'employees; DROP TABLE users', 'x'),
    ).rejects.toThrow();
  });
});

describe('tickets: a cashier and its owner, internal notes', () => {
  it('a cashier never sees its owner’s ticket (detail, list, search, piece)', async () => {
    const { owner, cashier } = await shop();
    const subject = `Écart caisse ${randomUUID().slice(0, 6)}`;
    const ticket = await openTicket(owner, subject);
    const id = String(ticket.id);
    expect((await cashier.call('GET', `/v1/support/tickets/${id}`)).status).toBe(404);
    const list = await cashier.call('GET', '/v1/support/tickets');
    expect((list.body.data as { id: string }[]).map((t) => t.id)).not.toContain(id);
    const search = await cashier.call('GET', `/v1/search?q=${encodeURIComponent(subject)}`);
    expect(JSON.stringify(search.body)).not.toContain(id);
    expect(
      (
        await cashier.call('POST', `/v1/support/tickets/${id}/messages`, {
          body: { body: 'Moi aussi' },
        })
      ).status,
    ).toBe(404);
    // The owner sees the cashier's ticket.
    const mine = await openTicket(cashier);
    expect((await owner.call('GET', `/v1/support/tickets/${String(mine.id)}`)).status).toBe(200);
  });

  it('an internal note leaves by no route: detail, pieces, search, notification', async () => {
    const { owner } = await shop();
    const ticket = await openTicket(owner);
    const id = String(ticket.id);
    const agent = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Agent Support', 'SUPPORT'),
    );
    const secret = `NoteInterne${randomUUID().slice(0, 6)}`;
    const form = new FormData();
    form.append('body', `${secret} : client connu, vérifier le relevé`);
    form.append('internal', 'true');
    form.append('attachment', new Blob([PDF], { type: 'application/pdf' }), 'interne.pdf');
    const noted = await agent.call('POST', `/v1/admin/support-tickets/${id}/messages`, { form });
    expect(noted.status).toBe(201);
    const piece = (
      noted.body.messages as { internal: boolean; attachments: { id: string }[] }[]
    ).find((m) => m.internal)?.attachments[0]?.id;
    expect(piece).toBeDefined();

    const seen = await owner.call('GET', `/v1/support/tickets/${id}`);
    expect(JSON.stringify(seen.body)).not.toContain(secret);
    expect(JSON.stringify(seen.body)).not.toContain(String(piece));
    expect(
      (await owner.call('GET', `/v1/support/tickets/${id}/attachments/${String(piece)}/link`))
        .status,
    ).toBe(404);
    const list = await owner.call('GET', `/v1/support/tickets?q=${secret}`);
    expect(list.body.data).toEqual([]);
    // The search echoes the typed text (`query`); no result carries the note.
    const search = await owner.call('GET', `/v1/search?q=${secret}`);
    expect(search.body.groups).toEqual([]);
    // The client's own answers do not echo it either.
    const replied = await owner.call('POST', `/v1/support/tickets/${id}/messages`, {
      body: { body: 'Merci pour votre retour.' },
    });
    expect(JSON.stringify(replied.body)).not.toContain(secret);
    // No outbox event (notification) and no audit line carries the note.
    const events = await db.system((tx) => tx.outboxEvent.findMany({ where: { aggregateId: id } }));
    expect(JSON.stringify(events)).not.toContain(secret);
    const audit = await db.system((tx) =>
      tx.auditLog.findMany({ where: { target: { contains: secret } } }),
    );
    expect(audit).toEqual([]);
  });
});

describe('search on the last lists', () => {
  it('settlements, approvals, disputes, alerts, receivables and the ledger accept q', async () => {
    const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Super'));
    const nothing = 'zz-introuvable';
    for (const path of [
      '/v1/admin/settlements',
      '/v1/admin/approvals',
      '/v1/admin/disputes',
      '/v1/admin/fraud-alerts',
      '/v1/admin/ledger-entries',
    ]) {
      const result = await admin.call('GET', `${path}?q=${nothing}`);
      expect(result.status, path).toBe(200);
      expect(result.body.data, path).toEqual([]);
    }
    const { merchant, owner } = await shop();
    const firm = await createCompany(db);
    const employee = await createEmployee(db, firm.id);
    const reference = `PAY-${String(randomInt(10_000_000, 99_999_999))}`;
    await db.system((tx) =>
      tx.payment.create({
        data: {
          reference,
          merchantId: merchant.id,
          employeeId: employee.id,
          companyId: firm.id,
          creditType: 'RESTAURATION',
          amountMillimes: 8_000n,
          status: 'CONFIRMED',
          channel: 'MERCHANT_CODE',
          confirmedAt: new Date(),
          settlementDate: new Date(),
        },
      }),
    );
    const found = await owner.call('GET', `/v1/merchant/receivables?q=${reference.slice(0, 8)}`);
    expect(found.status).toBe(200);
    expect((found.body.data as { reference: string }[]).map((r) => r.reference)).toContain(
      reference,
    );
    const none = await owner.call('GET', `/v1/merchant/receivables?q=${nothing}`);
    expect(none.body.data).toEqual([]);
    expect((await owner.call('GET', `/v1/merchant/settlements?q=${nothing}`)).body.data).toEqual(
      [],
    );
  });
});
