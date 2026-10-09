# Spec 06 – Application Employé (Flutter) et API de paiement
**Phase 5 · Cahier :** EMP-01 à EMP-08, RG-3, RG-5

## 1. Objectif
Permettre à l'employé et à sa famille de consulter leurs soldes et payer chez les commerçants par QR.

## 2. Règles
- Première connexion : changement de mot de passe, création du PIN, biométrie optionnelle.
- **QR employé** : `POST /qr` retourne un jeton signé (nonce, TTL 60 s, usage unique, lié à l'appareil). Rafraîchi automatiquement. Aucune donnée personnelle dans le QR.
- **Paiement** : scan du QR commerçant ou saisie du code à 8 chiffres ; confirmation par PIN/biométrie au-delà d'un seuil paramétrable (par défaut toujours).
- Contrôles : solde de la catégorie, lots non expirés (FEFO), plafonds jour/mois, limite du membre famille, commerçant actif et catégorie acceptée, antifraude.
- Famille : max paramétrable (4), limite individuelle optionnelle, suspension/suppression par l'employé ; les membres consomment le solde de l'employé.
- Notifications : crédits reçus, expiration J-30 et J-7, paiement effectué.
- Historique filtrable, reçu PDF.

## 3. API (extraits)
`GET /me/wallet` · `GET /me/transactions?cat&from&to&status` · `POST /qr` · `POST /payments/initiate` · `POST /payments/{id}/confirm` (Idempotency-Key) · `GET /merchants/nearby` · `GET/POST/PATCH /me/family` · `GET /me/notifications`.

## 4. Mobile (Flutter)
Architecture : `data` (API, stockage sécurisé), `domain` (modèles, cas d'usage), `presentation` (écrans, Riverpod). Thème généré depuis `design-tokens.json`. `flutter_secure_storage` pour les tokens, `local_auth` pour la biométrie, `mobile_scanner`, `qr_flutter`, pinning via `dio`, protection de capture d'écran sur QR/PIN. Argent en `int` millimes, formatage unique. Hors connexion : consultation du dernier solde, paiement indisponible avec message clair.

## 5. Écrans
Voir `design/figma-handoff.md` (Mobile Employé).

## 6. Tests
E3, E7, E8, E9, E12, E13, E16 ; QR lié à l'appareil (un autre appareil est refusé) ; PIN erroné ×5 ; double confirmation du même paiement (idempotence) ; Flutter : widget tests des écrans clés, test d'intégration du parcours de paiement.
