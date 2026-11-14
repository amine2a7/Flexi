// Demo data (request of 2026-11-14): a full view of the platform, every client at its own stage.
//   FlexiPay: superadmin@, nizar@ (Finance), ali@ and sonia@ (Opérations), support@ and karim@
//   (Support). 10 companies (BIAT: Propriétaire, RH, Finance) and 10 merchants (Carrefour:
//   Propriétaire, Caissier), from « dossier à déposer » to active and suspended. Employees, orders
//   in every status, allocations, payments over the last weeks, payouts (paid, released, in a
//   batch, waiting, rejected by the bank), change requests, contact messages.
// The structure (settings, clients, employees, accounts, KYC files) is written here; every amount
// then goes through the real API, started in this process, so the ledger only holds business
// entries. The seed fails when the books do not reconcile. Table: docs/demo/donnees-demo.md.
//   pnpm demo:reset  (or: pnpm --filter @flexipay/api db:reset && pnpm --filter @flexipay/api db:seed)
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
import type {
  AccountStatus,
  CreditType,
  LegalForm,
  MerchantCategory,
  SubRole,
} from '../src/generated/prisma/enums.js';
import { WebClient, type Body } from './demo/web-client.js';

/**
 * Password of the demo accounts. Shorter than the 12 characters asked when a password is CHOSEN
 * (change, reset): the seed writes its hash directly and the sign-in only checks the hash.
 */
const PASSWORD = 'Flexi2026';
const MFA = '123456';
const PIN = '1234';
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

// ------------------------------------------------------------------ data

/** Stage of a client: its account status and its KYC file. */
type Stage = 'ACTIVE' | 'KYC_TO_SUBMIT' | 'KYC_WAITING' | 'KYC_REJECTED' | 'SUSPENDED';
const STATUS_OF: Record<Stage, AccountStatus> = {
  ACTIVE: 'APPROVED',
  KYC_TO_SUBMIT: 'PENDING_KYC',
  KYC_WAITING: 'PENDING_KYC',
  KYC_REJECTED: 'REJECTED',
  SUSPENDED: 'SUSPENDED',
};

interface CompanySeed {
  readonly key: string;
  readonly name: string;
  readonly city: string;
  readonly legalForm: LegalForm;
  readonly rateBps: number;
  readonly stage: Stage;
  readonly departments: readonly string[];
  readonly employees: number;
}
const COMPANIES: readonly CompanySeed[] = [
  {
    key: 'biat',
    name: 'BIAT',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 300,
    stage: 'ACTIVE',
    departments: ['Direction', 'Ressources humaines', 'Agences'],
    employees: 8,
  },
  {
    key: 'telecom',
    name: 'Tunisie Telecom',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 350,
    stage: 'ACTIVE',
    departments: ['Technique', 'Commercial'],
    employees: 6,
  },
  {
    key: 'poulina',
    name: 'Poulina Group Holding',
    city: 'Ezzahra',
    legalForm: 'PM_MF',
    rateBps: 400,
    stage: 'ACTIVE',
    departments: ['Production', 'Logistique'],
    employees: 6,
  },
  {
    key: 'delice',
    name: 'Délice Danone',
    city: 'Soliman',
    legalForm: 'PM_MF',
    rateBps: 300,
    stage: 'ACTIVE',
    departments: ['Usine', 'Administration'],
    employees: 4,
  },
  {
    key: 'ooredoo',
    name: 'Ooredoo Tunisie',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 350,
    stage: 'ACTIVE',
    departments: ['Service client'],
    employees: 3,
  },
  {
    key: 'vermeg',
    name: 'Vermeg',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 250,
    stage: 'ACTIVE',
    departments: ['R&D'],
    employees: 0,
  },
  {
    key: 'mabrouk',
    name: 'Groupe Mabrouk',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 300,
    stage: 'KYC_WAITING',
    departments: [],
    employees: 0,
  },
  {
    key: 'sopra',
    name: 'Sopra HR Software Tunisie',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 300,
    stage: 'KYC_TO_SUBMIT',
    departments: [],
    employees: 0,
  },
  {
    key: 'onetech',
    name: 'One Tech Holding',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 300,
    stage: 'KYC_REJECTED',
    departments: [],
    employees: 0,
  },
  {
    key: 'tunisair',
    name: 'Tunisair',
    city: 'Tunis',
    legalForm: 'PM_MF',
    rateBps: 300,
    stage: 'SUSPENDED',
    departments: [],
    employees: 0,
  },
];

interface MerchantSeed {
  readonly key: string;
  readonly name: string;
  readonly city: string;
  readonly category: MerchantCategory;
  readonly legalForm: LegalForm;
  readonly types: readonly CreditType[];
  readonly rateBps: number;
  readonly stage: Stage;
  readonly iban: string;
}
const MERCHANTS: readonly MerchantSeed[] = [
  {
    key: 'carrefour',
    name: 'Carrefour',
    city: 'La Marsa',
    category: 'GROCERY',
    legalForm: 'PM_MF',
    types: ['RESTAURATION', 'HABILLEMENT', 'CADEAUX'],
    rateBps: 200,
    stage: 'ACTIVE',
    iban: 'TN5910006035183598478831',
  },
  {
    key: 'monoprix',
    name: 'Monoprix Lac 2',
    city: 'Tunis',
    category: 'GROCERY',
    legalForm: 'PM_MF',
    types: ['RESTAURATION', 'CADEAUX'],
    rateBps: 220,
    stage: 'ACTIVE',
    iban: 'TN5908006000671234567891',
  },
  {
    key: 'dareljeld',
    name: 'Restaurant Dar El Jeld',
    city: 'Tunis',
    category: 'RESTAURANT',
    legalForm: 'PP_CIN',
    types: ['RESTAURATION'],
    rateBps: 200,
    stage: 'ACTIVE',
    iban: 'TN5910006035183598470014',
  },
  {
    key: 'masmoudi',
    name: 'Pâtisserie Masmoudi',
    city: 'Sfax',
    category: 'BAKERY',
    legalForm: 'PP_MF',
    types: ['RESTAURATION'],
    rateBps: 200,
    stage: 'ACTIVE',
    iban: 'TN5904018104003691234821',
  },
  {
    key: 'zarzis',
    name: 'Boutique Zarzis Mode',
    city: 'Djerba',
    category: 'CLOTHING',
    legalForm: 'PP_MF',
    types: ['HABILLEMENT'],
    rateBps: 250,
    stage: 'ACTIVE',
    iban: 'TN5904018104003691234999',
  },
  {
    key: 'agil',
    name: 'Station Agil Lac 2',
    city: 'Tunis',
    category: 'FUEL_STATION',
    legalForm: 'PM_MF',
    types: ['CARBURANT'],
    rateBps: 150,
    stage: 'ACTIVE',
    iban: 'TN5925079000000123456789',
  },
  // An IBAN ending with 0000: the simulated bank rejects its transfer (case « rejeté »).
  {
    key: 'kitab',
    name: 'Librairie Al Kitab',
    city: 'Bizerte',
    category: 'GIFT_SHOP',
    legalForm: 'PP_CIN',
    types: ['CADEAUX'],
    rateBps: 300,
    stage: 'ACTIVE',
    iban: 'TN5903003000123456780000',
  },
  {
    key: 'sidibou',
    name: 'Café Sidi Bou Saïd',
    city: 'Sidi Bou Saïd',
    category: 'CAFE',
    legalForm: 'PP_CIN',
    types: ['RESTAURATION'],
    rateBps: 200,
    stage: 'KYC_WAITING',
    iban: 'TN5910006035183598471122',
  },
  {
    key: 'zink',
    name: 'Fast-food Le Zink',
    city: 'Sousse',
    category: 'FAST_FOOD',
    legalForm: 'PP_CIN',
    types: ['RESTAURATION'],
    rateBps: 200,
    stage: 'KYC_TO_SUBMIT',
    iban: 'TN5910006035183598472233',
  },
  {
    key: 'shell',
    name: 'Station Shell Ennasr',
    city: 'Ariana',
    category: 'FUEL_STATION',
    legalForm: 'PM_MF',
    types: ['CARBURANT'],
    rateBps: 150,
    stage: 'SUSPENDED',
    iban: 'TN5925079000000123453344',
  },
];

const FIRST_NAMES = [
  'Yasmine',
  'Mehdi',
  'Sana',
  'Hichem',
  'Amira',
  'Anis',
  'Rim',
  'Walid',
  'Ines',
  'Sofiane',
  'Hana',
  'Omar',
  'Leïla',
  'Bilel',
  'Nesrine',
  'Karim',
  'Olfa',
  'Tarek',
  'Salma',
  'Youssef',
  'Mariem',
  'Hamza',
  'Rania',
  'Aymen',
  'Dorra',
  'Fares',
  'Emna',
];
const LAST_NAMES = [
  'Jaziri',
  'Trabelsi',
  'Ben Ali',
  'Gharbi',
  'Dridi',
  'Khelifi',
  'Hammami',
  'Chaabane',
  'Ferchichi',
  'Mejri',
  'Sassi',
  'Belhadj',
  'Mansouri',
  'Jlassi',
  'Bouazizi',
  'Ayari',
  'Zouari',
  'Ben Salah',
  'Masmoudi',
  'Kammoun',
  'Tlili',
  'Baccouche',
  'Mzoughi',
  'Riahi',
  'Saidi',
  'Chebbi',
  'Haddad',
];
const POSITIONS = ['Chargé de clientèle', 'Analyste', 'Technicien', 'Assistant', 'Responsable'];
const KYC_DOCUMENTS = [
  'REGISTRY_EXTRACT',
  'TAX_CERTIFICATE',
  'MANAGER_ID_FRONT',
  'MANAGER_ID_BACK',
  'BANK_DETAILS',
] as const;
const slug = (value: string) =>
  value
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z]+/g, '');

/** Every account of the demo, for the table of docs/demo/donnees-demo.md and the seed log. */
const accountsList: { email: string; role: string; tenant: string }[] = [];

// ------------------------------------------------------------------ 1. structure (no money)

interface SeededEmployee {
  readonly id: string;
  readonly email: string;
  readonly company: string;
}

const ids = await prisma.$transaction(async (tx) => {
  await tx.platformSettings.create({
    data: {
      id: 1,
      payoutMinimumMillimes: BigInt(TND(50)),
      creditValidityMonths: 12,
      maxFamilyMembers: 5,
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

  // Accounts: same password, no forced change, MFA enrolled (fixed demo code).
  const user = async (
    email: string,
    displayName: string,
    role: 'ADMIN' | 'COMPANY' | 'MERCHANT' | 'EMPLOYEE',
    subRole: SubRole | null,
    tenant: { companyId?: string; merchantId?: string; employeeId?: string },
    shown: { role: string; tenant: string },
  ) => {
    accountsList.push({ email, ...shown });
    return tx.user.create({
      data: {
        email,
        displayName,
        role,
        subRole,
        passwordHash,
        mustChangePassword: false,
        mfaSecretEnc: encryptSecret(dataKey, newSecretBase32()),
        ...tenant,
      },
    });
  };
  const flexipay = (role: string) => ({ role, tenant: 'FlexiPay' });
  await user(
    'superadmin@flexipay.test',
    'Super-admin',
    'ADMIN',
    'SUPER_ADMIN',
    {},
    flexipay('Super-admin'),
  );
  const nizar = await user(
    'nizar@flexipay.test',
    'Nizar',
    'ADMIN',
    'FINANCE',
    {},
    flexipay('Finance'),
  );
  await user('ali@flexipay.test', 'Ali', 'ADMIN', 'COMPLIANCE', {}, flexipay('Opérations'));
  await user('sonia@flexipay.test', 'Sonia', 'ADMIN', 'COMPLIANCE', {}, flexipay('Opérations'));
  await user('support@flexipay.test', 'Support', 'ADMIN', 'SUPPORT', {}, flexipay('Support'));
  await user('karim@flexipay.test', 'Karim', 'ADMIN', 'SUPPORT', {}, flexipay('Support'));

  const flatGrid = (rateBps: number) => ({
    create: [
      { tiers: { create: [{ position: 0, rateBps, minMillimes: null, maxMillimes: null }] } },
    ],
  });

  /** KYC file of a client at its stage (none while « à déposer »). */
  const kycFile = async (
    stage: Stage,
    owner:
      | { accountType: 'COMPANY'; companyId: string }
      | { accountType: 'MERCHANT'; merchantId: string },
  ) => {
    if (stage === 'KYC_TO_SUBMIT') return;
    const approved = stage === 'ACTIVE' || stage === 'SUSPENDED';
    const rejected = stage === 'KYC_REJECTED';
    await tx.kycFile.create({
      data: {
        ...owner,
        status: approved ? 'APPROVED' : rejected ? 'REJECTED' : 'PENDING',
        ...(rejected
          ? { rejectionReason: 'Extrait du registre de commerce de plus de trois mois.' }
          : {}),
        // Opened by Finance: the super-admin and Opérations decide it (four eyes).
        createdBy: nizar.id,
        documents: {
          create: KYC_DOCUMENTS.map((type) => ({
            type,
            fileName: `${type.toLowerCase()}.png`,
            contentType: 'image/png',
            sizeBytes: png.length,
            storageKey: pngKey,
            status: approved
              ? 'VALIDATED'
              : rejected && type === 'REGISTRY_EXTRACT'
                ? 'TO_CORRECT'
                : 'SUBMITTED',
          })),
        },
        events: {
          create: [
            { action: 'SUBMITTED', actorName: 'Système' },
            ...(approved ? [{ action: 'APPROVED' as const, actorName: 'Ali' }] : []),
            ...(rejected ? [{ action: 'REJECTED' as const, actorName: 'Ali' }] : []),
          ],
        },
      },
    });
  };

  const companies: Record<string, { id: string }> = {};
  const employees: Record<string, SeededEmployee[]> = {};
  let person = 0;
  let phone = 20_100_000;
  for (const seed of COMPANIES) {
    const company = await tx.company.create({
      data: {
        name: seed.name,
        city: seed.city,
        phone: seal(`+216${String((phone += 1))}`),
        email: `${seed.key}@flexipay.test`,
        status: STATUS_OF[seed.stage],
        legalForm: seed.legalForm,
        commissionGrids: flatGrid(seed.rateBps),
      },
    });
    companies[seed.key] = company;
    await kycFile(seed.stage, { accountType: 'COMPANY', companyId: company.id });
    await user(
      `${seed.key}@flexipay.test`,
      seed.name,
      'COMPANY',
      'OWNER',
      { companyId: company.id },
      { role: 'Propriétaire (Entreprise)', tenant: seed.name },
    );
    if (seed.key === 'biat') {
      await user(
        'rh.biat@flexipay.test',
        'RH BIAT',
        'COMPANY',
        'MANAGER',
        { companyId: company.id },
        { role: 'RH (Entreprise)', tenant: seed.name },
      );
      await user(
        'finance.biat@flexipay.test',
        'Finance BIAT',
        'COMPANY',
        'FINANCE',
        { companyId: company.id },
        { role: 'Finance (Entreprise)', tenant: seed.name },
      );
    }
    const departments = await Promise.all(
      seed.departments.map((name) =>
        tx.department.create({ data: { companyId: company.id, name } }),
      ),
    );
    const list: SeededEmployee[] = [];
    for (let index = 0; index < seed.employees; index += 1) {
      const firstName = FIRST_NAMES[person % FIRST_NAMES.length] ?? 'Sami';
      const lastName = LAST_NAMES[(person * 7) % LAST_NAMES.length] ?? 'Ben Amor';
      person += 1;
      const email = `${slug(firstName)}.${slug(lastName)}@${seed.key}.test`;
      const employee = await tx.employee.create({
        data: {
          companyId: company.id,
          employeeNumber: `${seed.key.slice(0, 3).toUpperCase()}-${String(1001 + index)}`,
          firstName,
          lastName,
          email,
          phone: seal(`+216${String((phone += 1))}`),
          status: 'ACTIVE',
          departmentId: departments[index % Math.max(departments.length, 1)]?.id ?? null,
          position: POSITIONS[index % POSITIONS.length] ?? null,
          pinHash,
        },
      });
      await user(
        email,
        `${firstName} ${lastName.charAt(0)}.`,
        'EMPLOYEE',
        null,
        { employeeId: employee.id },
        { role: 'Bénéficiaire', tenant: seed.name },
      );
      list.push({ id: employee.id, email, company: seed.key });
    }
    employees[seed.key] = list;
  }

  const merchants: Record<string, { id: string; paymentCode: string }> = {};
  let code = 401_000;
  for (const seed of MERCHANTS) {
    const merchant = await tx.merchant.create({
      data: {
        name: seed.name,
        city: seed.city,
        category: seed.category,
        address: `Avenue Habib Bourguiba, ${seed.city}`,
        phone: seal(`+216${String((phone += 1))}`),
        email: `${seed.key}@flexipay.test`,
        status: STATUS_OF[seed.stage],
        legalForm: seed.legalForm,
        acceptedCreditTypes: [...seed.types],
        paymentCode: String((code += 1)),
        iban: seal(seed.iban),
        commissionGrids: flatGrid(seed.rateBps),
      },
    });
    merchants[seed.key] = merchant;
    await kycFile(seed.stage, { accountType: 'MERCHANT', merchantId: merchant.id });
    await user(
      `${seed.key}@flexipay.test`,
      seed.name,
      'MERCHANT',
      'OWNER',
      { merchantId: merchant.id },
      { role: 'Propriétaire (Commerçant)', tenant: seed.name },
    );
    if (seed.key === 'carrefour') {
      await user(
        'caissier.carrefour@flexipay.test',
        'Caissier Carrefour',
        'MERCHANT',
        'CASHIER',
        { merchantId: merchant.id },
        { role: 'Caissier (Commerçant)', tenant: seed.name },
      );
    }
  }
  return { companies, employees, merchants };
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
const signIn = (email: string) => new WebClient(base, origin, email).signIn(email, PASSWORD, MFA);

const admin = await signIn('superadmin@flexipay.test');
const finance = await signIn('nizar@flexipay.test');
const support = await signIn('support@flexipay.test');

const proof = (created: Body) => {
  const form = new FormData();
  form.set('transferReference', `VIR-${String(created.reference)}`);
  form.set('transferDate', new Date().toISOString().slice(0, 10));
  form.set('amountMillimes', String(created.totalMillimes));
  form.set('proof', new Blob([png]), 'avis-de-virement.png');
  return form;
};
type Lines = [CreditType, number][];
const order = (company: WebClient, lines: Lines) =>
  company.call('POST', '/v1/company/orders', {
    key: true,
    body: {
      lines: lines.map(([creditType, dinars]) => ({ creditType, amountMillimes: TND(dinars) })),
    },
  });
const confirm = (created: Body) =>
  finance.call('POST', `/v1/admin/credit-orders/${String(created.id)}/confirm`, { key: true });
const declare = (company: WebClient, created: Body) =>
  company.call('POST', `/v1/company/orders/${String(created.id)}/transfer-declarations`, {
    form: proof(created),
    key: true,
  });
const validate = (created: Body) =>
  admin.call('POST', `/v1/admin/credit-orders/${String(created.id)}/validate`, { key: true });
async function funded(company: WebClient, lines: Lines) {
  const created = await order(company, lines);
  await confirm(created);
  await declare(company, created);
  await validate(created);
  return created;
}

// Per employee: what it receives, then what it spends (under the daily caps of the settings).
const ALLOCATION: Lines = [
  ['RESTAURATION', 200],
  ['HABILLEMENT', 250],
  ['CARBURANT', 100],
  ['CADEAUX', 150],
];
const SHOPS_OF: Record<CreditType, readonly string[]> = {
  RESTAURATION: ['carrefour', 'monoprix', 'dareljeld', 'masmoudi'],
  HABILLEMENT: ['carrefour', 'zarzis'],
  CARBURANT: ['agil'],
  CADEAUX: ['carrefour', 'monoprix', 'kitab'],
};
const sales: Partial<Record<string, Partial<Record<CreditType, number>>>> = {};
let turn = 0;
const owners: Record<string, WebClient> = {};

for (const seed of COMPANIES.filter((item) => item.stage === 'ACTIVE')) {
  const company = await signIn(`${seed.key}@flexipay.test`);
  owners[seed.key] = company;
  const staff = ids.employees[seed.key] ?? [];
  if (staff.length > 0) {
    // The order that funds the allocation, then the allocation to every employee.
    await funded(
      company,
      ALLOCATION.map(
        ([type, dinars]) => [type, dinars * staff.length + 100] as [CreditType, number],
      ),
    );
    await company.call('POST', '/v1/company/allocations', {
      key: true,
      body: {
        allocations: staff.flatMap((employee) =>
          ALLOCATION.map(([creditType, dinars]) => ({
            employeeId: employee.id,
            creditType,
            amountMillimes: TND(dinars),
          })),
        ),
      },
    });
  }
  for (const employee of staff) {
    const client = await signIn(employee.email);
    const spend: Lines = [
      ['RESTAURATION', 45 + (turn % 4) * 5],
      ['RESTAURATION', 60 + (turn % 3) * 10],
      ['HABILLEMENT', 120 + (turn % 5) * 10],
      ['CARBURANT', 80],
      ['CADEAUX', 90 + (turn % 3) * 15],
    ];
    for (const [creditType, dinars] of spend) {
      const shops = SHOPS_OF[creditType];
      const shop = shops[turn % shops.length] ?? shops[0] ?? 'carrefour';
      turn += 1;
      const merchant = ids.merchants[shop];
      if (merchant === undefined) continue;
      await client.call('POST', '/v1/employee/payments', {
        key: true,
        body: {
          merchantCode: merchant.paymentCode,
          creditType,
          amountMillimes: TND(dinars),
          pin: PIN,
        },
      });
      const byType = (sales[shop] ??= {});
      byType[creditType] = (byType[creditType] ?? 0) + dinars;
    }
  }
}

// Orders in every other status, spread over the companies.
const biat = owners.biat;
const telecom = owners.telecom;
const poulina = owners.poulina;
const delice = owners.delice;
const ooredoo = owners.ooredoo;
const vermeg = owners.vermeg;
if (!biat || !telecom || !poulina || !delice || !ooredoo || !vermeg) throw new Error('owners');
// Above the threshold of the second validation (10 000 TND): validated once, waits for the 2nd.
const big = await order(biat, [['RESTAURATION', 12_000]]);
await confirm(big);
await declare(biat, big);
await validate(big);
await order(vermeg, [['RESTAURATION', 1_500]]); // awaiting confirmation
await order(telecom, [['CADEAUX', 800]]); // awaiting confirmation
await confirm(await order(ooredoo, [['RESTAURATION', 900]])); // awaiting payment
await confirm(await order(poulina, [['CARBURANT', 600]])); // awaiting payment
const toValidate = await order(delice, [['HABILLEMENT', 1_200]]);
await confirm(toValidate);
await declare(delice, toValidate); // awaiting validation
const refused = await order(telecom, [['HABILLEMENT', 450]]);
await finance.call('POST', `/v1/admin/credit-orders/${String(refused.id)}/refuse`, {
  body: { reason: 'Montant différent du bon de commande signé.' },
});
const cancelled = await order(poulina, [['CADEAUX', 300]]);
await poulina.call('POST', `/v1/company/orders/${String(cancelled.id)}/cancel`);
const proofRejected = await order(ooredoo, [['CADEAUX', 400]]);
await confirm(proofRejected);
await declare(ooredoo, proofRejected);
await finance.call('POST', `/v1/admin/credit-orders/${String(proofRejected.id)}/reject-proof`, {
  body: { reason: 'Avis de virement illisible : merci de le déposer à nouveau.' },
});
// Credit note: an order cancelled after its invoice was issued.
const creditNote = await order(biat, [['CADEAUX', 250]]);
await confirm(creditNote);
await biat.call('POST', `/v1/company/orders/${String(creditNote.id)}/cancel`);

// A refund at the restaurant (the meal is paid back to the employee).
const darEljeld = await signIn('dareljeld@flexipay.test');
const latest = ((await darEljeld.call('GET', '/v1/merchant/payments')).data as Body[])[0];
if (latest !== undefined) {
  await darEljeld.call('POST', `/v1/merchant/payments/${String(latest.id)}/refund`, { key: true });
  const restaurant = (sales.dareljeld ??= {});
  restaurant.RESTAURATION = (restaurant.RESTAURATION ?? 0) - Number(latest.amountMillimes) / 1000;
}

// Dates only (never an amount): the sales are spread over the last four weeks, all past the
// D-2 of the payout, so the dashboards and statistics show a history.
await prisma.$executeRaw`
  WITH spread AS (
    SELECT id, 3 + (row_number() OVER (ORDER BY created_at, id) % 26)::int AS days FROM payments)
  UPDATE payments p
     SET confirmed_at = p.confirmed_at - make_interval(days => s.days),
         created_at = p.created_at - make_interval(days => s.days),
         settlement_date = p.settlement_date - s.days
    FROM spread s
   WHERE p.id = s.id`;

// Payouts. Order matters: each release closes its batch, the next approval opens a new one.
const shops: Record<string, WebClient> = { dareljeld: darEljeld };
const shopClient = async (key: string) => (shops[key] ??= await signIn(`${key}@flexipay.test`));
/** Requests a payout of a share of what the shop sold on a type (at least 50 TND). */
async function requestPayout(key: string, creditType: CreditType, share: number) {
  const sold = sales[key]?.[creditType] ?? 0;
  const dinars = Math.max(50, Math.floor(sold * share));
  const shop = await shopClient(key);
  const quote = await shop.call('POST', '/v1/merchant/payout-quotes', {
    body: { creditType, grossMillimes: TND(dinars) },
  });
  return shop.call('POST', '/v1/merchant/payouts', { key: true, body: { quoteId: quote.quoteId } });
}
const approve = (payout: Body) =>
  finance.call('POST', `/v1/admin/payout-requests/${String(payout.id)}/approve`, { key: true });
async function release(batchId: string): Promise<void> {
  const asked = await finance.call('POST', `/v1/admin/settlements/${batchId}/release-requests`, {
    body: { reason: 'Lot contrôlé, montants conformes aux relevés.' },
  });
  await admin.call('POST', `/v1/admin/approvals/${String(asked.id)}/approve`);
}
const payouts = app.get(PayoutsService);
async function sendToBank(batchId: string): Promise<void> {
  await prisma.$executeRaw`UPDATE settlement_batches SET settlement_date = current_date
    WHERE id = ${batchId}::uuid`;
  await payouts.executeDueBatches();
}
// 1. Rejected by the bank (IBAN ending 0000), then requested again by the shop.
const rejected = await requestPayout('kitab', 'CADEAUX', 0.5);
const rejectedBatch = String((await approve(rejected)).batchId);
await release(rejectedBatch);
await sendToBank(rejectedBatch);
await requestPayout('kitab', 'CADEAUX', 0.5);
// 2. Paid: two shops in one batch, released in four eyes and executed by the bank.
const paidCarrefour = await requestPayout('carrefour', 'RESTAURATION', 0.8);
const paidBatch = String((await approve(paidCarrefour)).batchId);
await approve(await requestPayout('dareljeld', 'RESTAURATION', 0.8));
await approve(await requestPayout('masmoudi', 'RESTAURATION', 0.8));
await release(paidBatch);
await sendToBank(paidBatch);
// 3. Released by Finance in four eyes (sent to the bank at its date).
const released = await requestPayout('monoprix', 'RESTAURATION', 0.7);
await release(String((await approve(released)).batchId));
// 4. Checked, in a scheduled batch.
await approve(await requestPayout('zarzis', 'HABILLEMENT', 0.6));
// 5. Waiting for the administrator.
await requestPayout('carrefour', 'HABILLEMENT', 0.5);
await requestPayout('agil', 'CARBURANT', 0.6);
await requestPayout('monoprix', 'CADEAUX', 0.5);

// Pending change requests (four eyes): a grid and an IBAN.
const monoprixId = ids.merchants.monoprix?.id ?? '';
await finance.call('POST', '/v1/admin/commission-grids/change-requests', {
  body: {
    merchantId: monoprixId,
    tiers: [
      { rateBps: 200, minMillimes: null, maxMillimes: null },
      { rateBps: 180, minMillimes: TND(1_000), maxMillimes: null },
    ],
    reason: 'Volume en hausse : taux dégressif au-delà de 1 000 TND.',
  },
});
await admin.call(
  'POST',
  `/v1/admin/merchants/${ids.merchants.zarzis?.id ?? ''}/iban-change-requests`,
  {
    body: { iban: 'TN5904018104003691239999', reason: 'Nouveau compte à la BIAT Djerba.' },
  },
);

// Contact messages: one new, one handled by the support.
const visitor = new WebClient(base, origin, 'visiteur');
await visitor.call('POST', '/v1/public/contact-messages', {
  body: {
    name: 'Olfa Mzoughi',
    email: 'olfa.mzoughi@exemple.test',
    companyName: 'Clinique El Manar',
    requesterType: 'COMPANY',
    message: 'Bonjour, nous souhaitons équiper nos 120 employés en tickets FlexiPay.',
  },
});
const handled = await visitor.call('POST', '/v1/public/contact-messages', {
  body: {
    name: 'Tarek Ben Salah',
    email: 'tarek@resto-hammamet.test',
    requesterType: 'MERCHANT',
    message: 'Comment accepter les paiements FlexiPay dans mon restaurant à Hammamet ?',
  },
});
const inbox = (await support.call('GET', '/v1/admin/contact-messages')).data as Body[];
const toHandle = inbox.find((item) => item.reference === handled.reference) ?? inbox[0] ?? {};
await support.call('POST', `/v1/admin/contact-messages/${String(toHandle.id)}/handle`, {
  body: { note: 'Rappelé, rendez-vous fixé avec un commercial.' },
});

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

console.log(
  `Demo seed done: books reconciled, ${String(accountsList.length)} accounts, ${String(COMPANIES.length)} companies, ${String(MERCHANTS.length)} merchants.`,
);
console.log(JSON.stringify(accountsList));
