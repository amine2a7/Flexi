# Revue de conformité : vague 1 (B1, B2, D1, B4) et fidélité du BOARD

- **Date :** 2026-10-11 · **Relecteur :** conformite · **Branche :** `feat/web` (aucun commit, aucun push)
- **Base :** `git show` de 98add0a, 4431e45, a63412b, 7606a7a ; fichiers à HEAD 12c66bf ; `BOARD.md` et `decisions.md` du jour ; revues `securite-p0-s1-vague1-2026-10-11.md` et `qualite-q0-vague1-2026-10-11.md`.
- **Références :** `BOARD.md` (titres et critères de fin), CLAUDE.md règles 1-5, 15-18, contrat `openapi.yaml` (SHA-256 `82bf61bd…`, vérifié), glossaire, décisions du 2026-10-11.

## Verdicts

| Tâche | Commit | Verdict conformité | Remarque |
|---|---|---|---|
| P0-B1 monorepo | 98add0a | **CONFORME** | securite OK, qualite OK (Q0-03 Important ouvert, non bloquant côté conformité) |
| P0-B2 `packages/shared` | 4431e45 | **CONFORME** | securite OK, qualite OK |
| P0-D1 `packages/ui-tokens` | a63412b | **CONFORME** | securite OK, qualite OK ; compilation Dart reportée par décision du 2026-10-11 |
| P0-B4 Compose + Testcontainers | 7606a7a | **NON CLÔTURABLE** (statut du BOARD « En revue » exact) | critère de fin « docker compose healthy + `pnpm test:integration` » non exécuté : Docker ne répond pas |

## Tableau de conformité

| Exigence ou critère | Référence | Constaté | Statut |
|---|---|---|---|
| B1 : workspace pnpm + Turborepo, `turbo.json`, `tsconfig.base`, ESLint/Prettier partagés, scripts lint/typecheck/test/build | BOARD P0-B1 | `pnpm-workspace.yaml`, `turbo.json`, `tsconfig.base.json`, `packages/config/{eslint.js,prettier.js}` ; scripts racine `build lint typecheck test test:integration` dans `package.json` ; `pnpm lint` 5/5, `pnpm typecheck` 4/4 réussis (relancés par conformite) | Conforme |
| B1 : rien d'inventé | CLAUDE.md r16 | pas de code métier ; `test:e2e` est un no-op (Q0-11, Amélioration qualite) | Conforme |
| B2 : squelette Zod, types, constantes (millimes, bps), outillage de tests | BOARD P0-B2 ; CLAUDE.md r1-r2 ; contrat §2 | `money.ts` (entier 0..2^53-1, `tndToMillimes` refuse fractions), `rate.ts` (0..10 000), `enums.ts` (`Currency`, `Direction`, `BUSINESS_TIME_ZONE='Africa/Tunis'`) ; `pnpm --filter @flexipay/shared test` : 47/47 (relancé) | Conforme |
| B2 : alignement avec le contrat | contrat `AmountMillimes`, `RateBps`, `Direction`, `Currency` | bornes identiques ; pas de test de dérive contrat/shared (Q0-12, qualite) | Conforme |
| D1 : `design-tokens.json` → preset Tailwind + `ThemeData` Flutter, tests dont contrastes AA | BOARD P0-D1 ; CLAUDE.md r18 | `src/tailwind.ts`, `src/dart.ts`, `generated/`, `dart/lib/flexipay_tokens.dart` ; `contrast.test.ts`, `generation.test.ts` : 87/87 (relancé) | Conforme |
| D1 : Dart non compilé | décision 2026-10-11 (liste de tâches et limite de D1) | consigné au BOARD et au README du paquet | Conforme (limite acceptée) |
| B4 : Compose PostgreSQL 16 + Redis, healthchecks, aucun secret en dur | BOARD P0-B4 | `infra/docker-compose.yml` : images épinglées, `healthcheck` sur les deux services, mots de passe en `${VAR:?}`, ports `127.0.0.1` | Conforme (lecture) |
| B4 : socle Testcontainers | BOARD P0-B4 | `infra/testing/` ; tests unitaires `pnpm --filter @flexipay/testing-infra test` : 12/12 (relancé) ; tests d'intégration présents (`postgres.test.ts`, `redis.test.ts`) mais non exécutés | Partiel |
| B4 : « docker compose healthy » et `pnpm test:integration` | BOARD P0-B4 (reste) | non exécutables : une commande `docker info` lancée par conformite n'a rien renvoyé (bloquée), cohérent avec « Docker arrêté (C: plein) » | Manquant (en attente de Docker) |
| Un commit par tâche, message avec identifiant | décision 2026-10-11 (base de branche) | 98add0a, 4431e45, a63412b, 7606a7a, un par tâche ; titres `feat(...) P0-Bn/D1` | Conforme |
| Revues préalables présentes | README §6 | securite : OK ×4 (B4 sur lecture) ; qualite (Q0) : OK ×4 ; ux : sans objet (pas d'interface) | Conforme |
| Dépendances : dérogations enregistrées | décision 2026-10-11 (S1-06) | `source-map-js` 1.2.2 et `uuid` 11.1.1 notées dans `decisions.md` | Conforme |
| Rien d'interdit : pas d'IR, de mandat, de float monétaire, de donnée réelle | CLAUDE.md « Acteurs », r1 | aucune occurrence ; ESLint interdit `parseFloat` et `toFixed` | Conforme |

## Écarts sur le BOARD (à corriger par `main`)

```
[CONSTAT] B-01 PRE-2 « Docker ❌ » contredit P0-S9 « N-02 fermé » et la ligne P0-B4
Type : BOARD inexact
Référence : BOARD.md lignes 15, 28, 52 ; revue securite S1 (partie 1 : « docker info → serveur 29.8.2 », puis partie 4 : le démon ne répond plus)
Constaté : PRE-2 décrit « Docker Desktop is unable to start » (hyperviseur) ; P0-S9 déclare N-02 « fermé (hyperviseur) » ; P0-B4 invoque « Docker arrêté (C: plein) ». Trois états différents pour le même prérequis. Le démon a répondu pendant la revue S9 puis a cessé (disque C: plein, image déplacée sur D: par décision du 2026-10-11). Aujourd'hui : ne répond pas.
Correctif attendu : une seule ligne PRE-2 datée « Docker : installé ; hyperviseur corrigé (N-02 fermé) ; démon arrêté le 2026-10-11 (C: plein), image déplacée sur D: ; à relancer pour B4 ».
```

```
[CONSTAT] B-02 Chemin corrompu dans PRE-2
Type : BOARD inexact
Référence : BOARD.md ligne 15 ; README §14 « Pièges Windows » (echo et antislashs)
Constaté : « `C:\Program Files\Docker\Docker\resources\bin`esourcesin` » (artefact de l'écho `\r`/`\b`).
Correctif attendu : `C:/Program Files/Docker/Docker/resources/bin`.
```

```
[CONSTAT] B-03 Statuts du BOARD en retard sur la réalité du 2026-10-11
Type : BOARD inexact
Référence : BOARD.md lignes 32-33, 62 (Q0), 69 (WB1), 35 (F1)
Constaté :
 - Q0 « À faire » alors que la revue `qualite-q0-vague1-2026-10-11.md` existe (verdict OK, 3 Important et 10 Amélioration ouverts) ;
 - P0-D2 et P0-D3 « Terminé » alors que ux a rendu **À REVOIR** (12 Important, `ux-d2-d3-2026-10-11.md`) et que conformite rend **NON CONFORME** (`conformite-specs-d2-d3-2026-10-11.md`) : selon le protocole (§6, chaîne de revue), une spec n'est « validée » qu'après ux et conformite ; D2 est d'ailleurs en cours de modification dans l'arbre de travail (design) ;
 - WB1 « À faire » alors que backend a envoyé son `[LIVRÉ]` (packages/api-client, qualite OK, securite en cours) ;
 - P0-F1 « À faire » alors que `apps/web/package.json` existe (frontend a commencé).
Correctif attendu : Q0 « Terminé (OK, 3 Important à corriger avant la fin de la phase) » ; D2/D3 « En revue : à corriger (ux À REVOIR, conformite NON CONFORME) » ; WB1 « En revue » ; F1 « En cours ».
```

```
[CONSTAT] B-04 Le plan « web d'abord » omet des exigences du cahier sans les exclure par décision
Type : Oublié
Référence : cahier §4.1-4.3, §5.6 ; BOARD lignes 63-67 (WD1, WD3, WD4, WD5)
Constaté (exigences absentes des listes de specs du BOARD, ni « Hors périmètre » ni décision d'exclusion) :
 - WD5 : ADM-08 règlements (lots, fichiers bancaires, rapprochements, litiges ; RG-6, RG-7, critère d'acceptation 7), alors que le module « Règlements & compensation » figure dans la navigation (cahier §5.6) ; rôles internes et blocage/déblocage (ADM-10) ; ADM-11 reporting, ADM-12 support, ADM-13 administration système (Should).
 - WD4 : ENT-03 suivi des commandes et preuves de virement, ENT-05 renvoi/réinitialisation du mot de passe temporaire, ENT-07 attribution récurrente (Should), ENT-09 comptabilité (Should, module de navigation).
 - WD3 : COM-05 reçu (email/SMS, impression), COM-08 factures/relevés/attestations, COM-10 contestations (Should) ; module « Statistiques » (navigation, aucune exigence associée).
 - Modules « Support » des trois espaces (navigation, cahier §5.6).
Correctif attendu : `[DÉCISION]` de `main` : soit ajouter ces écrans aux tâches WD3/WD4/WD5, soit les exclure explicitement du MVP web (avec décision de l'utilisateur) et retirer le module correspondant de la sidebar. Le Must (ADM-08, ENT-03, ENT-05, COM-05, COM-08) ne peut pas être exclu sans décision.
```

```
[CONSTAT] B-05 WD1 sans « mot de passe oublié »
Type : Oublié
Référence : spec 01 §5 (`POST /auth/password/forgot`, `/reset`) ; BOARD ligne 63 (WD1)
Constaté : la liste WD1 (connexion, première connexion, MFA, session expirée, 404/500) n'inclut pas la réinitialisation du mot de passe ni l'enrôlement MFA (QR) ; `_besoins-contrat.md` (design) les prévoit (CT-C-9/10, CT-C-3).
Correctif attendu : compléter la ligne WD1 du BOARD (mot de passe oublié et réinitialisation, enrôlement MFA).
```

```
[CONSTAT] B-06 COM-02 (scan QR) : web ou mobile seulement ?
Type : Oublié (règle absente)
Référence : cahier §4.3 (COM-02 Must, « Espace Commerçant (web + mobile) ») ; BOARD WD3 « encaissement (code manuel) »
Constaté : le plan web ne prévoit que le code manuel (COM-03). Aucun document ni décision ne dit que le scan caméra est exclu du web.
Correctif attendu : `[DÉCISION]` : scan caméra sur le web inclus, ou réservé à l'app Pro (à consigner).
```

```
[CONSTAT] B-07 « contrat e8b0a175 » (ligne P0-B5) : repère ambigu
Type : BOARD inexact (mineur)
Référence : BOARD.md ligne 29 ; B7 « SHA-256 82bf61bd » ; `sha256sum openapi.yaml` = `82bf61bd…`
Constaté : e8b0a175 est l'empreinte d'une version antérieure du contrat (pas un commit) ; la version courante est 82bf61bd.
Correctif attendu : préciser « SHA-256 e8b0a175 (version B5), 82bf61bd (après B7) » ou remplacer par l'empreinte courante.
```

## Points conformes du BOARD

Hashes des quatre commits exacts ; B1, B2, D1 « Terminé » avec leur commit et securite OK : exact ; B4 « En revue » avec ce qui reste : exact ; P0-S1 « Terminé » avec les réserves : exact ; P0-L3 « commit à faire par l'utilisateur » : cohérent avec `git status` (fichiers de hooks modifiés, `.githooks/pre-push` non suivi) ; hors vague 1 : contrat SHA-256 `82bf61bd…` = valeur annoncée par B7.

## Verdict

**B1 CONFORME · B2 CONFORME · D1 CONFORME · B4 NON CLÔTURABLE (BOARD exact) · BOARD : 7 écarts ouverts (B-01 à B-07)**, dont deux `[DÉCISION]` (B-04, B-06).

## Non vérifié

1. `docker compose up` et `pnpm test:integration` (B4) : Docker ne répond pas.
2. Compilation Dart et `flutter test` : Flutter absent (décision).
3. `pnpm audit` : refusé par les permissions ; repris de la revue securite.
4. Arbre de travail : `docs/design/design-tokens.json`, `generated/tailwind-preset.cjs`, `dart/lib/flexipay_tokens.dart` et `pnpm-lock.yaml` sont modifiés hors commit (design et backend en cours) ; la revue porte sur les commits de la vague 1 et non sur ces modifications.
