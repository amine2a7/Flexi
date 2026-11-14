// Demo data (request of 2026-11-14): EXACTLY these accounts, nothing else (no employee, no
// order, no transaction). Table: docs/demo/donnees-demo.md.
//   FlexiPay : superadmin@ (Super-admin), nizar@ (Finance), ali@ (Opérations), support@ (Support)
//   Entreprise BIAT (PM MF, commission 3 %, KYC validé, active) : biat@ (Propriétaire)
//   Commerçant Carrefour (PM MF, commission 2 %, Restauration + Habillement + Cadeaux, KYC validé,
//   actif) : carrefour@ (Propriétaire)
// Same password for all, no forced change at the first sign-in, MFA enrolled (fixed demo code).
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
import type { CreditType, SubRole } from '../src/generated/prisma/enums.js';

/**
 * Password of the demo accounts. Shorter than the 12 characters asked when a password is CHOSEN
 * (change, reset): the seed writes its hash directly and the sign-in only checks the hash.
 */
const PASSWORD = 'Flexi2026';
const MFA = '123456';
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
const storage = new LocalDiskStorage(env.uploadDir);

/** Grey placeholder page (PNG): the KYC pieces of the demo. */
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

const KYC_DOCUMENTS = [
  'REGISTRY_EXTRACT',
  'TAX_CERTIFICATE',
  'MANAGER_ID_FRONT',
  'MANAGER_ID_BACK',
  'BANK_DETAILS',
] as const;

await prisma.$transaction(async (tx) => {
  // Platform settings (defaults of the migrations) and the four credit types.
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

  // A single grid line, without bounds: the rate of every amount.
  const flatGrid = (rateBps: number) => ({
    create: [
      { tiers: { create: [{ position: 0, rateBps, minMillimes: null, maxMillimes: null }] } },
    ],
  });

  const biat = await tx.company.create({
    data: {
      name: 'BIAT',
      city: 'Tunis',
      phone: seal('+21671131000'),
      email: 'biat@flexipay.test',
      status: 'APPROVED',
      legalForm: 'PM_MF',
      commissionGrids: flatGrid(300),
    },
  });
  const carrefour = await tx.merchant.create({
    data: {
      name: 'Carrefour',
      city: 'Tunis',
      category: 'GROCERY',
      address: 'La Marsa, Tunis',
      phone: seal('+21671980000'),
      email: 'carrefour@flexipay.test',
      status: 'APPROVED',
      legalForm: 'PM_MF',
      acceptedCreditTypes: ['RESTAURATION', 'HABILLEMENT', 'CADEAUX'],
      paymentCode: '401001',
      iban: seal('TN5910006035183598478831'),
      commissionGrids: flatGrid(200),
    },
  });

  // Accounts: same password, no forced change, MFA enrolled (fixed demo code).
  const user = (
    email: string,
    displayName: string,
    role: 'ADMIN' | 'COMPANY' | 'MERCHANT',
    subRole: SubRole,
    tenant: { companyId?: string; merchantId?: string },
  ) =>
    tx.user.create({
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
  await user('superadmin@flexipay.test', 'Super-admin', 'ADMIN', 'SUPER_ADMIN', {});
  const nizar = await user('nizar@flexipay.test', 'Nizar', 'ADMIN', 'FINANCE', {});
  await user('ali@flexipay.test', 'Ali', 'ADMIN', 'COMPLIANCE', {});
  await user('support@flexipay.test', 'Support', 'ADMIN', 'SUPPORT', {});
  await user('biat@flexipay.test', 'BIAT', 'COMPANY', 'OWNER', { companyId: biat.id });
  await user('carrefour@flexipay.test', 'Carrefour', 'MERCHANT', 'OWNER', {
    merchantId: carrefour.id,
  });

  // Validated KYC files: no « Complétez votre dossier » banner, the five pieces in « Mon dossier ».
  for (const owner of [
    { accountType: 'COMPANY' as const, companyId: biat.id },
    { accountType: 'MERCHANT' as const, merchantId: carrefour.id },
  ]) {
    await tx.kycFile.create({
      data: {
        ...owner,
        status: 'APPROVED',
        createdBy: nizar.id,
        documents: {
          create: KYC_DOCUMENTS.map((type) => ({
            type,
            fileName: `${type.toLowerCase()}.png`,
            contentType: 'image/png',
            sizeBytes: png.length,
            storageKey: pngKey,
            status: 'VALIDATED',
          })),
        },
        events: {
          create: [
            { action: 'SUBMITTED', actorName: 'Système' },
            { action: 'APPROVED', actorName: 'Système' },
          ],
        },
      },
    });
  }
});
await prisma.$disconnect();

console.log('Demo seed done: 6 accounts, BIAT and Carrefour (docs/demo/donnees-demo.md).');
