// Simulated `/v1/me` permissions of the demo accounts, local to the tests (the app only talks to
// the API). Copy of the server matrix (apps/api/src/common/permissions.ts, decision C of 2026-10-23).
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

const PERMISSIONS: Readonly<Record<string, readonly string[]>> = {
  'admin@flexipay.test': [
    ...BACK_OFFICE_READ,
    'settings.read',
    'messages.read',
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
  ],
  'operations@flexipay.test': [
    ...BACK_OFFICE_READ,
    'kyc.decide',
    'kycDocuments.read',
    'risk.read',
    'disputes.read',
    'disputes.manage',
    'alerts.manage',
  ],
  'admin2@flexipay.test': [
    ...BACK_OFFICE_READ,
    'settings.read',
    'disputes.read',
    'commissions.request',
    'orders.confirm',
    'orders.validate',
    'payouts.decide',
    'approvals.decide',
  ],
  'support@flexipay.test': [
    'accounts.read',
    'transactions.read',
    'users.read',
    'users.support',
    'messages.read',
    'messages.handle',
  ],
  'rh@flexipay.test': ['balances.read', 'employees.read', 'employees.manage', 'credits.allocate'],
  'lecture@flexipay.test': ['balances.read', 'employees.read', 'orders.read', 'invoices.read'],
  'caissier@flexipay.test': ['payments.collect', 'sales.readToday', 'shop.read'],
  'beneficiaire@flexipay.test': ['wallet.read', 'payments.pay'],
};

export function sessionOf(identifier: string): { permissions: readonly string[] } {
  const permissions = PERMISSIONS[identifier];
  if (permissions === undefined) throw new Error(identifier);
  return { permissions };
}
