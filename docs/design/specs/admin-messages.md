# Spec design – Administrateur › Messages de contact (liste et détail)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/messages, /admin/messages/{id}` · **Permissions :** `messages.read` ; traitement : `messages.handle` (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/contact-messages`, `POST /v1/admin/contact-messages/{id}/handle`.

## 1. Objectif
Traiter les demandes reçues par le formulaire de contact (répondre par e-mail, marquer traité avec une note). **Action principale :** « Marquer comme traité » ; « Répondre » (lien e-mail).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; DataTable, DescriptionList de l'expéditeur, ConfirmDialog avec note. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
