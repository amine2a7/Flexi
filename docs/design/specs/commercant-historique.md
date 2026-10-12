# Spec design – Commerçant › Historique des transactions (liste et détail)
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD3 · **Auteur :** design · **Date :** 2026-10-12
**Routes :** `/merchant/collect/history` (liste, onglet « Historique » du module Encaissement, décision du 2026-10-09) et `/merchant/collect/history/{id}` (détail) · **Exigences couvertes :** COM-06 (filtres date, statut, montant, recherche, export, pagination), COM-05 (reçu : impression), RG-5, `decisions.md` (aucun solde ni motif de refus côté commerçant).
**Dépend de :** `_socle-ecrans.md`, `dev-composants.md` (NC.1 `DataTable`, NC.2 `FilterBar`, NC.14 `ExportDialog`, NC.13), `commercant-encaissement.md` (onglets). Contrat : `_besoins-contrat.md` §2 (CT-M-4), §1bis (CT-X-1, 2, 3).

## 1. Objectif
Retrouver une vente passée, vérifier son statut et en imprimer le reçu. **Action principale de la page : « Nouvel encaissement »** (en-tête, N.2).

## 2. Rôles et permissions
Propriétaire et caissier (permission « consulter l'historique », nom à confirmer) ; comptable : selon l'API (la liste peut être refusée → C.8.8). Chaque vente est limitée au tenant de la session ; une vente d'un autre commerçant répond `404`.

## 3. Structure
### Écran A – Liste
1. `h1` « Encaisser un paiement » (module) avec onglets `Encaisser` · `Historique` ; sous-titre de page « Historique des transactions ».
2. **Barre de filtres** (NC.2) : recherche (référence) · statut · période (`Du`/`Au`, `CalendarDate`) · montant minimum / maximum (`MoneyInput` ×2) · « Appliquer » · « Effacer les filtres » · pastilles. Bouton « Exporter » (`secondary`, NC.14) à `end`.
3. **Compteur** (si `page.count` présent) puis **`DataTable`** (NC.1) : colonnes
| Colonne | Type | Tri | Carte mobile |
|---|---|---|---|
| Date et heure | `date` | oui (défaut `-createdAt`) | meta |
| Référence | `identity` (lien vers le détail) | non | titre |
| Client (prénom + initiale, **si l'API le fournit**) | `text` | non | meta |
| Catégorie | `text` | non | meta |
| Montant (TND) | `amount` | oui | montant |
| Statut | `status` | non | badge |
4. Pagination « Précédent / Suivant » (tableau) ou « Charger plus » (cartes), A.8.
### Écran B – Détail d'une vente
`h1` « Transaction {référence} » (clé avec variable), lien « Retour à l'historique » (restitue filtres et curseur) · `DescriptionList` : Référence, Date et heure, Montant (`Amount` `lg`), Statut (`StatusBadge`), Catégorie, Client (prénom + initiale), Caissier, Point de vente · action principale **« Imprimer le reçu »** (si `CONFIRMED`/`SETTLED`). **Aucun solde, aucun motif de refus, aucune commission** (RG-1.5).

## 4. Composants et tokens
`Tabs` (NC.4) · `FilterBar`/pastilles (`size.chip-height`) · `DataTable` : en-tête `color.bg`/`color.text-muted`, ligne `size.table-row-height`, séparateur `color.border` · `StatusBadge` (table `status` des tokens) · `Amount` `sm` (tableau) / `md` (carte) / `lg` (détail) · `ExportDialog` · `Button` `accent` pour l'action principale de page (« Nouvel encaissement ») ; détail : `primary` pour « Imprimer le reçu » · `StateView` `inline`.
**Mapping de statut (valeur de l'API → badge)** : `INITIATED` → `INITIE` · `CONFIRMED` → `CONFIRME` · `SETTLED` → `REGLE` · `REFUSED` → `REFUSE` · `DISPUTED` → `EN_LITIGE` · autre → `INCONNU`. (Le badge « À régler » n'est utilisé que dans la liste des créances.)

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `merchant.history.title` | Historique des transactions |
| `merchant.history.action.new` | Nouvel encaissement |
| `merchant.history.filter.search` | Rechercher par référence |
| `merchant.history.filter.status` | Statut |
| `merchant.history.filter.amountMin` / `.amountMax` | Montant minimum (TND) · Montant maximum (TND) |
| `merchant.history.table.caption` | Liste des transactions |
| `merchant.history.col.date` / `.reference` / `.customer` / `.category` / `.amount` / `.status` | Date et heure · Référence · Client · Catégorie · Montant (TND) · Statut |
| `merchant.history.table.count` | {count, plural, one {# transaction} other {# transactions}} |
| `merchant.history.table.countLowerBound` | Plus de {count} transactions |
| `merchant.history.empty.title` | Aucune transaction |
| `merchant.history.empty.message` | Vos encaissements apparaîtront ici. |
| `merchant.history.empty.action` | Encaisser un paiement |
| `merchant.history.error.title` | Impossible de charger l'historique |
| `merchant.history.detail.title` | Transaction {reference} |
| `merchant.history.detail.back` | Retour à l'historique |
| `merchant.history.detail.field.reference` / `.date` / `.amount` / `.status` / `.category` / `.customer` / `.cashier` / `.outlet` | Référence · Date et heure · Montant · Statut · Catégorie · Client · Caissier · Point de vente |
| `merchant.history.detail.print` | Imprimer le reçu |
| `merchant.history.detail.refusedNote` | Cette transaction a été refusée. |
Filtres/état vide filtré/export : clés `common.filter.*`, `common.state.emptyFiltered.*`, `common.export.*`. Statuts : `status.<KEY>`.

## 6. États
| État | Rendu |
|---|---|
| Chargement | squelette `table-row` × `UI.skeletonRowsInitial` (tableau) ou cartes ; barre de filtres active |
| Vide (aucune vente) | `StateView` `inline` : illustration, `merchant.history.empty.*`, action « Encaisser un paiement » (masquée si la permission manque) |
| Vide après filtre | `common.state.emptyFiltered.*` + « Effacer les filtres » |
| Erreur | `StateView` `inline` « Réessayer » + référence ; filtres conservés |
| Hors connexion | bandeau C.8.4 ; données chargées conservées avec date ; filtres/tri/pagination/export désactivés avec raison |
| Session expirée | N.6 (retour avec filtres non personnels, `commun-session-expiree.md` §3.1) |
| Permission refusée | C.8.8 ; « Exporter » absent si non autorisé |
| Détail introuvable ou d'un autre tenant | `404` C.8.9 |
| Vente refusée | affichée avec le badge « Refusé » et `refusedNote`, **sans motif ni montant d'une raison** ; le montant demandé est celui de l'API |
| Export | `ExportDialog` : en préparation / prêt / expiré / échec (NC.14) |
| Solde insuffisant / plafond | sans objet |

## 7. Données et contrat
| Élément affiché | Champ | Statut |
|---|---|---|
| Liste | `GET /v1/merchant/sales` → `{ data: Sale[], page: PageInfo [+ count] }` | **N** (CT-M-4) |
| Date et heure | `Sale.createdAt` (`Timestamp`) → `formatDateTime` | **N** |
| Référence | `Sale.reference` | **N** |
| Client | `Sale.customerDisplay` (prénom + initiale) — **à confirmer** (non prévu par COM-04 hors écran de validation) | **N / ?** |
| Catégorie | `Sale.category` → `category.<CODE>` | **N** |
| Montant | `Sale.amountMillimes` (`AmountMillimes`) | **N** |
| Statut | `Sale.status` (`PaymentStatus`) | **E** (enum) |
| Caissier, point de vente | `Sale.cashierDisplayName?`, `Sale.outletName?` | **N** |
| Filtres | `q`, `status`, `fromDate`/`toDate` (`CalendarDate`, CT-X-2), `amountMinMillimes`, `amountMaxMillimes` | **N** |
| Tri | `sort` (liste blanche : `createdAt`, `amountMillimes`) | **E** (convention §7) |
| Compteur | `page.count { value, isLowerBound }` (`?withCount=true`) | **N** (CT-X-1) |
| Export | `POST /v1/exports` type `MERCHANT_SALES` (CT-X-3) | **N** |
| Détail | `GET /v1/merchant/sales/{id}` → `Sale` | **N** |
Les valeurs des filtres ne sont jamais renvoyées par le serveur ; les montants min/max sont saisis par `MoneyInput` (entiers en millimes).

## 8. RTL
Colonnes inversées (référence à droite) ; montants et références en blocs LTR isolés alignés `end` ; format de date de la locale, chiffres occidentaux ; `Du`/`Au` dans l'ordre de lecture ; chevrons et « Retour à l'historique » en miroir.

## 9. Accessibilité
`<table>` avec `<caption>`, `th scope`, `aria-sort` (NC.1) ; la référence est le lien vers le détail (nom accessible « Transaction {référence} ») ; statut = icône + texte ; compteur annoncé après un filtre ; `form role="search"` ; pastilles retirables au clavier ; tableaux → cartes sans défilement horizontal à 360 px ; contrastes AA des tokens (`text-muted/bg` 4,55:1) ; focus restitué sur la ligne d'origine au retour du détail ; ordre de focus : action principale → onglets → filtres → table → pagination.

## 10. Responsive
`size.viewport-min` : cartes (`radius.card-desktop`, titre = référence, montant `md` à `end`, badge sous le montant, légende date/catégorie), filtres dans le panneau « Filtres (n) », action principale sous le `h1` pleine largeur ; `breakpoint.md` : tableau ; `breakpoint.lg` : toutes les colonnes ; la colonne Catégorie est masquée entre `md` et `lg` si la largeur manque.

## 11. Sécurité (points pour `securite`)
Tenant uniquement de la session (jamais de `merchantId` en paramètre) ; recherche en texte libre non restituée après reconnexion (§3.1 de `commun-session-expiree.md`) ; aucune donnée sensible ni solde du client ; export par lien signé de courte durée, isolation par tenant, neutralisation des formules côté serveur ; le reçu imprimé n'expose pas l'identité complète du client.

## 12. Questions et décisions ouvertes
1. **[QUESTION] backend** CT-M-4 : présence du prénom + initiale du client dans l'historique ; champs caissier/point de vente ; filtres montant ; `fromDate`/`toDate` ; export. **`main`** si besoin : la visibilité du client dans l'historique n'est pas définie par le cahier.
2. Aucun libellé « À régler » n'est utilisé ici (décision en attente sans effet sur cet écran).
