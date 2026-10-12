# Revue qualité P0-F1 + P0-F3 : squelette `apps/web` et en-têtes de sécurité

- **Date** : 2026-10-12
- **Relecteur** : qualite (en parallèle de securite, qui juge les en-têtes, la CSP et les cookies)
- **Branche** : `feat/web`, rien n'est commité (`apps/` non suivi) ; aucun commit, aucun push, aucun changement de branche
- **Base de revue** : `[LIVRÉ]` de frontend. Fichiers : `apps/web/` (configurations, `src/`, `scripts/`, `test/`, `e2e/`) et `pnpm-lock.yaml`
- **Propriétaire** : `frontend` ; le constat F1-02 concerne aussi `design` (`packages/ui-tokens`) et F1-04 concerne aussi `backend` (`packages/config`)

## Verdict

**OK** (aucun Bloquant). Ouverts : Important 1 (F1-01), Améliorations 4 (F1-02 à F1-05).

Points forts :
- **Frontières du monorepo** : aucun import interne d'un autre paquet. `@flexipay/ui-tokens` n'est utilisé que par son point d'entrée `./tailwind-preset`. Aucun appel réseau hors du futur client `@flexipay/api-client`.
- **Typage** : `strict` hérité du socle. Aucun `any` ni `@ts-`. Un seul `eslint-disable`, justifié par écrit (`requestLocale` déprécié, `src/i18n/request.ts:9`).
- **Tokens** : le preset remplace la palette et les espacements par défaut de Tailwind (vérifié par test), et un test interdit les valeurs arbitraires (`-[…]`). J'ai vérifié à la main que chaque classe utilisée dans `src/` existe dans les tokens (espacements 1 à 12 sans 7/9/11, `size.*`, `radius.button`, `fontWeight.title`, écrans sm à xl).
- **i18n** : 3 catalogues par espace de noms, testés (mêmes clés que la référence FR, aucun message vide, mêmes variables, noms de langue écrits dans leur propre langue). Le test AST interdit le texte JSX en dur. Le RTL est vérifié par test unitaire et par Playwright.
- **Données fictives** : MSW est isolé dans `src/mocks/` et chargé par un import dynamique, éliminé du code mort en production. Un test inspecte un vrai build : il cherche le marqueur des fixtures, MSW et le worker, et un échantillon témoin prouve que la recherche détecte bien chaque motif. Aucun reste de `msw` ni du marqueur dans `.next/static` de mon propre build.
- **Aucune logique métier** dans le front (aucun montant, aucun calcul).
- **Tests de comportement observable** : en-têtes, proxy (nonce différent à chaque requête, en-têtes falsifiés ignorés, redirection), MSW Node, catalogues, composants, et e2e sur le build de production (CSP réelle, injection XSS bloquée, aucun service worker).
- **Composants client** limités au strict nécessaire : `LocaleSwitcher` (`usePathname`), `error.tsx` (imposé par Next) et `MockGate`.

## Points à juger soumis par frontend

| Point | Avis qualite |
|---|---|
| (a) `module: ESNext` / `moduleResolution: Bundler` | Accepté : c'est une exigence de Next. Les options strictes sont héritées du socle ; `declaration*` et `sourceMap` sont coupés à juste titre (`noEmit`) |
| (b) tests de conventions | Bons et utiles. Le test du texte en dur a un angle mort : voir F1-05 |
| (c) test de build de production dans Vitest | Le principe est bon (une preuve sur un vrai build). L'exécution dans `pnpm test` a des effets de bord : **F1-01** |
| (d) Playwright avec deux serveurs, `channel: 'chromium'`, locale fr-FR | Accepté. Le contournement de `build` pour le serveur e2e est documenté. Voir la remarque sur `waitForTimeout` plus bas |
| (e) `devIndicators: false` | Accepté, la raison est documentée dans `next.config.ts:12` |
| (f) aucun composant d'interface avant WD2 | Accepté. Les styles de bouton recopiés entre `error.tsx` et `not-found.tsx` disparaîtront avec le composant `Button` de WF1 (pas de constat d'ici là) |

## Constats

```
[CONSTAT] F1-01 Le test du build de production modifie l'arbre de travail pendant `pnpm test`
Gravité : Important
Fichier : apps/web/test/build/no-mocks-in-production.test.ts:69-86 ; package.json:12 ; next-env.d.ts
Problème : le `beforeAll` lance `pnpm build` (avec NEXT_DIST_DIR=.next-test) depuis la suite
  unitaire. Cela a deux effets de bord sur des fichiers que d'autres tâches utilisent en même
  temps :
  (1) `scripts/remove-mock-worker.mjs` supprime `public/mockServiceWorker.js` : un `pnpm dev`
      lancé au même moment perd son worker MSW, et `MockGate` reste vide sans message (voir F1-03) ;
  (2) Next réécrit `next-env.d.ts` vers `.next-test/types/…`. Constaté : avant mon build, le fichier
      pointait vers `.next-test` ; mon `pnpm build` l'a remis vers `.next`. Or turbo lance `test`,
      `typecheck` (`next typegen && tsc`, qui lit ce fichier) et `build` en parallèle : en CI (B6),
      trois processus écrivent ou lisent ce fichier en même temps, d'où un risque d'échec aléatoire.
  La suite unitaire devient aussi un deuxième build complet (10 à 15 s) à chaque `pnpm test`.
Correctif proposé : sortir ce test de `vitest run`, dans une tâche dédiée (par exemple
  `test:build` dans apps/web/turbo.json, `cache: false`, lancée après `build` et jamais en
  parallèle de `typecheck` ou de `dev`), ou bien l'intégrer au projet Playwright `built`, qui
  fait déjà un vrai build. Dans les deux cas, documenter que ce test arrête le worker d'un
  `pnpm dev` en cours. B6 devra l'appeler explicitement.
Référence : qualite §7 (tests fiables, sans effet de bord) ; CLAUDE.md « pnpm lint && pnpm typecheck && pnpm test »
```

```
[CONSTAT] F1-02 Double assertion sur le thème du preset de tokens
Gravité : Amélioration
Fichier : apps/web/tailwind.config.ts:7-18 ; apps/web/test/tokens/tailwind-config.test.ts:18 ;
  cause : packages/ui-tokens/generated/tailwind-preset.d.cts (type `{ theme: Record<string, unknown> }`)
Problème : `tokensPreset.theme as unknown as TokenTheme` réécrit à la main la forme des tokens et
  masque toute divergence. Si `focus.width` est renommé, Tailwind produit `undefinedpx` sans
  erreur. La fonction `color()` protège les couleurs, mais pas `size`, `motion` ni `focus`.
Correctif proposé : design génère un `.d.cts` précis (clés littérales de chaque groupe, dérivées
  du JSON) ; frontend supprime l'interface `TokenTheme` et le double `as`. D'ici là, il suffit de
  valider `size`, `motion` et `focus` à l'exécution, comme le fait déjà `color()`.
Référence : qualite §5 (aucune assertion qui masque une erreur, types issus de la source)
```

```
[CONSTAT] F1-03 MockGate : échec du démarrage des mocks avalé, page blanche sans message
Gravité : Amélioration
Fichier : apps/web/src/mocks/mock-gate.tsx:22-32
Problème : `void import('./browser').then(…)` n'a pas de `catch`. Si le worker ne démarre pas
  (fichier supprimé par un build, voir F1-01, ou bien un navigateur sans service worker), le
  rejet n'est pas traité et `ready` reste `false` : l'application rend `null`, sans état
  d'erreur. Seul le mode développement est concerné, mais l'erreur est avalée.
Correctif proposé : `catch` qui conserve l'erreur dans un état, puis `throw` au rendu pour
  atteindre `error.tsx`, ou un message de développement explicite (texte i18n) indiquant de
  relancer `pnpm dev`.
Référence : qualite §6 (aucune erreur avalée en silence, états d'erreur gérés)
```

```
[CONSTAT] F1-04 Liste no-restricted-globals recopiée au lieu d'étendre la liste partagée
Gravité : Amélioration
Fichier : apps/web/eslint.config.mjs:23-31 ; packages/config/eslint.js:38-41
Problème : en configuration plate, la règle redéfinie dans apps/web remplace celle du socle.
  frontend a donc recopié l'entrée `parseFloat`. Toute entrée ajoutée plus tard au socle (règles
  argent ou sécurité) sera perdue dans apps/web sans que personne ne s'en aperçoive.
Correctif proposé : backend exporte la liste (par exemple `restrictedGlobals`) depuis
  `@flexipay/config/eslint` ; frontend l'étend : `[...restrictedGlobals, { name: 'localStorage', … }]`.
  Même logique pour `no-restricted-syntax` si le socle en ajoute un jour.
Référence : qualite §3 (réutilisation plutôt que copie)
```

```
[CONSTAT] F1-05 Contrôle du texte en dur : expressions JSX non couvertes
Gravité : Amélioration
Fichier : apps/web/test/conventions/source-conventions.test.ts:69-103
Problème : le test AST relève `JsxText` et les attributs `aria-label="…"`, mais pas
  `{'Texte'}`, `{`Texte`}` ni `aria-label={'…'}` : un texte d'interface écrit sous forme
  d'expression passe sans être vu.
Correctif proposé : relever aussi les `StringLiteral` et `NoSubstitutionTemplateLiteral` placés
  directement dans une `JsxExpression` enfant d'un élément ou d'un attribut de texte, avec un cas
  témoin dans le test (sans nouvelle dépendance).
Référence : CLAUDE.md règle 15 (aucune chaîne en dur) ; qualite §8
```

## Remarques sans constat

- **Classes Tailwind inconnues** : Tailwind ignore une classe inexistante sans rien signaler. Une faute de frappe ou un token absent donne donc un élément sans style, et aucun test ne le voit. J'ai vérifié chaque classe à la main aujourd'hui ; à partir de WF1, un contrôle automatique serait utile (classes de `src/` générées dans la CSS compilée).
- `max-w-toast-max-width` sert de largeur aux pages 404 et erreur ; `auth-card-max-width` ou `form-max-width` paraissent plus justes. C'est un sujet de fidélité (design et ux), à revoir avec la spec WD1.
- `@flexipay/api-client` est déclaré mais pas encore importé : il le sera en F2 (page de santé), ce qui est cohérent.
- `NextIntlClientProvider` sans `messages` transmet au client tout le catalogue de la locale. Sans effet aujourd'hui (6 petits fichiers) ; à limiter par espace de noms quand les catalogues grossiront (WF2 à WF5).
- e2e `security.spec.ts:93` : `waitForTimeout(300)` est une attente fixe. `expect.poll` sur les violations serait plus fiable.
- Taille des bundles : `.next/static/chunks` fait 701 Ko non compressés (le plus gros fichier : 224 Ko), ce qui correspond au socle React + Next attendu pour un squelette. Turbopack n'affiche plus les tailles par route : la taille compressée n'est pas mesurée.

## Commandes et résultats (lancées par qualite, 2026-10-12, Node 22.14.0, pnpm 9.15.4)

`pnpm exec turbo run <tâche> --force --filter=@flexipay/web` (dépendances comprises) :

| Tâche | Résultat |
|---|---|
| lint | 3/3 réussies |
| typecheck | 3/3 réussies (`next typegen && tsc`) |
| test | 3/3 réussies ; web : **9 fichiers, 60 tests** réussis (10,9 s, dont le build de production du test) |
| build | 3/3 réussies ; Next 16.3.6 (Turbopack) : `/[locale]` et `/[locale]/[...rest]` dynamiques, proxy actif |
| Recherche `msw` et `__FLEXIPAY_MOCK` dans `.next/static` | aucun résultat |
| Recherche `any`, `@ts-`, `eslint-disable`, `console`, `TODO` dans `apps/web/src` | 1 `eslint-disable` justifié (`request.ts:9`), rien d'autre |

## Non vérifié

1. **Playwright** (`pnpm --filter @flexipay/web test:e2e`, 24 tests annoncés) : non relancé par qualite. La suite démarre deux serveurs (ports 3001 et 3002), qui pourraient entrer en conflit avec ceux d'autres agents, et les navigateurs sont installés hors du dépôt. Les spécifications ont été relues.
2. Taille compressée des bundles et Lighthouse : non mesurés.
3. Racine complète (`pnpm lint/typecheck/test/build` sans filtre) : non relancée, car le filtre couvre déjà web et ses dépendances (api-client, config).
4. Couverture mesurée : `@vitest/coverage-v8` absent.
5. Fidélité visuelle, accessibilité et justesse des en-têtes de sécurité : relèvent de design, ux et securite.
6. Clés de catalogue à la fois feuille et parent (`common.amount.a11y`, etc., signalées par frontend) : question de spec entre design et frontend pour WF1, hors du code livré.
