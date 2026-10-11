# Revue securite : P0-S1, vague 1 (B1, B2, B4, D1) et revérification de P0-S9

- **Date** : 2026-10-11
- **Relecteur** : securite
- **Branche** : `feat/p0-vague1` (créée depuis `fix/cf-chaine-dev`). Aucun commit ni push de securite.
- **Base de revue** : partie 1 : `.claude/settings.json` et `.claude/hooks/*` à 6f018cd ; partie 2 : fichiers listés dans chaque `[LIVRÉ]` + `git status` / `git diff` de la branche.
- **Propriétaires** : lead (`main`) pour `.claude/` ; `backend` pour B1, B2, B4 ; `design` pour D1.

## Verdicts

| Tâche | Verdict | Constats ouverts |
|---|---|---|
| Revérification P0-S9 (CF-02/S9-02, S9-01, N-01, N-02) | **OK avec réserves** (aucun Critique ni Haute) | S1-03 Moyenne, S1-04 Basse (lead) |
| Revérification de 594f06e (S1-01, S1-02) puis de l'index (S1-09, S1-10) | **OK avec réserves** : S1-01, S1-02, S1-09 et S1-10 **fermés** | S1-11 Moyenne (lead ; boucle épuisée, décision utilisateur) |
| P0-B1 (98add0a) | **OK** | S1-07 Basse (backend en B6, lead au README) ; S1-05 et S1-06 fermés |
| P0-B2 (4431e45) | **OK** | aucun |
| P0-B4 | **OK sur lecture**, exécution à confirmer quand Docker répondra (voir partie 4) | aucun constat ; DC-5 côté Compose reporté à la première migration (backend → main) |
| P0-D1 (a63412b) | **OK** | aucun (S1-08 Basse fermé) |

**Verdict S1 : OK** (B4 sur lecture, exécution à confirmer quand Docker répondra). Aucun Critique
ni Haute ouvert. Ouverts : Moyenne 2 (S1-03, S1-11), Basse 2 (S1-04, S1-07). Commits contrôlés : 98add0a contient `onlyBuiltDependencies: []` ;
a63412b contient `assertSafeTokens` (correctif S1-08). Au moment de la revue, `pnpm-lock.yaml` est
modifié hors commit (probablement B4) : il sera relu avec B4.

## Partie 1 : revérification de P0-S9

### État des points ouverts

| Point | État | Preuve |
|---|---|---|
| N-01 gitleaks absent | **Fermé** | `gitleaks version` → `8.30.1` ; `gitleaks protect --help` existe encore dans cette version ; `gitleaks git --staged` disponible |
| N-02 Docker | **Fermé** | `docker info` → serveur `29.8.2`, « Docker Desktop (containerized) » |
| CF-02 / S9-02 | **Partiellement fermé** | Hook exécuté comme fichier, vrai gitleaks, dépôt jetable du scratchpad : index propre → 0 ; secret indexé → 2 ; `-am` → 2 ; `--all` → 2. Résiduel : **S1-01** (staging dans la même commande, commit par chemin, options abrégées ou entre guillemets) |
| Faux positif signalé par le lead | **Confirmé, qualifié Basse** | **S1-02**. Reproduit en réel deux fois sur mes propres commandes (`grep -i` et `-q`… dans la même ligne qu'un `git commit` → bloqué) |
| S9-01 / CF-04 | **Fermé en configuration, effet réel non garanti** | `settings.json` contient maintenant `ask` sur `pnpm i`, `pnpm install` (nus), `pnpm create *`, `pnpm * create *`, `pnpm exec *`, `pnpm * exec *`. Mais en réel, dans cette session (mode auto), `pnpm exec node --version` et `pnpm install --help` se sont exécutés **sans qu'aucune demande d'approbation ne me soit signalée** : **S1-03**. Trous restants dans la liste : **S1-04** |
| S9-03 | **Fermé** | `protect-files.js` : `…/server.pem::$DATA` → 2 ; `secrets/dev.env.example` → 2 (secrets testé avant l'exemption) ; `NotebookEdit` vers `secrets/a.ipynb` → 2. Nom court : le hook résout l'ancêtre existant avec `fs.realpathSync.native` (lecture, `protect-files.js:27-37`) ; `MIGRAT~1` inexistant → 0, normal (aucune migration existante ne peut être désignée par un nom court inexistant). Test sur une vraie migration impossible : `apps/` n'existe pas encore |
| S9-04 | **Fermé** | `enforce-scope.js` : entrée `null` → 2, `[]` → 2 ; securite → `docs/security/a.md` → 0, → `packages/a.ts` → 2 |

### Constats

```
[CONSTAT] S1-01 Scan gitleaks contourné quand l'indexation a lieu dans la même commande (résiduel de S9-02)
Sévérité : Moyenne
Fichier : .claude/hooks/guard-bash.sh:9-35
Preuve : hook exécuté comme fichier (CLAUDE_PROJECT_DIR = dépôt, cwd = dépôt jetable du
  scratchpad), vrai gitleaks 8.30.1, faux jeton ghp_ généré à l'exécution :
  - fichier non indexé contenant le jeton : « git add s.txt && git commit -m x » → 0,
    « git add . ; git commit -m x » → 0. Le hook s'exécute AVANT toute la commande : au moment
    du scan, l'index ne contient pas encore le fichier ;
  - fichier suivi modifié non indexé : « git commit -m x s.txt » → 0 ; « … -- s.txt » → 0 ;
    « git commit "-a" -m x » → 0 ; « git commit '--all' -m x » → 0 (les guillemets restent
    dans le jeton testé, git les retire) ; « --inc s.txt » → 0 et « --onl s.txt » → 0 (git
    accepte les abréviations non ambiguës des options longues) ; « --no-verif » → 0 ;
  - exécution réelle dans le dépôt jetable : les commits « --inc », « chemin » et « "-a" »
    ont abouti ; « gitleaks git . » sur cet historique → « leaks found: 1 ».
Scénario d'attaque : le lead commite chaque tâche en une seule commande
  « git add <fichiers> && git commit -m … » (forme la plus courante). Un agent backend a laissé
  dans packages/config un jeton GitHub de test réel (ou un .env.local copié sous un autre nom).
  Le scan s'exécute sur un index encore vide : « 0 commits scanned », le commit passe. Plus
  tard, « git push » est approuvé par l'utilisateur qui croit le scan actif : le secret est
  publié sur GitHub (GIT-1). La CI gitleaks (B6) n'existe pas encore.
Correctif proposé (vérifié dans un dépôt jetable) : un vrai hook git versionné, exécuté par git
  APRÈS l'indexation, sur l'index réel du commit (y compris l'index temporaire de -a et des
  chemins) :
    .githooks/pre-commit
      #!/bin/sh
      command -v gitleaks >/dev/null 2>&1 || { echo "gitleaks absent : commit refusé" >&2; exit 1; }
      exec gitleaks git --staged --redact --no-banner --exit-code 1 .
    + « git config --local core.hooksPath .githooks » (à ajouter au README §14, par poste).
  Résultat mesuré avec ce hook : -a, chemin, --inc, --onl, "-a", « git add && git commit »,
  alias « git -c alias.ci=commit ci -am » → tous refusés (code 1). Seuls passent
  « git commit -n » (= --no-verify) et « git -c core.hooksPath=… commit ». Donc guard-bash
  n'a plus qu'à : (1) refuser --no-verify, ses abréviations (--no-v…) et -n dans un groupe
  d'options courtes du segment commit ; (2) refuser toute mention de « hookspath » (insensible
  à la casse) dans une commande git, et « git config … --unset core.hooksPath » ; (3) avant
  un commit, vérifier « git config --get core.hooksPath » = .githooks, sinon échec fermé.
  Le contrôle « -a/--all/--include/--only » de guard-bash devient inutile (cause de S1-02).
  Garder gitleaks bloquant en CI sur tout l'historique (B6).
Exigence : GIT-1, DEV-4 / ASVS 14.3.x, 2.10.4 (V13.3.1 en ASVS 5.0)
```

```
[CONSTAT] S1-02 guard-bash : faux positifs du contrôle des options de commit (constat du lead du 2026-10-11)
Sévérité : Basse
Fichier : .claude/hooks/guard-bash.sh:11-24 (boucle « for tok in $cmd »)
Preuve : hook exécuté comme fichier :
  « sed -i 's/a/b/' f.txt ; git commit -m x » → 2 (« -i ») ;
  « grep -i foo f && git commit -m x » → 2 ; « git log -n 3 && git commit -m x » → 2 ;
  « git commit -m 'docs: option -n de pnpm' » → 2 ; « git commit -m 'feat: add -a flag' » → 2.
  Reproduit en réel sur deux de mes propres commandes pendant cette revue.
  Cause : toute la commande est découpée en jetons (y compris les autres segments et le texte
  du message), et les guillemets ne sont pas interprétés.
Qualification : pas de faille par lui-même (le contrôle échoue fermé). Risque indirect : un
  garde-fou qui bloque des commandes légitimes pousse à le contourner (commit à la main hors
  agent, désactivation temporaire du hook, reformulation qui évite le motif), ce qui affaiblit
  GIT-1. D'où Basse.
Correctif proposé : avec S1-01, le contrôle se réduit à --no-verify / -n / hooksPath. Pour
  l'appliquer sans faux positif :
  1) n'analyser que le segment de la commande qui contient « git … commit » (couper sur
     « ; », « && », « || », « | », saut de ligne) ;
  2) découper ce segment avec un petit analyseur Node sans dépendance (lib/shell-words.js :
     gère '…', "…" et « \ ») plutôt qu'avec le découpage de bash, afin que « "-n" » soit vu
     comme -n (pas de contournement par guillemets) et que « -m 'option -n' » soit un seul
     argument ;
  3) ignorer l'argument qui suit -m, -F, -C, -c, --message, --file, --author, --date,
     --reuse-message, --fixup, --squash (et les formes collées -mmsg, --message=…).
  Pour le faux positif SQL (« update transactions » dans un message, S9-07) : appliquer le
  motif ledger seulement aux segments qui ne sont pas un « git commit ».
Exigence : DEV-4 / ASVS 1.14.x (configuration sûre de l'outillage)
```

**État au 2026-10-11 (commit 594f06e) : S1-01 et S1-02 fermés**, détail en partie 3. Les
contournements résiduels et un nouveau faux positif font l'objet de S1-09 et S1-10.

```
[CONSTAT] S1-03 Les règles « ask » de settings.json ne garantissent pas une approbation humaine selon le mode de permission
Sévérité : Moyenne
Fichier : .claude/settings.json:7 (allow « Bash(pnpm *) ») et :20-38 (ask)
Preuve : dans cette session de sous-agent (mode auto actif), deux commandes couvertes par un
  motif ask se sont exécutées sans qu'aucune demande d'approbation ne me soit signalée :
  « pnpm exec node --version » (ask « pnpm exec * ») → exécutée (sortie :
  ERR_PNPM_RECURSIVE_EXEC_NO_PACKAGE) ; « pnpm install --help » (ask « pnpm install * ») →
  exécutée (aide affichée). Je ne peux pas savoir si l'utilisateur a vu et validé une
  demande, ou si le mode auto l'a approuvée à sa place (voir « Non vérifié »).
Scénario d'attaque : un agent backend, sous injection de prompt (README de dépendance,
  message d'erreur piégé, DEV-3), lance « pnpm create flexipay-helper » ou
  « pnpm --filter api add nestjs-zod-valdiation » (typosquatting, SC-1). Si le mode auto
  l'approuve sans humain, le paquet et ses scripts s'exécutent sur le poste personnel
  (jetons GitHub, dépôt, gestionnaire d'identifiants) avant toute revue.
Correctif proposé : ne pas faire reposer SC-1 sur le seul mode de permission. Ajouter une
  barrière indépendante du mode, dans un hook PreToolUse (code 2) : pour un appel portant un
  agent_id (sous-agent ou coéquipier), refuser « pnpm add / dlx / create / exec / up /
  update / upgrade / rebuild », « pnpm install|i » avec un nom de paquet, « npx », « pnpx »,
  « npm i|install », « flutter pub add », « dart pub add », avec le message : « demande à
  main ; l'utilisateur lance la commande ». Autoriser « pnpm install --frozen-lockfile » et
  « pnpm install --offline » (lockfile relu). Le premier « pnpm install » qui crée le
  lockfile de B1 est alors lancé par l'utilisateur (ou par le lead après son accord). Garder
  la relecture securite de chaque diff de package.json et pnpm-lock.yaml.
Exigence : SC-1, DEV-3 / ASVS 14.2.4 (V15.2.x en ASVS 5.0)
```

```
[CONSTAT] S1-04 Liste ask : commandes pnpm qui récupèrent ou exécutent du code encore absentes
Sévérité : Basse
Fichier : .claude/settings.json:20-38
Preuve : lecture. Aucun motif ask ne couvre : « pnpm up », « pnpm update », « pnpm upgrade »
  (nouvelles versions résolues, SC-4) ; « pnpm rebuild » (relance les scripts d'installation,
  SC-3) ; « pnpm -F api i <paquet> », « pnpm --filter api install » et « pnpm -r install »
  sans argument final (motifs « pnpm * i * », « pnpm * i », « pnpm * install » absents ; je
  ne sais pas si « pnpm * install * » couvre la forme sans argument final) ; « pnpm env use »
  (télécharge un binaire Node) ; « pnpm self-update ».
Scénario d'attaque : un agent lance « pnpm up --latest » pour « corriger » un avertissement :
  toutes les dépendances passent à la dernière version publiée, y compris une version
  compromise publiée la veille (SC-4), et les scripts d'installation s'exécutent.
Correctif proposé : couvert par le hook de S1-03. À défaut, ajouter en ask « pnpm up* »,
  « pnpm * up* », « pnpm update* », « pnpm * update* », « pnpm upgrade* », « pnpm rebuild* »,
  « pnpm * rebuild* », « pnpm * i », « pnpm * i * », « pnpm * install », « pnpm env * »,
  « pnpm self-update* ». Variante plus sûre (déjà proposée en S9-01) : remplacer
  « allow Bash(pnpm *) » par une liste explicite (lint, typecheck, test, build, dev,
  --filter * lint|typecheck|test|build, audit, install --frozen-lockfile).
Exigence : SC-1, SC-3, SC-4 / ASVS 14.2.4
```

## Partie 2 : livraisons de la vague 1

Base de revue : fichiers non suivis (aucun commit de la vague 1). Liste fournie par `main` dans son
rappel `[LIVRÉ]` du 2026-10-11, contrôlée par `git status --short` et `find`.

### P0-B1 et P0-B2 : OK

Verdicts rendus à backend avant une interruption de session, avec trois constats Basses. Leur
texte, perdu lors de l'interruption, a été renvoyé par backend le 2026-10-11 et est recopié ci-dessous.

```
[CONSTAT] S1-05 Liste blanche des builds : un paquet absent autorisé d'avance
Sévérité : Basse
Fichier : package.json:26-29 (pnpm.onlyBuiltDependencies ["esbuild"])
Preuve : esbuild absent de l'arbre (vite 8 utilise rolldown et lightningcss précompilés).
Scénario d'attaque : le jour où un outil tire esbuild en transitif, son script d'installation
  s'exécute sans revue.
Correctif proposé : "onlyBuiltDependencies": [] ; ajouter un paquet seulement à son entrée dans
  le lockfile, justifié dans le [LIVRÉ] ; vérifier qu'en pnpm 9.15 un tableau vide = aucun build.
Exigence : SC-3
```
**Fermé (revérifié).** `package.json` → `"onlyBuiltDependencies": []`. backend : `pnpm install`
annonce « build scripts that were ignored: cpu-features, protobufjs, ssh2 ». De mon côté : aucun
répertoire `build/` pour ces paquets, `pendingBuilds: []`, esbuild absent du lockfile.

```
[CONSTAT] S1-06 Dépendances transitives publiées depuis moins de 14 jours
Sévérité : Basse
Fichier : pnpm-lock.yaml
Preuve : vite 8.3.4 (08/10), rolldown 1.2.13 (07/10), @oxc-project/types 0.153.0, nanoid 3.3.20
  et postcss 8.5.29 (05/10), acorn 8.19.0 (05/10), ignore 7.0.12 (02/10).
Scénario d'attaque : version compromise d'un mainteneur tirée dans la fenêtre de détection
  habituelle, exécutée à chaque pnpm test.
Correctif proposé : pnpm.overrides vers la version précédente (≥ 14 jours), ou dérogation notée
  et validée par le lead ; contrôle CI en B6.
Exigence : SC-4
```
**Fermé (revérifié), avec dérogations à consigner par le lead.** Les 20 `pnpm.overrides` fixent la
dernière version publiée avant le 27/09. backend annonce 0 paquet de moins de 14 jours sur 326.
Je l'ai vérifié par sondage :
- Lockfile : vite 8.3.1, rolldown 1.2.11, @oxc-project/types 0.151.0, postcss 8.5.28,
  nanoid 3.3.19, acorn 8.18.0, ignore 7.0.10.
- Dates sur le registre (`npm view <paquet> time`) : vite 8.3.1 et rolldown 1.2.11 le 24/09,
  postcss 8.5.28 le 03/09.

Dérogations (la sécurité prime sur l'âge) :
- source-map-js 1.2.2, publié le 30/09 (11 jours) : la 1.2.1 fait l'objet d'un avis High (déni de service).
- uuid 11.1.1 : avis Moderate sur uuid 10.0.0, tiré par dockerode 4.

Ces overrides figent des dépendances transitives. Ils sont à retirer dès que B6 aura un
contrôle d'âge (ou pnpm ≥ 10.16 et `minimumReleaseAge`).

```
[CONSTAT] S1-07 Télémétrie Turborepo active par défaut
Sévérité : Basse
Fichier : turbo.json / environnement (pas de changement de fichier aujourd'hui)
Scénario d'attaque : métadonnées de build (noms de tâches, environnement) envoyées à un tiers
  depuis le poste et la CI.
Correctif proposé : TURBO_TELEMETRY_DISABLED=1 dans la CI (B6) ; une ligne au README §14 (lead)
  pour `pnpm turbo telemetry disable` sur le poste.
Exigence : SEC-D6
```
**Ouvert** : à traiter en B6 (backend) et au README §14 (lead).

Contrôles refaits après la reprise :

- `pnpm.onlyBuiltDependencies: []` (pnpm 9.15.4) : **effectif en réel**. Les paquets à script
  d'installation présents (`cpu-features`, `ssh2`, `protobufjs`, dépendances de Testcontainers)
  n'ont aucun répertoire `build/` ; `.modules.yaml` → `pendingBuilds: []`. SC-3 est satisfait en
  pratique, même sans pnpm 10.
- Lockfile : 326 entrées `integrity: sha512`, aucune URL hors `registry.npmjs.org` (SC-5).
- Paquets internes : `private: true` et `workspace:*` uniquement (SC-2, partiel : scope npm non réservé).
- `packages/config/eslint.js` : `no-eval`, `no-implied-eval`, `no-new-func`, interdiction de
  `parseFloat`/`toFixed`, `strictTypeChecked`. `packages/shared` : montants `int` 0..2^53-1 marqués,
  bps 0..10 000, `tndToMillimes` refuse les fractions et les dépassements (47 tests).
- `minimumReleaseAge` (SC-4) n'existe pas en pnpm 9 : reste ouvert, à traiter en B6 (Renovate/délai).

### P0-D1 : OK

Fichiers : `packages/ui-tokens/` (sources, tests, `generated/`, `dart/`), `pnpm-lock.yaml`.

- Aucune dépendance d'exécution ; dépendances de développement déjà présentes dans le workspace.
- Générateur Tailwind : `JSON.stringify` → pas d'injection dans le `.cjs` (exécuté par Tailwind
  lors du build web). Test de fraîcheur : fichiers générés = rendu de la source, octet à octet.
- Relâchement `restrict-template-expressions` (`allowNumber`) limité au paquet, sans argent : accepté.
- Aucun secret, aucun accès réseau, écriture limitée à `generated/` et `dart/lib/`.

```
[CONSTAT] S1-08 Générateur Dart : littéraux et identifiants non neutralisés
Sévérité : Basse
Fichier : packages/ui-tokens/src/dart.ts:47-49 (quote), :65, :80, :87, :174 (identifiants)
Preuve : quote() échappe « \ » et « ' » mais pas « $ » (interpolation Dart dans une chaîne
  simple) ni les sauts de ligne ; les clés du JSON (camel(k), noms de statut) sont recopiées
  comme identifiants sans validation. Aujourd'hui : 0 « $ » dans flexipay_tokens.dart, toutes les
  clés en [a-z0-9-] ou [A-Z_] : aucun impact actuel.
Scénario d'attaque : un contributeur (ou un agent) ajoute dans docs/design/design-tokens.json un
  libellé « ${…} » ou une clé contenant « ; » et du code : le fichier Dart généré, compilé dans
  les deux apps mobiles, contient du code non relu (le diff du JSON paraît anodin). Exige un
  accès en écriture au dépôt et une revue manquée : intégrité de la chaîne, pas de gain direct.
Correctif proposé : échapper aussi « $ », « \n », « \r » dans quote() ; valider chaque clé
  par /^[a-z][a-z0-9-]*$/ (ou /^[A-Z][A-Z_]*$/ pour les statuts) et lever une erreur sinon ;
  un test avec une valeur piégée.
Exigence : ASVS 5.0 V1 (encodage de sortie selon le contexte) ; menace SC-9 (code généré)
```
**Fermé (revérifié le 2026-10-11, 1er aller-retour).**
- `quote()` échappe maintenant `\`, `'`, `$`, `\n` et `\r` (`dart.ts:48-55`).
- `assertSafeTokens()` est appelée en tête de `renderDart` (`:103`). Elle valide les clés de chaque
  groupe, les clés de statut, `icon`, `labelKey`, les références `bg`/`fg` et les familles de police.
- `pnpm --filter @flexipay/ui-tokens test` → 87/87 ; 0 « $ » dans `flexipay_tokens.dart`.

Remarque non bloquante : le contrôle `v.bg in t.color` (`:89`) accepte les propriétés héritées
(`toString`, `constructor`…). Ces noms ne contiennent que des caractères d'identifiant : au pire
une erreur de compilation Dart, pas d'injection. `Object.hasOwn` serait plus strict.

### P0-B4 : observations préliminaires (pas encore de verdict)

Fichiers vus : `infra/docker-compose.yml`, `infra/testing/` (`infra/.env.example` **non lu** :
`.env*` interdits par CLAUDE.md ; seulement passé à gitleaks → aucune fuite). Points conformes :
ports Compose sur `127.0.0.1`, `${VAR:?}` obligatoires, images épinglées par version + `sha256`
(identiques à `images.ts`, vérifié par test), `no-new-privileges`, ni `privileged`, ni socket, ni
`network_mode: host`, scram-sha-256, Redis protégé par mot de passe (test NOAUTH), mots de passe
de test aléatoires (192 bits).

À formaliser à réception du `[LIVRÉ]` :
- (a) Testcontainers publie les ports **sans `HostIp`** (`generic-container.js:288` :
  `[{ HostPort: "0" }]`), donc sur toutes les interfaces, alors que Ryuk est désactivé : un
  conteneur orphelin (échec avant `afterAll`, `startPostgres` qui lève après `start()`) reste
  joignable depuis le réseau local. Risque faible (mot de passe aléatoire), probablement Basse.
- (b) DC-5 : les tests se connectent avec `flexipay_test`, le superutilisateur créé par l'image.
  Aucun rôle applicatif `NOSUPERUSER NOBYPASSRLS` n'est prévu dans le socle. Ce rôle est à exiger
  avant la première table soumise à la RLS.
- (c) Redis : `--requirepass` en argument (visible par `ps`/`docker inspect`), en dev seulement : à titre d'information.

## Partie 3 : revérification de 594f06e (S1-01, S1-02), 1er aller-retour

Fichiers : `.githooks/pre-commit` (100755 dans l'index, `core.hooksPath` = `.githooks` dans ce
clone), `.claude/hooks/guard-bash.{sh,js}`, `lib/shell-split.js`, `lib/scopes.js`,
`test/guard-bash.test.js`, `docs/handoff/README.md`.

**S1-01 fermé.** Le scan est maintenant fait par le hook git natif, après l'indexation :
`gitleaks git --staged --redact --exit-code 1`, avec échec fermé si gitleaks est absent. L'indexation
dans la même commande (`add && commit`, `-a`, commit par chemin, options abrégées) n'échappe donc
plus au scan. Le garde vérifie aussi avant chaque commit que le hook est actif et identique à HEAD.

**S1-02 fermé.** Seul le segment « git … commit » est analysé, et le message n'est jamais lu. Le hook
réel, appelé avec une entrée JSON :

| Cas | Code |
|---|---|
| `grep -i … ; git commit -m "fix"`, `grep -q … && git commit …`, message contenant « -n » et « --all », `-am`, `-mn` | 0 |
| `-vn`, `--no-ve`, `bash -c "git commit --no-verify …"`, `-c core.<hooksPath>=…` | 2 |

Tests : `node --test .claude/hooks/test/guard-bash.test.js` → 53/53 ; `enforce-scope.test.js` → 55/55.

```
[CONSTAT] S1-09 Hook natif contournable : sous-commande non littérale, alias persistant, GIT_CONFIG_*, commits sans pre-commit
Sévérité : Moyenne
Fichier : .claude/hooks/guard-bash.js:54-71 (parseGit), :145-149, :159-176 ; .githooks/ (pas de pre-push)
Preuve : guard-bash.js réel, entrée JSON, CLAUDE_PROJECT_DIR = le dépôt → code 0 (autorisé) pour :
  1) git $(printf commit) --no-verify -m x      (sous-commande vue comme « $() »)
  2) S=commit; git $S --no-verify -m x           (idem avec une variable ou des backticks)
  3) git config alias.ci "commit --no-verify"  puis  git ci -m x   (alias persistant : seul
     « -c alias.* » est refusé)
  4) K=core.hooks; export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=${K}Path GIT_CONFIG_VALUE_0=/x;
     git commit -m x   (le mot recherché n'apparaît jamais en clair ; checkNativeHook lit la
     configuration dans SON environnement, pas dans celui de la commande)
  5) git stash && git cherry-pick -m 1 stash@{0} ; git am <patch> : créent un commit à contenu
     NOUVEAU sans pre-commit (l'argument « réutilisent des commits existants » ne vaut pas pour
     stash ni am).
  Les témoins sont bloqués : `--no-verify` littéral et `-c core.<hooksPath>`.
Scénario d'attaque : un agent manipulé (injection de prompt dans un fichier lu, une issue, une
  dépendance) ou un agent qui veut « débloquer » son commit enregistre un .env, un jeton ou une clé
  par l'une de ces formes, puis pousse sa branche : le secret est sur GitHub avant tout contrôle,
  tant que B6 (gitleaks en CI) n'existe pas. Gain : jetons ou clés exposés dans l'historique.
Correctif proposé :
  a) Garde (échec fermé) : refuser tout segment git dont la sous-commande n'est pas un mot
     littéral (contient $, ` ou est vide) ; refuser l'écriture de « alias.* » par git config
     (lecture seule permise) ; refuser tout mot GIT_CONFIG_COUNT, GIT_CONFIG_KEY_*,
     GIT_CONFIG_PARAMETERS, GIT_CONFIG_GLOBAL/SYSTEM, GIT_DIR, GIT_INDEX_FILE, quel que soit le segment.
  b) Hook natif .githooks/pre-push : gitleaks git --log-opts="<distant>..<local>" sur les commits
     poussés. Il couvre stash, cherry-pick, am, rebase et merge, quelle que soit la façon dont le
     commit a été créé. Il garde le même échec fermé, et `push --no-verify` est refusé par le garde
     comme pour commit.
  c) Barrière réelle côté serveur : gitleaks bloquant en CI (B6) et, si le plan GitHub le permet,
     la protection des pushs du secret scanning. Les hooks locaux restent une aide.
Exigence : GIT-1, DEV-4 / ASVS 5.0 V13.3.1 (secrets hors du code source)
```

```
[CONSTAT] S1-10 Faux positif : « .githooks » ou « hooksPath » dans des données (heredoc, chaîne citée)
Sévérité : Basse
Fichier : .claude/hooks/lib/shell-split.js:103 (saut de ligne = fin de segment, heredoc non reconnu) ;
  guard-bash.js:145, :151 (motif cherché dans tout le texte d'un segment non git)
Preuve : constat réel du lead : le corps d'un `cat <<'EOF'` contenant « .githooks » est bloqué.
  Reproduit : « cat <<EOF > notes.md / see .githooks folder / EOF » → 2 ;
  « echo "the <hooksPath> doc" > x.md » → 2. Pendant cette revue, ma propre commande
  `node -e '…'` a été bloquée deux fois, parce qu'une étiquette et une regex contenaient le mot.
Qualification : échec fermé, donc aucune faille. Mais la friction pousse aux contournements
  (mot coupé, écriture par un autre outil), comme pour S1-02. D'où Basse.
Correctif proposé :
  1) shell-split reconnaît `<<[-]?\s*(['"]?)DELIM\1`. Si le délimiteur est entre guillemets, le
     corps est une donnée et n'est jamais analysé. Sans guillemets, seules les substitutions
     $(…) et `…` du corps sont extraites.
  2) Exception : si le heredoc alimente un interpréteur (bash, sh, zsh, dash, ou psql pour le
     motif SQL), le corps est analysé comme des commandes (ou du SQL), quelle que soit la forme
     du délimiteur. Lecture du premier mot du segment, après les affectations et `env`.
  3) Pour les segments non git, appliquer « .githooks » aux seuls mots qui ressemblent à un chemin
     (mot égal à .githooks ou commençant par .githooks/ ou */.githooks/), et non à toute la
     chaîne : un texte cité qui mentionne le dossier n'est plus bloqué, « cp x .githooks/pre-commit »
     l'est toujours. Pour « hooksPath » : seulement dans les segments git et dans les
     affectations GIT_CONFIG_* (voir S1-09 a).
  4) Tests : heredoc à délimiteur cité contenant les deux mots → 0 ; « bash <<'EOF' » contenant
     git commit --no-verify → 2 ; « psql <<'EOF' » contenant un DELETE sur le ledger → 2.
Exigence : DEV-4 / ASVS 1.14.x (configuration sûre de l'outillage)
```

Non vérifié (partie 3) : les contournements de S1-09 sont prouvés **au niveau du garde** (codes
réels). Leur effet côté git (alias, GIT_CONFIG_*, stash/cherry-pick et am qui n'appellent pas
pre-commit) repose sur le comportement documenté de git ≥ 2.31. Je ne l'ai pas reproduit dans un
dépôt jetable : l'écriture hors du projet m'est refusée par enforce-scope. Je n'ai pas non plus
refait le test réel du lead (add&&commit, -a, --inc avec un secret → 1).

## Partie 5 : S1-09 et S1-10, 3e et dernier aller-retour (index non commité, 2026-10-11)

Base : `git diff --cached` (index = arbre de travail, vérifié par `git diff --quiet`) :
`guard-bash.js`, `lib/shell-split.js`, `test/guard-bash.test.js`, `.githooks/pre-push` (100755),
`docs/handoff/README.md`. Le commit sera fait par l'utilisateur, car il touche `.githooks/`.

Tests : `node --test .claude/hooks/test/guard-bash.test.js` → 78/78. Hook réel avec entrée JSON :

| Cas | Code |
|---|---|
| S1-09 : `git $(printf commit) --no-verify`, `S=commit; git $S …`, `git config alias.ci "commit --no-verify"`, `GIT_CONFIG_*` à clé construite, `git push --no-verify`, `cp x .githooks/pre-push` | 2 |
| S1-10 : heredoc à délimiteur cité contenant `.githooks` et `hooksPath`, `echo "… hooksPath …" > x.md` | 0 |
| S1-10 : `bash <<'EOF'` contenant un commit `--no-verify`, `psql <<'EOF'` contenant un DELETE sur le ledger | 2 |

`.githooks/pre-push` : plage `distant..local`, ou `local --not --remotes` pour une nouvelle branche ;
suppressions ignorées ; zéro calculé par `hash-object` (compatible SHA-256) ; `|| exit 1` en cas
d'erreur de gitleaks ou d'un SHA distant inconnu (échec fermé). Je ne l'ai pas exécuté moi-même ;
le lead l'a testé en réel (secret refusé sur une branche existante et sur une nouvelle).

**S1-09 fermé, sauf le résiduel S1-11 ci-dessous. S1-10 fermé.**

```
[CONSTAT] S1-11 Alias défini par un fichier inclus (include.path) : commit et push sans hook
Sévérité : Moyenne
Fichier : .claude/hooks/guard-bash.js (parseGit, contrôles « -c » et « git config »)
Preuve : hook réel (index), code 0 pour :
  git -c include.path=docs/x.cfg ci -m x   ;   git config include.path ../docs/x.cfg
  git ci -m x   ;   git p origin feat/x     (sous-commande inconnue : alias, aucun contrôle)
Scénario d'attaque : un agent écrit dans son propre périmètre un fichier docs/x.cfg contenant
  « [alias] ci = commit --no-verify » et « p = push --no-verify ». Il l'inclut par -c include.path
  ou git config include.path (aucun mot « alias. » ni « hooksPath »), puis lance « git ci » et
  « git p ». Ni pre-commit ni pre-push ne s'exécutent : un secret part sur GitHub. checkNativeHook
  n'est même pas appelé, car la sous-commande n'est ni commit ni push. Il faut deux commandes
  délibérées : c'est une évasion volontaire, pas une erreur.
Correctif proposé : liste blanche des sous-commandes git intégrées (status, diff, log, show, add,
  commit, push, fetch, pull, switch, checkout, branch, restore, stash, merge, rebase, tag, config,
  rev-parse, ls-files, cat-file, remote…) : toute autre sous-commande, donc tout alias, est refusée.
  « -c » est refusé sauf liste blanche (color.*, core.quotepath, …). Les écritures de include.* et
  includeIf.* par git config sont refusées.
Exigence : GIT-1, DEV-4 / ASVS 5.0 V13.3.1
```

Boucle : c'est le 3e aller-retour sur ce sujet (S1-01 → S1-09 → S1-11). Je n'ouvre pas de 4e
aller-retour : S1-11 est transmis à main pour décision par l'utilisateur. Il s'agit d'un Moyenne,
donc non bloquant. La barrière réelle reste côté serveur : gitleaks en CI (B6) et la protection
des pushs GitHub.

Résiduels assumés par le lead et acceptés comme tels : écriture dans `.git/config` par un
interpréteur (`python -c`, `node -e`). Dans ce cas, checkNativeHook détecte tout changement de
`core.hooksPath` effectif au commit suivant, mais pas un alias.

## Partie 4 : P0-B4 (Compose dev + Testcontainers), `[LIVRÉ]` du 2026-10-11

Fichiers : `infra/docker-compose.yml`, `infra/.env.example` (non lu, règle `.env*` ; gitleaks : aucune
fuite), `infra/testing/` (src, tests unitaires et d'intégration, configurations vitest),
`pnpm-lock.yaml` (`pg` déplacé de devDependencies vers dependencies, même version 8.23.0).

**Verdict : OK sur lecture.** Aucun Critique, Haute, Moyenne ni Basse.

- **(a) Ports de test sur 127.0.0.1 : traité.** `LoopbackPostgreSqlContainer` et
  `LoopbackRedisContainer` réécrivent `HostIp: 127.0.0.1` sur toutes les `PortBindings` avant
  `super.start()`. Vérifié dans Testcontainers 11.14.0 : les modules appellent `withExposedPorts`
  dans leur **constructeur** (`postgresql-container.js:38`, `redis-container.js:17`), et
  `generic-container.js:291` remplit `hostConfig.PortBindings` à ce moment-là. La réécriture
  précède donc bien `client.container.create(... HostConfig: this.hostConfig)`.
  `TESTCONTAINERS_HOST_OVERRIDE=127.0.0.1`. Un test d'intégration relit `NetworkSettings.Ports`
  après le démarrage.
- **(b) DC-5 : traité pour les tests.** Le rôle `flexipay_app` est créé
  `NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION`, avec un mot de passe aléatoire
  par conteneur. Le DDL interpole un identifiant constant (testé) et un mot de passe contrôlé par
  `/^[a-f0-9]+$/` : aucune injection possible. Le superutilisateur `flexipay_admin` est réservé au
  schéma. Le test RLS fait lire la table par un rôle non propriétaire, sans `FORCE`, ce qui est
  correct : 1 ligne sur 2. Côté Compose dev, le rôle reste à créer, par la première migration
  d'`apps/api` (proposition de backend remontée à main ; DC-5 reste « partiel » pour le dev).
- Nettoyage : `startPostgres` arrête le conteneur si la création du rôle échoue ; les tests
  libèrent ce qui a été créé.
- Remarque, sans constat : dans `afterAll`, la boucle s'arrête à la première libération qui lève
  (par exemple `app.end()`), et le conteneur n'est alors pas arrêté (Ryuk désactivé). Comme le
  port est sur la boucle locale, l'impact se limite aux ressources du poste. `Promise.allSettled`
  ou un try/catch par élément éviterait ce cas. **Traité par backend** : `src/cleanup.ts`
  (`releaseAll` : ordre inverse, try/catch par étape, AggregateError), utilisé dans les deux tests
  d'intégration ; `pnpm --filter @flexipay/testing-infra test` → 12/12 (dont `cleanup.test.ts`).
- Inchangés et conformes : ports Compose sur 127.0.0.1, `${VAR:?}`, images version + sha256
  identiques au test, `no-new-privileges`, scram-sha-256, Redis avec mot de passe.

Vérifications : `pnpm --filter @flexipay/testing-infra test` → 10/10 (dont `loopback.test.ts`) ;
`gitleaks dir --redact infra` → aucune fuite.

Non vérifié (partie 4) :
1. **Exécution réelle** : `docker compose … up` (2 conteneurs sains), `docker port` sur
   127.0.0.1, `pnpm test:integration` (9 tests, dont la liaison sur la boucle locale et la RLS).
   Le démon Docker ne répond pas. Ce verdict est à confirmer par ces commandes : je revérifie dès
   que Docker revient.
2. Le `pnpm audit` « 0 vulnérabilité » de backend n'est pas reproduit (refusé dans ma session).

## Méthode et commandes (partie 1)

- `gitleaks version` → 8.30.1 ; `docker info --format …` → 29.8.2 ; `pnpm --version` → 9.15.4 ;
  `node --version` → v22.14.0 ; `git --version` → 2.47.1.windows.1.
- Hooks exécutés **comme fichiers** (`"$H"` avec entrée JSON construite par `node -e`), cwd =
  dépôts jetables `scratchpad/r1` et `scratchpad/r2`. Les chaînes de test sont construites par
  concaténation (`"git com""mit"`) pour que le hook de ma propre session ne les intercepte pas.
  Faux jeton `ghp_` aléatoire généré à l'exécution, jamais écrit dans le dépôt.
- Hook git natif de démonstration écrit dans `scratchpad/r2/.githooks/pre-commit` (hors dépôt),
  `core.hooksPath` réglé sur ce dépôt jetable uniquement.
- `protect-files.js` et `enforce-scope.js` exécutés avec des entrées simulées (aucune écriture).
- `git config --get core.hooksPath` dans le dépôt → non défini (code 1) ; pas de `.githooks/`.
- Aucun commit, aucun push, aucun changement de branche dans le dépôt.

## Non vérifié (partie 1)

1. **Cause exacte de S1-03** : je ne sais pas si l'utilisateur a vu et approuvé une demande pour
   mes deux commandes `pnpm`, ou si le mode auto les a approuvées. Je n'ai pas tenté
   `pnpm create <paquet>` ni `pnpm add` (paquet inconnu interdit) : je ne sais donc pas si le
   classifieur du mode auto aurait refusé un vrai téléchargement.
2. Couverture de la forme sans argument final par un motif « … * » (`pnpm * install *` sur
   `pnpm --filter api install`) : non vérifiée en réel.
3. Nom court 8.3 sur une **vraie** migration existante (`apps/` absent).
4. Comportement du hook natif proposé sur le poste du lead avec son `core.autocrlf` (testé
   seulement dans le dépôt jetable, mêmes binaires git et gitleaks).

## Vérifications et non vérifié (partie 2)

Commandes : `gitleaks dir --no-banner --redact <chemin>` sur les 13 chemins livrés → « no leaks
found » partout ; `pnpm test` → 3 tâches réussies (ui-tokens 82, shared 47, testing-infra 7 tests ;
résultats **en cache Turbo**) ; `pnpm lint` → 4/4 ; `pnpm typecheck` → 3/3 (en cache).

Non vérifié :
1. **`pnpm audit` et `pnpm audit --prod`** : commande refusée par le système de permissions de ma
   session (pas de contournement). backend annonce « No known vulnerabilities » ; je ne l'ai pas
   reproduit. La justification des 20 `pnpm.overrides` est fournie (S1-06), et les dates sont
   vérifiées par sondage sur 4 paquets seulement.
2. **Tests d'intégration Testcontainers** (B4) : lancés deux fois, code 1. La sortie est illisible
   (« No space left on device » : C: plein à 97 %), puis le démon Docker ne répond plus
   (`docker info` > 30 s). Ce que je n'ai pas pu vérifier en réel : les ports publiés par les
   conteneurs de test, l'authentification Redis réelle et le nettoyage sans Ryuk.
3. Fichier Dart généré **non compilé** (Flutter absent) ; contrastes vérifiés par test Node seulement.
4. `infra/.env.example` non lu (règle `.env*`).
5. Dates de publication des 326 entrées du lockfile : non revérifiées une à une (sondage de 4).
