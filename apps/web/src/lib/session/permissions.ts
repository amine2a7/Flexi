interface WithPermissions {
  readonly permissions: readonly string[];
}

/**
 * Permission needed to open each page of the web spaces (any one of them), matched by the longest
 * path prefix; names of the server matrix (apps/api/src/common/permissions.ts, decision C of
 * 2026-10-23), which the API publishes in `/v1/me`. A display comfort only: the API refuses every
 * request the session does not allow. A path outside the table is open (the API decides).
 */
const PAGE_PERMISSIONS: Readonly<Record<string, readonly string[]>> = {
  '/admin': ['dashboard.read'],
  '/admin/commercants': ['accounts.read'],
  '/admin/entreprises': ['accounts.read'],
  '/admin/utilisateurs': ['users.read'],
  '/admin/kyc': ['kyc.read'],
  '/admin/commandes': ['creditOrders.read'],
  '/admin/virements': ['adminPayouts.read'],
  '/admin/reglements': ['adminPayouts.read'],
  '/admin/commissions': ['commissions.read'],
  '/admin/validations': ['approvals.read'],
  '/admin/transactions': ['transactions.read'],
  '/admin/audit': ['audit.read'],
  '/admin/messages': ['messages.read'],
  '/admin/parametres': ['settings.read'],
  '/entreprise': ['balances.read'],
  '/entreprise/employes': ['employees.read'],
  '/entreprise/employes/import': ['employees.manage'],
  '/entreprise/commandes': ['orders.read'],
  '/entreprise/commandes/nouvelle': ['orders.create'],
  '/entreprise/attribution': ['credits.allocate'],
  '/entreprise/factures': ['invoices.read'],
  '/entreprise/reporting': ['balances.read'],
  '/commercant': ['stats.read'],
  '/commercant/encaissement': ['payments.collect'],
  '/commercant/historique': ['sales.read', 'sales.readToday'],
  '/commercant/creances': ['receivables.read'],
  '/commercant/virements': ['payouts.read'],
  '/commercant/reglements': ['settlements.read'],
  '/commercant/mon-commerce': ['shop.read'],
  '/commercant/statistiques': ['stats.read'],
};

/** True when the session holds one of the permissions. */
export function can(me: WithPermissions, ...required: readonly string[]): boolean {
  return required.some((permission) => me.permissions.includes(permission));
}

function pagePermissions(pathname: string): readonly string[] | undefined {
  let best: string | undefined;
  for (const prefix of Object.keys(PAGE_PERMISSIONS)) {
    const matches = pathname === prefix || pathname.startsWith(`${prefix}/`);
    if (matches && (best === undefined || prefix.length > best.length)) best = prefix;
  }
  return best === undefined ? undefined : PAGE_PERMISSIONS[best];
}

/** True when the session may open the page (menu entry shown, no « Accès refusé »). */
export function canOpen(me: WithPermissions, pathname: string): boolean {
  const required = pagePermissions(pathname);
  return required === undefined || can(me, ...required);
}

/** First page of the list the session may open (the landing page when the home is denied). */
export function firstOpenPage(me: WithPermissions, paths: readonly string[]): string | undefined {
  return paths.find((path) => canOpen(me, path));
}
