# Tableau des tâches

Tenu par le lead (`team-lead`) à chaque étape. Statuts : À faire · En cours · En revue · Bloqué · Terminé.
Préfixe `TEST-FIRST:` = tâche de tests écrits avant le code (tests rouges acceptés).

## Phase en cours : Phase 0 – Fondations (roadmap) — PROPOSÉE, en attente de validation

Objectif (roadmap) : monorepo, CI, Docker Compose (Postgres, Redis), lint/format ; pipeline de génération des tokens ; environnements dev et staging. Aucune fonctionnalité métier.
Critère de fin : pipeline vert ; securite OK ; design OK sur les coquilles.

### Prérequis bloquants (décisions utilisateur)
| ID | Sujet | Bloque |
|---|---|---|
| PRE-1 | `pnpm.exe` bloqué par Device Guard | tout le JS : B1 et suivantes |
| PRE-2 | Docker absent | B4 (Compose), tests d'intégration Testcontainers |
| PRE-3 | Flutter SDK absent | M1–M3 (et le hook TaskCompleted mobile, fermé par défaut) |
| PRE-4 | Pas de dépôt git ni de remote GitHub | B6 (CI exécutable), revues `git diff` |
| PRE-5 | Fournisseur d'hébergement staging non choisi (open-questions : hébergement INPDP) | déploiement staging (hors de cette phase) |

### Tâches
| ID | Titre | Responsable | Statut | Dépend de | Relecteur |
|---|---|---|---|---|---|
| P0-B1 | Monorepo pnpm + Turborepo : workspace, `turbo.json`, `tsconfig.base`, ESLint/Prettier partagés (`packages/config`), scripts lint/typecheck/test/build | backend | Proposé | PRE-1 | securite (S1) |
| P0-B2 | `packages/shared` : squelette Zod, types, constantes (millimes, bps), outillage de tests | backend | Proposé | B1 | securite (S1) |
| P0-B3 | `TEST-FIRST:` puis squelette `apps/api` NestJS : guard global (refus par défaut), `@Public()`, `GET /health`, validation de la config par Zod, logger avec masquage, en-têtes (helmet), rate limiting de base | backend | Proposé | B1, B2 | securite (S2) |
| P0-B4 | Docker Compose dev (PostgreSQL 16, Redis, healthchecks, aucun secret en dur) + socle Testcontainers | backend | Proposé | B1, PRE-2 | securite (S1) |
| P0-B5 | Contrat initial `docs/handoff/contracts/openapi.yaml` (health, format d'erreur, Idempotency-Key, pagination, montants en millimes) + génération `packages/api-client` ; `[CONTRAT]` à frontend et mobile | backend | Proposé | B3 | securite (S2) |
| P0-B6 | CI GitHub Actions : lint, typecheck, test, build, gitleaks, `pnpm audit`, CodeQL/Semgrep, Trivy, job Flutter ; pas de déploiement | backend | Proposé | B1, PRE-4 | securite (S3) |
| P0-D1 | `packages/ui-tokens` : génération `design-tokens.json` → preset Tailwind + `ThemeData` Flutter, tests (dont contrastes AA des paires texte/fond) | design | Proposé | B1 | securite (S1, dépendances) |
| P0-D2 | Spec `docs/design/specs/fondations-composants.md` : bouton, champ, badge de statut, carte, toast, montant, squelette, états vide/erreur/hors connexion | design | Proposé | — | — |
| P0-D3 | Spec `docs/design/specs/navigation.md` : sidebar web (3 espaces), barres basses Employé et Pro, écrans session expirée / hors connexion | design | Proposé | — | — |
| P0-D4 | Revue de fidélité des coquilles web et mobile | design | Proposé | F2, M2 | — |
| P0-F1 | Squelette `apps/web` : Next.js App Router, TS strict, Tailwind sur le preset ui-tokens, shadcn/ui, Lucide, i18n FR/AR/EN + RTL, Vitest + Playwright | frontend | Proposé | B1, D1 | securite (S4) |
| P0-F2 | Coquille de navigation web + page de santé via le client généré + utilitaire unique de formatage des montants (tests) | frontend | Proposé | F1, D2, D3, B5 | design (D4) |
| P0-F3 | En-têtes de sécurité web : CSP stricte, frame-ancestors, Referrer-Policy, X-Content-Type-Options, cookies (tests) | frontend | Proposé | F1 | securite (S4) |
| P0-M1 | Squelettes `apps/mobile-employe` et `apps/mobile-pro` : Riverpod, go_router, dio, freezed, lints stricts, l10n FR/AR/EN + RTL | mobile | Proposé | PRE-3 | securite (S4) |
| P0-M2 | Thème généré depuis les tokens + coquilles barre basse + écran de santé via client Dart généré + formateur de montants unique (tests) | mobile | Proposé | M1, D1, D3, B5 | design (D4) |
| P0-M3 | Socle sécurité mobile : `flutter_secure_storage`, intercepteur dio avec pinning (configurable), blocage de capture d'écran, build release obfusqué | mobile | Proposé | M1 | securite (S4) |
| P0-S1 | Revue monorepo, dépendances, Compose, ui-tokens | securite | Proposé | B1, B2, B4, D1 | — |
| P0-S2 | Revue squelette API et contrat initial | securite | Proposé | B3, B5 | — |
| P0-S3 | Revue CI (permissions des jobs, secrets, scans) | securite | Proposé | B6 | — |
| P0-S4 | Revue squelettes web et mobile (en-têtes, cookies, stockage, pinning, capture) | securite | Proposé | F1, F3, M1, M3 | — |
| P0-S5 | Modèle de menaces : chaîne d'approvisionnement, CI, environnement de dev ; points ASVS de la phase 0 | securite | Proposé | — | — |

## Historique

| Date | Phase | Résultat | Rapport |
|---|---|---|---|
| 2026-10-09 | Préparation de l'équipe d'agents | Terminé (sans coéquipier lancé) | `reports/preparation-equipe-2026-10-09.md` |
