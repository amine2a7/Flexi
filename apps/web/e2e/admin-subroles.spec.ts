// Decision C of 2026-10-23: each administrator sub-role sees only its menu entries and actions;
// a page opened by its URL without the permission says « Accès refusé ».
import { expect, test, type Page } from '@playwright/test';
import { dismissTour, signIn } from './sign-in';

const ALL = [
  '/admin',
  '/admin/commercants',
  '/admin/entreprises',
  '/admin/utilisateurs',
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
];
const without = (...denied: string[]) => ALL.filter((path) => !denied.includes(path));

const SUB_ROLES = [
  { name: 'Super-admin', account: 'admin@flexipay.test', menu: ALL, denied: [] as string[] },
  {
    name: 'Opérations',
    account: 'operations@flexipay.test',
    menu: without('/admin/messages', '/admin/parametres'),
    denied: ['/admin/parametres', '/admin/messages'],
  },
  {
    name: 'Finance',
    account: 'admin2@flexipay.test',
    menu: without('/admin/messages'),
    denied: ['/admin/messages'],
  },
  {
    name: 'Support',
    account: 'support@flexipay.test',
    menu: [
      '/admin/commercants',
      '/admin/entreprises',
      '/admin/utilisateurs',
      '/admin/transactions',
      '/admin/messages',
    ],
    denied: ['/admin', '/admin/parametres', '/admin/audit', '/admin/commandes', '/admin/kyc'],
  },
];

async function menu(page: Page): Promise<string[]> {
  const hrefs = await page
    .locator('nav a[href^="/fr/admin"]:visible')
    .evaluateAll((links) => links.map((link) => link.getAttribute('href') ?? ''));
  return [...new Set(hrefs.map((href) => href.replace(/^\/fr/, '')))].sort();
}

for (const subRole of SUB_ROLES) {
  test(`${subRole.name} sees only its menu and gets « Accès refusé » elsewhere`, async ({
    page,
  }) => {
    test.setTimeout(120_000);
    await signIn(page, subRole.account);
    expect(await menu(page)).toEqual([...subRole.menu].sort());
    for (const path of subRole.denied) {
      await page.goto(`/fr${path}`);
      await dismissTour(page);
      if (path === '/admin') {
        // Home denied: the support lands on its first page instead.
        await expect(page).toHaveURL(/\/fr\/admin\/commercants$/);
      } else {
        await expect(page.getByRole('heading', { level: 1, name: 'Accès refusé' })).toBeVisible();
      }
    }
  });
}

test('Finance never sees the KYC decision, Opérations never the payout decision', async ({
  page,
}) => {
  test.setTimeout(120_000);
  await signIn(page, 'admin2@flexipay.test');
  await page.goto('/fr/admin/kyc');
  await dismissTour(page);
  const file = page.locator('main a[href^="/fr/admin/kyc/"]').first();
  if ((await file.count()) > 0) {
    await file.click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByRole('button', { name: /Approuver|Valider/ })).toHaveCount(0);
  }
  await page.context().clearCookies();
  await signIn(page, 'operations@flexipay.test');
  await page.goto('/fr/admin/virements');
  await dismissTour(page);
  const payout = page.locator('main a[href^="/fr/admin/virements/"]').first();
  if ((await payout.count()) > 0) {
    await payout.click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByRole('button', { name: /Approuver|Rejeter/ })).toHaveCount(0);
  }
});
