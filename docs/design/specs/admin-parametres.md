# Spec design – Administrateur › Paramétrage
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/parametres` · **Permissions :** `settings.read` ; demande : `settings.request` (double validation) (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/settings`, `PUT /v1/admin/settings`.

## 1. Objectif
Voir et demander la modification des paramètres de la plateforme (minimum de virement, validité des crédits, membres de la famille, frais de commande, types de crédit, destination des crédits expirés). **Action principale :** « Modifier » puis « Soumettre la demande » (seconde validation).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; Onglets, DescriptionList, formulaire, bandeau « demande en attente ». Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
