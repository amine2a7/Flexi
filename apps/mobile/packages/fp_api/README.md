# fp_api (EXPERIMENTAL)
# Contrat d'API FlexiPay (version 0.2.2)

Ce fichier est le **contrat de référence** entre l'API (`apps/api`), le web (`apps/web`) et les
apps Flutter (`apps/mobile-employe`, `apps/mobile-pro`). Il est tenu par **backend**. Toute
modification est annoncée par un message `[CONTRAT]` ; tout changement **cassant** est annoncé
**avant** d'être fait (ce qui casse, migration côté client, date).

Contenu : conventions transverses (§1 à §9), `GET /health`, authentification web et profil
(§10, espace Commun). Les autres endpoints métier (Commerçant, Entreprise, Administrateur,
ledger, paiements, virements…) sont ajoutés module par module, en respectant les règles
ci-dessous. Le client web TypeScript est **généré** à partir de ce fichier
(`packages/api-client`, test de fraîcheur) ; le client mobile Dart le sera plus tard.

**Décisions provisoires** : les choix appliqués à titre provisoire par l'utilisateur le
2026-10-12 sont listés dans `docs/decisions-provisoires.md` et cités ici par leur numéro
(« DP n° 23 ») ; ils peuvent changer. Une valeur marquée « provisoire » sans numéro est un
choix technique de backend, soumis à securite. Les points « en attente de décision »
attendent une décision de l'utilisateur (`[DÉCISION]` envoyé au lead).

Code, noms de champs, codes d'erreur et valeurs d'énumération sont en **anglais** ; les textes
affichés à l'utilisateur ne viennent **jamais** du serveur : le serveur renvoie des **clés i18n**
traduites par le client (FR, AR en RTL, EN).

## 1. Versionnement et URL
- Toutes les routes métier sont préfixées par la version majeure : `/v1/...`.
  Exception : `GET /health` (sonde d'infrastructure, hors version).
- Changement **non cassant** (dans `/v1`) : nouvel endpoint, nouveau champ de réponse, nouveau
  paramètre facultatif, nouveau code d'erreur, nouvelle valeur d'énumération.
  Les clients **ignorent les champs inconnus** et prévoient une **valeur de repli** pour toute
  valeur d'énumération inconnue (badge neutre, message d'erreur générique).
- Changement **cassant** (suppression ou renommage de champ, changement de type, nouveau champ
  obligatoire en entrée, changement de sémantique) : nouvelle version majeure `/v2`. L'ancienne
  version annonce sa fin par les en-têtes `Deprecation` (RFC 9745) et `Sunset` (RFC 8594).
- Chemins en minuscules avec tirets (`/v1/commission-grids`), ressources au pluriel.
- Champs JSON et paramètres de requête en `camelCase`. Valeurs d'énumération en
  `UPPER_SNAKE_CASE`.

## 2. Montants et taux (règle non négociable)
- Tout montant est un **entier en millimes** (1 TND = 1 000 millimes ; 45,000 TND = `45000`).
  Type JSON `integer`, format `int64`, bornes `0` à `9007199254740991` (plus grand entier exact
  en JavaScript). Le serveur n'**émet** jamais de nombre décimal ni de chaîne pour un montant.
  En entrée, la validation porte sur la **valeur analysée** : toute valeur fractionnaire
  (`45000.5`) ou de type chaîne (`\"45000\"`) est refusée (`VALIDATION_FAILED`, code de champ
  `NOT_INTEGER` ou `INVALID_TYPE`), de même que toute valeur hors bornes (`TOO_SMALL`,
  `TOO_BIG`). Une écriture décimale d'un entier (`45000.0`, `4.5e4`) est indiscernable de
  l'entier après analyse JSON : elle est acceptée comme cet entier ; les clients ne doivent
  jamais l'émettre.
- Nom des champs : suffixe **`Millimes`** (`amountMillimes`, `balanceMillimes`,
  `missingMillimes`, `remainingMillimes`…), y compris dans les paramètres de requête
  (`?amountMillimes=45000`).
- Devise : **TND uniquement** (le multi-devise est hors périmètre). Elle est implicite ; le
  schéma `Currency` (`\"TND\"`) n'apparaît que sur les ressources qui l'exposent (ex. comptes).
- **Aucun montant négatif** dans l'API : le sens d'un mouvement est porté par un champ
  `direction` (`DEBIT` | `CREDIT`), comme dans le ledger.
- Taux : **points de base**, entier `0` à `10000` (200 = 2 %, 150 = 1,5 %), suffixe **`Bps`**
  (`rateBps`).
- Le **formatage** (3 décimales, séparateur de milliers, virgule décimale en FR, symbole TND) est
  fait **uniquement côté client**, par un utilitaire unique par plateforme. Le serveur ne renvoie
  jamais de montant formaté.
- Le serveur ne fait **aucun calcul de montant en virgule flottante**. Les règles de calcul
  (arrondi des commissions, minimum) relèvent des contrats de module et des décisions du lead.

## 3. Dates, heures et identifiants
- Horodatages : chaîne **RFC 3339 / ISO 8601 en UTC** avec le suffixe `Z` et la précision
  milliseconde, ex. `2026-10-09T08:30:00.000Z` (schéma `Timestamp`). Champs suffixés `At`
  (`createdAt`, `expiresAt`). Le client convertit dans le fuseau de l'utilisateur pour
  l'affichage.
- Dates calendaires sans heure : `YYYY-MM-DD` (schéma `CalendarDate`), champs suffixés `Date`
  ou `On`, exprimées dans le fuseau **`Africa/Tunis`**.
- **Fuseau des règles métier : `Africa/Tunis`** (décision du 2026-10-09, cahier v4.1) : dates
  calendaires, fenêtres « jour » et « mois » des plafonds, échéance J+2 des règlements (jours
  calendaires), dates d'expiration des crédits et alertes J-30/J-7. Les horodatages échangés
  par l'API restent **toujours en UTC** (schéma `Timestamp`).
- Identifiants de ressource : **UUID** (chaîne, format `uuid`), **opaques** : le client n'en
  déduit rien et ne les construit jamais. Jamais d'entier séquentiel exposé. Un identifiant
  n'est **jamais** une autorisation : chaque accès est contrôlé côté serveur (voir §6).
- Références lisibles par un humain (numéro de commande, code de paiement manuel à 8 chiffres)
  : champs distincts, définis par chaque module.

## 4. Format d'erreur unique — Problem Details (RFC 9457)
Toute erreur (4xx, 5xx) est renvoyée avec `Content-Type: application/problem+json` et le schéma
`Problem` :

```json
{
  \"type\": \"urn:flexipay:problem:insufficient-funds\",
  \"title\": \"Insufficient funds\",
  \"status\": 422,
  \"code\": \"INSUFFICIENT_FUNDS\",
  \"messageKey\": \"errors.insufficientFunds\",
  \"requestId\": \"0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21\",
  \"details\": { \"missingMillimes\": 15000 }
}
```

- `code` : identifiant machine **stable** (`UPPER_SNAKE_CASE`) ; c'est **le seul champ que le
  client teste**. Un code n'est jamais renommé dans une version majeure.
- `messageKey` : clé i18n du message, traduite par le client. Le serveur ne renvoie **aucun
  texte destiné à l'utilisateur**.
- `title` : libellé technique anglais, fixe par code, **jamais affiché**.
- `type` : URN stable dérivée du code (`urn:flexipay:problem:<code-en-kebab-case>`).
- `requestId` : identifiant de corrélation (UUID), identique à l'en-tête `X-Request-Id`, à
  afficher comme « référence » pour le support.
- `details` : objet **typé selon le code**, absent quand le code n'a pas de détail.
- Le membre RFC `detail` (texte libre) et `instance` ne sont **jamais** envoyés.
- **Aucune fuite** : pas de trace de pile, de message SQL, de nom de table, de valeur saisie,
  de donnée personnelle, de token, de RIB, ni de **solde complet** dans une erreur.
- **Aucune énumération** : connexion et mot de passe oublié répondent de façon identique, que
  le compte existe, soit verrouillé ou non (le verrouillage est notifié au titulaire par un
  autre canal). Une ressource d'un autre tenant répond **404**, jamais 403.

### Catalogue des codes (phase 0)
| HTTP | `code` | `messageKey` | `details` |
|---|---|---|---|
| 400 | `VALIDATION_FAILED` | `errors.validationFailed` | `fields[]` : `in`, `pointer`, `code`, `messageKey`, `params?` |
| 400 | `IDEMPOTENCY_KEY_REQUIRED` | `errors.idempotencyKeyRequired` | — |
| 400 | `IDEMPOTENCY_KEY_INVALID` | `errors.idempotencyKeyInvalid` | — |
| 401 | `UNAUTHENTICATED` | `errors.unauthenticated` | — |
| 401 | `SESSION_EXPIRED` | `errors.sessionExpired` | — |
| 401 | `INVALID_CREDENTIALS` | `errors.invalidCredentials` | — |
| 401 | `MFA_CODE_INVALID` | `errors.mfaCodeInvalid` | — |
| 401 | `MFA_CHALLENGE_EXPIRED` | `errors.mfaChallengeExpired` | — |
| 403 | `PASSWORD_CHANGE_REQUIRED` | `errors.passwordChangeRequired` | — |
| 403 | `MFA_ENROLLMENT_REQUIRED` | `errors.mfaEnrollmentRequired` | — |
| 403 | `FORBIDDEN` | `errors.forbidden` | — |
| 403 | `CSRF_TOKEN_INVALID` | `errors.csrfTokenInvalid` | — |
| 404 | `NOT_FOUND` | `errors.notFound` | — |
| 409 | `IDEMPOTENCY_REQUEST_IN_PROGRESS` | `errors.idempotencyRequestInProgress` | `retryAfterSeconds` |
| 409 | `RESOURCE_STATE_CONFLICT` | `errors.resourceStateConflict` | — |
| 413 | `PAYLOAD_TOO_LARGE` | `errors.payloadTooLarge` | — |
| 415 | `UNSUPPORTED_MEDIA_TYPE` | `errors.unsupportedMediaType` | — |
| 403 | `PIN_INVALID` | `errors.pinInvalid` | `retryAfterSeconds?` (blocage en cours), `reauthenticationRequired?` (reconnexion complète exigée) |
| 422 | `IDEMPOTENCY_KEY_REUSED` | `errors.idempotencyKeyReused` | — |
| 422 | `INSUFFICIENT_FUNDS` | `errors.insufficientFunds` | `missingMillimes` (employé titulaire uniquement) ; **aucun** `details` pour un membre famille |
| 422 | `LIMIT_EXCEEDED` | `errors.limitExceeded` | `limitType`, `remainingMillimes` (employé titulaire ; membre famille : `FAMILY_MEMBER` et reste de sa propre limite) |
| 422 | `PAYMENT_DECLINED` | `errors.paymentDeclined` | — (réponse commerçant, raison jamais révélée) |
| 429 | `RATE_LIMITED` | `errors.rateLimited` | `retryAfterSeconds` |
| 500 | `INTERNAL_ERROR` | `errors.internal` | — |
| 503 | `SERVICE_UNAVAILABLE` | `errors.serviceUnavailable` | `retryAfterSeconds?` |

Comportement attendu côté client :
- `SESSION_EXPIRED` (jeton d'accès expiré) : **une** tentative de rafraîchissement silencieux,
  puis rejeu de la requête ; si le rafraîchissement échoue, écran « session expirée » puis
  connexion. `UNAUTHENTICATED` (pas de session, session révoquée ou invalide) : connexion
  directe, sans tentative de rafraîchissement.
- `PASSWORD_CHANGE_REQUIRED` : redirection vers le changement obligatoire du mot de passe
  temporaire ; tant qu'il n'est pas changé, seules les routes de changement de mot de passe et
  de déconnexion sont autorisées (spec 01, SEC-A2).
- `INSUFFICIENT_FUNDS` : pour l'employé titulaire, `missingMillimes` = montant manquant (E7 :
  solde 30 000, paiement 45 000 → `missingMillimes: 15000`). Ni le solde disponible ni le
  montant requis ne sont jamais renvoyés.
- `LIMIT_EXCEEDED` : `limitType` indique le plafond atteint, `remainingMillimes` le reste
  disponible (E8 : plafond jour 100 000, déjà 80 000, paiement 30 000 →
  `{ \"limitType\": \"DAILY\", \"remainingMillimes\": 20000 }`).
- **Règle d'exposition des refus de paiement** (anti-déduction du solde, décisions du
  2026-10-09) :
  - **Employé titulaire du wallet** (payeur) : code précis (`INSUFFICIENT_FUNDS`,
    `LIMIT_EXCEEDED`…) avec ses `details`.
  - **Membre famille** (payeur sur le wallet de l'employé, RG-2.3) : il ne voit **que le
    reste de sa propre limite**, jamais le solde de l'employé, ni à l'écran ni dans une
    erreur.
    - Limite du membre dépassée (E16) : `LIMIT_EXCEEDED` avec
      `{ \"limitType\": \"FAMILY_MEMBER\", \"remainingMillimes\": <reste de sa propre limite> }`.
    - Refus dû au solde de l'employé : `INSUFFICIENT_FUNDS` **sans `details`** (aucun
      `missingMillimes`, aucun montant).
    - Invariant : le seul montant jamais renvoyé à un membre famille est le reste de sa
      propre limite. Le cas d'un plafond de l'employé (transaction, jour, mois) atteint par un
      paiement du membre est **en attente de décision utilisateur (2026-10-09)** ; il sera
      fixé par le contrat paiements, dans le respect de cet invariant.
  - **Commerçant** (et tout appelant autre que le payeur) : **toujours** le code générique
    `PAYMENT_DECLINED`, sans `details`, quelle que soit la raison du refus — jamais
    `INSUFFICIENT_FUNDS`, `LIMIT_EXCEEDED`, `missingMillimes` ni `remainingMillimes`. Un code
    distinct, répété sur des initiations successives, permettrait de retrouver le solde du
    payeur par dichotomie. Le commerçant ne voit **jamais** le solde du client (COM-04,
    cahier v4.1) : le résultat est seulement « accepté » ou « refusé » (`PAYMENT_DECLINED`,
    sans motif ni montant).
  - Exigence transmise au futur contrat paiements : **une seule initiation par QR** (en plus
    de l'usage unique, E12).
- Refus métier (`409`, `422`) d'une opération financière : **aucune écriture au ledger** n'a
  été faite.
- Hors connexion (aucune réponse réseau) : détecté par le client, ce n'est pas un code API.

### Erreurs de validation
`details.fields[]` liste chaque champ invalide : `in` (`body`, `query`, `path`, `header`),
`pointer` (JSON Pointer RFC 6901 dans le corps, ex. `/amountMillimes` ; nom du paramètre pour
`query`, `path`, `header`), `code` (`FieldErrorCode`), `messageKey`
(`errors.field.<codeEnCamelCase>`, ex. `errors.field.tooSmall`) et `params` facultatif
(ex. `{ \"min\": 1 }`). La **valeur saisie n'est jamais renvoyée**. Les corps de requête sont
**stricts** : un champ inconnu est refusé (`UNKNOWN_FIELD`), ce qui empêche l'affectation de
masse.

## 5. Idempotence — en-tête `Idempotency-Key`
- **Obligatoire** sur toute opération financière (toute requête qui crée une écriture au
  ledger, une commande, une attribution, un paiement, un virement, un règlement, une
  contre-passation), et recommandé sur tout `POST` qui crée une ressource. Les opérations
  concernées portent le paramètre `IdempotencyKey` et l'extension `x-financial: true`.
- Format : **UUID** (v4 ou v7) en texte, 36 caractères, généré par le client **une fois par
  intention** de l'utilisateur (un clic « Payer » = une clé), et réutilisé à l'identique pour
  chaque nouvel essai réseau de cette même intention.
- Absent sur une opération qui l'exige : `400 IDEMPOTENCY_KEY_REQUIRED`. Mal formé :
  `400 IDEMPOTENCY_KEY_INVALID`.
- **Portée** : l'unicité est **composite** — (tenant, utilisateur authentifié, clé). La même
  valeur de clé envoyée par un autre utilisateur ou un autre tenant est une clé distincte et ne
  peut **jamais** rejouer la réponse d'un autre. (La contrainte `UNIQUE` de la spec 02 §4 est
  donc composite.)
- **Empreinte** (SHA-256) enregistrée avec la clé : méthode + **chemin concret** (identifiants
  compris, ex. `/v1/payments/<id A>/confirm`, et non le gabarit) + paramètres de requête
  **triés** + corps JSON **canonique**. Une clé réutilisée sur un autre chemin (autre `{id}`),
  avec d'autres paramètres ou un autre corps est un **conflit**.
- **Registre d'idempotence distinct du ledger**. Cycle de vie d'une clé :
  1. Réception : **réservation** de la clé (état « en cours »), validée immédiatement. La
     réservation porte un **jeton de clôture** (identifiant de propriétaire ou numéro de
     version, renouvelé à chaque prise ou reprise) et un **bail** qui sert uniquement à libérer
     une réservation orpheline après un arrêt brutal. Le bail est **strictement supérieur** au
     délai maximal d'une transaction financière : `statement_timeout` et `lock_timeout` de ces
     transactions sont bornés en configuration, et le bail est dérivé de ces bornes. Une
     réservation dont le bail a expiré peut être reprise par une nouvelle requête, ce qui
     change son jeton.
  2. Succès (`2xx`) : les écritures au ledger et l'enregistrement de la réponse dans le registre
     sont faits dans la **même transaction SQL** (tout ou rien). Dans cette transaction, la
     ligne de réservation est relue **sous `SELECT … FOR UPDATE`** et son jeton comparé à celui
     détenu par la requête. Si le jeton a changé (bail expiré puis reprise), la transaction est
     **annulée** (rollback, aucune écriture) et la requête renvoie
     `409 IDEMPOTENCY_REQUEST_IN_PROGRESS` : un seul traitement peut valider.
  3. **Refus métier** (`409 RESOURCE_STATE_CONFLICT`, `422 INSUFFICIENT_FUNDS`,
     `422 LIMIT_EXCEEDED`, `422 PAYMENT_DECLINED`…) : la transaction de l'opération est annulée
     (**aucune écriture au ledger**), puis la réponse de refus est **enregistrée de façon
     durable** dans le registre, **sous la même vérification du jeton** (sous `FOR UPDATE`,
     sans effet si le jeton a changé). Le refus est donc **définitif pour cette clé** : un
     rejeu renvoie le même refus, même si le solde a changé entre-temps. Pour réessayer après
     un refus, le client génère une **nouvelle** clé.
  Filet de sécurité indépendant du registre : la clé est aussi enregistrée dans `transactions`
  avec une contrainte `UNIQUE` **composite** (tenant, utilisateur, clé). Une seconde écriture
  au ledger pour la même clé échoue donc en base, quel que soit l'état du registre.
  Test attendu : bail expiré pendant le traitement (verrous retenus artificiellement), même clé
  renvoyée → **une seule** écriture au ledger et une seule réponse de succès ; l'autre requête
  reçoit `409 IDEMPOTENCY_REQUEST_IN_PROGRESS` puis, au rejeu, la réponse enregistrée.
  4. Échec avant traitement ou technique (`400` de validation, `401`, `403`, `413`, `415`,
     `429`, `5xx`, rollback) : **rien n'est enregistré**, la réservation est libérée ; le client
     peut réessayer avec la **même** clé.
- **Rejeu** (même portée, même clé, même empreinte, état terminé) : le serveur renvoie
  **exactement la même réponse** (même statut, même corps), sans nouvelle écriture (E11), avec
  l'en-tête `Idempotent-Replayed: true`.
- **Requête concurrente** (même clé, réservation en cours) :
  `409 IDEMPOTENCY_REQUEST_IN_PROGRESS` avec `Retry-After`.
- **Conflit** (même portée, même clé, empreinte différente) : `422 IDEMPOTENCY_KEY_REUSED`,
  aucune écriture. Test attendu : même clé sur `/v1/payments/{A}/confirm` puis
  `/v1/payments/{B}/confirm` → `422 IDEMPOTENCY_KEY_REUSED`.
- Conservation : 24 h minimum ; **sans limite** pour les opérations financières (spec 02 §5).

## 6. Sécurité : authentification, autorisation, tenant
- **Guard global, refus par défaut** : toute route exige une authentification. Une route
  publique est explicitement marquée (`@Public()` côté NestJS ; `security: []` et
  `x-public: true` dans ce contrat). Phase 0 : seule `GET /health` est publique.
- **Web** (`apps/web`) : session par **cookies** posés par l'API — `HttpOnly`, `Secure`,
  `SameSite=Strict`, sans attribut `Domain` : jeton d'accès `__Host-fp_at` (`Path=/`) et jeton
  de rafraîchissement `__Secure-fp_rt` restreint à `Path=/v1/auth`. Le JavaScript n'a jamais
  accès aux jetons.
- **CSRF (web)**. `SameSite=Strict` ne protège pas d'un sous-domaine du même site : trois
  contrôles serveur s'y ajoutent, chacun refusé par `403 CSRF_TOKEN_INVALID` :
  1. **Origin** : sur **toute** méthode non sûre (`POST`, `PUT`, `PATCH`, `DELETE`), y compris
     les routes publiques d'authentification (connexion, rafraîchissement, mot de passe
     oublié — protection contre le CSRF de connexion), un en-tête `Origin` présent doit être
     **exactement** égal à une origine de la liste autorisée (comparaison de chaîne, sans
     joker ni sous-domaine implicite) ; `Origin: null` est refusé. Toute requête non sûre
     portant un cookie FlexiPay **sans** en-tête `Origin` est refusée.
  2. **Jeton** : toute méthode non sûre authentifiée par cookie exige l'en-tête
     **`X-CSRF-Token`** — jeton lié à la session (HMAC côté serveur), remis dans le **corps**
     des réponses qui établissent ou renouvellent la session (contrat du module auth) et
     conservé **en mémoire** par le client web. `GET`, `HEAD` et `OPTIONS` ne sont **pas**
     soumis au jeton CSRF (ils ne modifient jamais d'état).
  3. **Rafraîchissement** (`POST /v1/auth/refresh` par cookie) : exige en plus l'en-tête
     personnalisé **`X-FlexiPay-Client: web`** (qui impose un pré-vol CORS). C'est le mode de
     **récupération du jeton CSRF après rechargement de page** : le client web appelle le
     rafraîchissement, dont la réponse remet un nouveau jeton CSRF.
- **Mobile** (Flutter) : `Authorization: Bearer <jeton d'accès>` (durée de vie 10 à 15 min,
  SEC-A3), jeton de rafraîchissement rotatif avec détection de réutilisation ; stockage
  Keychain/Keystore uniquement. Pas de CSRF (le jeton n'est pas envoyé automatiquement).
- **Un seul mécanisme par requête** : une requête portant à la fois un cookie de session et un
  en-tête `Authorization` est refusée (`401 UNAUTHENTICATED`).
- Les jetons ne sont **jamais** acceptés dans l'URL (paramètre de requête).
- **Tenant et rôle vérifiés côté serveur sur chaque ressource** : le tenant (`companyId`,
  `merchantId`) et l'utilisateur proviennent **exclusivement de la session**, jamais du corps
  ni des paramètres pour un utilisateur non administrateur ; l'isolation est doublée par la
  Row-Level Security PostgreSQL. Ressource inexistante ou d'un autre tenant :
  `404 NOT_FOUND` ; rôle insuffisant pour la route : `403 FORBIDDEN`.
- **Un compte = un seul tenant** (MVP, RG-2.5, décision du 2026-10-09) : un utilisateur
  Entreprise ou Commerçant appartient à une seule entreprise ou à un seul commerçant. Le
  tenant de la session est **fixé à la connexion** et ne change pas pendant la session. Il
  n'existe **aucune route ni aucun en-tête** de sélection ou de changement de tenant.
- Les opérations sensibles (commission, règlement, rapprochement, RIB) suivent la double
  validation (initiateur ≠ approbateur) et sont journalisées ; elles seront décrites dans les
  contrats de module.
- **CORS** : liste blanche d'origines exactes (configuration par environnement) ; comparaison
  exacte de chaîne, jamais de reflet de l'`Origin` reçu, jamais `*`, `null` refusé ;
  `Access-Control-Allow-Credentials: true` uniquement pour une origine autorisée ;
  `Vary: Origin` sur toute réponse ; méthodes autorisées `GET, POST, PUT, PATCH, DELETE` ;
  en-têtes de requête autorisés `Content-Type, Authorization, Idempotency-Key, X-CSRF-Token,
  X-FlexiPay-Client, Accept-Language` ; en-têtes exposés `X-Request-Id, Retry-After,
  RateLimit-Limit, RateLimit-Remaining, RateLimit-Reset, Idempotent-Replayed`.
- **Transport** : HTTPS (TLS 1.2 minimum) partout, HSTS, hors développement local
  (`http://localhost`) ; aucune option de désactivation de la vérification TLS.

## 7. Pagination, tri et filtres
- Pagination **par curseur** (stable malgré les insertions concurrentes) :
  `?limit=` (1 à 100, défaut 20), `?cursor=` (chaîne **opaque** renvoyée par la page
  précédente), `?sort=` (champ autorisé par l'endpoint, préfixe `-` pour l'ordre décroissant ;
  défaut `-createdAt`).
- Réponse : `{ \"data\": [ ... ], \"page\": { \"limit\": 20, \"hasMore\": true, \"nextCursor\": \"...\" } }`
  (`nextCursor` vaut `null` sur la dernière page). Pas de total ni de numéro de page.
- Curseur invalide, altéré, ou réutilisé avec d'autres filtres/tri : `400 VALIDATION_FAILED`.
  Le curseur ne contourne jamais le filtrage par tenant.
- Champs de tri et de filtre : **liste blanche** par endpoint ; tout autre valeur est refusée.
  Filtres de période : `createdFrom` / `createdTo` (`Timestamp`, borne haute exclue).
- **Compteur borné facultatif** (UX-02, convention commune à **toutes** les listes paginées) :
  `?withCount=true` ajoute `page.count: { value, isLowerBound }`. Le serveur compte au plus
  jusqu'à **10 000** (DP n° 23) (comptage d'une sous-requête limitée à 10 001 lignes, coût borné quelle
  que soit la taille de la table) : `isLowerBound: false` → `value` est le nombre exact de
  résultats (`0` pour une liste vide) ; `isLowerBound: true` → « plus de `value` ». Mêmes filtres
  et même tenant (RLS) que la liste. À n'envoyer qu'au premier chargement et à chaque
  changement de filtre, jamais en tournant les pages. Si le comptage échoue ou dépasse son
  délai, la page est renvoyée **sans** `page.count` (jamais d'erreur pour cette raison). Le
  compte reflète l'instant de la requête (des insertions concurrentes peuvent le décaler).
  Sans `withCount`, `page.count` est absent. Pas de `totalCount` exact.

## 8. En-têtes communs
- Requête : `Accept-Language` (`fr`, `ar`, `en`) — utilisé pour les notifications et documents
  générés, pas pour les erreurs ; `Content-Type: application/json` pour tout corps.
- Réponse, systématiquement : `X-Request-Id` (UUID généré par le serveur ; une valeur envoyée
  par le client est ignorée), `Cache-Control: no-store` sur toute réponse authentifiée, en-têtes
  de sécurité (`Strict-Transport-Security`, `X-Content-Type-Options: nosniff`,
  `Referrer-Policy: no-referrer`, `Content-Security-Policy: default-src 'none';
  frame-ancestors 'none'` pour les réponses JSON de l'API).
- **Rate limiting** (par IP, par compte et par route, SEC-W2) : chaque réponse porte
  `RateLimit-Limit`, `RateLimit-Remaining`, `RateLimit-Reset` (secondes), qui décrivent la
  politique **la plus restrictive** applicable ; au-delà : `429 RATE_LIMITED` avec
  `Retry-After` (secondes).
- **Routes publiques d'authentification** (connexion, défi MFA, rafraîchissement, mot de passe
  oublié ou réinitialisation) — anti-énumération : le compteur « par compte » est indexé sur
  l'**identifiant soumis, normalisé puis haché**, qu'un compte existe ou non (même politique,
  mêmes seuils, même réponse) ; les en-têtes `RateLimit-*` et `Retry-After` de ces routes ne
  reflètent **que** la politique par IP et par route, jamais le compteur par identifiant.
  Le dépassement du compteur par identifiant renvoie la même réponse générique que des
  identifiants invalides.
- Idempotence : `Idempotent-Replayed: true` sur une réponse rejouée.
- Corps de requête limité en taille (`413 PAYLOAD_TOO_LARGE`) ; type autre que JSON refusé
  (`415 UNSUPPORTED_MEDIA_TYPE`).

## 9. Statuts métier
Les énumérations `AccountStatus`, `OrderStatus`, `PaymentStatus`, `PayoutRequestStatus` et
`ApprovalStatus` reprennent le cahier des charges (§8) et le glossaire, traduits en anglais.
Elles sont **provisoires** jusqu'au contrat de chaque module et peuvent s'enrichir (le client
prévoit une valeur de repli).
- **Tout statut affiché est fourni par le serveur** (conformite S-03) : le client n'en déduit
  jamais un à partir d'autres champs ni de l'heure de l'appareil. « À régler » (créance du
  commerçant) = `PaymentStatus` `CONFIRMED` (paiement encaissé non encore réglé, glossaire
  « Créance »). Lot de crédits `ACTIVE` → `EXPIRED` et alerte antifraude `OPEN` →
  `IN_PROGRESS` → `CLOSED` : ajoutés au glossaire (DP n° 14), schémas `CreditBatchStatus` et
  `FraudAlertStatus`, utilisés par les contrats Entreprise et Administrateur.

## 10. Authentification web : séquence et états de session (spec 01, SEC-A1 à SEC-A4)
Le web ne sert que `ADMIN`, `COMPANY` et `MERCHANT` (cahier §1.2), pour qui la MFA TOTP est
obligatoire (spec 01 §3). Toutes les routes `/v1/auth/_*` du web exigent l'en-tête
`X-FlexiPay-Client: web` (la variante mobile sera ajoutée avec le contrat mobile).

**Séquence** (la MFA est toujours vérifiée **avant** d'ouvrir une session, même partielle) :
1. `POST /v1/auth/login` avec identifiant + mot de passe.
   - Identifiants refusés, compte inconnu, **verrouillé**, suspendu, ou **mot de passe
     temporaire expiré** (72 h) : `401 INVALID_CREDENTIALS`, réponse identique dans tous les
     cas (§4, anti-énumération). Le titulaire est prévenu par un autre canal. Mot de passe
     temporaire expiré : « mot de passe oublié », ou nouveau mot de passe temporaire demandé à
     l'administrateur de son organisation (DP n° 15).
   - **Durée de réponse indépendante du compte** (WD1-S01) : pour un identifiant inconnu, le
     serveur calcule un hachage Argon2id factice avec les mêmes paramètres ; le verrouillage,
     l'état du compte et l'expiration du mot de passe temporaire sont évalués **après** ce
     hachage, de sorte que tous les cas `INVALID_CREDENTIALS` ont un coût comparable.
   - **Verrouillage vérifié avant le mot de passe** : un compte verrouillé reçoit
     `INVALID_CREDENTIALS` même avec le bon mot de passe.
   - Mot de passe correct d'un `FAMILY_MEMBER` (compte non verrouillé) :
     `403 FORBIDDEN` (DP n° 23 ; l'`EMPLOYEE` est admis sur le web depuis le 2026-10-13), sans cookie ni session, journalisé (ces rôles utilisent
     l'application mobile). Le contrôle n'a lieu qu'après vérification du mot de passe : il ne
     révèle rien sans le bon mot de passe.
   - **Portée du verrouillage** (spec 01 §3, DP n° 24) : 5 échecs par couple (compte, IP ou
     appareil) → blocage de ce couple 15 min, puis progressif ; seuil global de 20 échecs
     toutes origines → blocage du compte, alerte (SEC-L3) et notification du titulaire.
     Un tiers ne peut donc pas bloquer un compte en 5 essais.
   - MFA enrôlée : `200` `nextStep: MFA_CHALLENGE` + `challengeId` (opaque, usage unique,
     valable 5 min, DP n° 23) ; **aucun cookie** n'est posé.
   - MFA pas encore enrôlée : `200` avec une **session restreinte** (cookies posés,
     `csrfToken` dans le corps) et `nextStep: PASSWORD_CHANGE` (mot de passe temporaire) ou
     `MFA_ENROLL`.
2. `POST /v1/auth/mfa/verify` (`challengeId` + code TOTP à 6 chiffres, SHA-1, 30 s, DP n° 23,
   **ou** code de secours, DP n° 10) : session ouverte
   (cookies + `csrfToken`), `nextStep: PASSWORD_CHANGE` si le mot de passe est temporaire,
   sinon `NONE`. Code faux : `401 MFA_CODE_INVALID`. Défi inconnu, consommé ou expiré :
   `401 MFA_CHALLENGE_EXPIRED` (retour à la connexion). Les échecs MFA comptent dans le **même
   compteur de verrouillage** que la connexion (spec 01 §3) ; au verrouillage, le défi est
   invalidé. Téléphone perdu sans code de secours : réinitialisation de la MFA par un
   Administrateur en double validation (DP n° 16, contrat Administrateur).
3. `POST /v1/auth/password/change` (session restreinte `PASSWORD_CHANGE`) : `nextStep`
   `MFA_ENROLL` si la MFA n'est pas enrôlée, sinon `NONE`.
4. `POST /v1/auth/mfa/enroll` puis `POST /v1/auth/mfa/enroll/confirm` (session restreinte
   `MFA_ENROLL`) : `nextStep: NONE`, session complète, et les **10 codes de secours**
   affichés une seule fois (DP n° 10).

**Routes autorisées par état de session** (tout autre appel est refusé) :
| État (`nextStep`) | Routes autorisées | Refus des autres routes |
|---|---|---|
| `PASSWORD_CHANGE` (10 min au plus, en absolu ; usage unique) | `POST /v1/auth/password/change`, `POST /v1/auth/logout`, `POST /v1/auth/refresh` | `403 PASSWORD_CHANGE_REQUIRED` |
| `MFA_ENROLL` | `POST /v1/auth/mfa/enroll`, `POST /v1/auth/mfa/enroll/confirm`, `POST /v1/auth/logout`, `POST /v1/auth/refresh` | `403 MFA_ENROLLMENT_REQUIRED` |
| `NONE` (session complète) | toutes les routes permises par le rôle | — |

- Le **rafraîchissement** renvoie l'état courant (`nextStep`) : après un rechargement de page,
  le client sait où reprendre la séquence sans autre appel.
- Chaque réponse qui établit, renouvelle ou fait changer d'état la session **renouvelle**
  l'identifiant de session et le `csrfToken` (le précédent devient invalide).
- **Durées de session** (DP n° 18), appliquées par le serveur : inactivité 15 min ; durée
  absolue 8 h (Entreprise, Commerçant), 4 h (Administrateur). `SessionResult` les expose
  (`idleTimeoutSeconds`, `absoluteExpiresAt`) pour l'avertissement 2 min avant l'échéance
  (WCAG 2.2.1) ; « Rester connecté » = `POST /v1/auth/refresh` (remet à zéro l'inactivité,
  jamais l'échéance absolue). Toute requête authentifiée remet à zéro le délai d'inactivité.
- Décisions appliquées (provisoires) : politique de mot de passe (DP n° 9), codes de secours
  (DP n° 10), réinitialisation (DP n° 11), fermeture des autres sessions après un changement
  de mot de passe et de toutes après une réinitialisation (DP n° 12), permissions calculées
  par le serveur (DP n° 13).


This Dart package is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 0.15.0
- Generator version: 7.27.0
- Build package: org.openapitools.codegen.languages.DartDioClientCodegen

## Requirements

* Dart 2.15.0+ or Flutter 2.8.0+
* Dio 5.0.0+ (https://pub.dev/packages/dio)

## Installation & Usage

### pub.dev
To use the package from [pub.dev](https://pub.dev), please include the following in pubspec.yaml
```yaml
dependencies:
  fp_api: 0.15.0
```

### Github
If this Dart package is published to Github, please include the following in pubspec.yaml
```yaml
dependencies:
  fp_api:
    git:
      url: https://github.com/GIT_USER_ID/GIT_REPO_ID.git
      #ref: main
```

### Local development
To use the package from your local drive, please include the following in pubspec.yaml
```yaml
dependencies:
  fp_api:
    path: /path/to/fp_api
```

## Getting Started

Please follow the [installation procedure](#installation--usage) and then run the following:

```dart
import 'package:fp_api/fp_api.dart';


final api = FpApi().getAccountApi();
final String documentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = await api.getMyKycDocument(documentId);
    print(response);
} on DioException catch (e) {
    print("Exception when calling AccountApi->getMyKycDocument: $e\n");
}

```

## Documentation for API Endpoints

All URIs are relative to *http://localhost:3000*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
[*AccountApi*](doc/AccountApi.md) | [**getMyKycDocument**](doc/AccountApi.md#getmykycdocument) | **GET** /v1/account/kyc/documents/{documentId} | Télécharger une pièce de mon dossier
[*AccountApi*](doc/AccountApi.md) | [**getMyKycFile**](doc/AccountApi.md#getmykycfile) | **GET** /v1/account/kyc | Mon dossier KYC (entreprise ou commerçant, Administrateur / Gérant)
[*AccountApi*](doc/AccountApi.md) | [**uploadMyKycDocument**](doc/AccountApi.md#uploadmykycdocument) | **POST** /v1/account/kyc/documents | Déposer (ou redéposer) une pièce du dossier KYC
[*AdminApi*](doc/AdminApi.md) | [**acceptDispute**](doc/AdminApi.md#acceptdispute) | **POST** /v1/admin/disputes/{disputeId}/accept | Accepter un litige (seconde validation Finance, puis remboursement)
[*AdminApi*](doc/AdminApi.md) | [**addDisputeNote**](doc/AdminApi.md#adddisputenote) | **POST** /v1/admin/disputes/{disputeId}/notes | Ajouter une note d&#39;instruction
[*AdminApi*](doc/AdminApi.md) | [**adminCreateCompanyUser**](doc/AdminApi.md#admincreatecompanyuser) | **POST** /v1/admin/companies/{companyId}/users | Créer un utilisateur d&#39;une entreprise
[*AdminApi*](doc/AdminApi.md) | [**adminCreateMerchantUser**](doc/AdminApi.md#admincreatemerchantuser) | **POST** /v1/admin/merchants/{merchantId}/users | Créer un utilisateur d&#39;un commerçant
[*AdminApi*](doc/AdminApi.md) | [**adminUpdateTenantUser**](doc/AdminApi.md#adminupdatetenantuser) | **PATCH** /v1/admin/users/{userId} | Modifier le nom ou le rôle d&#39;un utilisateur d&#39;entreprise ou de commerçant
[*AdminApi*](doc/AdminApi.md) | [**approveAdminPayoutRequest**](doc/AdminApi.md#approveadminpayoutrequest) | **POST** /v1/admin/payout-requests/{payoutId}/approve | Valider une demande de virement (&#x60;REQUESTED&#x60; → &#x60;CHECKED&#x60;), ajoutée au prochain lot de règlement
[*AdminApi*](doc/AdminApi.md) | [**approveApproval**](doc/AdminApi.md#approveapproval) | **POST** /v1/admin/approvals/{approvalId}/approve | Approuver (approbateur différent de l&#39;initiateur)
[*AdminApi*](doc/AdminApi.md) | [**approveKycFile**](doc/AdminApi.md#approvekycfile) | **POST** /v1/admin/kyc-files/{fileId}/approve | Valider un dossier KYC (le compte devient actif, &#x60;APPROVED&#x60;)
[*AdminApi*](doc/AdminApi.md) | [**archiveCompanyTemplateAsAdmin**](doc/AdminApi.md#archivecompanytemplateasadmin) | **DELETE** /v1/admin/companies/{companyId}/allocation-templates/{templateId} | Fiche client › Attributions et modèles : désactiver un modèle
[*AdminApi*](doc/AdminApi.md) | [**changeUserRole**](doc/AdminApi.md#changeuserrole) | **POST** /v1/admin/users/{userId}/role | Changer le sous-rôle d&#39;un utilisateur
[*AdminApi*](doc/AdminApi.md) | [**closeFraudAlert**](doc/AdminApi.md#closefraudalert) | **POST** /v1/admin/fraud-alerts/{alertId}/close | Fermer une alerte de fraude avec un motif
[*AdminApi*](doc/AdminApi.md) | [**confirmCreditOrder**](doc/AdminApi.md#confirmcreditorder) | **POST** /v1/admin/credit-orders/{orderId}/confirm | Confirmer une commande (AWAITING_CONFIRMATION → AWAITING_PAYMENT)
[*AdminApi*](doc/AdminApi.md) | [**createAdministrator**](doc/AdminApi.md#createadministrator) | **POST** /v1/admin/users | Créer un administrateur (invitation par e-mail)
[*AdminApi*](doc/AdminApi.md) | [**createCompanyAccount**](doc/AdminApi.md#createcompanyaccount) | **POST** /v1/admin/companies | Créer une entreprise
[*AdminApi*](doc/AdminApi.md) | [**createCompanyEmployeeAsAdmin**](doc/AdminApi.md#createcompanyemployeeasadmin) | **POST** /v1/admin/companies/{companyId}/employees | Fiche client › Employés : ajouter un employé (identifiants affichés une fois)
[*AdminApi*](doc/AdminApi.md) | [**createMerchantAccount**](doc/AdminApi.md#createmerchantaccount) | **POST** /v1/admin/merchants | Créer un commerçant (profil de commission facultatif)
[*AdminApi*](doc/AdminApi.md) | [**deactivateUser**](doc/AdminApi.md#deactivateuser) | **POST** /v1/admin/users/{userId}/deactivate | Désactiver un utilisateur (irréversible)
[*AdminApi*](doc/AdminApi.md) | [**getAdminCreditOrder**](doc/AdminApi.md#getadmincreditorder) | **GET** /v1/admin/credit-orders/{orderId} | Détail d&#39;une commande de crédits
[*AdminApi*](doc/AdminApi.md) | [**getAdminCreditOrderProof**](doc/AdminApi.md#getadmincreditorderproof) | **GET** /v1/admin/credit-orders/{orderId}/proof | Capture du virement déclaré (administrateur)
[*AdminApi*](doc/AdminApi.md) | [**getAdminDashboard**](doc/AdminApi.md#getadmindashboard) | **GET** /v1/admin/dashboard | Tableau de bord Administrateur
[*AdminApi*](doc/AdminApi.md) | [**getAdminPayoutRequest**](doc/AdminApi.md#getadminpayoutrequest) | **GET** /v1/admin/payout-requests/{payoutId} | Demande de virement (brut, commission, net, IBAN, historique)
[*AdminApi*](doc/AdminApi.md) | [**getCompanyOverview**](doc/AdminApi.md#getcompanyoverview) | **GET** /v1/admin/companies/{companyId}/overview | Fiche complète de l&#39;entreprise : onglets Utilisateurs, Départements, Employés, Soldes, Commandes, Attributions, Factures
[*AdminApi*](doc/AdminApi.md) | [**getCompanyRecord**](doc/AdminApi.md#getcompanyrecord) | **GET** /v1/admin/companies/{companyId}/record | Fiche de l&#39;entreprise (contact, grille, historique, demandes en attente)
[*AdminApi*](doc/AdminApi.md) | [**getContactMessage**](doc/AdminApi.md#getcontactmessage) | **GET** /v1/admin/contact-messages/{messageId} | Détail d&#39;un message
[*AdminApi*](doc/AdminApi.md) | [**getDispute**](doc/AdminApi.md#getdispute) | **GET** /v1/admin/disputes/{disputeId} | Dossier d&#39;un litige (instruction, notes)
[*AdminApi*](doc/AdminApi.md) | [**getKycDocument**](doc/AdminApi.md#getkycdocument) | **GET** /v1/admin/kyc-files/{fileId}/documents/{documentId} | Pièce d&#39;un dossier KYC
[*AdminApi*](doc/AdminApi.md) | [**getKycFile**](doc/AdminApi.md#getkycfile) | **GET** /v1/admin/kyc-files/{fileId} | Dossier KYC avec ses pièces et son historique
[*AdminApi*](doc/AdminApi.md) | [**getMerchantAccount**](doc/AdminApi.md#getmerchantaccount) | **GET** /v1/admin/merchants/{merchantId} | Fiche d&#39;un commerçant
[*AdminApi*](doc/AdminApi.md) | [**getMerchantOverview**](doc/AdminApi.md#getmerchantoverview) | **GET** /v1/admin/merchants/{merchantId}/overview | Fiche complète du commerçant : onglets Utilisateurs, Ventes, Virements, Dossier KYC
[*AdminApi*](doc/AdminApi.md) | [**getMerchantRecord**](doc/AdminApi.md#getmerchantrecord) | **GET** /v1/admin/merchants/{merchantId}/record | Fiche du commerçant (contact, grille, historique, demandes en attente)
[*AdminApi*](doc/AdminApi.md) | [**getPlatformSettings**](doc/AdminApi.md#getplatformsettings) | **GET** /v1/admin/settings | Paramétrage de la plateforme
[*AdminApi*](doc/AdminApi.md) | [**getSettlementBatch**](doc/AdminApi.md#getsettlementbatch) | **GET** /v1/admin/settlements/{batchId} | Détail d&#39;un lot de règlement (virements validés qui le composent)
[*AdminApi*](doc/AdminApi.md) | [**getUser**](doc/AdminApi.md#getuser) | **GET** /v1/admin/users/{userId} | Fiche d&#39;un utilisateur et son historique
[*AdminApi*](doc/AdminApi.md) | [**handleContactMessage**](doc/AdminApi.md#handlecontactmessage) | **POST** /v1/admin/contact-messages/{messageId}/handle | Marque un message comme traité, avec une note facultative
[*AdminApi*](doc/AdminApi.md) | [**listAdminCreditOrders**](doc/AdminApi.md#listadmincreditorders) | **GET** /v1/admin/credit-orders | Toutes les commandes de crédits (filtre par statut et par entreprise)
[*AdminApi*](doc/AdminApi.md) | [**listAdminPayoutRequests**](doc/AdminApi.md#listadminpayoutrequests) | **GET** /v1/admin/payout-requests | Demandes de virement des commerçants
[*AdminApi*](doc/AdminApi.md) | [**listAdminTransactions**](doc/AdminApi.md#listadmintransactions) | **GET** /v1/admin/transactions | Transactions globales (paiements chez les commerçants)
[*AdminApi*](doc/AdminApi.md) | [**listApprovals**](doc/AdminApi.md#listapprovals) | **GET** /v1/admin/approvals | Demandes en attente de double validation
[*AdminApi*](doc/AdminApi.md) | [**listAuditLogs**](doc/AdminApi.md#listauditlogs) | **GET** /v1/admin/audit-logs | Journal d&#39;audit (lecture seule)
[*AdminApi*](doc/AdminApi.md) | [**listCompanyAccounts**](doc/AdminApi.md#listcompanyaccounts) | **GET** /v1/admin/companies | Entreprises
[*AdminApi*](doc/AdminApi.md) | [**listContactMessages**](doc/AdminApi.md#listcontactmessages) | **GET** /v1/admin/contact-messages | Messages reçus par le formulaire « Nous contacter », les plus récents d&#39;abord
[*AdminApi*](doc/AdminApi.md) | [**listDisputes**](doc/AdminApi.md#listdisputes) | **GET** /v1/admin/disputes | Litiges (lecture seule)
[*AdminApi*](doc/AdminApi.md) | [**listFraudAlerts**](doc/AdminApi.md#listfraudalerts) | **GET** /v1/admin/fraud-alerts | Alertes de fraude
[*AdminApi*](doc/AdminApi.md) | [**listKycFiles**](doc/AdminApi.md#listkycfiles) | **GET** /v1/admin/kyc-files | Dossiers KYC des commerçants et des entreprises
[*AdminApi*](doc/AdminApi.md) | [**listMerchantAccounts**](doc/AdminApi.md#listmerchantaccounts) | **GET** /v1/admin/merchants | Commerçants
[*AdminApi*](doc/AdminApi.md) | [**listSettlementBatches**](doc/AdminApi.md#listsettlementbatches) | **GET** /v1/admin/settlements | Lots de règlement des commerçants (J+2)
[*AdminApi*](doc/AdminApi.md) | [**listUsers**](doc/AdminApi.md#listusers) | **GET** /v1/admin/users | Utilisateurs de la plateforme (administrateurs, entreprises, commerçants, employés)
[*AdminApi*](doc/AdminApi.md) | [**openDispute**](doc/AdminApi.md#opendispute) | **POST** /v1/admin/disputes | Ouvrir un litige sur un paiement (montant mis en réserve, exclu des règlements)
[*AdminApi*](doc/AdminApi.md) | [**reactivateUser**](doc/AdminApi.md#reactivateuser) | **POST** /v1/admin/users/{userId}/reactivate | Réactiver un utilisateur suspendu
[*AdminApi*](doc/AdminApi.md) | [**recordAdminPayoutPayment**](doc/AdminApi.md#recordadminpayoutpayment) | **POST** /v1/admin/payout-requests/{payoutId}/payment | Enregistrer le paiement d&#39;un virement accepté (&#x60;CHECKED&#x60; → &#x60;EXECUTED&#x60;)
[*AdminApi*](doc/AdminApi.md) | [**recordSettlementBatchPayment**](doc/AdminApi.md#recordsettlementbatchpayment) | **POST** /v1/admin/settlements/{batchId}/payment | Enregistrer le paiement d&#39;un lot (chaque virement du lot passe « Payé », bug 6)
[*AdminApi*](doc/AdminApi.md) | [**refuseCreditOrder**](doc/AdminApi.md#refusecreditorder) | **POST** /v1/admin/credit-orders/{orderId}/refuse | Refuser une commande avec un motif (AWAITING_CONFIRMATION → REFUSED)
[*AdminApi*](doc/AdminApi.md) | [**rejectAdminPayoutRequest**](doc/AdminApi.md#rejectadminpayoutrequest) | **POST** /v1/admin/payout-requests/{payoutId}/reject | Refuser une demande de virement avec un motif (&#x60;REQUESTED&#x60; → &#x60;REJECTED&#x60;)
[*AdminApi*](doc/AdminApi.md) | [**rejectApproval**](doc/AdminApi.md#rejectapproval) | **POST** /v1/admin/approvals/{approvalId}/reject | Refuser une demande (motif obligatoire)
[*AdminApi*](doc/AdminApi.md) | [**rejectCreditOrderProof**](doc/AdminApi.md#rejectcreditorderproof) | **POST** /v1/admin/credit-orders/{orderId}/reject-proof | Rejeter le justificatif avec un motif (AWAITING_VALIDATION → AWAITING_PAYMENT)
[*AdminApi*](doc/AdminApi.md) | [**rejectDispute**](doc/AdminApi.md#rejectdispute) | **POST** /v1/admin/disputes/{disputeId}/reject | Rejeter un litige (le montant retourne au commerçant)
[*AdminApi*](doc/AdminApi.md) | [**rejectKycFile**](doc/AdminApi.md#rejectkycfile) | **POST** /v1/admin/kyc-files/{fileId}/reject | Refuser un dossier KYC avec un motif (le compte reste inactif, &#x60;REJECTED&#x60;)
[*AdminApi*](doc/AdminApi.md) | [**requestBatchRelease**](doc/AdminApi.md#requestbatchrelease) | **POST** /v1/admin/settlements/{batchId}/release-requests | Demander la libération d&#39;un lot (double validation Finance, tâche 9)
[*AdminApi*](doc/AdminApi.md) | [**requestCommissionGridChange**](doc/AdminApi.md#requestcommissiongridchange) | **POST** /v1/admin/commission-grids/change-requests | Demander un changement de grille de commission (double validation, règle 12)
[*AdminApi*](doc/AdminApi.md) | [**requestCompanyLegalFormChange**](doc/AdminApi.md#requestcompanylegalformchange) | **POST** /v1/admin/companies/{companyId}/legal-form-change-requests | Demander le changement de forme juridique (double validation ; s&#39;applique aux prochaines opérations)
[*AdminApi*](doc/AdminApi.md) | [**requestIbanChange**](doc/AdminApi.md#requestibanchange) | **POST** /v1/admin/merchants/{merchantId}/iban-change-requests | Demander un changement de RIB (double validation ; vaut pour les virements futurs)
[*AdminApi*](doc/AdminApi.md) | [**requestKycCorrections**](doc/AdminApi.md#requestkyccorrections) | **POST** /v1/admin/kyc-files/{fileId}/corrections | Demander une correction, avec un motif par pièce
[*AdminApi*](doc/AdminApi.md) | [**requestMerchantLegalFormChange**](doc/AdminApi.md#requestmerchantlegalformchange) | **POST** /v1/admin/merchants/{merchantId}/legal-form-change-requests | Demander le changement de forme juridique (double validation ; s&#39;applique aux prochaines opérations)
[*AdminApi*](doc/AdminApi.md) | [**requestPlatformSettingsChange**](doc/AdminApi.md#requestplatformsettingschange) | **PUT** /v1/admin/settings | Demander une modification du paramétrage (double validation)
[*AdminApi*](doc/AdminApi.md) | [**resendInvitation**](doc/AdminApi.md#resendinvitation) | **POST** /v1/admin/users/{userId}/reset-invitation | Renvoyer l&#39;invitation (nouveau mot de passe temporaire par e-mail)
[*AdminApi*](doc/AdminApi.md) | [**setMerchantCreditTypes**](doc/AdminApi.md#setmerchantcredittypes) | **PUT** /v1/admin/merchants/{merchantId}/credit-types | Définir les types de crédit acceptés par un commerçant
[*AdminApi*](doc/AdminApi.md) | [**startFraudAlert**](doc/AdminApi.md#startfraudalert) | **POST** /v1/admin/fraud-alerts/{alertId}/start | Prendre en charge une alerte de fraude
[*AdminApi*](doc/AdminApi.md) | [**suspendUser**](doc/AdminApi.md#suspenduser) | **POST** /v1/admin/users/{userId}/suspend | Suspendre un utilisateur
[*AdminApi*](doc/AdminApi.md) | [**unlockPin**](doc/AdminApi.md#unlockpin) | **POST** /v1/admin/users/{userId}/unlock-pin | Débloquer le code PIN d&#39;un employé
[*AdminApi*](doc/AdminApi.md) | [**updateCompany**](doc/AdminApi.md#updatecompany) | **PATCH** /v1/admin/companies/{companyId} | Modifier les informations de l&#39;entreprise à tout moment (décision du 2026-11-03)
[*AdminApi*](doc/AdminApi.md) | [**updateMerchant**](doc/AdminApi.md#updatemerchant) | **PATCH** /v1/admin/merchants/{merchantId} | Modifier les informations du commerçant à tout moment (décision du 2026-11-03)
[*AdminApi*](doc/AdminApi.md) | [**validateCreditOrderPayment**](doc/AdminApi.md#validatecreditorderpayment) | **POST** /v1/admin/credit-orders/{orderId}/validate | Valider le virement reçu et créditer le solde de l&#39;entreprise (AWAITING_VALIDATION → VALIDATED)
[*AuthApi*](doc/AuthApi.md) | [**changePassword**](doc/AuthApi.md#changepassword) | **POST** /v1/auth/password/change | Change le mot de passe (dont le mot de passe temporaire)
[*AuthApi*](doc/AuthApi.md) | [**confirmMfaEnrollment**](doc/AuthApi.md#confirmmfaenrollment) | **POST** /v1/auth/mfa/enroll/confirm | Confirme l&#39;enrôlement TOTP avec un premier code
[*AuthApi*](doc/AuthApi.md) | [**getPasswordPolicy**](doc/AuthApi.md#getpasswordpolicy) | **GET** /v1/auth/password-policy | Règles de la politique de mot de passe (aide à la saisie)
[*AuthApi*](doc/AuthApi.md) | [**login**](doc/AuthApi.md#login) | **POST** /v1/auth/login | Connexion par identifiant (e-mail ou téléphone) et mot de passe
[*AuthApi*](doc/AuthApi.md) | [**logout**](doc/AuthApi.md#logout) | **POST** /v1/auth/logout | Déconnexion (révoque la session courante)
[*AuthApi*](doc/AuthApi.md) | [**mobileChangePassword**](doc/AuthApi.md#mobilechangepassword) | **POST** /v1/mobile/auth/password/change | Choisir son mot de passe (première connexion) depuis l&#39;application mobile
[*AuthApi*](doc/AuthApi.md) | [**mobileLogin**](doc/AuthApi.md#mobilelogin) | **POST** /v1/mobile/auth/login | Connexion depuis une application mobile (jetons dans la réponse, pas de cookie)
[*AuthApi*](doc/AuthApi.md) | [**mobileLogout**](doc/AuthApi.md#mobilelogout) | **POST** /v1/mobile/auth/logout | Déconnexion de l&#39;application mobile (révoque les jetons de la session)
[*AuthApi*](doc/AuthApi.md) | [**mobileRefresh**](doc/AuthApi.md#mobilerefresh) | **POST** /v1/mobile/auth/refresh | Renouveler les jetons (rotation, réutilisation &#x3D; révocation de toute la session)
[*AuthApi*](doc/AuthApi.md) | [**mobileVerifyMfa**](doc/AuthApi.md#mobileverifymfa) | **POST** /v1/mobile/auth/mfa/verify | Résoudre le défi MFA depuis l&#39;application mobile
[*AuthApi*](doc/AuthApi.md) | [**refreshSession**](doc/AuthApi.md#refreshsession) | **POST** /v1/auth/refresh | Renouvelle la session (rotation du jeton de rafraîchissement)
[*AuthApi*](doc/AuthApi.md) | [**regenerateRecoveryCodes**](doc/AuthApi.md#regeneraterecoverycodes) | **POST** /v1/auth/mfa/recovery-codes | Régénère les 10 codes de secours (les anciens sont annulés)
[*AuthApi*](doc/AuthApi.md) | [**requestPasswordReset**](doc/AuthApi.md#requestpasswordreset) | **POST** /v1/auth/password/forgot | Demande de réinitialisation du mot de passe
[*AuthApi*](doc/AuthApi.md) | [**resetPassword**](doc/AuthApi.md#resetpassword) | **POST** /v1/auth/password/reset | Réinitialise le mot de passe (lien par e-mail ou code SMS)
[*AuthApi*](doc/AuthApi.md) | [**startMfaEnrollment**](doc/AuthApi.md#startmfaenrollment) | **POST** /v1/auth/mfa/enroll | Démarre l&#39;enrôlement TOTP (secret et URI otpauth)
[*AuthApi*](doc/AuthApi.md) | [**verifyMfa**](doc/AuthApi.md#verifymfa) | **POST** /v1/auth/mfa/verify | Réponse au défi MFA (code TOTP ou code de secours)
[*CompanyApi*](doc/CompanyApi.md) | [**allocateCredits**](doc/CompanyApi.md#allocatecredits) | **POST** /v1/company/allocations | Attribuer des crédits à des employés
[*CompanyApi*](doc/CompanyApi.md) | [**archiveDepartment**](doc/CompanyApi.md#archivedepartment) | **POST** /v1/company/departments/{departmentId}/archive | Archiver un département (refusé, 409 DEPARTMENT_NOT_EMPTY, s&#39;il a des employés)
[*CompanyApi*](doc/CompanyApi.md) | [**assignEmployeeDepartment**](doc/CompanyApi.md#assignemployeedepartment) | **PUT** /v1/company/employees/{employeeId}/department | Rattacher un employé à un département (ou le détacher avec null)
[*CompanyApi*](doc/CompanyApi.md) | [**assignEmployees**](doc/CompanyApi.md#assignemployees) | **POST** /v1/company/employees/assignments | Changer le département et/ou le poste d&#39;un ou plusieurs employés
[*CompanyApi*](doc/CompanyApi.md) | [**cancelCreditOrder**](doc/CompanyApi.md#cancelcreditorder) | **POST** /v1/company/orders/{orderId}/cancel | Annuler une commande tant qu&#39;aucun virement n&#39;a été déclaré
[*CompanyApi*](doc/CompanyApi.md) | [**changeEmployeesStatus**](doc/CompanyApi.md#changeemployeesstatus) | **POST** /v1/company/employees/status-changes | Suspendre ou réactiver plusieurs employés (au plus une page)
[*CompanyApi*](doc/CompanyApi.md) | [**confirmEmployeeImport**](doc/CompanyApi.md#confirmemployeeimport) | **POST** /v1/company/employees/imports | Confirmer un import (lignes valides de l&#39;aperçu)
[*CompanyApi*](doc/CompanyApi.md) | [**createAllocationTemplate**](doc/CompanyApi.md#createallocationtemplate) | **POST** /v1/company/allocation-templates | Enregistrer un modèle (filtres et montant par type ; nom unique, sinon 409)
[*CompanyApi*](doc/CompanyApi.md) | [**createCompanyDepartment**](doc/CompanyApi.md#createcompanydepartment) | **POST** /v1/company/departments | Créer un département (nom unique dans l&#39;entreprise, sinon 409)
[*CompanyApi*](doc/CompanyApi.md) | [**createCreditOrder**](doc/CompanyApi.md#createcreditorder) | **POST** /v1/company/orders | Passer une commande de crédits
[*CompanyApi*](doc/CompanyApi.md) | [**createCreditOrderQuote**](doc/CompanyApi.md#createcreditorderquote) | **POST** /v1/company/order-quotes | Récapitulatif d&#39;une commande de crédits (montant, frais, total)
[*CompanyApi*](doc/CompanyApi.md) | [**createEmployee**](doc/CompanyApi.md#createemployee) | **POST** /v1/company/employees | Créer un employé (mot de passe temporaire envoyé, RG-2.2)
[*CompanyApi*](doc/CompanyApi.md) | [**deactivateEmployee**](doc/CompanyApi.md#deactivateemployee) | **POST** /v1/company/employees/{employeeId}/deactivate | Désactiver un employé (irréversible)
[*CompanyApi*](doc/CompanyApi.md) | [**declareCreditOrderTransfer**](doc/CompanyApi.md#declarecreditordertransfer) | **POST** /v1/company/orders/{orderId}/transfer-declarations | Déclarer le virement d&#39;une commande (référence, date, montant, capture)
[*CompanyApi*](doc/CompanyApi.md) | [**deleteAllocationTemplate**](doc/CompanyApi.md#deleteallocationtemplate) | **DELETE** /v1/company/allocation-templates/{templateId} | Supprimer un modèle (archivé ; les attributions faites le gardent)
[*CompanyApi*](doc/CompanyApi.md) | [**getCompanyDashboard**](doc/CompanyApi.md#getcompanydashboard) | **GET** /v1/company/dashboard | Tableau de bord de l&#39;entreprise
[*CompanyApi*](doc/CompanyApi.md) | [**getCompanyFamilyAccounts**](doc/CompanyApi.md#getcompanyfamilyaccounts) | **GET** /v1/company/family-accounts | Comptes famille autorisés pour les employés (paramètre de l&#39;entreprise)
[*CompanyApi*](doc/CompanyApi.md) | [**getCompanyInvoicePdf**](doc/CompanyApi.md#getcompanyinvoicepdf) | **GET** /v1/company/invoices/{invoiceId}/pdf | Facture de la commande en PDF (tâche 10)
[*CompanyApi*](doc/CompanyApi.md) | [**getCreditOrder**](doc/CompanyApi.md#getcreditorder) | **GET** /v1/company/orders/{orderId} | Détail d&#39;une commande de crédits (déclaration, motif, historique)
[*CompanyApi*](doc/CompanyApi.md) | [**getCreditOrderProof**](doc/CompanyApi.md#getcreditorderproof) | **GET** /v1/company/orders/{orderId}/proof | Capture du virement déclaré (entreprise)
[*CompanyApi*](doc/CompanyApi.md) | [**getFundingAccount**](doc/CompanyApi.md#getfundingaccount) | **GET** /v1/company/funding-account | Compte bancaire de FlexiPay à créditer par virement
[*CompanyApi*](doc/CompanyApi.md) | [**listAllocationTemplates**](doc/CompanyApi.md#listallocationtemplates) | **GET** /v1/company/allocation-templates | Modèles d&#39;attribution de l&#39;entreprise (processus v2)
[*CompanyApi*](doc/CompanyApi.md) | [**listCompanyDepartments**](doc/CompanyApi.md#listcompanydepartments) | **GET** /v1/company/departments | Départements de l&#39;entreprise (cahier ENT-04), avec leur nombre d&#39;employés
[*CompanyApi*](doc/CompanyApi.md) | [**listCompanyInvoices**](doc/CompanyApi.md#listcompanyinvoices) | **GET** /v1/company/invoices | Factures
[*CompanyApi*](doc/CompanyApi.md) | [**listCreditOrders**](doc/CompanyApi.md#listcreditorders) | **GET** /v1/company/orders | Commandes de crédits
[*CompanyApi*](doc/CompanyApi.md) | [**listEmployees**](doc/CompanyApi.md#listemployees) | **GET** /v1/company/employees | Employés
[*CompanyApi*](doc/CompanyApi.md) | [**listPositions**](doc/CompanyApi.md#listpositions) | **GET** /v1/company/positions | Postes déjà utilisés dans l&#39;entreprise (suggestions de saisie)
[*CompanyApi*](doc/CompanyApi.md) | [**previewAllocation**](doc/CompanyApi.md#previewallocation) | **POST** /v1/company/allocation-previews | Aperçu d&#39;une attribution (processus v2, étape 4)
[*CompanyApi*](doc/CompanyApi.md) | [**previewAllocationImport**](doc/CompanyApi.md#previewallocationimport) | **POST** /v1/company/allocation-imports/previews | Analyse un fichier CSV d&#39;attribution (matricule ; une colonne par type de crédit)
[*CompanyApi*](doc/CompanyApi.md) | [**previewEmployeeImport**](doc/CompanyApi.md#previewemployeeimport) | **POST** /v1/company/employees/import-previews | Aperçu d&#39;un import CSV (erreurs et doublons)
[*CompanyApi*](doc/CompanyApi.md) | [**reactivateEmployee**](doc/CompanyApi.md#reactivateemployee) | **POST** /v1/company/employees/{employeeId}/reactivate | Réactiver un employé suspendu
[*CompanyApi*](doc/CompanyApi.md) | [**renameDepartment**](doc/CompanyApi.md#renamedepartment) | **PATCH** /v1/company/departments/{departmentId} | Renommer un département
[*CompanyApi*](doc/CompanyApi.md) | [**setCompanyFamilyAccounts**](doc/CompanyApi.md#setcompanyfamilyaccounts) | **PUT** /v1/company/family-accounts | Activer ou désactiver les comptes famille des employés
[*CompanyApi*](doc/CompanyApi.md) | [**suspendEmployee**](doc/CompanyApi.md#suspendemployee) | **POST** /v1/company/employees/{employeeId}/suspend | Suspendre un employé
[*CompanyApi*](doc/CompanyApi.md) | [**updateAllocationTemplate**](doc/CompanyApi.md#updateallocationtemplate) | **PUT** /v1/company/allocation-templates/{templateId} | Modifier un modèle
[*EmployeeApi*](doc/EmployeeApi.md) | [**changePin**](doc/EmployeeApi.md#changepin) | **POST** /v1/employee/pin | Changer mon code PIN de paiement
[*EmployeeApi*](doc/EmployeeApi.md) | [**confirmCheckout**](doc/EmployeeApi.md#confirmcheckout) | **POST** /v1/employee/checkouts/{checkoutId}/confirm | Payer la demande de la caisse avec mon PIN
[*EmployeeApi*](doc/EmployeeApi.md) | [**confirmPaymentRequest**](doc/EmployeeApi.md#confirmpaymentrequest) | **POST** /v1/employee/payment-requests/{requestId}/confirm | Confirmer une demande de paiement avec mon PIN
[*EmployeeApi*](doc/EmployeeApi.md) | [**createFamilyMember**](doc/EmployeeApi.md#createfamilymember) | **POST** /v1/employee/family/members | Ajouter un membre (5 au plus ; identifiant et mot de passe temporaire affichés une fois)
[*EmployeeApi*](doc/EmployeeApi.md) | [**createPaymentCode**](doc/EmployeeApi.md#createpaymentcode) | **POST** /v1/employee/payment-codes | Génère mon code de paiement (QR dynamique et code à 8 chiffres, 60 s, usage unique)
[*EmployeeApi*](doc/EmployeeApi.md) | [**deleteFamilyMember**](doc/EmployeeApi.md#deletefamilymember) | **DELETE** /v1/employee/family/members/{memberId} | Supprimer un membre (son crédit revient d&#39;abord au bénéficiaire)
[*EmployeeApi*](doc/EmployeeApi.md) | [**getCheckoutByCode**](doc/EmployeeApi.md#getcheckoutbycode) | **GET** /v1/employee/checkouts/code/{shortCode} | Demande en attente du code court affiché en caisse
[*EmployeeApi*](doc/EmployeeApi.md) | [**getCheckoutBySticker**](doc/EmployeeApi.md#getcheckoutbysticker) | **GET** /v1/employee/checkouts/sticker/{publicId} | Demande en attente à la caisse de l&#39;autocollant lu (NFC, QR ou lien)
[*EmployeeApi*](doc/EmployeeApi.md) | [**getEmployeeOperation**](doc/EmployeeApi.md#getemployeeoperation) | **GET** /v1/employee/operations/{operationId} | Détail d&#39;une opération (reçu)
[*EmployeeApi*](doc/EmployeeApi.md) | [**getEmployeeProfile**](doc/EmployeeApi.md#getemployeeprofile) | **GET** /v1/employee/profile | Mon profil de bénéficiaire
[*EmployeeApi*](doc/EmployeeApi.md) | [**getEmployeeWallet**](doc/EmployeeApi.md#getemployeewallet) | **GET** /v1/employee/wallet | Solde du bénéficiaire, par catégorie, avec les plafonds et les expirations
[*EmployeeApi*](doc/EmployeeApi.md) | [**getFamily**](doc/EmployeeApi.md#getfamily) | **GET** /v1/employee/family | Ma famille (processus v2) : membres, solde par type, plafond et date de fin
[*EmployeeApi*](doc/EmployeeApi.md) | [**listEmployeeNotifications**](doc/EmployeeApi.md#listemployeenotifications) | **GET** /v1/employee/notifications | Mes notifications (crédits reçus, paiements, paiements de ma famille), récentes d&#39;abord
[*EmployeeApi*](doc/EmployeeApi.md) | [**listEmployeeOperations**](doc/EmployeeApi.md#listemployeeoperations) | **GET** /v1/employee/operations | Historique de mes opérations (paiements, crédits reçus, expirations)
[*EmployeeApi*](doc/EmployeeApi.md) | [**listPaymentRequests**](doc/EmployeeApi.md#listpaymentrequests) | **GET** /v1/employee/payment-requests | Demandes de paiement en attente de ma confirmation
[*EmployeeApi*](doc/EmployeeApi.md) | [**lookupMerchant**](doc/EmployeeApi.md#lookupmerchant) | **GET** /v1/employee/merchants/{merchantCode} | Commerçant correspondant à un code (QR scanné ou saisi), avant le paiement
[*EmployeeApi*](doc/EmployeeApi.md) | [**payMerchant**](doc/EmployeeApi.md#paymerchant) | **POST** /v1/employee/payments | Payer un commerçant (code ou QR commerçant, montant, PIN)
[*EmployeeApi*](doc/EmployeeApi.md) | [**readEmployeeNotifications**](doc/EmployeeApi.md#reademployeenotifications) | **POST** /v1/employee/notifications/read | Tout marquer comme lu
[*EmployeeApi*](doc/EmployeeApi.md) | [**reclaimFamilyCredit**](doc/EmployeeApi.md#reclaimfamilycredit) | **POST** /v1/employee/family/members/{memberId}/reclaim | Reprendre le crédit d&#39;un membre (un type, ou tous si creditType est null)
[*EmployeeApi*](doc/EmployeeApi.md) | [**refusePaymentRequest**](doc/EmployeeApi.md#refusepaymentrequest) | **POST** /v1/employee/payment-requests/{requestId}/refuse | Refuser une demande de paiement
[*EmployeeApi*](doc/EmployeeApi.md) | [**transferToFamilyMember**](doc/EmployeeApi.md#transfertofamilymember) | **POST** /v1/employee/family/transfers | Transférer du crédit à un membre (même type, sans frais, plafond et date de fin facultatifs)
[*MeApi*](doc/MeApi.md) | [**completeOnboardingTour**](doc/MeApi.md#completeonboardingtour) | **POST** /v1/me/onboarding-tour | Marque la visite guidée comme vue ou passée
[*MeApi*](doc/MeApi.md) | [**getMe**](doc/MeApi.md#getme) | **GET** /v1/me | Profil de l&#39;utilisateur connecté (rôle, permissions, tenant)
[*MerchantApi*](doc/MerchantApi.md) | [**assignCashierRegister**](doc/MerchantApi.md#assigncashierregister) | **PUT** /v1/merchant/cashiers/{userId}/register | Rattacher un caissier à une caisse (propriétaire)
[*MerchantApi*](doc/MerchantApi.md) | [**cancelCheckout**](doc/MerchantApi.md#cancelcheckout) | **POST** /v1/merchant/checkouts/{checkoutId}/cancel | Annuler une demande encore en attente
[*MerchantApi*](doc/MerchantApi.md) | [**cancelMerchantPayment**](doc/MerchantApi.md#cancelmerchantpayment) | **POST** /v1/merchant/payments/{paymentId}/cancel | Annuler un encaissement encore « Initié »
[*MerchantApi*](doc/MerchantApi.md) | [**createCheckout**](doc/MerchantApi.md#createcheckout) | **POST** /v1/merchant/registers/{registerId}/checkouts | Demander un paiement à la caisse (montant, type) ; le client l&#39;approche et confirme
[*MerchantApi*](doc/MerchantApi.md) | [**createPayoutQuote**](doc/MerchantApi.md#createpayoutquote) | **POST** /v1/merchant/payout-quotes | Simuler une demande de virement (brut → commission → net)
[*MerchantApi*](doc/MerchantApi.md) | [**createPayoutRequest**](doc/MerchantApi.md#createpayoutrequest) | **POST** /v1/merchant/payouts | Demander un virement à partir d&#39;une simulation
[*MerchantApi*](doc/MerchantApi.md) | [**createRegister**](doc/MerchantApi.md#createregister) | **POST** /v1/merchant/registers | Créer une caisse (propriétaire)
[*MerchantApi*](doc/MerchantApi.md) | [**downloadRegisterStickerPdf**](doc/MerchantApi.md#downloadregisterstickerpdf) | **GET** /v1/merchant/registers/{registerId}/sticker/pdf | PDF imprimable 8 × 8 cm de l&#39;autocollant (QR du lien, nom du commerce et de la caisse)
[*MerchantApi*](doc/MerchantApi.md) | [**getCheckoutByIdempotencyKey**](doc/MerchantApi.md#getcheckoutbyidempotencykey) | **GET** /v1/merchant/checkouts/by-idempotency-key/{key} | Statut d&#39;une demande par sa clé d&#39;idempotence (reprise après coupure réseau)
[*MerchantApi*](doc/MerchantApi.md) | [**getMerchantDashboard**](doc/MerchantApi.md#getmerchantdashboard) | **GET** /v1/merchant/dashboard | Tableau de bord du commerçant
[*MerchantApi*](doc/MerchantApi.md) | [**getMerchantPayment**](doc/MerchantApi.md#getmerchantpayment) | **GET** /v1/merchant/payments/{paymentId} | Détail d&#39;un encaissement (suivi de la confirmation, commission, règlement, historique)
[*MerchantApi*](doc/MerchantApi.md) | [**getMerchantProfile**](doc/MerchantApi.md#getmerchantprofile) | **GET** /v1/merchant/profile | Mon commerce : coordonnées, profil de commission, points de vente, équipe
[*MerchantApi*](doc/MerchantApi.md) | [**getPayoutCommissionInvoice**](doc/MerchantApi.md#getpayoutcommissioninvoice) | **GET** /v1/merchant/payouts/{payoutId}/invoice | Facture de commission du virement en PDF (tâche 10 ; 409 pour un virement rejeté)
[*MerchantApi*](doc/MerchantApi.md) | [**getPayoutRequest**](doc/MerchantApi.md#getpayoutrequest) | **GET** /v1/merchant/payouts/{payoutId} | Détail d&#39;une demande de virement, avec son historique
[*MerchantApi*](doc/MerchantApi.md) | [**getRegisterSticker**](doc/MerchantApi.md#getregistersticker) | **GET** /v1/merchant/registers/{registerId}/sticker | Lien NDEF signé à écrire sur l&#39;autocollant NFC de la caisse (propriétaire)
[*MerchantApi*](doc/MerchantApi.md) | [**initiateMerchantPayment**](doc/MerchantApi.md#initiatemerchantpayment) | **POST** /v1/merchant/payments | Initier un encaissement par code client (DP n° 17)
[*MerchantApi*](doc/MerchantApi.md) | [**listMerchantDocuments**](doc/MerchantApi.md#listmerchantdocuments) | **GET** /v1/merchant/documents | Factures de commission, relevés et attestations
[*MerchantApi*](doc/MerchantApi.md) | [**listMerchantPayments**](doc/MerchantApi.md#listmerchantpayments) | **GET** /v1/merchant/payments | Historique des encaissements
[*MerchantApi*](doc/MerchantApi.md) | [**listMerchantReceivables**](doc/MerchantApi.md#listmerchantreceivables) | **GET** /v1/merchant/receivables | Créances : paiements confirmés non encore réglés
[*MerchantApi*](doc/MerchantApi.md) | [**listMerchantSettlements**](doc/MerchantApi.md#listmerchantsettlements) | **GET** /v1/merchant/settlements | Règlements reçus et prévus (J+2)
[*MerchantApi*](doc/MerchantApi.md) | [**listPayoutRequests**](doc/MerchantApi.md#listpayoutrequests) | **GET** /v1/merchant/payouts | Demandes de virement
[*MerchantApi*](doc/MerchantApi.md) | [**listRegisters**](doc/MerchantApi.md#listregisters) | **GET** /v1/merchant/registers | Caisses du commerce (le caissier ne voit que la sienne)
[*MerchantApi*](doc/MerchantApi.md) | [**refundMerchantPayment**](doc/MerchantApi.md#refundmerchantpayment) | **POST** /v1/merchant/payments/{paymentId}/refund | Annuler un paiement confirmé dans le délai du paramétrage (24 h par défaut)
[*MerchantApi*](doc/MerchantApi.md) | [**streamCheckoutEvents**](doc/MerchantApi.md#streamcheckoutevents) | **GET** /v1/merchant/registers/{registerId}/checkouts/events | Flux temps réel (SSE) des demandes de la caisse (payée, refusée, expirée)
[*MerchantApi*](doc/MerchantApi.md) | [**updateRegister**](doc/MerchantApi.md#updateregister) | **PATCH** /v1/merchant/registers/{registerId} | Renommer, activer ou désactiver une caisse (propriétaire)
[*PublicApi*](doc/PublicApi.md) | [**createContactMessage**](doc/PublicApi.md#createcontactmessage) | **POST** /v1/public/contact-messages | Envoie un message depuis la section « Nous contacter » de la page d&#39;accueil
[*PublicApi*](doc/PublicApi.md) | [**getPlatformTerms**](doc/PublicApi.md#getplatformterms) | **GET** /v1/public/terms | Conditions de la plateforme affichées dans les textes des pages
[*SystemApi*](doc/SystemApi.md) | [**getHealth**](doc/SystemApi.md#gethealth) | **GET** /health | Sonde de vivacité de l&#39;API
[*TeamApi*](doc/TeamApi.md) | [**createTeamUser**](doc/TeamApi.md#createteamuser) | **POST** /v1/team/users | Créer un utilisateur (RH, Finance ou Caissier)
[*TeamApi*](doc/TeamApi.md) | [**deactivateTeamUser**](doc/TeamApi.md#deactivateteamuser) | **POST** /v1/team/users/{userId}/deactivate | Désactiver un utilisateur
[*TeamApi*](doc/TeamApi.md) | [**listTeamUsers**](doc/TeamApi.md#listteamusers) | **GET** /v1/team/users | Utilisateurs de mon entreprise ou de mon commerce
[*TeamApi*](doc/TeamApi.md) | [**resetTeamUserPassword**](doc/TeamApi.md#resetteamuserpassword) | **POST** /v1/team/users/{userId}/reset-password | Générer un nouveau mot de passe temporaire
[*TeamApi*](doc/TeamApi.md) | [**updateTeamUser**](doc/TeamApi.md#updateteamuser) | **PATCH** /v1/team/users/{userId} | Modifier le nom ou le rôle d&#39;un utilisateur


## Documentation For Models

 - [AccountChange](doc/AccountChange.md)
 - [AccountRecord](doc/AccountRecord.md)
 - [AccountStatus](doc/AccountStatus.md)
 - [AdminDashboard](doc/AdminDashboard.md)
 - [AdminMonthlyFlow](doc/AdminMonthlyFlow.md)
 - [AdminPayoutRequest](doc/AdminPayoutRequest.md)
 - [AdminPayoutRequestDetail](doc/AdminPayoutRequestDetail.md)
 - [AdminPayoutRequestPage](doc/AdminPayoutRequestPage.md)
 - [AdminTeamUserUpdate](doc/AdminTeamUserUpdate.md)
 - [AdminTransaction](doc/AdminTransaction.md)
 - [AdminTransactionPage](doc/AdminTransactionPage.md)
 - [AdminUser](doc/AdminUser.md)
 - [AdminUserCreate](doc/AdminUserCreate.md)
 - [AdminUserDetail](doc/AdminUserDetail.md)
 - [AdminUserPage](doc/AdminUserPage.md)
 - [AdminUserTenant](doc/AdminUserTenant.md)
 - [AllocationImportPreview](doc/AllocationImportPreview.md)
 - [AllocationImportRequest](doc/AllocationImportRequest.md)
 - [AllocationImportRow](doc/AllocationImportRow.md)
 - [AllocationLine](doc/AllocationLine.md)
 - [AllocationPreview](doc/AllocationPreview.md)
 - [AllocationPreviewEmployee](doc/AllocationPreviewEmployee.md)
 - [AllocationPreviewLine](doc/AllocationPreviewLine.md)
 - [AllocationPreviewRequest](doc/AllocationPreviewRequest.md)
 - [AllocationRequest](doc/AllocationRequest.md)
 - [AllocationResult](doc/AllocationResult.md)
 - [AllocationTemplate](doc/AllocationTemplate.md)
 - [AllocationTemplateInput](doc/AllocationTemplateInput.md)
 - [AllocationTemplateList](doc/AllocationTemplateList.md)
 - [AllocationTypeAmount](doc/AllocationTypeAmount.md)
 - [Approval](doc/Approval.md)
 - [ApprovalCommissionGrid](doc/ApprovalCommissionGrid.md)
 - [ApprovalLegalFormChange](doc/ApprovalLegalFormChange.md)
 - [ApprovalPage](doc/ApprovalPage.md)
 - [ApprovalRejectRequest](doc/ApprovalRejectRequest.md)
 - [ApprovalStatus](doc/ApprovalStatus.md)
 - [ApprovalType](doc/ApprovalType.md)
 - [AuditLogEntry](doc/AuditLogEntry.md)
 - [AuditLogPage](doc/AuditLogPage.md)
 - [CashierRegisterAssignment](doc/CashierRegisterAssignment.md)
 - [CategoryBalance](doc/CategoryBalance.md)
 - [Checkout](doc/Checkout.md)
 - [CheckoutCreate](doc/CheckoutCreate.md)
 - [CheckoutRefusal](doc/CheckoutRefusal.md)
 - [CheckoutRefusalReason](doc/CheckoutRefusalReason.md)
 - [CheckoutRefusedProblem](doc/CheckoutRefusedProblem.md)
 - [CheckoutRefusedProblemAllOfDetails](doc/CheckoutRefusedProblemAllOfDetails.md)
 - [CheckoutStatus](doc/CheckoutStatus.md)
 - [CommissionGrid](doc/CommissionGrid.md)
 - [CommissionGridChangeRequest](doc/CommissionGridChangeRequest.md)
 - [CommissionTier](doc/CommissionTier.md)
 - [CompanyAccount](doc/CompanyAccount.md)
 - [CompanyAccountPage](doc/CompanyAccountPage.md)
 - [CompanyCreate](doc/CompanyCreate.md)
 - [CompanyDashboard](doc/CompanyDashboard.md)
 - [CompanyMonthlyFlow](doc/CompanyMonthlyFlow.md)
 - [CompanyOverview](doc/CompanyOverview.md)
 - [CompanyUpdate](doc/CompanyUpdate.md)
 - [ConfirmPaymentRequest403Response](doc/ConfirmPaymentRequest403Response.md)
 - [ContactMessage](doc/ContactMessage.md)
 - [ContactMessageCreate](doc/ContactMessageCreate.md)
 - [ContactMessageHandle](doc/ContactMessageHandle.md)
 - [ContactMessagePage](doc/ContactMessagePage.md)
 - [ContactMessageReceipt](doc/ContactMessageReceipt.md)
 - [ContactMessageStatus](doc/ContactMessageStatus.md)
 - [ContactRequesterType](doc/ContactRequesterType.md)
 - [CreditBatchStatus](doc/CreditBatchStatus.md)
 - [CreditOrder](doc/CreditOrder.md)
 - [CreditOrderCreate](doc/CreditOrderCreate.md)
 - [CreditOrderDecisionReason](doc/CreditOrderDecisionReason.md)
 - [CreditOrderDetail](doc/CreditOrderDetail.md)
 - [CreditOrderEvent](doc/CreditOrderEvent.md)
 - [CreditOrderEventAction](doc/CreditOrderEventAction.md)
 - [CreditOrderLine](doc/CreditOrderLine.md)
 - [CreditOrderPage](doc/CreditOrderPage.md)
 - [CreditOrderQuote](doc/CreditOrderQuote.md)
 - [CreditOrderQuoteRequest](doc/CreditOrderQuoteRequest.md)
 - [CreditType](doc/CreditType.md)
 - [CreditTypeAmount](doc/CreditTypeAmount.md)
 - [CreditTypeSettings](doc/CreditTypeSettings.md)
 - [Currency](doc/Currency.md)
 - [CustomerCheckout](doc/CustomerCheckout.md)
 - [CustomerSummary](doc/CustomerSummary.md)
 - [DecisionReason](doc/DecisionReason.md)
 - [Department](doc/Department.md)
 - [DepartmentAssignment](doc/DepartmentAssignment.md)
 - [DepartmentCreate](doc/DepartmentCreate.md)
 - [DepartmentList](doc/DepartmentList.md)
 - [Direction](doc/Direction.md)
 - [Dispute](doc/Dispute.md)
 - [DisputeDetail](doc/DisputeDetail.md)
 - [DisputeNote](doc/DisputeNote.md)
 - [DisputeNoteCreate](doc/DisputeNoteCreate.md)
 - [DisputeOpen](doc/DisputeOpen.md)
 - [DisputePage](doc/DisputePage.md)
 - [DisputeStatus](doc/DisputeStatus.md)
 - [Employee](doc/Employee.md)
 - [EmployeeAssignment](doc/EmployeeAssignment.md)
 - [EmployeeAssignmentResult](doc/EmployeeAssignmentResult.md)
 - [EmployeeBulkStatusChange](doc/EmployeeBulkStatusChange.md)
 - [EmployeeBulkStatusResult](doc/EmployeeBulkStatusResult.md)
 - [EmployeeBulkStatusResultResultsInner](doc/EmployeeBulkStatusResultResultsInner.md)
 - [EmployeeCreate](doc/EmployeeCreate.md)
 - [EmployeeDepartment](doc/EmployeeDepartment.md)
 - [EmployeeImportConfirm](doc/EmployeeImportConfirm.md)
 - [EmployeeImportPreview](doc/EmployeeImportPreview.md)
 - [EmployeeImportRequest](doc/EmployeeImportRequest.md)
 - [EmployeeImportResult](doc/EmployeeImportResult.md)
 - [EmployeeNotification](doc/EmployeeNotification.md)
 - [EmployeeNotificationKind](doc/EmployeeNotificationKind.md)
 - [EmployeeNotificationPage](doc/EmployeeNotificationPage.md)
 - [EmployeeOperation](doc/EmployeeOperation.md)
 - [EmployeeOperationDetail](doc/EmployeeOperationDetail.md)
 - [EmployeeOperationPage](doc/EmployeeOperationPage.md)
 - [EmployeeOperationStatus](doc/EmployeeOperationStatus.md)
 - [EmployeeOperationType](doc/EmployeeOperationType.md)
 - [EmployeePage](doc/EmployeePage.md)
 - [EmployeePaymentCreate](doc/EmployeePaymentCreate.md)
 - [EmployeePaymentRequest](doc/EmployeePaymentRequest.md)
 - [EmployeePaymentRequestList](doc/EmployeePaymentRequestList.md)
 - [EmployeeProfile](doc/EmployeeProfile.md)
 - [EmployeeStatus](doc/EmployeeStatus.md)
 - [EmployeeWallet](doc/EmployeeWallet.md)
 - [ExpiredCreditsDestination](doc/ExpiredCreditsDestination.md)
 - [FamilyAccountsSetting](doc/FamilyAccountsSetting.md)
 - [FamilyList](doc/FamilyList.md)
 - [FamilyMember](doc/FamilyMember.md)
 - [FamilyMemberBalance](doc/FamilyMemberBalance.md)
 - [FamilyMemberCreate](doc/FamilyMemberCreate.md)
 - [FamilyMemberCreated](doc/FamilyMemberCreated.md)
 - [FamilyReclaim](doc/FamilyReclaim.md)
 - [FamilyReclaimResult](doc/FamilyReclaimResult.md)
 - [FamilyRelationship](doc/FamilyRelationship.md)
 - [FamilyTransfer](doc/FamilyTransfer.md)
 - [FamilyTransferResult](doc/FamilyTransferResult.md)
 - [FieldError](doc/FieldError.md)
 - [FieldErrorCode](doc/FieldErrorCode.md)
 - [FieldErrorParamsValue](doc/FieldErrorParamsValue.md)
 - [FirstValidation](doc/FirstValidation.md)
 - [FraudAlert](doc/FraudAlert.md)
 - [FraudAlertKind](doc/FraudAlertKind.md)
 - [FraudAlertPage](doc/FraudAlertPage.md)
 - [FraudAlertSeverity](doc/FraudAlertSeverity.md)
 - [FraudAlertStatus](doc/FraudAlertStatus.md)
 - [FundingBankAccount](doc/FundingBankAccount.md)
 - [HealthStatus](doc/HealthStatus.md)
 - [IbanChangeRequest](doc/IbanChangeRequest.md)
 - [IdempotencyInProgressProblem](doc/IdempotencyInProgressProblem.md)
 - [ImportIssue](doc/ImportIssue.md)
 - [ImportIssueCode](doc/ImportIssueCode.md)
 - [ImportRow](doc/ImportRow.md)
 - [InlineObject](doc/InlineObject.md)
 - [InlineObject1](doc/InlineObject1.md)
 - [InlineObject2](doc/InlineObject2.md)
 - [InsufficientFundsProblem](doc/InsufficientFundsProblem.md)
 - [InsufficientFundsProblemAllOfDetails](doc/InsufficientFundsProblemAllOfDetails.md)
 - [Invoice](doc/Invoice.md)
 - [InvoicePage](doc/InvoicePage.md)
 - [InvoiceStatus](doc/InvoiceStatus.md)
 - [KycAccountType](doc/KycAccountType.md)
 - [KycCorrections](doc/KycCorrections.md)
 - [KycCorrectionsCorrectionsInner](doc/KycCorrectionsCorrectionsInner.md)
 - [KycDocument](doc/KycDocument.md)
 - [KycDocumentStatus](doc/KycDocumentStatus.md)
 - [KycDocumentType](doc/KycDocumentType.md)
 - [KycEvent](doc/KycEvent.md)
 - [KycFile](doc/KycFile.md)
 - [KycFilePage](doc/KycFilePage.md)
 - [KycFileSummary](doc/KycFileSummary.md)
 - [KycPiece](doc/KycPiece.md)
 - [KycStatus](doc/KycStatus.md)
 - [LegalForm](doc/LegalForm.md)
 - [LegalFormChangeRequest](doc/LegalFormChangeRequest.md)
 - [LimitExceededProblem](doc/LimitExceededProblem.md)
 - [LimitExceededProblemAllOfDetails](doc/LimitExceededProblemAllOfDetails.md)
 - [LimitType](doc/LimitType.md)
 - [LoginRequest](doc/LoginRequest.md)
 - [LoginResult](doc/LoginResult.md)
 - [Me](doc/Me.md)
 - [MeMfa](doc/MeMfa.md)
 - [MerchantAccount](doc/MerchantAccount.md)
 - [MerchantAccountPage](doc/MerchantAccountPage.md)
 - [MerchantCategory](doc/MerchantCategory.md)
 - [MerchantCreate](doc/MerchantCreate.md)
 - [MerchantCreditTypes](doc/MerchantCreditTypes.md)
 - [MerchantDashboard](doc/MerchantDashboard.md)
 - [MerchantDocument](doc/MerchantDocument.md)
 - [MerchantDocumentPage](doc/MerchantDocumentPage.md)
 - [MerchantDocumentType](doc/MerchantDocumentType.md)
 - [MerchantLookup](doc/MerchantLookup.md)
 - [MerchantMonthlyFlow](doc/MerchantMonthlyFlow.md)
 - [MerchantOverview](doc/MerchantOverview.md)
 - [MerchantPayment](doc/MerchantPayment.md)
 - [MerchantPaymentDetail](doc/MerchantPaymentDetail.md)
 - [MerchantPaymentPage](doc/MerchantPaymentPage.md)
 - [MerchantProfile](doc/MerchantProfile.md)
 - [MerchantUpdate](doc/MerchantUpdate.md)
 - [MfaChallengeResult](doc/MfaChallengeResult.md)
 - [MfaEnrollment](doc/MfaEnrollment.md)
 - [MfaEnrollmentConfirmRequest](doc/MfaEnrollmentConfirmRequest.md)
 - [MfaEnrollmentConfirmResult](doc/MfaEnrollmentConfirmResult.md)
 - [MfaProofRequest](doc/MfaProofRequest.md)
 - [MfaReEnrollmentRequest](doc/MfaReEnrollmentRequest.md)
 - [MfaVerifyRequest](doc/MfaVerifyRequest.md)
 - [MfaVerifyWithRecoveryCode](doc/MfaVerifyWithRecoveryCode.md)
 - [MfaVerifyWithTotp](doc/MfaVerifyWithTotp.md)
 - [MobileLogin200Response](doc/MobileLogin200Response.md)
 - [MobileLoginRequest](doc/MobileLoginRequest.md)
 - [MobileMfaVerifyRequest](doc/MobileMfaVerifyRequest.md)
 - [MobileRefreshRequest](doc/MobileRefreshRequest.md)
 - [MobileSession](doc/MobileSession.md)
 - [MyKycFile](doc/MyKycFile.md)
 - [OrderStatus](doc/OrderStatus.md)
 - [OverviewAllocation](doc/OverviewAllocation.md)
 - [OverviewEmployee](doc/OverviewEmployee.md)
 - [OverviewInvoice](doc/OverviewInvoice.md)
 - [OverviewKyc](doc/OverviewKyc.md)
 - [OverviewOrder](doc/OverviewOrder.md)
 - [OverviewPayout](doc/OverviewPayout.md)
 - [OverviewSale](doc/OverviewSale.md)
 - [OverviewUser](doc/OverviewUser.md)
 - [PageCount](doc/PageCount.md)
 - [PageInfo](doc/PageInfo.md)
 - [PaginatedEnvelope](doc/PaginatedEnvelope.md)
 - [PasswordChangeRequest](doc/PasswordChangeRequest.md)
 - [PasswordForgotRequest](doc/PasswordForgotRequest.md)
 - [PasswordPolicy](doc/PasswordPolicy.md)
 - [PasswordPolicyRule](doc/PasswordPolicyRule.md)
 - [PasswordPolicyRuleCode](doc/PasswordPolicyRuleCode.md)
 - [PasswordResetRequest](doc/PasswordResetRequest.md)
 - [PasswordResetWithOtp](doc/PasswordResetWithOtp.md)
 - [PasswordResetWithToken](doc/PasswordResetWithToken.md)
 - [PaymentCode](doc/PaymentCode.md)
 - [PaymentEvent](doc/PaymentEvent.md)
 - [PaymentInitiateRequest](doc/PaymentInitiateRequest.md)
 - [PaymentStatus](doc/PaymentStatus.md)
 - [PayoutEvent](doc/PayoutEvent.md)
 - [PayoutPayment](doc/PayoutPayment.md)
 - [PayoutPaymentRecord](doc/PayoutPaymentRecord.md)
 - [PayoutQuote](doc/PayoutQuote.md)
 - [PayoutQuoteRequest](doc/PayoutQuoteRequest.md)
 - [PayoutRequest](doc/PayoutRequest.md)
 - [PayoutRequestCreate](doc/PayoutRequestCreate.md)
 - [PayoutRequestDetail](doc/PayoutRequestDetail.md)
 - [PayoutRequestPage](doc/PayoutRequestPage.md)
 - [PayoutRequestStatus](doc/PayoutRequestStatus.md)
 - [PinChange](doc/PinChange.md)
 - [PinConfirmation](doc/PinConfirmation.md)
 - [PinRefusedProblem](doc/PinRefusedProblem.md)
 - [PinRefusedProblemAllOfDetails](doc/PinRefusedProblemAllOfDetails.md)
 - [PlatformSettings](doc/PlatformSettings.md)
 - [PlatformSettingsChange](doc/PlatformSettingsChange.md)
 - [PlatformSettingsWithholding](doc/PlatformSettingsWithholding.md)
 - [PlatformTerms](doc/PlatformTerms.md)
 - [PointOfSale](doc/PointOfSale.md)
 - [PositionList](doc/PositionList.md)
 - [Problem](doc/Problem.md)
 - [ProblemBase](doc/ProblemBase.md)
 - [ProblemCode](doc/ProblemCode.md)
 - [RateLimitedProblem](doc/RateLimitedProblem.md)
 - [Receivable](doc/Receivable.md)
 - [ReceivablePage](doc/ReceivablePage.md)
 - [RecoveryCodes](doc/RecoveryCodes.md)
 - [Register](doc/Register.md)
 - [RegisterCreate](doc/RegisterCreate.md)
 - [RegisterList](doc/RegisterList.md)
 - [RegisterStatus](doc/RegisterStatus.md)
 - [RegisterSticker](doc/RegisterSticker.md)
 - [RegisterUpdate](doc/RegisterUpdate.md)
 - [RenameDepartmentRequest](doc/RenameDepartmentRequest.md)
 - [RetryAfterDetails](doc/RetryAfterDetails.md)
 - [Role](doc/Role.md)
 - [ServiceUnavailableProblem](doc/ServiceUnavailableProblem.md)
 - [SessionNextStep](doc/SessionNextStep.md)
 - [SessionResult](doc/SessionResult.md)
 - [Settlement](doc/Settlement.md)
 - [SettlementBatch](doc/SettlementBatch.md)
 - [SettlementBatchDetail](doc/SettlementBatchDetail.md)
 - [SettlementBatchPage](doc/SettlementBatchPage.md)
 - [SettlementBatchStatus](doc/SettlementBatchStatus.md)
 - [SettlementPage](doc/SettlementPage.md)
 - [SettlementStatus](doc/SettlementStatus.md)
 - [StaffMember](doc/StaffMember.md)
 - [SubRole](doc/SubRole.md)
 - [TeamSubRole](doc/TeamSubRole.md)
 - [TeamUser](doc/TeamUser.md)
 - [TeamUserCreate](doc/TeamUserCreate.md)
 - [TeamUserCreated](doc/TeamUserCreated.md)
 - [TeamUserList](doc/TeamUserList.md)
 - [TeamUserPassword](doc/TeamUserPassword.md)
 - [TeamUserUpdate](doc/TeamUserUpdate.md)
 - [TemplateAutoRun](doc/TemplateAutoRun.md)
 - [TemporaryCredentials](doc/TemporaryCredentials.md)
 - [TenantSummary](doc/TenantSummary.md)
 - [TransferDeclaration](doc/TransferDeclaration.md)
 - [TransferProof](doc/TransferProof.md)
 - [UserAuditEntry](doc/UserAuditEntry.md)
 - [UserRoleChange](doc/UserRoleChange.md)
 - [UserStatus](doc/UserStatus.md)
 - [UserStatusChange](doc/UserStatusChange.md)
 - [ValidationProblem](doc/ValidationProblem.md)
 - [ValidationProblemAllOfDetails](doc/ValidationProblemAllOfDetails.md)


## Documentation For Authorization


Authentication schemes defined for the API:
### cookieAuth

- **Type**: API key
- **API key parameter name**: __Host-fp_at
- **Location**: 

### csrfToken

- **Type**: API key
- **API key parameter name**: X-CSRF-Token
- **Location**: HTTP header

### bearerAuth

- **Type**: HTTP Bearer Token authentication (JWT)


## Author



