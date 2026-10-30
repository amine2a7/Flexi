# Spec design – Administrateur › Journal d'audit
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/audit` · **Permissions :** `audit.read` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/audit-logs`.

## 1. Objectif
Retrouver qui a fait quoi et quand (actions sensibles, refus des quatre yeux). **Action principale :** aucune.

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; FilterBar (recherche), DataTable (date, acteur, action, objet), jamais de donnée sensible. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
