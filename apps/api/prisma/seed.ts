// Development data: the same accounts and the same data as the mocked API of the web app (MSW),
// loaded into the local PostgreSQL. Run once on an empty database:
//   pnpm --filter @flexipay/api db:reset && pnpm --filter @flexipay/api db:seed
// Every amount goes through the ledger (double entry, balances checked, reconciled at the end).
// When the demo history does not fund itself (MSW figures are independent of each other), an
// OPENING_BALANCE transaction (escrow -> wallet) brings the missing amount: it is the only entry
// that does not come from a business flow, and it is never written outside this seed.
// Never against staging or production: localhost and NODE_ENV other than production only.
import { execFileSync } from 'node:child_process';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { crc32, deflateSync } from 'node:zlib';
import type { Schemas } from '@flexipay/api-client';
import { PrismaPg } from '@prisma/adapter-pg';
import { hashSecret } from '../src/auth/password.js';
import { newSecretBase32 } from '../src/auth/totp.js';
import { encryptSecret, hmac, randomToken } from '../src/common/crypto.js';
import { sealPii } from '../src/common/pii.js';
import { LocalDiskStorage } from '../src/common/storage.js';
import {
  addDays,
  addMonths,
  businessDay,
  businessMonth,
  dateOnly,
  startOfBusinessMonth,
} from '../src/common/tunis.js';
import { databaseUrls, PG_SESSION_OPTIONS } from '../src/config/database-urls.js';
import { loadEnv } from '../src/config/env.js';
import { PrismaClient } from '../src/generated/prisma/client.js';
import type { CreditType, PaymentStatus, Role } from '../src/generated/prisma/enums.js';
import { LedgerService, accounts, type AccountRef } from '../src/ledger/ledger.service.js';

type S = Schemas;
type Status = 'ACTIVE' | 'INVITED' | 'SUSPENDED';

interface Snapshot {
  now: string;
  demo: {
    password: string;
    firstLoginPassword: string;
    pin: string;
    recoveryCodes: string[];
    adminIds: Record<string, string>;
    companyTenant: { id: string; label: string };
    merchantTenant: { id: string; label: string };
  };
  accounts: {
    id: string;
    identifier: string;
    password: string;
    role: Role;
    subRole: S['SubRole'] | null;
    displayName: string;
    tenant: { id: string; label: string } | null;
    temporaryPassword: boolean;
    mfaEnrolled: boolean;
    recoveryCodes: string[];
  }[];
  merchant: {
    rateBps: number;
    payments: S['MerchantPayment'][];
    payouts: S['PayoutRequest'][];
    documents: S['MerchantDocument'][];
    profile: S['MerchantProfile'];
  };
  company: {
    balances: Record<CreditType, number>;
    employees: S['Employee'][];
    invoices: S['Invoice'][];
  };
  admin: {
    merchants: S['MerchantAccount'][];
    companies: S['CompanyAccount'][];
    profiles: S['CommissionProfile'][];
    approvals: (Omit<S['Approval'], 'initiatedByMe'> & {
      initiatorId: string;
      profileId?: string;
    })[];
    batches: S['SettlementBatch'][];
    audit: S['AuditLogEntry'][];
    settings: S['PlatformSettings'];
    kycFiles: S['KycFile'][];
    payoutRequests: S['AdminPayoutRequest'][];
    transactions: S['AdminTransaction'][];
    contactMessages: S['ContactMessage'][];
  };
  orders: (Omit<S['CreditOrderDetail'], 'firstValidation'> & {
    firstValidator?: { actorId: string; actorName: string; occurredAt: string };
  })[];
  employee: {
    profile: S['EmployeeProfile'];
    operations: S['EmployeeOperationDetail'][];
    balances: Record<CreditType, number>;
  };
  shops: { name: string; city: string; types: CreditType[] }[];
  otherEmployees: {
    companyId: string;
    employees: {
      id: string;
      employeeNumber: string;
      firstName: string;
      lastName: string;
      phone: string;
      status: Status;
    }[];
  }[];
}

const CREDIT_TYPES: readonly CreditType[] = ['RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX'];
const HOUR = 3_600_000;
const DAY = 24 * HOUR;

// ------------------------------------------------------------------ guards and inputs

const env = loadEnv();
const urls = databaseUrls(process.env);
if (env.NODE_ENV === 'production') throw new Error('db:seed never runs in production');
if (!['localhost', '127.0.0.1', '::1'].includes(new URL(urls.adminUrl).hostname)) {
  throw new Error('db:seed only runs against a local PostgreSQL (localhost)');
}
const keys = {
  session: Buffer.from(env.SESSION_SECRET, 'base64'),
  data: Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64'),
};
/** Phones and IBAN are stored encrypted (securite B5-S11). */
const seal = (value: string) => sealPii(keys.data, value);
const sealNullable = (value: string | null) => (value === null ? null : seal(value));
const DEMO_IBAN = 'TN5904018104003691234821';

/** Initial data of MSW, printed by the web exporter (same generators, same seeds). */
function readSnapshot(): Snapshot {
  const apiDir = join(dirname(fileURLToPath(import.meta.url)), '..');
  const exporter = join(apiDir, '..', 'web', 'src', 'mocks', 'export-snapshot.ts');
  const output = execFileSync(process.execPath, ['--import', 'tsx', exporter], {
    cwd: apiDir,
    encoding: 'utf8',
    maxBuffer: 256 * 1024 * 1024,
  });
  return JSON.parse(output) as Snapshot;
}

/** Grey placeholder page (PNG) for the demo KYC pieces and transfer proofs. */
function placeholderPng(width = 240, height = 320): Buffer {
  const raw = Buffer.alloc((width + 1) * height, 0xff);
  for (let y = 0; y < height; y += 1) {
    const row = y * (width + 1);
    raw[row] = 0;
    const header = y >= 24 && y < 48;
    const line = y >= 72 && y < height - 24 && y % 16 < 4;
    for (let x = 24; x < width - 24; x += 1) {
      if (header) raw[row + 1 + x] = 0x40;
      else if (line) raw[row + 1 + x] = 0xd8;
    }
  }
  const chunk = (type: string, data: Buffer) => {
    const length = Buffer.alloc(4);
    length.writeUInt32BE(data.length);
    const body = Buffer.concat([Buffer.from(type, 'ascii'), data]);
    const crc = Buffer.alloc(4);
    crc.writeUInt32BE(crc32(body));
    return Buffer.concat([length, body, crc]);
  };
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr[8] = 8; // bit depth
  ihdr[9] = 0; // greyscale
  return Buffer.concat([
    Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk('IHDR', ihdr),
    chunk('IDAT', deflateSync(raw)),
    chunk('IEND', Buffer.alloc(0)),
  ]);
}

const slug = (text: string) =>
  text
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');

/** Deterministic digits from a text (phones, IBANs, payment codes of the generated accounts). */
function digitsOf(text: string, length: number): string {
  let out = '';
  let seed = crc32(Buffer.from(text));
  while (out.length < length) {
    seed = (Math.imul(seed, 1_103_515_245) + 12_345) >>> 0;
    out += String(seed % 10);
  }
  return out;
}

const big = (value: number) => BigInt(value);
const at = (iso: string) => new Date(iso);

// ------------------------------------------------------------------ seed

const snap = readSnapshot();
const now = new Date(snap.now);
const demo = snap.demo;
const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: urls.migrationUrl, options: PG_SESSION_OPTIONS }),
});
const storage = new LocalDiskStorage(env.uploadDir);
const ledger = new LedgerService();

const [marked] = await prisma.$queryRaw<
  { environment: string | null }[]
>`SELECT current_setting('app.environment', true) AS environment`;
if (marked?.environment !== 'development') {
  console.error('This database is not marked as a development one (run db:setup): no seed.');
  await prisma.$disconnect();
  process.exit(1);
}
if ((await prisma.user.count()) > 0) {
  console.error('The database already has data: run `pnpm --filter @flexipay/api db:reset` first.');
  await prisma.$disconnect();
  process.exit(1);
}

const pngKey = await storage.put(placeholderPng());
const passwordHash = await hashSecret(demo.password);
const firstLoginHash = await hashSecret(demo.firstLoginPassword);
const unusableHash = await hashSecret(randomToken());
const pinHash = await hashSecret(demo.pin);

const summary = await prisma.$transaction(
  async (tx) => {
    // The database accepts OPENING_BALANCE entries only in this transaction (migration 0007).
    await tx.$executeRaw`SELECT set_config('app.seed', 'on', true)`;
    const validity = new Map(
      snap.admin.settings.creditTypes.map((item) => [item.creditType, item.validityMonths]),
    );
    const openings = { count: 0, millimes: 0n };

    /** Brings `account` up to `required` with an opening entry (escrow -> wallet) if needed. */
    async function fundAccount(account: AccountRef, required: bigint, reference: string) {
      const balance = await ledger.balance(tx, account);
      if (balance >= required) return;
      const missing = required - balance;
      await ledger.post(tx, {
        type: 'OPENING_BALANCE',
        reference,
        entries: [
          { account: accounts.bankEscrow(), direction: 'D', amount: missing },
          { account, direction: 'C', amount: missing },
        ],
      });
      openings.count += 1;
      openings.millimes += missing;
    }

    // -------------------------------------------------------------- settings and profiles
    const settings = snap.admin.settings;
    await tx.platformSettings.create({
      data: {
        id: 1,
        payoutMinimumMillimes: big(settings.payoutMinimumMillimes),
        creditValidityMonths: settings.creditValidityMonths,
        maxFamilyMembers: settings.maxFamilyMembers,
        orderFeeRateBps: settings.orderFeeRateBps,
      },
    });
    await tx.creditTypeSetting.createMany({
      data: settings.creditTypes.map((item) => ({
        creditType: item.creditType,
        enabled: item.enabled,
        commissionRateBps: item.commissionRateBps,
        validityMonths: item.validityMonths,
        dailyLimitMillimes: big(item.dailyLimitMillimes),
      })),
    });
    await tx.commissionProfile.createMany({
      data: snap.admin.profiles.map((profile) => ({
        id: profile.id,
        name: profile.name,
        rateBps: profile.rateBps,
        updatedAt: at(profile.updatedAt),
      })),
    });
    const rateOf = (type: CreditType) =>
      settings.creditTypes.find((item) => item.creditType === type)?.commissionRateBps ?? 0;

    // -------------------------------------------------------------- companies and merchants
    await tx.company.createMany({
      data: snap.admin.companies.map((company) => ({
        id: company.id,
        name: company.name,
        city: company.city,
        phone: seal(`+2167${digitsOf(company.id, 7)}`),
        email: `contact@${slug(company.name)}.test`,
        status: company.status,
        createdAt: at(company.createdAt),
      })),
    });
    const ibans = new Map(
      snap.admin.payoutRequests.map((payout) => [payout.merchantId, payout.iban]),
    );
    const usedCodes = new Set<string>([snap.merchant.profile.paymentCode]);
    const paymentCode = (id: string) => {
      let code = digitsOf(id, 6);
      for (let salt = 0; usedCodes.has(code) || code.startsWith('0'); salt += 1)
        code = digitsOf(`${id}:${String(salt)}`, 6);
      usedCodes.add(code);
      return code;
    };
    const demoMerchantId = demo.merchantTenant.id;
    const merchantRows = snap.admin.merchants.map((merchant) => {
      const own = merchant.id === demoMerchantId;
      const iban =
        merchant.status !== 'APPROVED'
          ? null
          : own
            ? DEMO_IBAN
            : (ibans.get(merchant.id) ?? `TN59${digitsOf(merchant.id, 20)}`);
      return {
        id: merchant.id,
        name: merchant.name,
        category: merchant.category,
        city: merchant.city,
        address: own ? snap.merchant.profile.address : '',
        phone: seal(own ? snap.merchant.profile.phone : `+2167${digitsOf(merchant.id, 7)}`),
        email: `contact@${slug(merchant.name)}.test`,
        status: merchant.status,
        acceptedCreditTypes: merchant.acceptedCreditTypes,
        paymentCode: own ? snap.merchant.profile.paymentCode : paymentCode(merchant.id),
        iban: sealNullable(iban),
        commissionProfileId: merchant.commissionProfile?.id ?? null,
        createdAt: at(merchant.createdAt),
      };
    });
    // Shops of the beneficiary history that the admin list does not have (MSW keeps them apart).
    const CATEGORY: Record<CreditType, S['MerchantCategory']> = {
      RESTAURATION: 'RESTAURANT',
      HABILLEMENT: 'CLOTHING',
      CARBURANT: 'FUEL_STATION',
      CADEAUX: 'GIFT_SHOP',
    };
    const standard = snap.admin.profiles[0]?.id ?? '';
    for (const shop of snap.shops) {
      if (merchantRows.some((row) => row.name === shop.name)) continue;
      const id = `0193${digitsOf(shop.name, 4)}-${digitsOf(`${shop.name}b`, 4)}-7000-8000-${digitsOf(`${shop.name}c`, 12)}`;
      merchantRows.push({
        id,
        name: shop.name,
        category: CATEGORY[shop.types[0] ?? 'RESTAURATION'],
        city: shop.city,
        address: '',
        phone: seal(`+2167${digitsOf(id, 7)}`),
        email: `contact@${slug(shop.name)}.test`,
        status: 'APPROVED',
        acceptedCreditTypes: shop.types,
        paymentCode: paymentCode(id),
        iban: seal(`TN59${digitsOf(id, 20)}`),
        commissionProfileId: standard,
        createdAt: new Date(now.getTime() - 300 * DAY),
      });
    }
    await tx.merchant.createMany({ data: merchantRows });
    const merchantByName = new Map(merchantRows.map((row) => [row.name, row]));
    await tx.pointOfSale.createMany({
      data: snap.merchant.profile.pointsOfSale.map((point) => ({
        id: point.id,
        merchantId: demoMerchantId,
        name: point.name,
        city: point.city,
      })),
    });
    const companyByName = new Map(snap.admin.companies.map((company) => [company.name, company]));

    // -------------------------------------------------------------- employees
    const demoCompanyId = demo.companyTenant.id;
    const profile = snap.employee.profile;
    const yasmine = snap.company.employees.find(
      (employee) => employee.employeeNumber === profile.employeeNumber,
    );
    if (yasmine === undefined) throw new Error('seed: demo beneficiary missing from the employees');
    const yasmineId = yasmine.id;
    await tx.employee.createMany({
      data: snap.company.employees.map((employee) =>
        employee.id === yasmineId
          ? {
              id: employee.id,
              companyId: demoCompanyId,
              employeeNumber: profile.employeeNumber,
              firstName: profile.firstName,
              lastName: profile.lastName,
              email: profile.email,
              phone: seal(profile.phone),
              status: 'ACTIVE' as const,
              pinHash,
            }
          : {
              id: employee.id,
              companyId: demoCompanyId,
              employeeNumber: employee.employeeNumber,
              firstName: employee.firstName,
              lastName: employee.lastName,
              email: employee.email,
              phone: seal(employee.phone),
              status: employee.status,
            },
      ),
    });
    const companyNames = new Map(snap.admin.companies.map((company) => [company.id, company.name]));
    for (const group of snap.otherEmployees) {
      const domain = slug(companyNames.get(group.companyId) ?? 'societe');
      const rows = group.employees.map((employee, index) => ({
        id: employee.id,
        companyId: group.companyId,
        employeeNumber: employee.employeeNumber,
        firstName: employee.firstName,
        lastName: employee.lastName,
        email: `${slug(`${employee.firstName}.${employee.lastName}`).replaceAll('-', '')}${String(index)}@${domain}.test`,
        phone: seal(employee.phone),
        status: employee.status,
      }));
      for (let start = 0; start < rows.length; start += 1_000)
        await tx.employee.createMany({ data: rows.slice(start, start + 1_000) });
    }
    interface Payer {
      id: string;
      companyId: string;
      firstName: string;
      lastName: string;
      number: string;
    }
    const payers: Payer[] = [
      ...snap.company.employees
        .filter((employee) => employee.status === 'ACTIVE' && employee.id !== yasmineId)
        .map((employee) => ({
          id: employee.id,
          companyId: demoCompanyId,
          firstName: employee.firstName,
          lastName: employee.lastName,
          number: employee.employeeNumber,
        })),
      ...snap.otherEmployees.flatMap((group) =>
        group.employees
          .filter((employee) => employee.status === 'ACTIVE')
          .map((employee) => ({
            id: employee.id,
            companyId: group.companyId,
            firstName: employee.firstName,
            lastName: employee.lastName,
            number: employee.employeeNumber,
          })),
      ),
    ];
    const payersOf = new Map<string, Payer[]>();
    for (const payer of payers)
      payersOf.set(payer.companyId, [...(payersOf.get(payer.companyId) ?? []), payer]);
    const turn = new Map<string, number>();
    /** Next active employee of a company (round robin), never the demo beneficiary. */
    function payerOf(companyId: string): Payer {
      const list =
        payersOf.get(companyId) ?? payers.filter((payer) => payer.companyId !== demoCompanyId);
      const index = turn.get(companyId) ?? 0;
      turn.set(companyId, index + 1);
      const payer = list[index % list.length];
      if (payer === undefined) throw new Error('seed: no active employee');
      return payer;
    }

    // -------------------------------------------------------------- users
    const userIdByName = new Map<string, string>();
    for (const account of snap.accounts) {
      userIdByName.set(account.displayName, account.id);
      const tenantId = account.tenant?.id ?? null;
      await tx.user.create({
        data: {
          id: account.id,
          role: account.role,
          subRole: account.subRole,
          displayName: account.displayName,
          email: account.identifier,
          passwordHash: account.temporaryPassword ? firstLoginHash : passwordHash,
          mustChangePassword: account.temporaryPassword,
          tempPasswordExpiresAt: account.temporaryPassword
            ? new Date(now.getTime() + 30 * DAY)
            : null,
          mfaSecretEnc: account.mfaEnrolled ? encryptSecret(keys.data, newSecretBase32()) : null,
          companyId: account.role === 'COMPANY' ? tenantId : null,
          merchantId: account.role === 'MERCHANT' ? tenantId : null,
          employeeId: account.role === 'EMPLOYEE' ? yasmineId : null,
        },
      });
      if (account.mfaEnrolled) {
        await tx.recoveryCode.createMany({
          data: account.recoveryCodes.map((code) => ({
            userId: account.id,
            codeHash: hmac(keys.session, `recovery|${account.id}|${code}`),
          })),
        });
      }
    }
    // Staff of the demo shop (shown on its profile; they have no known password).
    // Staff members that are demo accounts (owner, cashier, accountant) were created above.
    const merchantAccounts = new Set(
      snap.accounts.filter((account) => account.role === 'MERCHANT').map((a) => a.displayName),
    );
    for (const member of snap.merchant.profile.staff) {
      if (merchantAccounts.has(member.displayName)) continue;
      await tx.user.create({
        data: {
          id: member.id,
          role: 'MERCHANT',
          subRole: member.subRole,
          displayName: member.displayName,
          email: `${slug(member.displayName).replaceAll('-', '.')}@${slug(demo.merchantTenant.label)}.test`,
          passwordHash: unusableHash,
          mustChangePassword: true,
          merchantId: demoMerchantId,
        },
      });
    }
    const userIdOf = (name: string) => demo.adminIds[name] ?? userIdByName.get(name) ?? null;

    // -------------------------------------------------------------- credit orders
    const orders = [...snap.orders].sort((a, b) => a.createdAt.localeCompare(b.createdAt));
    for (const order of orders) {
      const declaration = order.declaration;
      await tx.creditOrder.create({
        data: {
          id: order.id,
          reference: order.reference,
          companyId: order.companyId,
          status: order.status,
          amountMillimes: big(order.amountMillimes),
          feeRateBps: settings.orderFeeRateBps,
          feesMillimes: big(order.feesMillimes),
          totalMillimes: big(order.totalMillimes),
          paymentReference: order.paymentReference,
          declaredAmountMillimes:
            declaration === undefined ? null : big(declaration.amountMillimes),
          transferReference: declaration?.transferReference ?? null,
          transferDate: declaration === undefined ? null : dateOnly(declaration.transferDate),
          declaredAt: declaration === undefined ? null : at(declaration.declaredAt),
          proofStorageKey: declaration === undefined ? null : pngKey,
          proofFileName: declaration?.proof.fileName ?? null,
          proofContentType: declaration === undefined ? null : 'image/png',
          proofSizeBytes: declaration === undefined ? null : placeholderPng().length,
          refusalReason: order.refusalReason ?? null,
          proofRejectionReason: order.proofRejectionReason ?? null,
          firstValidatorId: order.firstValidator?.actorId ?? null,
          firstValidatorName: order.firstValidator?.actorName ?? null,
          firstValidatedAt:
            order.firstValidator === undefined ? null : at(order.firstValidator.occurredAt),
          createdAt: at(order.createdAt),
          lines: {
            create: order.lines.map((line) => ({
              creditType: line.creditType,
              amountMillimes: big(line.amountMillimes),
            })),
          },
          events: {
            create: order.history.map((event) => ({
              action: event.action,
              actorId:
                event.actorRole === 'ADMIN' || event.actorName === 'Leïla M.'
                  ? userIdOf(event.actorName)
                  : null,
              actorName: event.actorName,
              actorRole: event.actorRole,
              reason: event.reason ?? null,
              occurredAt: at(event.occurredAt),
            })),
          },
        },
      });
      if (order.status === 'VALIDATED') {
        await ledger.post(tx, {
          type: 'ORDER_VALIDATED',
          reference: order.reference,
          tenantId: order.companyId,
          entries: [
            { account: accounts.bankEscrow(), direction: 'D', amount: big(order.totalMillimes) },
            ...order.lines.map((line) => ({
              account: accounts.companyWallet(order.companyId, line.creditType),
              direction: 'C' as const,
              amount: big(line.amountMillimes),
            })),
            ...(order.feesMillimes > 0
              ? [
                  {
                    account: accounts.companyFees(),
                    direction: 'C' as const,
                    amount: big(order.feesMillimes),
                  },
                ]
              : []),
          ],
        });
      }
    }
    // Invoices: those of the demo company as in MSW; the other companies get theirs (one per
    // order that went past the confirmation step), numbered below.
    const invoiced = new Set(snap.company.invoices.map((invoice) => invoice.orderReference));
    const orderByReference = new Map(snap.orders.map((order) => [order.reference, order]));
    let invoiceNumber = Math.min(
      5_400,
      ...snap.company.invoices.map((invoice) => Number(invoice.number.split('-')[2])),
    );
    const invoices = snap.company.invoices.map((invoice) => ({
      number: invoice.number,
      companyId: demoCompanyId,
      orderId: orderByReference.get(invoice.orderReference)?.id ?? '',
      totalMillimes: big(invoice.totalMillimes),
      status: invoice.status,
      issuedAt: at(invoice.issuedAt),
    }));
    for (const order of [...snap.orders].sort((a, b) => b.createdAt.localeCompare(a.createdAt))) {
      if (invoiced.has(order.reference) || order.companyId === demoCompanyId) continue;
      if (!order.history.some((event) => event.action === 'CONFIRMED')) continue;
      invoiceNumber -= 1;
      invoices.push({
        number: `FAC-2026-${String(invoiceNumber)}`,
        companyId: order.companyId,
        orderId: order.id,
        totalMillimes: big(order.totalMillimes),
        status: order.status === 'VALIDATED' ? 'PAID' : 'UNPAID',
        issuedAt: at(order.createdAt),
      });
    }
    await tx.invoice.createMany({ data: invoices });

    // -------------------------------------------------------------- money movements
    async function allocate(
      companyId: string,
      employeeId: string,
      creditType: CreditType,
      amount: bigint,
      when: Date,
      id?: string,
    ) {
      const companyWallet = accounts.companyWallet(companyId, creditType);
      await fundAccount(companyWallet, amount, `SEED-OPENING-${companyId.slice(0, 8)}`);
      const wallet = accounts.employeeWallet(employeeId, creditType);
      const posted = await ledger.post(tx, {
        type: 'ALLOCATION',
        reference: `ALLOC-SEED-${employeeId.slice(0, 8)}`,
        tenantId: companyId,
        entries: [
          { account: companyWallet, direction: 'D', amount },
          { account: wallet, direction: 'C', amount },
        ],
      });
      await ledger.addLot(tx, {
        account: wallet,
        creditType,
        amount,
        expiresAt: addMonths(when, validity.get(creditType) ?? 12),
        sourceTransactionId: posted.transactionId,
      });
      await tx.allocation.create({
        data: {
          ...(id === undefined ? {} : { id }),
          companyId,
          employeeId,
          creditType,
          amountMillimes: amount,
          transactionId: posted.transactionId,
          createdAt: when,
        },
      });
    }

    const monthStart = startOfBusinessMonth(businessMonth(now));
    /** Date of a funding allocation: before the payment, never in the current month. */
    const fundingDate = (paid: Date) =>
      new Date(Math.min(paid.getTime() - DAY, monthStart.getTime() - 2 * DAY));

    interface PaymentInput {
      id: string;
      reference: string;
      merchantId: string;
      employeeId: string;
      companyId: string;
      creditType: CreditType;
      amount: bigint;
      status: PaymentStatus;
      createdAt: Date;
      channel: 'CUSTOMER_CODE' | 'MERCHANT_CODE';
      customer: { firstName: string; lastInitial: string; masked: string };
      /** Allocates the missing credits first (payers of the generated history). */
      fund: boolean;
    }
    const paymentRows: {
      id: string;
      merchantId: string;
      creditType: CreditType;
      amount: bigint;
      /** Status of MSW: SETTLED rows wait for a payout that covers them. */
      status: PaymentStatus;
      confirmedAt: Date | null;
      payoutId?: string;
    }[] = [];

    async function pay(input: PaymentInput) {
      const debited =
        input.status === 'CONFIRMED' || input.status === 'SETTLED' || input.status === 'DISPUTED';
      const confirmedAt = debited ? new Date(input.createdAt.getTime() + 40_000) : null;
      let transactionId: string | null = null;
      if (debited) {
        const wallet = accounts.employeeWallet(input.employeeId, input.creditType);
        if (input.fund) {
          const usable = await ledger.usable(tx, wallet, now);
          if (usable < input.amount) {
            await allocate(
              input.companyId,
              input.employeeId,
              input.creditType,
              input.amount - usable,
              fundingDate(input.createdAt),
            );
          }
        }
        const parts = await ledger.consumeFefo(tx, wallet, input.amount, now);
        transactionId = (
          await ledger.post(tx, {
            type: 'PAYMENT',
            reference: input.reference,
            tenantId: input.companyId,
            entries: [
              ...parts.map((part) => ({
                account: wallet,
                direction: 'D' as const,
                amount: part.amount,
                lotId: part.lotId,
              })),
              {
                account: accounts.merchantWallet(input.merchantId, input.creditType),
                direction: 'C',
                amount: input.amount,
              },
            ],
          })
        ).transactionId;
      }
      await tx.payment.create({
        data: {
          id: input.id,
          reference: input.reference,
          merchantId: input.merchantId,
          employeeId: input.employeeId,
          companyId: input.companyId,
          creditType: input.creditType,
          amountMillimes: input.amount,
          // SETTLED once a payout covers it (below); until then the payment is a receivable.
          status: input.status === 'SETTLED' ? 'CONFIRMED' : input.status,
          channel: input.channel,
          commissionRateBps: debited ? rateOf(input.creditType) : null,
          confirmedAt,
          settlementDate:
            confirmedAt === null ? null : dateOnly(addDays(businessDay(confirmedAt), 2)),
          transactionId,
          customerFirstName: input.customer.firstName,
          customerLastInitial: input.customer.lastInitial,
          customerMaskedNumber: input.customer.masked,
          createdAt: input.createdAt,
          events: {
            create: [
              ...(input.channel === 'CUSTOMER_CODE'
                ? [{ status: 'INITIATED' as const, occurredAt: input.createdAt }]
                : []),
              {
                status: debited ? ('CONFIRMED' as const) : ('REFUSED' as const),
                occurredAt: confirmedAt ?? new Date(input.createdAt.getTime() + 40_000),
              },
              ...(input.status === 'DISPUTED'
                ? [
                    {
                      status: 'DISPUTED' as const,
                      occurredAt: new Date(input.createdAt.getTime() + DAY),
                    },
                  ]
                : []),
            ],
          },
        },
      });
      paymentRows.push({
        id: input.id,
        merchantId: input.merchantId,
        creditType: input.creditType,
        amount: input.amount,
        status: input.status,
        confirmedAt,
      });
    }

    // Demo beneficiary: her history, oldest first (balances after each operation as in MSW).
    const shopIds = new Map(
      snap.shops.map((shop) => [shop.name, merchantByName.get(shop.name)?.id ?? '']),
    );
    for (const operation of [...snap.employee.operations].reverse()) {
      const when = at(operation.occurredAt);
      const amount = big(operation.amountMillimes);
      if (operation.type === 'ALLOCATION') {
        await allocate(demoCompanyId, yasmineId, operation.creditType, amount, when, operation.id);
      } else if (operation.type === 'EXPIRY') {
        const wallet = accounts.employeeWallet(yasmineId, operation.creditType);
        const parts = await ledger.consumeFefo(tx, wallet, amount, now);
        const posted = await ledger.post(tx, {
          type: 'CREDIT_EXPIRY',
          reference: operation.reference,
          entries: [
            ...parts.map((part) => ({
              account: wallet,
              direction: 'D' as const,
              amount: part.amount,
              lotId: part.lotId,
            })),
            { account: accounts.expiredCredits(), direction: 'C', amount },
          ],
        });
        await tx.creditExpiry.create({
          data: {
            id: operation.id,
            employeeId: yasmineId,
            companyId: demoCompanyId,
            creditType: operation.creditType,
            amountMillimes: amount,
            transactionId: posted.transactionId,
            occurredAt: when,
          },
        });
      } else {
        await pay({
          id: operation.id,
          reference: operation.reference,
          merchantId: shopIds.get(operation.counterpartyName) ?? demoMerchantId,
          employeeId: yasmineId,
          companyId: demoCompanyId,
          creditType: operation.creditType,
          amount,
          // Older than the settlement delay: paid out to the shop since (covered by a payout).
          status:
            operation.status === 'REFUSED'
              ? 'REFUSED'
              : now.getTime() - when.getTime() > 3 * DAY
                ? 'SETTLED'
                : 'CONFIRMED',
          createdAt: new Date(when.getTime() - 40_000),
          channel: 'MERCHANT_CODE',
          customer: {
            firstName: profile.firstName,
            lastInitial: profile.lastName.charAt(0),
            masked: `•••${profile.employeeNumber.slice(-4)}`,
          },
          fund: false,
        });
      }
    }

    // Payments of the demo shop and of the whole platform, and the payouts, in time order: a
    // payout leaves the receivables not covered by it on the shop wallet.
    const payerByCustomer = (customer: S['MerchantPayment']['customer']): Payer =>
      payers.find(
        (payer) =>
          payer.companyId !== demoCompanyId &&
          payer.firstName === customer.firstName &&
          payer.lastName.startsWith(customer.lastInitial),
      ) ?? payerOf(snap.admin.companies[1]?.id ?? '');
    interface Step {
      at: number;
      run: () => Promise<void>;
    }
    const steps: Step[] = [];
    for (const payment of snap.merchant.payments) {
      const payer = payerByCustomer(payment.customer);
      steps.push({
        at: at(payment.createdAt).getTime(),
        run: () =>
          pay({
            id: payment.id,
            reference: payment.reference,
            merchantId: demoMerchantId,
            employeeId: payer.id,
            companyId: payer.companyId,
            creditType: payment.creditType,
            amount: big(payment.amountMillimes),
            status: payment.status,
            createdAt: at(payment.createdAt),
            channel: 'CUSTOMER_CODE',
            customer: {
              firstName: payment.customer.firstName,
              lastInitial: payment.customer.lastInitial,
              masked: payment.customer.maskedEmployeeNumber,
            },
            fund: true,
          }),
      });
    }
    for (const transaction of snap.admin.transactions) {
      const merchant = merchantByName.get(transaction.merchantName);
      const company = companyByName.get(transaction.companyName);
      if (merchant === undefined || company === undefined)
        throw new Error('seed: unknown transaction party');
      steps.push({
        at: at(transaction.createdAt).getTime(),
        run: async () => {
          const payer = payerOf(company.id);
          await pay({
            id: transaction.id,
            reference: transaction.reference,
            merchantId: merchant.id,
            employeeId: payer.id,
            companyId: company.id,
            creditType: transaction.creditType,
            amount: big(transaction.amountMillimes),
            status: transaction.status,
            createdAt: at(transaction.createdAt),
            channel: 'CUSTOMER_CODE',
            customer: {
              firstName: payer.firstName,
              lastInitial: payer.lastName.charAt(0),
              masked: `•••${payer.number.slice(-4)}`,
            },
            fund: true,
          });
        },
      });
    }

    // Settlement batches of MSW, created when a payout goes into one (empty ones are skipped).
    const batches = new Map<string, string>();
    const mockBatches = [...snap.admin.batches].sort((a, b) =>
      a.settlementDate.localeCompare(b.settlementDate),
    );
    const today = businessDay(now);
    async function batchFor(requested: Date, paid: boolean): Promise<string> {
      const earliest = addDays(businessDay(requested), 2);
      const found = mockBatches.find((batch) =>
        paid
          ? batch.status === 'PAID' && batch.settlementDate >= earliest
          : batch.status === 'SCHEDULED' && batch.settlementDate > today,
      );
      const date = found?.settlementDate ?? (paid ? earliest : addDays(today, 2));
      const reference = found?.reference ?? `LOT-${date.replaceAll('-', '')}`;
      const existing = batches.get(reference);
      if (existing !== undefined) return existing;
      const id =
        found?.id ??
        `0193${digitsOf(reference, 4)}-${digitsOf(`${reference}b`, 4)}-7000-8000-${digitsOf(`${reference}c`, 12)}`;
      await tx.settlementBatch.create({
        data: {
          id,
          reference,
          settlementDate: dateOnly(date),
          status: paid ? 'PAID' : 'SCHEDULED',
          createdAt: new Date(dateOnly(date).getTime() - 2 * DAY),
        },
      });
      batches.set(reference, id);
      return id;
    }
    const checker = demo.adminIds['Amine K.'] ?? null;

    async function payout(input: {
      id: string;
      reference: string;
      merchantId: string;
      creditType: CreditType;
      status: S['PayoutRequestStatus'];
      gross: bigint;
      rateBps: number;
      commission: bigint;
      net: bigint;
      requestedAt: Date;
      iban: string;
    }) {
      const wallet = accounts.merchantWallet(input.merchantId, input.creditType);
      const open = paymentRows.filter(
        (row) =>
          row.merchantId === input.merchantId &&
          row.creditType === input.creditType &&
          row.status === 'CONFIRMED',
      );
      const coverable = paymentRows.filter(
        (row) =>
          row.merchantId === input.merchantId &&
          row.creditType === input.creditType &&
          row.status === 'SETTLED' &&
          row.payoutId === undefined,
      );
      const openSum = open.reduce((sum, row) => sum + row.amount, 0n);
      await fundAccount(
        wallet,
        input.gross + openSum,
        `SEED-OPENING-${input.merchantId.slice(0, 8)}`,
      );
      const posted = await ledger.post(tx, {
        type: 'PAYOUT_REQUESTED',
        reference: input.reference,
        tenantId: input.merchantId,
        entries: [
          { account: wallet, direction: 'D', amount: input.gross },
          { account: accounts.payoutPayable(), direction: 'C', amount: input.net },
          ...(input.commission > 0n
            ? [
                {
                  account: accounts.merchantCommission(),
                  direction: 'C' as const,
                  amount: input.commission,
                },
              ]
            : []),
        ],
      });
      const step = (offset: number) => new Date(input.requestedAt.getTime() + offset);
      const events: {
        status: S['PayoutRequestStatus'];
        occurredAt: Date;
        actorId?: string | null;
        reason?: string;
      }[] = [{ status: 'REQUESTED', occurredAt: input.requestedAt }];
      let batchId: string | null = null;
      if (input.status === 'REJECTED') {
        await ledger.reverse(tx, posted.transactionId, `${input.reference}-REJ`);
        events.push({ status: 'REJECTED', occurredAt: step(5 * HOUR), actorId: checker });
      } else if (input.status !== 'REQUESTED') {
        const executed = input.status === 'EXECUTED';
        batchId = await batchFor(input.requestedAt, executed);
        events.push({ status: 'CHECKED', occurredAt: step(4 * HOUR), actorId: checker });
        if (input.status === 'SENT' || executed)
          events.push({ status: 'SENT', occurredAt: step(2 * DAY) });
        if (executed) {
          await ledger.post(tx, {
            type: 'PAYOUT_EXECUTED',
            reference: input.reference,
            entries: [
              { account: accounts.payoutPayable(), direction: 'D', amount: input.net },
              { account: accounts.bankPayment(), direction: 'C', amount: input.net },
            ],
          });
          events.push({ status: 'EXECUTED', occurredAt: step(2 * DAY + 1) });
        }
      }
      await tx.payoutRequest.create({
        data: {
          id: input.id,
          reference: input.reference,
          merchantId: input.merchantId,
          creditType: input.creditType,
          status: input.status,
          grossMillimes: input.gross,
          commissionRateBps: input.rateBps,
          commissionMillimes: input.commission,
          netMillimes: input.net,
          iban: seal(input.iban),
          transactionId: posted.transactionId,
          requestedAt: input.requestedAt,
          batchId,
          events: {
            create: events.map((event) => ({
              status: event.status,
              occurredAt: event.occurredAt,
              actorId: event.actorId ?? null,
              reason: event.reason ?? null,
            })),
          },
        },
      });
      // An executed payout settles the earlier collected payments of the type that it covers.
      if (input.status === 'EXECUTED') {
        let left = input.gross;
        const covered: string[] = [];
        for (const row of coverable) {
          if (row.amount > left || row.confirmedAt === null || row.confirmedAt > input.requestedAt)
            continue;
          left -= row.amount;
          covered.push(row.id);
          row.payoutId = input.id;
        }
        if (covered.length > 0) {
          await tx.payment.updateMany({
            where: { id: { in: covered } },
            data: { payoutId: input.id, status: 'SETTLED' },
          });
          await tx.paymentEvent.createMany({
            data: covered.map((paymentId) => ({
              paymentId,
              status: 'SETTLED' as const,
              occurredAt: step(2 * DAY + 1),
            })),
          });
        }
      }
    }

    for (const request of snap.merchant.payouts) {
      steps.push({
        at: at(request.requestedAt).getTime(),
        run: () =>
          payout({
            id: request.id,
            reference: request.reference,
            merchantId: demoMerchantId,
            creditType: request.creditType,
            status: request.status,
            gross: big(request.grossMillimes),
            rateBps: request.commissionRateBps,
            commission: big(request.commissionMillimes),
            net: big(request.netMillimes),
            requestedAt: at(request.requestedAt),
            iban: DEMO_IBAN,
          }),
      });
    }
    for (const request of snap.admin.payoutRequests) {
      steps.push({
        at: at(request.requestedAt).getTime(),
        run: () =>
          payout({
            id: request.id,
            reference: request.reference,
            merchantId: request.merchantId,
            creditType: request.creditType,
            status: request.status,
            gross: big(request.grossMillimes),
            rateBps: request.commissionRateBps,
            commission: big(request.commissionMillimes),
            net: big(request.netMillimes),
            requestedAt: at(request.requestedAt),
            iban: request.iban,
          }),
      });
    }
    // Batches must exist before the payouts point to them: payouts are linked after creation.
    steps.sort((a, b) => a.at - b.at);
    for (const step of steps) await step.run();
    // Settled payments that no payout covered stay settled (history older than the payouts).
    const uncovered = paymentRows
      .filter((row) => row.status === 'SETTLED' && row.payoutId === undefined)
      .map((row) => row.id);
    if (uncovered.length > 0) {
      await tx.payment.updateMany({
        where: { id: { in: uncovered } },
        data: { status: 'SETTLED' },
      });
    }

    // Demo company: credits allocated this month (employees list), then its balances per type.
    const early = new Date(monthStart.getTime() + 2 * DAY);
    const allocatedNow = early.getTime() < now.getTime() ? early : new Date(now.getTime() - HOUR);
    for (const employee of snap.company.employees) {
      if (
        employee.id === yasmineId ||
        employee.status !== 'ACTIVE' ||
        employee.monthAllocatedMillimes === 0
      )
        continue;
      await allocate(
        demoCompanyId,
        employee.id,
        'RESTAURATION',
        big(employee.monthAllocatedMillimes),
        allocatedNow,
      );
    }
    const others = payersOf.get(demoCompanyId) ?? [];
    for (const creditType of CREDIT_TYPES) {
      const wallet = accounts.companyWallet(demoCompanyId, creditType);
      const target = big(snap.company.balances[creditType]);
      const balance = await ledger.balance(tx, wallet);
      if (balance < target) {
        await fundAccount(wallet, target, `SEED-OPENING-${demoCompanyId.slice(0, 8)}`);
        continue;
      }
      // Credits allocated during the previous months (spread over the active employees).
      let excess = balance - target;
      for (let index = 0; excess > 0n && index < others.length; index += 1) {
        const employee = others[index];
        if (employee === undefined) break;
        const remaining = BigInt(others.length - index);
        const share = index === others.length - 1 ? excess : (excess / remaining / 1_000n) * 1_000n;
        if (share <= 0n) continue;
        const month = (index % 5) + 1;
        const when = new Date(monthStart.getTime() - (month * 30 - 5) * DAY);
        await allocate(demoCompanyId, employee.id, creditType, share, when);
        excess -= share;
      }
    }

    // -------------------------------------------------------------- KYC
    for (const file of snap.admin.kycFiles) {
      await tx.kycFile.create({
        data: {
          id: file.id,
          accountType: file.accountType,
          // Opened by the second demo administrator: the first one (and the others) can decide it.
          createdBy: demo.adminIds['Hela R.'] ?? null,
          companyId: file.accountType === 'COMPANY' ? file.accountId : null,
          merchantId: file.accountType === 'MERCHANT' ? file.accountId : null,
          status: file.status,
          rejectionReason: file.rejectionReason ?? null,
          submittedAt: at(file.submittedAt),
          documents: {
            create: file.documents.map((document) => ({
              id: document.id,
              type: document.type,
              fileName: document.fileName,
              contentType: 'image/png',
              sizeBytes: placeholderPng().length,
              storageKey: pngKey,
              uploadedAt: at(document.uploadedAt),
            })),
          },
          events: {
            create: file.history.map((event) => ({
              action: event.action,
              actorName: event.actorName,
              reason: event.reason ?? null,
              occurredAt: at(event.occurredAt),
            })),
          },
        },
      });
    }

    // -------------------------------------------------------------- approvals, audit, messages
    const profileByName = new Map(snap.admin.profiles.map((item) => [item.name, item.id]));
    for (const approval of snap.admin.approvals) {
      const decided = approval.status !== 'PENDING';
      const commission = approval.type === 'COMMISSION_RATE_CHANGE';
      await tx.approval.create({
        data: {
          id: approval.id,
          type: approval.type,
          status: approval.status,
          subject: approval.subject,
          payload: commission
            ? {
                profileId: approval.profileId ?? profileByName.get(approval.subject) ?? '',
                newRateBps: approval.newRateBps ?? 0,
              }
            : { ...settings, payoutMinimumMillimes: 10_000 },
          oldRateBps: approval.oldRateBps ?? null,
          newRateBps: approval.newRateBps ?? null,
          reason: approval.reason ?? '',
          initiatorId: approval.initiatorId,
          initiatorName: approval.initiatorName,
          deciderId: decided ? checker : null,
          decidedAt: decided ? new Date(at(approval.createdAt).getTime() + DAY) : null,
          createdAt: at(approval.createdAt),
        },
      });
    }
    await tx.auditLog.createMany({
      data: snap.admin.audit.map((entry) => ({
        id: entry.id,
        occurredAt: at(entry.occurredAt),
        actorUserId: userIdOf(entry.actorName),
        actorName: entry.actorName,
        action: entry.action,
        target: entry.target.slice(0, 200),
      })),
    });
    await tx.contactMessage.createMany({
      data: snap.admin.contactMessages.map((message) => ({
        id: message.id,
        reference: message.reference,
        name: message.name,
        email: message.email,
        phone: sealNullable(message.phone),
        companyName: message.companyName,
        requesterType: message.requesterType,
        message: message.message,
        status: message.status,
        receivedAt: at(message.receivedAt),
        handledAt: message.handledAt === null ? null : at(message.handledAt),
        handledBy: message.handledBy,
        note: message.note,
      })),
    });
    await tx.merchantDocument.createMany({
      data: snap.merchant.documents.map((document) => ({
        id: document.id,
        merchantId: demoMerchantId,
        type: document.type,
        period: document.period,
        issuedAt: at(document.issuedAt),
      })),
    });

    // -------------------------------------------------------------- reference sequences
    const maxOf = (references: readonly string[]) =>
      Math.max(0, ...references.map((reference) => Number(/(\d+)$/.exec(reference)?.[1] ?? 0)));
    const sequences: [string, number, number][] = [
      ['order_reference_seq', 7_300, maxOf(snap.orders.map((order) => order.reference))],
      ['invoice_number_seq', 5_400, maxOf(invoices.map((invoice) => invoice.number))],
      [
        'payment_reference_seq',
        9_000,
        maxOf([
          ...snap.merchant.payments.map((row) => row.reference),
          ...snap.admin.transactions.map((row) => row.reference),
          ...snap.employee.operations
            .filter((op) => op.type === 'PAYMENT')
            .map((op) => op.reference),
        ]),
      ],
      [
        'payout_reference_seq',
        4_100,
        maxOf([...snap.merchant.payouts, ...snap.admin.payoutRequests].map((row) => row.reference)),
      ],
      [
        'contact_reference_seq',
        1_041,
        maxOf(snap.admin.contactMessages.map((row) => row.reference)),
      ],
    ];
    for (const [name, start, max] of sequences) {
      await tx.$queryRaw`SELECT setval(${name}::regclass, ${Math.max(max, start - 1)})`;
    }

    // -------------------------------------------------------------- checks
    const reconciliation = await ledger.reconcile(tx);
    if (!reconciliation.ok)
      throw new Error(`seed: ledger not reconciled (${reconciliation.mismatches.join(', ')})`);
    for (const creditType of CREDIT_TYPES) {
      const company = await ledger.balance(tx, accounts.companyWallet(demoCompanyId, creditType));
      if (company !== big(snap.company.balances[creditType]))
        throw new Error(`seed: company balance ${creditType} differs from MSW`);
      const employee = await ledger.balance(tx, accounts.employeeWallet(yasmineId, creditType));
      if (employee !== big(snap.employee.balances[creditType]))
        throw new Error(`seed: beneficiary balance ${creditType} differs from MSW`);
    }
    return {
      companies: snap.admin.companies.length,
      merchants: merchantRows.length,
      employees: await tx.employee.count(),
      orders: snap.orders.length,
      payments: paymentRows.length,
      payouts: snap.merchant.payouts.length + snap.admin.payoutRequests.length,
      batches: batches.size,
      openings,
      totalDebits: reconciliation.totalDebits,
    };
  },
  { timeout: 15 * 60_000, maxWait: 30_000 },
);

await prisma.$disconnect();
console.log(
  `seed done: ${String(summary.companies)} companies, ${String(summary.merchants)} merchants, ` +
    `${String(summary.employees)} employees, ${String(summary.orders)} orders, ` +
    `${String(summary.payments)} payments, ${String(summary.payouts)} payouts, ` +
    `${String(summary.batches)} batches; ${String(summary.openings.count)} opening entries; ` +
    'ledger reconciled, demo balances equal to MSW.',
);
