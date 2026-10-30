# Spec design – Administrateur › Tableau de bord
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin` · **Permissions :** `dashboard.read` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/dashboard`.

## 1. Objectif
Superviser la plateforme : volume du jour, comptes, validations en attente, prochain règlement, flux crédité et payé par mois, répartition par type. **Action principale :** aucune ; raccourcis « Créer un commerçant » (si merchants.manage) et « Voir les validations ».

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; StatCard (montants mis en avant), BarChart, CreditTypeBreakdown, TodoPanel des files à traiter. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
