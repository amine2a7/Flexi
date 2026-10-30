# Spec design – Administrateur › Validations (quatre yeux)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/validations` · **Permissions :** `approvals.read` ; décision : `approvals.decide` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/approvals`, `POST /v1/admin/approvals/{id}/approve|reject`.

## 1. Objectif
Traiter les demandes à seconde validation (taux de commission, paramétrage) : l'initiateur ne peut jamais approuver. **Action principale :** « Approuver » / « Refuser » (absents pour sa propre demande, mention « Votre demande »).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; FilterBar (statut), DataTable (objet, ancien et nouveau, initiateur, date), ConfirmDialog, motif de refus. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
