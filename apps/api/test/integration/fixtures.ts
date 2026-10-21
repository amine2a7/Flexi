import { randomUUID } from 'node:crypto';
import type { DbService } from '../../src/common/db.service.js';
import { encryptSecret } from '../../src/common/crypto.js';
import { hashSecret } from '../../src/auth/password.js';
import { codeAt, currentStep, newSecretBase32 } from '../../src/auth/totp.js';
import type { Env } from '../../src/config/env.js';
import type { Role, SubRole } from '../../src/generated/prisma/enums.js';
import { WebClient } from './http.js';

export const PASSWORD = 'Rose-des-sables-2026'; // gitleaks:allow (test-only value)

/** Platform and credit type settings of the demo (idempotent). */
export async function seedSettings(db: DbService): Promise<void> {
  await db.system(async (tx) => {
    await tx.platformSettings.upsert({
      where: { id: 1 },
      create: {
        id: 1,
        payoutMinimumMillimes: 20_000n,
        creditValidityMonths: 12,
        maxFamilyMembers: 4,
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
        phone: '+21671000000',
        email: 'contact@societe.test',
        status: 'APPROVED',
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
        phone: '+21698123456',
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
