# Revue de sécurité — P0-B5, contrat OpenAPI initial (P0-S6)

- **Relecteur** : securite · **Date** : 2026-10-09 · **Propriétaire** : backend
- **Objet** : `docs/handoff/contracts/openapi.yaml` (OpenAPI 3.1.0, `info.version` 0.1.0, 1 051 lignes)
- **Version relue** : SHA-256 `ad5967bfb55d5ca31a34ebe587c9daa0039e47c5a31bad96504085c21c61f96e`, modifié le 2026-10-09 17:10:31 (+01:00)
- **Base de revue** : le fichier complet (aucun `git diff main...HEAD` possible : le contrat n'est pas commité). **Le `[LIVRÉ]` de backend n'avait pas été reçu** au moment de la revue : si le fichier a changé depuis (empreinte différente), cette revue ne s'applique qu'à la version ci-dessus.
- **Référentiels** : ASVS 4.0.3 (V3.4, V4.1, V4.2, V7.4, V8.3, V11.1, V13, V14.4, V14.5), OWASP API Security Top 10 2023 (API1 BOLA, API2, API3 BOPLA, API4, API8).

## Verdict : **OK** (avec réserves)
Aucun constat Critique ni Haute. 3 constats Moyenne et 6 constats Basse, à corriger dans le contrat **avant la rédaction du contrat du module auth (phase 1) et du module paiements (phase 2)**. Ils ne bloquent pas la phase 0.

## Ce qui est solide (vérifié à la lecture)
| Point | Preuve |
|---|---|
| Refus par défaut : `security` global (cookie + CSRF, ou bearer) ; seule `/health` est publique (`security: []`, `x-public: true`) | l. 259-262, 274-275, 185-187 |
| `/health` ne révèle ni version, ni dépendances, ni hôte ; soumise au rate limiting | l. 269-273, 534-542 |
| Montants : `integer` `int64`, bornés de 0 à 2^53−1, suffixe `Millimes`, aucun montant négatif (champ `direction`), taux en bps de 0 à 10 000 ; aucun `number`/`float`/`decimal` dans le fichier (grep) | l. 37-56, 445-480 |
| IDOR par construction : tenant et utilisateur tirés **uniquement de la session** pour un non-administrateur, RLS en complément, autre tenant = 404 indiscernable, UUID opaques non séquentiels | l. 67-69, 204-208, 880-881 |
| Affectation de masse : corps stricts, champ inconnu refusé (`UNKNOWN_FIELD`) ; `additionalProperties: false` sur les schémas de sortie | l. 153-155 |
| Erreurs : RFC 9457, pas de `detail` libre ni d'`instance`, pas de pile, de SQL, de valeur saisie, de PII, de token, de RIB, de solde complet ; clés i18n côté client | l. 89-103, 595-631 |
| Pas d'énumération à la connexion ni au mot de passe oublié (réponse identique, verrouillage notifié par un autre canal) | l. 101-103 |
| Cookies : `HttpOnly`, `Secure`, `SameSite=Strict`, sans `Domain`, préfixes `__Host-` (accès) et `__Secure-` avec `Path=/v1/auth` (rafraîchissement) ; jetons inaccessibles au JavaScript | l. 188-191, 304-311 |
| CSRF : jeton lié à la session (HMAC) en mémoire + `SameSite=Strict` + contrôle de `Origin` ; bearer mobile sans CSRF ; refus d'une requête portant cookie **et** `Authorization` ; jetons jamais dans l'URL | l. 192-203 |
| Idempotence : UUID strict (motif et longueur), portée utilisateur + opération, empreinte SHA-256, rejeu identique avec `Idempotent-Replayed`, 409 en cours, 422 en cas de conflit, clé enregistrée dans la transaction SQL | l. 157-182, 330-344 |
| En-têtes : HSTS, `nosniff`, `Referrer-Policy: no-referrer`, CSP `default-src 'none'; frame-ancestors 'none'`, `Cache-Control: no-store`, `X-Request-Id` généré par le serveur (valeur cliente ignorée) ; 413 et 415 | l. 227-241 |
| Pagination : curseur opaque, intégrité vérifiée (altéré = 400), sans contournement du tenant ; tri et filtres sur liste blanche, `limit` ≤ 100 | l. 215-225, 345-377 |

## Constats

```
[CONSTAT] S6-01 Énumération de comptes par les en-têtes RateLimit et le 429 sur les routes d'authentification
Sévérité : Moyenne
Fichier : docs/handoff/contracts/openapi.yaml:235-238 (et 101-103)
Preuve : « chaque réponse porte RateLimit-Limit, RateLimit-Remaining, RateLimit-Reset, qui décrivent la politique
  la plus restrictive applicable (IP, compte, route) ».
Scénario d'attaque : un attaquant anonyme envoie POST /v1/auth/login (puis /password/forgot) avec une adresse cible
  et un mot de passe faux. Si le compteur « par compte » n'existe que pour un compte réel, RateLimit-Limit et
  RateLimit-Remaining diffèrent (par exemple 5 contre 100), ou un 429 n'apparaît que pour les comptes existants. Il
  trie ainsi une liste d'adresses ou de téléphones en comptes FlexiPay existants, cibles du bourrage d'identifiants
  et de l'hameçonnage. Cela contourne la règle « aucune énumération » des l. 101-103.
Correctif proposé : sur les routes publiques d'authentification, (a) clé du compteur « par identifiant » calculée sur
  l'identifiant soumis (haché), que le compte existe ou non, et (b) en-têtes RateLimit limités à la politique IP/route,
  jamais au compteur par identifiant. Écrire la règle au §8 et l'ajouter aux tests de la spec 01 (§8, test 1 : réponses
  identiques, en-têtes compris).
Exigence : SEC-W5, SEC-W2 / ASVS 2.2.1, 7.4.1 / API2:2023
```

```
[CONSTAT] S6-02 Idempotence : empreinte ambiguë (route) et refus 422 qui ne peut pas être mémorisé tel que décrit
Sévérité : Moyenne
Fichier : docs/handoff/contracts/openapi.yaml:167-180
Preuve : (1) l. 167-170 « portée : utilisateur + opération (méthode + route) ; empreinte de la méthode, de la route et
  du corps canonique » : on ne sait pas si « route » est le gabarit (/v1/payments/{id}/confirm) ou le chemin concret.
  (2) l. 171-174 : un refus 422 est rejoué à l'identique, mais l. 178-180 : la clé est enregistrée « dans la même
  transaction SQL que l'opération » ; or un refus 422 n'écrit rien (l. 145), la transaction est annulée et la clé
  n'est donc pas mémorisée.
Scénario d'attaque : (1) Avec le gabarit, un client qui réutilise par erreur une clé pour confirmer le paiement B
  reçoit le succès rejoué du paiement A (même corps, même gabarit) : B n'est pas confirmé mais l'écran dit « payé » ;
  le commerçant remet la marchandise sans encaissement. (2) Un paiement refusé pour solde insuffisant n'est pas
  mémorisé. L'app de l'employé, ou un attaquant qui rejoue une requête capturée sur un appareil compromis dans la
  fenêtre de validité, réessaie avec la même clé après un crédit du wallet : le paiement que l'utilisateur croyait
  refusé est exécuté plus tard.
Correctif proposé : (1) empreinte = méthode + chemin concret (paramètres de chemin résolus) + paramètres de requête
  triés + corps canonique ; portée = utilisateur + tenant actif. (2) Choisir et écrire une sémantique : soit la clé et
  la réponse 422 sont enregistrées dans une table d'idempotence distincte du ledger, validée même en cas de refus métier
  (recommandé, cohérent avec l. 171-174) ; soit le 422 n'est pas mémorisé, et le texte l. 173-174 est retiré. Dans les
  deux cas, ajouter les tests E11-bis : même clé et autre {id} → 422 IDEMPOTENCY_KEY_REUSED ; même clé après un refus
  → comportement documenté.
Exigence : SEC-P3 / ASVS 11.1.x (logique métier), 13.2.6 / spec 02 §5, glossaire E11
```

```
[CONSTAT] S6-03 CSRF : routes d'authentification par cookie et récupération du jeton non spécifiées
Sévérité : Moyenne
Fichier : docs/handoff/contracts/openapi.yaml:192-197, 304-320
Preuve : le jeton X-CSRF-Token est « remis dans le corps des réponses qui établissent ou renouvellent la session,
  conservé en mémoire ». Après un rechargement de page, il est perdu : le client doit appeler le rafraîchissement
  (cookie __Secure-fp_rt) sans jeton CSRF. Le contrôle d'Origin n'est décrit que pour les requêtes authentifiées par
  cookie, pas pour les routes publiques (login, refresh, logout, password/forgot).
Scénario d'attaque : SameSite=Strict ne protège pas d'un site du même site (« same-site »). Un sous-domaine compromis
  ou mal configuré du domaine FlexiPay (page marketing, support, ancien enregistrement DNS) envoie un POST
  /v1/auth/refresh avec le cookie de la victime : la rotation brûle son refresh token (déconnexion forcée), ou elle
  déclenche à tort la « détection de réutilisation » qui révoque toute la famille (déni de service ciblé). Le même
  vecteur permet le CSRF de connexion (la victime est connectée au compte de l'attaquant).
Correctif proposé : écrire au §6 que (a) le contrôle d'Origin (liste blanche exacte, Origin absent ou « null »
  refusé) s'applique à TOUTE méthode non sûre, routes publiques d'auth comprises ; (b) POST /v1/auth/refresh par
  cookie exige en plus un en-tête personnalisé non simple (déclenchant un preflight CORS) ; (c) le moyen de récupérer
  le jeton CSRF après un rechargement est défini (corps de la réponse de refresh). Détails dans le contrat auth, mais
  la règle transverse appartient ici.
Exigence : SEC-A7 / ASVS 3.4.3, 4.2.2, 13.2.3, 14.5.2-14.5.3
```

```
[CONSTAT] S6-04 Unicité de la clé d'idempotence : contrat et spec 02 incohérents
Sévérité : Basse
Fichier : docs/handoff/contracts/openapi.yaml:167-168, 181-182 ; docs/specs/02-ledger.md §4
Preuve : contrat « une même clé envoyée par un autre utilisateur est une clé différente » ; spec 02
  « transactions.idempotency_key UNIQUE » (unicité globale).
Scénario d'attaque : implémentée à la lettre de la spec 02, une collision de clé entre deux utilisateurs (client
  défaillant qui réutilise une constante, générateur faible côté app) provoque soit le rejet du paiement légitime du
  second utilisateur, soit, pire, le rejeu de la réponse du premier (fuite d'un reçu de paiement d'un autre
  utilisateur, API3:2023).
Correctif proposé : unicité composite (user_id, opération, clé) ou clé stockée sous forme d'empreinte
  HMAC(user_id ‖ opération ‖ clé), écrite au §5 ; demander l'alignement de la spec 02 (lead).
Exigence : SEC-P3 / ASVS 4.2.1
```

```
[CONSTAT] S6-05 Schéma Problem de base : « details » libre
Sévérité : Basse
Fichier : docs/handoff/contracts/openapi.yaml:629-631 (et oneOf l. 784-786, 906-908, 956-959)
Preuve : `details: { type: object }` sans `additionalProperties: false` ; les réponses font un oneOf avec ce Problem
  de base, qui accepte donc n'importe quel contenu.
Scénario d'attaque : un développeur place un objet d'exception, une ligne SQL ou un objet utilisateur dans `details`
  d'un code non typé ; la validation du contrat (tests de réponse) le laisse passer : fuite (API3:2023, ASVS 7.4.1).
Correctif proposé : dans Problem, interdire `details` (`not: { required: [details] }`) ou le fermer
  (`additionalProperties: false`, aucune propriété) ; seuls les sous-schémas *Problem typés le déclarent. Tests de
  contrat sur les réponses d'erreur.
Exigence : SEC-W5 / ASVS 7.4.1
```

```
[CONSTAT] S6-06 Promesse de validation impossible à tenir pour les entiers
Sévérité : Basse
Fichier : docs/handoff/contracts/openapi.yaml:39-42
Preuve : « jamais de notation scientifique… toute valeur non entière est refusée ». Après JSON.parse, 45000.0 et
  4.5e4 valent 45000 : un validateur (Zod `.int()`, JSON Schema 2020-12 `integer`) les accepte.
Scénario d'attaque : pas de perte de valeur (les dépassements au-delà de 2^53−1 sont rejetés par `maximum`), mais des
  tests de sécurité écrits sur cette promesse échoueront ou seront désactivés, et des clients pourraient se croire
  protégés côté serveur.
Correctif proposé : écrire « 45000.0 et 4.5e4 sont acceptés comme l'entier 45000 ; toute valeur à partie
  fractionnaire non nulle, chaîne, booléen, null ou hors bornes est refusée », ou exiger un analyseur JSON strict
  (coût à évaluer).
Exigence : SEC-W1 / ASVS 5.1.3
```

```
[CONSTAT] S6-07 « security » global : CSRF exigé aussi sur GET
Sévérité : Basse
Fichier : docs/handoff/contracts/openapi.yaml:259-262
Preuve : l'exigence globale `cookieAuth + csrfToken` s'applique à toutes les méthodes, alors que le §6 réserve le CSRF
  aux méthodes non sûres.
Scénario d'attaque : aucun gain direct ; risque de dérive : le client généré envoie le jeton CSRF partout, et une
  implémentation « alignée sur le contrat » pourrait accepter un GET à effet de bord protégé par ce seul jeton.
Correctif proposé : mentionner explicitement dans le schéma `csrfToken` « ignoré sur GET, HEAD et OPTIONS », et
  rappeler qu'aucun GET n'a d'effet de bord.
Exigence : ASVS 13.2.1
```

```
[CONSTAT] S6-08 CORS insuffisamment précisé
Sévérité : Basse
Fichier : docs/handoff/contracts/openapi.yaml:212-213
Preuve : « origines explicitement autorisées, credentials pour le web, jamais * ».
Scénario d'attaque : implémentation courante fautive : renvoyer l'Origin reçue (« reflection ») avec
  Access-Control-Allow-Credentials: true, ou accepter `null` ou un suffixe (evil-flexipay.tn) : un site tiers lit les
  réponses authentifiées de la victime.
Correctif proposé : écrire « comparaison exacte à une liste issue de la configuration (schéma, hôte, port), jamais de
  reflet, `null` refusé, `Vary: Origin`, aucun en-tête exposé au-delà de X-Request-Id, RateLimit-*, Retry-After et
  Idempotent-Replayed ».
Exigence : SEC-W4 / ASVS 14.5.3
```

```
[CONSTAT] S6-09 Serveurs : seul http://localhost est déclaré ; exigence TLS non écrite
Sévérité : Basse
Fichier : docs/handoff/contracts/openapi.yaml:253-255
Preuve : `servers: - url: http://localhost:3000`.
Scénario d'attaque : un générateur ou un client configuré par copie de cette URL vers un environnement distant
  enverrait jetons et cookies en clair (les cookies Secure et __Host- ne seraient d'ailleurs pas posés).
Correctif proposé : ajouter au §6 ou §8 « tout environnement autre que le dev local est en HTTPS (TLS 1.2+) ; le client
  mobile refuse http hors build de dev ».
Exigence : SEC-D1 / ASVS 9.1.1
```

```
[CONSTAT] S6-10 Raison du refus de paiement révélée au commerçant (oracle de solde)
Sévérité : Basse (ajouté le 2026-10-09 à la demande du lead)
Fichier : docs/handoff/contracts/openapi.yaml:137-144
Preuve : pour un appelant autre que le payeur, le code est renvoyé « sans details ». Le commerçant reçoit donc quand
  même INSUFFICIENT_FUNDS ou LIMIT_EXCEEDED, distincts du succès.
Scénario d'attaque : le commerçant saisit le montant A ; s'il recevait missingMillimes = M, il obtiendrait le solde
  exact de l'employé (A − M), soit un « solde complet » interdit par la règle 9. Même sans details, le code distinct
  plus des initiations répétées sur le même QR pendant 60 s (A = 50 000, 25 000, 37 500…) donnent le solde par
  dichotomie, ou révèlent que le plafond du jour est atteint.
Correctif proposé : (a) ne jamais exposer missingMillimes ni remainingMillimes au commerçant (déjà prévu) ; (b) côté
  commerçant, un code unique et générique (par exemple PAYMENT_DECLINED, message « Paiement refusé »), sans la raison,
  qui reste visible seulement par le payeur ; (c) une seule initiation par QR (à écrire dans le contrat paiements).
Exigence : SEC-W5, règle 9 de CLAUDE.md / ASVS 7.4.1, 8.3.x / API3:2023
```

**Membre famille et `missingMillimes`** : ce n'est pas un constat, c'est une décision métier (lead → utilisateur). La spec 06 §1 dit « l'employé et sa famille consultent leurs soldes » sans préciser si le membre voit le solde de l'employé. Avis securite : la règle d'exposition dans les erreurs doit être **identique** à celle de `GET /me/wallet` pour un membre, sinon le masquage ne protège rien, ou bien il fuit par l'erreur. Recommandation par défaut (minimisation) : le membre ne voit que **sa propre limite**. `LIMIT_EXCEEDED` avec `limitType: FAMILY_MEMBER` et `remainingMillimes` calculé sur sa limite est permis ; `INSUFFICIENT_FUNDS` causé par le wallet de l'employé est renvoyé **sans details**. Attention : un « disponible » égal à min(limite restante, solde employé) révèle aussi le solde de l'employé dès que ce solde est inférieur à la limite.

## Points d'attention pour les contrats de module (pas des constats sur ce contrat)
- **Paiements (phase 2)** : à `POST /payments/initiate`, le commerçant connaît le montant. Si les contrôles de solde et
  de plafond s'y exécutent et que le même QR peut être initié plusieurs fois pendant 60 s, la suite de réponses
  INSUFFICIENT_FUNDS / LIMIT_EXCEEDED / succès permet au commerçant de trouver par dichotomie le solde d'un employé
  (oracle de solde). Mesure : une seule initiation par QR, contrôles de solde à la confirmation, réponse au commerçant
  sans distinction. Ajouté au modèle de menaces à l'ouverture du module.
- **Multi-tenant** : la spec 01 prévoit `company_users` et `merchant_users`. Si un utilisateur peut appartenir à
  plusieurs entreprises ou commerçants, « le tenant vient de la session » suppose un tenant actif choisi
  explicitement et vérifié. Règle métier absente : `[DÉCISION]` remontée au lead.
- **Routes administrateur** : un préfixe distinct (`/v1/admin/...`) rendrait le RBAC vérifiable par construction
  (seul cas où un `companyId` en paramètre est légitime).

## Non vérifié
- Validité syntaxique et sémantique du YAML (Spectral, Redocly, ajv) : outils non installés, pnpm indisponible.
  Relecture manuelle uniquement.
- Implémentation : aucun code n'existe (B3 en attente d'outils). Toutes les garanties de ce contrat sont des
  **intentions** à tester en B3 et dans les modules (guard global, CSRF, Origin, idempotence, RLS, masquage).
- Génération des clients TS et Dart (comportement des générateurs avec `type: [string, 'null']`, `const`, `allOf`) :
  hors phase 0.
- Cohérence du contrat avec la version que backend annoncera dans son `[LIVRÉ]` (non reçu au moment de la revue) :
  voir l'empreinte en tête.
- `pnpm audit` et `gitleaks detect` : non lancés (pnpm bloqué par Device Guard, gitleaks absent).

## Revérification — 2e aller-retour (2026-10-09)
Version revérifiée : SHA-256 `8db62af2cf213fea64184dba7db4f2c5cd5b356c9acab5a3e815c616350317f9`, 1 142 lignes (empreinte recalculée par securite, identique à celle annoncée par backend dans son `[CORRIGÉ]`, qui vaut `[LIVRÉ]` P0-B5).

| Constat | État | Preuve dans la nouvelle version |
|---|---|---|
| S6-01 | **Fermé** | l. 290-296 : compteur par identifiant normalisé et haché, que le compte existe ou non ; en-têtes limités à la politique IP/route ; dépassement = réponse générique identique |
| S6-02 | **Fermé** | l. 189-192 : chemin concret, requête triée, corps canonique ; l. 193-206 : registre distinct, refus 422 enregistré durablement et définitif pour la clé ; l. 213-214 : test {A}/{B}. Voir le nouveau constat S6-11 sur le bail |
| S6-03 | **Fermé** | l. 225-241 : Origin exact sur toute méthode non sûre, routes publiques comprises, `null` et absence d'Origin avec cookie refusés ; `X-FlexiPay-Client: web` sur le refresh ; récupération du jeton CSRF par le refresh |
| S6-04 | **Fermé** (contrat) | l. 185-188 : unicité (tenant, utilisateur, clé). L'alignement de la spec 02 §4 reste à faire par le lead |
| S6-05 | **Fermé** | l. 659-703 : `ProblemBase` + `Problem` fermé par `unevaluatedProperties: false`, sans `details` ; variantes typées fermées ; `anyOf` (l. 865, 987, 1038) : un `details` arbitraire n'est accepté par aucune branche |
| S6-06 | **Fermé** | l. 39-46 : reformulé de façon exacte |
| S6-07 | **Fermé** | l. 236-237 et 376-380 : CSRF ignoré sur GET, HEAD, OPTIONS |
| S6-08 | **Fermé** | l. 256-262 : comparaison exacte, pas de reflet, `null` refusé, `Vary: Origin`, méthodes et en-têtes autorisés ou exposés listés |
| S6-09 | **Fermé** | l. 263-264, 311-315 : HTTPS (TLS 1.2+) hors dev local, aucune désactivation de TLS |
| S6-10 | **Fermé** | l. 129, 148-161, 655, exemple l. 1066-1073 : `PAYMENT_DECLINED` générique pour tout appelant autre que le payeur ; « une seule initiation par QR » transmis au futur contrat paiements ; membre famille et COM-04 en attente de décision |

```
[CONSTAT] S6-11 Idempotence : reprise d'un bail expiré sans jeton de clôture (double exécution possible)
Sévérité : Moyenne
Fichier : docs/handoff/contracts/openapi.yaml:193-197, 210-211
Preuve : l. 194-195 « réservation de la clé (état "en cours", avec un bail d'expiration court pour libérer une
  réservation orpheline après un arrêt brutal) » ; l. 196-197 « Succès : écritures au ledger et enregistrement de la
  réponse dans la même transaction SQL ». Rien n'oblige la transaction à vérifier qu'elle détient TOUJOURS la
  réservation au moment du COMMIT.
Scénario d'attaque : au pic de midi, la confirmation d'un paiement (requête 1) attend des verrous plus longtemps que
  le bail. Le client (délai réseau dépassé), ou un employé qui sait que la réponse tarde, renvoie la même requête avec
  la même clé (requête 2) : le bail est expiré, la réservation est reprise et la requête 2 traite le paiement. La
  requête 1 se termine ensuite et valide aussi : l'employé est débité deux fois, le commerçant crédité deux fois.
  Ni E11 ni E17 ne détectent ce cas.
Correctif proposé : écrire au §5 que (a) chaque réservation porte un jeton de clôture (identifiant de propriétaire ou
  numéro de version) ; la transaction de l'étape 2 (et l'enregistrement d'un refus à l'étape 3) verrouille la ligne du
  registre (FOR UPDATE) et annule tout si le jeton a changé ; (b) le bail est supérieur au délai maximal d'une
  transaction financière (statement_timeout ou lock_timeout), ces valeurs étant liées dans la config ; (c) filet de
  sécurité : la clé reste portée par `transactions` avec la contrainte UNIQUE composite (spec 02 §4), si bien qu'une
  seconde écriture au ledger pour la même clé échoue. Test : bail forcé à expirer pendant le traitement → une seule
  écriture au ledger, la seconde requête reçoit le rejeu ou le 409.
Exigence : SEC-P3 / CLAUDE.md règle 4 / ASVS 11.1.x / glossaire E11, E17
```

Point d'attention pour le contrat auth (phase 1), qui n'est pas un constat sur ce contrat : l'anti-énumération doit aussi couvrir le **temps de réponse**. Un calcul Argon2id factice doit être fait quand l'identifiant n'existe pas, sinon la différence de latence révèle l'existence du compte.

**Verdict après le 2e aller-retour : OK.** 0 Critique, 0 Haute ; 1 Moyenne ouverte (S6-11), à corriger au plus tard avant le premier contrat d'opération financière (phase 2). Elle ne bloque pas la phase 0.

## Revérification — 3e et dernier aller-retour (2026-10-09)
Version revérifiée : SHA-256 `e8b0a175dfd5c3eb6cc67e0cd349285f2ed2564c40806d2e896e22d8472268e1`, 1 159 lignes (empreinte recalculée par securite, identique à celle annoncée). Seule la §5 a été relue en détail ; backend indique que le reste est inchangé depuis 8db62af2 (non revérifié ligne à ligne).

| Constat | État | Preuve |
|---|---|---|
| S6-11 | **Fermé** | l. 194-201 : jeton de clôture renouvelé à chaque prise ou reprise ; bail strictement supérieur aux bornes `statement_timeout`/`lock_timeout`, dont il est dérivé. l. 202-207 : relecture sous `FOR UPDATE` et comparaison du jeton dans la transaction du succès, rollback + 409 si le jeton a changé. l. 208-214 : refus enregistré sous la même vérification. l. 215-217 : `UNIQUE` composite dans `transactions`, filet indépendant. l. 218-220 : test de bail expiré |

Remarques pour l'implémentation (phase 2), sans nouveau constat :
- l. 221-223 (étape 4) : la **libération** de la réservation après un échec doit aussi être conditionnée au jeton (`UPDATE … WHERE jeton = <le sien>`). Sinon une requête évincée (409) pourrait libérer la réservation reprise par une autre. L'argent reste protégé par le filet `UNIQUE` (l. 215-217) ; l'effet serait un 409 ou un rejeu incohérent pour le client.
- PostgreSQL 16 n'a pas de `transaction_timeout` (apparu en version 17) : borner seulement `statement_timeout` ne borne pas la durée totale d'une transaction à plusieurs instructions. La vérification du jeton sous `FOR UPDATE` couvre ce cas, et c'est elle qui compte. À tester (test l. 218-220).

**Verdict final P0-S6 : OK.** 0 Critique, 0 Haute, 0 Moyenne, 0 Basse ouverts sur le contrat. Restent hors contrat : les décisions demandées au lead (membre famille, COM-04, alignement de la spec 02 §4).

## Suivi des allers-retours
| Tour | Date | Événement |
|---|---|---|
| 1 | 2026-10-09 | Constats S6-01 à S6-09 envoyés à backend |
| 1 bis | 2026-10-09 | S6-10 ajouté (question du lead sur missingMillimes) ; exposition au membre famille = décision utilisateur |
| 2 | 2026-10-09 | `[CORRIGÉ]` de backend (SHA-256 8db62af2…17f9) : S6-01 à S6-10 fermés ; nouveau S6-11 (Moyenne) envoyé |
| 3 | 2026-10-09 | `[CORRIGÉ]` S6-11 (SHA-256 e8b0a175…68e1) : fermé. Verdict final OK. Limite de 3 allers-retours atteinte sans `[BLOQUÉ]` |
