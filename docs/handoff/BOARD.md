# Tableau des tâches

Tenu par le lead (`main`) à chaque étape. Statuts : À faire · En cours · En revue · Bloqué · Terminé.
Préfixe `TEST-FIRST:` = tâche de tests écrits avant le code (tests rouges acceptés).

## État courant (mis à jour le 2026-10-21) — À LIRE EN PREMIER

Mode économe (voir CLAUDE.md). Branche `feat/web`. Plan de l'utilisateur du 2026-10-21 (étapes 0 à 6, puis carnet de tickets).

| Étape | Statut | Commits / reste |
|---|---|---|
| Bloc 5 (API réelle, seed, web branché) + A (comptes et invitations) + B (pg, deux onglets) | Terminé | 3c958c2 … 38110ed |
| 0. `--webpack` par défaut (bug Turbopack) ; port 3000 = `next dev` de D:ProjectScool (conflit avec l'API) | Terminé | a1c5387 |
| 1. Ledger C1-C9, C13 (verrous, index 0010, réconciliation quotidienne) | Terminé, ledger-auditor **OK** | 3d9d733, 6bfef5e (S03 approbations, N1) |
| Correctif : sessions PostgreSQL en UTC (dates décalées d'1 h) | Terminé | d02cdd3 |
| 2. S01 PIN (réservation atomique, 15/30/60 min puis reconnexion) + S07 (empreinte HMAC) | Terminé | 983b69e, a8b5ce8 |
| 3. S02 sous-rôles vérifiés par le serveur (matrice de l'utilisateur) | Terminé, securite : S02 **FERMÉ** | voir le commit S02 ; ouverts : B5-S02-a (Moyenne, créateur du commerçant = validateur de son KYC), B5-S02-c (droits à confirmer, decisions.md 2026-10-21) |
| POINT DE CONTRÔLE 1 | **En attente de l'utilisateur** | |
| 4. qualite B1, M1, M2 ; boîte d'envoi PostgreSQL + job ; resend-credentials ; relationJoins figé ; commit des changements web en attente (client.ts, page Payer, traductions bénéficiaire, m10, m11) et des maquettes `docs/design` | À faire | |
| 5. Départements | À faire | |
| 6. Employé + activation du bénéficiaire par téléphone (code, OTP, PIN 6 chiffres, appareil de confiance) | À faire | puis POINT DE CONTRÔLE 2 |
| Carnet de tickets (mascotte, connexion, accueil, connexion mobile 360 px) | Après l'étape 6 | |

Revues ouvertes : `docs/handoff/reviews/securite-bloc5-a-b-2026-10-15.md` (S01, S03, S07 corrigés ; S02 ouvert ; S04-S06, S08-S22 à traiter) ; `qualite-bloc5-a-b-2026-10-15.md` (B1, M1-M6, m1-m14 ouverts). Ledger-auditor : N2 (litiges V1, test d'abord), N3, N4 restants.
Décisions du 2026-10-21 : pas de plafond mensuel en V1 ; litiges V1 = annulation commerçant sous 24 h + écriture corrective admin tracée ; pas de minimum de commission.
Les lignes WF1 à WF5 ci-dessous sont périmées : écrans faits (commits 4379630, 0c53df3 et suivants).

## Phase en cours : « web d'abord » — étape 1 terminée le 2026-10-12 (point de contrôle) ; branche `feat/web` ; 24 décisions en attente ; Docker arrêté (C: plein)

Objectif (roadmap) : monorepo, CI, Docker Compose (Postgres, Redis), lint/format ; pipeline de génération des tokens ; environnement dev. **Staging exclu de cette passe** (après le choix de l'hébergeur). Aucune fonctionnalité métier.
Critère de fin : pipeline vert ; securite OK ; design OK sur les coquilles.

### Prérequis (vérifiés par le lead le 2026-10-09, revérifiés le 2026-10-11 sur le PC personnel, après correctif de l'hyperviseur)
| ID | Sujet | État | Bloque |
|---|---|---|---|
| PRE-1 | pnpm utilisable | ✅ PC personnel : pnpm 9.15.4 s'exécute (2026-10-11). PC d'entreprise : bloqué par Device Guard, pas de contournement (décision) | — |
| PRE-2 | Docker | ⚠️ (N-02 fermé le 2026-10-11 : hyperviseur activé, Docker 29.8.2 a fonctionné, Testcontainers 5/5) — depuis 12h56 le moteur est arrêté : disque C: plein (« not enough space on the disk »), image disque déplacée sur D: par l'utilisateur, place à libérer sur C: | B4 (compose healthy, test:integration)
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
| P0-B3 | `TEST-FIRST:` puis squelette `apps/api` NestJS : guard global (refus par défaut), `@Public()`, `GET /health`, validation de la config par Zod, logger avec masquage, en-têtes (helmet), rate limiting de base | backend | À faire (web, étape 2) | B1, B2 | securite (S2) |
| P0-B4 | Docker Compose dev (PostgreSQL 16, Redis, healthchecks, aucun secret en dur) + socle Testcontainers | backend | En revue (commit 7606a7a ; securite OK sur lecture) — reste : docker compose healthy + pnpm test:integration, Docker arrêté (C: plein) | B1, PRE-2 | securite (S1) |
| P0-B5 | Rédaction du contrat initial `docs/handoff/contracts/openapi.yaml` (health, format d'erreur, Idempotency-Key, pagination, montants en millimes, auth par cookie/bearer, en-têtes) — **sans génération de client ni code** ; `[CONTRAT]` annoncé (frontend/mobile inactifs : consigné dans le rapport) | backend | Terminé (securite OK ; empreinte SHA-256 du contrat à la fin de B7 : 82bf61bd) | — | securite (P0-S6) |
| P0-B6 | CI GitHub Actions : lint, typecheck, test, build, gitleaks, `pnpm audit`, CodeQL/Semgrep, Trivy, job Flutter ; pas de déploiement | backend | À faire (web, étape 2) | B1, PRE-4 | securite (S3) |
| P0-D1 | `packages/ui-tokens` : génération `design-tokens.json` → preset Tailwind + `ThemeData` Flutter, tests (dont contrastes AA des paires texte/fond) | design | Terminé (securite OK, commit a63412b ; Dart non compilé, décision) | B1 | securite (S1, dépendances) |
| P0-D2 | Spec `docs/design/specs/fondations-composants.md` : bouton, champ, badge de statut, carte, toast, montant, squelette, états vide/erreur/hors connexion | design | À REVOIR (ux : 21 constats ; conformite : NON CONFORME S-01..S-06) — repris dans WD2 ; ne pas coder avant | — | — |
| P0-D3 | Spec `docs/design/specs/navigation.md` : sidebar web (3 espaces), barres basses Employé et Pro, écrans session expirée / hors connexion | design | À REVOIR (ux et conformite) — repris dans WD1 ; ne pas coder avant | — | — |
| P0-D4 | Revue de fidélité des coquilles web et mobile | design | En attente — outils | F2, M2 | — |
| P0-F1 | Squelette `apps/web` : Next.js App Router, TS strict, Tailwind sur le preset ui-tokens, shadcn/ui, Lucide, i18n FR/AR/EN + RTL, Vitest + Playwright | frontend | Terminé sauf shadcn/ui, reporté à WF1 (securite OK, qualite OK, conformite : F1 non conforme sur ce seul point ; commit 736d0ca) | B1, D1 | securite (S4) |
| P0-F2 | Coquille de navigation web + page de santé via le client généré + utilitaire unique de formatage des montants (tests) | frontend | À faire (web, étape 3) | F1, D2, D3, B5 | design (D4) |
| P0-F3 | En-têtes de sécurité web : CSP stricte, frame-ancestors, Referrer-Policy, X-Content-Type-Options, cookies (tests) | frontend | Terminé (securite OK, qualite OK ; commit 736d0ca) | F1 | securite (S4) |
| P0-M1 | Squelettes `apps/mobile-employe` et `apps/mobile-pro` : Riverpod, go_router, dio, freezed, lints stricts, l10n FR/AR/EN + RTL | mobile | En attente — mobile reporté (« web d'abord », décision du 2026-10-11) | PRE-3 | securite (S4) |
| P0-M2 | Thème généré depuis les tokens + coquilles barre basse + écran de santé via client Dart généré + formateur de montants unique (tests) | mobile | En attente — mobile reporté (« web d'abord », décision du 2026-10-11) | M1, D1, D3, B5 | design (D4) |
| P0-M3 | Socle sécurité mobile : `flutter_secure_storage`, intercepteur dio avec pinning (configurable), blocage de capture d'écran, build release obfusqué | mobile | En attente — mobile reporté (« web d'abord », décision du 2026-10-11) | M1 | securite (S4) |
| P0-S1 | Revue monorepo, dépendances, Compose, ui-tokens | securite | Terminé (OK : B1, B2, D1 ; B4 OK sur lecture ; commit a9cc4ae ; S1-11 risque accepté) | B1, B2, B4, D1 | — |
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
| P0-L3 | Correctif S1-01/S1-02 : hook git natif `.githooks/pre-commit` + guard-bash.js (segment commit seul), 53 tests + test réel | lead | En revue — S1-09/S1-10 corrigés (78 tests), commit à faire par l'utilisateur (touche .githooks/) ; S1-01/S1-02 fermés | décision | securite |

### Plan « web d'abord » (validé le 2026-10-11)
Chaîne de revue : code → securite + qualite → ux (si écran) + design (fidélité) → conformite ; spec → ux → conformite (+ securite si auth/argent) avant d'être codée.
Données fictives : MSW dans `apps/web/src/mocks/`, typées par `packages/api-client`, absentes du build de production (test). Aucune logique métier critique dans le front.

| ID | Titre | Responsable | Statut | Dépend de | Relecteur |
|---|---|---|---|---|---|
| Q0 | Revue qualité rétroactive de B1, B2, D1, B4 | qualite | Terminé (OK, 0 Important ; 7 Améliorations ouvertes) | — | — |
| WD1 | Specs Commun : connexion, première connexion (mot de passe temporaire), MFA, session expirée, 404/500 | design | Terminé (ux, securite, conformite OK ; commit 380bdb2) | WB2 (auth) | ux, conformite, securite |
| WD2 | Spec page bibliothèque de composants `/dev/composants` (boutons, champs, badges, cartes, toasts, tableaux, modales, montants ; tous les états) | design | Terminé (ux OK, conformite CONFORME sous réserve D-03 ; commit 4521e8c) | D2 | ux, conformite |
| WD3 | Specs Commerçant : tableau de bord, encaissement (code manuel), succès/refus, historique, créances, simulation et demande de virement (brut → commission → net, taux figé), règlements, mon commerce | design | En cours — 6 specs sur 8 en brouillon (commit e5cf55d), non relues | WD2 | ux, conformite, securite |
| WD4 | Specs Entreprise : tableau de bord, commande de crédits (frais), employés + import CSV (erreurs, doublons), attribution, factures, reporting, paramètres | design | À faire | WD2 | ux, conformite, securite |
| WD5 | Specs Administrateur : tableau de bord, comptes, création société et commerçant (profil de commission obligatoire), KYC, commissions (double validation), transactions et alertes, paramètres, audit | design | À faire | WD2 | ux, conformite, securite |
| WD6 | Revue de fidélité de chaque écran | design | À faire | WF2–WF5 | — |
| WB1 | `packages/api-client` : openapi-typescript + openapi-fetch depuis le contrat, test de fraîcheur | backend | Terminé (securite OK, qualite OK ; commit aea7937) | B1 | securite, qualite |
| WB2 | Contrat complété au fil des [QUESTION] de design, espace par espace ([CONTRAT]) | backend | Auth/Commun terminé (contrat 0.2.1, commit 045f6b4 ; WD1-S01 b en attente de décision) ; Commerçant à faire | questions design | securite, conformite |
| WF1 | Bibliothèque de composants codée (`/dev/composants`, hors production) | frontend | À faire | F1, WD2 validée | qualite, design, ux, conformite |
| WF2 | Écrans Commun + Playwright connexion | frontend | À faire | F2, WD1 validée, WB2 | securite, qualite, ux, design, conformite |
| WF3 | Écrans Commerçant + Playwright encaissement, simulation et demande de virement | frontend | À faire | WF2, WD3 validée | idem |
| WF4 | Écrans Entreprise + Playwright commande de crédits | frontend | À faire | WF2, WD4 validée | idem |
| WF5 | Écrans Administrateur + Playwright création de commerçant | frontend | À faire | WF2, WD5 validée | idem |

Critères de fin : pnpm lint, typecheck, test, build verts ; docker compose healthy ; /health conforme au contrat ; tous les écrans navigables (pnpm dev) en FR et AR (RTL) et petit écran ; Playwright vert sur les 5 parcours ; design OK, ux OK, qualite OK, conformite CONFORME, securite OK sans Critique ni Haute.

## Historique

| Date | Phase | Résultat | Rapport |
|---|---|---|---|
| 2026-10-09 | Préparation de l'équipe d'agents | Terminé (sans coéquipier lancé) | `reports/preparation-equipe-2026-10-09.md` |
| 2026-10-09 | Phase 0 – équipe réduite (design, securite, backend) | Terminé : D2, D3, B5, S5, S6 | `reports/phase0-equipe-reduite-2026-10-09.md` |
