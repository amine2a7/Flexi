// Every page of the three spaces, opened by an account of the space (mocked API): no page error,
// no console error, no error screen, no API failure. Detail pages are reached from their list.
import { expect, test } from '@playwright/test';
import { dismissTour, signIn } from './sign-in';

const SPACES: Record<string, { account: string; pages: string[] }> = {
  admin: {
    account: 'admin@flexipay.test',
    pages: [
      '/admin',
      '/admin/commercants',
      '/admin/entreprises',
      '/admin/kyc',
      '/admin/commandes',
      '/admin/virements',
      '/admin/commissions',
      '/admin/validations',
      '/admin/reglements',
      '/admin/transactions',
      '/admin/audit',
      '/admin/messages',
      '/admin/parametres',
    ],
  },
  company: {
    account: 'entreprise@flexipay.test',
    pages: [
      '/entreprise',
      '/entreprise/commandes',
      '/entreprise/commandes/nouvelle',
      '/entreprise/employes',
      '/entreprise/employes/import',
      '/entreprise/attribution',
      '/entreprise/factures',
    ],
  },
  merchant: {
    account: 'commercant@flexipay.test',
    pages: [
      '/commercant',
      '/commercant/encaissement',
      '/commercant/historique',
      '/commercant/creances',
      '/commercant/virements',
      '/commercant/reglements',
      '/commercant/mon-commerce',
    ],
  },
};

for (const [space, { account, pages }] of Object.entries(SPACES)) {
  test(`every ${space} page opens without error`, async ({ page }) => {
    test.setTimeout(240_000);
    let current = '';
    const problems: string[] = [];
    page.on('pageerror', (error) => problems.push(`${current} | page error | ${error.message}`));
    page.on('console', (message) => {
      if (message.type() === 'error') problems.push(`${current} | console | ${message.text()}`);
    });
    page.on('response', (response) => {
      const url = new URL(response.url());
      if (url.pathname.startsWith('/v1/') && response.status() >= 400) {
        problems.push(`${current} | API ${String(response.status())} | ${url.pathname}`);
      }
    });
    await signIn(page, account);
    const visit = async (path: string): Promise<void> => {
      current = path;
      await page.goto(`/fr${path}`);
      await dismissTour(page);
      if (await page.getByText('Une erreur est survenue').isVisible()) {
        problems.push(`${path} | error screen`);
      }
      if ((await page.getByRole('heading', { level: 1 }).count()) === 0) {
        problems.push(`${path} | no h1`);
      }
    };
    for (const path of pages) {
      await visit(path);
      const detail = page.locator(`main a[href^="/fr${path}/"]`).first();
      const href = (await detail.count()) > 0 ? await detail.getAttribute('href') : null;
      if (href !== null && !href.endsWith('/nouvelle') && !href.endsWith('/import')) {
        await visit(href.replace(/^\/fr/, ''));
      }
    }
    expect(problems).toEqual([]);
  });
}
