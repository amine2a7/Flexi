import { expect, test } from '@playwright/test';
import { signIn } from './sign-in';

// Bug 5 (processus v2): the transfer declaration goes through at the first try, and a refused
// field shows the server's exact error under it. Runs on the demo seed (`pnpm demo`).
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
  'base64',
);

test('the company declares its transfer at the first try', async ({ page }) => {
  await signIn(page, 'comptable@flexipay.test');
  await page.goto('/fr/entreprise/commandes');
  await page
    .getByRole('row')
    .filter({ hasText: 'En attente de paiement' })
    .first()
    .getByRole('link')
    .first()
    .click();
  const form = page.locator('form').filter({ has: page.getByLabel('Capture du virement') });
  await expect(form).toBeVisible();
  const hint = await form.getByText(/Montant à virer/).textContent();
  await form.getByLabel('Référence du virement').fill('VIR-BIAT-778213');
  await form.getByLabel('Date du virement').fill(new Date().toISOString().slice(0, 10));
  await form.getByLabel('Montant viré').fill(/Montant à virer : ([\d\s  ]+,\d{3})/.exec(hint ?? '')?.[1] ?? '');
  await form
    .getByLabel('Capture du virement')
    .setInputFiles({ name: 'avis.png', mimeType: 'image/png', buffer: PNG });
  await form.getByRole('button', { name: 'Envoyer la déclaration' }).click();
  await expect(page.getByText('En attente de validation').first()).toBeVisible();
  await expect(page.getByText('Vérifiez les champs signalés.')).toHaveCount(0);
});
