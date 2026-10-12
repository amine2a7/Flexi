# Spec design – Commerçant › Tableau de bord
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD3 · **Auteur :** design · **Date :** 2026-10-12
**Route :** `/merchant` · **Module :** `nav.merchant.dashboard` · **Exigences couvertes :** COM-01 (ventes du jour, en attente, réglé, commission, panier moyen, prochain règlement avec net estimé), RG-1.5, cahier §5.6, §5.8 (montants lisibles en moins de 2 s).
**Dépend de :** `_socle-ecrans.md`, `fondations-composants.md` (C.4.5 KPI, C.6 `Amount`), `dev-composants.md`. Contrat : `_besoins-contrat.md` §2 (CT-M-1).

## 1. Objectif
Donner au commerçant, en moins de 2 secondes, l'état de son activité (ventes du jour), de ce qu'on lui doit encore et de son prochain règlement. **Action principale unique : « Nouvel encaissement »** (propriétaire, caissier) ; pour un comptable (sans permission d'encaisser) elle devient « Demander un virement ».

## 2. Rôles et permissions
`MERCHANT` : propriétaire (tout), caissier (encaisser, historique), comptable (règlements et factures) — spec 07 §2. **Le front n'affiche une carte que si le champ correspondant est présent dans la réponse** : l'API omet les agrégats qu'un sous-rôle n'a pas le droit de voir. *Absent* (non autorisé) = la carte n'existe pas ; *null* (autorisé mais indisponible) = « — » + `common.amount.unavailable`.

## 3. Structure
1. `h1` « Tableau de bord » + sous-titre **période** « Période : du {fromDate} au {toDate} » (pour les agrégats « réglé », « commission », « panier moyen ») ; action principale à `end` de l'en-tête (N.2).
2. **Grille de cartes KPI** (C.4.5), ordre de lecture :
   1. **Ventes du jour** (`Amount` `lg`, + nombre de ventes en légende).
   2. **En attente de règlement** (`Amount` `lg`, lien « Voir les créances »).
   3. **Prochain règlement** : date d'échéance (`CalendarDate`) + montant brut ; **net estimé** seulement si l'API le fournit (voir §12 `[DÉCISION]`) ; lien « Voir les règlements ».
   4. **Réglé** (période).
   5. **Commission** (période) — **carte affichée seulement si `commissionMillimes` est présent** (voir §12).
   6. **Panier moyen** (période).
3. Aucun graphique dans le MVP (aucune exigence ; pas de donnée inventée).

## 4. Composants et tokens
`Card` KPI (`radius.card-desktop`, `space.5`, `shadow.card`, bordure `color.border`) · libellé `type-scale.caption` `color.text-muted` · valeur `Amount` `lg` (`type-scale.amount`, devise `type-scale.currency`) tonalité `neutral` (`positive` n'est pas utilisée ici : un chiffre d'affaires n'est pas un « crédit disponible ») · légende `type-scale.caption` · lien « Voir … » `Button` `link` (≥ `size.touch-target-min`) · grille 1 colonne → 2 colonnes dès `breakpoint.md` → 3 colonnes dès `breakpoint.lg` (espacement `space.4`) · `Button` `accent`/`primary` · `Skeleton` `kpi`.
Le **zéro réel** s'affiche `0,000` avec une aide « Aucune vente aujourd'hui » (UX-11).

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `merchant.dashboard.title` | Tableau de bord |
| `merchant.dashboard.period` | Période : du {fromDate} au {toDate} |
| `merchant.dashboard.action.collect` | Nouvel encaissement |
| `merchant.dashboard.action.payout` | Demander un virement |
| `merchant.dashboard.kpi.salesToday.label` | Ventes du jour |
| `merchant.dashboard.kpi.salesToday.count` | {count, plural, =0 {Aucune vente aujourd'hui} one {# vente} other {# ventes}} |
| `merchant.dashboard.kpi.pending.label` | En attente de règlement (libellé provisoire : voir §12) |
| `merchant.dashboard.kpi.pending.link` | Voir les créances |
| `merchant.dashboard.kpi.nextSettlement.label` | Prochain règlement |
| `merchant.dashboard.kpi.nextSettlement.dueOn` | Prévu le {date} |
| `merchant.dashboard.kpi.nextSettlement.net` | Net estimé |
| `merchant.dashboard.kpi.nextSettlement.link` | Voir les règlements |
| `merchant.dashboard.kpi.nextSettlement.none` | Aucun règlement prévu pour le moment. |
| `merchant.dashboard.kpi.settled.label` | Réglé |
| `merchant.dashboard.kpi.commission.label` | Commission |
| `merchant.dashboard.kpi.averageBasket.label` | Panier moyen |
| `merchant.dashboard.empty.title` | Bienvenue sur FlexiPay |
| `merchant.dashboard.empty.message` | Vos ventes apparaîtront ici dès votre premier encaissement. |
| `merchant.dashboard.empty.action` | Encaisser un paiement |
| `merchant.dashboard.error.title` | Impossible d'afficher votre tableau de bord |
Les erreurs utilisent `errors.*` (C.9). Aucun texte juridique.

## 6. États
| État | Rendu |
|---|---|
| Chargement | squelette `kpi` ×6, mêmes dimensions que les cartes ; pas de « 0,000 » provisoire |
| Normal | cartes selon les champs présents |
| Vide (nouveau commerçant : toutes valeurs à zéro et aucune vente) | `StateView` `inline` en tête (`merchant.dashboard.empty.*`) **et** cartes à `0,000` ; si l'API n'indique pas explicitement « première utilisation », l'écran affiche seulement les `0,000` (pas de règle de détection côté front) |
| Erreur | `StateView` `inline` « Réessayer » + référence ; les liens de navigation restent utilisables |
| Hors connexion | bandeau C.8.4 ; dernières valeurs conservées avec `common.state.offline.lastUpdate` (jamais présentées comme actuelles) ; action « Nouvel encaissement » désactivée avec `common.state.offline.actionDisabled` |
| Session expirée | N.6 |
| Permission refusée | cartes absentes (voir §2) ; si aucune carte et aucune action : C.8.8 |
| Compte non validé (`PENDING_KYC`, `SUSPENDED`…) | l'API refuse l'encaissement (spec 04 §2) ; le front affiche seulement le message de l'API (`errors.forbidden`) sur l'action ; **aucune règle d'éligibilité n'est codée** |
| Solde insuffisant / plafond | sans objet (réservé au payeur) |

## 7. Données et contrat
| Élément affiché | Champ du contrat | Statut |
|---|---|---|
| Ventes du jour | `MerchantDashboard.salesTodayMillimes` (`AmountMillimes`) | **N** (CT-M-1) |
| Nombre de ventes | `salesTodayCount` (entier) | **N** |
| En attente de règlement | `pendingSettlementMillimes` | **N** |
| Prochain règlement | `nextSettlement.dueOn` (`CalendarDate`), `nextSettlement.grossMillimes`, `nextSettlement.estimatedNetMillimes?`, `nextSettlement.rateBps?` (`RateBps`) | **N** |
| Réglé / Commission / Panier moyen | `settledMillimes`, `commissionMillimes?`, `averageBasketMillimes` | **N** |
| Période | `period.fromDate`, `period.toDate` (`CalendarDate`) | **N** |
Endpoint : `GET /v1/merchant/dashboard`. Les valeurs sont **toutes calculées par le serveur** ; le front n'additionne ni ne divise rien (panier moyen compris).

## 8. RTL
Grille inversée automatiquement ; libellés alignés `start` ; montants en bloc LTR isolé, devise après le nombre ; dates formatées par la locale en chiffres occidentaux ; aucun graphique ; lien « Voir … » avec chevron miroir.

## 9. Accessibilité
`h1` + chaque carte est une `<section aria-labelledby>` (libellé de la carte) ; chaque valeur est un seul nœud lecteur d'écran (« Ventes du jour : 48 250,000 dinars tunisiens ») ; liens avec nom explicite (« Voir les créances ») ; ordre de focus : action principale → cartes dans l'ordre de lecture → liens ; contrastes `text/surface` 17,85:1, `text-muted/surface` 4,76:1 ; aucune information par la couleur seule ; cibles ≥ `size.touch-target-min`.

## 10. Responsive
`size.viewport-min` : 1 colonne, action principale sous le `h1` en pleine largeur (N.2/UX-18) ; `breakpoint.md` : 2 colonnes ; `breakpoint.lg` : 3 colonnes ; largeur max `size.desktop-max-width`. Les montants ne sont jamais tronqués (`Amount` réduit d'un cran `lg → md` si la carte est étroite).

## 11. Sécurité
Aucun solde du client ; aucune donnée d'un autre commerçant (tenant uniquement de la session) ; agrégats selon la permission côté serveur ; aucune donnée sensible en URL ; valeurs hors connexion marquées « Dernière mise à jour » et stockées en mémoire seulement (pas de `localStorage` sans validation de `securite`).

## 12. Questions et décisions ouvertes
1. **[DÉCISION] `main`** : COM-01 liste « commission » et « prochain règlement avec net estimé », alors que la spec 07 §2 et RG-1.5 disent que la commission « n'est visible et prélevée qu'à la demande de virement ». Proposition de design : la carte « Commission » (commission déjà prélevée sur des virements exécutés) et le « net estimé » ne sont affichés que si l'API les fournit ; sinon absents. **Aucun taux ni commission n'est calculé dans le front.**
2. **En attente de décision de l'utilisateur** : libellé de l'état « à régler » vu par le commerçant (recommandation ux : « En attente de règlement »). Le libellé de la carte est provisoire.
3. **[QUESTION] backend** CT-M-1 : période des agrégats, champs facultatifs par sous-rôle, distinction *absent* / *null*.
