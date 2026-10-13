# Spec design – Commerçant › Encaissement : attente de confirmation, succès, refus
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD3 · **Auteur :** design · **Date :** 2026-10-12
**Route :** `/merchant/collect/payments/{id}` · **Exigences couvertes :** COM-04 (écran de validation : client « prénom + initiale », matricule masqué, catégorie, montant, compte à rebours ; résultat « accepté » ou « refusé » **sans solde ni motif**), COM-05 (reçu : impression ; envoi à confirmer), RG-5, critère d'acceptation 5 (QR/code utilisé deux fois ou âgé de plus de 60 s rejeté), `decisions.md` du 2026-10-09.
**Dépend de :** `commercant-encaissement.md`, `dev-composants.md` (NC.3, NC.8 `Countdown`, NC.9 `ResultView`, NC.11 `MaskedValue`), `fondations-composants.md` (C.8.11). Contrat : `_besoins-contrat.md` §2 (CT-M-2, 2b, 2c, 2d).

## 1. Objectif
Dire au commerçant, sans ambiguïté, où en est l'encaissement : **en attente du client**, **accepté** ou **refusé**. Une seule vue, trois états ; **action principale** : « Nouvel encaissement » (une fois l'issue connue) ou « Annuler l'encaissement » pendant l'attente (secondaire).

## 2. Rôles et permissions
Propriétaire et caissier (permission « encaisser »). L'URL contient un identifiant opaque de paiement ; l'API le vérifie pour le tenant de la session (`404` sinon, C.8.9). Un rechargement ou un retour arrière **reprend l'état réel** (jamais de nouvelle initiation).

## 3. Structure
### 3.1 État A – En attente de la confirmation du client (`status = INITIATED`)
`h1` « En attente du client » · **récapitulatif** (`DescriptionList`) : **Client** (prénom + initiale, ex. « Salma B. »), **Matricule** (`MaskedValue`), **Catégorie**, **Montant** (`Amount` `lg`) · **compte à rebours** (`Countdown`, NC.8) · texte « Le client doit confirmer le paiement dans son application. » · bouton secondaire **« Annuler l'encaissement »** (ouvre `ConfirmDialog` « Annuler cet encaissement ? »). **Aucun solde, aucun motif, aucun bouton « Confirmer » côté commerçant** (décision de séquence en attente, voir §12).
### 3.2 État B – Paiement accepté (`status = CONFIRMED`)
`ResultView` (NC.9) : pastille `CircleCheck`, `h1` « Paiement accepté », **montant brut** (`Amount` `lg`, `positive`), client (prénom + initiale), catégorie, date/heure (`formatDateTime`), **référence** copiable, statut `CONFIRME` · prochaine étape : « Le montant sera ajouté à vos créances. » (`merchant.collect.result.nextStep`) · actions : **« Nouvel encaissement »** (principale, `accent`), « Imprimer le reçu » (`secondary`), lien « Voir l'historique ». **Pas de commission affichée** (RG-1.5 : la commission n'apparaît qu'à la demande de virement).
### 3.3 État C – Paiement refusé (`PAYMENT_DECLINED`, ou `status = REFUSED`)
`StateView` `page` (C.8.11) : icône `CircleX`, **uniquement** « Paiement refusé. Le client peut vérifier son application. », action principale **« Nouvel encaissement »**. Aucun motif, aucun montant, aucun bouton « Réessayer ».
### 3.4 État D – Annulé par le commerçant
`StateView` `inline` : « Encaissement annulé. » + « Nouvel encaissement ». *(Existence d'un statut distinct à confirmer, CT-M-2c ; sinon l'écran affiche l'état C.)*
### 3.5 Délai dépassé
Quand `Countdown` atteint 0 : texte « Délai dépassé. » (`common.countdown.expired`), « Annuler l'encaissement » désactivé avec raison, l'écran **continue d'interroger l'API** et bascule dès que l'issue (en pratique C) est connue. Le front **ne décide jamais** de l'issue : il n'affiche « refusé » que si l'API le dit.

## 4. Composants et tokens
`ResultView` / `StateView` (C.8) · `Countdown` : texte `type-scale.label`, barre de hauteur `space.2`, piste `color.border`, remplissage `color.navy` · `DescriptionList` (NC.13) · `Amount` `lg` · `StatusBadge` · `CopyField` (référence) · `ConfirmDialog` (NC.3, variante `confirm`, largeur `size.modal-max-width`) · `Button` `accent`, `secondary`, `link` · succès : pastille `emerald-soft`/`emerald-text` ; refus : `danger-soft`/`danger-text` ; attente : `info-soft`/`info-text` (icône `Clock`).

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `merchant.collectResult.waiting.title` | En attente du client |
| `merchant.collectResult.waiting.message` | Le client doit confirmer le paiement dans son application. |
| `merchant.collectResult.customer` | Client |
| `merchant.collectResult.matricule` | Matricule |
| `merchant.collectResult.category` | Catégorie |
| `merchant.collectResult.amount` | Montant |
| `merchant.collectResult.cancel.label` | Annuler l'encaissement |
| `merchant.collectResult.cancel.confirm.title` | Annuler cet encaissement ? |
| `merchant.collectResult.cancel.confirm.consequence` | Le client ne pourra plus confirmer ce paiement. |
| `merchant.collectResult.cancel.confirm.action` | Annuler l'encaissement |
| `merchant.collectResult.cancel.confirm.keep` | Continuer l'encaissement |
| `merchant.collectResult.cancelled` | Encaissement annulé. |
| `merchant.collectResult.success.title` | Paiement accepté |
| `merchant.collectResult.success.nextStep` | Le montant sera ajouté à vos créances. |
| `merchant.collectResult.reference` | `common.result.reference` « Référence » |
| `merchant.collectResult.print` | Imprimer le reçu |
| `merchant.collectResult.history` | Voir l'historique |
| `merchant.collectResult.new` | Nouvel encaissement (= `errors.paymentDeclined.action`) |
| `errors.paymentDeclined.label` | Paiement refusé. Le client peut vérifier son application. |
| `common.countdown.remaining` / `.expired` | Temps restant : {seconds} s · Délai dépassé |
| `merchant.collectResult.a11y.waiting` | En attente de la confirmation du client. |
| `merchant.collectResult.a11y.accepted` | Paiement accepté : {amount} dinars tunisiens. |
Le libellé du bouton de confirmation d'annulation est le **résultat** (« Annuler l'encaissement »), et le bouton sûr « Continuer l'encaissement » porte le focus initial (variante `destructive`-like).

## 6. États
| État | Rendu |
|---|---|
| Chargement initial (reprise par URL) | squelette du récapitulatif ; **aucun succès ni échec présumé** |
| Attente | §3.1 ; interrogation de `GET /v1/merchant/payments/{id}` à la cadence fournie par l'API (`pollAfterSeconds`, sinon `UI.pollIntervalMs`) ou événement serveur |
| Accepté / Refusé / Annulé | §3.2–3.4 ; la page ne se ré-interroge plus |
| Délai dépassé | §3.5 |
| Annulation en cours | bouton du dialogue `loading`, dialogue non fermable ; `Idempotency-Key` ; si la réponse tarde : « Vérifier l'état de l'opération » (même clé) ; **jamais** d'annulation de l'annulation |
| Conflit (`409 RESOURCE_STATE_CONFLICT`, ex. confirmé par le client entre-temps) | bandeau persistant « Cette opération a déjà été traitée ou son état a changé. » + « Actualiser » (C.8.10) ; au rechargement l'état réel s'affiche |
| Erreur de lecture (réseau/serveur) | bandeau d'erreur non bloquant « Impossible de vérifier l'état » + « Réessayer » ; **on n'affiche pas « refusé » par défaut** ; l'attente continue |
| Hors connexion | bandeau C.8.4 ; l'écran conserve son état, indique `common.state.offline.lastUpdate` ; reprise automatique au retour de la connexion |
| Session expirée | N.6 ; au retour, `returnTo` ramène sur cette page, qui reprend l'état réel |
| Introuvable / autre tenant | `404` C.8.9 |
| Permission refusée | C.8.8 |
| Solde insuffisant / plafond | sans objet (jamais côté commerçant) |

## 7. Données et contrat
| Élément affiché | Champ | Statut |
|---|---|---|
| Client | `MerchantPayment.customer.firstName`, `customer.lastInitial` | **N** (CT-M-2b) |
| Matricule | `MerchantPayment.maskedMatricule` (déjà masqué par l'API) | **N** |
| Catégorie | `MerchantPayment.category` → clé `category.<CODE>` | **N** |
| Montant | `MerchantPayment.amountMillimes` (`AmountMillimes`) | **N** |
| Statut | `MerchantPayment.status` (`PaymentStatus` : `INITIATED` → attente, `CONFIRMED` → `CONFIRME`, `REFUSED` → `REFUSE`) | **E** (enum) / **N** (champ) |
| Compte à rebours | `MerchantPayment.expiresAt` (`Timestamp`), `serverTime` (`Timestamp`) | **N** (CT-X-5) |
| Référence | `MerchantPayment.reference` | **N** |
| Date | `MerchantPayment.createdAt` / `confirmedAt` | **N** |
| Annulation | `POST /v1/merchant/payments/{id}/cancel` + `Idempotency-Key` | **N** (CT-M-2c) |
| Erreurs | `PAYMENT_DECLINED`, `RESOURCE_STATE_CONFLICT`, `NOT_FOUND`, `IDEMPOTENCY_REQUEST_IN_PROGRESS` | **E** |
**Interdits :** aucun champ de solde, de motif de refus, de plafond ni d'identité complète du client dans la réponse ; si l'API en renvoyait un, le front ne l'afficherait pas.

## 8. RTL
Récapitulatif aligné `start` ; prénom + initiale selon la langue du nom (LTR isolé si latin) ; montant, référence, matricule masqué en blocs LTR isolés ; barre du compte à rebours qui se vide vers `start` ; icônes de statut non directionnelles.

## 9. Accessibilité
Le focus va au `h1` à chaque changement d'état (`tabindex="-1"`) ; l'état est annoncé : attente `role="status"`, accepté `role="status"`, **refusé `role="alert"`** ; `Countdown` `role="timer"` annoncé au plus toutes les `UI.liveAnnounceCountdownMs` ; nom lecteur d'écran du montant « Paiement accepté : 45,000 dinars tunisiens » ; l'issue n'est jamais portée par la couleur seule (icône + titre + texte) ; contrastes `emerald-text/surface` 5,48:1, `danger-text/danger-soft` 5,30:1 ; cibles ≥ `size.touch-target-min` ; ordre de focus : `h1` → récapitulatif → action principale → actions secondaires.

## 10. Responsive
`size.viewport-min` : colonne unique, `Amount` `lg` ; actions empilées, principale en premier et collante en bas pour l'écran de décision (N.2) ; le compte à rebours reste visible en haut du récapitulatif ; ≥ `breakpoint.md` : carte centrée (`size.form-max-width`). **Impression du reçu :** feuille de style d'impression mêmes tokens, noir sur blanc, sans coquille ; contenu : nom du commerce (`MerchantProfile.tradeName`), date, montant, catégorie, référence, statut ; **ni commission, ni solde**.

## 11. Sécurité (points pour `securite`)
Aucun solde ni motif jamais ; le résultat affiché provient uniquement de l'API (pas d'optimisme) ; l'identifiant de paiement dans l'URL est opaque et vérifié par tenant ; polling avec limitation (cadence serveur) ; `Idempotency-Key` sur l'annulation ; le reçu imprimé ne contient pas d'identité complète du client ; pas de mise en cache de la page (`no-store`).

## 12. Questions et décisions ouvertes
1. **[DÉCISION] `main`** — séquence du paiement (voir `commercant-encaissement.md` §12.1) ; si le cahier COM-04 implique une **confirmation côté commerçant**, l'état A gagne un bouton « Confirmer l'encaissement » (principal) à côté de « Annuler » ; la structure de l'écran le permet sans autre changement.
2. **[QUESTION] backend** : statut d'annulation, polling/SSE, `serverTime`, **envoi du reçu par e-mail/SMS** (COM-05 : destinataire non défini — le web spécifie l'impression seulement ; l'envoi n'est pas inventé).
