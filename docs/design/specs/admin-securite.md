# Spec design – Administrateur › Sécurité & conformité
**Statut :** mise à jour le 2026-11-02 (API réelle) · **Auteur :** lead · **Routes :** `/admin/securite`, `/admin/securite/litiges/[disputeId]` · **Permissions :** `risk.read` et `alerts.manage` pour les alertes (super-admin, Opérations) ; `disputes.read` pour les litiges (+ Finance, décision du 2026-11-02) ; `disputes.manage` pour instruire (super-admin, Opérations)
**Contrat :** 0.8.0, routes `/v1/admin/fraud-alerts` et `/v1/admin/disputes`.

## 1. Objectif
Traiter les alertes de fraude (à examiner → en cours → fermée avec motif) et instruire les litiges. Opérations ouvre un litige depuis Transactions, ajoute des notes, rejette ou accepte ; Finance lit le dossier et approuve le remboursement dans Validations (double validation).
## 2. Structure
`PageHeader` ; `Tabs` « Alertes de fraude » / « Litiges » (Finance : seulement la liste des litiges) ; `DataTable` par onglet (alerte : type, concerné, gravité, date, statut, traité par, actions ; litige : référence vers le dossier, paiement, commerçant, montant mis en avant, motif, date, statut). Dossier : montant, statut, informations, décision (`ReasonDialog`), notes (`Timeline`), bandeau « En attente de la seconde validation ». Gravité et statut en badges (icône + texte, couleurs de la charte : élevée = danger, moyenne = attention, faible = information).
## 3. États
Squelette, vide (« Aucune alerte », « Aucun litige »), erreur + réessayer ; sans `disputes.read` : « Accès refusé ».
