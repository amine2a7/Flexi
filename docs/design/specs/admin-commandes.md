# Spec design – Administrateur › Commandes de crédits (liste et détail)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/commandes, /admin/commandes/{id}` · **Permissions :** `creditOrders.read` ; confirmation : `orders.confirm` ; validation : `orders.validate` (seconde validation au-delà du seuil) (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/credit-orders`, `POST /v1/admin/credit-orders/{id}/confirm|refuse|validate|reject-proof`.

## 1. Objectif
Confirmer une commande, contrôler la preuve de virement et valider le crédit du portefeuille (quatre yeux au-delà du seuil). **Action principale :** selon l'état : « Confirmer » ou « Valider le paiement » ; jamais pour le premier validateur.

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; FilterBar (statut), DataTable, OrderSummaryCard, FileViewer de la preuve, alerte d'écart déclaré/attendu, Timeline. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
