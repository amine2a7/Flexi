# Revue securite : dépendances (78312b8), CI B6 (17532c2), QY-03 b (a37e727)

Date : 2026-10-29 · Branche : `feat/web` · Relecteur : securite
Référentiels : OWASP ASVS 4.0.3 niveau 2 (V14.2 dépendances, V14.1 build), OWASP API Top 10, modèle de menaces §3.3, §3.4.

## Verdict : **OK** (aucun Critique ni Haute ouvert ; 2 Moyennes, 3 Basses)

## 1. Dépendances (78312b8)

Vérifié :

- Versions directes : `next` 16.4.2, `zod` 4.6.7 (api, web, shared), `prisma`, `@prisma/client`, `@prisma/adapter-pg` 7.10.1, conformes à la décision du 2026-10-29. Lockfile résolu sur ces versions (`pnpm-lock.yaml` : `next@16.4.2`, `zod@4.6.7`, `prisma@7.10.1`, etc.).
- Overrides nouveaux bornés à la majeure vulnérable : `body-parser@^2` → 2.4.0, `fast-uri@^3` → 3.1.9, `multer@^2` → 2.5.0, `undici@^7` → 7.30.1. Aucune montée de majeure ; `undici@8.11.2` (autre chemin) reste intact et n'est pas signalé. `mysql2` et `deepmerge-ts` non ajoutés (n'étaient « que si nécessaires »).
- `pnpm audit -P` (exécuté le 2026-10-29) : **1 vulnérabilité, Moyenne**, `qs` 6.16.0 (GHSA-6pq8-jhm2-2vcw, via `express@5.2.1`), conforme à la dérogation refusée jusqu'au 2026-11-10. Aucune Critique, aucune Haute. `--audit-level=high` : code de sortie 0.
- `onlyBuiltDependencies` inchangé (`@prisma/engines`, `prisma`).

Remarque (hors commit) : l'override ancien `uuid@^10` → 11.1.1 franchit une majeure ; déjà accepté (décision du 2026-10-11), sans suite.

## 2. CI B6 (17532c2)

Vérifié : `permissions: contents: read` au niveau du workflow (aucun job n'élève) ; aucun `pull_request_target`, `workflow_run`, déploiement, secret de dépôt ni `${{ github.event.* }}` dans un `run:` ; `persist-credentials: false` sur les deux checkouts ; secrets de test générés par exécution (`openssl rand`) ; `pnpm install --frozen-lockfile` ; gitleaks v8.30.1 sur l'historique complet (`fetch-depth: 0`, `--exit-code 1`, `--redact`) ; `pnpm audit -P` et Semgrep (`--error`, `--metrics=off`) bloquants, sans `continue-on-error`.

```
[CONSTAT] DC-01 : le job de sécurité est rouge tant que qs (Moyenne) n'est pas corrigé
Sévérité : Moyenne
Fichier : .github/workflows/ci.yml:82
Preuve : `pnpm audit -P --audit-level=moderate` → exit=1 (qs 6.16.0) ; `--audit-level=high` → exit=0. Le modèle de menaces (SC-10) fixe le seuil bloquant à « high ».
Scénario d'attaque : jusqu'au 2026-11-10 le job « security » échoue sur chaque PR ; l'équipe prend l'habitude de fusionner malgré un job rouge (ou retire le check requis), et une vraie fuite détectée par gitleaks ou Semgrep dans le même job passe inaperçue (« un contrôle qui échoue en permanence n'est pas un contrôle »).
Correctif proposé : `--audit-level=high` (conforme à SC-10), ou exception tracée `pnpm.auditConfig.ignoreGhsas: ["GHSA-6pq8-jhm2-2vcw"]` retirée le 2026-11-10 avec la montée de qs ; séparer gitleaks, audit et Semgrep en étapes/jobs distincts pour que l'échec de l'un ne masque pas les autres.
Exigence : ASVS 14.2.1 ; modèle de menaces SC-10, CI-7
```

```
[CONSTAT] DC-02 : actions et images épinglées par étiquette mutable, pas par SHA ni empreinte
Sévérité : Moyenne
Fichier : .github/workflows/ci.yml:29, 39, 42, 43, 69, 75, 77, 78, 85
Preuve : `actions/checkout@v4`, `pnpm/action-setup@v4` (tierce), `actions/setup-node@v4`, `postgres:16`, `ghcr.io/gitleaks/gitleaks:v8.30.1`, `semgrep/semgrep:1.100.0`.
Scénario d'attaque : un attaquant qui compromet le mainteneur de `pnpm/action-setup` réécrit l'étiquette `v4` (cas tj-actions, mars 2025). Le jeton est en lecture et le job sans secret, donc pas de vol ni de push ; mais l'action modifiée peut remplacer le binaire pnpm ou neutraliser gitleaks/audit (faux vert) et faire passer une PR malveillante.
Correctif proposé : épingler chaque action par SHA complet avec la version en commentaire (`uses: actions/checkout@<sha40> # v4.x.y`), images par `@sha256:` ; activer Dependabot `github-actions` et `docker` pour les mises à jour ; limiter les actions autorisées dans les réglages du dépôt. Monter Semgrep vers une version maintenue au passage (les jeux de règles `p/*` sont aussi tirés sans épinglage : à accepter ou figer).
Exigence : ASVS 14.2.4 ; modèle de menaces SC-7, SC-8
```

```
[CONSTAT] DC-03 : secrets de test non masqués dans les logs
Sévérité : Basse
Fichier : .github/workflows/ci.yml:50-56
Preuve : valeurs écrites dans `$GITHUB_ENV` sans `::add-mask::`.
Scénario d'attaque : un test ou un outil qui affiche son environnement imprime `SESSION_SECRET`/`DATA_ENCRYPTION_KEY` en clair dans des logs lisibles. Impact nul aujourd'hui (valeurs jetables), mais le motif sera recopié pour de vrais secrets.
Correctif proposé : `echo "::add-mask::$v"` avant chaque export.
Exigence : ASVS 14.1.3 ; modèle de menaces CI-5
```

## 3. QY-03 b (a37e727)

Vérifié : migration 0017 nouvelle (pas de modification d'une ancienne), colonne `created_by UUID` nullable ; `admin.service.ts:273` renseigne `createdBy: principal().userId` (identité serveur, jamais du corps de requête) ; `payouts.service.ts:568-572` second `ensureNotAuthor` après verrouillage `FOR UPDATE` de la demande, refus 403 audité (`fourEyes.refused`) ; test d'intégration `payments.test.ts:436` : créateur → 403 + audit, autre admin Finance → 200.

**Commerçants antérieurs (`created_by` nul) non refusés : acceptable.** Aucune production, données de dev synthétiques ; le premier contrôle (auteur de la demande) reste actif. Fermer en échec (`authorRequired`) bloquerait les virements de tous les commerçants anciens sans gain réel.

```
[CONSTAT] QY-01 : aucun test ne prouve que la route de création renseigne createdBy
Sévérité : Basse
Fichier : apps/api/test/integration/payments.test.ts:40-66
Preuve : le test injecte `createdBy` par l'aide `createMerchant(..., creator.id)` en base ; le chemin `POST /v1/admin/merchants` → `createdBy` n'est pas couvert.
Scénario d'attaque : une régression supprime la ligne `createdBy` à la création ; tous les nouveaux commerçants ont un créateur nul, le contrôle devient muet et le super-admin crée un commerçant puis approuve seul ses virements, sans qu'aucun test ne casse.
Correctif proposé : test créant le commerçant par l'API avec l'admin A, puis approbation par A → 403.
Exigence : ASVS 1.11.2 ; décision 2026-10-21 (quatre yeux)
```

```
[CONSTAT] QY-02 : créateurs connus mais non reportés pour les commerçants existants
Sévérité : Basse (risque accepté possible)
Fichier : apps/api/prisma/migrations/0017_merchant_created_by/migration.sql:3
Preuve : pas de reprise depuis le journal `merchants.create`.
Scénario d'attaque : en préproduction, un admin qui a créé un commerçant avant la migration approuve ses virements.
Correctif proposé : soit nouvelle migration de reprise depuis `audit_log` (`action = 'merchants.create'`, acteur), soit acceptation notée ; aucun effet tant qu'il n'y a pas de production.
Exigence : décision 2026-10-21
```

## Non vérifié

- Exécution des tests d'intégration (PostgreSQL requis) et d'un vrai run GitHub Actions : notamment que gitleaks dans Docker scanne bien N > 0 commits (risque `dubious ownership` de git sur le volume monté, qui ferait un scan vide) ; à confirmer dans le log du premier run.
- Réglages du dépôt GitHub (protection de branche, checks requis, approbation des PR de forks, visibilité) : pas d'accès.
- Provenance npm et absence de scripts d'installation des 4 overrides : vérification du lead reprise de la décision, non refaite par moi.
- Contenu des correctifs amont (changelogs de next, zod, prisma) : non relu.
