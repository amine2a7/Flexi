// Visual control (design web objective of 2026-10-30): one capture of each page per space, in
// French and Arabic, for the project's device (desktop or mobile), in docs/design/captures/<space>/.
// Run on the mocked API: CAPTURE_SPACE=commun|commercant|entreprise|admin.
import { mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { test, type Page } from '@playwright/test';
import { PASSWORD, dismissTour, signIn } from './sign-in';

const OUT = join(import.meta.dirname, '..', '..', '..', 'docs', 'design', 'captures');
const LOCALES = ['fr', 'ar'] as const;

interface Shot {
  readonly name: string;
  readonly path: string;
  /** Account signed in first (none: public page). */
  readonly account?: string;
  /** Steps that bring the page to its state (sign-in steps of the auth screens). */
  readonly prepare?: (page: Page, locale: string) => Promise<void>;
}

const startSignIn = (account: string, password: string) => async (page: Page, locale: string) => {
  await page.goto(`/${locale}/login`);
  await page
    .locator('input[autocomplete="username"], input[type="email"], input')
    .first()
    .fill(account);
  await page.locator('input[type="password"]').first().fill(password);
  await page.locator('form button[type="submit"]').first().click();
  await page.waitForURL((url) => !url.pathname.endsWith('/login'));
};

const SPACES: Record<string, readonly Shot[]> = {
  commun: [
    { name: 'accueil', path: '/' },
    { name: 'aide', path: '/aide' },
    { name: 'connexion', path: '/login' },
    { name: 'mfa', path: '', prepare: startSignIn('commercant@flexipay.test', PASSWORD) },
    {
      name: 'premiere-connexion',
      path: '',
      prepare: startSignIn('premiere@flexipay.test', 'Temp1234!'),
    },
    { name: 'mot-de-passe-oublie', path: '/mot-de-passe-oublie' },
    { name: 'session-expiree', path: '/session-expiree' },
    { name: '404', path: '/page-inexistante' },
    { name: 'acces-refuse', path: '/commercant/virements', account: 'caissier@flexipay.test' },
  ],
  commercant: [
    'tableau-de-bord:/commercant',
    'encaissement:/commercant/encaissement',
    'historique:/commercant/historique',
    'creances:/commercant/creances',
    'virements:/commercant/virements',
    'reglements:/commercant/reglements',
    'mon-commerce:/commercant/mon-commerce',
    'statistiques:/commercant/statistiques',
    'parametres:/commercant/parametres',
    'support:/commercant/support',
  ].map((item) => {
    const [name = '', path = ''] = item.split(':');
    return { name, path, account: 'commercant@flexipay.test' };
  }),
  entreprise: [
    'tableau-de-bord:/entreprise',
    'employes:/entreprise/employes',
    'import:/entreprise/employes/import',
    'commandes:/entreprise/commandes',
    'nouvelle-commande:/entreprise/commandes/nouvelle',
    'attribution:/entreprise/attribution',
    'factures:/entreprise/factures',
    'reporting:/entreprise/reporting',
    'parametres:/entreprise/parametres',
    'support:/entreprise/support',
  ].map((item) => {
    const [name = '', path = ''] = item.split(':');
    return { name, path, account: 'entreprise@flexipay.test' };
  }),
  admin: [
    'tableau-de-bord:/admin',
    'commercants:/admin/commercants',
    'entreprises:/admin/entreprises',
    'utilisateurs:/admin/utilisateurs',
    'kyc:/admin/kyc',
    'commandes:/admin/commandes',
    'virements:/admin/virements',
    'commissions:/admin/commissions',
    'validations:/admin/validations',
    'reglements:/admin/reglements',
    'transactions:/admin/transactions',
    'securite:/admin/securite',
    'reporting:/admin/reporting',
    'audit:/admin/audit',
    'messages:/admin/messages',
    'parametres:/admin/parametres',
  ].map((item) => {
    const [name = '', path = ''] = item.split(':');
    return { name, path, account: 'admin@flexipay.test' };
  }),
};

const space = process.env.CAPTURE_SPACE ?? 'commun';
/** Comma-separated screen names to capture again (all by default). */
const only = process.env.CAPTURE_ONLY?.split(',');

for (const locale of LOCALES) {
  test(`captures ${space} (${locale})`, async ({ page }, info) => {
    test.setTimeout(600_000);
    const dir = join(OUT, space);
    mkdirSync(dir, { recursive: true });
    let signedAs: string | undefined;
    for (const shot of (SPACES[space] ?? []).filter(
      (item) => only === undefined || only.includes(item.name),
    )) {
      if (shot.account !== undefined && shot.account !== signedAs) {
        await page.context().clearCookies();
        await signIn(page, shot.account);
        signedAs = shot.account;
      }
      if (shot.prepare !== undefined) {
        await page.context().clearCookies();
        signedAs = undefined;
        await shot.prepare(page, locale);
      } else {
        await page.goto(`/${locale}${shot.path}`);
      }
      await dismissTour(page);
      // Entrance animations (fade, rise) end before the capture.
      await page.waitForTimeout(900);
      await page.screenshot({
        path: join(dir, `${shot.name}-${locale}-${info.project.name}.jpg`),
        type: 'jpeg',
        quality: 70,
        fullPage: true,
      });
    }
  });
}
