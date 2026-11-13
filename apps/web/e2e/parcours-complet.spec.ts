// Parcours complet (request of 2026-11-12), on the real API and a database reset at start:
// only admin@ (super-admin), operations@ (KYC decision, decision of 2026-11-12: four eyes),
// sarra@ and nour@ (Finance) come from the seed; the company, its employee and the merchant are
// created during the test and sign in with the temporary password shown at their creation.
// The API runs with TEST_CLOCK=1 (DEMO_TEST_CLOCK=1 pnpm demo:rapide): days move forward for the
// daily payment cap and the settlement at D+2. A screenshot at each step:
// e2e/captures/parcours/.
import { execSync } from 'node:child_process';
import { mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { expect, test, type APIRequestContext, type Browser, type Page } from '@playwright/test';
import { dismissTour } from './sign-in';

const ROOT = join(import.meta.dirname, '..', '..', '..');
const SHOTS = join(import.meta.dirname, 'captures', 'parcours');
const API = `http://localhost:${process.env.E2E_API_PORT ?? '3198'}`;
const SEED_PASSWORD = 'Test1234!';
/** The test routes of the API answer the local test runner only (header sent on purpose). */
const TEST_HEADERS = { 'x-flexipay-test': '1' };
const MFA = '123456';
const NEW_PASSWORD = 'Parcours-2026!sur';
const PIN = '4826';
const TEMP = /[A-Za-z2-9]{4}-[A-Za-z2-9]{4}-[A-Za-z2-9]{4}-[A-Za-z2-9]{4}/;
const PDF = Buffer.from(
  '%PDF-1.4\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n2 0 obj<</Type/Pages/Kids[]/Count 0>>endobj\ntrailer<</Root 1 0 R>>\n%%EOF\n',
);
const pdf = (name: string) => ({ name, mimeType: 'application/pdf', buffer: PDF });
/** A formatted amount, whatever the spaces of the thousands (narrow no-break space). */
const tnd = (text: string) => new RegExp(text.replace(/ /g, '\\s?'));

let step = 0;
async function capture(page: Page, name: string): Promise<void> {
  step += 1;
  await page.screenshot({
    path: join(SHOTS, `${String(step).padStart(2, '0')}-${name}.png`),
    fullPage: true,
  });
}

async function advanceDays(request: APIRequestContext, days: number): Promise<void> {
  const response = await request.post(`${API}/__test/clock?days=${String(days)}`, {
    headers: TEST_HEADERS,
  });
  expect(response.ok(), 'TEST_CLOCK=1 is required on the API').toBe(true);
}

/** Signs in (password, then the MFA code when the account has one) and lands in the space. */
async function login(page: Page, email: string, password: string): Promise<void> {
  await page.goto('/fr/login');
  await page.getByLabel('E-mail ou téléphone').fill(email);
  await page.getByLabel('Mot de passe', { exact: true }).fill(password);
  await page.getByRole('button', { name: 'Valider mon ticket' }).click();
  const mfa = page.getByLabel('Code à 6 chiffres');
  await page.waitForURL((url) => !url.pathname.endsWith('/login'));
  if (page.url().includes('/login/mfa')) {
    await mfa.fill(MFA);
    await page.getByRole('button', { name: 'Vérifier' }).click();
    await page.waitForURL((url) => !url.pathname.includes('/login'));
  }
  await page.locator('#main-content h1').first().waitFor();
  await dismissTour(page);
}

/** First sign-in of an account created during the test: temporary password, own password, MFA. */
async function firstLogin(page: Page, email: string, temporary: string): Promise<void> {
  await page.goto('/fr/login');
  await page.getByLabel('E-mail ou téléphone').fill(email);
  await page.getByLabel('Mot de passe', { exact: true }).fill(temporary);
  await page.getByRole('button', { name: 'Valider mon ticket' }).click();
  await expect(page.getByRole('heading', { name: 'Choisissez votre mot de passe' })).toBeVisible();
  await page.getByLabel('Nouveau mot de passe').fill(NEW_PASSWORD);
  await page.getByLabel('Confirmer le mot de passe').fill(NEW_PASSWORD);
  await page.getByRole('button', { name: 'Enregistrer mon mot de passe' }).click();
  await page.waitForURL((url) => !url.pathname.includes('premiere-connexion'));
  const enrol = page.getByLabel("3. Saisissez le code affiché par l'application.");
  if (await enrol.isVisible().catch(() => false)) {
    await enrol.fill(MFA);
    await page.getByRole('button', { name: 'Activer' }).click();
    await page
      .getByLabel('J’ai noté mes codes de secours')
      .or(page.getByLabel("J'ai noté mes codes de secours"))
      .check();
    await page.getByRole('button', { name: 'Accéder à mon espace' }).click();
  }
  await page.locator('#main-content h1').first().waitFor();
  await dismissTour(page);
}

/** Reads the temporary password shown once, then closes the window. */
async function readCredentials(page: Page): Promise<string> {
  const dialog = page.getByRole('dialog', { name: 'Identifiants à transmettre' });
  await expect(dialog).toBeVisible();
  const text = await dialog.innerText();
  const found = TEMP.exec(text)?.[0];
  expect(found, 'temporary password shown once').toBeDefined();
  await dialog.getByRole('button', { name: "J'ai transmis les identifiants" }).click();
  await expect(dialog).toHaveCount(0);
  return found ?? '';
}

async function actor(browser: Browser): Promise<Page> {
  const context = await browser.newContext({
    baseURL: test.info().project.use.baseURL,
    locale: 'fr-FR',
    reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  // A blocked step fails in 30 s with its reason, instead of waiting for the test timeout.
  page.setDefaultTimeout(30_000);
  return page;
}

/** Uploads every document asked in « Mon dossier » (the four of the platform settings). */
async function fileKyc(page: Page, space: 'entreprise' | 'commercant'): Promise<void> {
  await page.goto(`/fr/${space}/dossier`);
  await expect(page.getByRole('heading', { level: 1, name: 'Mon dossier' })).toBeVisible();
  const inputs = page.locator('input[type="file"][id^="kyc-"]');
  // Five pieces since the corrections of 2026-11-13: the CIN in two, front and back.
  await expect(inputs).toHaveCount(5);
  for (let index = 0; index < 5; index += 1) {
    const input = inputs.nth(index);
    const id = (await input.getAttribute('id')) ?? `piece-${String(index)}`;
    await input.setInputFiles(pdf(`${id}.pdf`));
    await expect(page.getByText('Déposée').nth(index)).toBeVisible();
  }
  await expect(page.getByText('Dossier complet : FlexiPay le vérifie.')).toBeVisible();
}

/** operations@ opens the KYC file of the account and validates it (never the creator, four eyes). */
async function validateKyc(page: Page, name: string): Promise<void> {
  await page.goto('/fr/admin/kyc');
  await dismissTour(page);
  await page.getByRole('link', { name }).first().click();
  await page.getByRole('button', { name: 'Valider le dossier' }).click();
  await page.getByRole('dialog').getByRole('button', { name: 'Valider le dossier' }).click();
  await expect(page.getByText('Dossier validé : le compte est actif.')).toBeVisible();
}

test.describe.configure({ mode: 'serial' });

test('parcours complet : de la création du client au virement du commerçant', async ({
  browser,
  request,
}) => {
  test.skip(test.info().project.name !== 'desktop', 'one journey, desktop screen');
  test.setTimeout(30 * 60_000);
  // Only on an API started with the test clock (DEMO_TEST_CLOCK=1 pnpm demo:rapide): elsewhere
  // the journey is skipped before anything is reset.
  const clock = await request
    .get(`${API}/__test/clock`, { headers: TEST_HEADERS })
    .catch(() => undefined);
  test.skip(clock?.ok() !== true, 'needs the API test clock (DEMO_TEST_CLOCK=1 pnpm demo:rapide)');
  mkdirSync(SHOTS, { recursive: true });
  // A database reset at start (demo seed: admin@, operations@, sarra@, nour@ and the settings).
  execSync('pnpm demo:reset', { cwd: ROOT, stdio: 'ignore' });

  const admin = await actor(browser);
  const company = await actor(browser);
  const ops = await actor(browser);
  const sarra = await actor(browser);
  const nour = await actor(browser);
  const merchant = await actor(browser);
  const beneficiary = await actor(browser);
  const companyEmail = 'rh@test-parcours.tn';
  const employeeEmail = 'beneficiaire@test-parcours.tn';
  const merchantEmail = 'gerant@resto-parcours.tn';

  // 1. admin@ creates « Test Parcours SA » (PM MF, grid 3 %) and reads its temporary password.
  await login(admin, 'admin@flexipay.test', SEED_PASSWORD);
  await admin.goto('/fr/admin/entreprises');
  await admin.getByRole('button', { name: 'Créer une entreprise' }).click();
  let dialog = admin.getByRole('dialog');
  await dialog.getByLabel('Raison sociale').fill('Test Parcours SA');
  await dialog.getByLabel('Forme juridique').selectOption('PM_MF');
  await dialog.getByLabel('Ville').fill('Tunis');
  await dialog.getByLabel('Téléphone').fill('+21671000001');
  await dialog.getByLabel('E-mail du responsable').fill(companyEmail);
  await dialog.getByRole('button', { name: 'Continuer' }).click();
  await dialog.getByLabel('Taux par défaut (%)').fill('3');
  await capture(admin, 'admin-cree-entreprise');
  await dialog.getByRole('button', { name: "Créer l'entreprise" }).click();
  const companyPassword = await readCredentials(admin);

  // 2. The company signs in with it, chooses its password, files its 4 KYC documents.
  await firstLogin(company, companyEmail, companyPassword);
  await fileKyc(company, 'entreprise');
  await capture(company, 'entreprise-kyc-depose');

  // 3. operations@ validates the file: the company is active.
  await login(ops, 'operations@flexipay.test', SEED_PASSWORD);
  await validateKyc(ops, 'Test Parcours SA');
  await company.goto('/fr/entreprise/dossier');
  await expect(company.getByText('Dossier validé : votre compte est actif.')).toBeVisible();
  await capture(company, 'entreprise-active');

  // 4. Department Production and the employee « Bénéficiaire Test » (Ouvrier).
  await company.goto('/fr/entreprise/departements');
  await company.getByRole('button', { name: 'Créer un département' }).first().click();
  await company.getByRole('dialog').getByLabel('Nom du département').fill('Production');
  await company.getByRole('dialog').getByRole('button', { name: 'Créer le département' }).click();
  await expect(company.getByText('Département « Production » créé.')).toBeVisible();
  await company.goto('/fr/entreprise/employes');
  await company.getByRole('button', { name: 'Ajouter un employé' }).first().click();
  dialog = company.getByRole('dialog');
  await dialog.getByLabel('Matricule').fill('TP-001');
  await dialog.getByLabel('Prénom').fill('Bénéficiaire');
  await dialog.getByLabel('Nom', { exact: true }).fill('Test');
  await dialog.getByLabel('E-mail').fill(employeeEmail);
  await dialog.getByLabel('Téléphone').fill('+21698000001');
  await dialog.getByLabel('Département').selectOption({ label: 'Production' });
  await dialog.getByLabel('Poste').fill('Ouvrier');
  await dialog.getByRole('button', { name: "Créer l'employé" }).click();
  const employeePassword = await readCredentials(company);
  await capture(company, 'entreprise-employe-cree');

  // 5. Order: Restauration 10 000 + Carburant 6 000, total 16 581,000.
  await company.goto('/fr/entreprise/commandes/nouvelle');
  await company.getByLabel('Montant Restauration (TND)').fill('10000');
  await company.getByLabel('Montant Carburant (TND)').fill('6000');
  await company.getByRole('button', { name: 'Calculer le récapitulatif' }).click();
  await expect(company.getByText(tnd('16 581,000')).first()).toBeVisible();
  await capture(company, 'entreprise-devis-16581');
  await company.getByRole('button', { name: 'Passer la commande' }).click();
  await company
    .getByRole('dialog')
    .getByRole('button', { name: /^Commander pour/ })
    .click();
  await expect(company.getByRole('heading', { level: 1, name: /^Commande CMD-/ })).toBeVisible();

  // 6. admin@ confirms; the company declares its transfer; sarra@ (1/2) then nour@ validate.
  await admin.goto('/fr/admin/commandes');
  await admin
    .getByRole('row')
    .filter({ hasText: 'Test Parcours SA' })
    .getByRole('link')
    .first()
    .click();
  await admin.waitForURL(/\/admin\/commandes\/[0-9a-f-]{36}$/);
  const orderUrl = admin.url();
  await admin.getByRole('button', { name: 'Confirmer la commande' }).click();
  await admin.getByRole('dialog').getByRole('button', { name: 'Confirmer la commande' }).click();
  await expect(admin.getByText('Commande confirmée.')).toBeVisible();
  await company.goto('/fr/entreprise/commandes');
  await company
    .getByRole('row')
    .filter({ hasText: 'En attente de paiement' })
    .first()
    .getByRole('link')
    .first()
    .click();
  const form = company.locator('form').filter({ has: company.getByLabel('Capture du virement') });
  await form.getByLabel('Référence du virement').fill('VIR-PARCOURS-0001');
  await form.getByLabel('Date du virement').fill(new Date().toISOString().slice(0, 10));
  await form.getByLabel('Montant viré (TND)').fill('16581');
  await form.getByLabel('Capture du virement').setInputFiles(pdf('avis-virement.pdf'));
  await form.getByRole('button', { name: 'Envoyer la déclaration' }).click();
  await expect(company.getByText('En attente de validation').first()).toBeVisible();
  await capture(company, 'entreprise-virement-declare');
  const path = new URL(orderUrl).pathname;
  await login(sarra, 'sarra@flexipay.tn', SEED_PASSWORD);
  await sarra.goto(path);
  await sarra.getByRole('button', { name: 'Première validation' }).click();
  await sarra
    .getByRole('dialog')
    .getByRole('button', { name: /Première validation|Valider/ })
    .click();
  await expect(sarra.getByText(/Première validation enregistrée/)).toBeVisible();
  await capture(sarra, 'sarra-premiere-validation');
  await login(nour, 'nour@flexipay.tn', SEED_PASSWORD);
  await nour.goto(path);
  await nour.getByRole('button', { name: 'Valider (2e validation)' }).click();
  await nour
    .getByRole('dialog')
    .getByRole('button', { name: /Valider/ })
    .click();
  await expect(nour.getByText(/Paiement validé/).first()).toBeVisible();
  await capture(nour, 'nour-seconde-validation');
  await company.goto('/fr/entreprise');
  await expect(company.getByText(tnd('10 000,000')).first()).toBeVisible();
  await expect(company.getByText(tnd('6 000,000')).first()).toBeVisible();
  await company.goto('/fr/entreprise/factures');
  await expect(company.getByRole('row').nth(1)).toBeVisible();
  await capture(company, 'entreprise-soldes-facture');

  // 7. 1 300 TND of Restauration to the beneficiary (Production + Ouvrier), template saved.
  await company.goto('/fr/entreprise/attribution');
  await company.getByLabel('Département').selectOption({ label: 'Production' });
  await company.getByLabel('Poste').selectOption({ label: 'Ouvrier' });
  await company.getByRole('button', { name: 'Tout sélectionner (résultat du filtre)' }).click();
  await expect(company.getByText('1 employé sélectionné')).toBeVisible();
  await company.getByLabel('Restauration par employé (TND)').fill('1300');
  await company.getByRole('button', { name: 'Voir l’aperçu' }).click();
  await company.getByLabel('Enregistrer comme modèle').check();
  await company.getByLabel('Nom du modèle').fill('Tickets Production');
  await capture(company, 'entreprise-attribution-apercu');
  await company.getByRole('button', { name: 'Attribuer', exact: true }).click();
  await company.getByRole('dialog').getByRole('button', { name: 'Attribuer' }).click();
  await expect(company.getByText('Modèle « Tickets Production » enregistré.')).toBeVisible();

  // 8. admin@ creates « Resto Parcours » (PP CIN, grid 2 %, Restauration); it files KYC and RIB.
  await admin.goto('/fr/admin/commercants');
  await admin.getByRole('button', { name: 'Créer un commerçant' }).click();
  dialog = admin.getByRole('dialog');
  await dialog.getByLabel('Nom du commerce').fill('Resto Parcours');
  await dialog.getByLabel('Forme juridique').selectOption('PP_CIN');
  await dialog.getByLabel('Catégorie').selectOption('RESTAURANT');
  await dialog.getByLabel('Ville').fill('Tunis');
  await dialog.getByLabel('Téléphone').fill('+21671000002');
  await dialog.getByLabel('E-mail du responsable').fill(merchantEmail);
  await dialog.getByLabel('Restauration').check();
  await dialog.getByRole('button', { name: 'Continuer' }).click();
  await dialog.getByLabel('Taux par défaut (%)').fill('2');
  await capture(admin, 'admin-cree-commercant');
  await dialog.getByRole('button', { name: 'Créer le commerçant' }).click();
  const merchantPassword = await readCredentials(admin);
  await firstLogin(merchant, merchantEmail, merchantPassword);
  await fileKyc(merchant, 'commercant');
  await validateKyc(ops, 'Resto Parcours');
  // The IBAN of the RIB is entered by an administrator and approved by another one (four eyes):
  // a merchant never changes its own bank account.
  await admin.goto('/fr/admin/commercants');
  await admin.getByRole('link', { name: 'Resto Parcours' }).first().click();
  await admin.getByRole('button', { name: 'Changer le RIB' }).click();
  dialog = admin.getByRole('dialog');
  await dialog.getByLabel('Nouveau RIB (IBAN)').fill('TN5910006035183598478831');
  await dialog.getByLabel('Motif').fill('RIB déposé dans le dossier KYC');
  await dialog.getByRole('button', { name: 'Envoyer pour validation' }).click();
  await expect(dialog).toHaveCount(0);
  await login(sarra, 'sarra@flexipay.tn', SEED_PASSWORD);
  await sarra.goto('/fr/admin/validations');
  await sarra
    .getByRole('row')
    .filter({ hasText: 'Resto Parcours' })
    .getByRole('button', { name: 'Valider' })
    .click();
  await sarra.getByRole('dialog').getByRole('button', { name: 'Valider la demande' }).click();
  await expect(sarra.getByText('Demande validée.')).toBeVisible();
  await capture(merchant, 'commercant-kyc-valide');

  // 9. The beneficiary signs in with its temporary password, chooses its password and PIN.
  await firstLogin(beneficiary, employeeEmail, employeePassword);
  await beneficiary.goto('/fr/beneficiaire/securite');
  await expect(beneficiary.getByText('Choisissez votre code PIN')).toBeVisible();
  await beneficiary.getByLabel('Nouveau PIN (4 chiffres)').fill(PIN);
  await beneficiary.getByLabel('Confirmer le nouveau PIN').fill(PIN);
  await beneficiary.getByRole('button', { name: 'Enregistrer mon PIN' }).click();
  await expect(beneficiary.getByText('PIN enregistré : vous pouvez payer.')).toBeVisible();
  await capture(beneficiary, 'beneficiaire-pin');

  // 10. 1 250 TND paid at Resto Parcours, 150 TND a day (daily cap), 50,000 left.
  await merchant.goto('/fr/commercant/encaissement');
  const codeText = merchant.getByText(/Code commerçant\s*:\s*\d{6}/);
  await expect(codeText).toBeVisible();
  const merchantCode = /(\d{6})/.exec(await codeText.innerText())?.[1];
  expect(merchantCode).toBeDefined();
  const amounts = [150, 150, 150, 150, 150, 150, 150, 150, 50];
  for (const [day, amount] of amounts.entries()) {
    if (day > 0) {
      await advanceDays(request, 1);
      await login(beneficiary, employeeEmail, NEW_PASSWORD);
    }
    await beneficiary.goto('/fr/beneficiaire/payer');
    await beneficiary.getByRole('button', { name: 'Payer un commerçant' }).click();
    await beneficiary.getByLabel('Code commerçant (6 chiffres)').fill(merchantCode ?? '');
    await beneficiary.getByRole('button', { name: 'Continuer' }).click();
    const category = beneficiary.getByLabel('Type de crédit');
    if ((await category.count()) > 0) await category.selectOption('RESTAURATION');
    await beneficiary.getByLabel('Montant (TND)').fill(String(amount));
    await beneficiary
      .locator('main')
      .getByRole('button', { name: /^Payer [0-9]/ })
      .click();
    await beneficiary.getByLabel('Code PIN (4 chiffres)').fill(PIN);
    await beneficiary
      .getByRole('dialog')
      .getByRole('button', { name: /^Payer / })
      .click();
    await expect(beneficiary.getByText('Paiement accepté')).toBeVisible();
  }
  await beneficiary.goto('/fr/beneficiaire');
  await expect(beneficiary.getByText(tnd('50,000')).first()).toBeVisible();
  await capture(beneficiary, 'beneficiaire-reste-50');

  // 11. Three days later (D+2 passed), the merchant asks its transfer: net 1 214,500.
  await advanceDays(request, 3);
  await login(merchant, merchantEmail, NEW_PASSWORD);
  await merchant.goto('/fr/commercant/virements');
  await merchant.getByLabel('Montant à virer (TND)').fill('1250');
  await merchant.getByRole('button', { name: 'Simuler', exact: true }).click();
  const summary = merchant.locator('dl').filter({ hasText: 'Net viré' }).first();
  for (const [label, value] of [
    ['Commission', '25,000'],
    ['TVA sur la commission', '4,750'],
    ['Retenue à la source', '0,750'],
    ['Timbre fiscal', '1,000'],
    ['Frais de virement', '4,000'],
    ['Net viré', '1 214,500'],
  ] as const) {
    await expect(summary.getByText(label).first()).toBeVisible();
    await expect(summary.getByText(tnd(value)).first()).toBeVisible();
  }
  await capture(merchant, 'commercant-simulation-1214500');
  await merchant.getByRole('button', { name: 'Demander ce virement' }).click();
  await merchant
    .getByRole('dialog')
    .getByRole('button', { name: /^Demander / })
    .click();
  await expect(merchant.getByText('Demande enregistrée')).toBeVisible();

  // 12. sarra@ accepts, records the payment with a bank reference: « Payé », invoice issued.
  await login(sarra, 'sarra@flexipay.tn', SEED_PASSWORD);
  await sarra.goto('/fr/admin/virements');
  await sarra
    .getByRole('row')
    .filter({ hasText: 'Resto Parcours' })
    .getByRole('link')
    .first()
    .click();
  await sarra.getByRole('button', { name: 'Valider le virement' }).click();
  await sarra.getByRole('dialog').getByRole('button', { name: 'Valider le virement' }).click();
  await expect(sarra.getByText('Virement validé : ajouté au prochain lot.')).toBeVisible();
  await sarra.getByRole('button', { name: 'Enregistrer le paiement' }).click();
  dialog = sarra.getByRole('dialog');
  await dialog.getByLabel('Référence du virement bancaire').fill('BIAT-PARCOURS-778213');
  await dialog.getByRole('button', { name: 'Valider' }).click();
  await expect(sarra.getByText(/paiement enregistré, virement payé/)).toBeVisible();
  await expect(sarra.getByText('Payé').first()).toBeVisible();
  await capture(sarra, 'sarra-virement-paye');
  await login(merchant, merchantEmail, NEW_PASSWORD);
  await merchant.goto('/fr/commercant/virements');
  await merchant.getByRole('button', { name: 'Suivi des demandes' }).click();
  await merchant
    .getByRole('link', { name: /VIR-|Ouvrir/ })
    .first()
    .click();
  // The merchant's own wording of a paid transfer: « Exécutée », funds on its account.
  await expect(merchant.getByText('Virement exécuté : fonds sur votre compte')).toBeVisible();
  // Its fees: commission 25 + VAT 4,750 + withholding 0,750 + stamp 1 + transfer 4 = 35,500.
  for (const fee of ['25,000', '4,750', '0,750', '1,000', '4,000', '1 214,500']) {
    await expect(merchant.locator('main').getByText(tnd(fee)).first()).toBeVisible();
  }
  await expect(
    merchant
      .getByRole('link', { name: 'Télécharger la facture de commission' })
      .or(merchant.getByRole('button', { name: 'Télécharger la facture de commission' })),
  ).toBeVisible();
  await capture(merchant, 'commercant-paye-facture');

  // 13. Books: 8 700 + 6 000 at the company, 50 for the beneficiary, 1 214,500 paid out,
  // 581,000 + 35,500 of fees = 16 581,000; no « Écart du grand livre » alert.
  await login(company, companyEmail, NEW_PASSWORD);
  await company.goto('/fr/entreprise');
  await expect(company.getByText(tnd('8 700,000')).first()).toBeVisible();
  await expect(company.getByText(tnd('6 000,000')).first()).toBeVisible();
  // Its invoice: 16 000 of credits + 581,000 of fees = 16 581,000.
  await company.goto('/fr/entreprise/factures');
  await expect(company.locator('main').getByText(tnd('16 581,000')).first()).toBeVisible();
  await capture(company, 'entreprise-soldes-finaux');
  // Every millime is found: 8 700 + 6 000 + 50 + 1 214,500 + 581 + 35,500 = 16 581,000.
  expect(8_700_000 + 6_000_000 + 50_000 + 1_214_500 + 581_000 + 35_500).toBe(16_581_000);
  // The reconciliation of the books, run now: balances, double entry, lots, taxes.
  const books = await request.post(`${API}/__test/reconcile`, { headers: TEST_HEADERS });
  expect(await books.json()).toEqual({ ok: true });
  await login(admin, 'admin@flexipay.test', SEED_PASSWORD);
  await admin.goto('/fr/admin/securite');
  await expect(admin.getByRole('heading', { level: 1 })).toBeVisible();
  await expect(admin.getByText('Écart du grand livre')).toHaveCount(0);
  await capture(admin, 'admin-aucun-ecart');
});
