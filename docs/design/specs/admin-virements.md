# Spec design – Administrateur › Virements commerçants (liste et détail)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/virements, /admin/virements/{id}` · **Permissions :** `adminPayouts.read` ; décision : `payouts.decide` (jamais le demandeur ni le créateur du commerçant) (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/payout-requests`, `POST /v1/admin/payout-requests/{id}/approve|reject`.

## 1. Objectif
Contrôler une demande de virement (brut, commission au taux figé, net, RIB masqué) et l'approuver pour le prochain lot J+2 ou la rejeter avec un motif. **Action principale :** « Approuver » / « Rejeter ».

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; DataTable, AmountBreakdown (brut, commission, net), ConfirmDialog, motif de rejet. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
