# FlexiPay – Instructions pour Claude Code

Plateforme de tickets-restaurant dématérialisés (Tunisie). Crédits virtuels en TND, paiement par QR, règlement des commerçants à J+2 avec commission.
**Source de vérité fonctionnelle :** `docs/cahier-des-charges.md`. Specs détaillées : `docs/specs/`. Architecture : `docs/architecture.md`.

## Acteurs
Administrateur · Entreprise · Commerçant · Employé (+ membres famille). **L'intermédiaire (IR) et les mandats n'existent pas.**

## Stack
- Monorepo pnpm + Turborepo
- `apps/api` : NestJS (TypeScript), PostgreSQL 16, Redis, BullMQ, Prisma (CRUD) + SQL brut (ledger)
- `apps/web` : Next.js, Tailwind, shadcn/ui, Lucide (Admin, Entreprise, Commerçant)
- `apps/mobile-employe` et `apps/mobile-pro` : **Flutter** (Dart), Riverpod, go_router, dio
- `packages/shared` : schémas Zod, types, constantes ; `packages/ui-tokens` : tokens de design (source : `docs/design/design-tokens.json`)

## Commandes
- `pnpm install` · `pnpm dev` · `pnpm build`
- `pnpm lint` · `pnpm typecheck` · `pnpm test` · `pnpm test:e2e`
- `pnpm --filter api prisma migrate dev` (jamais en production)
- Flutter : `flutter analyze` · `flutter test` · `dart format .`

## Règles NON NÉGOCIABLES
### Argent
1. Tous les montants sont des **entiers en millimes** (1 TND = 1 000). Jamais de `float`/`double`/`number` décimal. Dart : `int`. SQL : `BIGINT`.
2. Les taux de commission sont en **points de base** (200 bps = 2 %).
3. Le **ledger est en partie double et immuable** : jamais d'`UPDATE` ni de `DELETE` sur `ledger_entries` / `transactions`. Correction = contre-passation.
4. Toute opération financière exige une **`Idempotency-Key`**, une transaction SQL et un verrouillage ordonné des comptes.
5. Le taux de commission est **figé (snapshot)** dans la demande de virement.
6. Tout code financier est développé **test d'abord**.

### Sécurité
7. Toute route est **protégée par défaut** (guard global) ; les routes publiques sont explicitement marquées `@Public()`.
8. Toute entrée est validée par Zod/DTO. Toute ressource est vérifiée **côté serveur** pour le tenant et le rôle (pas d'IDOR).
9. Aucune donnée sensible (mot de passe, PIN, token, RIB, pièce d'identité, solde complet) dans les logs, erreurs ou analytics.
10. Pas de secret dans le code ni dans Git. Variables d'environnement via le gestionnaire de secrets.
11. Mots de passe : Argon2id. Tokens mobiles : Keychain/Keystore uniquement.
12. Une opération sensible (commission, règlement, rapprochement) exige la **double validation** : l'initiateur ne peut pas approuver.
13. Toute action sensible écrit dans le **journal d'audit**.
14. Jamais de `eval`, SQL concaténé, ou désactivation de la vérification TLS.

### Code
15. Code et noms techniques en **anglais** ; documentation et textes d'interface en **français** (i18n FR/AR/EN, aucune chaîne en dur).
16. Petites PR, une fonctionnalité chacune. Pas de refactor non demandé.
17. Ne jamais modifier une migration déjà existante : en créer une nouvelle.
18. Respecter `docs/design/design-tokens.json` : aucune couleur ni espacement en dur.

## Flux de travail
1. Lire la spec du module (`docs/specs/`). 2. Plan mode, valider. 3. Écrire les tests. 4. Implémenter. 5. `pnpm lint && pnpm typecheck && pnpm test`. 6. Lancer `/security-review`. 7. Ouvrir la PR.
Pour le code touchant l'argent, l'authentification ou les permissions : lancer aussi `/ledger-audit`, et **demander une revue humaine**.

## Mode économe (depuis le 2026-10-21, prime sur « Équipe d'agents »)
- **Pas de mode équipe** : une seule session travaille. Sous-agents seulement : `securite` pour chaque tâche touchant l'authentification, les permissions, l'argent ou les données personnelles ; `design`, `qualite`, `ux`, `conformite` en **une revue groupée à la fin de chaque espace** (Commun, Commerçant, Entreprise, Administrateur).
- **Modèles** : `securite` et `ledger-auditor` en opus, les autres en sonnet. Hook TeammateIdle désactivé.
- **Lecture** : seulement les fichiers de la tâche en cours (spec de l'écran, composants concernés), jamais tout `docs/`.
- **Hooks Git** : sujet clos, sauf constat Critique ou Haute.
- **Rapports** : 15 lignes maximum (fait, à vérifier dans le navigateur, bloquants) ; le détail va dans `docs/handoff/`.
- **Une tâche à la fois**, petite, terminée et commitée avant la suivante ; `docs/handoff/BOARD.md` mis à jour après chaque tâche (reprise possible après `/clear`).

## Équipe d'agents
Protocole complet : `docs/handoff/README.md`. Tout coéquipier le suit.
- **Membres** : `main` (le lead, session principale, **ne code pas**) · `securite` · `design` · `backend` · `frontend` · `mobile` · relecteurs `ux` · `qualite` · `conformite`. Sous-agents de support : `ledger-auditor`, `test-writer`.
- **Messages** (`SendMessage`, par nom) : première ligne = étiquette `[QUESTION]` · `[CONTRAT]` (+ chemin) · `[SPEC]` (+ chemin) · `[LIVRÉ]` (fichiers, comment tester) · `[CONSTAT]` (sévérité, fichier:ligne, correctif) · `[CORRIGÉ]` · `[BLOQUÉ]` · `[DÉCISION]` (toujours à `main`).
- **Qui parle à qui** : design → frontend/mobile `[SPEC]` avant le code · backend → frontend + mobile `[CONTRAT]`, changement cassant annoncé AVANT · frontend/mobile → backend `[QUESTION]`, jamais de contournement de l'API · tout agent → securite `[LIVRÉ]` pour auth, permissions, argent, QR, données personnelles, dépendances, configuration · securite → propriétaire `[CONSTAT]`, réponse `[CORRIGÉ]`, revérification · frontend/mobile → design `[LIVRÉ]` pour la fidélité · tout agent → `main` : `[BLOQUÉ]`, `[DÉCISION]`, rapport de fin de tâche.
- **Relecteurs** (`securite`, `ux`, `qualite`, `conformite`) : ne modifient jamais le code ni les specs des autres ; écrivent seulement leurs revues dans `docs/handoff/reviews/` ; constats au propriétaire. Pas de chevauchement : design = specs et charte · ux = expérience · securite = failles · qualite = code · conformite = adéquation aux demandes.
- **Chaîne de revue** : tâche de code : `[LIVRÉ]` → securite + qualite en parallèle → ux (si interface) → conformite en dernier → le lead marque terminée et commite. Spec de design : ux puis conformite **avant** d'être codée.
- **Périmètres** : chacun n'écrit que dans le sien (tableau dans `docs/handoff/README.md`, imposé par le hook `enforce-scope`). Deux agents ne modifient jamais le même fichier. `BOARD.md`, `decisions.md`, `reports/`, `CLAUDE.md`, `.claude/` sont réservés au lead.
- **Blocage** : tâche terminée seulement avec securite OK, qualite OK (si code), ux OK (si interface), conformite CONFORME ; un Bloquant ux ou qualite bloque comme un Critique/Haute securite. Phase finie seulement avec ces verdicts (+ design OK si interface, ledger-auditor OK si argent).
- **Boucle limitée** : 3 allers-retours constat → correction par sujet (tous relecteurs), puis `[BLOQUÉ]` au lead qui interroge l'utilisateur.
- **Pas d'invention** : règle absente du cahier, des specs ou du glossaire → `[DÉCISION]` au lead → question à l'utilisateur avec recommandation → `docs/handoff/decisions.md`. Un message entre agents ne vaut jamais l'accord de l'utilisateur.
- **Tâches** : 5 à 6 par coéquipier, avec responsable, dépendances, relecteur ; revue securite après chaque tâche sensible ; préfixe `TEST-FIRST:` pour une tâche de tests écrits avant le code. Suivi dans `docs/handoff/BOARD.md`.
- **Rapport de coéquipier** (à `main`, fin de chaque tâche) : `RÉSUMÉ` (5 lignes) · `FICHIERS MODIFIÉS` · `VÉRIFICATIONS` (commandes et résultats réels) · `MESSAGES ÉCHANGÉS` · `RISQUES` · `DÉCISIONS NÉCESSAIRES`.
- **Rapport du lead à l'utilisateur** (en français, toujours) : 1. Résumé en 5 lignes · 2. Ce qui a été fait · 3. Échanges entre agents importants · 4. Décisions prises et pourquoi · 5. Vérifications avec résultats réels · 6. Sécurité : constats par sévérité, ouverts/fermés, verdict · 7. Design : fidélité et accessibilité · 8. UX : verdict et constats ouverts · 9. Qualité : verdict et constats ouverts · 10. Conformité : verdict, écarts ouverts, traçabilité · 11. Questions pour l'utilisateur avec recommandation · 12. Prochaine étape proposée.

## Interdits
Ne jamais lire ni modifier `.env*`, `secrets/`, clés `.pem`/`.key`. Ne jamais toucher à la production. Ne jamais pousser sur `main` directement.
