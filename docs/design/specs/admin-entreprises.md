# Spec design – Administrateur › Entreprises
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/entreprises` · **Permissions :** `accounts.read` ; création : `companies.manage` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/companies`, `POST /v1/admin/companies`.

## 1. Objectif
Trouver une entreprise cliente, en créer une (dossier KYB ouvert, invitation du responsable). **Action principale :** « Créer une entreprise ».

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; FilterBar, DataTable (nom, ville, création, statut), AccountForm. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
