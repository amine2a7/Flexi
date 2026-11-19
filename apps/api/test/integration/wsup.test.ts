// W-SUP: support tickets and dynamic search. A client never sees another client's ticket, Support
// never changes money, a PIN typed in a message is masked before saving, the search never returns
// another company's item, the CIN is found only complete and only by Opérations, and a search
// over 10 000 rows answers in less than 200 ms.
import { randomInt, randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen, type WebClient } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { blindIndex } = await import('../../src/common/keyring.js');
const { SupportService } = await import('../../src/support/support.service.js');
const { redactSecrets } = await import('../../src/support/redact.js');
const { routes } = await import('../routes.js');
const {
  PASSWORD,
  createCompany,
  createEmployee,
  createUser,
  oneLineGrid,
  sealed,
  seedSettings,
  signedIn,
} = await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';
const blind = (kind: string, value: string) =>
  blindIndex(Buffer.from(env.BLIND_INDEX_KEY, 'base64'), kind, value);
const PDF = Buffer.from('%PDF-1.4\n% ticket test\n1 0 obj << >> endobj\ntrailer << >>\n%%EOF\n');

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

type Sub = 'SUPER_ADMIN' | 'FINANCE' | 'COMPLIANCE' | 'SUPPORT';
const admin = async (subRole: Sub, name = `Agent ${subRole}`) => {
  const user = await createUser(db, env, 'ADMIN', {}, name, subRole);
  return { user, client: await signedIn(base, user) };
};

async function company(token = randomUUID().slice(0, 6)) {
  const row = await createCompany(db, `Société ${token}`);
  const owner = await signedIn(
    base,
    await createUser(db, env, 'COMPANY', { companyId: row.id }, `Patronne ${token}`),
  );
  return { company: row, owner };
}

async function shop() {
  const merchant = await db.system((tx) =>
    tx.merchant.create({
      data: {
        name: `Épicerie ${randomUUID().slice(0, 5)}`,
        category: 'GROCERY',
        city: 'Sfax',
        phone: sealed('+21674000001'),
        email: 'epicerie@test.tn',
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
  return { merchant, owner };
}

/** A confirmed payment of a beneficiary at a shop (rows only: read by the ticket). */
async function payment(merchantId: string) {
  const firm = await createCompany(db);
  const employee = await createEmployee(db, firm.id);
  return db.system((tx) =>
    tx.payment.create({
      data: {
        reference: `PAY-${String(randomInt(10_000_000, 99_999_999))}`,
        merchantId,
        employeeId: employee.id,
        companyId: firm.id,
        creditType: 'RESTAURATION',
        amountMillimes: 12_500n,
        status: 'CONFIRMED',
        channel: 'MERCHANT_CODE',
        confirmedAt: new Date(),
      },
    }),
  );
}

function ticketForm(fields: Record<string, string>, piece?: Buffer) {
  const form = new FormData();
  for (const [name, value] of Object.entries(fields)) form.append(name, value);
  if (piece !== undefined)
    form.append('attachment', new Blob([piece], { type: 'application/pdf' }), 'releve.pdf');
  return form;
}

async function openTicket(client: WebClient, fields: Record<string, string> = {}) {
  const created = await client.call('POST', '/v1/support/tickets', {
    body: {
      category: 'OTHER',
      subject: 'Question sur mon compte',
      description: 'Bonjour, je n’arrive pas à télécharger mon relevé du mois.',
      ...fields,
    },
  });
  expect(created.status).toBe(201);
  return created.body;
}

describe('support tickets: a client never sees another client’s ticket', () => {
  it('another company gets 404 on the ticket, its list, its answers and its pieces', async () => {
    const first = await company();
    const other = await company();
    const created = await first.owner.call('POST', '/v1/support/tickets', {
      form: ticketForm(
        {
          category: 'ACCOUNT_ACCESS',
          subject: 'Accès bloqué',
          description: 'Mon accès est bloqué depuis ce matin, merci de vérifier.',
        },
        PDF,
      ),
    });
    expect(created.status).toBe(201);
    expect(String(created.body.reference)).toMatch(/^TK-\d{4}-\d{6}$/);
    const id = String(created.body.id);
    const pieces = created.body.attachments as { id: string }[];
    expect(pieces).toHaveLength(1);

    expect((await other.owner.call('GET', `/v1/support/tickets/${id}`)).status).toBe(404);
    const list = await other.owner.call('GET', '/v1/support/tickets');
    expect((list.body.data as { id: string }[]).map((t) => t.id)).not.toContain(id);
    const reply = await other.owner.call('POST', `/v1/support/tickets/${id}/messages`, {
      body: { body: 'Je me glisse dans la conversation' },
    });
    expect(reply.status).toBe(404);
    const link = await other.owner.call(
      'GET',
      `/v1/support/tickets/${id}/attachments/${pieces[0]?.id ?? ''}/link`,
    );
    expect(link.status).toBe(404);
    // A merchant and an administrator route are refused to a company.
    expect((await other.owner.call('GET', '/v1/admin/support-tickets')).status).toBe(403);
  });

  it('inside a company: each user sees its own tickets, the owner sees them all', async () => {
    const { company: firm, owner } = await company();
    const hr = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: firm.id }, 'RH', 'MANAGER'),
    );
    const finance = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId: firm.id }, 'Finance', 'FINANCE'),
    );
    const ticket = await openTicket(hr);
    expect((await finance.call('GET', `/v1/support/tickets/${String(ticket.id)}`)).status).toBe(
      404,
    );
    expect((await owner.call('GET', `/v1/support/tickets/${String(ticket.id)}`)).status).toBe(200);
    const ownerList = await owner.call('GET', '/v1/support/tickets');
    expect((ownerList.body.data as { id: string }[]).map((t) => t.id)).toContain(ticket.id);
  });

  it('a beneficiary (app) opens a ticket on its payment; another beneficiary cannot read it', async () => {
    const { merchant } = await shop();
    const paid = await payment(merchant.id);
    const mine = await mobileClient(paid.employeeId);
    const stranger = await mobileClient((await createEmployee(db, paid.companyId)).id);
    const created = await mine.call('POST', '/v1/support/tickets', {
      category: 'DISPUTED_TRANSACTION',
      subject: 'Paiement contesté',
      description: 'Je n’ai jamais fait ce paiement chez ce commerçant.',
      linkType: 'PAYMENT',
      linkId: paid.id,
    });
    expect(created.status).toBe(201);
    // Contested transaction: high priority, the payment is linked.
    expect(created.body.priority).toBe('HIGH');
    expect(created.body.link).toMatchObject({ type: 'PAYMENT', reference: paid.reference });
    expect(
      (await stranger.call('GET', `/v1/support/tickets/${String(created.body.id)}`)).status,
    ).toBe(404);
    // A payment of someone else cannot be linked.
    const foreign = await stranger.call('POST', '/v1/support/tickets', {
      category: 'DISPUTED_TRANSACTION',
      subject: 'Paiement contesté',
      description: 'Je conteste ce paiement que je ne reconnais pas.',
      linkType: 'PAYMENT',
      linkId: paid.id,
    });
    expect(foreign.status).toBe(404);
  });
});

describe('support tickets: masking, conversation, statuses', () => {
  it('a PIN, a password and a card number are masked before saving', async () => {
    const { owner } = await company();
    const ticket = await openTicket(owner, {
      description:
        'Mon code PIN est 4821 et mon mot de passe : Soleil-2026!, carte 4111 1111 1111 1111.',
    });
    const stored = await db.system((tx) =>
      tx.supportTicket.findUniqueOrThrow({ where: { id: String(ticket.id) } }),
    );
    expect(stored.description).not.toContain('4821');
    expect(stored.description).not.toContain('Soleil-2026!');
    expect(stored.description).not.toContain('4111 1111 1111 1111');
    expect(stored.description).toContain('1111');
    expect(stored.redacted).toBe(true);
    const reply = await owner.call('POST', `/v1/support/tickets/${String(ticket.id)}/messages`, {
      body: { body: 'J’oubliais : le PIN de ma carte est 1234' },
    });
    expect(reply.status).toBe(201);
    const messages = await db.system((tx) =>
      tx.supportTicketMessage.findMany({ where: { ticketId: String(ticket.id) } }),
    );
    expect(messages.map((m) => m.body).join(' ')).not.toContain('1234');
    expect(messages[0]?.redacted).toBe(true);
    // Arabic and a plain text stay as they are when there is no secret.
    expect(redactSecrets('الرمز السري 9876').text).not.toContain('9876');
    expect(redactSecrets('Commande CMD-2026-7300 de 1500 dinars').redacted).toBe(false);
  });

  it('agents answer, note, assign, transfer, resolve; the client reopens; closed after 7 days', async () => {
    const { owner } = await company();
    const support = await admin('SUPPORT', `Sonia ${randomUUID().slice(0, 4)}`);
    const ticket = await openTicket(owner);
    const id = String(ticket.id);

    const queue = await support.client.call('GET', '/v1/admin/support-tickets?assignee=none');
    expect((queue.body.data as { id: string }[]).map((t) => t.id)).toContain(id);
    const agents = await support.client.call(
      'GET',
      '/v1/admin/support-tickets/agents?team=SUPPORT',
    );
    expect((agents.body.data as { id: string }[]).map((a) => a.id)).toContain(support.user.id);
    const assigned = await support.client.call(
      'POST',
      `/v1/admin/support-tickets/${id}/assignment`,
      {
        body: { assigneeId: support.user.id },
      },
    );
    expect(assigned.status).toBe(200);
    expect(assigned.body.status).toBe('IN_PROGRESS');

    const outboxBefore = await db.system((tx) =>
      tx.outboxEvent.count({ where: { aggregateId: id, topic: 'support.ticket.replied' } }),
    );
    const answered = await support.client.call('POST', `/v1/admin/support-tickets/${id}/messages`, {
      body: { body: 'Pouvez-vous préciser le mois concerné ?', waitingCustomer: true },
    });
    expect(answered.status).toBe(201);
    expect(answered.body.status).toBe('WAITING_CUSTOMER');
    expect(answered.body.firstResponseAt).not.toBeNull();
    const noted = await support.client.call('POST', `/v1/admin/support-tickets/${id}/messages`, {
      body: { body: 'Client déjà venu le mois dernier', internal: true },
    });
    expect(noted.status).toBe(201);
    // Each answer is notified (outbox); an internal note is not.
    expect(
      await db.system((tx) =>
        tx.outboxEvent.count({ where: { aggregateId: id, topic: 'support.ticket.replied' } }),
      ),
    ).toBe(outboxBefore + 1);

    const seen = await owner.call('GET', `/v1/support/tickets/${id}`);
    const bodies = (seen.body.messages as { body: string }[]).map((m) => m.body);
    expect(bodies).toContain('Pouvez-vous préciser le mois concerné ?');
    expect(bodies).not.toContain('Client déjà venu le mois dernier');
    expect(JSON.stringify(seen.body)).not.toContain('internal');
    // Even a direct read under the client's RLS never returns the note.
    const companyId = (
      await db.system((tx) => tx.supportTicket.findUniqueOrThrow({ where: { id } }))
    ).companyId;
    const visible = await db.run({ role: 'COMPANY', companyId }, (tx) =>
      tx.supportTicketMessage.findMany({ where: { ticketId: id } }),
    );
    expect(visible.some((m) => m.internal)).toBe(false);

    const back = await owner.call('POST', `/v1/support/tickets/${id}/messages`, {
      body: { body: 'Il s’agit du mois d’octobre.' },
    });
    expect(back.body.status).toBe('IN_PROGRESS');

    const transferred = await support.client.call(
      'POST',
      `/v1/admin/support-tickets/${id}/transfer`,
      {
        body: { team: 'FINANCE', note: 'Écart de facturation à vérifier' },
      },
    );
    expect(transferred.status).toBe(200);
    expect(transferred.body.team).toBe('FINANCE');
    expect(transferred.body.assignee).toBeNull();

    const resolved = await support.client.call('POST', `/v1/admin/support-tickets/${id}/status`, {
      body: { status: 'RESOLVED' },
    });
    expect(resolved.body.status).toBe('RESOLVED');
    const reopened = await owner.call('POST', `/v1/support/tickets/${id}/reopen`);
    expect(reopened.status).toBe(200);
    expect(reopened.body.status).toBe('OPEN');
    await support.client.call('POST', `/v1/admin/support-tickets/${id}/status`, {
      body: { status: 'RESOLVED' },
    });
    const jobs = app.get(SupportService);
    await jobs.closeResolved(new Date(Date.now() + 8 * 86_400_000));
    const closed = await owner.call('GET', `/v1/support/tickets/${id}`);
    expect(closed.body.status).toBe('CLOSED');
    const late = await owner.call('POST', `/v1/support/tickets/${id}/messages`, {
      body: { body: 'Encore une question' },
    });
    expect(late.status).toBe(409);

    // Counters of the queue; every step is in the audit log.
    expect((await support.client.call('GET', `/v1/admin/support-tickets/${id}`)).status).toBe(200);
    const stats = await support.client.call('GET', '/v1/admin/support-tickets/stats');
    expect(stats.status).toBe(200);
    expect(typeof stats.body.open).toBe('number');
    expect(typeof stats.body.overdue).toBe('number');
    const reference = String(ticket.reference);
    const actions = await db.system((tx) =>
      tx.auditLog.findMany({
        where: { target: { startsWith: reference } },
        select: { action: true },
      }),
    );
    expect(new Set(actions.map((a) => a.action))).toEqual(
      new Set([
        'support.create',
        'support.view',
        'support.assign',
        'support.answer',
        'support.note',
        'support.reply',
        'support.transfer',
        'support.status',
        'support.reopen',
      ]),
    );
  });

  it('pieces are encrypted on the storage and reached only by a signed link of 5 minutes', async () => {
    const { owner } = await company();
    const created = await owner.call('POST', '/v1/support/tickets', {
      form: ticketForm(
        {
          category: 'KYC',
          subject: 'Pièce KYC',
          description: 'Voici la pièce demandée pour le KYC.',
        },
        PDF,
      ),
    });
    const id = String(created.body.id);
    const piece = (created.body.attachments as { id: string }[])[0]?.id ?? '';
    const row = await db.system((tx) =>
      tx.supportTicketAttachment.findUniqueOrThrow({ where: { id: piece } }),
    );
    const onDisk = await readFile(join(env.uploadDir, ...row.storageKey.split('/')));
    expect(onDisk.includes(Buffer.from('%PDF'))).toBe(false);

    const link = await owner.call('GET', `/v1/support/tickets/${id}/attachments/${piece}/link`);
    expect(link.status).toBe(200);
    const file = await fetch(base + String(link.body.url), {
      headers: {
        Cookie: owner.cookieHeader(String(link.body.url)),
        Origin: 'http://localhost:3001',
      },
    });
    expect(file.status).toBe(200);
    expect(Buffer.from(await file.arrayBuffer()).equals(PDF)).toBe(true);
    // Another user with the same link, or an expired link: refused.
    const support = await admin('SUPPORT');
    const stolen = await support.client.call(
      'GET',
      String(link.body.url).replace('/v1/support/tickets', '/v1/admin/support-tickets'),
    );
    expect(stolen.status).toBe(403);
    const expired = await owner.call(
      'GET',
      `/v1/support/tickets/${id}/attachments/${piece}?expires=1000&signature=${'a'.repeat(43)}`,
    );
    expect(expired.status).toBe(403);
    // A file that is not a PDF, JPG or PNG is refused.
    const wrong = await owner.call('POST', '/v1/support/tickets', {
      form: (() => {
        const form = ticketForm({
          category: 'OTHER',
          subject: 'Fichier',
          description: 'Un fichier texte qui n’est pas accepté.',
        });
        form.append(
          'attachment',
          new Blob(['MZ executable'], { type: 'application/pdf' }),
          'x.pdf',
        );
        return form;
      })(),
    });
    expect(wrong.status).toBe(415);
  });

  it('the creation is rate limited per user', async () => {
    const { owner } = await company();
    for (let i = 0; i < 10; i += 1) await openTicket(owner);
    const refused = await owner.call('POST', '/v1/support/tickets', {
      body: {
        category: 'OTHER',
        subject: 'Encore',
        description: 'Une onzième demande en une heure.',
      },
    });
    expect(refused.status).toBe(429);
    expect(refused.body.code).toBe('RATE_LIMITED');
  });
});

describe('Support never changes money', () => {
  it('every admin write route outside the tickets and contact messages is refused to Support', async () => {
    const support = await admin('SUPPORT');
    const writes = (await routes()).filter(
      (route) => route.path.startsWith('/v1/admin') && route.method !== 'GET',
    );
    const allowed: string[] = [];
    for (const route of writes) {
      const path = route.path.replace(/:[A-Za-z]+/g, randomUUID());
      const result = await support.client.call(route.method, path, {
        body: {},
        headers: { 'Idempotency-Key': randomUUID() },
      });
      if (!(result.status === 403 && result.body.code === 'FORBIDDEN')) allowed.push(route.name);
    }
    expect(allowed.sort()).toEqual(
      [
        'AdminController.handle',
        'AdminSupportController.assign',
        'AdminSupportController.reply',
        'AdminSupportController.status',
        'AdminSupportController.transfer',
      ].sort(),
    );
  }, 60_000);

  it('Support reads the linked transaction, and its ticket work writes nothing in the ledger', async () => {
    const { merchant, owner } = await shop();
    const paid = await payment(merchant.id);
    const ticket = await openTicket(owner, {
      category: 'PAYMENT_DECLINED',
      linkType: 'PAYMENT',
      linkId: paid.id,
    });
    const before = await db.system((tx) => tx.ledgerTransaction.count());
    const support = await admin('SUPPORT');
    const detail = await support.client.call(
      'GET',
      `/v1/admin/support-tickets/${String(ticket.id)}`,
    );
    expect(detail.status).toBe(200);
    expect(detail.body.linked).toMatchObject({
      type: 'PAYMENT',
      reference: paid.reference,
      amountMillimes: 12_500,
      status: 'CONFIRMED',
    });
    await support.client.call('POST', `/v1/admin/support-tickets/${String(ticket.id)}/status`, {
      body: { status: 'RESOLVED' },
    });
    expect(await db.system((tx) => tx.ledgerTransaction.count())).toBe(before);
    const payment2 = await db.system((tx) =>
      tx.payment.findUniqueOrThrow({ where: { id: paid.id } }),
    );
    expect(payment2.status).toBe('CONFIRMED');
  });
});

describe('global search', () => {
  it('never returns an item of another company', async () => {
    const token = `zq${randomUUID().slice(0, 5)}`;
    const mine = await company(`${token}a`);
    const other = await company(`${token}b`);
    for (const firm of [mine.company, other.company])
      await db.system((tx) =>
        tx.employee.create({
          data: {
            companyId: firm.id,
            employeeNumber: `E-${randomUUID().slice(0, 6)}`,
            firstName: 'Mehdi',
            lastName: `Ben ${token}`,
            email: `${randomUUID().slice(0, 8)}@salarie.test`,
            phone: sealed('+21698000000'),
            status: 'ACTIVE',
          },
        }),
      );
    await openTicket(mine.owner, { subject: `Souci ${token} paie` });
    await openTicket(other.owner, { subject: `Souci ${token} paie` });

    const result = await mine.owner.call('GET', `/v1/search?q=${token}`);
    expect(result.status).toBe(200);
    const groups = result.body.groups as {
      type: string;
      items: { id: string; parentId: string | null }[];
    }[];
    const employees = groups.find((g) => g.type === 'EMPLOYEE')?.items ?? [];
    expect(employees).toHaveLength(1);
    expect(employees[0]?.parentId).toBe(mine.company.id);
    const otherIds = new Set([
      other.company.id,
      ...(
        await db.system((tx) =>
          tx.supportTicket.findMany({
            where: { companyId: other.company.id },
            select: { id: true },
          }),
        )
      ).map((t) => t.id),
      ...(
        await db.system((tx) =>
          tx.employee.findMany({ where: { companyId: other.company.id }, select: { id: true } }),
        )
      ).map((e) => e.id),
    ]);
    for (const group of groups)
      for (const found of group.items) {
        expect(otherIds.has(found.id)).toBe(false);
        if (found.parentId !== null) expect(found.parentId).toBe(mine.company.id);
      }
    expect(groups.find((g) => g.type === 'TICKET')?.items).toHaveLength(1);
    // A company never gets the groups of the administrators.
    expect(groups.map((g) => g.type)).not.toContain('COMPANY');

    // A typo and a piece of word still find the employee (trigrams, without accents).
    const typo = await mine.owner.call('GET', `/v1/search?q=${encodeURIComponent('mehdy')}`);
    const typoEmployees =
      (typo.body.groups as { type: string; items: { parentId: string }[] }[]).find(
        (g) => g.type === 'EMPLOYEE',
      )?.items ?? [];
    expect(typoEmployees.length).toBeGreaterThan(0);
    expect(typoEmployees.every((e) => e.parentId === mine.company.id)).toBe(true);

    // The exact reference of another company's ticket opens nothing.
    const foreign = await db.system((tx) =>
      tx.supportTicket.findFirstOrThrow({ where: { companyId: other.company.id } }),
    );
    const exact = await mine.owner.call('GET', `/v1/search?q=${foreign.reference}`);
    expect(exact.body.exact).toBeNull();
    const own = await db.system((tx) =>
      tx.supportTicket.findFirstOrThrow({ where: { companyId: mine.company.id } }),
    );
    const ownExact = await mine.owner.call('GET', `/v1/search?q=${own.reference}`);
    expect(ownExact.body.exact).toMatchObject({ type: 'TICKET', id: own.id });
    // Fewer than 2 characters: refused.
    expect((await mine.owner.call('GET', '/v1/search?q=a')).status).toBe(400);
  });

  it('the CIN is found only complete, and only by Opérations (audited)', async () => {
    const cin = String(randomInt(10_000_000, 99_999_999));
    const firm = await createCompany(db, `Cabinet ${randomUUID().slice(0, 5)}`);
    await db.system((tx) =>
      tx.company.update({
        where: { id: firm.id },
        data: { nationalId: sealed(cin), nationalIdIndex: blind('cin', cin) },
      }),
    );
    const ids = (body: Record<string, unknown>) =>
      (body.groups as { items: { id: string }[] }[]).flatMap((g) => g.items.map((i) => i.id));

    const ops = await admin('COMPLIANCE');
    const full = await ops.client.call('GET', `/v1/search?q=${cin}`);
    expect(ids(full.body)).toContain(firm.id);
    const partial = await ops.client.call('GET', `/v1/search?q=${cin.slice(0, 6)}`);
    expect(ids(partial.body)).not.toContain(firm.id);
    for (const subRole of ['SUPER_ADMIN', 'FINANCE', 'SUPPORT'] as const) {
      const other = await admin(subRole);
      const result = await other.client.call('GET', `/v1/search?q=${cin}`);
      expect(result.status).toBe(200);
      expect(ids(result.body)).not.toContain(firm.id);
    }
    const audited = await db.system((tx) =>
      tx.auditLog.findMany({ where: { action: 'search.identifier' } }),
    );
    expect(audited.length).toBeGreaterThan(0);
    expect(audited.every((entry) => !entry.target.includes(cin))).toBe(true);
  });

  it('answers in less than 200 ms over 10 000 rows', async () => {
    const { company: firm, owner } = await company();
    await db.system(
      (tx) => tx.$executeRaw`
        INSERT INTO employees (id, company_id, employee_number, first_name, last_name, email, phone, status)
        SELECT gen_random_uuid(), ${firm.id}::uuid, 'V-' || g, 'Prénom' || g, 'Nom' || (g % 997),
               'v' || g || '@volume.test', 'x', 'ACTIVE'
          FROM generate_series(1, 10000) AS g`,
    );
    await db.system((tx) => tx.$executeRaw`ANALYZE employees`);
    const support = await admin('SUPER_ADMIN');
    const timings: number[] = [];
    for (const [client, q] of [
      [owner, 'Nom42'],
      [owner, 'prenom 512'],
      [support.client, 'Nom42'],
      [support.client, 'nmo421'],
    ] as const) {
      // One warm-up call per query, then the measure.
      await client.call('GET', `/v1/search?q=${encodeURIComponent(q)}`);
      const started = performance.now();
      const result = await client.call('GET', `/v1/search?q=${encodeURIComponent(q)}`);
      timings.push(performance.now() - started);
      expect(result.status).toBe(200);
    }
    expect(Math.max(...timings)).toBeLessThan(200);
  }, 60_000);
});

describe('search in the apps (history, day of the shop)', () => {
  it('a beneficiary finds its payment by reference or amount; a shop by amount', async () => {
    const { merchant, owner } = await shop();
    const paid = await payment(merchant.id);
    const app = await mobileClient(paid.employeeId);
    const ids = (body: Record<string, unknown>) =>
      (body.data as { reference: string }[]).map((row) => row.reference);
    expect(ids((await app.call('GET', '/v1/employee/operations?q=12,5')).body)).toContain(
      paid.reference,
    );
    expect(
      ids((await app.call('GET', `/v1/employee/operations?q=${paid.reference.slice(0, 7)}`)).body),
    ).toContain(paid.reference);
    expect(ids((await app.call('GET', '/v1/employee/operations?q=99,999')).body)).toEqual([]);
    const day = await owner.call('GET', '/v1/merchant/payments?q=12.500');
    expect((day.body.data as { reference: string }[]).map((row) => row.reference)).toContain(
      paid.reference,
    );
  });
});

/** A beneficiary signed in on the app (bearer token). */
async function mobileClient(employeeId: string) {
  const user = await createUser(db, env, 'EMPLOYEE', { employeeId }, 'Yasmine J.');
  await db.system((tx) => tx.user.update({ where: { id: user.id }, data: { mfaSecretEnc: null } }));
  const deviceId = `device-${randomUUID()}`;
  const login = await fetch(`${base}/v1/mobile/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ identifier: user.email, password: PASSWORD, deviceId }),
  });
  const session = (await login.json()) as { accessToken: string };
  return {
    async call(method: string, path: string, body?: unknown) {
      const response = await fetch(base + path, {
        method,
        headers: {
          Authorization: `Bearer ${session.accessToken}`,
          ...(body === undefined ? {} : { 'Content-Type': 'application/json' }),
        },
        ...(body === undefined ? {} : { body: JSON.stringify(body) }),
      });
      const text = await response.text();
      return {
        status: response.status,
        body: (text === '' ? {} : JSON.parse(text)) as Record<string, unknown>,
      };
    },
  };
}
