# Spec design – Commerçant › Encaissement (saisie du code client)
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD3 · **Auteur :** design · **Date :** 2026-10-12
**Route :** `/merchant/collect` (onglet « Encaisser » du module `nav.merchant.collect`, l'onglet « Historique » est `commercant-historique.md`) · **Exigences couvertes :** COM-03 (saisie manuelle du code à 8 chiffres), COM-04, RG-5 (QR dynamique 60 s ou code manuel à 8 chiffres, résultat « accepté » / « refusé » seulement côté commerçant), critère d'acceptation 5, `decisions.md` du 2026-10-09 (texte du refus, aucun solde).
**Hors périmètre web :** le **scan QR par caméra** (COM-02) relève de l'application Pro (mobile, reportée). Le web couvre la saisie du code.
**Dépend de :** `_socle-ecrans.md`, `fondations-composants.md` (C.2 `MoneyInput`, C.8.11), `dev-composants.md` (NC.3, NC.8, NC.9), `commercant-encaissement-resultat.md` (suite du parcours). Contrat : `_besoins-contrat.md` §2 (CT-M-2).

## 1. Objectif
Démarrer un encaissement : le commerçant saisit le **code à 8 chiffres** affiché dans l'application du client et le **montant**, puis demande le paiement. **Action principale unique : « Encaisser ».** La confirmation du client et le résultat sont sur la page suivante.

## 2. Rôles et permissions
Propriétaire et caissier (permission « encaisser », nom à confirmer, format `module.action`). Un comptable n'a ni l'onglet ni la page (retirés, pas grisés) ; accès direct par URL → C.8.8. Le commerçant doit être actif : si le serveur refuse (compte non validé ou suspendu), le front affiche seulement le refus générique (§6), **sans motif**.

## 3. Structure
1. `h1` « Encaisser un paiement » ; onglets `Encaisser` · `Historique` (NC.4).
2. **Carte du formulaire** (largeur max `size.form-max-width`) :
   - aide : « Demandez au client le code à 8 chiffres affiché dans son application. » ;
   - champ **Code du client** (8 chiffres) ;
   - champ **Montant** (`MoneyInput`, devise TND, aperçu « Soit … TND ») ;
   - **bouton principal « Encaisser »** (`accent`, pleine largeur sous `breakpoint.sm`).
3. Aucun solde, plafond ni information sur le client n'est affiché avant l'initiation (le front ne connaît rien du client).

**Action :** `POST /v1/merchant/payments` avec `Idempotency-Key` (S7) ; succès → navigation vers `/merchant/collect/payments/{id}` (attente de la confirmation du client, voir `commercant-encaissement-resultat.md`).

## 4. Composants et tokens
`Tabs` (NC.4) · `Card` desktop (`radius.card-desktop`, `space.6`) · `Field` code : `inputmode="numeric"`, `autocomplete="off"`, hauteur `size.input-height`, `type-scale.title` à chasse fixe `tabular-nums`, espacement de lecture des chiffres (visuel seulement, par groupes de 4 en CSS, la valeur reste 8 chiffres) · `MoneyInput` (C.2, UX-05) · `Button` `accent` (`color.emerald` / `color.on-emerald`, `size.button-height`) · aide `type-scale.body` `color.text-muted` · `StateView` `inline` (refus) · barre d'action collante sous `breakpoint.sm`.

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `merchant.collect.title` | Encaisser un paiement |
| `merchant.collect.tabs.collect` / `.history` | Encaisser · Historique |
| `merchant.collect.help` | Demandez au client le code à 8 chiffres affiché dans son application. |
| `merchant.collect.code.label` | Code du client |
| `merchant.collect.code.help` | 8 chiffres. |
| `merchant.collect.amount.label` | Montant à encaisser |
| `merchant.collect.submit` | Encaisser |
| `merchant.collect.offline.label` | `common.state.offline.actionDisabled` « Indisponible hors connexion. » (+ « L'encaissement nécessite une connexion. » `merchant.collect.offline.message`) |
| `merchant.collect.declined.action` | Nouvel encaissement (`errors.paymentDeclined.action`) |
| `errors.paymentDeclined.label` | Paiement refusé. Le client peut vérifier son application. |
| `errors.field.invalidFormat` | Le format est incorrect. (code mal formé) |
| `errors.field.required` | Ce champ est obligatoire. |
| `common.field.amount.invalid` / `common.field.amount.preview` | voir C.2 |
Texte du refus : **exactement** « Paiement refusé. Le client peut vérifier son application. » (décision de l'utilisateur du 2026-10-09), seul message affiché, sans second texte.

## 6. États
| État | Rendu |
|---|---|
| Repos | formulaire vide, focus initial sur le champ Code |
| Chargement (soumission) | bouton `loading` (`aria-busy`, clics ignorés), champs en lecture seule ; **jamais de bouton « Annuler »** pendant l'écriture (C.8.1) ; au-delà de `UI.slowLoadingMs` : bandeau C.8.10 + « Vérifier l'état de l'opération » (rejeu avec la même clé) |
| Erreur de validation (`400 VALIDATION_FAILED`) | messages sous les champs (format du code, montant non entier ou ≤ 0 — pointers `/code`, `/amountMillimes`), résumé annoncé, focus sur le premier champ fautif ; la saisie est conservée |
| **Refus (`422 PAYMENT_DECLINED`)** | `StateView` `inline` (C.8.11) : icône `CircleX`, **uniquement** le texte exact du refus, `role="alert"`, action principale « Nouvel encaissement » (efface le formulaire et prépare une **nouvelle** `Idempotency-Key`) ; **aucun motif, aucun montant, aucun solde, aucun bouton « Réessayer » avec la même clé** (un nouvel essai est une nouvelle intention). Le même écran couvre code inconnu, expiré, déjà utilisé, commerçant suspendu, solde ou plafond : le front ne peut pas les distinguer, c'est voulu |
| Trop de demandes (`429`) | `errors.rateLimited` + compte à rebours, bouton désactivé avec raison |
| Erreur serveur / réseau | `errors.internal` / `errors.network` + « Réessayer » avec **la même clé** + référence ; `common.state.error.safeRetry` |
| `409 IDEMPOTENCY_REQUEST_IN_PROGRESS` | bandeau « Traitement en cours… », nouvel essai automatique après `Retry-After` |
| Hors connexion | bandeau C.8.4 ; bouton désactivé avec `merchant.collect.offline.label` ; la saisie est conservée |
| Session expirée | N.6 (code et montant non conservés) |
| Permission refusée | C.8.8 |
| Vide / solde insuffisant / plafond | **sans objet** : le commerçant ne voit jamais de solde ni de motif (COM-04 v4.1, critère d'acceptation 4 réservé au payeur) |

## 7. Données et contrat
| Élément | Source | Statut |
|---|---|---|
| Soumission | `POST /v1/merchant/payments` `{ code, amountMillimes }` (`PositiveAmountMillimes`) + `Idempotency-Key` | **N** (CT-M-2) |
| Réponse | `MerchantPayment { id, status (PaymentStatus), amountMillimes, category, customer, maskedMatricule, expiresAt, serverTime }` — consommée par la page suivante | **N** |
| Erreurs | `Problem` : `PAYMENT_DECLINED` (E), `VALIDATION_FAILED` (E), `RATE_LIMITED` (E), `IDEMPOTENCY_REQUEST_IN_PROGRESS` (E) | **E** |
Le code est validé en **format** seulement (8 chiffres) ; le front ne contrôle ni l'existence, ni la validité, ni le montant maximal.

## 8. RTL
Formulaire aligné `start` ; le **code** et le **montant** sont saisis et affichés en LTR (blocs isolés) ; devise après le nombre ; bouton pleine largeur sous `breakpoint.sm`.

## 9. Accessibilité
`<form>` ; labels explicites ; aide liée par `aria-describedby` ; code : `inputmode="numeric"`, pas de `type="number"` (flèches, perte de zéros) ; **pas d'envoi automatique à 8 chiffres** ; erreurs `role="alert"` ; le refus prend le focus (titre) ; ordre de focus : onglets → code → montant → « Encaisser » ; contrastes `on-emerald/emerald` 6,69:1, `danger-text/danger-soft` 5,30:1 ; cibles ≥ `size.touch-target-min` ; aperçu du montant annoncé poliment (C.2).

## 10. Responsive
`size.viewport-min` : une colonne, bouton « Encaisser » dans une **barre d'action collante** en bas (formulaire de décision, N.2/UX-18) ; ≥ `breakpoint.md` : carte centrée de largeur `size.form-max-width` ; le clavier numérique s'ouvre pour le code et le montant.

## 11. Sécurité (points pour `securite`)
Aucun oracle : toutes les causes d'échec donnent le même écran ; pas de compte à rebours « code valide encore X s » avant l'initiation ; le code n'est pas journalisé ni stocké (effacé à l'envoi et au démontage) ; une `Idempotency-Key` par intention ; `merchantId` jamais fourni par le client ; limitation de débit côté serveur.

## 12. Questions et décisions ouvertes
1. **[DÉCISION] `main`** — **séquence du paiement** : `docs/architecture.md` (« l'employé confirme par PIN/biométrie ») et le cahier COM-04 (« écran de validation : … confirmation et annulation ») ne disent pas qui confirme. Le design retient : le commerçant initie (code + montant), le **client** confirme dans son application, le commerçant **voit l'attente** et peut **annuler tant que rien n'est confirmé** ; le résultat est « accepté » ou « refusé » sans motif. À confirmer avant WF3.
2. **[QUESTION] backend** CT-M-2 : champs de la réponse, polling ou SSE, annulation, `serverTime`.
