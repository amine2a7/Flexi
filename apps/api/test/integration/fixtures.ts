import { randomUUID } from 'node:crypto';
import type { DbService } from '../../src/common/db.service.js';
import { encryptSecret } from '../../src/common/crypto.js';
import { phoneIndex, sealPii } from '../../src/common/pii.js';
import { hashSecret } from '../../src/auth/password.js';
import { codeAt, currentStep, newSecretBase32 } from '../../src/auth/totp.js';
import type { Env } from '../../src/config/env.js';
import type { Role, SubRole } from '../../src/generated/prisma/enums.js';
import { WebClient } from './http.js';

export const PASSWORD = 'Rose-des-sables-2026'; // gitleaks:allow (test-only value)

const dataKey = () => Buffer.from(process.env.DATA_ENCRYPTION_KEY ?? '', 'base64');
/** A phone or an IBAN as the API stores it (encrypted, securite B5-S11). */
export const sealed = (value: string) => sealPii(dataKey(), value);
/** Lookup index of a user phone (users.phone_hash). */
export const phoneKey = (phone: string) => phoneIndex(dataKey(), phone);

/** One-line commission grid (default rate) for a shop or a company created in a test. */
export const oneLineGrid = (rateBps = 200) => ({
  create: { tiers: { create: [{ position: 0, rateBps }] } },
});
/** Same grid as an API body (window « Commission »). */
export const gridBody = (rateBps = 200) => [{ rateBps, minMillimes: null, maxMillimes: null }];

/** Ledger lines of the transactions of a reference (code, direction, amount), sorted. */
export async function ledgerLines(db: DbService, reference: string) {
  const rows = await db.system(
    (tx) =>
      tx.$queryRaw<{ code: string; direction: string; amount: bigint }[]>`
      SELECT a.code, e.direction::text AS direction, e.amount_millimes AS amount
        FROM ledger_entries e
        JOIN ledger_accounts a ON a.id = e.account_id
        JOIN ledger_transactions t ON t.id = e.transaction_id
       WHERE t.reference = ${reference}
       ORDER BY a.code, e.direction`,
  );
  return rows.map((row) => ({
    code: row.code.split(':')[0],
    direction: row.direction,
    amount: Number(row.amount),
  }));
}

/** Platform and credit type settings of the demo (idempotent). */
export async function seedSettings(db: DbService): Promise<void> {
  await db.system(async (tx) => {
    await tx.platformSettings.upsert({
      where: { id: 1 },
      create: {
        id: 1,
        payoutMinimumMillimes: 20_000n,
        creditValidityMonths: 12,
        maxFamilyMembers: 5,
        orderFeeRateBps: 150,
      },
      update: {},
    });
    const types = [
      ['RESTAURATION', 200, 12, 80_000n],
      ['HABILLEMENT', 250, 12, 300_000n],
      ['CARBURANT', 150, 6, 150_000n],
      ['CADEAUX', 300, 12, 250_000n],
    ] as const;
    for (const [creditType, rate, validity, limit] of types) {
      await tx.creditTypeSetting.upsert({
        where: { creditType },
        create: {
          creditType,
          enabled: true,
          commissionRateBps: rate,
          validityMonths: validity,
          dailyLimitMillimes: limit,
        },
        update: {},
      });
    }
  });
}

export async function createCompany(db: DbService, name = `Société ${randomUUID().slice(0, 6)}`) {
  return db.system((tx) =>
    tx.company.create({
      data: {
        name,
        city: 'Tunis',
        phone: sealed('+21671000000'),
        email: 'contact@societe.test',
        status: 'APPROVED',
        commissionGrids: oneLineGrid(150),
      },
    }),
  );
}

export async function createEmployee(db: DbService, companyId: string) {
  return db.system((tx) =>
    tx.employee.create({
      data: {
        companyId,
        employeeNumber: `E-${randomUUID().slice(0, 6)}`,
        firstName: 'Yasmine',
        lastName: 'Jebali',
        email: `${randomUUID().slice(0, 8)}@salarie.test`,
        phone: sealed('+21698123456'),
        status: 'ACTIVE',
      },
    }),
  );
}

export interface TestUser {
  readonly email: string;
  readonly secret: string;
  readonly id: string;
}

export async function createUser(
  db: DbService,
  env: Env,
  role: Role,
  tenant: { companyId?: string; merchantId?: string; employeeId?: string } = {},
  displayName = 'Test U.',
  subRole?: SubRole | null,
): Promise<TestUser> {
  const email = `${role.toLowerCase()}-${randomUUID().slice(0, 8)}@flexipay.test`;
  const secret = newSecretBase32();
  const user = await db.system(async (tx) =>
    tx.user.create({
      data: {
        role,
        subRole:
          subRole !== undefined
            ? subRole
            : role === 'ADMIN'
              ? 'SUPER_ADMIN'
              : role === 'EMPLOYEE'
                ? null
                : 'OWNER',
        displayName,
        email,
        passwordHash: await hashSecret(PASSWORD),
        mfaSecretEnc: encryptSecret(Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64'), secret),
        companyId: tenant.companyId ?? null,
        merchantId: tenant.merchantId ?? null,
        employeeId: tenant.employeeId ?? null,
      },
    }),
  );
  return { email, secret, id: user.id };
}

/** Sign-ins per user: a TOTP step is never accepted twice, the second one uses the next step. */
const signIns = new Map<string, bigint>();

/** Signs in through the real routes (password + TOTP). At most two sign-ins per user. */
export async function signedIn(base: string, user: TestUser): Promise<WebClient> {
  const client = new WebClient(base);
  const login = await client.call('POST', '/v1/auth/login', {
    body: { identifier: user.email, password: PASSWORD },
  });
  const offset = signIns.get(user.id) ?? 0n;
  signIns.set(user.id, offset + 1n);
  const verify = await client.call('POST', '/v1/auth/mfa/verify', {
    body: {
      challengeId: login.body.challengeId,
      code: codeAt(user.secret, currentStep() + offset),
    },
  });
  if (verify.status !== 200) throw new Error(`sign-in failed: ${JSON.stringify(verify.body)}`);
  return client;
}

/** The 4 documents of a KYC file, filed directly (processus v2: approval needs all of them). */
export async function fileKycDocuments(db: DbService, fileId: string): Promise<void> {
  await db.system((tx) =>
    tx.kycDocument.createMany({
      data: (
        [
          'REGISTRY_EXTRACT',
          'TAX_CERTIFICATE',
          'MANAGER_ID_FRONT',
          'MANAGER_ID_BACK',
          'BANK_DETAILS',
        ] as const
      ).map((type) => ({
        fileId,
        type,
        fileName: `${type}.pdf`,
        contentType: 'application/pdf',
        sizeBytes: 1_024,
        storageKey: `test/${fileId}/${type}`,
      })),
    }),
  );
}
