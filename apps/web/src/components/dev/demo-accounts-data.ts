// Development only: accounts of the demo seed (apps/api/prisma/seed.ts, docs/demo/donnees-demo.md),
// shown on /login to fill the form. Never in a production build (test/build).
export const DEV_PANEL_MARKER = '__FLEXIPAY_DEV_PANEL__';

export const DEMO_MFA_CODE = '123456';
const PASSWORD = 'Flexi2026';

/** One account per role and sub-role; `role` is the key of its label (dev.accounts.*). */
export const DEMO_ACCOUNT_HINTS = [
  { role: 'admin', identifier: 'superadmin@flexipay.test', password: PASSWORD },
  { role: 'admin2', identifier: 'nizar@flexipay.test', password: PASSWORD },
  { role: 'operations', identifier: 'ali@flexipay.test', password: PASSWORD },
  { role: 'support', identifier: 'support@flexipay.test', password: PASSWORD },
  { role: 'company', identifier: 'biat@flexipay.test', password: PASSWORD },
  { role: 'merchant', identifier: 'carrefour@flexipay.test', password: PASSWORD },
] as const;
