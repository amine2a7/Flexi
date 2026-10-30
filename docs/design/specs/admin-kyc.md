# Spec design – Administrateur › Dossiers KYC (liste et dossier)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/admin/kyc, /admin/kyc/{id}` · **Permissions :** `kyc.read` ; documents : `kycDocuments.read` ; décision : `kyc.decide` (quatre yeux : jamais l'auteur du dossier) (décision C du 2026-10-23)
**Contrat :** `GET /v1/admin/kyc-files`, `GET /v1/admin/kyc-files/{id}/documents/{documentId}`, `POST /v1/admin/kyc-files/{id}/approve|reject`.

## 1. Objectif
Contrôler les pièces d'un compte et décider (approuver, refuser avec un motif visible par le titulaire). **Action principale :** « Approuver » / « Refuser » (dossier en attente, permission et quatre yeux).

## 2. Structure et composants
`PageHeader` (titre, description, action principale à `end`, filtrée par permission) ; DataTable, DescriptionList, FileViewer des pièces, ConfirmDialog, motif de refus obligatoire. Tableaux en cartes sous `breakpoint.md` ; montants `Amount` (gras, devise plus petite) ; badges de statut icône + texte.

## 3. États
Chargement (squelette), vide (message utile + action si permise), erreur (message + « Réessayer »), succès (bandeau ou toast selon l'action) ; page ouverte sans permission : « Accès refusé » de la coquille.

## 4. Textes, RTL, accessibilité
Clés i18n FR/AR/EN du namespace `admin.*` ; aucune chaîne en dur ; références et montants isolés `ltr` ; actions nommées par leur résultat ; dialogues avec focus initial et Échap.
