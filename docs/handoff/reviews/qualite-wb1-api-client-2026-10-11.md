# Revue qualité WB1 : `packages/api-client`

- **Date** : 2026-10-11
- **Relecteur** : qualite
- **Branche** : `feat/web` (aucun commit, aucun push, aucun changement de branche)
- **Base de revue** : `[LIVRÉ]` de backend (WB1) ; fichiers non commités `packages/api-client/` (package.json, eslint.config.mjs, tsconfig*.json, vitest.config.ts, src/codegen.ts, src/generate.ts, src/index.ts, src/generated/schema.ts, test/freshness.test.ts, test/client.test.ts) ; `docs/handoff/contracts/openapi.yaml` (lecture). Revérification après `[CORRIGÉ]` : scripts/codegen.ts, src/index.ts, tsconfig*.json, package.json, test/*.ts
- **Propriétaire** : `backend`

## Verdict

**OK** (aucun Bloquant). Après revérification (1er aller-retour) : **WB1-01 à WB1-04 fermés**, 0 constat ouvert.

Points forts : génération explicite (`build` ne génère pas, contrairement à Q0-01), le même code
sert au script et au test de fraîcheur (comparaison octet à octet avec la configuration Prettier du
dépôt) ; montants `int64` générés en `number` (`AmountMillimes: number`), cohérents
avec `packages/shared` ; `exports` limité à `.` ; types issus du contrat et non réécrits ; fichier
généré exclu du lint mais inclus dans le typecheck ; aucun `any`, `@ts-`, `eslint-disable`, `TODO`
ni `console`. Dépendances justifiées : `openapi-fetch` (exécution), `openapi-typescript` et
`prettier` (génération, dev). Décision du 2026-10-11 (openapi-typescript + openapi-fetch) respectée.

## Constats (revue initiale)

```
[CONSTAT] WB1-01 isProblem affirme un type plus précis que ce qu'il vérifie
Gravité : Important
Fichier : packages/api-client/src/index.ts:53-62
Problème : la garde renvoie `value is ProblemBase`, mais ne vérifie que `typeof code === 'string'`.
  Or `ProblemBase.code` est l'union fermée `ProblemCode` ('VALIDATION_FAILED' | …),
  et `type`/`title` (requis) ne sont pas vérifiés. Un code inconnu (API plus récente, proxy,
  erreur 502 d'une passerelle au format proche) est typé comme un code connu : un `switch` exhaustif
  du front compilera avec un `default` jugé inatteignable, et l'état d'erreur générique ne sera pas
  forcé par le typage.
Correctif proposé : (a) `enumValues: true` et vérifier `code` ∈ ProblemCode ; ou (b) réduire le
  type affirmé à ce qui est vérifié. Test : `code: 'UNKNOWN_CODE'`.
Référence : qualite §5, §6
```

```
[CONSTAT] WB1-02 Le générateur est compilé et livré avec le client
Gravité : Amélioration
Fichier : packages/api-client/tsconfig.build.json:8 ; src/codegen.ts, src/generate.ts
Problème : `dist/` contient `codegen.js` et `generate.js`, qui importent des devDependencies.
Correctif proposé : déplacer dans `scripts/` (typecheck et lint seulement, hors build).
Référence : qualite §2, §11
```

```
[CONSTAT] WB1-03 Test des montants : n'affirme que l'absence de bigint
Gravité : Amélioration
Fichier : packages/api-client/test/freshness.test.ts:13-16
Problème : un passage des montants en `string` ne serait pas détecté.
Correctif proposé : affirmer `AmountMillimes: number;`, `PositiveAmountMillimes: number;`, `RateBps: number;`.
Référence : qualite §7 ; CLAUDE.md règle 1
```

```
[CONSTAT] WB1-04 Tests du middleware CSRF : assertions de type et import dynamique inutiles
Gravité : Amélioration
Fichier : packages/api-client/test/client.test.ts:77-102
Problème : `options: {} as never`, `(out as Request)`, `await import(...)` alors que le module est importé.
Correctif proposé : import statique ; test via `createApiClient` + `fakeFetch` dès qu'une route POST existe (WB2).
Référence : qualite §5, §7
```

## Revérification (`[CORRIGÉ]` de backend, aller-retour 1/3)

| Constat | État | Preuve |
|---|---|---|
| WB1-01 | **Fermé** | `scripts/codegen.ts` : `openapiTS(…, { enumValues: true })` → `problemCodeValues` généré ; `src/index.ts` : `isProblem(value): value is ApiProblem` (`code: string`, `details?: unknown`), vérifie `type` (motif URN), `title`, `status`, `code`, `messageKey`, `requestId` ; `isKnownProblemCode(code): code is ProblemCode`. Tests : `UNKNOWN_CODE` accepté comme Problem et refusé comme code connu ; `about:blank` et `title: 3` refusés |
| WB1-02 | **Fermé** | `scripts/codegen.ts` (module + CLI), inclus dans `tsconfig.json` seulement ; `generate` = `node --experimental-strip-types …` ; `dist/` = `index.*` + `generated/` uniquement |
| WB1-03 | **Fermé** | `test/freshness.test.ts` affirme `AmountMillimes: number;`, `PositiveAmountMillimes: number;`, `RateBps: number;` et l'absence de `bigint` |
| WB1-04 | **Fermé** | Imports statiques ; helper `runOnRequest` avec contrôle `instanceof Request`. Reste une assertion de test `{} as Parameters<OnRequest>[0]['options']` : typée, limitée au helper de test, acceptée. Test via route POST reporté à WB2 (attendu) |

Remarque sans constat : `lib: DOM` ajoutée à `tsconfig.json` et `tsconfig.build.json` (Request/Response d'un client navigateur) : cohérent.

## Remarque sans constat

- `openapi-typescript` 7.13.0 déclare `typescript ^5.x` en peer ; le dépôt est en 6.0.3. Le test de
  fraîcheur couvre la génération ; à surveiller à chaque montée de version (signalé par backend).

## Commandes et résultats (lancées par qualite, 2026-10-11)

| Commande | Revue initiale | Revérification |
|---|---|---|
| `pnpm exec turbo run lint --force --filter=@flexipay/api-client` | réussie | réussie |
| `pnpm exec turbo run typecheck --force --filter=@flexipay/api-client` | réussie | réussie |
| `pnpm exec turbo run test --force --filter=@flexipay/api-client` | 9/9 | **11/11** |
| `pnpm exec turbo run build --force --filter=@flexipay/api-client` | réussie | réussie ; `dist/` sans outillage |
| `npx prettier --check packages/api-client` | — | conforme |

## Non vérifié

1. Racine complète (`pnpm lint/typecheck/test/build` sans filtre) : `apps/` est en cours chez frontend (non livré), hors périmètre de WB1.
2. Couverture mesurée : `@vitest/coverage-v8` absent du workspace.
3. Usage réel depuis `apps/web` (composants serveur, MSW) : à vérifier en F1/F2.
4. Test du middleware CSRF via une route POST du client : attend WB2.
5. `pnpm audit` des nouvelles dépendances : sujet securite.
