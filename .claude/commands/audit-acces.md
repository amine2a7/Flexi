---
description: Diagnostiquer puis corriger le contrôle d'accès (serveur, web, MSW) et les pages en erreur
argument-hint: [périmètre, ex. « admin » ou « tous les espaces »]
---
Audit du contrôle d'accès sur `$ARGUMENTS` (par défaut : les 3 espaces web). Deux phases, dans l'ordre. **Phase 1 sans rien corriger**, rapport de 15 lignes, puis phase 2.

## Phase 1 — Diagnostic
**Référence :** la matrice des sous-rôles dans `docs/handoff/decisions.md` (dernière décision « Rôles »), `apps/api/src/common/permissions.ts`.

a. **Serveur.** Lance `pnpm --filter @flexipay/api exec vitest run --config vitest.integration.config.ts test/integration/admin-matrix.test.ts`. Le test appelle en HTTP chaque route admin avec chaque sous-rôle et compare à `EXPECTED`. Il échoue si une route admin n'a pas d'entrée. Pour un autre espace, copie ce modèle (table `EXPECTED` par route `Controller.method`). Restitue un tableau `route | sous-rôle | attendu | obtenu`. Une réponse autorisée là où l'on attend 403 est un constat **CRITIQUE**. Signale les routes de la matrice qui n'existent pas encore (404).

b. **Web.** Vérifie que :
- le menu (`components/layout/nav-config.ts` + `space-layout.tsx`), les pages et les boutons passent par `lib/session/permissions.ts` (`canOpen`, `useCan`, `useCanOpen`). Les chercher : `grep -rn "\.POST\|\.PUT" src/app` ; chaque action doit être conditionnée par la permission de sa route ;
- MSW applique la même table : `mocks/handlers/permission-gate.ts` + `mocks/fixtures/route-permissions.json`. Le test `apps/api/test/unit/mock-route-permissions.test.ts` doit être vert. Sinon, régénère le JSON depuis `routePermissionTable()` (`apps/api/test/route-permission-table.ts`).

c. **Pages en erreur.** Lance `apps/web/e2e/pages-sweep.spec.ts` : il ouvre chaque page de chaque espace, suit le premier lien de détail et relève les erreurs de page et de console, les écrans d'erreur, les `/v1` en ≥ 400 et les pages sans `h1`. Pour chaque page en échec, donne la cause **réelle** (stack, réponse API), pas le symptôme.

## Phase 2 — Correctif
Un commit par point, tests d'abord :
1. Serveur (matrice + `EXPECTED`), puis revue `securite` (sous-agent) obligatoire.
2. Web : `PAGE_PERMISSIONS` dans `lib/session/permissions.ts`, actions et liens conditionnés, « Accès refusé » (`layout.pageForbidden`) pour une page ouverte par son URL, compteurs du menu sans appel interdit. MSW : JSON régénéré.
3. Une correction par page listée en 1c, avec un test qui reproduit l'erreur avant le correctif.
4. Playwright : `apps/web/e2e/admin-subroles.spec.ts` (menu exact par sous-rôle, « Accès refusé », boutons absents), à étendre aux sous-rôles entreprise et commerçant.

## Pièges connus (constatés le 2026-10-25)
- **Mode du serveur 3001.** `pnpm dev` utilise MSW, `pnpm dev:api` l'API réelle (`localhost:3000`). Vérifie-le avant de conclure : l'hôte des réponses `/v1`, ou `response.fromServiceWorker()`. Un seul `next dev` peut tourner par dossier.
- **Playwright local.** La config du dépôt démarre aussi un build de production (délai dépassé). Utilise une config temporaire **non commitée**, avec un seul `webServer` (`pnpm dev`, `reuseExistingServer: true`), `workers: 1` et `channel: 'msedge'` (Chromium Playwright non installé). Supprime-la à la fin.
- **Visite guidée.** À la première connexion, elle rend la page inerte : tous les `h1` disparaissent (faux « no h1 »). `e2e/sign-in.ts` la ferme (`dismissTour`).
- **Prisma.** Un `prisma generate` après une modification du schéma, sans migration appliquée, provoque des 500 sur toute requête à la table concernée. Applique la migration avec `pnpm --filter @flexipay/api db:migrate` (jamais `.env`).
- **i18n.** Les JSON de `src/messages` sont plus récents que `scripts/i18n/ns-*.cjs` : **ne relance pas `gen.cjs`**. Ajoute les clés FR/EN/AR directement dans les JSON, et dans la source.
- **Git Bash.** Il réécrit les arguments `/chemin` : préfixe avec `MSYS_NO_PATHCONV=1` et passe les scripts Node en chemin `C:/…`.
- **Enchaînements.** Pas de `vitest … | grep && git commit` : grep réussit même quand les tests échouent. Vérifie le résultat, puis commite.
- **Hooks React en test.** Ajoute `// @vitest-environment jsdom` en tête du fichier.
- **Animations.** L'horodatage du premier `requestAnimationFrame` peut précéder `start` : borne toute progression à [0, 1].

## Rapport
15 lignes maximum, en français : constats par sévérité, commits, vérifications (commandes et résultats réels), comptes à utiliser pour revérifier (mot de passe `Test1234!`, MFA `123456`). Le détail va dans `docs/handoff/reviews/acces-<AAAA-MM-JJ>.md`.

Comptes du seed (identiques dans MSW) :
- Administrateur : super-admin `admin@`, Finance `admin2@`, Opérations `operations@`, Support `support@` ;
- Entreprise : `entreprise@`, RH `rh@`, Comptable `comptable@`, Lecture `lecture@` ;
- Commerçant : `commercant@`, `caissier@`, `comptable-commerce@`.

Tous en `@flexipay.test`.
