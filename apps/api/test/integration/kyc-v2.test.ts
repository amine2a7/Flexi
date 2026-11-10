// KYC file filed by the client (processus v2, bug 2): « Compte › Mon dossier », a status per
// document, a correction asked per document, validation once the four are there.
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { loadTestEnv } from './setup.js';
import { listen } from './http.js';

loadTestEnv();
const { loadEnv } = await import('../../src/config/env.js');
const { createApp } = await import('../../src/app.factory.js');
const { DbService } = await import('../../src/common/db.service.js');
const { createUser, seedSettings, signedIn } = await import('./fixtures.js');

const env = loadEnv();
const db = new DbService(env);
const app = await createApp(env, false);
let base = '';

const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  'base64',
);

beforeAll(async () => {
  await seedSettings(db);
  base = await listen(app);
});
afterAll(async () => {
  await app.close();
  await db.onModuleDestroy();
});

function document(type: string, file: Buffer = PNG, name = 'piece.png'): FormData {
  const form = new FormData();
  form.set('type', type);
  form.set('document', new Blob([file]), name);
  return form;
}

describe('KYC file filed by the client', () => {
  it('files 4 documents, gets a correction, files again, is validated, then orders', async () => {
    const operations = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Amine O.', 'SUPER_ADMIN'),
    );
    const created = await operations.call('POST', '/v1/admin/companies', {
      body: {
        name: `Carthage ${String(Date.now())}`,
        legalForm: 'PM_MF',
        city: 'Tunis',
        phone: '+21671000001',
        email: `ahmed-${String(Date.now())}@carthage.tn`,
        commissionGrid: [{ rateBps: 300, minMillimes: null, maxMillimes: null }],
      },
    });
    expect(created.status).toBe(201);
    const companyId = String(created.body.id);
    const owner = await signedIn(
      base,
      await createUser(db, env, 'COMPANY', { companyId }, 'Ahmed B.'),
    );

    const empty = await owner.call('GET', '/v1/account/kyc');
    expect((empty.body.documents as { status: string }[]).map((piece) => piece.status)).toEqual([
      'MISSING',
      'MISSING',
      'MISSING',
      'MISSING',
    ]);
    // Before the validation, no order (clear refusal).
    const early = await owner.call('POST', '/v1/company/order-quotes', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 1_000_000 }] },
    });
    expect(early.status).toBe(409);
    expect(early.body.details).toMatchObject({ reason: 'KYC_NOT_APPROVED' });

    // Another format, or more than 5 MB: refused.
    const text = await owner.call('POST', '/v1/account/kyc/documents', {
      form: document('MANAGER_ID', Buffer.from('hello'), 'cin.txt'),
    });
    expect(text.status).toBe(415);
    const heavy = await owner.call('POST', '/v1/account/kyc/documents', {
      form: document('MANAGER_ID', Buffer.concat([PNG, Buffer.alloc(5 * 1024 * 1024)])),
    });
    expect(heavy.status).toBe(413);

    for (const type of ['REGISTRY_EXTRACT', 'TAX_CERTIFICATE', 'MANAGER_ID', 'BANK_DETAILS'])
      expect(
        (await owner.call('POST', '/v1/account/kyc/documents', { form: document(type) })).status,
      ).toBe(201);

    const compliance = await signedIn(
      base,
      await createUser(db, env, 'ADMIN', {}, 'Nour C.', 'COMPLIANCE'),
    );
    const fileId = String((await owner.call('GET', '/v1/account/kyc')).body.id);
    const file = await compliance.call('GET', `/v1/admin/kyc-files/${fileId}`);
    const pieces = file.body.pieces as { type: string; documentId: string }[];
    const managerId = pieces.find((piece) => piece.type === 'MANAGER_ID')?.documentId ?? '';
    const asked = await compliance.call('POST', `/v1/admin/kyc-files/${fileId}/corrections`, {
      body: {
        corrections: [{ documentId: managerId, reason: 'CIN illisible, merci de la redéposer.' }],
      },
    });
    expect(asked.status).toBe(200);
    // A document to correct: no validation yet.
    expect((await compliance.call('POST', `/v1/admin/kyc-files/${fileId}/approve`)).status).toBe(
      409,
    );
    const mine = await owner.call('GET', '/v1/account/kyc');
    expect(mine.body.documents).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          type: 'MANAGER_ID',
          status: 'TO_CORRECT',
          correctionReason: 'CIN illisible, merci de la redéposer.',
        }),
      ]),
    );
    expect(
      (await owner.call('POST', '/v1/account/kyc/documents', { form: document('MANAGER_ID') }))
        .status,
    ).toBe(201);
    const approved = await compliance.call('POST', `/v1/admin/kyc-files/${fileId}/approve`);
    expect(approved.status).toBe(200);
    expect(
      (approved.body.pieces as { status: string }[]).every((piece) => piece.status === 'VALIDATED'),
    ).toBe(true);
    const quote = await owner.call('POST', '/v1/company/order-quotes', {
      body: { lines: [{ creditType: 'RESTAURATION', amountMillimes: 1_000_000 }] },
    });
    expect(quote.status).toBe(200);
  });
});
