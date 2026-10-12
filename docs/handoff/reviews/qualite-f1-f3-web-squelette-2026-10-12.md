# Revue qualité P0-F1 + P0-F3 : squelette `apps/web` et en-têtes de sécurité

- **Date** : 2026-10-12 (revue initiale et revérification)
- **Relecteur** : qualite (en parallèle de securite, qui juge les en-têtes, la CSP et les cookies)
- **Branche** : `feat/web`, rien n'est commité (`apps/` non suivi) ; aucun commit, aucun push, aucun changement de branche
- **Base de revue** : `[LIVRÉ]` de frontend, puis son `[CORRIGÉ]` F1-01 à F1-05. Fichiers : `apps/web/` (configurations, `src/`, `scripts/`, `test/`, `e2e/`) et `pnpm-lock.yaml`
- **Propriétaire** : `frontend` (F1-02 touche aussi `design`, F1-04 touche aussi `backend`)

## Verdict

**OK** (aucun Bloquant). Après revérification (aller-retour 1 sur 3) : **F1-01 à F1-05 fermés, aucun constat ouvert**.

Restes hors de ce sujet :
- **design** : le type précis de `tailwind-preset.d.cts` (suite de F1-02, simple confort désormais, puisque apps/web valide les tokens à l'exécution).
- **backend** : l'appel à `turbo run test:build` en CI (B6). L'export `restrictedGlobals` n'est plus nécessaire, car frontend étend `safetyRules['no-restricted-globals']`.

Points forts :
- **Frontières du monorepo** : aucun import interne d'un autre paquet. `@flexipay/ui-tokens` n'est utilisé que par son point d'entrée `./tailwind-preset`.
- **Typage** : `strict` hérité du socle. Aucun `any` ni `@ts-`. Un seul `eslint-disable`, justifié par écrit (`src/i18n/request.ts:9`).
- **Tokens** : le preset remplace les valeurs par défaut de Tailwind (vérifié par test), les valeurs arbitraires sont interdites par test, et j'ai vérifié chaque classe utilisée à la main.
- **i18n** : 3 catalogues par espace de noms, testés (mêmes clés que la référence FR, aucun message vide, mêmes variables, noms de langue écrits dans leur propre langue) ; texte en dur interdit par un test AST, avec témoins positifs et négatifs ; RTL testé.
- **Données fictives** : MSW est isolé dans `src/mocks/` et chargé par un import dynamique, éliminé du code mort en production. Son absence du build est prouvée par `test:build`, avec un échantillon témoin pour chaque motif recherché.
- **Aucune logique métier** dans le front.
- **Tests de comportement observable**, dont l'e2e sur le build de production.

## Points à juger soumis par frontend

| Point | Avis qualite |
|---|---|
| (a) `module: ESNext` / `moduleResolution: Bundler` | Accepté : c'est une exigence de Next, et les options strictes sont héritées du socle |
| (b) tests de conventions | Bons ; l'angle mort F1-05 est fermé |
| (c) test du build de production | Il ne lance plus de build : il est passé dans `test:build`, après `build` (F1-01 fermé) |
| (d) Playwright avec deux serveurs, `channel: 'chromium'`, locale fr-FR | Accepté |
| (e) `devIndicators: false` | Accepté (raison documentée) |
| (f) aucun composant d'interface avant WD2 | Accepté. Les styles de bouton recopiés entre `error.tsx` et `not-found.tsx` disparaîtront avec le composant `Button` de WF1 |

## Constats (revue initiale)

```
[CONSTAT] F1-01 Le test du build de production modifie l'arbre de travail pendant `pnpm test`
Gravité : Important — FERMÉ le 2026-10-12
Fichier : apps/web/test/build/no-mocks-in-production.test.ts:69-86 ; package.json:12 ; next-env.d.ts
Problème : le `beforeAll` lançait `pnpm build` depuis la suite unitaire, avec deux effets de bord :
  (1) suppression de `public/mockServiceWorker.js`, ce qui casse un `pnpm dev` en cours ;
  (2) réécriture de `next-env.d.ts` vers `.next-test`, en concurrence avec `typecheck` et `build`
      que turbo lance en parallèle. Risque d'échecs aléatoires en CI.
Correctif proposé : tâche dédiée lancée après `build` (ou projet Playwright `built`), documentée.
Référence : qualite §7
```

```
[CONSTAT] F1-02 Double assertion sur le thème du preset de tokens
Gravité : Amélioration — FERMÉ le 2026-10-12
Fichier : apps/web/tailwind.config.ts:7-18 ; test/tokens/tailwind-config.test.ts:18 ;
  cause : packages/ui-tokens/generated/tailwind-preset.d.cts
Problème : `as unknown as TokenTheme` masquait tout écart (un token renommé donnait `undefinedpx`).
Correctif proposé : type précis généré (design) ou validation à l'exécution (frontend).
Référence : qualite §5
```

```
[CONSTAT] F1-03 MockGate : échec du démarrage des mocks avalé, page blanche sans message
Gravité : Amélioration — FERMÉ le 2026-10-12
Fichier : apps/web/src/mocks/mock-gate.tsx:22-32
Problème : `void import(...).then()` n'avait pas de `catch` ; l'application restait vide.
Correctif proposé : `catch` puis relance de l'erreur au rendu, pour atteindre `error.tsx`.
Référence : qualite §6
```

```
[CONSTAT] F1-04 Liste no-restricted-globals recopiée au lieu d'étendre la liste partagée
Gravité : Amélioration — FERMÉ le 2026-10-12
Fichier : apps/web/eslint.config.mjs:23-31 ; packages/config/eslint.js:38-41
Problème : la règle redéfinie remplaçait celle du socle, d'où l'entrée `parseFloat` recopiée.
Correctif proposé : étendre la liste du socle.
Référence : qualite §3
```

```
[CONSTAT] F1-05 Contrôle du texte en dur : expressions JSX non couvertes
Gravité : Amélioration — FERMÉ le 2026-10-12
Fichier : apps/web/test/conventions/source-conventions.test.ts:69-103
Problème : `{'Texte'}`, `{`Texte`}` et `aria-label={'…'}` n'étaient pas détectés.
Correctif proposé : relever aussi les littéraux placés dans une `JsxExpression`, avec des cas témoins.
Référence : CLAUDE.md règle 15
```

## Revérification (`[CORRIGÉ]` de frontend, aller-retour 1 sur 3)

| Constat | État | Preuve |
|---|---|---|
| F1-01 | **Fermé** | `vitest.config.ts` exclut `test/build/**`. Script `test:build` (`vitest.build.config.ts`) et tâche turbo `test:build` (`dependsOn: ["build"]`, `cache: false`, `apps/web/turbo.json:8-12`). Le test ne fait plus que lire la sortie (`NEXT_DIST_DIR ?? .next`, en ignorant `cache/` et `dev/`). La suppression du worker est testée dans un dossier temporaire (`remove-mock-worker.mjs` accepte une racine en argument). Après `test`, `build` et `test:build`, `next-env.d.ts` pointe bien vers `.next` |
| F1-02 | **Fermé** | `tailwind.tokens.ts` : `readTokens` valide `size`, `motion`, `focus`, les couleurs de focus et `motion.skeleton`, avec un message qui nomme le token fautif ; plus de `as unknown as` dans `tailwind.config.ts`. Il reste une conversion `as Record<string, unknown>` après un contrôle d'exécution (`record()`, ligne 25) : légitime. Test `test/tokens/tokens-validation.test.ts` (preset réel, puis renommage, mauvais type, token manquant → erreur nommée) |
| F1-03 | **Fermé** | `mock-gate.tsx:211-225` : `catch`, puis relance de l'erreur au rendu. Test `test/mocks/mock-gate.test.tsx` : l'échec du worker atteint le composant d'erreur, et l'application n'est pas rendue |
| F1-04 | **Fermé** | `eslint.config.mjs:259-266` : `...safetyRules['no-restricted-globals']` (sévérité et `parseFloat` du socle) complété par `localStorage` et `sessionStorage` |
| F1-05 | **Fermé** | `findHardcodedText` (`source-conventions.test.ts:110-143`) : texte JSX, `{'x'}`, `{`x`}`, attributs de texte littéraux ou en expression ; 6 témoins positifs et 4 négatifs (`:87-107`) |

Nouveau depuis la revue initiale, relu sans constat : `scripts/dev.mjs` (lanceur du serveur de développement). Il copie le worker, supprime les `AGENTS.md`/`CLAUDE.md` que `next dev` écrit quand il détecte un agent (constat securite F1-S02), filtre les variables d'environnement des agents et transmet les signaux d'arrêt au processus enfant. Le code est lisible et commenté. Un test de conventions vérifie l'absence de ces fichiers.

## Remarques sans constat

- **Classes Tailwind inconnues** : Tailwind ignore une classe inexistante sans le signaler. Un contrôle automatique sera utile à partir de WF1, quand les composants arriveront.
- `max-w-toast-max-width` sert de largeur aux pages 404 et erreur ; c'est un sujet de fidélité pour design et ux (spec WD1).
- `NextIntlClientProvider` transmet au client tout le catalogue de la locale. À limiter par espace de noms quand les catalogues grossiront.
- e2e `security.spec.ts` : `waitForTimeout(300)` est une attente fixe ; `expect.poll` serait plus fiable.
- Taille des bundles : `.next/static/chunks` fait 701 Ko non compressés (revue initiale), ce qui correspond au socle React + Next attendu.
- Le test `build script` vérifie aussi le texte du script `build` dans `package.json` : c'est un garde-fou volontaire, couplé à l'implémentation, et je l'accepte.

## Commandes et résultats (lancées par qualite, Node 22.14.0, pnpm 9.15.4)

`pnpm exec turbo run <tâche> --force --filter=@flexipay/web` (dépendances comprises), `NEXT_TELEMETRY_DISABLED=1` :

| Tâche | Revue initiale | Revérification |
|---|---|---|
| lint | 3/3 | 3/3 |
| typecheck | 3/3 | 3/3 |
| test | 3/3 ; web : 9 fichiers, 60 tests (build compris) | 3/3 ; web : **10 fichiers, 87 tests**, sans build |
| build | 3/3 (Next 16.3.6, Turbopack) | 3/3 |
| test:build | — | 4/4 ; **5 tests** (contrôle de la recherche, script de build, sortie de production sans MSW ni données fictives) |
| Recherche `msw` et `__FLEXIPAY_MOCK` dans `.next/static` | aucun résultat | couvert par `test:build` |

## Non vérifié

1. **Playwright** (26 réussis et 1 ignoré annoncés par frontend) : non relancé par qualite (deux serveurs sur les ports 3001 et 3002, risque de conflit avec d'autres agents) ; spécifications relues.
2. Taille compressée des bundles et Lighthouse : non mesurés.
3. Racine complète sans filtre : non relancée, car le filtre couvre web et ses dépendances.
4. Couverture mesurée : `@vitest/coverage-v8` absent.
5. Fidélité visuelle, accessibilité et en-têtes de sécurité : relèvent de design, ux et securite.
6. Appel de `turbo run test:build` en CI : à brancher par backend en B6.
