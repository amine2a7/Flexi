import type { Page } from '@playwright/test';

/** Demo accounts of the seed and of the mock (same password and MFA code). */
export const PASSWORD = 'Test1234!';
export const MFA = '123456';

/** Signs in with password then MFA, and closes the welcome tour if it opens. */
export async function signIn(page: Page, account: string): Promise<void> {
  await page.goto('/fr/login');
  await page.getByLabel('E-mail ou téléphone').fill(account);
  await page.getByLabel('Mot de passe', { exact: true }).fill(PASSWORD);
  await page.getByRole('button', { name: 'Se connecter' }).click();
  await page.getByLabel('Code à 6 chiffres').fill(MFA);
  await page.getByRole('button', { name: 'Vérifier' }).click();
  await page.waitForURL((url) => !url.pathname.includes('/login'));
  await dismissTour(page);
}

/** The welcome tour makes the page inert behind it: closed before looking at the page. */
export async function dismissTour(page: Page): Promise<void> {
  await page.waitForLoadState('networkidle');
  if ((await page.getByRole('dialog').count()) === 0) return;
  const recorded = page.waitForResponse((response) =>
    response.url().includes('/v1/me/onboarding-tour'),
  );
  await page.keyboard.press('Escape');
  await recorded;
  // Closing records the tour as seen: wait for that request before leaving the page.
  await page.getByRole('dialog').waitFor({ state: 'detached' });
  await page.waitForLoadState('networkidle');
}
