import type { Role, SubRole } from '../generated/prisma/enums.js';

// Permissions computed by the server from the role and the sub-role of the SESSION (never from the
// request), checked on every route by the global guard (securite B5-S02). Matrix of the user
// (plan of 2026-10-21); names follow the contract pattern `module.action`.

/** Any signed-in user, whatever the role (own session, own profile). */
export const SELF = 'session.self';

const COMPANY_OWNER = [
  'balances.read',
  'employees.read',
  'employees.manage',
  'credits.allocate',
  'orders.read',
  'orders.create',
  'orders.declareTransfer',
  'fundingAccount.read',
  'invoices.read',
  'kyc.submit',
  'team.manage',
] as const;

const MERCHANT_OWNER = [
  'stats.read',
  'sales.read',
  'payments.collect',
  'payments.refund',
  'receivables.read',
  'payouts.read',
  'payouts.request',
  'settlements.read',
  'documents.read',
  'shop.read',
  'kyc.submit',
  'team.manage',
  // Tills and their NFC stickers (M4): the owner only.
  'registers.manage',
] as const;

/**
 * W-SUP: every user of a company, a merchant or a beneficiary opens and follows its support
 * tickets; the web users (administrators included) have the global search.
 */
const SUPPORT_CLIENT = ['support.use'] as const;
const SEARCH = ['search.use'] as const;
/** The complete CIN or RIB of a client, through the blind index: Opérations only (W-SUP). */
const IDENTIFIER_SEARCH = ['search.identifiers'] as const;

// Admin permissions never reuse a company or merchant name: a tenant route must stay unreachable
// for an administrator (the matrix is per role, the guard checks names only).
const ADMIN_ALL = [
  'dashboard.read',
  'accounts.read',
  'transactions.read',
  'audit.read',
  'settings.read',
  'commissions.read',
  'creditOrders.read',
  'adminPayouts.read',
  'approvals.read',
  'kyc.read',
  'messages.read',
  'users.read',
  'userBalances.read',
  'risk.read',
  'disputes.read',
  'disputes.manage',
  'alerts.manage',
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
  // W-FIN: the general ledger (Finance and Super-admin only) and the invoices issued by FlexiPay.
  'ledger.read',
  'adminInvoices.read',
  // W-SUP: the queue of the support tickets (every administrator) and the global search.
  'tickets.read',
  'tickets.manage',
  'adminSearch.read',
] as const;

/**
 * Kept for the super-admin (requests of 2026-11-14 and 2026-11-17): the administrators' accounts
 * and roles, the requests to change the platform settings, and every change to a user account
 * (Opérations, Finance and Support only read the users).
 */
const SUPER_ADMIN_ONLY: readonly Permission[] = [
  'users.adminRoles',
  'settings.request',
  'users.manage',
  'users.support',
];

/** What Finance reads (decision C of 2026-10-23). */
const ADMIN_BACK_OFFICE_READ = [
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
] as const;

const EMPLOYEE = ['wallet.read', 'payments.pay', 'family.manage'] as const;
/** A family member pays and reads its own wallet; it never manages a family (processus v2). */
const FAMILY_MEMBER = ['wallet.read', 'payments.pay'] as const;

export type Permission =
  | (typeof COMPANY_OWNER)[number]
  | (typeof MERCHANT_OWNER)[number]
  | (typeof ADMIN_ALL)[number]
  | (typeof EMPLOYEE)[number]
  | (typeof SUPPORT_CLIENT)[number]
  | (typeof SEARCH)[number]
  | (typeof IDENTIFIER_SEARCH)[number]
  | 'sales.readToday';

/**
 * Role x sub-role matrix. A sub-role missing from the matrix gets nothing (deny by default).
 * - Company (request of 2026-11-14): Propriétaire (OWNER) = everything, and its RH and Finance
 *   users (`team.manage`); RH (MANAGER) = employees, departments, allocations, balances; Finance
 *   (FINANCE) = orders, transfer declarations, invoices. READ_ONLY and ACCOUNTANT are former
 *   sub-roles, no longer given (reading only, until the administrator changes them).
 * - Merchant: Propriétaire (OWNER) = everything, and its cashiers (`team.manage`); Caissier
 *   (CASHIER) = collect and the day's collections, nothing else. ACCOUNTANT is a former sub-role,
 *   no longer given (reading of the finances, no collect).
 * - Admin (decision C of 2026-10-23): SUPER_ADMIN = everything (admins, roles, statuses,
 *   settings), never an exception to the four eyes; Opérations (COMPLIANCE, request of
 *   2026-11-14) = the second administrator: everything but SUPER_ADMIN_ONLY; FINANCE = commissions and rates,
 *   credit orders, payouts, second validation, reading of accounts, transactions, balances, users,
 *   settings, audit; SUPPORT = reading of accounts, users, transactions, contact messages; never
 *   balances. Opérations, Finance and Support only READ the users (request of 2026-11-17).
 */
const MATRIX: Record<Role, Partial<Record<SubRole | 'NONE', readonly Permission[]>>> = {
  ADMIN: {
    SUPER_ADMIN: ADMIN_ALL,
    // The second administrator (request of 2026-11-14): everything but the administrators'
    // accounts, the platform settings and the changes to user accounts; the four eyes still apply.
    // The general ledger stays with Finance and the super-admin (request of 2026-11-19).
    COMPLIANCE: [
      ...ADMIN_ALL.filter(
        (permission) => !SUPER_ADMIN_ONLY.includes(permission) && permission !== 'ledger.read',
      ),
      ...IDENTIFIER_SEARCH,
    ],
    FINANCE: [
      ...ADMIN_BACK_OFFICE_READ,
      'settings.read',
      'disputes.read',
      'commissions.request',
      'orders.confirm',
      'orders.validate',
      'payouts.decide',
      'approvals.decide',
      'ledger.read',
      'adminInvoices.read',
      'tickets.read',
      'tickets.manage',
      'adminSearch.read',
    ],
    SUPPORT: [
      'accounts.read',
      'transactions.read',
      'users.read',
      'messages.read',
      'messages.handle',
      'tickets.read',
      'tickets.manage',
      'adminSearch.read',
    ],
  },
  COMPANY: {
    OWNER: [...COMPANY_OWNER, ...SUPPORT_CLIENT, ...SEARCH],
    MANAGER: [
      'balances.read',
      'employees.read',
      'employees.manage',
      'credits.allocate',
      ...SUPPORT_CLIENT,
      ...SEARCH,
    ],
    FINANCE: [
      'balances.read',
      'orders.read',
      'orders.create',
      'orders.declareTransfer',
      'fundingAccount.read',
      'invoices.read',
      ...SUPPORT_CLIENT,
      ...SEARCH,
    ],
    ACCOUNTANT: ['balances.read', 'orders.read', 'invoices.read', ...SUPPORT_CLIENT, ...SEARCH],
    READ_ONLY: [
      'balances.read',
      'employees.read',
      'orders.read',
      'invoices.read',
      ...SUPPORT_CLIENT,
      ...SEARCH,
    ],
  },
  MERCHANT: {
    OWNER: [...MERCHANT_OWNER, ...SUPPORT_CLIENT, ...SEARCH],
    CASHIER: ['payments.collect', 'sales.readToday', 'shop.read', ...SUPPORT_CLIENT, ...SEARCH],
    ACCOUNTANT: [
      'stats.read',
      'sales.read',
      'receivables.read',
      'payouts.read',
      'settlements.read',
      'documents.read',
      'shop.read',
      ...SUPPORT_CLIENT,
      ...SEARCH,
    ],
  },
  EMPLOYEE: { NONE: [...EMPLOYEE, ...SUPPORT_CLIENT] },
  FAMILY_MEMBER: { NONE: [...FAMILY_MEMBER, ...SUPPORT_CLIENT] },
};

/** Permissions of a session, published by GET /v1/me (the web masks what is not allowed). */
export function permissionsOf(role: Role, subRole: SubRole | null): Permission[] {
  return [...(MATRIX[role][subRole ?? 'NONE'] ?? [])];
}

/** True when the session holds one of the permissions of the route (or the route is SELF). */
export function allows(
  role: Role,
  subRole: SubRole | null,
  required: readonly (Permission | typeof SELF)[],
): boolean {
  if (required.includes(SELF)) return true;
  const held = permissionsOf(role, subRole);
  return required.some((permission) => permission !== SELF && held.includes(permission));
}
