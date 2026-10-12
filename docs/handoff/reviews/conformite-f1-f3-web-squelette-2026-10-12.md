# Revue de conformité : P0-F1 (squelette `apps/web`) et P0-F3 (en-têtes de sécurité web)

- **Date :** 2026-10-12 · **Relecteur :** conformite · **Branche :** `feat/web` (aucun commit, aucun push)
- **Base :** commit 736d0ca (73 fichiers dans `apps/web/` et `pnpm-lock.yaml`) ; fichiers lus : `package.json`, `README.md`, `src/mocks/*`, `src/lib/security/headers.ts`, `src/i18n/routing.ts`, `test/build/no-mocks-in-production.test.ts`, `test/i18n/catalogues.test.ts`, messages FR. Références : `BOARD.md` (titres de P0-F1 et P0-F3), plan « web d'abord » et décisions du 2026-10-11 et du 2026-10-12, CLAUDE.md règles 7, 15, 18, specs `navigation.md` et `fondations-composants.md`, contrat `openapi.yaml`.
- **Revues préalables :** securite **OK** (`securite-f1-f3-web-2026-10-12.md`) ; qualite **OK**, aucun constat ouvert (`qualite-f1-f3-web-squelette-2026-10-12.md`) ; ux : sans objet (une seule page de substitution « Squelette de l'application », aucun écran).
- **Remarque de chaîne :** le BOARD marque F1 et F3 « Terminé » (commit 736d0ca) avant ma revue ; cette revue est donc rétroactive.

## Verdicts

| Tâche | Verdict | Écart ouvert |
|---|---|---|
| **P0-F3** en-têtes de sécurité | **CONFORME** | aucun |
| **P0-F1** squelette `apps/web` | **NON CONFORME** (1 écart Basse) | F1-C1 : « shadcn/ui » du titre de F1 absent |

## Tableau de conformité

| Exigence ou critère | Référence | Constaté | Statut |
|---|---|---|---|
| Next.js App Router, TypeScript strict | BOARD P0-F1 ; CLAUDE.md « Stack » | `next` 16.3.6, `src/app/[locale]/…`, `tsconfig.json` ; `pnpm typecheck` vert (vérifié par qualite) | Conforme |
| Tailwind sur le preset `ui-tokens`, aucune couleur ni espacement en dur | BOARD P0-F1 ; CLAUDE.md r18 | `tailwind.config.ts`, `tailwind.tokens.ts` ; `test/tokens/*`, `test/conventions/source-conventions.test.ts` | Conforme |
| shadcn/ui | BOARD P0-F1 (titre) ; CLAUDE.md « Stack » ; `navigation.md` N.1, `dev-composants.md` §5 | ni `components.json`, ni composants `ui/`, ni Radix ni `class-variance-authority` ; seuls `clsx` et `tailwind-merge` | **Écart F1-C1** |
| Lucide | BOARD P0-F1 | `lucide-react` 1.48.0 | Conforme |
| i18n FR/AR/EN + RTL, FR par défaut, aucune chaîne en dur | BOARD P0-F1 ; CLAUDE.md r15 ; charte §9 | `routing.ts` (`fr`, `ar`, `en`, préfixe toujours présent) ; `direction.ts` (`ar` → `rtl`) ; catalogues FR/AR/EN avec exactement les mêmes clés et variables (`test/i18n/catalogues.test.ts`) ; endonymes testés | Conforme |
| Vitest + Playwright | BOARD P0-F1 | `vitest.config.ts`, `vitest.build.config.ts`, `playwright.config.ts`, `e2e/skeleton.spec.ts`, `e2e/production/security.spec.ts` | Conforme |
| Données fictives MSW dans `apps/web/src/mocks/`, typées par `packages/api-client` | BOARD plan « web d'abord » ; décision 2026-10-11 | `src/mocks/handlers.ts` : tableau vide, commentaire « typé par l'api-client » ; aucune donnée à contrôler | Conforme (rien encore à vérifier ; voir « Données fictives ») |
| MSW désactivé en production, prouvé par test | décision 2026-10-11 | `MockGate` : `NODE_ENV !== 'production'` ; `scripts/remove-mock-worker.mjs` avant `next build` ; `test/build/no-mocks-in-production.test.ts` (sentinelle, `setupWorker`, `mockServiceWorker`, paquet `msw`, marqueur de handlers ; scanner testé, faux positif de Next.js écarté) | Conforme |
| Aucune logique métier dans le front | plan « web d'abord » | aucun écran métier ; aucun calcul | Conforme |
| Pas de stockage navigateur de jetons | contrat §6 ; CLAUDE.md r9, r11 | README : pas de `localStorage` / `sessionStorage` / `document.cookie` ; cookie de langue seul, `SameSite=Strict`, `Secure` en production | Conforme |
| F3 : CSP stricte à nonce, sans `unsafe-inline` ni `unsafe-eval` en production | BOARD P0-F3 | `headers.ts` : `script-src 'self' 'nonce-…' 'strict-dynamic'`, `style-src` à nonce en production, `object-src 'none'`, `upgrade-insecure-requests` ; `test/security/headers.test.ts`, `proxy.test.ts` | Conforme |
| F3 : `frame-ancestors`, Referrer-Policy, X-Content-Type-Options | BOARD P0-F3 | `frame-ancestors 'none'`, `X-Frame-Options: DENY`, `Referrer-Policy: no-referrer`, `nosniff`, plus HSTS en production, Permissions-Policy, COOP/CORP | Conforme |
| F3 : cookies (tests) | BOARD P0-F3 ; contrat §6 (cookies posés par l'API) | cookie de langue testé ; cookies de session : à l'API (contrat), non applicable au front | Conforme |
| Rien d'interdit (IR, mandat, solde, secret) ; aucun secret dans le code | CLAUDE.md | aucune occurrence ; `src/lib/env.ts` validé par `test/lib/env.test.ts` | Conforme |
| Nouvelles dépendances justifiées et validées | décision 2026-10-11 (S1-03) | 21 dépendances directes ; revue securite OK | Conforme (validation utilisateur : à confirmer par `main`) |

## Écart

```
[CONSTAT] F1-C1 « shadcn/ui » du titre de P0-F1 non livré
Type : Oublié (BOARD inexact)
Référence : BOARD P0-F1 (« Next.js … Tailwind … shadcn/ui, Lucide, i18n … ») ; CLAUDE.md « Stack » ; `dev-composants.md` (AlertDialog, Table, Tabs…)
Constaté : aucun fichier de configuration shadcn (`components.json`), aucun composant `ui/`, ni dépendance sous-jacente (Radix, CVA). Le squelette ne contient que `clsx` et `tailwind-merge`.
Correctif attendu : soit l'initialisation de shadcn/ui est faite dans WF1 (bibliothèque de composants), avec ses dépendances justifiées et validées par l'utilisateur, et `main` ajuste le titre de P0-F1 au BOARD ; soit frontend l'ajoute à F1. Propriétaires : frontend, main.
```

## Données fictives : contrôle à appliquer à chaque livraison (WF2 à WF5)

Aujourd'hui `handlers.ts` est vide : rien n'est faux. Dès le premier handler, je vérifierai :
1. **Typage** : chaque réponse est typée par les schémas générés de `@flexipay/api-client` ; aucun `as` ni `any` pour faire passer une donnée.
2. **Millimes** : tout montant est un entier (`…Millimes`), sans décimale ni chaîne ; taux en `…Bps` ; exemples tirés du glossaire (45 000 → 900 → 44 100, E1, E4, E5).
3. **Erreurs RFC 9457** : `Content-Type: application/problem+json`, membres `type`, `title`, `status`, `code`, `messageKey`, `requestId` (+ `details` typés), jamais `detail` ni `instance` ; codes du catalogue du contrat.
4. **Statuts** : valeurs des énumérations du contrat et du glossaire (dont les statuts ajoutés par la décision n° 14), pas de libellé français dans une donnée.
5. **Refus de paiement commerçant** : `PAYMENT_DECLINED` sans `details`, aucun solde du client dans aucune réponse destinée au commerçant.
6. **Absence en production** : étendre `FORBIDDEN` du test de build aux comptes de test (`@flexipay.test`, `Test1234!`, code fictif MFA) ; la page de connexion ne les affiche qu'en développement.
7. **Pas de logique métier dans les handlers** qui ne soit pas dans une fixture déclarative (commission, plafond, solde calculés en dur = écart).
Je demande à frontend un test qui valide chaque réponse simulée contre le schéma OpenAPI (valeur, pas seulement le type TypeScript).

## Non vérifié

1. Exécution des tests : reprise des résultats de qualite (lint 8/8, typecheck 7/7, test 8/8, build 5/5, test de build 5/5), non relancés par conformite.
2. `e2e/` : non exécuté (Chromium).
3. Validation par l'utilisateur des 21 dépendances directes (décision 2026-10-11 S1-03) : non vérifiable depuis les fichiers.
