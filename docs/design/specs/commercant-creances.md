# Spec design – Commerçant › Créances (paiements encaissés non encore réglés)
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD3 · **Auteur :** design · **Date :** 2026-10-12
**Route :** `/merchant/settlements/receivables` (onglet « Créances » du module `nav.merchant.settlements` « Règlements & factures ») · **Exigences couvertes :** COM-01 (« en attente (J+2) »), COM-08 (suivi des règlements), glossaire (créance = paiements encaissés non encore réglés), RG-1.5 (la commission n'est calculée qu'à la demande de virement), RG-7 et E15 (litige exclu d'un règlement), cahier §9 critère 7.
**Dépend de :** `_socle-ecrans.md`, `dev-composants.md` (NC.1, NC.2, NC.4), `fondations-composants.md` C.3. Contrat : `_besoins-contrat.md` §2 (CT-M-3).

## 1. Objectif
Montrer au commerçant **ce qui lui reste à recevoir** et **quand**, paiement par paiement. **Action principale : « Demander un virement »** (en-tête, N.2), pour les rôles autorisés.

## 2. Rôles et permissions
Propriétaire et comptable (permission « consulter les règlements », nom à confirmer). Le caissier n'a pas ce module (retiré de la navigation, spec 07 §2). L'action « Demander un virement » n'apparaît que si la permission « demander un virement » est présente (le caissier ne peut pas, test spec 07).

## 3. Structure
1. `h1` « Règlements et factures » ; onglets (NC.4) : **Créances** · **Règlements** · **Documents** ; action principale « Demander un virement ».
2. **Bandeau d'information** (`Banner` info) : « Ces paiements seront réglés à leur échéance. La commission est calculée uniquement lorsque vous demandez un virement. » (RG-1.5).
3. **Résumé** (2 cartes KPI C.4.5) : **Montant en attente de règlement** (`pendingMillimes`) ; **Montant en litige** (`inDisputeMillimes`, affiché seulement si présent), avec la note « Les paiements en litige sont exclus des règlements. » (E15).
4. **Filtres** (NC.2) : période (échéance), statut (« En attente de règlement », « En litige » — libellés : voir §12), recherche par référence.
5. **`DataTable`** (NC.1) : Date de la vente · Référence (lien vers la transaction `commercant-historique.md` détail) · Montant brut (TND) · Échéance de règlement (`CalendarDate`) · Statut.

## 4. Composants et tokens
`Tabs` · `Banner` info (`color.info-soft`/`info-text`) · `Card` KPI · `DataTable` · `StatusBadge` : `A_REGLER` (`info-soft`/`info-text`, `CalendarClock`) pour `CONFIRMED`, `EN_LITIGE` (`danger-soft`/`danger-text`, `Scale`) pour `DISPUTED` — **présentation d'une valeur fournie par le serveur** (fondations C.3, mise à jour du 2026-10-12) · `Amount` `sm`/`lg` · `FilterBar`.

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `merchant.receivables.title` | `merchant.settlements.title` « Règlements et factures » |
| `merchant.settlements.tabs.receivables` / `.payouts` / `.documents` | Créances · Règlements · Documents |
| `merchant.settlements.action.payout` | Demander un virement |
| `merchant.receivables.banner` | Ces paiements seront réglés à leur échéance. La commission est calculée uniquement lorsque vous demandez un virement. |
| `merchant.receivables.kpi.pending` | Montant en attente de règlement |
| `merchant.receivables.kpi.dispute` | Montant en litige |
| `merchant.receivables.kpi.disputeNote` | Les paiements en litige sont exclus des règlements. |
| `merchant.receivables.col.date` / `.reference` / `.amount` / `.dueOn` / `.status` | Date de la vente · Référence · Montant brut (TND) · Échéance de règlement · Statut |
| `merchant.receivables.table.caption` | Liste des créances |
| `merchant.receivables.table.count` / `.countLowerBound` | {count, plural, one {# créance} other {# créances}} · Plus de {count} créances |
| `merchant.receivables.empty.title` | Aucune créance en attente |
| `merchant.receivables.empty.message` | Vos paiements encaissés apparaîtront ici jusqu'à leur règlement. |
| `merchant.receivables.empty.action` | Voir l'historique |
| `status.A_REGLER` | À régler (**libellé en attente de décision de l'utilisateur** ; recommandation ux : « En attente de règlement ») |
| `status.EN_LITIGE` | En litige |

## 6. États
| État | Rendu |
|---|---|
| Chargement | squelette KPI ×2 + `table-row` |
| Vide | `StateView` `inline` (`merchant.receivables.empty.*`) ; KPI à `0,000` |
| Vide après filtre | `common.state.emptyFiltered.*` |
| Erreur | `StateView` `inline` « Réessayer » + référence |
| Hors connexion | bandeau C.8.4 ; données datées ; filtres désactivés avec raison ; « Demander un virement » désactivé avec raison |
| Session expirée | N.6 |
| Permission refusée | C.8.8 ; action absente |
| Créance en litige | badge `EN_LITIGE` + note ; jamais incluse dans un virement (règle côté serveur) |
| Solde insuffisant / plafond | sans objet |

## 7. Données et contrat
| Élément | Champ | Statut |
|---|---|---|
| Liste | `GET /v1/merchant/receivables` → `{ data: Receivable[], page: PageInfo [+ count] }` | **N** (CT-M-3) |
| Date, référence, montant | `Receivable.createdAt` (`Timestamp`), `reference`, `amountMillimes` (`AmountMillimes`) | **N** |
| Échéance | `Receivable.dueOn` (`CalendarDate`, `Africa/Tunis`, calculée par le serveur : le front ne calcule jamais le J+2) | **N** |
| Statut | `Receivable.status` : `PaymentStatus` `CONFIRMED` → badge `A_REGLER`, `DISPUTED` → `EN_LITIGE` | **E** (enum) |
| Résumé | `summary.pendingMillimes`, `summary.inDisputeMillimes?` | **N** |
| Filtres | `status`, `fromDate`/`toDate` (CT-X-2), `q` | **N** |

## 8. RTL
Comme `commercant-historique.md` ; échéance et dates en chiffres occidentaux selon la locale ; montants en bloc LTR isolé ; icônes `CalendarClock`, `Scale` non directionnelles.

## 9. Accessibilité
`<table>`/`caption`/`aria-sort` ; badge = icône + texte ; KPI : un nœud lecteur d'écran par carte (« Montant en attente de règlement : 12 500,000 dinars tunisiens ») ; le bandeau est `role="status"` ; échéance en texte (jamais une couleur d'alerte seule) ; contrastes AA des tokens ; ordre de focus : action principale → onglets → filtres → table.

## 10. Responsive
`size.viewport-min` : KPI empilés, cartes (titre = référence, montant `md` à `end`, badge sous le montant, légende « Échéance : {date} ») ; `breakpoint.md` : tableau ; action principale sous le `h1` en pleine largeur (N.2).

## 11. Sécurité
Tenant de la session uniquement ; aucune donnée d'un autre commerçant ; aucun solde de client ; les montants viennent du serveur ; aucun motif de litige exposé au commerçant au-delà du statut.

## 12. Questions et décisions ouvertes
1. **En attente de décision de l'utilisateur** : libellé « À régler » vu par le commerçant (ux UX-10 : « En attente de règlement »). Aucune modification de `status.A_REGLER` avant la décision.
2. **[QUESTION] backend** CT-M-3 : confirmer que « à régler » = `CONFIRMED` dans cette liste (réponse du 2026-10-12) et que `DISPUTED` y figure ; présence de `summary`.
