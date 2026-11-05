# Carte des fichiers par module

À consulter avant chaque tâche ; mise à jour à chaque fichier créé. Chemins relatifs à la racine.
Web : `W = apps/web/src`, pages sous `W/app/[locale]/`. API : `A = apps/api/src`. Tests API : `T = apps/api/test/integration`.

| Module | API | Web | Tests | Spec |
|---|---|---|---|---|
| Ledger | `A/ledger/ledger.service.ts` (post, reverse, lockAccounts, balance, addLot, reconcile) | — | `T/ledger.test.ts`, `T/rls-ledger.test.ts`, `T/concurrency.test.ts` | `docs/specs/02-ledger.md`, ADR 0002 |
| Commission (grilles, TVA, timbre) | `A/platform/commission-grids.ts`, `A/platform/settings.service.ts` (commissionRate, grille manquante), `A/admin/admin.service.ts` (requestGridChange), `A/common/db.service.ts` (asService), `packages/shared/src/commission.ts`, `packages/shared/src/fees.ts`, migrations 0024-0025 | `admin/commissions/page.tsx`, `W/components/admin/account-form.tsx` (2 étapes), `W/components/admin/commission-grid-editor.tsx` (fenêtre « Commission », aperçu) | `T/admin.test.ts` (grilles, règles du 2026-11-04), `packages/shared/test/commission.test.ts`, `packages/shared/test/fees.test.ts` | `docs/specs/03-commissions.md`, ADR 0004, `docs/design/specs/admin-fenetre-commission.md` |
| Commande (crédit entreprise) | `A/orders/orders.service.ts`, `A/orders/admin-orders.controller.ts`, `A/company/company.service.ts` | `entreprise/commandes/`, `admin/commandes/` | `T/orders.test.ts` | `docs/specs/05-entreprise.md` |
| Virement commerçant | `A/payouts/payouts.service.ts`, `A/payouts/merchant.controller.ts`, `A/payouts/admin-payouts.controller.ts`, `A/payouts/settlement-batch.ts`, `A/payouts/bank.adapter.ts` (banque simulée), `A/admin/admin.service.ts` (requestBatchRelease), migration 0030 | `commercant/virements/`, `admin/virements/`, `admin/reglements/`, `commercant/reglements/` | `T/disputes.test.ts`, `T/four-eyes.test.ts` | `docs/specs/08-reglements.md` |
| Paiement | `A/payments/payments.service.ts`, `A/payments/pin.service.ts` | `commercant/encaissement/`, `admin/transactions/` | `T/payments.test.ts`, `T/pin.test.ts` | `docs/specs/06-employe-mobile.md` |
| Litiges | `A/risk/disputes.service.ts`, `A/risk/risk.controller.ts` | `admin/securite/page.tsx`, `admin/securite/litiges/[disputeId]/page.tsx` | `T/disputes.test.ts`, `apps/web/e2e/security.spec.ts` | `docs/design/specs/admin-securite.md` |
| Alertes de fraude | `A/risk/fraud.service.ts`, `A/jobs/jobs.service.ts` | `admin/securite/page.tsx` | `T/fraud-alerts.test.ts` | idem |
| Admin entreprise | `A/admin/admin.controller.ts`, `A/admin/admin.service.ts` (accountRecord, updateAccount, requestIbanChange), migration 0028 | `admin/entreprises/page.tsx`, `admin/entreprises/[companyId]/page.tsx`, `W/components/admin/account-form.tsx`, `W/components/admin/account-record.tsx` | `T/admin.test.ts`, `T/accounts.test.ts` | `docs/specs/04-admin-kyc.md` |
| Admin commerçant | idem | `admin/commercants/page.tsx`, `admin/commercants/[merchantId]/page.tsx` | idem | idem, `docs/specs/07-commercant.md` |
| Validations (double validation) | `A/admin/admin.service.ts` (approvals) | `admin/validations/` | `T/four-eyes.test.ts` | `docs/specs/09-notifications-audit.md` |
| Paramètres plateforme | `A/platform/settings.service.ts` | `admin/parametres/page.tsx` | `T/admin.test.ts` | — |
| Jobs (lots, réconciliation, expirations) | `A/jobs/jobs.service.ts` | — | `T/disputes.test.ts` | `docs/specs/02-ledger.md` |
| Permissions | `A/common/permissions.ts` | `W/lib/session/permissions.ts` | `T/admin-matrix.test.ts`, `T/permissions.test.ts`, `apps/web/test/lib/permissions.test.ts` (sessions simulées : `apps/web/test/fixtures/sessions.ts`) | — |
| Contrat et client | `docs/handoff/contracts/openapi.yaml` | `packages/api-client` (codegen `scripts/codegen.ts`) | — | — |
| Landing et connexion | — | `(public)/page.tsx`, `(ticket)/login/page.tsx`, `W/components/auth/login-form.tsx`, `W/components/public/ticket-book.tsx` | `apps/web/e2e/login.spec.ts` | `docs/design/carnet-tickets/` |
| Schéma et migrations | `apps/api/prisma/schema.prisma`, `apps/api/prisma/migrations/` | — | — | — |
| Données de volume (hors démo) | `apps/api/prisma/seed-volume.ts`, générateur `apps/api/prisma/volume/` (ancien MSW) — `db:seed:volume` | — | — | — |
