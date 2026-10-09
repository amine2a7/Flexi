# Architecture technique

## Vue d'ensemble
```
 Flutter Employé ─┐
 Flutter Pro ─────┼─► Cloudflare (WAF) ─► API NestJS ─► PostgreSQL (ledger, RLS)
 Web Next.js ─────┘                          │ ├────► Redis (QR, rate limit, files)
                                             │ ├────► S3 privé (documents KYC, PDF)
                                             │ └────► Banque / SMS / Email / Push / Passerelle carte
```
Monolithe modulaire NestJS. Les modules communiquent par services internes et événements, pas par HTTP.

## Modules API
`auth` · `users` · `companies` · `merchants` · `employees` · `family` · `commission-profiles` · `orders` · `ledger` · `wallets` · `credits` · `payments` · `qr` · `payouts` · `settlements` · `disputes` · `kyc` · `approvals` · `audit` · `notifications` · `reporting` · `settings`

## Structure du dépôt
```
apps/api  apps/web  apps/mobile-employe  apps/mobile-pro
packages/shared  packages/ui-tokens  packages/api-client  packages/config
docs/  infra/  .claude/  CLAUDE.md
```

## Choix clés
| Sujet | Choix |
|---|---|
| Mobile | **Flutter** (Riverpod, go_router, dio, freezed, flutter_secure_storage, local_auth, mobile_scanner, qr_flutter) |
| Contrat API | OpenAPI généré par NestJS → clients TypeScript (web) et Dart (mobile) |
| Design tokens | `docs/design/design-tokens.json` → Tailwind (web) et `ThemeData` (Flutter), via un script de génération |
| Argent | Millimes entiers `BIGINT`, taux en bps, ledger en partie double immuable |
| Isolation | Row-Level Security PostgreSQL par `company_id` / `merchant_id` |
| Jobs | BullMQ : expirations, règlements J+2, notifications, réconciliation |
| Observabilité | Sentry, OpenTelemetry, Grafana/Loki, alertes sur échec de réconciliation |
| Environnements | dev → staging → prod, secrets via gestionnaire dédié |

## Flux : paiement employé → commerçant
1. L'employé demande un QR (`POST /qr`) : jeton signé, nonce, TTL 60 s, lié à l'appareil, stocké dans Redis.
2. Le commerçant scanne (`POST /payments/initiate`) avec le montant.
3. L'employé confirme par PIN/biométrie (`POST /payments/{id}/confirm`, `Idempotency-Key`).
4. Transaction SQL : verrouillage ordonné des comptes, contrôles (solde, lots FEFO, plafonds, commerçant actif, antifraude), écritures : débit wallet employé, crédit wallet commerçant (brut).
5. Consommation atomique du QR. Notifications aux deux parties, reçu PDF asynchrone.

## Flux : demande de virement commerçant
1. `GET /payouts/quote?amount=` : retourne brut, taux (bps), commission, net.
2. `POST /payouts` : fige le taux, écritures (débit wallet commerçant, crédit à-payer et revenu commission), statut *Demandée*.
3. Contrôles (RIB/KYC, LAB/FT), file d'approbation si seuil dépassé, génération de l'ordre bancaire, statut *Exécutée* au retour de la banque.

## Environnements et déploiement
CI GitHub Actions : lint, typecheck, tests, scans (CodeQL/Semgrep, gitleaks, Trivy, audit), build, déploiement staging automatique, production manuelle avec approbation. Mobile : Fastlane/Codemagic → TestFlight et Play Console (test interne).
