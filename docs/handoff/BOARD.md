# Tableau des tâches

Tenu par le lead (`team-lead`) à chaque étape. Statuts : À faire · En cours · En revue · Bloqué · Terminé.
Préfixe `TEST-FIRST:` = tâche de tests écrits avant le code (tests rouges acceptés).

## Phase en cours : Phase 0 – Fondations — passe « équipe réduite » TERMINÉE le 2026-10-09 ; 17 tâches en attente d'outils (reprise sur PC personnel, README §14)

Objectif (roadmap) : monorepo, CI, Docker Compose (Postgres, Redis), lint/format ; pipeline de génération des tokens ; environnement dev. **Staging exclu de cette passe** (après le choix de l'hébergeur). Aucune fonctionnalité métier.
Critère de fin : pipeline vert ; securite OK ; design OK sur les coquilles.

### Prérequis (vérifiés par le lead le 2026-10-09)
| ID | Sujet | État | Bloque |
|---|---|---|---|
| PRE-1 | pnpm utilisable | ❌ bloqué par Device Guard sur le PC d'entreprise — **pas de contournement** (décision) ; reprise sur PC personnel | B1 et toutes les tâches JS |
| PRE-2 | Docker | ❌ introuvable (ni PATH, ni C:\Program Files\Docker) | B4, tests d'intégration |
| PRE-3 | Flutter SDK (Android) | ❌ introuvable (ni PATH, ni emplacements usuels) | M1–M3 |
| PRE-4 | Dépôt git + remote | ✅ `git init` (main), origin = https://github.com/amine2a7/Flexi, commit 0219ad1 (auteur corrigé), rien de poussé | — |
| PRE-5 | Staging | ⏸ exclu de cette passe (décision utilisateur) | — |

### Tâches
| ID | Titre | Responsable | Statut | Dépend de | Relecteur |
|---|---|---|---|---|---|
| P0-B1 | Monorepo pnpm + Turborepo : workspace, `turbo.json`, `tsconfig.base`, ESLint/Prettier partagés (`packages/config`), scripts lint/typecheck/test/build | backend | En attente — outils | PRE-1 | securite (S1) |
| P0-B2 | `packages/shared` : squelette Zod, types, constantes (millimes, bps), outillage de tests | backend | En attente — outils | B1 | securite (S1) |
| P0-B3 | `TEST-FIRST:` puis squelette `apps/api` NestJS : guard global (refus par défaut), `@Public()`, `GET /health`, validation de la config par Zod, logger avec masquage, en-têtes (helmet), rate limiting de base | backend | En attente — outils | B1, B2 | securite (S2) |
| P0-B4 | Docker Compose dev (PostgreSQL 16, Redis, healthchecks, aucun secret en dur) + socle Testcontainers | backend | En attente — outils | B1, PRE-2 | securite (S1) |
| P0-B5 | Rédaction du contrat initial `docs/handoff/contracts/openapi.yaml` (health, format d'erreur, Idempotency-Key, pagination, montants en millimes, auth par cookie/bearer, en-têtes) — **sans génération de client ni code** ; `[CONTRAT]` annoncé (frontend/mobile inactifs : consigné dans le rapport) | backend | Terminé (securite OK, contrat e8b0a175) | — | securite (P0-S6) |
| P0-B6 | CI GitHub Actions : lint, typecheck, test, build, gitleaks, `pnpm audit`, CodeQL/Semgrep, Trivy, job Flutter ; pas de déploiement | backend | En attente — outils | B1, PRE-4 | securite (S3) |
| P0-D1 | `packages/ui-tokens` : génération `design-tokens.json` → preset Tailwind + `ThemeData` Flutter, tests (dont contrastes AA des paires texte/fond) | design | En attente — outils | B1 | securite (S1, dépendances) |
| P0-D2 | Spec `docs/design/specs/fondations-composants.md` : bouton, champ, badge de statut, carte, toast, montant, squelette, états vide/erreur/hors connexion | design | Terminé (hypothèses GET /me à confirmer ; fidélité à revoir en D4) | — | — |
| P0-D3 | Spec `docs/design/specs/navigation.md` : sidebar web (3 espaces), barres basses Employé et Pro, écrans session expirée / hors connexion | design | Terminé (hypothèses GET /me à confirmer ; fidélité à revoir en D4) | — | — |
| P0-D4 | Revue de fidélité des coquilles web et mobile | design | En attente — outils | F2, M2 | — |
| P0-F1 | Squelette `apps/web` : Next.js App Router, TS strict, Tailwind sur le preset ui-tokens, shadcn/ui, Lucide, i18n FR/AR/EN + RTL, Vitest + Playwright | frontend | En attente — outils | B1, D1 | securite (S4) |
| P0-F2 | Coquille de navigation web + page de santé via le client généré + utilitaire unique de formatage des montants (tests) | frontend | En attente — outils | F1, D2, D3, B5 | design (D4) |
| P0-F3 | En-têtes de sécurité web : CSP stricte, frame-ancestors, Referrer-Policy, X-Content-Type-Options, cookies (tests) | frontend | En attente — outils | F1 | securite (S4) |
| P0-M1 | Squelettes `apps/mobile-employe` et `apps/mobile-pro` : Riverpod, go_router, dio, freezed, lints stricts, l10n FR/AR/EN + RTL | mobile | En attente — outils | PRE-3 | securite (S4) |
| P0-M2 | Thème généré depuis les tokens + coquilles barre basse + écran de santé via client Dart généré + formateur de montants unique (tests) | mobile | En attente — outils | M1, D1, D3, B5 | design (D4) |
| P0-M3 | Socle sécurité mobile : `flutter_secure_storage`, intercepteur dio avec pinning (configurable), blocage de capture d'écran, build release obfusqué | mobile | En attente — outils | M1 | securite (S4) |
| P0-S1 | Revue monorepo, dépendances, Compose, ui-tokens | securite | En attente — outils | B1, B2, B4, D1 | — |
| P0-S2 | Revue squelette API et contrat initial | securite | En attente — outils | B3, B5 | — |
| P0-S3 | Revue CI (permissions des jobs, secrets, scans) | securite | En attente — outils | B6 | — |
| P0-S4 | Revue squelettes web et mobile (en-têtes, cookies, stockage, pinning, capture) | securite | En attente — outils | F1, F3, M1, M3 | — |
| P0-S5 | Modèle de menaces : chaîne d'approvisionnement, CI, environnement de dev ; points ASVS de la phase 0 | securite | Terminé (OK avec réserves : CF-01..CF-09 ouverts, décision utilisateur) | — | — |
| P0-S6 | Revue du contrat OpenAPI initial (B5) : authentification, IDOR par construction des routes, Idempotency-Key, format d'erreur sans fuite, en-têtes ; ajoutée par la règle (c), validée | securite | Terminé (OK, S6-01..S6-11 fermés en 3 allers-retours) | B5 | — |

## Historique

| Date | Phase | Résultat | Rapport |
|---|---|---|---|
| 2026-10-09 | Préparation de l'équipe d'agents | Terminé (sans coéquipier lancé) | `reports/preparation-equipe-2026-10-09.md` |
| 2026-10-09 | Phase 0 – équipe réduite (design, securite, backend) | Terminé : D2, D3, B5, S5, S6 | `reports/phase0-equipe-reduite-2026-10-09.md` |
