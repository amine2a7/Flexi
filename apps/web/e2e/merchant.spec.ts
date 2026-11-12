// Step 3 (Commerçant): collect a payment with the customer code, then simulate and request a
// payout: the net shown by the simulation is the net of the request (frozen rate, rule 5).
// Real API (demo seed): the customer shows a fresh code on its phone, the merchant types it,
// the customer confirms with its PIN (1234 in the demo).
import { expect, test } from '@playwright/test';
import { dismissTour, signIn } from './sign-in';

test('the merchant collects a payment confirmed by the customer', async ({ page, browser }) => {
  // One demo customer, one live code at a time (a new code cancels the previous one): the test
  // runs once, on the desktop project, never in parallel with itself.
  test.skip(test.info().project.name !== 'desktop', 'one demo customer code at a time');
  test.setTimeout(180_000);
  const phoneContext = await browser.newContext({
    baseURL: test.info().project.use.baseURL,
    locale: 'fr-FR',
  });
  const phone = await phoneContext.newPage();
  await signIn(phone, 'beneficiaire@flexipay.test');
  await phone.goto('/fr/beneficiaire/payer');
  await dismissTour(phone);
  await phone.getByRole('button', { name: 'Afficher mon code' }).click();
  const shown = await phone
    .getByText(/^\d{4} \d{4}$/)
    .first()
    .innerText();
  const code = shown.replace(/\s/g, '');

  await signIn(page, 'commercant@flexipay.test');
  await page.goto('/fr/commercant/encaissement');
  await dismissTour(page);
  await page.getByLabel('Code client (8 chiffres)').fill(code);
  // A small amount: the demo customer's daily cap stays far, even after several runs.
  await page.getByLabel('Montant (TND)').fill('4,500');
  await page.getByRole('button', { name: 'Demander la confirmation' }).click();
  await expect(page.getByText('En attente du client')).toBeVisible();

  await phone.getByRole('button', { name: 'Confirmer', exact: true }).first().click();
  await phone.getByLabel('Code PIN (4 chiffres)').fill('1234');
  await phone
    .getByRole('dialog')
    .getByRole('button', { name: /^Payer / })
    .click();
  await expect(page.getByText('Paiement accepté')).toBeVisible({ timeout: 30_000 });
  await phoneContext.close();
});

test('the net of the simulation is the net of the payout request', async ({ page }) => {
  test.setTimeout(120_000);
  // Le Jasmin (Karim) has 1 250 TND to transfer in the demo seed.
  await signIn(page, 'karim@lejasmin.tn');
  await page.goto('/fr/commercant/virements');
  await dismissTour(page);
  await page.getByLabel('Montant à virer (TND)').fill('100');
  await page.getByRole('button', { name: 'Simuler', exact: true }).click();
  const summary = page.locator('dl').filter({ hasText: 'Net viré' }).first();
  // An amount is read whole from its label (« 1 234,000 TND »): figures and currency are apart.
  const net =
    (await summary.locator('[aria-label$="TND"]').last().getAttribute('aria-label')) ?? '';
  expect(net).toMatch(/\d/);
  await page.getByRole('button', { name: 'Demander ce virement' }).click();
  const dialog = page.getByRole('dialog');
  await dialog.getByRole('button', { name: /^Demander / }).click();
  await expect(dialog).toHaveCount(0);
  // The new request (first of the tracking list) carries the same net.
  await page.getByRole('button', { name: 'Suivi des demandes' }).click();
  await page
    .getByRole('link', { name: /VIR-|Voir/ })
    .first()
    .click();
  await expect(page.locator(`[aria-label="${net}"]`).first()).toBeVisible();
});
