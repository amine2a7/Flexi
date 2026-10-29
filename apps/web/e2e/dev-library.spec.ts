// Component library (dev-composants.md): every section renders in FR and AR (RTL) without error;
// its absence from a build is proven by test/build (route, marker).
import { expect, test } from '@playwright/test';

const SECTIONS = [
  'buttons',
  'fields',
  'badges',
  'cards',
  'toasts',
  'amounts',
  'skeletons',
  'states',
  'table',
  'dialogs',
  'users',
  'navigation',
  'misc',
];

for (const locale of ['fr', 'ar'] as const) {
  test(`the component library renders every section (${locale})`, async ({ page }) => {
    const problems: string[] = [];
    page.on('pageerror', (error) => problems.push(error.message));
    page.on('console', (message) => {
      if (message.type() === 'error') problems.push(message.text());
    });
    await page.goto(`/${locale}/dev/composants`);
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    expect(await page.locator('html').getAttribute('dir')).toBe(locale === 'ar' ? 'rtl' : 'ltr');
    for (const id of SECTIONS) await expect(page.locator(`section#${id} h2`)).toBeVisible();
    await expect(page.locator('meta[name="robots"]')).toHaveAttribute('content', /noindex/);
    expect(problems).toEqual([]);
  });
}

test('the dialogs of the library open and close with the keyboard', async ({ page }) => {
  await page.goto('/fr/dev/composants#dialogs');
  await page.getByRole('button', { name: 'Ouvrir une modale' }).click();
  await expect(page.getByRole('dialog')).toBeVisible();
  await page.keyboard.press('Escape');
  await expect(page.getByRole('dialog')).toHaveCount(0);
});
