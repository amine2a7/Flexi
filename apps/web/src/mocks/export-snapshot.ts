// Development only: prints the initial data of the mocked API as JSON, so that the database seed
// of the real API (apps/api/prisma/seed.ts) loads the same accounts and the same data as MSW.
//   node --import tsx apps/web/src/mocks/export-snapshot.ts > snapshot.json
// Never imported by the application (mock code is excluded from production builds: test/build).
import { ADMIN_IDS, db, invoicesOf } from './db';
import { EMPLOYEE_SHOPS, employeeBalance } from './employee-seed';
import { CREDIT_TYPES } from './credit-types';
import {
  COMPANY_TENANT,
  DEMO_FIRST_LOGIN_PASSWORD,
  DEMO_PASSWORD,
  DEMO_PIN,
  DEMO_RECOVERY_CODES,
  MERCHANT_TENANT,
} from './fixtures/accounts';
import { FIRST_NAMES, LAST_NAMES, createRandom, tunisianPhone } from './fixtures/random';

/** Employees of the other companies: MSW only counts them (employeesCount), the seed creates them. */
function otherEmployees() {
  const random = createRandom(59);
  return db.admin.companies
    .filter((company) => company.id !== COMPANY_TENANT.id)
    .map((company) => ({
      companyId: company.id,
      employees: Array.from({ length: company.employeesCount }, (_, index) => {
        const roll = random.next();
        return {
          id: random.uuid(),
          employeeNumber: `EMP-${String(1001 + index)}`,
          firstName: random.pick(FIRST_NAMES),
          lastName: random.pick(LAST_NAMES),
          phone: tunisianPhone(random),
          status: roll < 0.86 ? 'ACTIVE' : roll < 0.95 ? 'INVITED' : 'SUSPENDED',
        };
      }),
    }));
}

const snapshot = {
  now: new Date().toISOString(),
  demo: {
    password: DEMO_PASSWORD,
    firstLoginPassword: DEMO_FIRST_LOGIN_PASSWORD,
    pin: DEMO_PIN,
    recoveryCodes: DEMO_RECOVERY_CODES,
    adminIds: ADMIN_IDS,
    companyTenant: COMPANY_TENANT,
    merchantTenant: MERCHANT_TENANT,
  },
  accounts: db.accounts,
  merchant: {
    rateBps: db.merchant.rateBps,
    payments: db.merchant.payments,
    payouts: db.merchant.payouts,
    documents: db.merchant.documents,
    profile: db.merchant.profile,
  },
  company: {
    balances: db.company.balances,
    employees: db.company.employees,
    invoices: invoicesOf(db.orders),
  },
  admin: {
    merchants: db.admin.merchants,
    companies: db.admin.companies,
    approvals: db.admin.approvals,
    batches: db.admin.batches,
    audit: db.admin.audit,
    settings: db.admin.settings,
    kycFiles: db.admin.kycFiles,
    payoutRequests: db.admin.payoutRequests,
    transactions: db.admin.transactions,
    contactMessages: db.admin.contactMessages,
  },
  orders: db.orders.map(({ proof: _proof, ...order }) => order),
  employee: {
    profile: db.employee.profile,
    operations: db.employee.operations,
    balances: Object.fromEntries(
      CREDIT_TYPES.map((type) => [type, employeeBalance(db.employee, type)]),
    ),
  },
  shops: EMPLOYEE_SHOPS,
  otherEmployees: otherEmployees(),
};

process.stdout.write(JSON.stringify(snapshot));
