// Step 3 (Commerçant): collect a payment with the customer code, then simulate and request a
// payout: the net shown by the simulation is the net of the request (frozen rate, rule 5).
// Mocked API: customer code 12345678 is confirmed by the customer after 4 s.
import { expect, test } from '@playwright/test';
import { dismissTour, signIn } from './sign-in';

test('the merchant collects a payment confirmed by the customer', async ({ page }) => {
  test.setTimeout(120_000);
  await signIn(page, 'commercant@flexipay.test');
  await page.goto('/fr/commercant/encaissement');
  await dismissTour(page);
  await page.getByLabel('Code client (8 chiffres)').fill('12345678');
  await page.getByLabel('Montant (TND)').fill('45,500');
  await page.getByRole('button', { name: 'Demander la confirmation' }).click();
  await expect(page.getByText('En attente du client')).toBeVisible();
  await expect(page.getByText('Paiement accepté')).toBeVisible({ timeout: 30_000 });
});

test('the net of the simulation is the net of the payout request', async ({ page }) => {
  test.setTimeout(120_000);
  await signIn(page, 'commercant@flexipay.test');
  await page.goto('/fr/commercant/virements');
  await dismissTour(page);
  await page.getByLabel('Montant à virer (TND)').fill('100');
  await page.getByRole('button', { name: 'Simuler', exact: true }).click();
  const summary = page.locator('dl').filter({ hasText: 'Net viré' }).first();
  const net = (await summary.getByText(/TND/).last().innerText()).trim();
  expect(net).toMatch(/\d/);
  await page.getByRole('button', { name: 'Demander ce virement' }).click();
  const dialog = page.getByRole('dialog');
  await dialog.getByRole('button', { name: /^Demander / }).click();
  await expect(dialog).toHaveCount(0);
  // The new request (first of the list) carries the same net.
  await page
    .getByRole('link', { name: /VIR-|Voir/ })
    .first()
    .click();
  await expect(page.getByText(net, { exact: true }).first()).toBeVisible();
});
