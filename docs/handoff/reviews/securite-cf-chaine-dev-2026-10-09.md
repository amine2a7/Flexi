# Revue securite : P0-S9, correctifs CF-01 à CF-09 (chaîne de développement)

- **Date** : 2026-10-09
- **Relecteur** : securite
- **Base de revue** : `git diff main..fix/cf-chaine-dev` (8 commits : 8b120ae CF-01, 3ea058b CF-03, 64f8ba1 CF-04, 6221c46 CF-05, 2d02113 CF-06, 3e08503 CF-07, 5c53f0d CF-08, d40c42a CF-09) + `git stash show -p stash@{0}` (CF-02, non commité, à commiter par l'utilisateur)
- **Constats d'origine** : `docs/security/modele-de-menaces.md` §3.7
- **Propriétaire du code revu** : lead (`main`) : `.claude/`, `.gitignore`, `docs/handoff/README.md`

## Verdict : **OK** (non bloquant)

Aucun constat Critique ni Haute. Les correctifs ferment les cas décrits dans les constats d'origine et je n'ai trouvé **aucune régression** : le lead et les agents Explore et Plan peuvent toujours écrire. Il reste deux contournements de sévérité **Moyenne** (S9-01 pour les dépendances, S9-02 pour le scan des commits) et cinq de sévérité **Basse**. La fusion est possible. Je recommande de corriger S9-01 et S9-02 avant la phase 1.

## État des constats d'origine

| CF | État | Preuve principale | Résiduel |
|---|---|---|---|
| CF-01 | **Partiellement fermé** | Les 4 cas d'origine bloquent maintenant (code 2) : `C:\…\flexipay\secrets\db.txt`, `secrets/db.txt`, `.ENV`, `certs/server.PEM`. Une migration existante bloque aussi avec antislashs et en majuscules | S9-03 (flux ADS `::$DATA`, nom court 8.3) |
| CF-02 | **Partiellement fermé** (stash, non commité) | Version du stash exécutée comme fichier, gitleaks absent : `git commit -m x` → 2, `git commit -am x` → 2, `--amend` → 2 ; version de la branche → 0 | S9-02 (`commit -a`, `git -C … commit`) |
| CF-03 | **Fermé** | `securite` vers `contracts/openapi.yaml` → 2 ; `design` vers `reviews/securite-*` → 2 (même en majuscules) ; `design` vers `reviews/design-*` → 0 ; **test réel** : mon `Write` hors projet a été bloqué avec « l'agent « securite » … (hors du projet) » | aucun |
| CF-04 | **Partiellement fermé** | Lecture de `settings.json` (JSON valide) : `ask` sur `pnpm * add *`, `pnpm i *`, `pnpm install *`, `pnpm * install *`, `pnpm dlx *`, `pnpm * dlx *`, `npx *`, `dart pub add *`. Rien n'a été exécuté (pnpm indisponible) | S9-01 (`pnpm create`, `pnpm exec npx`, `pnpm install` sans argument) |
| CF-05 | **Fermé** (réserve Basse) | Non-JSON → 2 ; entrée vide → 2 ; `agent_id` sans `agent_type` → 2 ; `agent_type` vide → 2 ; session principale sans `agent_id` → 0 ; Explore et Plan → 0 ; **test réel** : `agent_type` est bien transmis pour securite | S9-04 (JSON `null` → code 1, non bloquant) |
| CF-06 | **Fermé** (compléments Basse) | `git check-ignore --no-index` ignore les 11 cas listés (`*.jks`, `*.keystore`, `key.properties`, `*.p12`, `*.mobileprovision`, `google-services.json`, `GoogleService-Info.plist`, `*.tfstate`, `*.tfstate.*`, `.npmrc`, `apps/api/.npmrc`). `git ls-files -ci --exclude-standard` est vide : aucun fichier suivi n'est nouvellement ignoré | S9-05 (`*.p8`, `*.tfvars`, compte de service Firebase…) |
| CF-07 | **Fermé** | `.claude/agents/ledger-auditor.md:4` → `tools: Read, Grep, Glob`. La commande `/ledger-audit` est adaptée : l'appelant lance les tests | aucun |
| CF-08 | **Partiellement fermé** | Politique écrite (README, « Signature des commits ») mais **pas appliquée** : les 8 commits ont `%G?` = `N`, et `gpg.format` n'est pas défini | S9-06 |
| CF-09 | **Fermé** (en tant qu'aide) | Les 4 cas d'origine → 2, ainsi que `ONLY`, `IF EXISTS` et `"public"."transactions"` avec guillemets échappés. Les commandes légitimes passent (`SELECT … FROM ledger_entries` → 0 ; `transactions_archive` → 0) | S9-07 (contournements résiduels assumés ; la vraie barrière est SEC-P4 et DC-5) |

## Régressions vérifiées (aucune)

- **Session principale** (aucun `agent_id`) vers `.claude/settings.json` et vers `docs/handoff/BOARD.md` → 0 : le lead peut toujours écrire.
- **Agents Explore et Plan** (`agent_id` présent, `agent_type` hors `scopes.js`) → 0.
- `backend` → `docs/handoff/contracts/openapi.yaml` → 0. `test-writer` → `apps/api/src/a.spec.ts` → 0.
- `ledger-auditor` → `docs/handoff/reviews/ledger-x.md` → 2. Comportement voulu : c'est le lead qui écrit ce tableau via `/ledger-audit`.
- Retrait de `allow Bash(npx prettier *)` : sans effet sur `format.sh`, car les hooks ne passent pas par les règles de permission. Un `npx prettier` lancé à la main par un agent demandera simplement une approbation.
- Faux positif de `guard-bash.sh` (déjà présent avant la branche) : un message de commit contenant « update transactions » est bloqué (code 2). Je l'ai constaté en réel sur l'une de mes propres commandes de test (voir S9-07).

## Constats

```
[CONSTAT] S9-01 Approbation des dépendances encore contournable (résiduel de CF-04)
Sévérité : Moyenne
Fichier : .claude/settings.json:7 (allow "Bash(pnpm *)") et :20-30 (ask)
Preuve : lecture. Ces commandes commencent par « pnpm » et ne correspondent à aucun motif ask :
  - « pnpm create <starter> » (équivaut à pnpm dlx create-<starter> : téléchargement puis exécution) ;
  - « pnpm exec npx <paquet> », « pnpm exec pnpx <paquet> », « pnpm exec npm i <paquet> »
    (le motif ask « npx * » ne s'applique qu'en tête de commande) ;
  - modification de apps/api/package.json (périmètre backend) puis « pnpm install » SANS argument :
    je ne sais pas si « pnpm install * » couvre la commande nue (non vérifié).
Scénario d'attaque : un agent backend lit un README de dépendance ou un message d'erreur piégé
  (injection de prompt, DEV-3) qui lui suggère « pnpm create flexipay-helper » ou
  « pnpm exec npx some-fix ». La commande est autorisée sans approbation humaine. Le paquet
  (typosquatting, SC-1) s'exécute sur le poste avec les droits de l'utilisateur (jetons GitHub,
  dépôt) avant toute revue.
Correctif proposé : ajouter en ask « Bash(pnpm create *) », « Bash(pnpm * create *) »,
  « Bash(pnpm exec *) » ou au moins « Bash(pnpm * exec *) », et « Bash(pnpm install) »,
  « Bash(pnpm i) » (formes nues). Garder la revue securite de chaque diff de package.json et
  de pnpm-lock.yaml (SC-1). Variante plus robuste : remplacer « allow Bash(pnpm *) » par une
  liste explicite (pnpm lint, typecheck, test, build, dev, --filter * lint|typecheck|test|build).
Exigence : SC-1, DEV-3 / ASVS 14.2.4 (composants tiers de sources fiables)
```

```
[CONSTAT] S9-02 Scan gitleaks contournable par « commit -a » et les options globales de git (résiduel de CF-02, stash)
Sévérité : Moyenne
Fichier : stash@{0}:.claude/hooks/guard-bash.sh:7 (grep -qE 'git commit') et :14 (gitleaks protect --staged)
Preuve : version du stash exécutée comme fichier, avec un faux gitleaks qui réussit (PATH de test) :
  - « git commit -am x » → 0 : le hook ne scanne que l'index. Les fichiers suivis mais non indexés
    sont ajoutés par -a APRÈS le scan, donc commis sans être scannés. C'est aussi vrai pour
    « git commit <chemin> », « --include » et « --only ».
  - gitleaks absent : « git -C . commit -m x » → 0 ; « git -c user.name=x commit -m x » → 0 ;
    « git  commit -m x » (deux espaces) → 0. Ces formes ne correspondent pas non plus à
    « allow Bash(git commit *) » et retombent sur une demande d'approbation : l'utilisateur est
    sollicité, mais sans être averti que le scan n'a pas eu lieu.
Scénario d'attaque : un agent backend colle un jeton de test réel dans apps/api/src/config.ts
  (fichier suivi, déjà commité). Il lance « git commit -am "fix config" » : l'index scanné ne
  contient pas la modification, le hook laisse passer, et le secret est commis. Plus tard,
  « git push » est approuvé par un utilisateur qui croit le scan actif : le secret se retrouve
  sur GitHub (GIT-1). La CI gitleaks (B6) n'existe pas encore.
Correctif proposé :
  1) un vrai hook git pre-commit versionné (ex. .githooks/pre-commit avec
     « git config core.hooksPath .githooks ») qui lance gitleaks sur l'index. Il s'exécute après
     le staging de -a, couvre toutes les formes et aliases, et protège aussi les commits faits
     par l'utilisateur. Dans guard-bash, refuser « --no-verify » et « -n » sur commit ;
  2) dans guard-bash, motif élargi :
     git([[:space:]]+-[cC][[:space:]]*[^[:space:]]+)*[[:space:]]+commit
     et refus de « -a/--all/--include/--only/<chemin> » (exiger un « git add » explicite) ;
  3) gitleaks bloquant en CI sur tout l'historique (B6, CI-7). Vérifier aussi la sous-commande
     selon la version installée : « protect » est obsolète dans les v8 récentes au profit de
     « gitleaks git --staged » (non vérifié, gitleaks absent).
Exigence : GIT-1, DEV-4 / ASVS 14.3.x, 2.10.4 (secrets hors du code source)
```

```
[CONSTAT] S9-03 protect-files contournable par les flux ADS et les noms courts 8.3 de NTFS (résiduel de CF-01)
Sévérité : Basse
Fichier : .claude/hooks/protect-files.sh:12-25 ; .claude/settings.json (matcher « Edit|Write|MultiEdit », sans NotebookEdit)
Preuve (hook exécuté avec des entrées simulées, puis Node dans le scratchpad, hors dépôt) :
  - « …/certs/server.pem::$DATA » → 0 et « …/.env::$DATA » → 0. Avec Node, un
    writeFileSync sur « c.pem::$DATA » a créé « c.pem » : le flux par défaut EST le fichier.
  - Migration existante : « …/prisma/MIGRAT~1/20261009_init/migration.sql » → 0
    (« dir /x » affiche MIGRAT~1, le fichier existe sous ce nom : la génération 8.3 est active
    sur C:, comme le montre aussi le chemin NGB010~1) ; « …/migration.sql::$DATA » → 0.
  - « secrets/prod.env.example » → 0 : l'exemption .env.example est testée avant secrets/.
  - Le point final ou l'espace final (« server.pem. ») N'EST PAS un contournement : Node crée
    un fichier distinct « a.pem. ».
Scénario d'attaque : un agent backend induit en erreur (DEV-3), ou qui veut « réparer » une
  migration en échec, modifie apps/api/prisma/MIGRAT~1/<existante>/migration.sql via Write ou
  Edit. Le hook ne voit pas « /prisma/migrations/ », et enforce-scope accepte (apps/api/ est son
  périmètre). Les bases déjà migrées divergent du schéma (règle 17).
Correctif proposé : réécrire protect-files en Node (normalisation commune avec enforce-scope) :
  refuser tout « : » au-delà de la lettre de lecteur et tout segment « ~<chiffre> » ; ou résoudre
  le parent existant le plus proche avec fs.realpathSync.native, qui rend les noms longs, avant
  de comparer. Tester secrets/ avant l'exemption .env.example. Ajouter NotebookEdit au matcher
  et lire tool_input.notebook_path. Garder le contrôle CI des migrations (GIT-5) comme vraie
  barrière.
Exigence : GIT-5, DEV-1 / ASVS 12.3.1 (validation des chemins de fichiers)
```

```
[CONSTAT] S9-04 enforce-scope : une exception d'exécution sort en code 1, non bloquant (réserve sur CF-05)
Sévérité : Basse
Fichier : .claude/hooks/enforce-scope.js:10-22
Preuve : entrée « null » → code 1 (TypeError sur input.agent_id) ; entrée « [] » → code 0.
  Pour Claude Code, un code autre que 2 est une erreur non bloquante : l'écriture a lieu.
Scénario d'attaque : peu réaliste aujourd'hui, car Claude Code envoie toujours un objet. Mais
  toute exception future (changement de format d'entrée, bogue dans scopes.js ou path.relative)
  fait échouer le contrôle en mode ouvert, sans bruit, pour tous les agents.
Correctif proposé : vérifier que l'entrée est un objet non tableau
  (typeof input === 'object' && input && !Array.isArray(input)), sinon exit 2 ; et entourer tout
  le corps d'un try/catch qui sort en 2 (même principe dans protect-files et guard-bash). Note :
  enforce-scope prend agent_type en priorité, alors que task-completed prend teammate_name en
  priorité. Aligner l'ordre (sans impact constaté).
Exigence : DEV-4 / ASVS 7.4.1 (échec sécurisé)
```

```
[CONSTAT] S9-05 .gitignore : motifs de secrets encore absents (complément de CF-06)
Sévérité : Basse
Fichier : .gitignore:8-20
Preuve : git check-ignore -v --no-index → NON IGNORÉ pour AuthKey_ABC123.p8, infra/staging.tfvars,
  flexipay-firebase-adminsdk-x1.json, cert.pfx, .envrc, id_ed25519.
Scénario d'attaque : le développeur mobile télécharge la clé APNs ou App Store Connect
  (AuthKey_XXXX.p8) ou le compte de service Firebase Admin (secret serveur des notifications
  push) dans le dépôt pour tester, puis fait « git add . ». La clé part sur GitHub : envoi de
  notifications au nom de FlexiPay (hameçonnage des employés) ou accès à App Store Connect.
Correctif proposé : ajouter *.p8, *.pfx, *.tfvars (en gardant *.tfvars.example),
  *firebase-adminsdk*.json, service-account*.json, .envrc, et id_rsa* / id_ed25519* (pertinent
  avec la signature SSH de CF-08). Note : local.properties sera couvert par le .gitignore généré
  par Flutter dans android/ (non vérifié, apps non créées).
Exigence : GIT-1, GIT-4, SEC-S7 / ASVS 2.10.4, MASVS-CODE
```

```
[CONSTAT] S9-06 Signature des commits : politique écrite mais non appliquée, et procédure de vérification incomplète (CF-08)
Sévérité : Basse
Fichier : docs/handoff/README.md (section « Signature des commits ») ; configuration git locale
Preuve : git log --format='%h %G? %s' main..fix/cf-chaine-dev → « N » sur les 8 commits ;
  git config --get gpg.format → code 1 (non défini) ; git config --get
  gpg.ssh.allowedSignersFile → code 1.
Scénario d'attaque : comme dans GIT-3. Sans signature exigée sur main, un commit poussé avec
  une identité falsifiée (user.email de l'utilisateur) est indiscernable d'un commit légitime.
Correctif proposé : appliquer la procédure (utilisateur). La compléter par
  « git config --local gpg.ssh.allowedSignersFile <fichier> » (une ligne « email clé-publique ») :
  sans ce fichier, git ne peut pas vérifier localement une signature SSH, et l'étape « %G? doit
  afficher G » échouera (comportement exact non vérifié faute de clé configurée). Activer
  « Require signed commits » sur main (réglage GitHub non vérifiable depuis ce poste).
Exigence : GIT-3 / ASVS 14.1.x (intégrité de la chaîne de build)
```

```
[CONSTAT] S9-07 guard-bash : contournements résiduels du garde-fou SQL et faux positifs (CF-09, aide assumée)
Sévérité : Basse
Fichier : .claude/hooks/guard-bash.sh:16-24
Preuve (hook exécuté comme fichier, motifs construits par concaténation) : → 0 pour un autre
  schéma (« app.ledger_entries »), une liste de tables (« TRUNCATE foo, ledger_entries »,
  « DROP TABLE foo, audit_log »), un saut de ligne entre le mot-clé et la table, un commentaire
  « /**/ », « SET session_replication_role = replica » (désactive les triggers pour un
  superutilisateur), « DROP TRIGGER … ON ledger_entries », « DROP SCHEMA public CASCADE »,
  « psql -f fichier.sql ». Faux positif : un message de commit contenant « update transactions »
  → 2.
Scénario d'attaque : un agent qui veut « nettoyer » des écritures de test lance une
  requête de suppression écrite sur plusieurs lignes, ou, sous le rôle propriétaire, la précède de
  « session_replication_role = replica ». Le hook ne voit rien. Seuls le rôle applicatif sans
  privilège et les triggers protègent alors le ledger.
Correctif proposé : aucun élargissement supplémentaire du motif (course perdue d'avance). Garder
  le hook comme aide, comme l'indique son commentaire. La vraie barrière est SEC-P4 (triggers) +
  DC-5 : le rôle applicatif et le rôle de test sont NOSUPERUSER, NOBYPASSRLS, non propriétaires
  des tables ; donc pas de DISABLE TRIGGER ni de session_replication_role possible. Pour le faux
  positif, ne pas appliquer le motif SQL au texte suivant « -m » d'un commit (optionnel).
Exigence : SEC-P4, DC-5 / ASVS 1.4.x (défense en profondeur)
```

## Méthode et commandes

- Lecture de `git show` pour chacun des 8 commits (un commit = un CF, aucun fichier hors sujet) et de `git stash show -p stash@{0}`. Aucun `stash pop` ni `apply`.
- Hooks exécutés avec des entrées JSON simulées depuis un pilote `node -` passé sur stdin (aucun fichier écrit dans le dépôt). Paramètre : `CLAUDE_PROJECT_DIR=C:/Users/NGB010226/Desktop/flexipay`. Version CF-02 du hook extraite par `git show stash@{0}:.claude/hooks/guard-bash.sh` dans le **scratchpad** (hors dépôt) puis exécutée comme fichier. Une migration factice et les essais NTFS ont aussi été faits dans le scratchpad.
- **Piège de banc de test, à noter pour README §14** : passer le contenu d'un hook par `bash -c "<script>"` depuis Node sous Windows altère les guillemets et antislashs. Le hook paraît alors laisser tout passer (0), alors que le même hook exécuté comme fichier bloque (2). Il faut toujours exécuter les hooks **comme fichiers**. Autre piège : les chemins Windows dans des chaînes JS littérales (`\f` donne un saut de page). Il faut construire l'antislash avec `String.fromCharCode(92)`.
- Test réel : un `Write` de securite vers le scratchpad a été bloqué par `enforce-scope.js` (« l'agent « securite » … hors du projet »), et aucun fichier n'a été créé. Les deux écritures de ce livrable (cette revue, `docs/security/modele-de-menaces.md`) ont été acceptées.
- `node -e JSON.parse(settings.json)` → valide. `git check-ignore -v --no-index` sur 18 chemins. `git ls-files -ci --exclude-standard` → vide. `command -v gitleaks` → absent (code 1).
- Aucune commande pnpm, Docker ou Flutter. Aucun commit.

## Non vérifié

1. **CF-04, en réel** : je n'ai pas vérifié que `ask` l'emporte sur `allow Bash(pnpm *)`, ni que `pnpm install *` couvre la commande nue `pnpm install`. Raison : pnpm est indisponible et les commandes pnpm sont interdites dans cette tâche ; la vérification s'est faite par lecture seulement.
2. **S9-03 de bout en bout** : je n'ai pas tenté de vrai `Write` via `::$DATA` ou `MIGRAT~1`, pour ne pas écrire de fichier protégé. La preuve se limite au hook et au comportement de Node dans le scratchpad.
3. **gitleaks réel** (absent du poste) : détection effective, et validité de la sous-commande `protect` dans la version qui sera installée.
4. **Blocage réel de CF-02** sur un vrai commit : rapporté par le lead, non reproduit. Je n'ai pas fait de commit ; seule la simulation du hook l'appuie.
5. **Réglages GitHub** : « Require signed commits », protection de `main`, *push protection*.
6. **Comportement exact de `%G?`** pour une signature SSH sans `allowedSignersFile` (aucune clé configurée).
7. **Test réel négatif pour `design`** vers `reviews/securite-*` : je n'ai qu'une simulation, plus mon propre test réel négatif (hors projet) qui montre que `agent_type` est transmis.
8. **Présence garantie de `agent_id`** pour tout sous-agent dans les futures versions de Claude Code. CF-05 en dépend : si `agent_id` disparaît, un sous-agent sans type serait traité comme la session principale.
9. **`.gitignore` généré par Flutter** dans `android/` (`local.properties`) : les apps ne sont pas encore créées.
