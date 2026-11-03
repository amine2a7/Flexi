import { expect, test } from '@playwright/test';
import { dismissTour, signIn } from './sign-in';

// Administrateur › Sécurité on the real API: Opérations opens and instructs a dispute, Finance
// reads the file and cannot act on it (the refund is approved in Validations).
test.describe('security screens', () => {
  test('Opérations opens a dispute from a transaction and accepts it, Finance reads it', async ({
    page,
    browser,
  }) => {
    await signIn(page, 'operations@flexipay.test');
    await dismissTour(page);
    await page.goto('/fr/admin/transactions');
    const open = page.getByRole('button', { name: 'Ouvrir un litige' }).first();
    await open.click();
    const dialog = page.getByRole('dialog');
    await dialog.getByRole('textbox').fill('Paiement contesté par le bénéficiaire.');
    await dialog.getByRole('button', { name: 'Ouvrir un litige' }).click();
    await expect(page).toHaveURL(/\/fr\/admin\/securite\/litiges\//);
    await expect(page.getByRole('heading', { level: 1, name: /Litige LIT-/ })).toBeVisible();
    await page.getByLabel('Ajouter une note').fill('Ticket de caisse demandé au commerçant.');
    await page.getByRole('button', { name: 'Ajouter', exact: true }).click();
    await expect(page.getByText('Ticket de caisse demandé au commerçant.').first()).toBeVisible();
    await page.getByRole('button', { name: 'Accepter le litige' }).click();
    const confirm = page.getByRole('dialog');
    await confirm.getByRole('textbox').fill('Double débit confirmé par le commerçant.');
    await confirm.getByRole('button', { name: 'Accepter le litige' }).click();
    await expect(page.getByText('En attente de la seconde validation')).toBeVisible();
    const file = page.url();

    const context = await browser.newContext({ baseURL: new URL(file).origin });
    const finance = await context.newPage();
    await signIn(finance, 'admin2@flexipay.test');
    await dismissTour(finance);
    await finance.goto(file);
    await expect(finance.getByRole('heading', { level: 1, name: /Litige LIT-/ })).toBeVisible();
    await expect(finance.getByRole('button', { name: 'Accepter le litige' })).toHaveCount(0);
    await expect(finance.getByLabel('Ajouter une note')).toHaveCount(0);
    await expect(finance.getByRole('link', { name: 'Ouvrir les validations' })).toBeVisible();
    await finance.goto('/fr/admin/securite');
    await expect(finance.getByRole('tab', { name: 'Alertes de fraude' })).toHaveCount(0);
    await context.close();
  });
});
