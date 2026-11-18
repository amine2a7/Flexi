// TEST-FIRST (SEC-1): security of the storage, over HTTP and in the database itself.
import { createHmac, randomInt, randomUUID } from 'node:crypto';
import { hash } from '@node-rs/argon2';
import { Logger } from '@nestjs/common';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { appClient, loadTestEnv, ownerClient } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { LedgerService, accounts } = await import('../../src/ledger/ledger.service.js');
const { JobsService } = await import('../../src/jobs/jobs.service.js');
const { PASSWORD, createCompany, createUser, gridBody, seedSettings, signedIn } =
  await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
// Logs on: everything the API writes is captured below.
const app = await createApp(env, true);
const ledger = new LedgerService();
let base = '';

/** Everything the API writes on stdout and stderr during this file (kept out of the console). */
const written: string[] = [];
const capture = (stream: NodeJS.WriteStream) =>
  vi.spyOn(stream, 'write').mockImplementation((chunk: string | Uint8Array) => {
    written.push(String(chunk));
    return true;
  });
let spies: ReturnType<typeof capture>[] = [];

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
  spies = [capture(process.stdout), capture(process.stderr)];
});
afterAll(async () => {
  for (const spy of spies) spy.mockRestore();
  await app.close();
  await db.onModuleDestroy();
});

// Smallest valid PNG.
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  'base64',
);

const cin = () => String(randomInt(10_000_000, 99_999_999));

async function merchantWith(nationalId: string) {
  const admin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Amine K.'));
  return admin.call('POST', '/v1/admin/merchants', {
    body: {
      name: `Épicerie ${randomUUID().slice(0, 8)}`,
      category: 'GROCERY',
      city: 'Tunis',
      phone: '+21671000000',
      email: `epicerie-${randomUUID().slice(0, 6)}@test.tn`,
      legalForm: 'PP_CIN',
      nationalId,
      commissionGrid: gridBody(),
      acceptedCreditTypes: ['RESTAURATION'],
    },
  });
}

describe('personal data at rest (SEC-1)', () => {
  it('a CIN number is never readable in clear in the database, and goes out masked', async () => {
    const number = cin();
    const created = await merchantWith(number);
    expect(created.status).toBe(201);
    const id = String(created.body.id);
    const owner = await ownerClient();
    try {
      const row = await owner.query<{ line: string; national_id: string; index: string }>(
        `SELECT row_to_json(m)::text AS line, national_id, national_id_index AS index
           FROM merchants m WHERE id = $1`,
        [id],
      );
      const stored = row.rows[0];
      expect(stored?.line).not.toContain(number);
      expect(stored?.national_id.startsWith('v2.')).toBe(true);
      expect(stored?.index).toMatch(/^[0-9a-f]{64}$/);
    } finally {
      await owner.end();
    }
    const superAdmin = await signedIn(base, await createUser(db, env, 'ADMIN', {}, 'Sarra F.'));
    const record = await superAdmin.call('GET', `/v1/admin/merchants/${id}/record`);
    expect(record.body.maskedNationalId).toBe(`•••• ${number.slice(-4)}`);
    expect(JSON.stringify(record.body)).not.toContain(number);
  });

  it('the same CIN for a second shop is refused, found by its blind index', async () => {
    const number = cin();
    expect((await merchantWith(number)).status).toBe(201);
    const again = await merchantWith(number);
    expect(again.status).toBe(409);
    expect(again.body.details).toMatchObject({ reason: 'IDENTIFIER_IN_USE', field: 'nationalId' });
    // The database itself refuses it, even past the API (two requests at the same moment).
    const owner = await ownerClient();
    try {
      const [first] = (
        await owner.query<{ national_id_index: string }>(
          'SELECT national_id_index FROM merchants WHERE national_id_index IS NOT NULL LIMIT 1',
        )
      ).rows;
      await expect(
        owner.query(
          `UPDATE merchants SET national_id_index = $1
            WHERE id = (SELECT id FROM merchants
                         WHERE national_id_index IS DISTINCT FROM $1 LIMIT 1)`,
          [first?.national_id_index],
        ),
      ).rejects.toMatchObject({ code: '23505' });
    } finally {
      await owner.end();
    }
  });

  it('only Opérations reads the identifiers in clear, on the KYC file', async () => {
    const number = cin();
    const created = await merchantWith(number);
    const merchantId = String(created.body.id);
    const file = await db.system((tx) =>
      tx.kycFile.findFirstOrThrow({ where: { merchantId }, select: { id: true } }),
    );
    const operations = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Sonia O.', 'COMPLIANCE'),
    );
    const finance = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Karim F.', 'FINANCE'),
    );
    const seen = await operations.call('GET', `/v1/admin/kyc-files/${file.id}`);
    expect(seen.body.identifiers).toMatchObject({ nationalId: number });
    const masked = await finance.call('GET', `/v1/admin/kyc-files/${file.id}`);
    expect(masked.body.identifiers).toBeUndefined();
    expect(masked.body.maskedIdentifiers).toMatchObject({ nationalId: `•••• ${number.slice(-4)}` });
    expect(JSON.stringify(masked.body)).not.toContain(number);
  });

  it('a former password hash (no pepper) is replaced at the next good sign-in', async () => {
    const user = await createUser(db, env, 'ADMIN', {}, 'Ancien H.');
    const former = await hash(PASSWORD, { memoryCost: 19_456, timeCost: 2, parallelism: 1 });
    await db.system((tx) =>
      tx.user.update({ where: { id: user.id }, data: { passwordHash: former } }),
    );
    await signedIn(base, user);
    const stored = await db.system((tx) =>
      tx.user.findUniqueOrThrow({ where: { id: user.id }, select: { passwordHash: true } }),
    );
    expect(stored.passwordHash.startsWith('$argon2id$v=19$m=65536,t=3,p=1$')).toBe(true);
  });
});

describe('ledger and audit append only, hash chains (SEC-1)', () => {
  async function postOnce() {
    const reference = `SEC1-${randomUUID().slice(0, 8)}`;
    const company = await createCompany(db);
    await db.system(async (tx) => {
      const posted = await ledger.post(tx, {
        type: 'ALLOCATION',
        reference,
        entries: [
          { account: accounts.bankEscrow(), direction: 'D', amount: 1_000n },
          {
            account: accounts.companyWallet(company.id, 'RESTAURATION'),
            direction: 'C',
            amount: 1_000n,
          },
        ],
      });
      return posted;
    });
    const owner = await ownerClient();
    try {
      const rows = await owner.query<{ id: string }>(
        `SELECT e.id::text AS id FROM ledger_entries e
           JOIN ledger_transactions t ON t.id = e.transaction_id
          WHERE t.reference = $1 ORDER BY e.id`,
        [reference],
      );
      return rows.rows.map((row) => row.id);
    } finally {
      await owner.end();
    }
  }

  it('fp_app can neither change nor delete a ledger line nor an audit entry, and has no DDL', async () => {
    const [entry] = await postOnce();
    const client = await appClient();
    try {
      await expect(
        client.query('UPDATE ledger_entries SET amount_millimes = 1 WHERE id = $1', [entry]),
      ).rejects.toMatchObject({ code: '42501' });
      await expect(
        client.query('DELETE FROM ledger_entries WHERE id = $1', [entry]),
      ).rejects.toMatchObject({ code: '42501' });
      await expect(
        client.query("UPDATE audit_log SET target = 'x' WHERE false"),
      ).rejects.toMatchObject({ code: '42501' });
      await expect(client.query('CREATE TABLE sec1_probe (id int)')).rejects.toMatchObject({
        code: '42501',
      });
      // The API never connects as a superuser.
      const role = await client.query<{ rolsuper: boolean; rolbypassrls: boolean }>(
        'SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user',
      );
      expect(role.rows[0]).toEqual({ rolsuper: false, rolbypassrls: false });
    } finally {
      await client.end();
    }
  });

  it('a ledger line or an audit entry changed by hand is caught by the nightly reconciliation', async () => {
    const [entry] = await postOnce();
    expect((await db.system((tx) => ledger.reconcile(tx))).ledgerChainBreaks).toEqual([]);
    const owner = await ownerClient();
    const tamper = async (sql: string, values: unknown[]) => {
      await owner.query('BEGIN');
      // Past the append-only triggers, as an intruder with the superuser would do.
      await owner.query('SET LOCAL session_replication_role = replica');
      await owner.query(sql, values);
      await owner.query('COMMIT');
    };
    const [audit] = (
      await owner.query<{ id: string; target: string }>(
        'SELECT id::text AS id, target FROM audit_log ORDER BY occurred_at DESC LIMIT 1',
      )
    ).rows;
    try {
      await tamper(
        "UPDATE ledger_entries SET created_at = created_at + interval '1 second' WHERE id = $1",
        [entry],
      );
      const broken = await db.system((tx) => ledger.reconcile(tx));
      expect(broken.ok).toBe(false);
      expect(broken.ledgerChainBreaks).toEqual([String(entry)]);
      // The existing alert of the nightly reconciliation: audit entry naming the line, first.
      expect(await app.get(JobsService).reconcileBooks()).toBe(false);
      const logged = await db.system((tx) =>
        tx.auditLog.findFirst({
          where: { action: 'ledger.reconcileFailed' },
          orderBy: { occurredAt: 'desc' },
        }),
      );
      expect(logged?.target.startsWith(`chaîne grand livre #${String(entry)}`)).toBe(true);
      const raised = await db.system((tx) =>
        tx.fraudAlert.findFirst({ where: { kind: 'LEDGER_MISMATCH' } }),
      );
      expect(raised).toMatchObject({ severity: 'HIGH' });

      await tamper('UPDATE audit_log SET target = $2 WHERE id = $1::uuid', [
        audit?.id,
        `${audit?.target ?? ''}!`,
      ]);
      expect((await db.system((tx) => ledger.reconcile(tx))).auditChainBreaks).toEqual([audit?.id]);
    } finally {
      // Put back as it was: the chains hold again.
      await tamper(
        "UPDATE ledger_entries SET created_at = created_at - interval '1 second' WHERE id = $1",
        [entry],
      );
      await tamper('UPDATE audit_log SET target = $2 WHERE id = $1::uuid', [
        audit?.id,
        audit?.target,
      ]);
      await owner.end();
    }
    const repaired = await db.system((tx) => ledger.reconcile(tx));
    expect(repaired.ledgerChainBreaks).toEqual([]);
    expect(repaired.auditChainBreaks).toEqual([]);
  });
});

describe('KYC pieces by signed link (SEC-1)', () => {
  it('a link works 5 minutes for the administrator who asked; expired or borrowed, it is refused', async () => {
    const operations = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Nour C.', 'COMPLIANCE'),
    );
    const created = await operations.call('POST', '/v1/admin/companies', {
      body: {
        name: `Carthage ${randomUUID().slice(0, 8)}`,
        legalForm: 'PM_MF',
        city: 'Tunis',
        phone: '+21671000001',
        email: `ahmed-${randomUUID().slice(0, 6)}@carthage.tn`,
        commissionGrid: gridBody(),
      },
    });
    const companyId = String(created.body.id);
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId }, 'Ahmed B.'),
    );
    const form = new FormData();
    form.set('type', 'REGISTRY_EXTRACT');
    form.set('document', new Blob([PNG]), 'rne.png');
    expect((await owner.call('POST', '/v1/account/kyc/documents', { form })).status).toBe(201);
    const fileId = String((await owner.call('GET', '/v1/account/kyc')).body.id);
    const reviewer = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Leila R.', 'COMPLIANCE'),
    );
    const file = await reviewer.call('GET', `/v1/admin/kyc-files/${fileId}`);
    const documentId = String((file.body.documents as { id: string }[])[0]?.id);
    const path = `/v1/admin/kyc-files/${fileId}/documents/${documentId}`;

    // Without a link: refused.
    expect((await reviewer.call('GET', path)).status).toBe(400);
    const link = await reviewer.call('GET', `${path}/link`);
    expect(link.status).toBe(200);
    const expires = Number(link.body.expires);
    expect(expires * 1000 - Date.now()).toBeLessThanOrEqual(5 * 60_000);
    const download = await fetch(`${base}${String(link.body.url)}`, {
      headers: { Cookie: reviewer.cookieHeader('/v1/admin') },
    });
    expect(download.status).toBe(200);
    expect(Buffer.from(await download.arrayBuffer()).equals(PNG)).toBe(true);

    // Borrowed by another administrator: refused.
    const other = await fetch(`${base}${String(link.body.url)}`, {
      headers: { Cookie: operations.cookieHeader('/v1/admin') },
    });
    expect(other.status).toBe(403);

    // Expired (signed like a real one, 1 second in the past): refused.
    const me = await reviewer.call('GET', '/v1/me');
    const past = Math.floor(Date.now() / 1000) - 1;
    const signature = createHmac('sha256', Buffer.from(env.FILE_LINK_SECRET, 'base64'))
      .update(`kyc-document|${fileId}|${documentId}|${String(me.body.id)}|${String(past)}`)
      .digest('base64url');
    const expired = await reviewer.call(
      'GET',
      `${path}?expires=${String(past)}&signature=${signature}`,
    );
    expect(expired.status).toBe(403);
    expect(expired.body.code).toBe('FORBIDDEN');
  });
});

describe('logs (SEC-1)', () => {
  it('no password, PIN, token, CIN nor RIB is ever written in the logs', async () => {
    const number = cin();
    const iban = 'TN5910006035183598470014';
    const user = await createUser(db, env, 'ADMIN', {}, 'Logs L.');
    const client = await signedIn(base, user);
    await merchantWith(number);
    await fetch(`${base}/v1/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Origin: env.webOrigins[0] ?? '' },
      body: JSON.stringify({ identifier: user.email, password: 'Faux-mot-de-passe-2026' }), // gitleaks:allow (test-only value)
    });
    const access = client.cookie('__Host-fp_at') ?? '';
    // Even a careless line goes through the mask.
    new Logger('Sec1').error(
      `password=${PASSWORD} pin: 4827 token=${access} cin ${number} iban ${iban} rib ${iban.slice(4)} Bearer ${access}`,
    );
    const logs = written.join('');
    expect(logs).toContain('[masqué]');
    for (const secret of [PASSWORD, number, iban, iban.slice(4), access, '4827'])
      expect(logs).not.toContain(secret);
  });
});
