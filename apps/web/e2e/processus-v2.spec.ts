import { expect, test } from '@playwright/test';
import { signIn } from './sign-in';

// Processus v2 on the demo seed (`pnpm demo`): allocation by department and position with a
// preview and a template relaunched, and the full client record with its tabs.

test('the company allocates to Production / Ouvrier, saves the template and relaunches it', async ({
  page,
}) => {
  test.setTimeout(120_000);
  const name = `Tickets e2e ${String(Date.now()).slice(-6)}`;
  await signIn(page, 'entreprise@flexipay.test');
  await page.goto('/fr/entreprise/attribution');
  await page.getByLabel('Département').selectOption({ label: 'Production' });
  await page.getByLabel('Poste').selectOption({ label: 'Ouvrier' });
  await page.getByRole('button', { name: 'Tout sélectionner (résultat du filtre)' }).click();
  await expect(page.getByText('4 employés sélectionnés')).toBeVisible();
  await page.getByLabel('Restauration par employé (TND)').fill('1');
  await page.getByRole('button', { name: 'Voir l’aperçu' }).click();
  await expect(page.getByText('Employés concernés : 4')).toBeVisible();
  await page.getByLabel('Enregistrer comme modèle').check();
  await page.getByLabel('Nom du modèle').fill(name);
  await page.getByRole('button', { name: 'Attribuer', exact: true }).click();
  await page.getByRole('dialog').getByRole('button', { name: 'Attribuer' }).click();
  await expect(page.getByText(`Modèle « ${name} » enregistré.`)).toBeVisible();

  await page.goto('/fr/entreprise/modeles');
  const row = page.getByRole('row').filter({ hasText: name });
  await expect(row).toBeVisible();
  await row.getByRole('link', { name: 'Relancer' }).click();
  await expect(page.getByText(`Relance du modèle « ${name} »`)).toBeVisible();
  await expect(page.getByText('Employés concernés : 4')).toBeVisible();
});

test('the administrator opens every tab of a company record', async ({ page }) => {
  test.setTimeout(120_000);
  await signIn(page, 'admin@flexipay.test');
  await page.goto('/fr/admin/entreprises');
  await page
    .getByRole('link', { name: /Carthage/ })
    .first()
    .click();
  const tabs = page.getByRole('group', { name: 'Onglets de la fiche' });
  await expect(tabs).toBeVisible();
  await expect(page.getByText('Forme juridique').first()).toBeVisible();
  await tabs.getByRole('button', { name: 'Employés' }).click();
  await expect(page.getByText(/employés affichés sur/)).toBeVisible();
  for (const tab of ['Dossier KYC', 'Utilisateurs', 'Départements', 'Soldes', 'Commandes']) {
    await tabs.getByRole('button', { name: tab }).click();
    await expect(page.getByRole('alert')).toHaveCount(0);
  }
  await tabs.getByRole('button', { name: 'Attributions et modèles' }).click();
  await expect(page.getByRole('table').first()).toBeVisible();
});
