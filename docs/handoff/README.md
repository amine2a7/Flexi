# Protocole de l'équipe d'agents FlexiPay

Ce dossier est la **mémoire durable** de l'équipe : une équipe d'agents ne survit pas à `/resume`, ce qui est écrit ici, si.
Le résumé de ce protocole est repris dans `CLAUDE.md` (section « Équipe d'agents »), chargé par tous les coéquipiers.

## 0. Mode économe (depuis le 2026-10-21, prime sur la suite)

- **Pas de mode équipe** : une seule session travaille. Sous-agents seulement : `securite` pour chaque tâche touchant l'authentification, les permissions, l'argent ou les données personnelles ; `design`, `qualite`, `ux`, `conformite` en **une revue groupée à la fin de chaque espace** (Commun, Commerçant, Entreprise, Administrateur).
- **Modèles** : `securite` et `ledger-auditor` en opus, les autres en sonnet. Hook TeammateIdle désactivé.
- **Lecture** : seulement les fichiers de la tâche en cours (spec de l'écran, composants concernés), jamais tout `docs/`.
- **Hooks Git** : sujet clos, sauf constat Critique ou Haute.
- **Rapports** : 15 lignes maximum (fait, à vérifier dans le navigateur, bloquants) ; le détail va dans `docs/handoff/`.
- **Une tâche à la fois**, petite, terminée et commitée avant la suivante ; `docs/handoff/BOARD.md` mis à jour après chaque tâche (reprise possible après `/clear`).

Les sections suivantes restent la référence pour les rôles, les étiquettes de messages et les périmètres quand un sous-agent est appelé.

## 1. L'équipe

| Nom (adresse) | Définition | Rôle |
|---|---|---|
| `main` (le « lead ») | session principale | Découpe, assigne, route, arbitre, surveille, rend compte. **Ne code pas.** |
| `securite` | `.claude/agents/securite.md` (opus) | Revue de sécurité, modèle de menaces, droit de blocage |
| `design` | `.claude/agents/design.md` (sonnet) | Specs d'écran avant le code, tokens, revue de fidélité |
| `backend` | `.claude/agents/backend.md` (sonnet) | API NestJS, ledger, contrat OpenAPI, infra, monorepo |
| `frontend` | `.claude/agents/frontend.md` (sonnet) | Web Next.js : Administrateur, Entreprise, Commerçant |
| `mobile` | `.claude/agents/mobile.md` (sonnet) | Flutter : app Employé, app Pro (Commerçant) |
| `ux` | `.claude/agents/ux.md` (sonnet) | **Relecteur** : expérience utilisateur des specs (avant le code) et des écrans réels (Nielsen, WCAG 2.1 AA, RTL, microcopie) ; user stories proposées au lead |
| `qualite` | `.claude/agents/qualite.md` (sonnet) | **Relecteur** : qualité du code hors sécurité (architecture, typage, tests, conventions, performances) |
| `conformite` | `.claude/agents/conformite.md` (sonnet) | **Relecteur**, en dernier : conformité aux demandes (cahier, specs, décisions, contrat, BOARD), matrice de traçabilité |

Les **relecteurs** (`securite`, `ux`, `qualite`, `conformite`) ne modifient jamais le code ni les specs des autres : ils écrivent leurs revues dans `docs/handoff/reviews/` et envoient leurs constats au propriétaire.

Sous-agents de support (lancés par un coéquipier, pas membres de l'équipe) : `ledger-auditor` (invariants financiers, lecture seule) et `test-writer` (tests d'abord, fichiers de test uniquement).

> Adresse du lead : **`main`** (session principale). Dans cette version de Claude Code, les coéquipiers nommés sont des agents en arrière-plan : l'adresse `team-lead` n'existe pas. Écrire « lead » dans les textes, adresser les messages à `main`. Un agent ne peut pas « attendre » dans son tour : il envoie son message et termine son tour ; un message entrant le relance.

## 2. Communication directe (a)

Les coéquipiers se parlent par message (`SendMessage`), par leur nom. **Chaque message commence par une étiquette** sur sa première ligne (c'est la seule ligne visible en aperçu) :

| Étiquette | Usage | Contenu obligatoire |
|---|---|---|
| `[QUESTION]` | Besoin d'une info d'un autre agent | Question précise, ce qui est bloqué en attendant |
| `[CONTRAT]` | Contrat d'API ou schéma publié ou modifié | Chemin du fichier, ce qui change, cassant ou non |
| `[SPEC]` | Spec d'écran prête | Chemin de la spec, exigences couvertes |
| `[LIVRÉ]` | Tâche prête à être relue | Fichiers, comment tester, points d'attention |
| `[CONSTAT]` | Problème trouvé en revue | Sévérité, fichier:ligne, preuve, correctif proposé |
| `[CORRIGÉ]` | Réponse à un constat | Ce qui a changé, fichier:ligne, test ajouté |
| `[BLOQUÉ]` | Impossible d'avancer | Raison, ce qu'il faut, de qui |
| `[DÉCISION]` | Une règle métier manque | **Toujours adressé à `main`**, jamais tranché seul |

Exemples :
```
[CONTRAT] docs/handoff/contracts/openapi.yaml — ajout GET /payouts/quote (non cassant)
[SPEC] docs/design/specs/demande-virement.md — COM-07, prête pour frontend et mobile
[CONSTAT] Haute — apps/api/src/modules/payouts/payouts.controller.ts:42 — merchantId lu dans le corps (IDOR)
[CORRIGÉ] payouts.controller.ts:42 — merchantId tiré de la session ; test « refuse un autre commerçant » ajouté
[BLOQUÉ] contrat /payments absent : impossible de coder l'écran de validation (besoin : backend)
[DÉCISION] Arrondi de la commission : round_half_up ou banker's ? (glossaire : « à confirmer »)
```

## 3. Qui parle à qui (b)

| De → À | Quand | Étiquette |
|---|---|---|
| design → frontend / mobile | Une spec est prête, **avant** qu'ils codent l'écran | `[SPEC]` |
| backend → frontend + mobile | L'OpenAPI est publié ou change. **Tout changement cassant est annoncé AVANT d'être fait** | `[CONTRAT]` |
| frontend / mobile → backend | Le contrat ne couvre pas un besoin. **On ne contourne jamais l'API** | `[QUESTION]` |
| tout agent → securite | Fin de chaque tâche touchant auth, permissions, argent, QR, données personnelles, dépendances ou configuration | `[LIVRÉ]` |
| securite → propriétaire du code | Revue terminée avec problème | `[CONSTAT]` |
| propriétaire → securite | Correction faite ; securite **revérifie** | `[CORRIGÉ]` |
| frontend / mobile → design | Écran terminé, revue de fidélité | `[LIVRÉ]` |
| producteur → qualite | Fin de chaque tâche de code (en parallèle de securite) | `[LIVRÉ]` |
| design → ux puis conformite | Spec d'écran prête, **avant** qu'elle soit codée | `[SPEC]` |
| frontend / mobile → ux | Écran terminé, après securite et qualite | `[LIVRÉ]` |
| relecteurs → conformite | Verdicts de securite, qualite, ux ; conformite relit en dernier | verdict |
| ux / qualite / conformite → propriétaire | Revue avec problème ; le propriétaire répond `[CORRIGÉ]`, le relecteur revérifie | `[CONSTAT]` |
| design → frontend / mobile | Résultat de la revue | OK ou `[CONSTAT]` |
| tout agent → main | Blocage, règle manquante, fin de tâche | `[BLOQUÉ]`, `[DÉCISION]`, rapport (j) |

Tout constat **Critique** est copié immédiatement à `main`, qui le remonte à l'utilisateur.

## 4. Liste de tâches partagée (c)

- Le lead découpe chaque phase en tâches de taille raisonnable (**5 à 6 par coéquipier**), avec responsable, dépendances et relecteur (ex. « écran X web » dépend de « spec X » et de « contrat X »).
- **Une tâche de revue `securite` est créée après chaque tâche sensible**, et une revue `design` après chaque tâche d'interface.
- Une tâche dont les tests sont écrits avant le code (tests rouges attendus) a un sujet préfixé **`TEST-FIRST:`** : le hook accepte alors des tests en échec, lint et typecheck restent obligatoires.
- Le lead reporte l'état dans `BOARD.md` à chaque étape.

## 5. Périmètres (d)

Un agent n'écrit **que** dans son périmètre. Pour toucher au périmètre d'un autre, il lui envoie un message. **Deux agents ne modifient jamais le même fichier.** Le hook `enforce-scope` bloque toute écriture hors périmètre (source : `.claude/hooks/lib/scopes.js`).

| Agent | Écrit dans |
|---|---|
| main | `docs/handoff/BOARD.md`, `decisions.md`, `README.md`, `reports/`, `CLAUDE.md`, `.claude/` (réservés) |
| securite | `docs/security/`, `docs/handoff/reviews/securite-*` |
| design | `docs/design/` (dont `specs/`), `packages/ui-tokens/`, `docs/handoff/reviews/design-*` |
| backend | `apps/api/`, `packages/shared/`, `packages/api-client/`, `packages/config/`, `infra/`, `docker-compose*`, `docs/handoff/contracts/`, config racine du monorepo, `.github/` |
| frontend | `apps/web/` |
| mobile | `apps/mobile-employe/`, `apps/mobile-pro/` |
| ux | `docs/handoff/reviews/ux-*` (dont `ux-captures/`) |
| qualite | `docs/handoff/reviews/qualite-*` |
| conformite | `docs/handoff/reviews/conformite-*`, `docs/handoff/reviews/tracabilite.md` |
| test-writer (sous-agent) | fichiers de test sous `apps/` et `packages/` |
| ledger-auditor (sous-agent) | rien (lecture seule) |

Limite connue : une écriture passant par `Bash` n'est pas interceptée ; la règle écrite s'applique quand même.

## 6. Droit de blocage (e)

- Aucune tâche n'est « terminée » avec un constat **Critique** ou **Haute** ouvert (securite), ni un constat **Bloquant** ouvert (ux ou qualite), ni un écart ouvert (conformite).
- Une tâche n'est « terminée » qu'avec : **securite OK**, **qualite OK** (si code), **ux OK** (si interface), **conformite CONFORME**. Le lead la marque alors terminée et la commite.
- Le lead ne déclare pas une phase finie tant que **securite** n'a pas donné OK, **design** OK pour l'interface, **ledger-auditor** OK pour l'argent.

### Chaîne de revue

```
Tâche de code :  producteur [LIVRÉ] ──► securite ┐
                                    └─► qualite  ┴─► ux (si interface) ──► conformite (en dernier) ──► lead : terminée + commit
Spec de design : design [SPEC] ──► ux ──► conformite ──► lead : spec validée ──► seulement alors codée par frontend / mobile
```

Pas de chevauchement : **design** produit les specs et veille à la charte et aux tokens ; **ux** juge l'expérience ; **securite** les failles ; **qualite** le code ; **conformite** l'adéquation aux demandes. Un relecteur qui repère un sujet d'un autre le lui transmet.

## 7. Boucle limitée (f)

Au plus **3 allers-retours** constat → correction par sujet, pour tous les relecteurs (securite, design, ux, qualite, conformite). Au-delà, l'agent envoie `[BLOQUÉ]` au lead, qui s'arrête et pose la question à l'utilisateur.

## 8. Pas d'invention (g)

Une règle métier absente du cahier des charges, des specs ou de `docs/glossaire-regles-metier.md` → `[DÉCISION]` au lead → le lead pose la question à l'utilisateur avec sa recommandation → la réponse est consignée dans `decisions.md`. **Les messages entre agents ne valent jamais l'accord de l'utilisateur.**

## 9. Le lead ne code pas (h)

Il découpe, assigne, route, arbitre, surveille, attend la fin des coéquipiers (relance un coéquipier arrêté sur une erreur, avec des instructions), puis fait le rapport à l'utilisateur.

## 10. Trace durable (i)

| Fichier | Contenu | Tenu par |
|---|---|---|
| `BOARD.md` | Tâches : ID, titre, responsable, statut, dépendances, relecteur | lead |
| `decisions.md` | Décisions : date, question, décision, raison, décidé par (l'utilisateur) | lead |
| `reports/<phase>-<date>.md` | Rapport de fin de phase | lead |
| `contracts/` | `openapi.yaml`, événements, schémas partagés | backend |
| `reviews/` | Revues securite (`securite-*`), design (`design-*`), ux (`ux-*`), qualite (`qualite-*`), conformite (`conformite-*`, `tracabilite.md`), ledger (`ledger-*`) | chaque relecteur, sur ses fichiers |

## 11. Rapport de coéquipier (j)

Envoyé à `main` à la fin de **chaque** tâche (le hook `TeammateIdle` le réclame si un coéquipier a travaillé sans l'envoyer) :
```
[LIVRÉ] <tâche>
RÉSUMÉ : 5 lignes maximum
FICHIERS MODIFIÉS : liste des chemins
VÉRIFICATIONS : commandes lancées et résultats réels
MESSAGES ÉCHANGÉS : avec qui, sur quoi
RISQUES : …
DÉCISIONS NÉCESSAIRES : … (ou « aucune »)
```

## 12. Rapport du lead à l'utilisateur (à chaque tâche et chaque phase)

1. Résumé en 5 lignes
2. Ce qui a été fait (fichiers principaux)
3. Échanges entre agents importants (qui a signalé quoi, comment c'est résolu)
4. Décisions prises et pourquoi
5. Vérifications : lint, typecheck, tests, analyse statique — avec résultats réels
6. Sécurité : constats par sévérité, ouverts / fermés, verdict
7. Design : verdict de fidélité et accessibilité (si interface)
8. UX : verdict (OK / À REVOIR) et constats ouverts par gravité (si interface)
9. Qualité : verdict (OK / À REVOIR) et constats ouverts par gravité
10. Conformité : verdict (CONFORME / NON CONFORME), écarts ouverts, état de la matrice de traçabilité
11. Questions pour l'utilisateur, avec la recommandation du lead pour chacune
12. Prochaine étape proposée

## 13. Hooks qualité

| Hook | Script | Effet |
|---|---|---|
| PreToolUse (Edit/Write) | `enforce-scope.js` | Bloque une écriture hors périmètre |
| PreToolUse (Edit/Write/NotebookEdit) | `protect-files.js` | Bloque `.env*`, `secrets/`, `*.pem`, `*.key`, migrations existantes (chemins Windows, casse, flux `::$DATA`, noms courts 8.3) |
| git pre-commit (natif) | `.githooks/pre-commit` | gitleaks sur l'index réel du commit, après l'indexation (`-a`, chemins, alias compris) ; refus si gitleaks est absent (S1-01). Protège aussi les commits de l'utilisateur. Activé par poste (§14) |
| git pre-push (natif) | `.githooks/pre-push` | gitleaks sur chaque commit poussé, y compris ceux créés sans pre-commit (stash, cherry-pick, am, rebase) ; refus si gitleaks est absent (S1-09) |
| PreToolUse (Bash) | `guard-bash.sh` → `guard-bash.js` | Analyse le seul segment `git … commit` (jamais le message) ; corps de heredoc traités comme données sauf s'ils alimentent un interpréteur ou psql (S1-10). Refuse `-n`/`--no-verify` (et abréviations) sur commit et push, toute modification de `core.hooksPath`, de `.githooks/` ou de `.git/config` hors git, les variables `GIT_CONFIG_*`/`GIT_DIR`/`GIT_INDEX_FILE`, les alias, les sous-commandes git non littérales, `commit-tree` ; vérifie avant commit ou push que les hooks natifs sont actifs et intacts (S1-01, S1-02, S1-09). Aide : SQL destructeur sur ledger et audit, hors messages de commit (CF-09). Une modification de `.githooks/` déjà commité est commitée par l'utilisateur |
| PostToolUse (Edit/Write) | `format.sh` | Prettier / dart format |
| TaskCompleted | `task-completed.js` | Refuse la complétion si lint, typecheck ou tests du périmètre échouent |
| TeammateIdle | `teammate-idle.js` | Réclame le rapport (j) à un coéquipier qui a travaillé sans l'envoyer |

## 14. Reprise sur un nouveau poste

À faire **avant de lancer l'équipe** sur toute nouvelle machine. Le lead vérifie lui-même chaque point et reporte le résultat dans `BOARD.md` (section Prérequis).

### Outils et versions requis
| Outil | Version minimale | Rôle |
|---|---|---|
| Git | 2.40+ | Dépôt, revues `git diff main...HEAD` |
| Node.js | 20 LTS+ (testé : 22.22) | Hooks (`.claude/hooks/*.js`), monorepo |
| pnpm | 9+ (doit **s'exécuter**, pas seulement être installé) | Monorepo, hook TaskCompleted |
| Docker Desktop + WSL2 | Docker 24+, Compose v2 | PostgreSQL 16, Redis, Testcontainers |
| Flutter SDK (canal stable) + Android Studio | Flutter 3.22+ / Dart 3.4+ ; Android SDK et un émulateur ou appareil | Apps mobiles (iOS plus tard : nécessite un Mac) |
| Claude Code | 2.1.222+ (hooks TaskCompleted / TeammateIdle) | Équipe d'agents |
| gitleaks (**obligatoire**) | 8+ | Hook git natif `.githooks/pre-commit` : sans gitleaks, aucun commit (CF-02, S1-01) ; CI |

### Commandes de vérification (Git Bash)
```bash
git --version && node --version && npm --version
pnpm -v                                 # doit afficher une version, pas une erreur de stratégie
docker --version && docker compose version && docker info --format '{{.ServerVersion}}'
flutter --version && dart --version && flutter doctor   # Android : tout en ✓
claude --version
gitleaks version                        # obligatoire (sinon tout commit est refusé)
git config --local core.hooksPath .githooks   # active le hook natif (une fois par clone) ; vérifier avec --get
echo "AGENT_TEAMS=$CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS"   # doit valoir 1 (défini dans .claude/settings.json)
git config --local user.name && git config --local user.email   # identité du dépôt
git config core.autocrlf                # avec .gitattributes (eol=lf), les hooks .sh restent en LF
pnpm turbo telemetry disable            # une fois par poste (S1-07) ; en CI : TURBO_TELEMETRY_DISABLED=1
pnpm audit -P                           # audit des dépendances de production (« --prod » est refusé par la règle deny *prod*)
```

### Pièges Windows (constatés le 2026-10-11 sur le PC personnel)
- **`echo` de Git Bash et chemins Windows** : `echo "C:\Program Files\Docker\Docker\resources\bin"` interprète `\r` et `\b` (retour chariot, retour arrière) et produit un chemin corrompu, y compris dans un fichier écrit par redirection. Utiliser des barres obliques (`C:/Program Files/...` ou `/c/Program Files/...`) ou `printf '%s\n' '<chemin>'` (guillemets simples).
- **CLI `claude`** : l'extension VS Code ne fournit pas la commande `claude` dans le terminal. Installer la CLI (`npm install -g @anthropic-ai/claude-code` ou l'installeur officiel), puis vérifier `claude --version` (2.1.296 sur le PC personnel). La fonction équipe se lance depuis la CLI en terminal interactif.
- **Docker hors PATH** : Docker Desktop installe ses binaires dans `C:/Program Files/Docker/Docker/resources/bin`. Si `docker` est introuvable, rouvrir le terminal après le premier démarrage de Docker Desktop, ou ajouter ce dossier au PATH utilisateur.
- **Hyperviseur non chargé** (N-02) : `docker run hello-world` → `open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified`, et les logs (`%LOCALAPPDATA%/Docker/log/host/com.docker.backend.exe.log`) affichent `HCS_E_HYPERV_NOT_INSTALLED`, alors que la virtualisation est active dans le BIOS et que WSL, VirtualMachinePlatform et Hyper-V sont activés. Diagnostic : `(Get-CimInstance Win32_ComputerSystem).HypervisorPresent` vaut `False`. Correctif (PowerShell **administrateur**) : `bcdedit /set hypervisorlaunchtype auto`, puis **redémarrage complet** (pas un arrêt avec démarrage rapide). Si la valeur était déjà `Auto` : `wsl --install --no-distribution` puis redémarrage.
- **gitleaks** : installé par `winget install Gitleaks.Gitleaks` ; rouvrir le terminal pour qu'il soit dans le PATH. Il est obligatoire (CF-02) : sans lui, tout commit lancé par Claude est refusé.

### Démarrage de la fonction équipe
Vérifier que la fonction équipe démarre : `claude --version`, lancement en **terminal interactif** (pas l'extension VS Code), `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. Si `TaskCompleted` et `TeammateIdle` ne se déclenchent toujours pas, passer au hook `SubagentStop`.

> Constat du 2026-10-09 (extension VS Code, Claude Code 2.1.222) : les agents nommés se sont comportés en sous-agents en arrière-plan (adresse du lead `main`, pas de liste de tâches partagée) ; aucun déclenchement de `TaskCompleted` ni de `TeammateIdle` n'a été observé.

### Signature des commits (CF-08, à faire avant la phase 1)
- Sur chaque poste, signature SSH des commits (clé personnelle de l'utilisateur, jamais dans le dépôt) :
  `git config --local gpg.format ssh` · `git config --local user.signingkey <chemin de la clé publique>` · `git config --local commit.gpgsign true`.
- Ajouter la clé publique comme *Signing key* sur GitHub, puis activer **« Require signed commits »** dans la protection de la branche `main`.
- Vérification locale des signatures SSH : créer un fichier de signataires autorisés hors du dépôt (ligne `<email> <clé publique>`) puis `git config --local gpg.ssh.allowedSignersFile <chemin du fichier>` ; sans ce fichier, `%G?` n'affiche pas `G` (S9-06, à confirmer à la mise en place).
- Vérification : `git log --format='%h %G? %s' -5` doit afficher `G` (signature valide).
- Les commits antérieurs à la mise en place (non signés) restent tels quels ; aucune réécriture d'historique.

### Tests des hooks (obligatoires à chaque reprise)
Les hooks lisent leur entrée en JSON sur stdin : on les teste en leur envoyant des entrées simulées et en vérifiant le code de sortie (0 = laisse passer, 2 = bloque).
Toujours **exécuter le hook comme fichier** (`bash .claude/hooks/x.sh`, `node .claude/hooks/x.js`), jamais son contenu via `bash -c` (sous Windows, guillemets et antislashs sont altérés et le test donne un faux résultat). `CLAUDE_PROJECT_DIR` au format Windows (`C:/Users/...`), pas `/c/Users/...`.
```bash
export CLAUDE_PROJECT_DIR="$PWD"
# Périmètres de tous les agents (55 cas, dont ux, qualite, conformite) : tous doivent passer
node --test .claude/hooks/test/enforce-scope.test.js
# guard-bash (78 cas : -n, --no-verify, core.hooksPath, .githooks, GIT_CONFIG_*, alias, heredocs, faux positifs, SQL) : tous doivent passer
node --test .claude/hooks/test/guard-bash.test.js
# Périmètres : doit bloquer (2), puis laisser passer (0)
echo '{"agent_type":"securite","tool_input":{"file_path":"apps/api/x.ts"}}' | node .claude/hooks/enforce-scope.js; echo "code $?"
echo '{"agent_type":"securite","tool_input":{"file_path":"docs/security/x.md"}}' | node .claude/hooks/enforce-scope.js; echo "code $?"
# Fichiers protégés : doit bloquer (2)
echo '{"tool_input":{"file_path":".env"}}' | node .claude/hooks/protect-files.js; echo "code $?"
# TeammateIdle : transcript sans rapport après une écriture → 2
```
Pour `task-completed.js`, créer un faux projet **hors du dépôt** avec `apps/web/package.json` dont `lint` et `typecheck` réussissent (`node -e "process.exit(0)"`) et `test` échoue (`node -e "process.exit(1)"`), puis lancer avec `CLAUDE_PROJECT_DIR=<faux projet>` :
- sujet `"Ecran X"` → **2** (tests en échec) ;
- sujet `"TEST-FIRST: Ecran X"` → **0** (tests rouges tolérés, lint et typecheck verts) ;
- `lint` en échec avec `TEST-FIRST:` → **2** ;
- un `apps/mobile-pro/pubspec.yaml` présent → `flutter analyze` doit réellement tourner.

**Le cas `TEST-FIRST:` n'a jamais pu être validé avec le vrai pnpm sur le premier poste** (pnpm bloqué par Device Guard) : il doit être revérifié en priorité. Ne lancer l'équipe que si tous les cas donnent le code attendu.
