# Spec design – Commerçant › Règlements et documents

**Statut :** rétro-spec de l'écran existant (étape 3, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/commercant/reglements` · **Permission :** `settlements.read` (gérant, comptable du commerce ; jamais le caissier)
**Dépend de :** `_socle-ecrans.md`, `dev-composants.md` (NC.1 tableau, NC.4 onglets), `fondations-composants.md` C.3, C.6. Contrat : `GET /v1/merchant/settlements`, `GET /v1/merchant/documents` (`documents.read`).

## 1. Objectif

Voir ce qui a été réellement viré (règlements J+2) et retrouver les documents mensuels (facture de commission, relevé, attestation). **Action principale :** aucune (consultation) ; téléchargement d'un document.

## 2. Structure

1. `PageHeader` : « Règlements et documents » · « Vos règlements J+2 et vos documents mensuels. »
2. `Tabs` : « Règlements » (par défaut) · « Documents ».
3. Onglet Règlements : `DataTable` (date de règlement, référence, nombre de paiements, brut, commission, net, statut) ; montants `Amount` alignés à `end`, valeurs **renvoyées par l'API** (jamais recalculées) ; statut `StatusBadge` (`A_REGLER`, `REGLE`).
4. Onglet Documents : `DataTable` (document, période, émis le, lien de téléchargement) ; type traduit (`merchant.settlements.docTypes.*`).

## 3. Textes (FR de référence, clés `merchant.settlements.*`)

`title`, `description`, `tabSettlements`, `tabDocuments`, `date`, `reference`, `count`, `gross`, `commission`, `net`, `status`, `emptyTitle` « Aucun règlement », `docType`, `period`, `issuedAt`, `docTypes.COMMISSION_INVOICE|STATEMENT|CERTIFICATE`, `emptyDocuments` « Aucun document ».

## 4. États

Chargement : squelette de tableau · Vide : `EmptyState` du tableau · Erreur : `ErrorState` avec « Réessayer » · 403 (caissier ouvrant l'URL) : page « Accès refusé » de la coquille.

## 5. RTL, accessibilité, responsive

Montants `dir="ltr"` isolés, colonnes à `end` ; légende de tableau (`caption`) ; sous `breakpoint.md`, le tableau passe en cartes (NC.1). Aucune logique d'argent dans le front : brut, commission et net viennent du règlement.

## 6. Questions ouvertes

1. Filtre par période (mois) : non prévu ; à confirmer avec l'utilisateur.
