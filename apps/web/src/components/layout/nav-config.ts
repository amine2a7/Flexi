import type { Schemas } from '@flexipay/api-client';
import type { NavCounter } from './nav-counters';
import {
  ArrowLeftRight,
  Building2,
  CalendarCheck,
  ClipboardCheck,
  CreditCard,
  FileSearch,
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
  /** Green counter of what waits for an action (nav-counters.ts). */
  readonly counter?: NavCounter;
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
    {
      href: '/entreprise/commandes',
      labelKey: 'nav.company.orders',
      icon: ShoppingCart,
      counter: 'companyOrdersToPay',
    },
    { href: '/entreprise/attribution', labelKey: 'nav.company.allocation', icon: Wallet },
    { href: '/entreprise/factures', labelKey: 'nav.company.invoices', icon: Receipt },
  ],
  ADMIN: [
    { href: '/admin', labelKey: 'nav.admin.dashboard', icon: LayoutDashboard },
    { href: '/admin/commercants', labelKey: 'nav.admin.merchants', icon: Store },
    { href: '/admin/entreprises', labelKey: 'nav.admin.companies', icon: Building2 },
    { href: '/admin/kyc', labelKey: 'nav.admin.kyc', icon: FileSearch, counter: 'adminKyc' },
    {
      href: '/admin/commandes',
      labelKey: 'nav.admin.orders',
      icon: ShoppingCart,
      counter: 'adminOrdersToHandle',
    },
    {
      href: '/admin/virements',
      labelKey: 'nav.admin.payouts',
      icon: ArrowLeftRight,
      counter: 'adminPayouts',
    },
    { href: '/admin/commissions', labelKey: 'nav.admin.commissions', icon: Percent },
    {
      href: '/admin/validations',
      labelKey: 'nav.admin.approvals',
      icon: ClipboardCheck,
      counter: 'adminApprovals',
    },
    { href: '/admin/reglements', labelKey: 'nav.admin.settlements', icon: CalendarCheck },
    { href: '/admin/transactions', labelKey: 'nav.admin.transactions', icon: CreditCard },
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
