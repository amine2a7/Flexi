// Demo data (request of 2026-11-05): from an EMPTY database, ONE example of each situation, with
// Tunisian names (table: docs/demo/donnees-demo.md). The structure (settings, companies, shops,
// employees, accounts) is written here; every amount then goes through the real API, started in
// this process: orders, allocations, payments, payouts, batches and the simulated bank, so the
// ledger only holds business entries. The seed fails when the books do not reconcile.
//   pnpm demo  (or: pnpm --filter @flexipay/api db:reset && pnpm --filter @flexipay/api db:seed)
// Never against staging or production: localhost and NODE_ENV other than production only.
import { crc32, deflateSync } from 'node:zlib';
import { PrismaPg } from '@prisma/adapter-pg';
import { hashSecret } from '../src/auth/password.js';
import { newSecretBase32 } from '../src/auth/totp.js';
import { encryptSecret } from '../src/common/crypto.js';
import { sealPii } from '../src/common/pii.js';
import { LocalDiskStorage } from '../src/common/storage.js';
import { databaseUrls, PG_SESSION_OPTIONS } from '../src/config/database-urls.js';
import { loadEnv } from '../src/config/env.js';
import { PrismaClient } from '../src/generated/prisma/client.js';
import type { CreditType, SubRole } from '../src/generated/prisma/enums.js';
import { WebClient, type Body } from './demo/web-client.js';

const PASSWORD = 'Test1234!';
const MFA = '123456';
const PIN = '1234';
const DAY = 86_400_000;
const TND = (dinars: number) => dinars * 1000;

// ------------------------------------------------------------------ guards

// The demo accounts sign in with the fixed code (development only, refused in production).
process.env.DEMO_FIXED_MFA_CODE ??= MFA;
const env = loadEnv();
const urls = databaseUrls(process.env);
if (env.NODE_ENV === 'production') throw new Error('db:seed never runs in production');
if (!['localhost', '127.0.0.1', '::1'].includes(new URL(urls.adminUrl).hostname)) {
  throw new Error('db:seed only runs against a local PostgreSQL (localhost)');
}
const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: urls.migrationUrl, options: PG_SESSION_OPTIONS }),
});
const [marked] = await prisma.$queryRaw<
  { environment: string | null }[]
>`SELECT current_setting('app.environment', true) AS environment`;
if (marked?.environment !== 'development') {
  console.error('This database is not marked as a development one (run db:reset): no seed.');
  await prisma.$disconnect();
  process.exit(1);
}
if ((await prisma.user.count()) > 0) {
  console.error('The database already has data: run `pnpm demo:reset` (or db:reset) first.');
  await prisma.$disconnect();
  process.exit(1);
}

const dataKey = Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64');
const seal = (value: string) => sealPii(dataKey, value);
const passwordHash = await hashSecret(PASSWORD);
const pinHash = await hashSecret(PIN);
const storage = new LocalDiskStorage(env.uploadDir);

/** Grey placeholder page (PNG): KYC pieces and transfer proofs of the demo. */
function placeholderPng(width = 240, height = 320): Buffer {
  const raw = Buffer.alloc((width + 1) * height, 0xff);
  for (let y = 0; y < height; y += 1) {
    raw[y * (width + 1)] = 0;
    if (y >= 24 && y < 48) raw.fill(0x40, y * (width + 1) + 25, (y + 1) * (width + 1) - 24);
  }
  const chunk = (type: string, data: Buffer) => {
    const length = Buffer.alloc(4);
    length.writeUInt32BE(data.length);
    const body = Buffer.concat([Buffer.from(type, 'ascii'), data]);
    const crc = Buffer.alloc(4);
    crc.writeUInt32BE(crc32(body));
    return Buffer.concat([length, body, crc]);
  };
  const header = Buffer.alloc(13);
  header.writeUInt32BE(width, 0);
  header.writeUInt32BE(height, 4);
  header[8] = 8;
  return Buffer.concat([
    Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk('IHDR', header),
    chunk('IDAT', deflateSync(raw)),
    chunk('IEND', Buffer.alloc(0)),
  ]);
}
const png = placeholderPng();
const pngKey = await storage.put(png);

// ------------------------------------------------------------------ 1. structure (no money)

const ids = await prisma.$transaction(async (tx) => {
  await tx.platformSettings.create({
    data: {
      id: 1,
      payoutMinimumMillimes: BigInt(TND(50)),
      creditValidityMonths: 12,
      maxFamilyMembers: 4,
      orderFeeRateBps: 500,
    },
  });
  const types: [CreditType, number, number, number][] = [
    ['RESTAURATION', 200, 12, TND(150)],
    ['HABILLEMENT', 250, 12, TND(500)],
    ['CARBURANT', 150, 6, TND(200)],
    ['CADEAUX', 300, 12, TND(300)],
  ];
  await tx.creditTypeSetting.createMany({
    data: types.map(([creditType, rate, months, limit]) => ({
      creditType,
      enabled: true,
      commissionRateBps: rate,
      validityMonths: months,
      dailyLimitMillimes: BigInt(limit),
    })),
  });

  // A grid line: the default one (no bounds) or a tranche in TND, both bounds included.
  const grid = (lines: [number, number?, number?][]) => ({
    create: [
      {
        tiers: {
          create: lines.map(([rateBps, min, max], position) => ({
            position,
            rateBps,
            minMillimes: min === undefined ? null : BigInt(TND(min)),
            maxMillimes: max === undefined ? null : BigInt(TND(max)),
          })),
        },
      },
    ],
  });
  const company = (name: string, city: string, status: 'APPROVED' | 'PENDING_KYC' | 'SUSPENDED') =>
    tx.company.create({
      data: {
        name,
        city,
        phone: seal('+21671234567'),
        email: `contact@${name.toLowerCase().replace(/[^a-z]+/g, '-')}.tn`,
        status,
        commissionGrids: grid([[500], [300, 15_000, 18_000]]),
      },
    });
  const carthage = await company('Groupe Carthage Services', 'Tunis', 'APPROVED');
  const sfax = await company('Société Sfax Industries', 'Sfax', 'PENDING_KYC');
  const sousse = await company('Sousse Logistique', 'Sousse', 'SUSPENDED');

  let code = 401_000;
  const shop = (
    name: string,
    city: string,
    category: 'RESTAURANT' | 'CLOTHING' | 'FUEL_STATION' | 'GIFT_SHOP' | 'BAKERY' | 'CAFE',
    type: CreditType,
    options: { rateBps?: number; iban?: string | null; status?: 'APPROVED' | 'PENDING_KYC' } = {},
  ) =>
    tx.merchant.create({
      data: {
        name,
        city,
        category,
        address: `Avenue Habib Bourguiba, ${city}`,
        phone: seal('+21698765432'),
        email: `contact@${name.toLowerCase().replace(/[^a-z]+/g, '-')}.tn`,
        status: options.status ?? 'APPROVED',
        acceptedCreditTypes: [type],
        paymentCode: String((code += 1)),
        iban: options.iban === null ? null : seal(options.iban ?? 'TN5908006000671234567891'),
        ...(options.rateBps === undefined ? {} : { commissionGrids: grid([[options.rateBps]]) }),
      },
    });
  const darElJeld = await shop('Restaurant Dar El Jeld', 'Tunis', 'RESTAURANT', 'RESTAURATION', {
    rateBps: 200,
    iban: 'TN5910006035183598478831',
  });
  const zarzis = await shop('Boutique Zarzis Mode', 'Djerba', 'CLOTHING', 'HABILLEMENT', {
    rateBps: 250,
    iban: 'TN5904018104003691234821',
  });
  const agil = await shop('Station Agil Lac 2', 'Tunis', 'FUEL_STATION', 'CARBURANT', {
    rateBps: 150,
    iban: 'TN5925079000000123456789',
  });
  // An IBAN ending with 0000: the simulated bank rejects the transfer (case « rejeté »).
  const kitab = await shop('Librairie Al Kitab', 'Bizerte', 'GIFT_SHOP', 'CADEAUX', {
    rateBps: 300,
    iban: 'TN5903003000123456780000',
  });
  const masmoudi = await shop('Pâtisserie Masmoudi', 'Sfax', 'BAKERY', 'RESTAURATION', {
    rateBps: 200,
    iban: null,
    status: 'PENDING_KYC',
  });
  // No grid (« Grille à vérifier »): its first payment is refused and raises the alert.
  const sidiBou = await shop('Café Sidi Bou Saïd', 'Sidi Bou Saïd', 'CAFE', 'RESTAURATION');

  const departments = await Promise.all(
    ['Direction', 'Ressources humaines', 'Logistique'].map((name) =>
      tx.department.create({ data: { companyId: carthage.id, name } }),
    ),
  );
  const employee = (
    number: string,
    firstName: string,
    lastName: string,
    status: 'ACTIVE' | 'INVITED' | 'SUSPENDED',
    department: number,
  ) =>
    tx.employee.create({
      data: {
        companyId: carthage.id,
        employeeNumber: number,
        firstName,
        lastName,
        email: `${firstName.toLowerCase()}.${lastName.toLowerCase().replace(/ /g, '')}@carthage.tn`,
        phone: seal(`+2162${number.slice(-7).padStart(7, '0')}`),
        status,
        departmentId: departments[department]?.id ?? null,
        ...(status === 'ACTIVE' ? { pinHash } : {}),
      },
    });
  const yasmine = await employee('EMP-1001', 'Yasmine', 'Jaziri', 'ACTIVE', 0);
  const mehdi = await employee('EMP-1002', 'Mehdi', 'Trabelsi', 'INVITED', 1);
  const sana = await employee('EMP-1003', 'Sana', 'Ben Ali', 'INVITED', 1);
  const hichem = await employee('EMP-1004', 'Hichem', 'Gharbi', 'SUSPENDED', 2);

  // Accounts: one per role and sub-role, same password, MFA enrolled (fixed demo code).
  const user = (
    email: string,
    displayName: string,
    role: 'ADMIN' | 'COMPANY' | 'MERCHANT' | 'EMPLOYEE',
    subRole: SubRole | null,
    tenant: { companyId?: string; merchantId?: string; employeeId?: string },
    invitation?: { expiresAt: Date },
  ) =>
    tx.user.create({
      data: {
        email,
        displayName,
        role,
        subRole,
        passwordHash,
        mustChangePassword: invitation !== undefined,
        tempPasswordExpiresAt: invitation?.expiresAt ?? null,
        mfaSecretEnc: invitation === undefined ? encryptSecret(dataKey, newSecretBase32()) : null,
        ...tenant,
      },
    });
  const now = Date.now();
  await user('admin@flexipay.test', 'Amine K.', 'ADMIN', 'SUPER_ADMIN', {});
  await user('operations@flexipay.test', 'Sonia B.', 'ADMIN', 'COMPLIANCE', {});
  const financeUser = await user('admin2@flexipay.test', 'Hela R.', 'ADMIN', 'FINANCE', {});
  await user('support@flexipay.test', 'Karim T.', 'ADMIN', 'SUPPORT', {});
  await user('entreprise@flexipay.test', 'Leïla M.', 'COMPANY', 'OWNER', {
    companyId: carthage.id,
  });
  await user('rh@flexipay.test', 'Nour H.', 'COMPANY', 'MANAGER', { companyId: carthage.id });
  await user('comptable@flexipay.test', 'Walid S.', 'COMPANY', 'ACCOUNTANT', {
    companyId: carthage.id,
  });
  await user(
    'premiere@flexipay.test',
    'Rim A.',
    'COMPANY',
    'READ_ONLY',
    { companyId: carthage.id },
    {
      expiresAt: new Date(now + 7 * DAY),
    },
  );
  await user('commercant@flexipay.test', 'Sami B.', 'MERCHANT', 'OWNER', {
    merchantId: darElJeld.id,
  });
  await user('caissier@flexipay.test', 'Aya K.', 'MERCHANT', 'CASHIER', {
    merchantId: darElJeld.id,
  });
  // Managers of the other shops (they request the payouts of the demo).
  await user('zarzis@flexipay.test', 'Mounir Z.', 'MERCHANT', 'OWNER', { merchantId: zarzis.id });
  await user('agil@flexipay.test', 'Fatma L.', 'MERCHANT', 'OWNER', { merchantId: agil.id });
  await user('kitab@flexipay.test', 'Ali K.', 'MERCHANT', 'OWNER', { merchantId: kitab.id });
  await user('beneficiaire@flexipay.test', 'Yasmine J.', 'EMPLOYEE', null, {
    employeeId: yasmine.id,
  });
  // Invited (valid 7 days), invitation expired, suspended.
  await user(
    'mehdi.trabelsi@carthage.tn',
    'Mehdi T.',
    'EMPLOYEE',
    null,
    { employeeId: mehdi.id },
    {
      expiresAt: new Date(now + 7 * DAY),
    },
  );
  await user(
    'sana.benali@carthage.tn',
    'Sana B.',
    'EMPLOYEE',
    null,
    { employeeId: sana.id },
    {
      expiresAt: new Date(now - 2 * DAY),
    },
  );
  await tx.user.create({
    data: {
      email: 'hichem.gharbi@carthage.tn',
      displayName: 'Hichem G.',
      role: 'EMPLOYEE',
      passwordHash,
      status: 'SUSPENDED',
      employeeId: hichem.id,
    },
  });

  // KYC files waiting for a decision (company and shop).
  for (const owner of [
    { accountType: 'COMPANY' as const, companyId: sfax.id },
    { accountType: 'MERCHANT' as const, merchantId: masmoudi.id },
  ]) {
    await tx.kycFile.create({
      data: {
        ...owner,
        // Opened by Finance: the super-admin and Opérations can decide it (four eyes).
        createdBy: financeUser.id,
        documents: {
          create: (['REGISTRY_EXTRACT', 'TAX_CERTIFICATE', 'MANAGER_ID'] as const).map((type) => ({
            type,
            fileName: `${type.toLowerCase()}.png`,
            contentType: 'image/png',
            sizeBytes: png.length,
            storageKey: pngKey,
          })),
        },
        events: { create: [{ action: 'SUBMITTED', actorName: 'Système' }] },
      },
    });
  }
  return { carthage, sousse, darElJeld, zarzis, agil, kitab, sidiBou, yasmine, sfax, masmoudi };
});

// ------------------------------------------------------------------ 2. money, through the API

const { createApp } = await import('../src/app.factory.js');
const { PayoutsService } = await import('../src/payouts/payouts.service.js');
const { DbService } = await import('../src/common/db.service.js');
const { LedgerService } = await import('../src/ledger/ledger.service.js');
const app = await createApp(env, false);
await app.listen(0, '127.0.0.1');
const address = app.getHttpServer().address() as { port: number };
const base = `http://127.0.0.1:${String(address.port)}`;
const origin = env.webOrigins[0] ?? 'http://localhost:3001';
const signIn = (email: string, password = PASSWORD) =>
  new WebClient(base, origin, email).signIn(email, password, MFA);

const admin = await signIn('admin@flexipay.test');
const finance = await signIn('admin2@flexipay.test');
const support = await signIn('support@flexipay.test');
const company = await signIn('entreprise@flexipay.test');
const beneficiary = await signIn('beneficiaire@flexipay.test');
const manager = await signIn('commercant@flexipay.test');
const zarzis = await signIn('zarzis@flexipay.test');
const agil = await signIn('agil@flexipay.test');
const kitab = await signIn('kitab@flexipay.test');

const references: Record<string, string> = {};
const proof = () => {
  const form = new FormData();
  form.set('transferReference', 'BIAT-778899');
  form.set('transferDate', new Date().toISOString().slice(0, 10));
  return form;
};
async function order(lines: [CreditType, number][]): Promise<Body> {
  return company.call('POST', '/v1/company/orders', {
    key: true,
    body: {
      lines: lines.map(([creditType, dinars]) => ({ creditType, amountMillimes: TND(dinars) })),
    },
  });
}
async function declare(created: Body): Promise<void> {
  const form = proof();
  form.set('amountMillimes', String(created.totalMillimes));
  form.set('proof', new Blob([png]), 'avis-de-virement.png');
  await company.call('POST', `/v1/company/orders/${String(created.id)}/transfer-declarations`, {
    form,
    key: true,
  });
}
const confirm = (created: Body) =>
  finance.call('POST', `/v1/admin/credit-orders/${String(created.id)}/confirm`, { key: true });
const validate = (created: Body, by: WebClient) =>
  by.call('POST', `/v1/admin/credit-orders/${String(created.id)}/validate`, { key: true });

// Orders: the validated one funds the company on the 4 types.
const funded = await order([
  ['RESTAURATION', 1_000],
  ['HABILLEMENT', 600],
  ['CARBURANT', 400],
  ['CADEAUX', 300],
]);
await confirm(funded);
await declare(funded);
await validate(funded, admin);
references.validated = String(funded.reference);
const awaitingConfirmation = await order([['RESTAURATION', 500]]);
references.awaitingConfirmation = String(awaitingConfirmation.reference);
const awaitingPayment = await order([['RESTAURATION', 800]]);
await confirm(awaitingPayment);
references.awaitingPayment = String(awaitingPayment.reference);
const awaitingValidation = await order([['CADEAUX', 700]]);
await confirm(awaitingValidation);
await declare(awaitingValidation);
references.awaitingValidation = String(awaitingValidation.reference);
const firstValidation = await order([['RESTAURATION', 12_000]]);
await confirm(firstValidation);
await declare(firstValidation);
await validate(firstValidation, admin);
references.firstValidation = String(firstValidation.reference);
const refused = await order([['HABILLEMENT', 250]]);
await finance.call('POST', `/v1/admin/credit-orders/${String(refused.id)}/refuse`, {
  body: { reason: 'Montant différent du bon de commande signé.' },
});
references.refused = String(refused.reference);
const cancelled = await order([['CARBURANT', 300]]);
await company.call('POST', `/v1/company/orders/${String(cancelled.id)}/cancel`);
references.cancelled = String(cancelled.reference);
const proofRejected = await order([['RESTAURATION', 450]]);
await confirm(proofRejected);
await declare(proofRejected);
await finance.call('POST', `/v1/admin/credit-orders/${String(proofRejected.id)}/reject-proof`, {
  body: { reason: 'Avis de virement illisible : merci de le déposer à nouveau.' },
});
references.proofRejected = String(proofRejected.reference);
// Credit note: an order cancelled after its invoice was issued.
const creditNote = await order([['CADEAUX', 200]]);
await confirm(creditNote);
await company.call('POST', `/v1/company/orders/${String(creditNote.id)}/cancel`);
references.creditNote = String(creditNote.reference);
const expiredQuote = await order([['HABILLEMENT', 400]]);
references.expiredQuote = String(expiredQuote.reference);

// Allocation: the active employee gets credits on the 4 types.
await company.call('POST', '/v1/company/allocations', {
  key: true,
  body: {
    allocations: (
      [
        ['RESTAURATION', 300],
        ['HABILLEMENT', 400],
        ['CARBURANT', 300],
        ['CADEAUX', 300],
      ] as [CreditType, number][]
    ).map(([creditType, dinars]) => ({
      employeeId: ids.yasmine.id,
      creditType,
      amountMillimes: TND(dinars),
    })),
  },
});

// Payments of the beneficiary by shop code (PIN 1234).
const pay = (
  shop: { paymentCode: string },
  creditType: CreditType,
  dinars: number,
  expect: number[] = [],
) =>
  beneficiary.call('POST', '/v1/employee/payments', {
    key: true,
    expect,
    body: { merchantCode: shop.paymentCode, creditType, amountMillimes: TND(dinars), pin: PIN },
  });
const latestPayment = async (shop: WebClient) =>
  ((await shop.call('GET', '/v1/merchant/payments')).data as Body[])[0] ?? {};
await pay(ids.darElJeld, 'RESTAURATION', 80);
references.accepted = String((await latestPayment(manager)).reference);
await pay(ids.darElJeld, 'RESTAURATION', 25);
const toCancel = await latestPayment(manager);
await manager.call('POST', `/v1/merchant/payments/${String(toCancel.id)}/refund`, { key: true });
references.cancelledPayment = String(toCancel.reference);
await pay(ids.zarzis, 'HABILLEMENT', 150);
await pay(ids.agil, 'CARBURANT', 120);
await pay(ids.kitab, 'CADEAUX', 100);
// No grid: refused (422) and the alert « Grille de commission manquante » is raised.
await pay(ids.sidiBou, 'RESTAURATION', 10, [422]);
// Refused for an insufficient balance: the shop asks 300 TND, 250 TND are left.
const code = await beneficiary.call('POST', '/v1/employee/payment-codes');
const initiated = await zarzis.call('POST', '/v1/merchant/payments', {
  key: true,
  body: { customerCode: code.code, creditType: 'HABILLEMENT', amountMillimes: TND(300) },
});
const requests = (await beneficiary.call('GET', '/v1/employee/payment-requests')).data as Body[];
const request = requests.find((item) => item.amountMillimes === TND(300)) ?? {};
await beneficiary.call('POST', `/v1/employee/payment-requests/${String(request.id)}/confirm`, {
  key: true,
  expect: [422],
  body: { pin: PIN },
});
await beneficiary.call('POST', `/v1/employee/payment-requests/${String(request.id)}/refuse`);
references.refusedPayment = String(initiated.reference);

// Payouts. Order matters: each release closes its batch, the next approval opens a new one.
async function requestPayout(shop: WebClient, creditType: CreditType, dinars: number) {
  const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
    body: { creditType, grossMillimes: TND(dinars) },
  });
  return shop.call('POST', '/v1/merchant/payouts', { key: true, body: { quoteId: quote.quoteId } });
}
async function release(payoutId: string): Promise<string> {
  const approved = await finance.call('POST', `/v1/admin/payout-requests/${payoutId}/approve`, {
    key: true,
  });
  const batchId = String(approved.batchId);
  const asked = await finance.call('POST', `/v1/admin/settlements/${batchId}/release-requests`, {
    body: { reason: 'Lot contrôlé, montants conformes aux relevés.' },
  });
  await admin.call('POST', `/v1/admin/approvals/${String(asked.id)}/approve`);
  return batchId;
}
const services = { payouts: app.get(PayoutsService) };
// 1. Rejected by the bank (IBAN ending 0000), then requested again by the shop.
const rejected = await requestPayout(kitab, 'CADEAUX', 100);
const rejectedBatch = await release(String(rejected.id));
await prisma.$executeRaw`UPDATE settlement_batches SET settlement_date = current_date
  WHERE id = ${rejectedBatch}::uuid`;
await services.payouts.executeDueBatches();
const again = await requestPayout(kitab, 'CADEAUX', 100);
references.bankRejected = String(rejected.reference);
references.requestedAgain = String(again.reference);
// 2. Released by Finance in four eyes (sent to the bank at its date).
const released = await requestPayout(agil, 'CARBURANT', 120);
await release(String(released.id));
references.released = String(released.reference);
// 3. Checked, in a scheduled batch.
const inBatch = await requestPayout(zarzis, 'HABILLEMENT', 150);
await finance.call('POST', `/v1/admin/payout-requests/${String(inBatch.id)}/approve`, {
  key: true,
});
references.inBatch = String(inBatch.reference);
// 4. Waiting for the administrator.
const pending = await requestPayout(manager, 'RESTAURATION', 80);
references.pendingPayout = String(pending.reference);

// Pending change requests (four eyes): a grid and a RIB.
await finance.call('POST', '/v1/admin/commission-grids/change-requests', {
  body: {
    merchantId: ids.darElJeld.id,
    tiers: [
      { rateBps: 180, minMillimes: null, maxMillimes: null },
      { rateBps: 150, minMillimes: TND(1_000), maxMillimes: null },
    ],
    reason: 'Volume en hausse : taux dégressif au-delà de 1 000 TND.',
  },
});
await admin.call('POST', `/v1/admin/merchants/${ids.zarzis.id}/iban-change-requests`, {
  body: { iban: 'TN5904018104003691239999', reason: 'Nouveau compte à la BIAT Djerba.' },
});

// Contact messages: one new, one handled by the support.
const visitor = new WebClient(base, origin, 'visiteur');
await visitor.call('POST', '/v1/public/contact-messages', {
  body: {
    name: 'Olfa Mzoughi',
    email: 'olfa.mzoughi@exemple.tn',
    companyName: 'Clinique El Manar',
    requesterType: 'COMPANY',
    message: 'Bonjour, nous souhaitons équiper nos 120 employés en tickets FlexiPay.',
  },
});
const handled = await visitor.call('POST', '/v1/public/contact-messages', {
  body: {
    name: 'Tarek Ben Salah',
    email: 'tarek@resto-hammamet.tn',
    requesterType: 'MERCHANT',
    message: 'Comment accepter les paiements FlexiPay dans mon restaurant à Hammamet ?',
  },
});
const inbox = (await support.call('GET', '/v1/admin/contact-messages')).data as Body[];
const toHandle = inbox.find((item) => item.reference === handled.reference) ?? inbox[0] ?? {};
await support.call('POST', `/v1/admin/contact-messages/${String(toHandle.id)}/handle`, {
  body: { note: 'Rappelé, rendez-vous fixé avec un commercial.' },
});

// The expired quote: its end is moved to yesterday (demo date only, not money).
await prisma.$executeRaw`UPDATE credit_orders SET quote_expires_at = now() - interval '1 day'
  WHERE reference = ${references.expiredQuote}`;

// ------------------------------------------------------------------ 3. checks

const db = new DbService(env);
const books = await db.system((tx) => new LedgerService().reconcile(tx));
await app.close();
await db.onModuleDestroy();
await prisma.$disconnect();
if (!books.ok) {
  console.error('Demo seed: the books do not reconcile', {
    mismatches: books.mismatches,
    lots: books.lotMismatches,
    taxes: books.taxMismatches,
  });
  process.exit(1);
}

console.log('Demo seed done: books reconciled (one example per case, docs/demo/donnees-demo.md).');
console.log(JSON.stringify(references, null, 2));
