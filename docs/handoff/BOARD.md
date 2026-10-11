# Tableau des tâches

Tenu par le lead (`team-lead`) à chaque étape. Statuts : À faire · En cours · En revue · Bloqué · Terminé.
Préfixe `TEST-FIRST:` = tâche de tests écrits avant le code (tests rouges acceptés).

## Phase en cours : Phase 0 – Fondations — vague 1 en clôture (B4 bloqué par Docker) ; priorité suivante « web d'abord » (décision du 2026-10-11), mobile reporté

Objectif (roadmap) : monorepo, CI, Docker Compose (Postgres, Redis), lint/format ; pipeline de génération des tokens ; environnement dev. **Staging exclu de cette passe** (après le choix de l'hébergeur). Aucune fonctionnalité métier.
Critère de fin : pipeline vert ; securite OK ; design OK sur les coquilles.

### Prérequis (vérifiés par le lead le 2026-10-09, revérifiés le 2026-10-11 sur le PC personnel, après correctif de l'hyperviseur)
| ID | Sujet | État | Bloque |
|---|---|---|---|
| PRE-1 | pnpm utilisable | ✅ PC personnel : pnpm 9.15.4 s'exécute (2026-10-11). PC d'entreprise : bloqué par Device Guard, pas de contournement (décision) | — |
| PRE-2 | Docker | ❌ (N-02) Docker Desktop installé (`C:\Program Files\Docker\Docker\resources\bin`esourcesin`) mais hors PATH ; `docker run hello-world` → « Docker Desktop is unable to start » (2026-10-11) | B4, tests d'intégration (« En attente — Docker ») |
| PRE-3 | Flutter SDK (Android) | ❌ toujours absent (`flutter` introuvable, revérifié le 2026-10-11) | M1–M3, M2 (thème), test Dart de D1 |
| PRE-4 | Dépôt git + remote | ✅ origin = https://github.com/amine2a7/Flexi ; identité `--local` reposée sur le PC personnel ; `main` recréée à 8e2a02a et poussée par l'utilisateur (2026-10-11, après correction d'un 403 d'identifiants) ; PR `fix/cf-chaine-dev` → `main` à ouvrir par l'utilisateur (`gh` absent), sans fusion | — |
| PRE-5 | Staging | ⏸ exclu de cette passe (décision utilisateur) | — |
| PRE-6 | gitleaks | ✅ (N-01 fermé) gitleaks 8.30.1 (winget) ; CF-02/S9-02 appliqué et testé (2026-10-11) | — |
| PRE-7 | Protection de `main` sur GitHub | ⏳ à régler par l'utilisateur : PR obligatoire, 0 approbation, signature reportée à S9-06 (décision du 2026-10-11) | Fusion de la PR CF |

### Tâches
| ID | Titre | Responsable | Statut | Dépend de | Relecteur |
|---|---|---|---|---|---|
| P0-B1 | Monorepo pnpm + Turborepo : workspace, `turbo.json`, `tsconfig.base`, ESLint/Prettier partagés (`packages/config`), scripts lint/typecheck/test/build | backend | Terminé (securite OK, commit 98add0a) | PRE-1 | securite (S1) |
| P0-B2 | `packages/shared` : squelette Zod, types, constantes (millimes, bps), outillage de tests | backend | Terminé (securite OK, commit 4431e45) | B1 | securite (S1) |
| P0-B3 | `TEST-FIRST:` puis squelette `apps/api` NestJS : guard global (refus par défaut), `@Public()`, `GET /health`, validation de la config par Zod, logger avec masquage, en-têtes (helmet), rate limiting de base | backend | À faire (après la vague 1) | B1, B2 | securite (S2) |
| P0-B4 | Docker Compose dev (PostgreSQL 16, Redis, healthchecks, aucun secret en dur) + socle Testcontainers | backend | Bloqué — Docker ne répond plus (image déplacée sur D:, redémarrage à faire par l'utilisateur) ; Testcontainers vert 5/5 avant la panne | B1, PRE-2 | securite (S1) |
| P0-B5 | Rédaction du contrat initial `docs/handoff/contracts/openapi.yaml` (health, format d'erreur, Idempotency-Key, pagination, montants en millimes, auth par cookie/bearer, en-têtes) — **sans génération de client ni code** ; `[CONTRAT]` annoncé (frontend/mobile inactifs : consigné dans le rapport) | backend | Terminé (securite OK, contrat e8b0a175) | — | securite (P0-S6) |
| P0-B6 | CI GitHub Actions : lint, typecheck, test, build, gitleaks, `pnpm audit`, CodeQL/Semgrep, Trivy, job Flutter ; pas de déploiement | backend | À faire (après la vague 1) | B1, PRE-4 | securite (S3) |
| P0-D1 | `packages/ui-tokens` : génération `design-tokens.json` → preset Tailwind + `ThemeData` Flutter, tests (dont contrastes AA des paires texte/fond) | design | Terminé (securite OK, commit a63412b ; Dart non compilé, décision) | B1 | securite (S1, dépendances) |
| P0-D2 | Spec `docs/design/specs/fondations-composants.md` : bouton, champ, badge de statut, carte, toast, montant, squelette, états vide/erreur/hors connexion | design | Terminé (hypothèses GET /me à confirmer ; fidélité à revoir en D4) | — | — |
| P0-D3 | Spec `docs/design/specs/navigation.md` : sidebar web (3 espaces), barres basses Employé et Pro, écrans session expirée / hors connexion | design | Terminé (hypothèses GET /me à confirmer ; fidélité à revoir en D4) | — | — |
| P0-D4 | Revue de fidélité des coquilles web et mobile | design | En attente — outils | F2, M2 | — |
| P0-F1 | Squelette `apps/web` : Next.js App Router, TS strict, Tailwind sur le preset ui-tokens, shadcn/ui, Lucide, i18n FR/AR/EN + RTL, Vitest + Playwright | frontend | En attente — outils | B1, D1 | securite (S4) |
| P0-F2 | Coquille de navigation web + page de santé via le client généré + utilitaire unique de formatage des montants (tests) | frontend | En attente — outils | F1, D2, D3, B5 | design (D4) |
| P0-F3 | En-têtes de sécurité web : CSP stricte, frame-ancestors, Referrer-Policy, X-Content-Type-Options, cookies (tests) | frontend | En attente — outils | F1 | securite (S4) |
| P0-M1 | Squelettes `apps/mobile-employe` et `apps/mobile-pro` : Riverpod, go_router, dio, freezed, lints stricts, l10n FR/AR/EN + RTL | mobile | En attente — mobile reporté (« web d'abord », décision du 2026-10-11) | PRE-3 | securite (S4) |
| P0-M2 | Thème généré depuis les tokens + coquilles barre basse + écran de santé via client Dart généré + formateur de montants unique (tests) | mobile | En attente — mobile reporté (« web d'abord », décision du 2026-10-11) | M1, D1, D3, B5 | design (D4) |
| P0-M3 | Socle sécurité mobile : `flutter_secure_storage`, intercepteur dio avec pinning (configurable), blocage de capture d'écran, build release obfusqué | mobile | En attente — mobile reporté (« web d'abord », décision du 2026-10-11) | M1 | securite (S4) |
| P0-S1 | Revue monorepo, dépendances, Compose, ui-tokens | securite | En cours (B1, B2, D1 OK ; B4 en attente ; revérification S1-01/S1-02 commit 594f06e) | B1, B2, B4, D1 | — |
| P0-S2 | Revue squelette API et contrat initial | securite | En attente — outils | B3, B5 | — |
| P0-S3 | Revue CI (permissions des jobs, secrets, scans) | securite | En attente — outils | B6 | — |
| P0-S4 | Revue squelettes web et mobile (en-têtes, cookies, stockage, pinning, capture) | securite | En attente — outils | F1, F3, M1, M3 | — |
| P0-S5 | Modèle de menaces : chaîne d'approvisionnement, CI, environnement de dev ; points ASVS de la phase 0 | securite | Terminé (OK avec réserves : CF-01..CF-09 ouverts, décision utilisateur) | — | — |
| P0-S6 | Revue du contrat OpenAPI initial (B5) : authentification, IDOR par construction des routes, Idempotency-Key, format d'erreur sans fuite, en-têtes ; ajoutée par la règle (c), validée | securite | Terminé (OK, S6-01..S6-11 fermés en 3 allers-retours) | B5 | — |
| P0-D5 | Report des décisions du 2026-10-09 dans la charte et les specs D2/D3 (+ S8-01 : suppression de « Changer d'espace ») | design | Terminé | décisions | securite (S8-01 fermé) |
| P0-B7 | Report des décisions du 2026-10-09 dans le contrat (SHA-256 82bf61bd) | backend | Terminé (securite OK) | décisions | securite (P0-S8) |
| P0-S7 | Report des décisions de sécurité (SEC-D7, SEC-S7, ASVS 5.0, modèle de menaces v3) | securite | Terminé | décisions | — |
| P0-S8 | Revue de P0-B7 et constat S8-01 | securite | Terminé (OK, 0 ouvert) | B7 | — |
| P0-L1 | Correctifs CF-01 à CF-09 sur branche dédiée (un commit par constat) | lead | En revue (CF-01..09 + S9-01..06 commités ; CF-02/S9-02 appliqué et testé le 2026-10-11 : commit normal → 0, faux secret indexé → 2, `-a`/`--no-verify` → 2, gitleaks absent → 2 ; revérification securite à faire) | décisions commitées | securite |
| P0-S9 | Revue securite de `fix/cf-chaine-dev` (CF-01..09, S9-01..07) — constats de poste du 2026-10-11 : **N-01** gitleaks absent → fermé par le lead (installé, CF-02 appliqué et testé) ; **N-02** Docker ne démarre pas → fermé par le lead (hyperviseur) | securite | En cours (verdict OK provisoire ; revérification de CF-02/S9-02, N-01 et N-02 à faire dans S1) | L1 | — |
| P0-L2 | Agents relecteurs `ux`, `qualite`, `conformite` : définitions, périmètres (scopes.js), 55 tests du hook, protocole et CLAUDE.md | lead | Terminé (commit a429a88) | décision | — |
| P0-L3 | Correctif S1-01/S1-02 : hook git natif `.githooks/pre-commit` + guard-bash.js (segment commit seul), 53 tests + test réel | lead | En revue (commit 594f06e) | décision | securite |

## Historique

| Date | Phase | Résultat | Rapport |
|---|---|---|---|
| 2026-10-09 | Préparation de l'équipe d'agents | Terminé (sans coéquipier lancé) | `reports/preparation-equipe-2026-10-09.md` |
| 2026-10-09 | Phase 0 – équipe réduite (design, securite, backend) | Terminé : D2, D3, B5, S5, S6 | `reports/phase0-equipe-reduite-2026-10-09.md` |
