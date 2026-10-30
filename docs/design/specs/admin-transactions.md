# Spec design – Administrateur › Transactions
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/transactions` · **Permissions :** `transactions.read` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/transactions`.

## 1. Objectif
Rechercher un paiement de la plateforme (référence, commerçant, type, montant, date, statut). **Action principale :** aucune (consultation).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; FilterBar (recherche, statut, type de crédit), DataTable, montants mis en avant. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
