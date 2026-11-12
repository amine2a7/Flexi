// Step 2 (decisions A to D of 2026-10-23): a company suspends, reactivates and deactivates an
// employee with a reason; an administrator sub-role without the right never sees the actions.
import { expect, test } from '@playwright/test';

// Employee rows are read from the table: on a phone the list becomes cards (desktop only).
test.skip(({ isMobile }) => isMobile, 'tables become cards on a phone');
import { dismissTour, signIn } from './sign-in';

const REASON = 'Départ de la société confirmé par les RH.';

test('the company creates an employee (temporary password sent, status Invité)', async ({
  page,
}) => {
  test.setTimeout(120_000);
  await signIn(page, 'entreprise@flexipay.test');
  await page.goto('/fr/entreprise/employes');
  await dismissTour(page);
  await page.getByRole('button', { name: 'Ajouter un employé' }).click();
  const dialog = page.getByRole('dialog');
  const number = `E2E${String(Date.now()).slice(-6)}`;
  await dialog.getByLabel('Matricule').fill(number);
  await dialog.getByLabel('Prénom').fill('Amel');
  await dialog.getByLabel('Nom', { exact: true }).fill('Testeur');
  await dialog.getByLabel('E-mail').fill(`${number.toLowerCase()}@exemple.tn`);
  await dialog.getByLabel('Téléphone').fill('+21622123456');
  await dialog.getByRole('button', { name: "Créer l'employé" }).click();
  await expect(page.getByText(/a été ajouté/)).toBeVisible();
  await page
    .getByRole('searchbox')
    .or(page.getByLabel(/Rechercher/))
    .first()
    .fill(number);
  await page.keyboard.press('Enter');
  await expect(page.getByRole('row').filter({ hasText: number }).getByText('Invité')).toBeVisible();
});

test('the company suspends, reactivates then deactivates an employee', async ({ page }) => {
  test.setTimeout(180_000);
  await signIn(page, 'entreprise@flexipay.test');
  await page.goto('/fr/entreprise/employes');
  await dismissTour(page);
  const row = page
    .getByRole('row')
    .filter({ has: page.getByRole('button', { name: 'Suspendre' }) })
    .first();
  const name = (await row.getByRole('cell').first().innerText()).split('\n')[0] ?? '';
  const act = async (button: string, confirm: string) => {
    await page
      .getByRole('row')
      .filter({ hasText: name })
      .getByRole('button', { name: button })
      .click();
    const dialog = page.getByRole('dialog');
    await expect(dialog.getByRole('button', { name: confirm })).toBeDisabled();
    await dialog.getByLabel('Motif').fill(REASON);
    await dialog.getByRole('button', { name: confirm }).click();
    await expect(dialog).toHaveCount(0);
  };
  await row.getByRole('button', { name: 'Suspendre' }).click();
  await page.getByRole('dialog').getByLabel('Motif').fill(REASON);
  await page.getByRole('dialog').getByRole('button', { name: 'Suspendre le compte' }).click();
  await expect(
    page.getByRole('row').filter({ hasText: name }).getByText('Suspendu').first(),
  ).toBeVisible();
  await act('Réactiver', 'Réactiver le compte');
  await expect(page.getByRole('row').filter({ hasText: name }).getByText('Actif')).toBeVisible();
  await page
    .getByRole('row')
    .filter({ hasText: name })
    .getByRole('button', { name: 'Désactiver' })
    .click();
  await expect(page.getByRole('dialog').getByText(/pendant 30 jours/)).toBeVisible();
  await expect(page.getByRole('dialog').getByText(/Cette action est définitive/)).toBeVisible();
  await page.getByRole('dialog').getByLabel('Motif').fill(REASON);
  await page.getByRole('dialog').getByRole('button', { name: "Désactiver l'employé" }).click();
  await expect(
    page
      .getByRole('row')
      .filter({ hasText: name })
      .getByText(/délai de grâce jusqu'au/),
  ).toBeVisible();
  await expect(
    page.getByRole('row').filter({ hasText: name }).getByRole('button', { name: 'Réactiver' }),
  ).toHaveCount(0);
});

test('support sees users but never the status actions; the super-admin does', async ({ page }) => {
  test.setTimeout(180_000);
  await signIn(page, 'support@flexipay.test');
  await page.goto('/fr/admin/utilisateurs');
  await dismissTour(page);
  await page.getByRole('link', { name: 'Leïla M.' }).first().click();
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  for (const name of ['Suspendre', 'Désactiver', 'Changer le rôle'])
    await expect(page.getByRole('button', { name, exact: true })).toHaveCount(0);
  await expect(page.getByText('Solde', { exact: true })).toHaveCount(0);
  await page.context().clearCookies();
  await signIn(page, 'admin@flexipay.test');
  await page.goto('/fr/admin/utilisateurs');
  await dismissTour(page);
  await page.getByRole('link', { name: 'Leïla M.' }).first().click();
  await expect(page.getByRole('button', { name: 'Suspendre', exact: true })).toBeVisible();
});
