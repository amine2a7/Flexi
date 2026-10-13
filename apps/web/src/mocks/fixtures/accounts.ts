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
      permissions: [
        'merchants.manage',
        'companies.manage',
        'commissions.request',
        'approvals.decide',
        'audit.read',
        'settings.request',
      ],
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
      permissions: [
        'merchants.manage',
        'companies.manage',
        'commissions.request',
        'approvals.decide',
        'audit.read',
        'settings.request',
      ],
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
      permissions: ['employees.manage', 'orders.create', 'credits.allocate', 'invoices.read'],
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
      permissions: ['payments.collect', 'sales.read', 'payouts.request', 'settlements.read'],
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
      permissions: ['wallet.read', 'payments.pay'],
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
      permissions: ['employees.manage', 'credits.allocate'],
    },
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
] as const;

export const DEMO_ACCOUNTS_MARKER = MOCK_FIXTURE_SENTINEL;
