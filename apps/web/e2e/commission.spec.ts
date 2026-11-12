import { expect, test } from '@playwright/test';
import { dismissTour, signIn } from './sign-in';

// Window « Commission » and detailed simulations on the real API (decisions of 2026-11-03).
test.describe('commission grids and simulations', () => {
  test('the administrator creates a company with a grid in 2 steps, preview included', async ({
    page,
  }) => {
    await signIn(page, 'admin@flexipay.test');
    await dismissTour(page);
    await page.goto('/fr/admin/entreprises');
    await page.getByRole('button', { name: 'Créer une entreprise' }).click();
    const dialog = page.getByRole('dialog');
    await dialog.getByLabel('Raison sociale').fill(`Société E2E ${String(Date.now())}`);
    await dialog.getByLabel('Forme juridique').selectOption('PM_MF');
    await dialog.getByLabel('Ville').fill('Sfax');
    await dialog.getByLabel('Téléphone').fill('+21674000111');
    await dialog.getByLabel('E-mail du responsable').fill(`rh-${String(Date.now())}@e2e.tn`);
    await dialog.getByRole('button', { name: 'Continuer' }).click();
    await dialog.getByLabel('Taux par défaut (%)').fill('5');
    await dialog.getByRole('button', { name: 'Ajouter une tranche' }).click();
    await dialog.getByLabel('Taux (%)').fill('3');
    await dialog.getByLabel('De (TND)').fill('15000');
    await dialog.getByLabel('À (TND)').fill('18000');
    await dialog.getByLabel("Montant d'exemple (TND)").fill('16000');
    await expect(dialog.getByText('Total à payer')).toBeVisible();
    // Processus v2: the PM MF total also carries the withholding tax and the transfer fee.
    await expect(dialog.getByText(/16\s5\d\d,\d{3}/).first()).toBeVisible();
    // An overlapping tranche is refused with a clear message.
    await dialog.getByRole('button', { name: 'Ajouter une tranche' }).click();
    await dialog.getByLabel('Taux (%)').nth(1).fill('2');
    await dialog.getByLabel('De (TND)').nth(1).fill('17000');
    await dialog.getByRole('button', { name: "Créer l'entreprise" }).click();
    await expect(dialog.getByText(/chevauche une autre tranche/)).toBeVisible();
    await dialog.getByRole('button', { name: 'Supprimer la tranche 2' }).click();
    await dialog.getByRole('button', { name: "Créer l'entreprise" }).click();
    // Processus v2: the temporary password of the new client is shown once.
    const credentials = page.getByRole('dialog', { name: 'Identifiants à transmettre' });
    await expect(credentials).toBeVisible();
    await credentials.getByRole('button', { name: "J'ai transmis les identifiants" }).click();
    await expect(page.getByRole('dialog')).toHaveCount(0);
  });

  test('the company sees commission, VAT and stamp duty in its order summary', async ({ page }) => {
    await signIn(page, 'entreprise@flexipay.test');
    await dismissTour(page);
    await page.goto('/fr/entreprise/commandes/nouvelle');
    await page.getByLabel(/Montant Restauration/).fill('1000');
    await page.getByRole('button', { name: 'Calculer le récapitulatif' }).click();
    await expect(page.getByText('TVA sur la commission').first()).toBeVisible();
    await expect(page.getByText('Timbre fiscal').first()).toBeVisible();
  });

  test('the merchant sees commission, VAT, stamp duty and net in the payout simulation', async ({
    page,
  }) => {
    await signIn(page, 'karim@lejasmin.tn');
    await dismissTour(page);
    await page.goto('/fr/commercant/virements');
    await page.getByLabel('Montant à virer (TND)').fill('60');
    await page.getByRole('button', { name: 'Simuler', exact: true }).click();
    await expect(page.getByText('TVA sur la commission').first()).toBeVisible();
    await expect(page.getByText('Timbre fiscal').first()).toBeVisible();
  });
});
