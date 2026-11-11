import type { Schemas } from '@flexipay/api-client';
import type { NavCounter } from './nav-counters';
import {
  ArrowLeftRight,
  Building2,
  ChartColumn,
  LifeBuoy,
  CalendarCheck,
  ClipboardCheck,
  CreditCard,
  FileSearch,
  FileText,
  HandCoins,
  History,
  Home,
  QrCode,
  Repeat,
  ShieldCheck,
  UserCog,
  UserRound,
  LayoutDashboard,
  Mail,
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

/** A category of the side menu: opens and closes its entries (accordion, request of 2026-11-05). */
export interface NavGroup {
  readonly key: string;
  readonly labelKey: string;
  readonly icon: LucideIcon;
  readonly items: readonly NavItem[];
}

/** An entry of the menu: a direct link (Accueil, Paramètres) or a category. */
export type NavEntry = NavItem | NavGroup;

export function isGroup(entry: NavEntry): entry is NavGroup {
  return 'items' in entry;
}

type Role = Schemas['Role'];

const group = (key: string, icon: LucideIcon, items: readonly NavItem[]): NavGroup => ({
  key,
  labelKey: `nav.groups.${key}`,
  icon,
  items,
});

// Navigation of each space by category (request of 2026-11-05). There is no role switch
// (decision 25). The beneficiary keeps a flat menu (bottom bar on a phone).
export const NAVIGATION: Partial<Record<Role, readonly NavEntry[]>> = {
  MERCHANT: [
    { href: '/commercant', labelKey: 'nav.merchant.dashboard', icon: Home },
    group('sales', HandCoins, [
      { href: '/commercant/encaissement', labelKey: 'nav.merchant.collect', icon: HandCoins },
      { href: '/commercant/historique', labelKey: 'nav.merchant.history', icon: History },
      { href: '/commercant/statistiques', labelKey: 'nav.merchant.statistics', icon: ChartColumn },
    ]),
    group('money', Wallet, [
      { href: '/commercant/creances', labelKey: 'nav.merchant.receivables', icon: CalendarCheck },
      { href: '/commercant/virements', labelKey: 'nav.merchant.payouts', icon: ArrowLeftRight },
      { href: '/commercant/reglements', labelKey: 'nav.merchant.settlements', icon: FileText },
    ]),
    group('account', UserRound, [
      { href: '/commercant/mon-commerce', labelKey: 'nav.merchant.shop', icon: Store },
      { href: '/commercant/dossier', labelKey: 'nav.merchant.kyc', icon: FileSearch },
      { href: '/commercant/parametres', labelKey: 'nav.merchant.settings', icon: Settings },
      { href: '/commercant/support', labelKey: 'nav.merchant.support', icon: LifeBuoy },
    ]),
  ],
  EMPLOYEE: [
    { href: '/beneficiaire', labelKey: 'nav.beneficiary.home', icon: Home },
    {
      href: '/beneficiaire/payer',
      labelKey: 'nav.beneficiary.pay',
      icon: QrCode,
      counter: 'employeeRequests',
    },
    { href: '/beneficiaire/historique', labelKey: 'nav.beneficiary.history', icon: History },
    { href: '/beneficiaire/famille', labelKey: 'nav.beneficiary.family', icon: Users },
    { href: '/beneficiaire/profil', labelKey: 'nav.beneficiary.profile', icon: UserRound },
    { href: '/beneficiaire/securite', labelKey: 'nav.beneficiary.security', icon: ShieldCheck },
  ],
  COMPANY: [
    { href: '/entreprise', labelKey: 'nav.company.dashboard', icon: Home },
    group('credits', Wallet, [
      {
        href: '/entreprise/commandes',
        labelKey: 'nav.company.orders',
        icon: ShoppingCart,
        counter: 'companyOrdersToPay',
      },
      { href: '/entreprise/attribution', labelKey: 'nav.company.allocation', icon: Wallet },
      {
        href: '/entreprise/modeles',
        labelKey: 'nav.company.allocationTemplates',
        icon: Repeat,
      },
    ]),
    group('team', Users, [
      { href: '/entreprise/employes', labelKey: 'nav.company.employees', icon: Users },
      { href: '/entreprise/departements', labelKey: 'nav.company.departments', icon: Building2 },
    ]),
    group('finance', Receipt, [
      { href: '/entreprise/factures', labelKey: 'nav.company.invoices', icon: Receipt },
      { href: '/entreprise/reporting', labelKey: 'nav.company.reporting', icon: ChartColumn },
    ]),
    group('account', UserRound, [
      { href: '/entreprise/dossier', labelKey: 'nav.company.kyc', icon: FileSearch },
      { href: '/entreprise/parametres', labelKey: 'nav.company.settings', icon: Settings },
      { href: '/entreprise/support', labelKey: 'nav.company.support', icon: LifeBuoy },
    ]),
  ],
  ADMIN: [
    group('steering', LayoutDashboard, [
      { href: '/admin', labelKey: 'nav.admin.dashboard', icon: LayoutDashboard },
      { href: '/admin/securite', labelKey: 'nav.admin.security', icon: ShieldCheck },
      { href: '/admin/reporting', labelKey: 'nav.admin.reporting', icon: ChartColumn },
    ]),
    group('clients', Building2, [
      { href: '/admin/entreprises', labelKey: 'nav.admin.companies', icon: Building2 },
      { href: '/admin/commercants', labelKey: 'nav.admin.merchants', icon: Store },
      { href: '/admin/kyc', labelKey: 'nav.admin.kyc', icon: FileSearch, counter: 'adminKyc' },
      { href: '/admin/utilisateurs', labelKey: 'nav.admin.users', icon: UserCog },
    ]),
    group('operations', ClipboardCheck, [
      {
        href: '/admin/commandes',
        labelKey: 'nav.admin.orders',
        icon: ShoppingCart,
        counter: 'adminOrdersToHandle',
      },
      {
        href: '/admin/validations',
        labelKey: 'nav.admin.approvals',
        icon: ClipboardCheck,
        counter: 'adminApprovals',
      },
      {
        href: '/admin/virements',
        labelKey: 'nav.admin.payouts',
        icon: ArrowLeftRight,
        counter: 'adminPayouts',
      },
      { href: '/admin/reglements', labelKey: 'nav.admin.settlements', icon: CalendarCheck },
    ]),
    group('finance', CreditCard, [
      { href: '/admin/transactions', labelKey: 'nav.admin.transactions', icon: CreditCard },
      { href: '/admin/commissions', labelKey: 'nav.admin.commissions', icon: Percent },
    ]),
    group('support', LifeBuoy, [
      {
        href: '/admin/messages',
        labelKey: 'nav.admin.messages',
        icon: Mail,
        counter: 'adminMessages',
      },
      { href: '/admin/audit', labelKey: 'nav.admin.audit', icon: ScrollText },
    ]),
    { href: '/admin/parametres', labelKey: 'nav.admin.settings', icon: Settings },
  ],
};

/** Every link of a space, categories flattened (permissions, landing page, bottom bar). */
export function navLinks(entries: readonly NavEntry[]): NavItem[] {
  return entries.flatMap((entry) => (isGroup(entry) ? entry.items : [entry]));
}

/** The current item: exact match for a space home, prefix match for the other entries. */
export function isActive(item: NavItem, pathname: string, home: string): boolean {
  return item.href === home
    ? pathname === home
    : pathname === item.href || pathname.startsWith(`${item.href}/`);
}
