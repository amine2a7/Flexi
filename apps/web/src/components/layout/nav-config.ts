import type { Schemas } from '@flexipay/api-client';
import {
  ArrowLeftRight,
  Building2,
  CalendarCheck,
  ClipboardCheck,
  FileText,
  HandCoins,
  History,
  LayoutDashboard,
  Percent,
  Receipt,
  ScrollText,
  Settings,
  ShoppingCart,
  Store,
  Users,
  Wallet,
  type LucideIcon,
} from 'lucide-react';

export interface NavItem {
  readonly href: string;
  readonly labelKey: string;
  readonly icon: LucideIcon;
}

type Role = Schemas['Role'];

// Navigation of each space (navigation.md N.1-N.3). Support and Statistics are not listed until
// they have a spec (decision 6); there is no role switch (decision 25).
export const NAVIGATION: Partial<Record<Role, readonly NavItem[]>> = {
  MERCHANT: [
    { href: '/commercant', labelKey: 'nav.merchant.dashboard', icon: LayoutDashboard },
    { href: '/commercant/encaissement', labelKey: 'nav.merchant.collect', icon: HandCoins },
    { href: '/commercant/historique', labelKey: 'nav.merchant.history', icon: History },
    { href: '/commercant/creances', labelKey: 'nav.merchant.receivables', icon: CalendarCheck },
    { href: '/commercant/virements', labelKey: 'nav.merchant.payouts', icon: ArrowLeftRight },
    { href: '/commercant/reglements', labelKey: 'nav.merchant.settlements', icon: FileText },
    { href: '/commercant/mon-commerce', labelKey: 'nav.merchant.shop', icon: Store },
  ],
  COMPANY: [
    { href: '/entreprise', labelKey: 'nav.company.dashboard', icon: LayoutDashboard },
    { href: '/entreprise/employes', labelKey: 'nav.company.employees', icon: Users },
    { href: '/entreprise/commandes', labelKey: 'nav.company.orders', icon: ShoppingCart },
    { href: '/entreprise/attribution', labelKey: 'nav.company.allocation', icon: Wallet },
    { href: '/entreprise/factures', labelKey: 'nav.company.invoices', icon: Receipt },
  ],
  ADMIN: [
    { href: '/admin', labelKey: 'nav.admin.dashboard', icon: LayoutDashboard },
    { href: '/admin/commercants', labelKey: 'nav.admin.merchants', icon: Store },
    { href: '/admin/entreprises', labelKey: 'nav.admin.companies', icon: Building2 },
    { href: '/admin/commissions', labelKey: 'nav.admin.commissions', icon: Percent },
    { href: '/admin/validations', labelKey: 'nav.admin.approvals', icon: ClipboardCheck },
    { href: '/admin/reglements', labelKey: 'nav.admin.settlements', icon: ArrowLeftRight },
    { href: '/admin/audit', labelKey: 'nav.admin.audit', icon: ScrollText },
    { href: '/admin/parametres', labelKey: 'nav.admin.settings', icon: Settings },
  ],
};

/** The current item: exact match for a space home, prefix match for the other entries. */
export function isActive(item: NavItem, pathname: string, home: string): boolean {
  return item.href === home
    ? pathname === home
    : pathname === item.href || pathname.startsWith(`${item.href}/`);
}
