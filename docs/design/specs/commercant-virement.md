# Spec design – Commerçant › Simulation et demande de virement
**Statut :** prête pour relecture (ux → conformite → securite ; **argent : ledger-auditor informé**) · **Tâche :** WD3 · **Auteur :** design · **Date :** 2026-10-12
**Routes :** `/merchant/settlements/payouts/new` (simulation et demande) et `/merchant/settlements/payouts/{id}` (résultat et suivi d'une demande) · **Exigences couvertes :** COM-07 (demande de virement avec simulation : montant, taux, commission, net), RG-1.5 (brut → commission → net avant confirmation), RG-1.6 (taux figé à la validation), RG-4 (seuil minimum de règlement), RG-6 (contrôles : RIB, KYC, LAB/FT), glossaire E4, E5, E6, E14, cahier §9 critère 2, spec 03 §2 et spec 07 §2 (profil changé entre simulation et demande), revue ux UX-04, UX-06, UX-07, UX-10, UX-01.
**Dépend de :** `_socle-ecrans.md` (S6, S7), `dev-composants.md` (NC.3 `ConfirmDialog`, NC.7 `AmountBreakdown`, NC.9 `ResultView`, NC.11 `MaskedValue`, NC.5), `fondations-composants.md` (C.2 `MoneyInput`, C.8.10). Contrat : `_besoins-contrat.md` §2 (CT-M-5, 6, 7, 8).

## 1. Objectif
Permettre au commerçant de **voir exactement ce qu'il recevra** avant de demander un virement : montant demandé (brut), **taux**, **commission**, **net à recevoir en grand**, puis de confirmer. **Action principale unique : « Demander le virement ».** Ce que le front affiche vient **entièrement** de l'API ; il ne calcule ni commission, ni net, ni plafond.

## 2. Rôles et permissions
Propriétaire (et comptable si l'API l'autorise : « les règlements » relèvent du comptable, spec 07 §2). Le **caissier ne peut pas** demander de virement (test spec 07) : la page est retirée de sa navigation, accès direct → C.8.8. L'API indique en plus `canRequest` (+ raison) : si `false`, le formulaire reste lisible mais l'action est absente, avec la raison en texte (`cannotRequestReasonKey`).

## 3. Structure
### Écran A – Simulation et demande (`/merchant/settlements/payouts/new`)
1. Lien « Retour à Règlements et factures » ; `h1` « Demander un virement ».
2. **Carte « Avant de commencer »** (`DescriptionList`) : **Montant disponible pour un virement** (`Amount` `lg`) · **Montant minimum d'un virement** (`Amount` `md`) · **Destination** : titulaire du compte + RIB masqué (`MaskedValue`, lecture seule).
3. **Champ « Montant à virer »** (`MoneyInput`) avec aide **avant la saisie** : « Minimum : {min} TND · Disponible : {available} TND » (le seuil est annoncé avant, pas seulement en cas d'erreur — ux).
4. Bouton `secondary` **« Voir la simulation »** (soumission explicite ; aucune simulation automatique à chaque frappe).
5. **Simulation** (apparaît sous le champ après réponse) : `AmountBreakdown` variante `deduction` :
   - **Montant demandé** (`md`) ;
   - **− Commission ({taux})** (`md`), ex. « − Commission (2 %) » ;
   - trait de total ;
   - **Net à recevoir** en `lg`, tonalité `positive` ;
   - aide : « Le taux est figé dès la confirmation. » (RG-1.6).
6. **Bouton principal « Demander le virement »** (`accent`) : ouvre la modale de confirmation (écran B). Lien `tertiary` « Annuler » (retour).
Si le montant saisi est modifié après la simulation, la simulation devient **périmée** : elle est retirée (ou marquée « Simulation à actualiser » avec le bouton « Voir la simulation ») ; le bouton « Demander le virement » reste affiché mais ne soumet que la simulation à jour (sinon il relance la simulation).
### Écran B – Confirmation (`ConfirmDialog` `sensitive`, NC.3)
Titre **« Demander ce virement ? »** · récapitulatif : `AmountBreakdown` (montant, commission et taux, **net en `lg`**) + **Destination** (RIB masqué) · ligne de conséquence (icône `Info`) : « Le taux de {taux} est figé dès la confirmation. Il ne changera plus pour cette demande. » · bouton principal **« Demander le virement »** (libellé par le résultat) · « Annuler ».
### Écran C – Résultat et suivi (`/merchant/settlements/payouts/{id}`)
`ResultView` (NC.9) lorsque la demande vient d'être créée, sinon en-tête de détail : `h1` « Demande de virement envoyée » (titre au passé) · `AmountBreakdown` **figé** (montant, taux figé, commission, net) · **statut** (`StatusBadge` `DEMANDEE`…) · **référence** copiable · **frise d'étapes** (UX-10, `Stepper` lecture seule) *Demandée → Contrôlée → Envoyée → Exécutée* (ou *Rejetée*) avec **une phrase par étape** · prochaine étape en texte (« Nous contrôlons votre demande. Vous serez notifié lorsque le virement sera exécuté. », sans délai inventé) · actions : **« Voir mes règlements »** (principale) et « Retour au tableau de bord ». Un rechargement affiche le même écran sans refaire l'opération.

## 4. Composants et tokens
`Card` desktop (`radius.card-desktop`, `space.6`, largeur max `size.form-max-width`) · `DescriptionList` (NC.13) · `MoneyInput` (C.2 : `size.input-height`, `radius.input`, devise TND, aperçu « Soit … TND ») · `AmountBreakdown` (NC.7 : libellés `type-scale.body` `color.text-muted`, montants `Amount` `md`, trait `color.border-strong`, total `lg` `color.emerald-text`) · `MaskedValue` (NC.11) · `ConfirmDialog` (`size.modal-max-width`, `color.overlay`, `shadow.raised`) · `Button` `accent` (réussite financière : `color.emerald`/`color.on-emerald`), `secondary`, `tertiary` · `ResultView` / `StateView` · `Stepper` (NC.5) en lecture seule · `Banner` info/erreur · barre d'action collante sous `breakpoint.sm`.

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `merchant.payout.title` | Demander un virement |
| `merchant.payout.back` | Retour à Règlements et factures |
| `merchant.payout.summary.available` | Montant disponible pour un virement |
| `merchant.payout.summary.minimum` | Montant minimum d'un virement |
| `merchant.payout.summary.destination` | Compte de destination |
| `merchant.payout.amount.label` | Montant à virer |
| `merchant.payout.amount.help` | Minimum : {min} TND · Disponible : {available} TND |
| `merchant.payout.simulate` | Voir la simulation |
| `merchant.payout.simulation.title` | Simulation |
| `merchant.payout.simulation.gross` | Montant demandé |
| `merchant.payout.simulation.commission` | Commission |
| `merchant.payout.simulation.net` | Net à recevoir |
| `merchant.payout.simulation.rateLocked` | Le taux est figé dès la confirmation. |
| `merchant.payout.simulation.stale` | Simulation à actualiser : le montant a changé. |
| `merchant.payout.submit` | Demander le virement |
| `merchant.payout.cancel` | Annuler |
| `merchant.payout.confirm.title` | Demander ce virement ? |
| `merchant.payout.confirm.consequence` | Le taux de {rate} est figé dès la confirmation. Il ne changera plus pour cette demande. |
| `merchant.payout.confirm.action` | Demander le virement |
| `merchant.payout.error.belowMinimum` | Le montant minimum d'un virement est de {min} TND. |
| `merchant.payout.error.exceedsAvailable` | Le montant dépasse le montant disponible ({available} TND). |
| `merchant.payout.cannot` | Vous ne pouvez pas demander de virement pour le moment. (+ raison fournie par l'API) |
| `merchant.payout.quoteChanged.title` | Le taux a changé depuis votre simulation |
| `merchant.payout.quoteChanged.message` | Vérifiez la nouvelle simulation avant de confirmer. Rien n'a été envoyé. |
| `merchant.payout.quoteChanged.old` / `.new` | Ancienne simulation · Nouvelle simulation |
| `merchant.payout.quoteChanged.action` | Demander le virement avec le nouveau taux |
| `merchant.payout.result.title` | Demande de virement envoyée |
| `merchant.payout.result.nextStep` | Nous contrôlons votre demande. Vous serez notifié lorsque le virement sera exécuté. |
| `merchant.payout.result.reference` | `common.result.reference` « Référence » |
| `merchant.payout.result.toSettlements` | Voir mes règlements |
| `merchant.payout.result.toDashboard` | `common.state.forbidden.action` « Retour au tableau de bord » |
| `merchant.payout.timeline.label` | Suivi de votre demande |
| `merchant.payout.timeline.REQUESTED` | Demandée — votre demande a été enregistrée. |
| `merchant.payout.timeline.CHECKED` | Contrôlée — nos équipes ont vérifié votre demande. |
| `merchant.payout.timeline.SENT` | Envoyée — le virement a été transmis à la banque. |
| `merchant.payout.timeline.EXECUTED` | Exécutée — le virement a été exécuté. |
| `merchant.payout.timeline.REJECTED` | Rejetée — la demande n'a pas pu être menée à bien. (motif de l'API s'il est fourni) |
| `common.breakdown.a11y.deduction` | {label} déduite : {amount} dinars tunisiens |
Statuts : `status.DEMANDEE` « Demandée », `status.CONTROLEE` « Contrôlée », `status.ENVOYEE` « Envoyée », `status.EXECUTEE` « Exécutée », `status.REJETEE` « Rejetée ». Erreurs génériques : `errors.*`. **Exemples de test de référence** : demande `45000` à `200` bps → commission `900`, net `44100` (glossaire E4) ; `10000` à `150` bps → `150` / `9850` (E5) — les valeurs sont **fournies par l'API (mocks MSW)**, le front ne les calcule pas.

## 6. États
| État | Rendu |
|---|---|
| Chargement de la page (`payout-eligibility`) | squelette `DescriptionList` + champ ; aucun « 0,000 » provisoire |
| Repos | carte d'information + champ vide + aide du seuil |
| Simulation en cours | bouton « Voir la simulation » `loading` ; la simulation précédente est grisée puis remplacée |
| Simulation affichée | §3.5 |
| Montant sous le minimum (`422 PAYOUT_BELOW_MINIMUM`, E14) | erreur **sous le champ** (icône + texte) `merchant.payout.error.belowMinimum` avec `details.minimumMillimes` ; pas de simulation ; focus sur le champ |
| Montant supérieur au disponible (`422 PAYOUT_EXCEEDS_AVAILABLE`) | erreur sous le champ `merchant.payout.error.exceedsAvailable` avec `details.availableMillimes` ; **c'est le propre solde virtuel du commerçant** (non le solde d'un client) ; validé par securite |
| Validation (`400 VALIDATION_FAILED`, montant vide, non entier, ≤ 0) | erreurs de champ (C.2), résumé, focus |
| Confirmation ouverte | modale B |
| Envoi en cours | bouton principal de la modale `loading`, modale non fermable, **même `Idempotency-Key`** ; **jamais d'« Annuler »** ; au-delà de `UI.slowLoadingMs` : bandeau « Traitement en cours… » + « Vérifier l'état de l'opération » (rejeu avec la même clé) |
| **Profil changé entre simulation et demande (`409 PAYOUT_QUOTE_CHANGED`)** | **bandeau persistant** (UX-07) dans la modale : titre « Le taux a changé depuis votre simulation », **ancienne et nouvelle simulation côte à côte** (deux `AmountBreakdown`, la nouvelle encadrée avec icône `RefreshCw` et libellé « Nouvelle simulation ») ; **aucune écriture n'a eu lieu** ; le bouton principal devient « Demander le virement avec le nouveau taux » et exige un **nouveau clic** (jamais de soumission automatique) ; **nouvelle `Idempotency-Key`** pour ce nouvel essai (refus métier mémorisé) |
| Conflit d'état (`409 RESOURCE_STATE_CONFLICT`) | bandeau persistant « Actualiser » (C.8.10) |
| Traitement concurrent (`409 IDEMPOTENCY_REQUEST_IN_PROGRESS`) | bandeau « Traitement en cours… », réessai après `Retry-After` |
| Succès | écran C (`ResultView`) |
| Erreur réseau / `5xx` | `StateView` `inline` dans la modale : « Réessayer » **avec la même clé** + référence + `common.state.error.safeRetry` |
| Trop de demandes (`429`) | `errors.rateLimited` + compte à rebours |
| Hors connexion | bandeau C.8.4 ; « Voir la simulation » et « Demander le virement » désactivés avec `common.state.offline.actionDisabled` ; la saisie est conservée |
| Session expirée | N.6 (saisie non conservée tant que la décision B n'est pas rendue ; jamais de resoumission automatique d'une opération financière) |
| Permission refusée / `canRequest = false` | action absente + raison ; accès direct → C.8.8 |
| Détail introuvable | `404` C.8.9 |
| Demande rejetée (`REJECTED`) | écran C avec badge `REJETEE` et frise ; motif seulement si l'API le fournit |
| Solde insuffisant au sens « payeur » | **sans objet** (réservé à l'employé) ; les cas ci-dessus sont des refus de **montant demandé** |

## 7. Données et contrat
| Élément affiché | Champ | Statut |
|---|---|---|
| Disponible, minimum, destination | `PayoutEligibility.availableMillimes`, `minPayoutMillimes` (`AmountMillimes`), `destination.accountHolderName`, `destination.ribMasked`, `canRequest`, `cannotRequestReasonKey?` (`GET /v1/merchant/payout-eligibility`) | **N** (CT-M-5) |
| Simulation | `PayoutQuote.quoteId`, `amountMillimes` (`PositiveAmountMillimes`), `rateBps` (`RateBps`), `commissionMillimes`, `netMillimes` (`GET /v1/payouts/quote?amountMillimes=`) | **N** (CT-M-6) |
| Demande | `POST /v1/payouts` `{ amountMillimes, quoteId }` + `Idempotency-Key` → `PayoutRequest { id, reference, status (PayoutRequestStatus), amountMillimes, rateBpsSnapshot, commissionMillimes, netMillimes, destination.ribMasked, createdAt }` | **N** (CT-M-7) |
| Profil changé | `409 PAYOUT_QUOTE_CHANGED` + `details.quote` (`PayoutQuote`) | **N** |
| Erreurs de montant | `422 PAYOUT_BELOW_MINIMUM` (`details.minimumMillimes`), `422 PAYOUT_EXCEEDS_AVAILABLE` (`details.availableMillimes`) | **N** |
| Statut et frise | `PayoutRequest.status` (**E** `PayoutRequestStatus` : `REQUESTED` → `DEMANDEE`, `CHECKED` → `CONTROLEE`, `SENT` → `ENVOYEE`, `EXECUTED` → `EXECUTEE`, `REJECTED` → `REJETEE`), `statusHistory[] { status, at }` | **E** (enum) / **N** (champ) |
| Suivi | `GET /v1/merchant/payouts/{id}` | **N** (CT-M-8) |
| Erreurs génériques | `Problem` : `VALIDATION_FAILED`, `FORBIDDEN`, `RESOURCE_STATE_CONFLICT`, `IDEMPOTENCY_REQUEST_IN_PROGRESS`, `IDEMPOTENCY_KEY_REUSED` (erreur d'intégration), `RATE_LIMITED` | **E** |
**Règle :** `commissionMillimes`, `netMillimes`, `rateBps` et `rateBpsSnapshot` sont **toujours lus de la réponse** ; la page de suivi affiche `rateBpsSnapshot` (le taux figé), jamais le taux courant du profil (E6).

## 8. RTL
Formulaire aligné `start` ; **tous les montants et le taux** en blocs LTR isolés (`48 250,000 TND`, `2 %`) ; l'opérateur « − » à l'intérieur du bloc LTR du libellé reste lisible (le libellé est en arabe, l'opérateur précède le libellé dans l'ordre logique) ; les deux simulations « ancienne / nouvelle » se lisent de droite à gauche ; frise d'étapes inversée ; chevron du lien de retour et flèche éventuelle en miroir ; RIB masqué en LTR isolé.

## 9. Accessibilité
- Lecture de la simulation : **un nœud par ligne** (« Montant demandé : 45,000 dinars tunisiens », « Commission déduite : 0,900 dinar tunisien », « Net à recevoir : 44,100 dinars tunisiens » dans cet ordre) ; l'opérateur visuel est `aria-hidden`. L'apparition de la simulation est annoncée (région `status`, poliment).
- Aide du seuil liée au champ par `aria-describedby` ; aperçu du montant (UX-05) poli ; erreurs `role="alert"`, icône + texte, focus sur le champ fautif.
- `ConfirmDialog` : `role="alertdialog"`, focus initial sur le titre, piège de focus, Échap ferme sauf pendant l'envoi, voile ne ferme pas, retour du focus au déclencheur ; ordre DOM = visuel (Annuler puis principal).
- Frise : `<ol>`, étape courante `aria-current="step"`, état en texte (« terminée », « en cours », « à venir »).
- Contrastes : `emerald-text/surface` 5,48:1 (net), `on-emerald/emerald` 6,69:1 (bouton), `danger-text/danger-soft` 5,30:1 ; l'issue n'est jamais portée par la couleur seule ; cibles ≥ `size.touch-target-min`.

## 10. Responsive
`size.viewport-min` : une colonne ; **barre d'action collante** en bas avec « Demander le virement » (écran de décision, N.2/UX-18) sans masquer le dernier champ ni le dernier message d'erreur ; modale en pleine largeur à pied collant ; simulation ancienne/nouvelle **empilées** ; `breakpoint.md` : carte centrée (`size.form-max-width`) ; `breakpoint.lg` : deux simulations côte à côte.

## 11. Sécurité (points pour `securite` et `ledger-auditor`)
La commission est calculée **uniquement** par le serveur (`GET /payouts/quote`, même fonction que le calcul réel, spec 03 §6) ; le front n'envoie que `amountMillimes` et `quoteId` ; le taux est figé côté serveur dans la demande (RG-1.6, CLAUDE.md règle 5) ; `Idempotency-Key` par intention, rejeu à l'identique après échec réseau, **nouvelle clé après refus métier** (C.8.3) ; aucune écriture en cas de `PAYOUT_QUOTE_CHANGED` ; RIB **masqué fourni masqué** par l'API et non modifiable ici ; pas de solde de client ; le caissier est refusé par le serveur (403) ; le « disponible » affiché est le solde virtuel **propre au commerçant** — à valider par securite au regard de la règle 9 (« solde complet ») ; tenant uniquement de la session ; aucune donnée sensible en URL (l'identifiant de demande est opaque) ; la modale n'est pas fermable pendant l'écriture.

## 12. Questions et décisions ouvertes
1. **[QUESTION] backend** CT-M-5 à CT-M-8 : `payout-eligibility` (disponible, minimum, destination), `quoteId` et sa durée de validité, codes `PAYOUT_BELOW_MINIMUM` / `PAYOUT_EXCEEDS_AVAILABLE` / `PAYOUT_QUOTE_CHANGED` et leurs `details`, `statusHistory`, motif de rejet affichable.
2. **En attente de décision de l'utilisateur** : libellé « À régler » (sans effet sur cet écran).
3. **Cadre non résolu des documents** : cahier §12.4 (« demande libre, automatique J+2, ou les deux ? ») ; cet écran couvre la **demande libre** (RG-6, COM-07). Le règlement automatique est affiché dans `commercant-reglements.md` sans action du commerçant.
4. **Confirmation de montant élevé** ou second facteur : non spécifié dans les documents ; aucun n'est inventé.
