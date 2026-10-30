# Spec design – Administrateur › Règlements (lots J+2)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/reglements, /admin/reglements/{id}` · **Permissions :** `adminPayouts.read` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/settlements`, `GET /v1/admin/settlements/{id}`.

## 1. Objectif
Suivre les lots de règlement : date, nombre de virements, total net, statut, détail des virements d'un lot. **Action principale :** aucune (le lot part par le job planifié).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; DataTable, StatusBadge (À régler, Réglé), détail du lot. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
