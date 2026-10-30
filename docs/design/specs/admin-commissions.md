# Spec design – Administrateur › Commissions
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/commissions` · **Permissions :** `commissions.read` ; demande de changement : `commissions.request` (double validation) (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/commission-profiles`, `POST /v1/admin/commission-profiles/{id}/change-requests`.

## 1. Objectif
Voir les profils de commission (taux, commerçants rattachés) et demander un changement de taux soumis à seconde validation. **Action principale :** « Modifier le taux » par profil (demande, jamais d'effet immédiat).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; DataTable (nom, taux, commerçants, mise à jour), Modal de demande (nouveau taux en %, motif), bandeau « demande en attente ». Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
