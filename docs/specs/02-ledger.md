# Spec 02 – Ledger, wallets et crédits
**Phase 2 · Cahier :** RG-3, RG-4, section 3 (circuit financier), SEC-P*

## 1. Objectif
Gérer tout l'argent par un ledger en partie double, immuable, en millimes, avec lots de crédits expirants.

## 2. Comptes
| Code | Nature | Description |
|---|---|---|
| `BANK_ESCROW` | actif | Compte de cantonnement (fonds clients) |
| `BANK_PAYMENT` | actif | Compte de paiement (virements sortants) |
| `COMPANY_WALLET:{id}` | passif | Crédits disponibles de l'entreprise |
| `EMPLOYEE_WALLET:{id}` | passif | Crédits de l'employé (famille incluse) |
| `MERCHANT_WALLET:{id}` | passif | Créances du commerçant (brut) |
| `PAYOUT_PAYABLE` | passif | Virements demandés, non exécutés |
| `REVENUE_COMPANY_FEES` | produit | Frais de service entreprise |
| `REVENUE_MERCHANT_COMMISSION` | produit | Commissions commerçant |
| `REVENUE_EXPIRED` | produit | Crédits expirés (selon décision métier) |

## 3. Écritures types (millimes)
| Événement | Débit | Crédit |
|---|---|---|
| Commande validée (50 000 000 + 500 000 frais) | BANK_ESCROW 50 500 000 | COMPANY_WALLET 50 000 000 ; REVENUE_COMPANY_FEES 500 000 |
| Attribution 200 000 | COMPANY_WALLET 200 000 | EMPLOYEE_WALLET 200 000 |
| Paiement 45 000 | EMPLOYEE_WALLET 45 000 | MERCHANT_WALLET 45 000 |
| Demande de virement 45 000, profil 2 % | MERCHANT_WALLET 45 000 | PAYOUT_PAYABLE 44 100 ; REVENUE_MERCHANT_COMMISSION 900 |
| Exécution du virement 44 100 | PAYOUT_PAYABLE 44 100 | BANK_PAYMENT 44 100 |
| Contre-passation | écriture inverse référençant l'originale | |
Le transfert de trésorerie séquestre → paiement est documenté avec la banque (hors ledger applicatif ou compte de passage).

## 4. Données
`accounts` (id, code, owner_type, owner_id, currency='TND', created_at) · `transactions` (id, type, tenant_id, user_id, idempotency_key, reference, created_at, reverses_id ; **UNIQUE (tenant_id, user_id, idempotency_key)**) · `ledger_entries` (id, transaction_id, account_id, direction D|C, amount_millimes BIGINT CHECK >0, lot_id, created_at) · `credit_lots` (id, wallet_account_id, category, initial_amount, remaining_amount CHECK ≥0, expires_at, source_transaction_id) · `account_balances` (matérialisé, mis à jour dans la même transaction, vérifié par réconciliation).
Contraintes : somme débits = somme crédits par transaction (contrainte différée ou trigger) ; triggers interdisant UPDATE/DELETE sur `transactions` et `ledger_entries` ; `remaining_amount` ne peut descendre sous 0.

## 5. Règles
- Consommation FEFO : lots non expirés par `expires_at` croissant ; un paiement peut consommer plusieurs lots.
- Plafonds (transaction, jour, mois, membre famille) vérifiés dans la transaction, avec les mêmes verrous.
- Verrouillage des comptes concernés dans un **ordre déterministe** (par id) pour éviter les deadlocks.
- Niveau d'isolation `SERIALIZABLE` avec réessai sur conflit, ou `READ COMMITTED` + `FOR UPDATE` documenté.
- Idempotence : même clé → même réponse, aucune nouvelle écriture ; clé conservée 24 h minimum (ou à vie pour les financiers). **Unicité par (tenant, utilisateur, clé)**, jamais globale ; registre et protocole de réservation décrits dans le contrat (`docs/handoff/contracts/openapi.yaml`, section idempotence, constats S6-04 et S6-11).
- Fuseau : les fenêtres « jour » et « mois » des plafonds et les dates d'expiration se calculent en `Africa/Tunis`.
- Expiration : job quotidien qui constate les lots expirés (écriture ou marquage selon décision métier).
- Réconciliation quotidienne : somme des soldes wallets = engagements ; somme ledger = 0 ; écart → alerte critique.

## 6. API interne (services)
`LedgerService.post(transaction)` (seule porte d'entrée en écriture) · `WalletService.getBalance`, `getLots` · `CreditService.allocate`, `consume`, `expire`.

## 8. Tests (voir glossaire E1–E17)
Équilibre débit/crédit ; immuabilité (UPDATE/DELETE refusés) ; idempotence ; FEFO (E9) ; lot expiré (E10) ; plafonds (E8) ; **concurrence 1 000 paiements (E17)** ; solde jamais négatif ; contre-passation ; réconciliation détecte un écart injecté.

## 9. Hors périmètre
Multi-devises, intérêts, prêts.
