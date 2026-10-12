# Revue securite : WB2, contrat d'authentification 0.2.0 (`/v1/auth/*`, `/v1/me`)

- **Date** : 2026-10-12
- **Relecteur** : securite
- **Base de revue** : `git diff -- docs/handoff/contracts/openapi.yaml` (description §6, §9, §10 ;
  11 routes ; schémas `LoginRequest`, `MfaVerifyRequest`, `MfaEnrollment`, `PasswordChangeRequest`,
  `PasswordForgotRequest`, `PasswordResetRequest`, `LoginResult`, `SessionResult`, `Me`, en-tête
  `Set-Cookie-Session`) ; `packages/api-client` régénéré. Référentiels : SEC-A1 à A8, SEC-W5,
  spec 01, ASVS 4.0.3 niveau 2 ; constats WD1 (`securite-wd1-specs-auth-2026-10-12.md`).
- **Propriétaire** : backend

## Verdict : **OK**

Aucun constat Critique ni Haute. Ouverts : 2 Moyennes, 1 Basse (backend).

Points solides :
- **MFA vérifiée avant toute session**, et défi sans cookie ;
- états de session restreints avec liste blanche de routes et `403` ailleurs ;
- **identifiant de session et `csrfToken` renouvelés** à chaque changement d'état (fixation de
  session impossible) ;
- `401 INVALID_CREDENTIALS` unique (compte inconnu, verrouillé, suspendu, temporaire expiré) ;
- `202` identique pour « mot de passe oublié » ;
- jeton de réinitialisation dans le **fragment**, qui révoque toutes les sessions sans en ouvrir ;
  la MFA reste exigée ensuite ;
- échecs MFA et `CURRENT_PASSWORD_INVALID` dans le même compteur de verrouillage ;
- secret TOTP renvoyé une seule fois, `no-store`, libellé otpauth sans e-mail ni téléphone ;
- cookies `__Host-`/`__Secure-`, `HttpOnly`, `Secure`, `SameSite=Strict`, sans `Domain`, refresh
  limité à `Path=/v1/auth` ;
- CSRF en trois couches : `Origin` exact (y compris sur la connexion), jeton HMAC, en-tête
  personnalisé sur le rafraîchissement ;
- un seul mécanisme d'authentification par requête ;
- `/v1/me` sans e-mail, téléphone ni solde, tenant issu de la session ;
- bornes de longueur sur toutes les entrées (mot de passe 256, identifiant 254) ;
- `additionalProperties: false`.

## Constats

```
[CONSTAT] WB2-S01 Ré-enrôlement MFA depuis une session complète sans nouvelle preuve
Sévérité : Moyenne
Fichier : docs/handoff/contracts/openapi.yaml, /v1/auth/mfa/enroll (« ou complète, pour un
  nouvel enrôlement ») et /v1/auth/mfa/enroll/confirm
Preuve : en session complète, enroll puis confirm remplacent le secret TOTP. Seul un code issu du
  NOUVEAU secret est exigé : ni code de l'ancien secret, ni mot de passe.
Scénario d'attaque : poste de caisse ou de comptabilité resté ouvert, ou session volée.
  L'attaquant appelle POST /v1/auth/mfa/enroll, scanne le nouveau secret avec son propre téléphone
  et confirme. Le titulaire ne peut plus se connecter : déni de service, puis récupération par le
  support, cible d'ingénierie sociale. Si l'attaquant connaît aussi le mot de passe (hameçonnage),
  la MFA ne le protège plus jamais.
Correctif proposé : en session complète, mfa/enroll exige une preuve récente : code TOTP de
  l'ANCIEN secret (ou code de secours une fois SEC-A4 décidé) ET mot de passe actuel, par exemple
  { currentPassword, currentCode } dans le corps. Erreurs : CURRENT_PASSWORD_INVALID,
  MFA_CODE_INVALID, comptées dans le verrouillage. L'ancien secret reste actif jusqu'à la
  confirmation. Notification « nouvelle application d'authentification » (déjà prévue). En
  session restreinte MFA_ENROLL (premier enrôlement), le comportement actuel convient.
Exigence : SEC-A4 / ASVS 3.7.1, 2.8.x (4.0.3)
```

```
[CONSTAT] WD1-S01 (suite) Verrouillage : durée de réponse identique non écrite, verrouillage d'un tiers non traité
Sévérité : Moyenne
Fichier : openapi.yaml §10 et /v1/auth/login, /v1/auth/mfa/verify, /v1/auth/password/forgot
Preuve : déjà traité dans le contrat : 401 identique dans tous les cas et limitation de débit par
  IP, route et identifiant haché, donc indépendante de l'existence du compte. Reste ouvert :
  (a) la connexion ne promet pas une DURÉE de réponse identique : un compte inconnu répond sans
      calcul Argon2id, donc plus vite ;
  (b) 5 échecs verrouillent le compte pour tout le monde, alors que n'importe qui peut provoquer
      ces 5 échecs.
Scénario d'attaque :
  (a) un attaquant chronomètre /v1/auth/login : environ 5 ms pour un compte inconnu contre
      environ 150 ms pour un compte réel. Il obtient la liste des comptes valides malgré le
      message unique ;
  (b) il envoie 5 mots de passe faux toutes les 15 min sur le compte ADMIN ou sur les comptes
      Commerçant connus : le titulaire reçoit INVALID_CREDENTIALS même avec le bon mot de passe,
      sans explication à l'écran (caisse ou paie bloquée).
Correctif proposé :
  (a) écrire au contrat : « hachage Argon2id factice pour un identifiant inconnu ; durée de
      réponse indépendante de l'existence, de l'état et du verrouillage du compte » (à tester en B3) ;
  (b) au choix, en restant dans la spec 01 (« 5 échecs → blocage 15 min, puis progressif ;
      notification ») :
      - compteur par couple (compte, IP ou appareil) en plus du compteur global, le blocage global
        ne s'enclenchant qu'à un seuil plus élevé ;
      - ou blocage global maintenu, mais levé par une réinitialisation de mot de passe réussie,
        avec une notification qui indique comment débloquer.
      Si la règle de la spec 01 doit changer, [DÉCISION] à main.
Exigence : SEC-W5 / ASVS 2.2.1 (4.0.3) ; API4:2023
```

```
[CONSTAT] WB2-S02 Anti-rejeu TOTP, tolérance d'horloge et entropie du jeton de réinitialisation non spécifiés
Sévérité : Basse
Fichier : openapi.yaml, /v1/auth/mfa/verify, /v1/auth/mfa/enroll/confirm, PasswordResetRequest
Preuve : rien ne dit qu'un code TOTP déjà accepté est refusé dans sa fenêtre, ni quelle dérive
  d'horloge est tolérée. Le jeton de réinitialisation est borné à 32–256 caractères, sans exigence
  d'entropie ni de stockage haché.
Scénario d'attaque : un code TOTP vu par-dessus l'épaule (caisse), ou intercepté par un
  hameçonnage en temps réel, est rejoué dans les 30 à 90 s sur un autre défi ouvert avec le même
  mot de passe.
Correctif proposé : écrire au contrat :
  - un code TOTP accepté est refusé jusqu'à la fin de sa fenêtre (dernier pas utilisé mémorisé par
    utilisateur) ; tolérance de ±1 pas (30 s) ;
  - jeton de réinitialisation : au moins 128 bits aléatoires (CSPRNG), stocké haché (SHA-256),
    usage unique, invalidé par une nouvelle demande et par tout changement de mot de passe.
Exigence : ASVS 2.8.4, 2.5.x, 2.3.1 (4.0.3)
```

## Revérification : contrat 0.2.1 (1er aller-retour, 2026-10-12)

- **WB2-S01 fermé** : `/v1/auth/mfa/enroll` exige, en session complète, `MfaReEnrollmentRequest`
  `{ currentPassword, currentCode }` (ancien secret). Chaque champ a son code d'erreur, et chaque
  échec compte dans le verrouillage. L'ancien secret reste actif jusqu'à la confirmation, le titulaire
  est notifié. Rendu du QR par img/canvas écrit au contrat.
- **WD1-S01 (a) fermé** : §10, Argon2id factice avec les mêmes paramètres ; verrouillage, état du
  compte et expiration évalués après le hachage ; compte verrouillé = `INVALID_CREDENTIALS` même
  avec le bon mot de passe ; `403` EMPLOYEE/FAMILY_MEMBER seulement pour un compte non verrouillé,
  sans cookie, journalisé.
- **WD1-S01 (b) en attente de décision de l'utilisateur** (portée du verrouillage, qui modifie la
  spec 01 §3) : écrit au §10 avec les deux options, `[DÉCISION]` envoyé à main par backend. Ce
  point reste ouvert, en Moyenne, jusqu'à la décision.
- **WB2-S02 fermé** : anti-rejeu TOTP (±1 pas, code accepté refusé jusqu'à la fin de sa fenêtre) ;
  jeton de réinitialisation d'au moins 128 bits CSPRNG, haché SHA-256, usage unique, invalidé.
- **N-02 conforme** : `currentPassword` facultatif dans le schéma, obligatoire en session complète
  et ignoré à l'état `PASSWORD_CHANGE`. Conditions 1 à 5 et 7 écrites dans `changePassword` ;
  §10 « 10 min au plus, en absolu ; usage unique » ; `SessionResult.restrictedUntil`, y compris
  dans `/refresh` ; 401 générique ; mot de passe temporaire valable jusqu'à 72 h. Condition 6
  (révocation des autres sessions) en attente de décision, avec la recommandation commune.

Non reproduit : redocly et api-client 13/13 (déclaration de backend). Mise en œuvre : à tester en B3.

## Réponses aux questions de backend

| Question | Réponse |
|---|---|
| 4. `403 FORBIDDEN` pour EMPLOYEE/FAMILY_MEMBER après le bon mot de passe : oracle acceptable ? | **Oui.** Il faut déjà le bon mot de passe, et l'API mobile donne la même information. Conditions : vérification du verrouillage **avant** celle du mot de passe (un compte verrouillé reste en `401`), aucun cookie, journal d'audit, message générique sans mention du rôle. |
| 6. QR généré côté client | Acceptable. Le rendu se fait par `<img>` (data URI) ou `<canvas>`, jamais `innerHTML`. La bibliothèque passera ma revue de dépendance en F1 (SC-1). Le constat WD1-S03 de design est ajusté dans ce sens. |
| 1. Défi MFA sans cookie | Acceptable : usage unique, 5 min, compté dans le verrouillage. Le lier à un cookie de pré-authentification serait une défense en profondeur facultative. |
| Révocation des autres sessions après changement (en attente) | Recommandation : **oui, automatique** (voir la revue WD1 §2), ASVS 3.3.3. |

## Avis sur ux N-02 : mot de passe temporaire non redemandé au changement forcé

**Acceptable**, à l'état `PASSWORD_CHANGE` uniquement. C'est un écart assumé et borné à l'ASVS 2.1.6,
à écrire dans le contrat :
1. En session complète, `currentPassword` reste obligatoire.
2. La session restreinte dure **10 min absolues** après la vérification du mot de passe
   temporaire ; le rafraîchissement ne prolonge pas cette échéance.
3. Usage unique : un succès consomme la session restreinte et invalide le mot de passe temporaire.
4. La session est liée à la version du mot de passe temporaire : un renvoi ou l'expiration des
   72 h la révoque.
5. CSRF, limitation de débit et compteur de verrouillage maintenus.
6. Révocation des autres sessions, journal d'audit et notification après le changement.
7. Aucune autre route d'écriture n'est ouverte à cet état.

Compléments acceptés avec ux le 2026-10-12 :
- l'échéance `restrictedUntil` est exposée (avertissement WCAG 2.2.1, N.9 variante absolue) ;
- l'expiration des 10 min n'invalide pas le mot de passe temporaire, valable jusqu'à 72 h ou
  jusqu'au changement réussi ;
- le message « délai dépassé » est déduit de l'état en mémoire du client, jamais d'un paramètre
  d'URL, et le serveur répond de façon générique.

## Décision transmise à main

Durées d'**inactivité** et **absolue** des sessions web (CT-X-6) : absentes des documents ; seul le
jeton d'accès (10 à 15 min, SEC-A3) est fixé. Ma recommandation :
- inactivité 15 min ;
- durée absolue 8 h pour Entreprise et Commerçant, 4 h pour Administrateur ;
- avertissement 2 min avant ;
- les deux limites appliquées par le serveur (expiration du refresh token), et exposées au client
  pour l'avertissement N.9.

## Vérifications

- Lecture du diff du contrat (routes, schémas, en-têtes) ; client régénéré présent.
- Les résultats déclarés par backend (redocly 0 erreur, api-client 13/13) n'ont pas été relancés
  par moi dans cette revue.

## Non vérifié

1. La mise en œuvre (temps constant, verrouillage, rotation, révocation de famille, Origin exact)
   sera vérifiée en B3 et dans le module d'authentification, tests à l'appui.
2. Validation redocly et tests api-client : non reproduits (déclaration de backend).
3. Sections du contrat hors authentification modifiées par WB2 (pagination §7, compteur borné) :
   le compteur borné (LIMIT 10001) est noté ; je n'en ai pas fait une revue détaillée.
