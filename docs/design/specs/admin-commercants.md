# Spec design – Administrateur › Commerçants (liste et fiche)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/commercants, /admin/commercants/{id}` · **Permissions :** `accounts.read` ; création et types acceptés : `merchants.manage` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/merchants`, `POST /v1/admin/merchants`, `PUT /v1/admin/merchants/{id}/credit-types`.

## 1. Objectif
Trouver un commerçant, voir son dossier, créer un commerçant avec son profil de commission, régler les types de crédit acceptés. **Action principale :** « Créer un commerçant » (liste) ; « Enregistrer les types » (fiche).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; FilterBar (recherche, statut), DataTable (nom, catégorie, types, ville, profil, création, statut), AccountForm (profil de commission obligatoire), CreditTypeCheckboxes. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
