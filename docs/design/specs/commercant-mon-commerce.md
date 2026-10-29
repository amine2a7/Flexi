# Spec design – Commerçant › Mon commerce

**Statut :** rétro-spec de l'écran existant (étape 3, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/commercant/mon-commerce` · **Permission :** `shop.read` (gérant, caissier, comptable du commerce)
**Dépend de :** `_socle-ecrans.md`, `fondations-composants.md` (DescriptionList, MaskedValue, badges de type de crédit). Contrat : `GET /v1/merchant/profile`.

## 1. Objectif

Consulter les informations du commerce, ses points de vente, son équipe et les types de crédit acceptés. **Lecture seule :** toute modification passe par l'administrateur FlexiPay (texte `changeHint`). **Action principale :** aucune.

## 2. Structure

1. `PageHeader` : « Mon commerce » · « Informations de votre commerce, points de vente et équipe. »
2. Carte identité (`DescriptionList`) : catégorie, ville, adresse, téléphone, compte bancaire **masqué** (`MaskedValue`, jamais l'IBAN complet ; le caissier ne voit que la valeur masquée), profil de commission (nom et taux renvoyés par l'API).
3. Carte « Types de crédit acceptés » : badges icône + texte, aide « Définis par FlexiPay. »
4. Carte « Points de vente » et carte « Équipe » (nom, sous-rôle traduit `subRole.*`).
5. Ligne `changeHint` : « Pour modifier ces informations, contactez l'administrateur FlexiPay. »

## 3. Textes (FR de référence, clés `merchant.shop.*`)

`title`, `description`, `category`, `city`, `address`, `phone`, `iban`, `commission`, `changeHint`, `pointsOfSale`, `staff`, `acceptedTypes`, `acceptedTypesHint`.

## 4. États

Chargement : `LoadingBlock` · Erreur : `ErrorState` avec « Réessayer » · Équipe ou points de vente vides : phrase neutre, jamais un bloc vide.

## 5. Sécurité, RTL, accessibilité

IBAN masqué partout (S11), téléphone affiché tel que renvoyé ; valeurs techniques `dir="ltr"` ; listes sémantiques (`ul`/`dl`).

## 6. Questions ouvertes

1. Modification du téléphone ou de l'adresse par le gérant (changement de RIB : double validation, décision A) : hors périmètre, à confirmer.
