# Revue qualité — BLOC 5 (API réelle NestJS/PostgreSQL, web branché) + A (comptes et invitations) + B (requêtes pg séquentielles, deux onglets)

- **Relecteur** : qualite
- **Date** : 2026-10-15
- **Branche** : `feat/web`, périmètre `3c958c2^..38110ed` **sauf** `9c44aea` (animations)
- **Commits relus** : 3c958c2, 88fd5ae, dac48a2, a0149c4, 4494706, 1d44eca, 49350e8, 3a33a6b, 57b56cf, c6c6fb3, bb8a50e (A), 38110ed (B)
- **Propriétaires** : `backend` (apps/api, packages/api-client, contrat) · `frontend` (apps/web : lib/api, mocks, scripts/dev.mjs)

## Verdict : **À REVOIR**

1 Bloquant, 6 Majeurs, 14 Mineurs, 3 Suggestions. Le Bloquant est mesuré : un import de 5 000 salariés (limite de la spec) occupe toute la file Argon2id environ 38 s. Pendant ce temps, toute connexion et toute vérification de PIN de la plateforme attend.

Ce qui est bon : l'injection explicite `@Inject` est faite partout, `any`, `@ts-ignore` et `console.log` sont absents du code applicatif, et il y a un seul `commissionOf` côté API, en BIGINT avec arrondi demi supérieur. Les tests d'intégration vont jusqu'à PostgreSQL et couvrent le RLS, les invariants du ledger, la concurrence sur un portefeuille et le parcours complet de l'invitation. Le correctif B est propre : aucun `Promise.all` ne reste sur une transaction et aucun avertissement pg n'apparaît dans les 4 exécutions. Le client web a ses tests écrits d'abord (409, rejeu CSRF, pas de boucle).

---

## Commandes lancées et résultats réels

Les exécutions 1 à 4 ont eu lieu entre 09:30 et 09:35, sur le code commité. Les fichiers de `apps/api/src` modifiés depuis par `backend` (travail en cours, non commité) datent de 09:47 et `concurrency.test.ts` de 09:35:33.

| Commande | Résultat |
|---|---|
| `pnpm --filter @flexipay/api lint` | OK (0 erreur, 0 avertissement) |
| `pnpm --filter @flexipay/api typecheck` | OK (prisma generate + tsc, couvre `src`, `test`, `scripts`, `prisma`) |
| `pnpm --filter @flexipay/api test` (unitaires) | OK : 4 fichiers, 19 tests |
| `pnpm --filter @flexipay/api test:integration` (flexipay_test), exécution 1 | OK : 7 fichiers, 53 tests, 22,4 s |
| idem, exécutions 2, 3, 4 (recherche d'instabilité) | OK : 53/53 à chaque fois (21,5 s / 21,5 s / 22,2 s) ; 0 « already executing a query », 0 DeprecationWarning |
| idem, exécution 5, **sous charge** (web test + typecheck en parallèle) | **Non retenue** : 3 échecs dans `concurrency.test.ts`, un fichier non commité de `backend` (TEST-FIRST en cours, fichiers `src` modifiés pendant l'exécution). Hors périmètre. Voir M6 sur le partage de la base de test |
| `pnpm --filter @flexipay/web lint` | OK |
| `pnpm --filter @flexipay/web typecheck` | OK (next typegen + tsc) |
| `pnpm --filter @flexipay/web test` | OK : 14 fichiers, 194 tests |
| idem **sous charge** | 1 échec : `test/conventions/source-conventions.test.ts:47`, délai de 5 s dépassé (hors périmètre, S3) |
| ESLint avec règles temporaires `max-lines-per-function` 70, `complexity` 15, `max-depth` 4 (`--rule`, rien écrit) | 11 dépassements (S1) |
| Mesure Argon2id (node, paramètres de `password.ts`) | 1 hachage : 17 ms ; 200 en parallèle : 1 522 ms, soit **environ 38 s pour 5 000** ; un hachage de connexion mis en file derrière 200 hachages d'import attend **1 555 ms** |
| Lecture du runtime Prisma 7.10 (`@prisma/client/runtime/client.js`, `@prisma/adapter-pg/dist/index.js`) | Les erreurs pg portent `meta = { driverAdapterError }`, sans `meta.code` (voir M1) |

---

## Constats

### Bloquant

**[CONSTAT B1] L'import de salariés bloque Argon2id pour toute la plateforme (environ 38 s pour 5 000 lignes)**
- Gravité : **Bloquant**
- Fichiers : `apps/api/src/auth/invitation.service.ts:52-63` (`prepare` : `Promise.all` sur toute la liste) · `apps/api/src/company/company.service.ts:372-381` (appel avec toutes les lignes valides, jusqu'à 5 000, `company.controller.ts:54`)
- Problème : chaque ligne déclenche un hachage Argon2id (19 MiB, t=2) et les 5 000 hachages sont lancés d'un coup. Ils passent par une file FIFO à 4 fils (mesure ci-dessus). L'import met environ 38 s à répondre, souvent au-delà du délai d'un proxy ; le client réessaie alors, alors que l'aperçu est déjà consommé (409). Surtout, pendant ces 38 s, chaque `verifySecret` et `hashSecret` de la plateforme attend derrière : connexion, changement de mot de passe, **PIN de paiement** (`pin.service.ts`). Une action métier normale d'une entreprise gèle donc l'encaissement chez tous les commerçants.
- Correctif proposé : ne plus hacher dans la requête. Option 1 : créer les comptes sans mot de passe utilisable, puis générer, hacher et envoyer l'invitation dans un job (BullMQ est dans la stack) à concurrence 1. Option 2, provisoire : hacher par petits lots à concurrence bornée (1 ou 2), avec un plafond de lignes par requête et une durée maximale documentée. Ajouter un test qui vérifie la concurrence bornée de `prepare` (compteur de hachages en vol).
- Référence : point 9 (performances) de la mission ; spec 05 (import jusqu'à 5 000 lignes). Volet déni de service transmis à `securite`.

### Majeurs

**[CONSTAT M1] La correspondance « verrou ou délai dépassé → 503 réessayable » ne se déclenche jamais (code mort, non testé)**
- Gravité : Majeur
- Fichier : `apps/api/src/common/problem.filter.ts:56-65`
- Problème : le filtre lit `error.meta.code`. Avec `@prisma/adapter-pg` 7.10, le code pg est dans `meta.driverAdapterError.cause.originalCode`. `40001`/`40P01` deviennent `P2034` ; `55P03` et `57014` deviennent `P2039` (ORM) ou `P2010` (SQL brut). `P2028` (délai `maxWait` d'ouverture de transaction) n'est pas traité non plus. Sous contention (paiements sur un même portefeuille, `lock_timeout` de 5 s), le client reçoit donc `500 INTERNAL_ERROR` au lieu de `503 SERVICE_UNAVAILABLE` avec `Retry-After`, et l'erreur est journalisée comme une erreur inconnue. Aucun test ne couvre ce chemin (aucune occurrence de 503 dans `test/`).
- Correctif proposé : un seul décodeur dans `common/`, par exemple `prismaFailure(error)`, qui teste `instanceof Prisma.PrismaClientKnownRequestError` et associe P2002 → 409, P2034/P2028 → 503, et P2010/P2039 avec `originalCode` 55P03/57014 → 503. L'utiliser dans `problem.filter.ts` et dans `invitation.service.ts` (voir m1). Ajouter un test d'intégration : une transaction tient `FOR UPDATE` sur un compte, une seconde requête dépasse le `lock_timeout` et doit recevoir 503 avec `Retry-After`.
- Référence : point 6 de la mission (gestion des erreurs, format du contrat §4).

**[CONSTAT M2] L'envoi des invitations après le commit n'est pas fiable et aucun chemin ne permet de renvoyer**
- Gravité : Majeur
- Fichiers : `apps/api/src/admin/admin.service.ts:277`, `:365` · `apps/api/src/company/company.service.ts:282`, `:408` · `apps/api/src/auth/invitation.service.ts:102-120` · `apps/api/src/common/outbox.service.ts:27-30`
- Problème : `deliver` envoie les messages un par un après le commit. Si un envoi échoue (disque, et plus tard fournisseur), la route répond 500 alors que les comptes sont créés, et les invitations suivantes ne partent pas. L'utilisateur réessaie et reçoit 409 : le compte existe avec un mot de passe temporaire que personne ne connaît. En `production`, `OutboxService.send` se contente d'un avertissement et n'envoie rien : chaque création produit un compte inutilisable sans rien signaler à l'appelant. Le nom « Outbox » laisse croire à une boîte d'envoi transactionnelle, ce qu'elle n'est pas. La spec 05 prévoit `POST /company/employees/{id}/resend-credentials`, absent du contrat et de l'API (transmis à `conformite`).
- Correctif proposé : écrire l'invitation dans une table d'envoi **dans la même transaction** que le compte (mot de passe temporaire chiffré, ou mieux, régénéré à l'envoi), puis la délivrer par un job avec reprise. À défaut, en attendant : capturer chaque échec d'envoi, le journaliser sans contenu, ne pas transformer une création réussie en 500, et livrer la route de renvoi de la spec.
- Référence : point 6 de la mission ; spec 05 §API.

**[CONSTAT M3] L'API réécrit les schémas et constantes de `packages/shared`, qu'elle déclare sans jamais l'importer**
- Gravité : Majeur
- Fichiers : `apps/api/src/common/validation.ts:89-91` (`millimes`, `positiveMillimes`, `rateBps`) · `apps/api/src/common/money.ts:22-24` (`10_000` en dur) · `apps/api/src/common/tunis.ts:4` (`'Africa/Tunis'`) · `apps/api/package.json` (`@flexipay/shared` en dépendance, 0 import dans `src`, `scripts`, `prisma`, `test`)
- Problème : `packages/shared` contient déjà `amountMillimesSchema`, `positiveAmountMillimesSchema`, `rateBpsSchema`, `BPS_PER_UNIT` et `BUSINESS_TIME_ZONE`. Les règles d'argent (bornes des millimes, des points de base) ont donc deux sources qui peuvent diverger.
- Correctif proposé : importer ces schémas et constantes depuis `@flexipay/shared`, en complétant le paquet si un schéma manque, et supprimer les doublons. Sinon, retirer la dépendance inutile et consigner pourquoi.
- Référence : CLAUDE.md (Stack : `packages/shared` = schémas Zod, constantes) ; points 3 et 10 de la mission.

**[CONSTAT M4] Le seed de l'API exécute un fichier interne de l'app web, sans valider le résultat, dans une fonction de 1 060 lignes**
- Gravité : Majeur
- Fichiers : `apps/api/prisma/seed.ts:127-136` (exécute `apps/web/src/mocks/export-snapshot.ts`) · `:135` (`JSON.parse(output) as Snapshot`) · `:36-107` (interface `Snapshot` recopiée à la main) · `:224` (callback de transaction : 1 060 lignes, complexité 99) · `apps/web/src/mocks/export-snapshot.ts`
- Problème : 1) la frontière entre apps n'est pas respectée : l'API dépend d'un chemin interne de `apps/web`, avec un périmètre et un propriétaire différents. Un renommage dans les mocks casse `db:seed` sans erreur de typage. 2) `as Snapshot` est une assertion qui masque toute dérive de forme : l'interface est maintenue à la main des deux côtés. 3) Une fonction de 1 060 lignes avec des fonctions imbriquées (`pay` 91 lignes, `payout` 130 lignes) est difficile à relire alors qu'elle écrit dans le ledger, même en développement.
- Correctif proposé : déplacer les générateurs et données de démonstration dans un paquet de développement partagé (par exemple `packages/demo-data`, non publié) importé par MSW et par le seed, avec un type exporté unique. À défaut, valider la sortie avec un schéma Zod commun. Découper le seed en modules (comptes, commandes, paiements, virements, KYC), chacun avec ses fonctions.
- Référence : point 2 (frontières du monorepo), points 4 et 5 (complexité, typage) de la mission.

**[CONSTAT M5] La garde contre les requêtes parallèles sur une transaction est partielle, et `relationJoins` (préversion) n'est pas consigné**
- Gravité : Majeur
- Fichiers : `apps/api/prisma/schema.prisma:10` · `apps/api/test/integration/connections.test.ts:19-22`, `:56`
- Problème : 1) **Pertinence de `relationJoins`** : la correction est juste et efficace sur le symptôme, car un `findMany` avec `include` devient une seule requête et l'aller-retour est même plus court. Mais la fonction est encore en préversion dans Prisma 7.10 (`isPreviewFeatureOn("relationJoins")` dans le générateur), elle change la stratégie de **toutes** les lectures (jointures LATERAL et agrégation JSON) et elle ne couvre que les `include`. Les écritures imbriquées et les autres cas que le moteur parallélise ne sont pas prouvés. 2) **Le test ne prouve qu'une partie** : il passe sur 6 routes GET et repose sur un avertissement `util.deprecate`, émis **une seule fois par processus**. Il n'a pas de contrôle positif qui prouverait que le détecteur fonctionne, et le reste de la suite (écritures, paiements, virements) n'est pas surveillé, contrairement à ce qu'annonce le message de commit (« no pg warning in the whole suite »).
- Correctif proposé : détecteur déterministe et global. Dans un `setupFiles` de `vitest.integration.config.ts`, envelopper `pg.Client.prototype.query` avec un compteur de requêtes en vol par client et faire échouer le test courant si une requête démarre pendant qu'une autre tourne. On couvre ainsi toute la suite, sans dépendre d'un avertissement unique. Consigner le choix de `relationJoins` dans un ADR (préversion, version de Prisma figée, revérification à chaque montée de version, piste de sortie si Prisma sérialise lui-même les requêtes d'une transaction dans l'adaptateur).
- Référence : point 7 (pertinence des tests), point 10 (dépendances) de la mission ; `docs/adr/`.

**[CONSTAT M6] Tests d'intégration instables : deux causes probables trouvées**
- Gravité : Majeur
- Fichiers : `apps/api/test/integration/ledger.test.ts:308-326` · `apps/api/src/common/db.service.ts:66` (`maxWait: 5_000`) · `apps/api/test/integration/global-setup.ts` (DROP puis CREATE de `flexipay_test`)
- Problème : l'échec isolé signalé n'a pas été reproduit en 4 exécutions sur le code commité. Deux causes plausibles, la seconde constatée aujourd'hui :
  1. **200 paiements simultanés** sur un portefeuille, avec un pool pg par défaut (10 connexions), un `maxWait` de 5 s et un `lock_timeout` de 5 s. Sur une machine chargée (l'exécution consignée dans `apps/api/var/it.log` a duré 116 s contre 22 s), une transaction peut échouer en `P2028` ou par délai de verrou au lieu de `InsufficientFundsError`. Le test attend exactement 140 refus ; `refused` vaut alors moins de 140 et le test échoue sans aucune erreur fonctionnelle.
  2. **Base de test partagée entre agents** : `global-setup` supprime et recrée `flexipay_test` à chaque exécution. Aujourd'hui à 09:46, un autre agent lançait la suite (journal `it.log` du scratchpad : 13 échecs, dont « sign-in failed ») pendant mon exécution de 09:47. Deux exécutions simultanées se détruisent la base l'une l'autre.
- Correctif proposé : 1) dans le test de concurrence, faire échouer explicitement sur toute raison autre que `InsufficientFundsError` en affichant la raison, et dimensionner le pool et `maxWait` du test (ou réduire à 50 paiements) pour que le test mesure l'invariant et non la vitesse de la machine. 2) un nom de base unique par exécution (`flexipay_test_<pid>`, supprimée à la fin), ou un verrou consultatif PostgreSQL pris par `global-setup`, pour sérialiser les exécutions.
- Référence : point 7 de la mission (tests pertinents et fiables) ; hook TaskCompleted (une porte instable bloque à tort ou laisse passer à tort).

### Mineurs

**[CONSTAT m1] `isUniqueViolation` repose sur du typage par forme et sur le texte du message**
- `apps/api/src/auth/invitation.service.ts:123-130`. Le repli `message.includes('Unique constraint')` est fragile et peut classer à tort une autre erreur. Correctif : `instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002'`, dans le décodeur commun de M1.

**[CONSTAT m2] Charge utile des validations lue par double assertion**
- `apps/api/src/admin/admin.service.ts:474`, `:480` (`as unknown as PlatformSettingsInput`), `:544`. La charge utile JSON d'une validation à quatre yeux (taux de commission, paramétrage) est appliquée sans contrôle de forme. Une demande en attente créée par une version antérieure s'appliquerait sans erreur. Correctif : la relire avec le schéma Zod de la saisie avant de l'appliquer.

**[CONSTAT m3] CSV analysé deux fois, indices de colonnes en dur, lignes écartées en silence**
- `apps/api/src/company/company.service.ts:289-293` : deuxième analyse avec `slice(3, 4)` et `slice(0, 5_001)` ; `:311` : `column === 4`. Puis `:367-370` : à la confirmation, une ligne dont l'e-mail est pris entre l'aperçu et la confirmation est écartée sans être signalée. Enfin `:322-327` : un e-mail déjà présent chez les salariés est rattaché au champ `employeeNumber`, alors qu'un e-mail déjà utilisé par un compte l'est au champ `email` (incohérent). Correctif : une seule fonction `parseEmployeeCsv`, des constantes de colonnes nommées, des lignes rejetées renvoyées dans la réponse.

**[CONSTAT m4] Nom court recopié 4 fois et troncature silencieuse**
- `${firstName} ${lastName.charAt(0)}.` dans `company.service.ts:255`, `:376` et `pin.service.ts:78`, `:108`. Par ailleurs, `invitation.service.ts:77` tronque `displayName.slice(0, 120)` sans le signaler. Correctif : une fonction `shortName()` commune ; une longueur maximale validée à l'entrée plutôt qu'une troncature.

**[CONSTAT m5] `OutboxService` : repli sur localhost recopié, textes en dur dans les services**
- `apps/api/src/common/outbox.service.ts:43`, `:47` : le repli `'http://localhost:3001'` est recopié alors que `env.ts:14` a déjà cette valeur par défaut ; `signInUrl()` devrait réutiliser `webOrigin()`. Les textes des messages sont en dur dans `invitation.service.ts:106-117` et `auth.service.ts` (`deliver`). Correctif : un module de gabarits de messages (FR maintenant, langue de l'utilisateur ensuite, conformément à l'i18n FR/AR/EN).

**[CONSTAT m6] Dépendance inversée : `CommonModule` fournit un service de `auth/`**
- `apps/api/src/common/common.module.ts:4`, `:27`, `:49` (`InvitationService`, comme `SessionService` avant lui). Correctif : exporter `InvitationService` depuis `AuthModule` (importé par les modules qui en ont besoin), ou le déplacer dans `common/` s'il est vraiment transverse.

**[CONSTAT m7] `prepare([un])` puis `if (invitation !== undefined)` trois fois**
- `apps/api/src/company/company.service.ts:251`, `:278`, `:282`. Correctif : `prepareOne(invitee): Promise<PreparedInvitation>`.

**[CONSTAT m8] Trous de couverture dans `accounts.test.ts`, et des tests qui écrivent dans `var/` du développeur**
- `apps/api/test/integration/accounts.test.ts`. La garantie centrale de l'ADR implicite (« rien n'est envoyé pour un compte non créé ») n'est pas vérifiée : le test 409 (`:171-188`) ne contrôle pas l'absence de fichier dans la boîte d'envoi. Ne sont pas testés non plus : l'aperçu d'import qui signale un e-mail déjà utilisé (`company.service.ts:326`), la confirmation d'import avec un e-mail pris entre-temps, le 409 sur commerçant et entreprise. L'assertion `password.length >= 12` (`:126`) est faible : le format est 4 groupes de 4 séparés par des tirets. `temporaryPassword()` n'a pas de test unitaire (alphabet, groupes, contraintes). `invitationTo` (`:34-44`) relit tout `var/outbox`, jamais vidé et partagé avec le développement (déjà plus de 40 fichiers) ; les tests écrivent aussi dans `var/uploads` (plus de 70 fichiers). Correctif : un `UPLOAD_DIR` temporaire par exécution, supprimé à la fin, et les tests manquants.

**[CONSTAT m9] Code mort dans un test d'authentification**
- `apps/api/test/integration/auth.test.ts:186`, `:189-190` : `const thief = new WebClient(base)` n'est jamais utilisé, et `expect(thief).toBeDefined()` n'affirme rien ; l'attente de 50 ms n'est pas expliquée alors que la révocation est validée avant la réponse. Correctif : supprimer les deux. Si l'attente masque une vraie course, la nommer et la tester.

**[CONSTAT m10] Client web : fuite des copies de requêtes, rejeu de l'`Idempotency-Key` non testé**
- `apps/web/src/lib/api/client.ts:83-107` : la `Map copies` n'est vidée que dans `onResponse`. Sur une erreur réseau, openapi-fetch 0.17 appelle `onError`, que ce code n'implémente pas, et la copie reste en mémoire avec son corps (téléversements KYC compris). `apps/web/test/lib/api-client.test.ts` ne vérifie pas que le rejeu après 403 CSRF garde la même `Idempotency-Key` : c'est la condition qui rend le rejeu sûr pour une opération financière. Les faux minuteurs sont restaurés dans le corps du test (`:136-144`) et non dans `afterEach`. Correctif : `onError` qui supprime la copie, un test du rejeu avec `Idempotency-Key`, `vi.useRealTimers()` dans `afterEach`.

**[CONSTAT m11] Demande de paiement de démonstration : erreurs ignorées**
- `apps/web/src/app/[locale]/beneficiaire/payer/page.tsx:337-345` : `fetch` direct, hors du client typé, toléré parce qu'il s'agit d'une route de développement hors contrat. `.then(onCreated)` est appelé même sur une réponse 4xx ou 5xx, et aucun `.catch` n'existe : une erreur réseau devient une promesse rejetée non gérée. L'en-tête de canal web n'est pas envoyé. Correctif : vérifier `response.ok`, afficher l'état d'erreur, ajouter `.catch`.

**[CONSTAT m12] Le test MSW prouve désormais `notMocked`, pas la régression corrigée**
- `apps/web/test/mocks/msw-server.test.ts:25-27` : le test passe encore, mais le rejet vient maintenant du gestionnaire final `notMocked` et non de `onUnhandledRequest: 'error'`. La description et le commentaire d'en-tête sont dépassés. Le cas du bogue corrigé n'est pas testé : une route `/v1` reconnue seulement par `sessionRestore` partait vers le réseau. Il manque aussi la preuve que `notMocked`, placé en dernier, ne masque pas une route servie. Correctif : deux tests explicites (route `/v1` inconnue après `sessionRestore` → erreur réseau ; route servie → réponse du gestionnaire) et un intitulé à jour.

**[CONSTAT m13] Mocks : règle de commission recopiée et repli silencieux à 0**
- `apps/web/src/mocks/admin-seed.ts:116-120` : formule `Math.floor((gross * rate + 5_000) / 10_000)` réécrite au lieu de `commissionOf` de `db.ts:202`. La résolution du taux « propre au commerçant, sinon taux du type, sinon 0 » est recopiée dans `admin-seed.ts:116-119` et `handlers/admin-ops.ts:130-134`. Correctif : une fonction `rateOf(merchant, creditType)` dans `mocks/db.ts`, sans repli à 0 (lever une erreur de données).

**[CONSTAT m14] Composant web : double import et logique de `CommissionLabel` recopiée**
- `apps/web/src/components/ui/credit-type.tsx:8` et `:10` importent le même module `amount` par deux chemins (`@/components/ui/amount` et `./amount`). `apps/web/src/app/[locale]/commercant/page.tsx:99-105` réécrit le cas « taux par type » de `CommissionLabel`. Correctif : un seul import ; réutiliser `CommissionLabel` (ou un petit `RateOrByType`).

### Suggestions

**[S1] Points de complexité à surveiller** (mesure ESLint temporaire) : `common/auth.guard.ts:27` `canActivate` (complexité 27) · `ledger/ledger.service.ts:133` `post` (28) · `company/company.service.ts:303` (20) et `:487` `allocate` (98 lignes) · `payouts/payouts.service.ts:277` `request` (89 lignes) et `:108` `dashboard` (71) · `orders/orders.service.ts:346` `checkDeclaration` (17). Proposition : ajouter `complexity` et `max-lines-per-function` en avertissement dans `packages/config` pour stopper la croissance, sans refonte immédiate (règle 16).

**[S2] `session.service.ts` (refresh)** : `SELECT … FOR UPDATE` puis `findUnique` font deux lectures de la même ligne. Une seule lecture verrouillante suffirait. Mineur en performance, mais la constante `CONCURRENT_REFRESH_MS` gagnerait à être exposée dans le contrat (30 s y est écrit en clair).

**[S3] Hors périmètre, constaté pendant la revue** : `apps/web/test/conventions/source-conventions.test.ts:47` dépasse le délai de 5 s sous charge (balayage synchrone de l'arborescence). Proposition : un délai explicite pour ce fichier, ou une liste des fichiers lue une seule fois en `beforeAll`.

---

## Points demandés par le lead : réponses

- **Architecture et injection** : l'injection est explicite partout (`@Inject(...)`, compatible avec tsx et esbuild sans métadonnées). Contrôleurs minces, services porteurs de la logique. Écarts : m6 (CommonModule fournit un service de `auth/`), M3 (shared ignoré).
- **Duplication** : la commission côté API est unique (`commissionOf`) ; elle est recopiée dans les mocks (m13). Les invitations sont factorisées dans `InvitationService`, mais le schéma d'appel reste répété (m7) et le nom court aussi (m4). Seed : M4.
- **Typage strict** : aucun `any` ni `@ts-ignore`. Assertions à revoir : `seed.ts:135` (M4), `admin.service.ts:474/480/544` (m2), `invitation.service.ts:125` et `problem.filter.ts:57` (m1, M1).
- **Correspondance P2002 → 409** : elle fonctionne, puisque le test 409 passe par la contrainte unique des `users`. Mais elle repose sur du typage par forme et un repli textuel (m1), et le reste du décodage des erreurs Prisma est faux (M1).
- **`relationJoins`** : pertinent comme correctif immédiat, insuffisant comme garantie (M5). À consigner en ADR, avec un détecteur global.
- **Exporteur `export-snapshot.ts`** : couplage entre apps à supprimer (M4).
- **Test MSW `notMocked`** : correctif juste, test à recibler (m12).
- **Instabilité** : non reproduite en 4 exécutions ; deux causes probables (M6).
- **Restes** : aucun `TODO`, `FIXME` ni `console.log` dans le code relu (le seed est autorisé par la configuration ESLint). Code mort : m9 et la branche 503 de M1. Dépendance inutile : `@flexipay/shared` dans l'API (M3).

## Transmis à `securite` (hors périmètre qualité)

1. Déni de service par l'import (B1, volet disponibilité).
2. L'aperçu d'import (`company.service.ts:288-293`, `:326`, portée `system`) révèle à une entreprise quelles adresses e-mail ont déjà un compte FlexiPay, tous tenants confondus : énumération possible.
3. La fenêtre de 30 s du refresh concurrent (`session.service.ts`, `refresh`) : un jeton volé et rejoué dans les 30 s reçoit 409 sans révocation de la famille. Compromis à valider.
4. `admin.service.ts:466-487` (`approve`) : la validation est relue sans verrou de ligne avant d'être appliquée. Deux approbations simultanées peuvent passer. `backend` écrit en ce moment des tests de concurrence sur ce sujet (C2).

## Transmis à `conformite`

- `POST /company/employees/{id}/resend-credentials` (spec 05) est absent du contrat et de l'API (lié à M2).

## Non vérifié

- `pnpm build` (API et web) : non lancé. Le build web supprime `public/mockServiceWorker.js` et aurait coupé un serveur `pnpm dev` utilisé par d'autres agents ; le lead ne l'avait pas demandé.
- Couverture chiffrée (`--coverage`) : non mesurée ; `@vitest/coverage-v8` n'est pas vérifié dans les dépendances.
- Hypothèse 1 de M6 (épuisement du pool sous charge) : déduite de la configuration et du code ; la seule exécution sous charge est invalide (travail non commité de `backend` modifié pendant l'exécution).
- La forme exacte de l'erreur `P2028` sous `maxWait` avec l'adaptateur pg n'a pas été provoquée ; seul le code du runtime a été lu.
- `apps/api/src/generated/` (généré, ignoré par git) et les migrations SQL 0001 à 0009 sous l'angle sécurité (RLS) : laissés à `securite` et `ledger-auditor`.
- Les pages web de `9c44aea` (animations) : hors périmètre par consigne.
