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
] as const;

const MERCHANT_OWNER = [
  'stats.read',
  'sales.read',
  'payments.collect',
  'receivables.read',
  'payouts.read',
  'payouts.request',
  'settlements.read',
  'documents.read',
  'shop.read',
] as const;

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
] as const;

/** What Opérations (COMPLIANCE) and Finance both read (decision C of 2026-10-23). */
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

const EMPLOYEE = ['wallet.read', 'payments.pay'] as const;

export type Permission =
  | (typeof COMPANY_OWNER)[number]
  | (typeof MERCHANT_OWNER)[number]
  | (typeof ADMIN_ALL)[number]
  | (typeof EMPLOYEE)[number]
  | 'sales.readToday';

/**
 * Role x sub-role matrix. A sub-role missing from the matrix gets nothing (deny by default).
 * - Company: Administrateur (OWNER) = everything; RH (MANAGER) = employees, allocations, balances;
 *   Comptable (ACCOUNTANT) = orders, transfer declarations, invoices; READ_ONLY = reading.
 * - Merchant: Gérant (OWNER) = everything; Caissier (CASHIER) = collect and the day's history,
 *   no payout (IBAN masked everywhere); ACCOUNTANT = reading of the finances, no collect.
 * - Admin (decision C of 2026-10-23): SUPER_ADMIN = everything (admins, roles, statuses,
 *   settings), never an exception to the four eyes; Opérations (COMPLIANCE) = KYC and audit, reading
 *   of accounts, commissions, orders, settlements, balances, users; FINANCE = commissions and rates,
 *   credit orders, payouts, second validation, reading of accounts, transactions, balances, users,
 *   settings, audit; SUPPORT = reading of accounts, users, transactions, invitation resend and PIN
 *   unlock, contact messages; never balances.
 */
const MATRIX: Record<Role, Partial<Record<SubRole | 'NONE', readonly Permission[]>>> = {
  ADMIN: {
    SUPER_ADMIN: ADMIN_ALL,
    COMPLIANCE: [...ADMIN_BACK_OFFICE_READ, 'kyc.decide', 'kycDocuments.read'],
    FINANCE: [
      ...ADMIN_BACK_OFFICE_READ,
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
  },
  COMPANY: {
    OWNER: COMPANY_OWNER,
    MANAGER: ['balances.read', 'employees.read', 'employees.manage', 'credits.allocate'],
    ACCOUNTANT: [
      'balances.read',
      'orders.read',
      'orders.create',
      'orders.declareTransfer',
      'fundingAccount.read',
      'invoices.read',
    ],
    READ_ONLY: ['balances.read', 'employees.read', 'orders.read', 'invoices.read'],
  },
  MERCHANT: {
    OWNER: MERCHANT_OWNER,
    CASHIER: ['payments.collect', 'sales.readToday', 'shop.read'],
    ACCOUNTANT: [
      'stats.read',
      'sales.read',
      'receivables.read',
      'payouts.read',
      'settlements.read',
      'documents.read',
      'shop.read',
    ],
  },
  EMPLOYEE: { NONE: EMPLOYEE },
  FAMILY_MEMBER: { NONE: EMPLOYEE },
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
