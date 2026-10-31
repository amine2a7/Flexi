import type { Schemas } from '@flexipay/api-client';
import { MOCK_FIXTURE_SENTINEL } from './sentinel';

// Demo accounts of the mocked API (development only, never in a production build: test/build).
// The MFA code is the same for every account; the password is demo data and does not follow the
// password policy of decision 9 (which applies when a password is created or changed).
export const DEMO_MFA_CODE = '123456';
export const DEMO_PASSWORD = 'Test1234!';
export const DEMO_FIRST_LOGIN_PASSWORD = 'Temp1234!';
/** Payment PIN of the demo beneficiary (mobile and web beneficiary space). */
export const DEMO_PIN = '1234';
export const DEMO_RECOVERY_CODES = [
  'ABCD2345EF',
  'GHJK6789LM',
  'NPQR2345ST',
  'UVWX6789YZ',
  'BCDF2345GH',
  'JKLM6789NP',
  'QRST2345UV',
  'WXYZ6789AB',
  'CDEF2345HJ',
  'KLMN6789PQ',
] as const;

export interface DemoAccount {
  readonly id: string;
  readonly identifier: string;
  password: string;
  readonly role: Schemas['Role'];
  readonly subRole: Schemas['SubRole'] | null;
  readonly displayName: string;
  readonly tenant: Schemas['TenantSummary'] | null;
  temporaryPassword: boolean;
  mfaEnrolled: boolean;
  recoveryCodes: string[];
  readonly permissions: readonly string[];
}

export const COMPANY_TENANT = {
  id: '01930a1c-2b3d-7e4f-8a5b-6c7d8e9f0a1b',
  label: 'Groupe Carthage Services',
};
export const MERCHANT_TENANT = {
  id: '01930a1c-3c4d-7f5a-9b6c-7d8e9f0a1b2c',
  label: 'Café El Medina',
};

/** Permissions of the server matrix (apps/api/src/common/permissions.ts, decision C of 2026-10-23). */
const BACK_OFFICE_READ = [
  'dashboard.read',
  'accounts.read',
  'transactions.read',
  'audit.read',
  'commissions.read',
  'creditOrders.read',
  'adminPayouts.read',
  'approvals.read',
  'kyc.read',
  'users.read',
  'userBalances.read',
];
const PERMISSIONS = {
  SUPER_ADMIN: [
    ...BACK_OFFICE_READ,
    'settings.read',
    'messages.read',
    'risk.read',
    'disputes.manage',
    'users.manage',
    'users.adminRoles',
    'users.support',
    'merchants.manage',
    'companies.manage',
    'commissions.request',
    'settings.request',
    'approvals.decide',
    'kyc.decide',
    'kycDocuments.read',
    'orders.confirm',
    'orders.validate',
    'payouts.decide',
    'messages.handle',
  ],
  COMPLIANCE: [
    ...BACK_OFFICE_READ,
    'kyc.decide',
    'kycDocuments.read',
    'risk.read',
    'disputes.manage',
  ],
  FINANCE: [
    ...BACK_OFFICE_READ,
    'settings.read',
    'commissions.request',
    'orders.confirm',
    'orders.validate',
    'payouts.decide',
    'approvals.decide',
  ],
  SUPPORT: [
    'accounts.read',
    'transactions.read',
    'users.read',
    'users.support',
    'messages.read',
    'messages.handle',
  ],
  COMPANY_OWNER: [
    'balances.read',
    'employees.read',
    'employees.manage',
    'credits.allocate',
    'orders.read',
    'orders.create',
    'orders.declareTransfer',
    'fundingAccount.read',
    'invoices.read',
  ],
  COMPANY_MANAGER: ['balances.read', 'employees.read', 'employees.manage', 'credits.allocate'],
  COMPANY_ACCOUNTANT: [
    'balances.read',
    'orders.read',
    'orders.create',
    'orders.declareTransfer',
    'fundingAccount.read',
    'invoices.read',
  ],
  COMPANY_READ_ONLY: ['balances.read', 'employees.read', 'orders.read', 'invoices.read'],
  MERCHANT_OWNER: [
    'stats.read',
    'sales.read',
    'payments.collect',
    'receivables.read',
    'payouts.read',
    'payouts.request',
    'settlements.read',
    'documents.read',
    'shop.read',
  ],
  MERCHANT_CASHIER: ['payments.collect', 'sales.readToday', 'shop.read'],
  MERCHANT_ACCOUNTANT: [
    'stats.read',
    'sales.read',
    'receivables.read',
    'payouts.read',
    'settlements.read',
    'documents.read',
    'shop.read',
  ],
  EMPLOYEE: ['wallet.read', 'payments.pay'],
} as const;

/** One fictitious account per sub-role (synthetic data only), same password and MFA code. */
function subRoleAccount(
  id: string,
  identifier: string,
  role: Schemas['Role'],
  subRole: Schemas['SubRole'],
  displayName: string,
  tenant: Schemas['TenantSummary'] | null,
  permissions: readonly string[],
): DemoAccount {
  return {
    id,
    identifier,
    password: DEMO_PASSWORD,
    role,
    subRole,
    displayName,
    tenant,
    temporaryPassword: false,
    mfaEnrolled: true,
    recoveryCodes: [...DEMO_RECOVERY_CODES],
    permissions,
  };
}

export function createDemoAccounts(): DemoAccount[] {
  return [
    {
      id: '01930a1c-0001-7a00-8000-000000000001',
      identifier: 'admin@flexipay.test',
      password: DEMO_PASSWORD,
      role: 'ADMIN',
      subRole: 'SUPER_ADMIN',
      displayName: 'Amine K.',
      tenant: null,
      temporaryPassword: false,
      mfaEnrolled: true,
      recoveryCodes: [...DEMO_RECOVERY_CODES],
      permissions: PERMISSIONS.SUPER_ADMIN,
    },
    {
      id: '01930a1c-0009-7a00-8000-000000000009',
      identifier: 'admin2@flexipay.test',
      password: DEMO_PASSWORD,
      role: 'ADMIN',
      subRole: 'FINANCE',
      displayName: 'Hela R.',
      tenant: null,
      temporaryPassword: false,
      mfaEnrolled: true,
      recoveryCodes: [...DEMO_RECOVERY_CODES],
      permissions: PERMISSIONS.FINANCE,
    },
    {
      id: '01930a1c-0002-7a00-8000-000000000002',
      identifier: 'entreprise@flexipay.test',
      password: DEMO_PASSWORD,
      role: 'COMPANY',
      subRole: 'OWNER',
      displayName: 'Leïla M.',
      tenant: COMPANY_TENANT,
      temporaryPassword: false,
      mfaEnrolled: true,
      recoveryCodes: [...DEMO_RECOVERY_CODES],
      permissions: PERMISSIONS.COMPANY_OWNER,
    },
    {
      id: '01930a1c-0003-7a00-8000-000000000003',
      identifier: 'commercant@flexipay.test',
      password: DEMO_PASSWORD,
      role: 'MERCHANT',
      subRole: 'OWNER',
      displayName: 'Sami B.',
      tenant: MERCHANT_TENANT,
      temporaryPassword: false,
      mfaEnrolled: true,
      recoveryCodes: [...DEMO_RECOVERY_CODES],
      permissions: PERMISSIONS.MERCHANT_OWNER,
    },
    {
      id: '01930a1c-0005-7a00-8000-000000000005',
      identifier: 'beneficiaire@flexipay.test',
      password: DEMO_PASSWORD,
      role: 'EMPLOYEE',
      subRole: null,
      displayName: 'Yasmine J.',
      tenant: COMPANY_TENANT,
      temporaryPassword: false,
      mfaEnrolled: true,
      recoveryCodes: [...DEMO_RECOVERY_CODES],
      permissions: PERMISSIONS.EMPLOYEE,
    },
    {
      id: '01930a1c-0004-7a00-8000-000000000004',
      identifier: 'premiere@flexipay.test',
      password: DEMO_FIRST_LOGIN_PASSWORD,
      role: 'COMPANY',
      subRole: 'MANAGER',
      displayName: 'Nour T.',
      tenant: COMPANY_TENANT,
      temporaryPassword: true,
      mfaEnrolled: false,
      recoveryCodes: [],
      permissions: PERMISSIONS.COMPANY_MANAGER,
    },
    subRoleAccount(
      '01930a1c-000a-7a00-8000-00000000000a',
      'operations@flexipay.test',
      'ADMIN',
      'COMPLIANCE',
      'Mehdi S.',
      null,
      PERMISSIONS.COMPLIANCE,
    ),
    subRoleAccount(
      '01930a1c-000b-7a00-8000-00000000000b',
      'support@flexipay.test',
      'ADMIN',
      'SUPPORT',
      'Olfa D.',
      null,
      PERMISSIONS.SUPPORT,
    ),
    subRoleAccount(
      '01930a1c-000c-7a00-8000-00000000000c',
      'rh@flexipay.test',
      'COMPANY',
      'MANAGER',
      'Sarra B.',
      COMPANY_TENANT,
      PERMISSIONS.COMPANY_MANAGER,
    ),
    subRoleAccount(
      '01930a1c-000d-7a00-8000-00000000000d',
      'comptable@flexipay.test',
      'COMPANY',
      'ACCOUNTANT',
      'Karim J.',
      COMPANY_TENANT,
      PERMISSIONS.COMPANY_ACCOUNTANT,
    ),
    subRoleAccount(
      '01930a1c-000e-7a00-8000-00000000000e',
      'lecture@flexipay.test',
      'COMPANY',
      'READ_ONLY',
      'Ines A.',
      COMPANY_TENANT,
      PERMISSIONS.COMPANY_READ_ONLY,
    ),
    subRoleAccount(
      '01930a1c-000f-7a00-8000-00000000000f',
      'caissier@flexipay.test',
      'MERCHANT',
      'CASHIER',
      'Salma B.',
      MERCHANT_TENANT,
      PERMISSIONS.MERCHANT_CASHIER,
    ),
    subRoleAccount(
      '01930a1c-0010-7a00-8000-000000000010',
      'comptable-commerce@flexipay.test',
      'MERCHANT',
      'ACCOUNTANT',
      'Imen J.',
      MERCHANT_TENANT,
      PERMISSIONS.MERCHANT_ACCOUNTANT,
    ),
  ];
}

/** Shown in the development panel of /login (never rendered in a production build). */
export const DEMO_ACCOUNT_HINTS = [
  { role: 'admin', identifier: 'admin@flexipay.test', password: DEMO_PASSWORD },
  { role: 'admin2', identifier: 'admin2@flexipay.test', password: DEMO_PASSWORD },
  { role: 'company', identifier: 'entreprise@flexipay.test', password: DEMO_PASSWORD },
  { role: 'merchant', identifier: 'commercant@flexipay.test', password: DEMO_PASSWORD },
  { role: 'beneficiary', identifier: 'beneficiaire@flexipay.test', password: DEMO_PASSWORD },
  { role: 'firstLogin', identifier: 'premiere@flexipay.test', password: DEMO_FIRST_LOGIN_PASSWORD },
  { role: 'operations', identifier: 'operations@flexipay.test', password: DEMO_PASSWORD },
  { role: 'support', identifier: 'support@flexipay.test', password: DEMO_PASSWORD },
  { role: 'hr', identifier: 'rh@flexipay.test', password: DEMO_PASSWORD },
  { role: 'accountant', identifier: 'comptable@flexipay.test', password: DEMO_PASSWORD },
  { role: 'readOnly', identifier: 'lecture@flexipay.test', password: DEMO_PASSWORD },
  { role: 'cashier', identifier: 'caissier@flexipay.test', password: DEMO_PASSWORD },
  {
    role: 'merchantAccountant',
    identifier: 'comptable-commerce@flexipay.test',
    password: DEMO_PASSWORD,
  },
] as const;

export const DEMO_ACCOUNTS_MARKER = MOCK_FIXTURE_SENTINEL;
