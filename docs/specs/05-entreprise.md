# Spec 05 – Espace Entreprise
**Phase 4 · Cahier :** ENT-01 à ENT-10, RG-2.2, RG-3

## 1. Objectif
Commander des crédits, créer et gérer les employés, attribuer des crédits, suivre la consommation.

## 2. Règles
- Commande : catégorie(s), montant, date d'attribution, validité. Total = montant + frais (profil COMPANY). Statuts : `CREEE` → `PAYEE` → `RAPPROCHEE` → `CREDITEE`.
- Le wallet n'est crédité qu'après rapprochement bancaire validé par Finance (double validation au-delà du seuil).
- Employés : création manuelle ou import CSV (`nom,prenom,email,telephone,matricule`). Taille max 5 000 lignes / 5 Mo. Détection des doublons (matricule, email, téléphone) avec aperçu avant import. Neutralisation des formules (`=`, `+`, `-`, `@` en début de cellule).
- Mot de passe temporaire par employé (spec 01). Désactivation d'un employé : plus de paiement possible, crédits restant selon règle contractuelle.
- Attribution : unitaire, par lots, récurrente. Débit du wallet entreprise, création de lots avec expiration. Impossible d'attribuer plus que le solde. Annulation d'une attribution possible seulement pour la part non consommée.
- Reporting : par employé, département, commerçant, période, expirés ; exports PDF/Excel (limités en taille, asynchrones).

## 3. Données
`orders`, `order_lines`, `invoices`, `payment_proofs`, `employees` (company_id, matricule, department, status), `family_members`, `allocations`, `allocation_batches`, `import_jobs`.

## 4. API (extraits)
`POST /company/orders` · `GET /company/orders` · `POST /company/employees` · `POST /company/employees/import` (aperçu puis confirmation) · `POST /company/employees/{id}/resend-credentials` · `POST /company/allocations` · `GET /company/reports/{type}`.

## 5. Tests
E1, E2 ; import avec doublons ; formule injectée neutralisée ; attribution > solde refusée ; entreprise A n'accède pas aux employés de B ; 250 employés attribués de façon atomique (tout ou rien) ; rôle lecture seule ne peut pas attribuer.
