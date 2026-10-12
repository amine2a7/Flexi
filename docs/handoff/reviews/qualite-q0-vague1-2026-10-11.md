# Revue qualité Q0 : rétroactive de la vague 1 (B1, B2, D1, B4)

- **Date** : 2026-10-11 (revérifications : D1 et Q0-03 le 2026-10-12)
- **Relecteur** : qualite
- **Branche** : `feat/web` (aucun commit, aucun push, aucun changement de branche)
- **Base de revue** : `git show` de 98add0a (B1), 4431e45 (B2), a63412b (D1), 7606a7a (B4) ; fichiers à HEAD (12c66bf). Revue securite parallèle déjà rendue : `securite-p0-s1-vague1-2026-10-11.md`. Revérifications : arbre de travail de `packages/ui-tokens/` (`[CORRIGÉ]` de design) et de `packages/config/` (`[CORRIGÉ]` Q0-03 de backend)
- **Propriétaires** : `backend` (B1, B2, B4), `design` (D1)

## Verdict

| Tâche | Verdict | Bloquant | Important ouvert | Amélioration ouverte |
|---|---|---|---|---|
| P0-B1 monorepo, `packages/config`, racine (98add0a + correctif Q0-03) | **OK** | 0 | 0 (Q0-03 fermé) | 4 (Q0-10, Q0-11, Q0-13, Q0-14) |
| P0-B2 `packages/shared` (4431e45) | **OK** | 0 | 0 | 1 (Q0-12) |
| P0-D1 `packages/ui-tokens` (a63412b + correctifs) | **OK** | 0 | 0 (Q0-01 fermé) | 2 (Q0-07, Q0-08 différés) ; Q0-06, Q0-09 fermés |
| P0-B4 `infra/` (7606a7a) | **OK sur lecture** (intégration non exécutée, Docker arrêté) | 0 | 1 (Q0-02) | 2 (Q0-04, Q0-05) |

**Verdict Q0 : OK** (aucun Bloquant). Ouverts au 2026-10-12 : Important 1 (Q0-02, backend), Amélioration 9 (Q0-04, Q0-05, Q0-07, Q0-08, Q0-10 à Q0-14). Fermés : Q0-01, Q0-03, Q0-06, Q0-09. Q0-14 est noté ici mais n'a pas encore été envoyé à backend : l'utilisateur a demandé l'arrêt (STOP) le 2026-10-12.

Points forts constatés : TypeScript strict complet (`noUncheckedIndexedAccess`, `verbatimModuleSyntax`, `useUnknownInCatchVariables`), ESLint `strictTypeChecked` + `stylisticTypeChecked` + `reportUnusedDisableDirectives`, interdiction de `parseFloat` et `toFixed`, aucun `any`, aucun `@ts-ignore`, aucun `eslint-disable`, aucun `TODO`. Montants en millimes entiers bornés au contrat (0..2^53-1), bps 0..10 000, `tndToMillimes` qui refuse les fractions ; tests de comportement observables (47 tests). Générateur de tokens sans valeur en dur (vérifié par test), contrastes AA testés, sorties neutralisées (S1-08). Socle Testcontainers lisible, `releaseAll` testé.

## Points signalés par les producteurs

| Point | Avis qualite |
|---|---|
| B4 lit `startedTestContainer.inspectResult` (non public) | Confirmé : `startedTestContainer` est `protected` et `inspectResult` est `private` dans Testcontainers 11.14.0 ; une API publique existe → **Q0-02 Important** |
| Placement dependencies / devDependencies | Correct partout : `@flexipay/config` met en `dependencies` ce que `eslint.js` importe (`@eslint/js`, `eslint-config-prettier`, `typescript-eslint`) et `eslint` / `typescript` en peer + dev ; `shared` : `zod` seul en dépendance ; `testing-infra` : `testcontainers`, `@testcontainers/*`, `pg` en dépendances (importés par `src/`), `ioredis` et `@types/pg` en dev (tests seulement ; `dist/*.d.ts` ne référence pas `pg`) ; `ui-tokens` : aucune dépendance d'exécution. Seule amélioration : versions répétées (Q0-13) |
| `pnpm.overrides` limités à une majeure | Sélecteurs `nom@^majeure` : l'override cesse de s'appliquer quand le parent change de majeure, c'est sain. Exception : `uuid@^10` → `11.1.1` franchit une majeure (dérogation décidée le 2026-10-11) ; dockerode 4.0.12 n'utilise que `require("uuid").v4` (`lib/session.js:4`), présent en uuid 11 : compatible. Les versions exactes figent les correctifs futurs → Q0-10 Amélioration |
| ui-tokens relâche `restrict-template-expressions` (`allowNumber`) | Accepté : limité à `src/**` et `test/**` du paquet, justifié en commentaire, aucun montant manipulé. Pas de constat |

## Constats

```
[CONSTAT] Q0-01 Le build régénère les fichiers commités et neutralise le test de fraîcheur
Gravité : Important — FERMÉ le 2026-10-12
Fichier : packages/ui-tokens/package.json:19-20 (scripts generate et build identiques)
Problème : `build` = `tsc && node dist/generate.js` écrit `generated/*.cjs|.d.cts` et
  `dart/lib/flexipay_tokens.dart`, fichiers suivis par git (constaté : `pnpm build` affiche
  « wrote generated/tailwind-preset.cjs … »). Conséquences : (1) en CI, `pnpm build` puis
  `pnpm test` compare les fichiers fraîchement régénérés à eux-mêmes : un JSON modifié sans
  `generate` commité passe au vert, le test « committed generated files are up to date » ne
  protège plus rien ; (2) un build modifie des sources suivies ; (3) turbo ne déclare que
  `dist/**` en sorties : sur un cache hit, les fichiers générés ne sont pas restaurés (incohérent
  selon le cache) ; (4) deux scripts identiques.
Correctif proposé : `build` = `tsc -p tsconfig.build.json` seulement ; `generate` reste le seul
  script qui écrit `generated/` et `dart/` ; le test de fraîcheur reste le garde-fou (ou un mode
  `generate --check` qui échoue sans écrire). À signaler à backend pour B6 : `git diff --exit-code`
  après build et test en CI.
Référence : CLAUDE.md règle 18 (tokens = source unique) ; README du paquet « un test échoue s'ils ne sont pas à jour »
```

```
[CONSTAT] Q0-02 Lecture de champs privés de Testcontainers par double assertion
Gravité : Important
Fichier : infra/testing/src/containers.ts:34-46 (publishedHostIps), :68 et :76 (hostBindingIps)
Problème : `container as unknown as { startedTestContainer: { inspectResult: … } }` contourne
  `protected startedTestContainer` (abstract-started-container.d.ts:5) et `private inspectResult`
  (started-generic-container.d.ts:10). Le double `as` masque toute erreur de type : une mise à jour
  de Testcontainers (même un correctif) renommant ces champs donne une TypeError à l'exécution,
  sans erreur de compilation. Donnée utile seulement aux tests, mais exposée dans l'API publique
  du paquet (`StartedPostgres.hostBindingIps`, `StartedRedis.hostBindingIps`).
Correctif proposé : API publique de Testcontainers, dans le test d'intégration :
  `const client = await getContainerRuntimeClient();`
  `const info = await client.container.inspect(client.container.getById(id));`
  puis `info.NetworkSettings.Ports` (exposer `containerId` via `getId()` au lieu de
  `hostBindingIps`), ou au minimum une fonction qui valide la forme à l'exécution et échoue avec
  un message explicite. Supprime aussi la cause de Q0-04.
Référence : qualite §5 (aucune assertion `as` qui masque une erreur)
```

```
[CONSTAT] Q0-03 Pas de règle no-console dans la configuration ESLint partagée
Gravité : Important — FERMÉ le 2026-10-12
Fichier : packages/config/eslint.js:16-37 (safetyRules) et :59-63
Problème : rien n'empêche un `console.log` dans `apps/api` (qui aura un logger avec masquage, B3)
  ni dans `apps/web` (F1 démarre). C'est à la fois un reste de débogage et un risque de fuite de
  données sensibles hors du logger masqué (règle 9, sujet securite). Il est moins coûteux de
  l'interdire avant B3 et F1 que de le relever écran par écran.
Correctif proposé : `'no-console': 'error'` dans la config partagée ; dérogation explicite et
  locale pour les scripts CLI (`packages/ui-tokens/src/generate.ts`, futurs scripts) par
  surcharge `files` dans leur `eslint.config.mjs`.
Référence : qualite §11 ; CLAUDE.md règle 9
```

```
[CONSTAT] Q0-04 startRedis ne libère pas le conteneur si une étape suivant start() échoue
Gravité : Amélioration
Fichier : infra/testing/src/containers.ts:127-140
Problème : `startPostgres` arrête le conteneur en cas d'échec après `start()` (try/catch,
  :105-123), pas `startRedis` : si `publishedHostIps` lève (cas de Q0-02), le conteneur reste
  lancé (Ryuk désactivé). Incohérence entre les deux fonctions.
Correctif proposé : même try/catch que startPostgres (ou disparaît avec le correctif de Q0-02).
Référence : qualite §6 (gestion des erreurs)
```

```
[CONSTAT] Q0-05 Test qui vérifie PostgreSQL plutôt que le code, avec une assertion trop large
Gravité : Amélioration
Fichier : infra/testing/test/integration/postgres.test.ts:73-80
Problème : « enforces a non-negative balance with a CHECK constraint » crée sa propre table et
  vérifie que PostgreSQL applique un CHECK : aucun code du projet n'est testé. `.rejects.toThrow()`
  passerait aussi pour une erreur de syntaxe ou de connexion.
Correctif proposé : le retirer (il reviendra, utile, sur la vraie table des soldes dans apps/api),
  ou au minimum vérifier le code SQLSTATE `23514` (check_violation). Même remarque pour
  `/NOAUTH/` côté Redis : correct, à garder.
Référence : qualite §7 (pertinence des tests)
```

```
[CONSTAT] Q0-06 Références du thème Dart non vérifiées contre les tokens
Gravité : Amélioration — FERMÉ le 2026-10-12
Fichier : packages/ui-tokens/src/dart.ts:233-316
Problème : `FlexiTheme.light()` référence en dur `FlexiColors.navy`, `onNavy`, `emerald`,
  `textMuted`, `borderStrong`, `overlay`, `FlexiTypeScale.amountXl`, `FlexiRadius.cardMobile`,
  `FlexiSize.touchTargetMobile`, etc. Si un token est renommé dans le JSON, le Dart généré ne
  compile plus, et aucun test Node ne le voit (Flutter absent : la compilation Dart est reportée,
  décision du 2026-10-11). Les statuts, eux, sont vérifiés (`assertSafeTokens`).
Correctif proposé : liste des noms de tokens utilisés par le thème, vérifiée dans
  `assertSafeTokens` (comme `status.bg/fg`) ; un test qui renomme `navy` attend une erreur.
Référence : qualite §6, §7
```

```
[CONSTAT] Q0-07 Source JSON chargée sans validation de forme
Gravité : Amélioration — DIFFÉRÉ (ouvert)
Fichier : packages/ui-tokens/src/tokens.ts:47-49
Problème : `JSON.parse(...) as Tokens` : l'assertion affirme la forme sans la vérifier. Un
  groupe absent ou une valeur du mauvais type donne une erreur peu lisible plus loin, ou une
  valeur `NaN`/`undefined` dans le preset Tailwind (le test `not.toMatch(/undefined|NaN/)` ne
  couvre que le Dart).
Correctif proposé : valider à la lecture (schéma Zod, déjà dans le workspace, en devDependency
  du paquet) et renvoyer un message qui nomme le token fautif ; `Tokens` = `z.infer` du schéma.
Référence : qualite §5 (aucune assertion `as` qui masque une erreur)
```

```
[CONSTAT] Q0-08 renderDart : fonction de 215 lignes
Gravité : Amélioration — DIFFÉRÉ (ouvert)
Fichier : packages/ui-tokens/src/dart.ts:105-319
Problème : une seule fonction produit toutes les sections (couleurs, tailles, police, échelle,
  statuts, thème). Linéaire, mais longue à relire et à faire évoluer (thème sombre à venir).
Correctif proposé : une fonction par section (`renderColors`, `renderTypeScale`,
  `renderStatus`, `renderTheme`…) assemblées par `renderDart`. Sortie octet à octet inchangée
  (le test de fraîcheur le garantit).
Référence : qualite §4 (complexité)
```

```
[CONSTAT] Q0-09 Point d'entrée src/index.ts inutilisé
Gravité : Amélioration — FERMÉ le 2026-10-12
Fichier : packages/ui-tokens/src/index.ts:1-4 ; package.json:7-13
Problème : `exports` n'expose que `./tailwind-preset` ; `src/index.ts` (compilé en
  `dist/index.js`) n'est importé ni par le paquet, ni par les tests (qui importent les modules
  directement) : code mort.
Correctif proposé : le supprimer, ou l'exposer explicitement s'il a un consommateur prévu.
Référence : qualite §11
```

```
[CONSTAT] Q0-10 Overrides exacts : figent les correctifs futurs, sans échéance tracée
Gravité : Amélioration
Fichier : package.json:28-49
Problème : 20 versions exactes de dépendances transitives. Le sélecteur `@^majeure` est bien
  limité, mais une version exacte bloque aussi les correctifs de sécurité ultérieurs (ex. un
  vite 8.3.2 correctif ne sera pas pris). La justification (S1-06, dérogations du 2026-10-11) vit
  dans la revue securite et le message de commit, pas à côté du code (JSON sans commentaire).
  `uuid@^10` → `11.1.1` franchit une majeure (vérifié compatible : dockerode n'utilise que `v4`).
Correctif proposé : tâche B6 explicite « retirer les overrides » avec contrôle d'âge en CI
  (décision du 2026-10-11) ; d'ici là, une ligne par override dans un fichier tracé (raison,
  date, condition de retrait). Faire tourner `pnpm test:integration` (dockerode + uuid 11) dès
  que Docker revient.
Référence : qualite §10 (dépendances) ; décision du 2026-10-11 (S1-06)
```

```
[CONSTAT] Q0-11 test:e2e : no-op qui réussit
Gravité : Amélioration
Fichier : package.json:16
Problème : `pnpm test:e2e` affiche un message et sort en 0 : en CI (B6) ce serait un vert sans
  aucun test. Code de substitution.
Correctif proposé : `turbo run test:e2e` (vide aujourd'hui, réel dès F1 avec Playwright), ou
  sortie non nulle tant qu'aucune suite n'existe et pas d'appel en CI avant F1.
Référence : qualite §11
```

```
[CONSTAT] Q0-12 Schémas Zod alignés à la main sur le contrat, sans test de dérive
Gravité : Amélioration
Fichier : packages/shared/src/money.ts:15-29, rate.ts:9 ; test/money.test.ts:17-21
Problème : les bornes (`AmountMillimes` 0..9007199254740991, `PositiveAmountMillimes` min 1,
  `RateBps` 0..10000, `Currency`, `Direction`) sont recopiées du contrat
  (`openapi.yaml:541-575`) ; les tests comparent à des littéraux, pas au contrat. Avec WB1, les
  types générés par openapi-typescript seront une seconde source : une modification du contrat
  ne ferait échouer aucun test de shared.
Correctif proposé : un test de shared qui lit `docs/handoff/contracts/openapi.yaml` et compare
  minimum/maximum/enum aux constantes (backend possède les deux fichiers).
Référence : qualite §5 (types issus du contrat) ; décision du 2026-10-11 (contrat d'abord)
```

```
[CONSTAT] Q0-13 Versions d'outillage répétées dans chaque package.json
Gravité : Amélioration
Fichier : packages/shared/package.json:26-32, packages/ui-tokens/package.json:25-31,
  infra/testing/package.json:30-38, packages/config/package.json:24-31
Problème : `eslint 10.11.0`, `typescript 6.0.3`, `vitest 4.1.11`, `@types/node 22.20.4`
  recopiés à chaque paquet ; apps/api et apps/web vont en ajouter deux copies. Une montée de
  version oubliée à un endroit crée deux versions dans l'arbre.
Correctif proposé : catalogue pnpm (`catalog:` dans `pnpm-workspace.yaml`, disponible en
  pnpm 9.5+) pour l'outillage partagé.
Référence : qualite §3, §10
```

```
[CONSTAT] Q0-14 Dérogation no-console accordée selon le nom de fichier, dans tout le dépôt
Gravité : Amélioration — NON ENVOYÉ (STOP de l'utilisateur, 2026-10-12)
Fichier : packages/config/eslint.js:10 (cliFiles) et :75-78
Problème : `'**/scripts/**/*'` et `'**/generate.{ts,…}'` désactivent `no-console` pour tout
  fichier de ce nom, dans n'importe quelle app. Un futur `apps/api/src/…/invoices/generate.ts`
  (génération de factures, code métier) ou un dossier `scripts/` côté web échapperait à la règle
  sans que personne ne l'ait décidé.
Correctif proposé : garder la règle stricte dans la config partagée et déclarer la dérogation
  dans le `eslint.config.mjs` de chaque paquet concerné (`src/generate.ts` de ui-tokens,
  `scripts/codegen.ts` d'api-client), ou restreindre les motifs à `packages/*/scripts/**` ;
  ajouter un cas de test « generate.ts sous apps/ refusé » si le motif reste global.
Référence : qualite §11 ; CLAUDE.md règle 9
```

## Revérification D1 (`[CORRIGÉ]` de design, aller-retour 1/3, 2026-10-12)

| Constat | État | Preuve |
|---|---|---|
| Q0-01 | **Fermé** | `package.json:20` : `build` = `tsc -p tsconfig.build.json` ; `generate` (`:19`) seul script qui écrit. Empreintes SHA-256 et dates de `generated/tailwind-preset.cjs`, `generated/tailwind-preset.d.cts`, `dart/lib/flexipay_tokens.dart` identiques avant et après `turbo run build --force` ; aucune ligne `wrote` dans la sortie |
| Q0-06 | **Fermé** | `src/dart.ts:102-146` : table `THEME_REQUIRED` (13 couleurs, 10 styles, 3 rayons, 3 tailles) et `assertThemeTokens`, appelée en tête de `renderDart` (`:157`) ; test « rejects a token that FlexiTheme.light() depends on (rename of navy) » (`test/generation.test.ts:219-226`), message qui nomme le token |
| Q0-09 | **Fermé** | `src/index.ts` supprimé ; aucun import de `@flexipay/ui-tokens` hors `./tailwind-preset` (seul consommateur : `apps/web/tailwind.config.ts:3`) |
| Q0-07 | **Différé, accepté** (Amélioration ouverte) | Ajouter `zod` à `ui-tokens` est une modification de dépendances : décision S1-03 (chaque ajout validé par l'utilisateur). Couverture partielle en attendant : `assertSafeTokens` + `assertThemeTokens`. À arbitrer par le lead |
| Q0-08 | **Différé, accepté** (Amélioration ouverte) | Non bloquant ; refactor protégé par le test de fraîcheur, à planifier (par exemple avec le thème sombre) |

Remarque : les fichiers générés diffèrent de HEAD (8 tailles ajoutées au JSON et clé `status.INCONNU`, travail de design en cours) ; le test de fraîcheur passe, ils correspondent donc au JSON courant.

## Revérification Q0-03 (`[CORRIGÉ]` de backend, aller-retour 1/3, 2026-10-12)

| Constat | État | Preuve |
|---|---|---|
| Q0-03 | **Fermé** | `packages/config/eslint.js:21` : `'no-console': 'error'` dans `safetyRules` ; dérogation `cliFiles` (`:10`, `:75-78`). Test `packages/config/test/eslint-config.test.mjs` (node:test, sans nouvelle dépendance), 3 cas : refus dans `src/`, autorisation dans `scripts/` et `generate`, règles argent toujours actives → 3/3. La portée de la dérogation fait l'objet de Q0-14 (Amélioration) |

## Commandes et résultats (lancées par qualite, Node 22.14.0, pnpm 9.15.4)

Revue initiale (2026-10-11) :

| Commande | Résultat |
|---|---|
| `pnpm lint --force` (sans cache Turbo) | 5/5 tâches réussies, 0 en cache (config, shared, ui-tokens, testing-infra, + api-client non commité) |
| `pnpm typecheck --force` | 4/4 réussies, 0 en cache |
| `pnpm exec turbo run test --force --continue` | shared **47/47**, ui-tokens **87/87**, testing-infra **12/12** (unitaires) ; échec de `@flexipay/api-client#test` : « No test files found » (WB1 alors en cours) |
| `pnpm exec turbo run build --force --continue` | shared, ui-tokens, testing-infra réussis ; échec de `@flexipay/api-client#build` : TS18003 « No inputs were found » ; ui-tokens affiche `wrote generated/…` (Q0-01) ; fichiers générés inchangés (`git status`) |
| `pnpm format:check` | « All matched files use Prettier code style! » |
| Recherche `any`, `as unknown`, `@ts-`, `eslint-disable`, `TODO`, `console.` dans le code de Q0 | 0 `any`/`@ts-`/`eslint-disable`/`TODO` ; 1 `console.log` légitime (CLI `generate.ts`) ; assertions : Q0-02, Q0-07 ; `PortBindings as …` accepté (le type d'origine est `any` dans @types/dockerode) |

Revérification D1 (2026-10-12), `pnpm exec turbo run <tâche> --force --filter=@flexipay/ui-tokens` :

| Tâche | Résultat |
|---|---|
| lint | 1/1 réussie |
| typecheck | 1/1 réussie |
| test | **87/87** (dont le nouveau test Q0-06 ; le test « no colour literal » de `index.ts` disparaît avec le fichier) |
| build | 1/1 réussie ; aucun fichier suivi réécrit (empreintes identiques) |

Revérification Q0-03 (2026-10-12), `pnpm exec turbo run <tâche> --force --filter='./packages/*' --filter='./infra/*'` (apps/web exclu, non livré) :

| Tâche | Résultat |
|---|---|
| lint | 5/5 réussies (`no-console` actif partout) |
| typecheck | 4/4 réussies |
| test | config 3/3, shared 47/47, ui-tokens 87/87, api-client 13/13, testing-infra 12/12 |
| build | 4/4 réussies |

## Non vérifié

1. `pnpm test:integration` (Testcontainers : PostgreSQL 16, Redis, liaison 127.0.0.1, RLS, dockerode avec uuid 11) : Docker arrêté, non relancé.
2. `docker compose -f infra/docker-compose.yml up` (santé des services) : Docker arrêté.
3. Compilation Dart et `flutter test` du paquet `dart/` : Flutter absent (décision du 2026-10-11).
4. Couverture de code mesurée : `@vitest/coverage-v8` n'est pas installé dans le workspace ; je n'ai rien ajouté. Couverture évaluée à la lecture (toutes les fonctions exportées de shared et testing-infra ont un test ; ui-tokens couvert par les tests de génération).
5. Consommation réelle du preset Tailwind par `apps/web` (version de Tailwind, valeurs numériques d'`opacity`) : à vérifier en F1.
6. Ajout en CI de `git diff --exit-code` après build et test (suggestion liée à Q0-01) : B6, non livré.
7. Q0-03 dans `apps/web` : lint d'`apps/web` non lancé (en cours chez frontend, non livré).
