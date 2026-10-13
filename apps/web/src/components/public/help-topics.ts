import type { StaticImageData } from 'next/image';
import adminAccounts from '@/assets/help/admin-accounts.jpg';
import adminDashboard from '@/assets/help/admin-dashboard.jpg';
import adminKyc from '@/assets/help/admin-kyc.jpg';
import adminMessages from '@/assets/help/admin-messages.jpg';
import adminOrders from '@/assets/help/admin-orders.jpg';
import adminPayouts from '@/assets/help/admin-payouts.jpg';
import adminSettings from '@/assets/help/admin-settings.jpg';
import adminTransactions from '@/assets/help/admin-transactions.jpg';
import companyAllocation from '@/assets/help/company-allocation.jpg';
import companyDashboard from '@/assets/help/company-dashboard.jpg';
import companyEmployees from '@/assets/help/company-employees.jpg';
import companyInvoices from '@/assets/help/company-invoices.jpg';
import companyOrders from '@/assets/help/company-orders.jpg';
import employeeHistory from '@/assets/help/employee-history.jpg';
import employeeHome from '@/assets/help/employee-home.jpg';
import employeePay from '@/assets/help/employee-pay.jpg';
import employeeSecurity from '@/assets/help/employee-security.jpg';
import firstLogin from '@/assets/help/first-login.jpg';
import forgotPassword from '@/assets/help/forgot-password.jpg';
import login from '@/assets/help/login.jpg';
import merchantCollect from '@/assets/help/merchant-collect.jpg';
import merchantDashboard from '@/assets/help/merchant-dashboard.jpg';
import merchantHistory from '@/assets/help/merchant-history.jpg';
import merchantPayouts from '@/assets/help/merchant-payouts.jpg';
import merchantReceivables from '@/assets/help/merchant-receivables.jpg';
import merchantSettlements from '@/assets/help/merchant-settlements.jpg';
import merchantShop from '@/assets/help/merchant-shop.jpg';
import mfa from '@/assets/help/mfa.jpg';
import sessionExpired from '@/assets/help/session-expired.jpg';

export interface HelpTopic {
  /** Key under help.topics (title, text) and anchor of the topic. */
  readonly key: string;
  readonly capture?: StaticImageData;
  /** Phone-sized capture (beneficiary space). */
  readonly mobile?: boolean;
}

export type HelpSectionKey = 'account' | 'COMPANY' | 'MERCHANT' | 'EMPLOYEE' | 'ADMIN';

/** Anchor of each section, also used by the "Help" link of each space (/aide#<anchor>). */
export const HELP_ANCHORS: Record<HelpSectionKey, string> = {
  account: 'compte',
  COMPANY: 'entreprise',
  MERCHANT: 'commercant',
  EMPLOYEE: 'beneficiaire',
  ADMIN: 'administrateur',
};

/** Help centre content: sign-in topics first, then one section per space, screen by screen. */
export const HELP_SECTIONS: readonly { key: HelpSectionKey; topics: readonly HelpTopic[] }[] = [
  {
    key: 'account',
    topics: [
      { key: 'login', capture: login },
      { key: 'mfa', capture: mfa },
      { key: 'firstLogin', capture: firstLogin },
      { key: 'forgotPassword', capture: forgotPassword },
      { key: 'sessionExpired', capture: sessionExpired },
      { key: 'accountLocked' },
    ],
  },
  {
    key: 'COMPANY',
    topics: [
      { key: 'companyDashboard', capture: companyDashboard },
      { key: 'companyEmployees', capture: companyEmployees },
      { key: 'companyOrders', capture: companyOrders },
      { key: 'companyAllocation', capture: companyAllocation },
      { key: 'companyInvoices', capture: companyInvoices },
    ],
  },
  {
    key: 'MERCHANT',
    topics: [
      { key: 'merchantDashboard', capture: merchantDashboard },
      { key: 'merchantCollect', capture: merchantCollect },
      { key: 'merchantHistory', capture: merchantHistory },
      { key: 'merchantReceivables', capture: merchantReceivables },
      { key: 'merchantPayouts', capture: merchantPayouts },
      { key: 'merchantSettlements', capture: merchantSettlements },
      { key: 'merchantShop', capture: merchantShop },
    ],
  },
  {
    key: 'EMPLOYEE',
    topics: [
      { key: 'employeeHome', capture: employeeHome, mobile: true },
      { key: 'employeePay', capture: employeePay, mobile: true },
      { key: 'employeeHistory', capture: employeeHistory, mobile: true },
      { key: 'employeeSecurity', capture: employeeSecurity, mobile: true },
    ],
  },
  {
    key: 'ADMIN',
    topics: [
      { key: 'adminDashboard', capture: adminDashboard },
      { key: 'adminAccounts', capture: adminAccounts },
      { key: 'adminKyc', capture: adminKyc },
      { key: 'adminOrders', capture: adminOrders },
      { key: 'adminPayouts', capture: adminPayouts },
      { key: 'adminSettings', capture: adminSettings },
      { key: 'adminTransactions', capture: adminTransactions },
      { key: 'adminMessages', capture: adminMessages },
    ],
  },
];
