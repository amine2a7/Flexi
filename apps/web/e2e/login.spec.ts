// Common screens (WF2): sign-in, MFA, first sign-in, session expired, protected page without session.
import { expect, test, type Page } from '@playwright/test';
import { MFA, PASSWORD, dismissTour } from './sign-in';

async function submitPassword(page: Page, account: string, password: string): Promise<void> {
  await page.goto('/fr/login');
  await page.getByLabel('E-mail ou téléphone').fill(account);
  await page.getByLabel('Mot de passe', { exact: true }).fill(password);
  await page.getByRole('button', { name: 'Se connecter' }).click();
}

/** True when the API mock answers (the first sign-in test changes the account). */
async function mocked(page: Page): Promise<boolean> {
  return page.evaluate(async () => {
    const registration = await navigator.serviceWorker.getRegistration();
    return registration?.active?.scriptURL.includes('/mockServiceWorker.js') ?? false;
  });
}

test.describe('sign-in', () => {
  test('a wrong password is refused without saying which part is wrong', async ({ page }) => {
    await submitPassword(page, 'commercant@flexipay.test', 'Mauvais-mot-2026');
    await expect(page.getByText('Identifiant ou mot de passe incorrect.')).toBeVisible();
    await expect(page).toHaveURL(/\/fr\/login/);
  });

  test('a wrong MFA code is refused, the right one opens the space', async ({ page }) => {
    await submitPassword(page, 'commercant@flexipay.test', PASSWORD);
    await expect(page.getByRole('heading', { name: 'Vérification en deux étapes' })).toBeVisible();
    await page.getByLabel('Code à 6 chiffres').fill('000000');
    await page.getByRole('button', { name: 'Vérifier' }).click();
    await expect(page.getByText(/Code incorrect/)).toBeVisible();
    await page.getByLabel('Code à 6 chiffres').fill(MFA);
    await page.getByRole('button', { name: 'Vérifier' }).click();
    await expect(page).toHaveURL(/\/fr\/commercant$/);
    await dismissTour(page);
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  });

  test('a protected page without session goes to sign-in and back after it', async ({ page }) => {
    await page.goto('/fr/entreprise/factures');
    await expect(page).toHaveURL(/\/fr\/login\?returnTo=/);
    await page.getByLabel('E-mail ou téléphone').fill('entreprise@flexipay.test');
    await page.getByLabel('Mot de passe', { exact: true }).fill(PASSWORD);
    await page.getByRole('button', { name: 'Se connecter' }).click();
    await page.getByLabel('Code à 6 chiffres').fill(MFA);
    await page.getByRole('button', { name: 'Vérifier' }).click();
    await expect(page).toHaveURL(/\/fr\/entreprise\/factures$/);
  });

  test('the first sign-in asks for a new password before anything else', async ({ page }) => {
    await page.goto('/fr/login');
    test.skip(!(await mocked(page)), 'changes the account: mocked API only');
    await submitPassword(page, 'premiere@flexipay.test', 'Temp1234!');
    await expect(
      page.getByRole('heading', { name: 'Choisissez votre mot de passe' }),
    ).toBeVisible();
    await page.goto('/fr/entreprise');
    await expect(page).toHaveURL(/premiere-connexion/);
  });

  test('the session expired page offers to sign in again', async ({ page }) => {
    await page.goto('/fr/session-expiree');
    await expect(page.getByRole('heading', { level: 1, name: 'Session expirée' })).toBeVisible();
    await page.getByRole('link', { name: 'Se reconnecter' }).click();
    await expect(page).toHaveURL(/\/fr\/login/);
  });
});
