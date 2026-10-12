/**
 * GENERATED from docs/handoff/contracts/openapi.yaml by openapi-typescript. DO NOT EDIT.
 * Regenerate: pnpm --filter @flexipay/api-client generate
 */
export interface paths {
  '/health': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Sonde de vivacité de l'API
     * @description Route **publique** (`@Public()`). Indique seulement que le processus répond.
     *     Ne renvoie **aucune** information sur la version, les dépendances, l'hôte ou la
     *     configuration. Les contrôles détaillés de dépendances (PostgreSQL, Redis) ne sont pas
     *     exposés publiquement. Soumise au rate limiting par IP.
     */
    get: operations['getHealth'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/login': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Connexion par identifiant (e-mail ou téléphone) et mot de passe
     * @description Route **publique** (`@Public()`), contrôle exact de l'en-tête `Origin` (§6, CSRF de
     *     connexion), rate limiting par IP, route et identifiant haché (§8). Voir la séquence en §10.
     *     Réponse identique (`401 INVALID_CREDENTIALS`) pour un compte inconnu, verrouillé, suspendu,
     *     un mot de passe faux ou un mot de passe temporaire expiré. Journal d'audit : succès et
     *     échec (sans le mot de passe ni l'identifiant en clair).
     */
    post: operations['login'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/mfa/verify': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Réponse au défi MFA (code TOTP)
     * @description Route **publique** (le défi tient lieu d'authentification partielle). Code TOTP RFC 6238
     *     à 6 chiffres (provisoire). Échecs comptés dans le compteur de verrouillage de la connexion (5 échecs).
     *     **Anti-rejeu** (WB2-S02) : tolérance de ±1 pas de 30 s ; un code accepté est refusé
     *     (`MFA_CODE_INVALID`) pour ce compte jusqu'à la fin de sa fenêtre de validité.
     *     Erreurs : `401 MFA_CODE_INVALID` (code faux, le défi reste valable jusqu'au verrouillage),
     *     `401 MFA_CHALLENGE_EXPIRED` (défi inconnu, déjà utilisé, expiré ou invalidé par le
     *     verrouillage : retour à la connexion). Journal d'audit : succès et échec.
     *     Codes de secours (SEC-A4) : en attente de décision, ajoutés ensuite (champ facultatif).
     */
    post: operations['verifyMfa'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/mfa/enroll': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Démarre l'enrôlement TOTP (secret et URI otpauth)
     * @description Session restreinte `MFA_ENROLL` : sans corps. Session **complète** (changement d'appareil
     *     d'authentification, WB2-S01) : corps **obligatoire** `{ currentPassword, currentCode }`,
     *     `currentCode` étant un code de l'**ancien** secret (ou, après décision, un code de
     *     secours) ; champ absent : `400 VALIDATION_FAILED` (`REQUIRED`) ; mot de passe faux :
     *     `CURRENT_PASSWORD_INVALID` ; code faux : `401 MFA_CODE_INVALID` ; chaque échec compte
     *     dans le verrouillage. L'ancien secret reste **actif** jusqu'à la confirmation du nouveau.
     *     Génère un **nouveau** secret à chaque appel (le précédent, non confirmé, est abandonné) ;
     *     il n'est actif qu'après `POST /v1/auth/mfa/enroll/confirm`. Le secret n'est renvoyé
     *     **qu'ici**, jamais journalisé ; le client l'affiche une seule fois (QR généré côté client à
     *     partir d'`otpauthUri`, rendu par `img`/`canvas`, jamais `innerHTML` ; saisie manuelle avec
     *     `secretBase32`) et ne le conserve pas. `Cache-Control: no-store`. Journal d'audit :
     *     démarrage d'enrôlement (sans le secret) ; notification au titulaire en session complète.
     */
    post: operations['startMfaEnrollment'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/mfa/enroll/confirm': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Confirme l'enrôlement TOTP avec un premier code
     * @description Active le secret si le code est valable (`401 MFA_CODE_INVALID` sinon, échec compté dans
     *     le compteur de verrouillage ; `409 RESOURCE_STATE_CONFLICT` si aucun enrôlement n'est en
     *     cours ou s'il a expiré, 10 min, provisoire). La session devient complète (`nextStep: NONE`),
     *     identifiant de session et `csrfToken` renouvelés. Journal d'audit et notification au
     *     titulaire. Codes de secours (SEC-A4) : en attente de décision, ajoutés à cette réponse.
     */
    post: operations['confirmMfaEnrollment'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/password/change': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Change le mot de passe (dont le mot de passe temporaire)
     * @description Session restreinte `PASSWORD_CHANGE` ou session complète.
     *     **`currentPassword`** (ux N-02, avis securite du 2026-10-12, écart ASVS 4.0.3 §2.1.6 assumé) :
     *     - session **complète** : obligatoire (absent : `VALIDATION_FAILED`, code `REQUIRED`) ;
     *     - état **`PASSWORD_CHANGE`** : non demandé et ignoré s'il est envoyé. Cette exemption tient
     *       aux conditions suivantes : (1) la session restreinte dure **10 min au plus, en absolu**,
     *       après la vérification du mot de passe temporaire ; le rafraîchissement ne prolonge jamais
     *       cette échéance, exposée dans `SessionResult.restrictedUntil` (au-delà :
     *       `401 UNAUTHENTICATED` générique, retour à la connexion ; le mot de passe temporaire
     *       reste valable jusqu'à ses 72 h ou jusqu'au changement réussi) ; (2) elle est à
     *       **usage unique** : un changement réussi la consomme (nouvel identifiant de session,
     *       nouveau `csrfToken`, état suivant) et invalide le mot de passe temporaire ; (3) elle est
     *       liée à la **version** du mot de passe temporaire : un renvoi par l'entreprise ou
     *       l'administrateur, ou l'expiration des 72 h, la révoque ; (4) `X-CSRF-Token`, rate
     *       limiting et compteur de verrouillage s'appliquent (refus répétés de la politique
     *       compris) ; (5) aucune autre route d'écriture n'est ouverte dans cet état (§10).
     *     `currentPassword` faux (session complète) :
     *     `400 VALIDATION_FAILED`, champ `/currentPassword` code `CURRENT_PASSWORD_INVALID` ;
     *     l'échec compte dans le compteur de verrouillage (au verrouillage, toutes les sessions sont
     *     révoquées et la requête suivante reçoit `401 UNAUTHENTICATED`). Nouveau mot de passe
     *     refusé par la politique : champ `/newPassword`, code `PASSWORD_POLICY_VIOLATION`, une
     *     entrée par règle non respectée avec `params.rule` (code de `PasswordPolicyRuleCode`) et les
     *     paramètres de la règle. Succès : session renouvelée, `nextStep` suivant (§10). Révocation
     *     des autres sessions et familles de jetons de rafraîchissement : en attente de décision
     *     (recommandation backend et securite : oui, automatique). Journal d'audit et notification
     *     au titulaire. Jamais de mot de passe dans les journaux ni les erreurs.
     */
    post: operations['changePassword'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/password-policy': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Règles de la politique de mot de passe (aide à la saisie)
     * @description Route **publique** (utile à la réinitialisation, sans session). Liste structurée de règles
     *     que le client affiche via ses clés i18n (`passwordPolicy.rule.<codeEnCamelCase>`), sans
     *     aucune règle codée en dur. Le serveur reste seul juge (`PASSWORD_POLICY_VIOLATION`).
     *     Les **valeurs** sont en attente de décision (SEC-A1) ; l'exemple suit la recommandation.
     */
    get: operations['getPasswordPolicy'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/refresh': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Renouvelle la session (rotation du jeton de rafraîchissement)
     * @description Authentifiée par le cookie `__Secure-fp_rt` (`Path=/v1/auth`) et l'en-tête
     *     `X-FlexiPay-Client: web` (pré-vol CORS) ; pas de `X-CSRF-Token` (c'est le moyen de le
     *     récupérer après un rechargement, §6). Rotation : nouveau jeton d'accès, nouveau jeton de
     *     rafraîchissement, nouveau `csrfToken`, état courant (`nextStep`). Jeton absent, invalide,
     *     expiré ou **réutilisé** (toute la famille est alors révoquée, SEC-A3) :
     *     `401 UNAUTHENTICATED` et cookies effacés.
     */
    post: operations['refreshSession'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/logout': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Déconnexion (révoque la session courante)
     * @description Autorisée dans tous les états de session. Révoque la session et sa famille de jetons de
     *     rafraîchissement, efface les cookies (`Max-Age=0`). Idempotente : sans session valable,
     *     `204` quand même (cookies effacés). Journal d'audit.
     */
    post: operations['logout'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/password/forgot': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Demande de réinitialisation du mot de passe
     * @description Route **publique**. Réponse **toujours** `202`, identique et de durée comparable que le
     *     compte existe ou non (anti-énumération, §4) ; rate limiting par IP, route et identifiant
     *     haché. Mécanisme d'envoi (lien ou OTP, durée de validité) : **en attente de décision**
     *     (recommandation : lien par e-mail à usage unique, 15 min). Journal d'audit.
     */
    post: operations['requestPasswordReset'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/password/reset': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Réinitialise le mot de passe (forme provisoire, en attente de décision)
     * @description Route **publique**. **Forme provisoire** tant que le mécanisme n'est pas décidé : elle
     *     suit la recommandation (lien). Le jeton du lien est placé dans le **fragment** de l'URL
     *     (`#token=…`), jamais envoyé au serveur dans l'URL ni journalisé ; la page web le lit et
     *     l'envoie dans le corps. Jeton (WB2-S02) : au moins 128 bits issus d'un générateur
     *     cryptographique, stocké **haché** (SHA-256), usage unique, invalidé par une nouvelle
     *     demande ou par un changement de mot de passe. Jeton inconnu, utilisé ou expiré :
     *     `400 VALIDATION_FAILED` (champ `/token`, code `INVALID_FORMAT`), sans distinguer les cas.
     *     Politique non respectée : `PASSWORD_POLICY_VIOLATION`. Succès : toutes les sessions du
     *     compte sont révoquées, aucune session n'est ouverte (le client renvoie vers la connexion,
     *     MFA comprise). Journal d'audit et notification au titulaire.
     */
    post: operations['resetPassword'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/me': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Profil de l'utilisateur connecté (rôle, permissions, tenant)
     * @description Session **complète** uniquement (une session restreinte reçoit
     *     `403 PASSWORD_CHANGE_REQUIRED` ou `403 MFA_ENROLLMENT_REQUIRED`, §10). Rôle, sous-rôle,
     *     permissions et tenant viennent **uniquement** de la session ; la navigation du client est
     *     calculée à partir de cette réponse, le serveur restant l'autorité sur chaque route.
     *     Aucune donnée sensible (ni e-mail, ni téléphone, ni solde).
     */
    get: operations['getMe'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
}
export type webhooks = Record<string, never>;
export interface components {
  schemas: {
    /**
     * AmountMillimes
     * Format: int64
     * @description Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND.
     *     Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`.
     * @example 45000
     */
    AmountMillimes: number;
    /**
     * PositiveAmountMillimes
     * Format: int64
     * @description Montant en millimes strictement positif (montant d'une opération demandée).
     * @example 45000
     */
    PositiveAmountMillimes: number;
    /**
     * RateBps
     * Format: int32
     * @description Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
     * @example 200
     */
    RateBps: number;
    /**
     * Currency
     * @description Devise ; seule la valeur TND existe (3 décimales, unité de stockage le millime).
     * @enum {string}
     */
    Currency: 'TND';
    /**
     * Direction
     * @description Sens d'un mouvement (les montants ne sont jamais négatifs).
     * @enum {string}
     */
    Direction: 'DEBIT' | 'CREDIT';
    /**
     * Timestamp
     * Format: date-time
     * @description Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
     * @example 2026-10-09T08:30:00.000Z
     */
    Timestamp: string;
    /**
     * CalendarDate
     * Format: date
     * @description Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
     * @example 2026-10-11
     */
    CalendarDate: string;
    /**
     * Uuid
     * Format: uuid
     * @description Identifiant opaque de ressource.
     * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
     */
    Uuid: string;
    /** PageInfo */
    PageInfo: {
      /** Format: int32 */
      limit: number;
      hasMore: boolean;
      /** @description Curseur de la page suivante, `null` sur la dernière page. */
      nextCursor: string | null;
      count?: components['schemas']['PageCount'];
    };
    /**
     * PageCount
     * @description Compteur borné (§7), présent seulement avec `?withCount=true` et si le comptage a abouti.
     *     `isLowerBound: false` : `value` = nombre exact de résultats ; `true` : plus de `value`
     *     résultats (plafond 10 000, provisoire).
     */
    PageCount: {
      /** Format: int32 */
      value: number;
      isLowerBound: boolean;
    };
    /**
     * PaginatedEnvelope
     * @description Enveloppe commune des listes. Chaque endpoint de liste la spécialise avec
     *     `allOf` en précisant le type des éléments de `data`.
     */
    PaginatedEnvelope: {
      data: unknown[];
      page: components['schemas']['PageInfo'];
    };
    /** HealthStatus */
    HealthStatus: {
      /** @constant */
      status: 'OK';
    };
    /** LoginRequest */
    LoginRequest: {
      /**
       * @description E-mail **ou** numéro de téléphone (une seule zone de saisie, spec 01 §5), normalisé par
       *     le serveur. Jamais renvoyé dans une réponse ni une erreur.
       */
      identifier: string;
      /**
       * Format: password
       * @description Jamais journalisé. Aucune règle de politique n'est appliquée à la connexion.
       */
      password: string;
    };
    /**
     * SessionNextStep
     * @description Étape suivante d'une session ouverte (§10). `NONE` : session complète.
     *     `PASSWORD_CHANGE` : mot de passe temporaire à changer. `MFA_ENROLL` : MFA à enrôler.
     *     Liste extensible (valeur inconnue : renvoyer vers la connexion).
     * @enum {string}
     */
    SessionNextStep: 'NONE' | 'PASSWORD_CHANGE' | 'MFA_ENROLL';
    /**
     * CsrfToken
     * @description Jeton anti-CSRF lié à la session (§6), à conserver **en mémoire** uniquement et à envoyer
     *     dans `X-CSRF-Token` sur `POST`, `PUT`, `PATCH`, `DELETE`. Renouvelé à chaque réponse qui
     *     établit ou renouvelle la session.
     */
    CsrfToken: string;
    /**
     * SessionResult
     * @description Session ouverte ou renouvelée (cookies posés par la même réponse).
     */
    SessionResult: {
      nextStep: components['schemas']['SessionNextStep'];
      csrfToken: components['schemas']['CsrfToken'];
      /**
       * @description Présent seulement quand `nextStep` = `PASSWORD_CHANGE` : échéance **absolue** de la
       *     session restreinte (10 min après la vérification du mot de passe temporaire, jamais
       *     prolongée par le rafraîchissement). Sert à l'avertissement d'expiration (WCAG 2.2.1).
       *     À l'échéance : `401 UNAUTHENTICATED` générique ; le mot de passe temporaire reste
       *     valable jusqu'à ses 72 h ou jusqu'au changement réussi.
       */
      restrictedUntil?: components['schemas']['Timestamp'];
    };
    /**
     * MfaChallengeResult
     * @description Mot de passe accepté, défi MFA à résoudre ; aucune session ni cookie.
     */
    MfaChallengeResult: {
      /** @constant */
      nextStep: 'MFA_CHALLENGE';
      /**
       * Format: uuid
       * @description Identifiant opaque du défi, usage unique, valable 5 min (provisoire).
       */
      challengeId: string;
      challengeExpiresAt: components['schemas']['Timestamp'];
    };
    /**
     * LoginResult
     * @description Résultat d'une connexion acceptée : défi MFA (`nextStep: MFA_CHALLENGE`) ou session
     *     (`SessionResult`, `nextStep` ∈ `NONE`, `PASSWORD_CHANGE`, `MFA_ENROLL`).
     */
    LoginResult:
      components['schemas']['MfaChallengeResult'] | components['schemas']['SessionResult'];
    /**
     * TotpCode
     * @description Code TOTP (RFC 6238) à 6 chiffres (provisoire). Jamais journalisé.
     */
    TotpCode: string;
    /** MfaVerifyRequest */
    MfaVerifyRequest: {
      /** Format: uuid */
      challengeId: string;
      code: components['schemas']['TotpCode'];
    };
    /**
     * MfaEnrollment
     * @description Secret TOTP en attente de confirmation (10 min, provisoire). Affiché une seule fois, jamais
     *     journalisé, jamais conservé par le client après l'écran.
     */
    MfaEnrollment: {
      /**
       * @description URI `otpauth://totp/FlexiPay:<libellé>?secret=…&issuer=FlexiPay&algorithm=SHA1&digits=6&period=30` (paramètres provisoires),
       *     à transformer en QR **côté client**. Le libellé ne contient ni e-mail ni téléphone.
       */
      otpauthUri: string;
      /** @description Même secret, en Base32, pour la saisie manuelle. */
      secretBase32: string;
      expiresAt: components['schemas']['Timestamp'];
    };
    /**
     * MfaReEnrollmentRequest
     * @description Preuve exigée pour remplacer un secret MFA en session complète (WB2-S01). Les deux champs
     *     sont obligatoires dans ce cas ; le corps est absent en session restreinte `MFA_ENROLL`.
     */
    MfaReEnrollmentRequest: {
      /** Format: password */
      currentPassword?: string;
      currentCode?: components['schemas']['TotpCode'];
    };
    /** MfaEnrollmentConfirmRequest */
    MfaEnrollmentConfirmRequest: {
      code: components['schemas']['TotpCode'];
    };
    /** PasswordChangeRequest */
    PasswordChangeRequest: {
      /**
       * Format: password
       * @description Mot de passe actuel. **Obligatoire en session complète**, non demandé à l'état
       *     `PASSWORD_CHANGE` (voir l'opération `changePassword`). Jamais journalisé.
       */
      currentPassword?: string;
      /**
       * Format: password
       * @description Soumis à la politique (`GET /v1/auth/password-policy`). Jamais journalisé.
       */
      newPassword: string;
    };
    /**
     * PasswordPolicyRuleCode
     * @description Règle de la politique de mot de passe. Liste extensible (règle inconnue : ne pas
     *     l'afficher). Les règles en vigueur et leurs paramètres sont en attente de décision
     *     (SEC-A1) : `MIN_LENGTH {min}`, `MAX_LENGTH {max}`, `NOT_COMPROMISED` (absent des listes
     *     de mots de passe compromis), `NOT_IDENTIFIER` (différent de l'identifiant),
     *     `DIFFERENT_FROM_CURRENT`.
     * @enum {string}
     */
    PasswordPolicyRuleCode:
      'MIN_LENGTH' | 'MAX_LENGTH' | 'NOT_COMPROMISED' | 'NOT_IDENTIFIER' | 'DIFFERENT_FROM_CURRENT';
    /** PasswordPolicyRule */
    PasswordPolicyRule: {
      code: components['schemas']['PasswordPolicyRuleCode'];
      params?: {
        [key: string]: number;
      };
    };
    /** PasswordPolicy */
    PasswordPolicy: {
      rules: components['schemas']['PasswordPolicyRule'][];
    };
    /** PasswordForgotRequest */
    PasswordForgotRequest: {
      /** @description E-mail ou téléphone. Jamais renvoyé ni journalisé en clair. */
      identifier: string;
    };
    /**
     * PasswordResetRequest
     * @description Forme provisoire (mécanisme « lien », en attente de décision).
     */
    PasswordResetRequest: {
      /** @description Jeton à usage unique lu dans le fragment de l'URL du lien. Jamais journalisé. */
      token: string;
      /** Format: password */
      newPassword: string;
    };
    /**
     * Role
     * @description Rôle de l'utilisateur (spec 01 §2). Le web ne sert que ADMIN, COMPANY et MERCHANT.
     * @enum {string}
     */
    Role: 'ADMIN' | 'COMPANY' | 'MERCHANT' | 'EMPLOYEE' | 'FAMILY_MEMBER';
    /**
     * SubRole
     * @description Sous-rôle (spec 01 §2, cahier ENT-10, spec 07 §2). ADMIN : `SUPER_ADMIN`, `FINANCE`,
     *     `SUPPORT`, `COMPLIANCE`. COMPANY : `OWNER`, `MANAGER`, `ACCOUNTANT`, `READ_ONLY`.
     *     MERCHANT : `OWNER`, `CASHIER`, `ACCOUNTANT`. Aucun pour EMPLOYEE et FAMILY_MEMBER.
     *     Liste extensible. Le client ne déduit **aucun droit** du sous-rôle : il utilise
     *     `permissions`.
     * @enum {string}
     */
    SubRole:
      | 'SUPER_ADMIN'
      | 'FINANCE'
      | 'SUPPORT'
      | 'COMPLIANCE'
      | 'OWNER'
      | 'MANAGER'
      | 'ACCOUNTANT'
      | 'READ_ONLY'
      | 'CASHIER';
    /**
     * Permission
     * @description Permission calculée par le serveur, sous la forme `module.action` (ex. `payments.collect`).
     *     Les noms sont publiés espace par espace avec chaque contrat de module ; la matrice rôle ×
     *     sous-rôle est en attente de décision pour les cases que les documents ne fixent pas.
     *     Une permission inconnue du client est ignorée.
     */
    Permission: string;
    /** Me */
    Me: {
      id: components['schemas']['Uuid'];
      /** @description Prénom et initiale du nom (aucune autre donnée personnelle). */
      displayName: string;
      role: components['schemas']['Role'];
      subRole: components['schemas']['SubRole'] | null;
      permissions: components['schemas']['Permission'][];
      /**
       * @description Tenant unique du compte (RG-2.5), fixé à la connexion : entreprise ou commerçant.
       *     `null` pour un administrateur.
       */
      tenant: components['schemas']['TenantSummary'] | null;
      mfa: {
        required: boolean;
        enrolled: boolean;
      };
    };
    /** TenantSummary */
    TenantSummary: {
      id: components['schemas']['Uuid'];
      /** @description Raison sociale de l'entreprise ou nom du commerce. */
      label: string;
    };
    /**
     * AccountStatus
     * @description Compte (cahier §8) — En attente KYC, Validé, Rejeté, Suspendu.
     * @enum {string}
     */
    AccountStatus: 'PENDING_KYC' | 'APPROVED' | 'REJECTED' | 'SUSPENDED';
    /**
     * OrderStatus
     * @description Commande — Créée, Payée, Rapprochée, Créditée, Annulée.
     * @enum {string}
     */
    OrderStatus: 'CREATED' | 'PAID' | 'RECONCILED' | 'CREDITED' | 'CANCELLED';
    /**
     * PaymentStatus
     * @description Paiement — Initié, Confirmé, Réglé, Refusé, En litige (cahier v4.1 §8).
     * @enum {string}
     */
    PaymentStatus: 'INITIATED' | 'CONFIRMED' | 'SETTLED' | 'REFUSED' | 'DISPUTED';
    /**
     * PayoutRequestStatus
     * @description Demande de virement — Demandée, Contrôlée, Envoyée, Exécutée, Rejetée.
     * @enum {string}
     */
    PayoutRequestStatus: 'REQUESTED' | 'CHECKED' | 'SENT' | 'EXECUTED' | 'REJECTED';
    /**
     * ApprovalStatus
     * @description Approbation (double validation, approbateur ≠ initiateur) — En attente, Approuvée, Refusée.
     * @enum {string}
     */
    ApprovalStatus: 'PENDING' | 'APPROVED' | 'REJECTED';
    /**
     * ProblemCode
     * @description Code d'erreur machine stable (catalogue en section 4). Liste extensible.
     * @enum {string}
     */
    ProblemCode:
      | 'VALIDATION_FAILED'
      | 'IDEMPOTENCY_KEY_REQUIRED'
      | 'IDEMPOTENCY_KEY_INVALID'
      | 'UNAUTHENTICATED'
      | 'SESSION_EXPIRED'
      | 'INVALID_CREDENTIALS'
      | 'MFA_CODE_INVALID'
      | 'MFA_CHALLENGE_EXPIRED'
      | 'PASSWORD_CHANGE_REQUIRED'
      | 'MFA_ENROLLMENT_REQUIRED'
      | 'FORBIDDEN'
      | 'CSRF_TOKEN_INVALID'
      | 'NOT_FOUND'
      | 'IDEMPOTENCY_REQUEST_IN_PROGRESS'
      | 'RESOURCE_STATE_CONFLICT'
      | 'PAYLOAD_TOO_LARGE'
      | 'UNSUPPORTED_MEDIA_TYPE'
      | 'IDEMPOTENCY_KEY_REUSED'
      | 'INSUFFICIENT_FUNDS'
      | 'LIMIT_EXCEEDED'
      | 'PAYMENT_DECLINED'
      | 'RATE_LIMITED'
      | 'INTERNAL_ERROR'
      | 'SERVICE_UNAVAILABLE';
    /**
     * ProblemBase
     * @description Membres communs de toute erreur RFC 9457 (`application/problem+json`). Schéma de base
     *     **non utilisé seul** : il est composé par `Problem` (sans détails) et par les variantes
     *     typées `*Problem`, chacune **fermée** par `unevaluatedProperties: false`. Les membres RFC
     *     `detail` et `instance` ne sont jamais envoyés. Aucun texte destiné à l'utilisateur : le
     *     client traduit `messageKey`.
     */
    ProblemBase: {
      /**
       * Format: uri
       * @description URN stable dérivée du code, ex. `urn:flexipay:problem:insufficient-funds`.
       */
      type: string;
      /** @description Libellé technique anglais fixe par code. Jamais affiché. */
      title: string;
      /** @description Statut HTTP, identique à celui de la réponse. */
      status: number;
      code: components['schemas']['ProblemCode'];
      /** @description Clé i18n du message (`errors.<codeEnCamelCase>`). */
      messageKey: string;
      /**
       * Format: uuid
       * @description Identifiant de corrélation, identique à l'en-tête `X-Request-Id`.
       */
      requestId: string;
    };
    /**
     * Problem
     * @description Erreur **sans détails** (aucun membre `details`, aucun membre supplémentaire). Seules les
     *     variantes typées (`ValidationProblem`, `InsufficientFundsProblem`, `LimitExceededProblem`,
     *     `RateLimitedProblem`, `IdempotencyInProgressProblem`, `ServiceUnavailableProblem`)
     *     déclarent un `details`, avec un schéma fermé.
     */
    Problem: components['schemas']['ProblemBase'];
    /**
     * FieldErrorCode
     * @description Motif d'invalidité d'un champ. Liste extensible.
     * @enum {string}
     */
    FieldErrorCode:
      | 'REQUIRED'
      | 'INVALID_TYPE'
      | 'INVALID_FORMAT'
      | 'INVALID_ENUM'
      | 'NOT_INTEGER'
      | 'TOO_SMALL'
      | 'TOO_BIG'
      | 'TOO_SHORT'
      | 'TOO_LONG'
      | 'UNKNOWN_FIELD'
      | 'INVALID_CURSOR'
      | 'CURRENT_PASSWORD_INVALID'
      | 'PASSWORD_POLICY_VIOLATION';
    /** FieldError */
    FieldError: {
      /** @enum {string} */
      in: 'body' | 'query' | 'path' | 'header';
      /** @description JSON Pointer (RFC 6901) pour `body`, ex. `/amountMillimes` ; nom du paramètre sinon. */
      pointer: string;
      code: components['schemas']['FieldErrorCode'];
      /** @description Clé i18n, ex. `errors.field.tooSmall`. */
      messageKey: string;
      /** @description Paramètres de la règle (ex. `{"min": 1}`). Jamais la valeur saisie. */
      params?: {
        [key: string]: number | string;
      };
    };
    /** ValidationProblem */
    ValidationProblem: components['schemas']['ProblemBase'] & {
      /** @constant */
      code?: 'VALIDATION_FAILED';
      details: {
        fields: components['schemas']['FieldError'][];
      };
    };
    /**
     * InsufficientFundsProblem
     * @description Solde insuffisant (E7). Code réservé au **payeur** (le commerçant reçoit
     *     `PAYMENT_DECLINED`). Employé titulaire du wallet : `details.missingMillimes` toujours
     *     présent. Membre famille (refus dû au solde de l'employé) : **aucun** `details`, aucun
     *     montant. `details` est donc facultatif dans le schéma. Jamais de solde disponible ni de
     *     montant requis.
     */
    InsufficientFundsProblem: components['schemas']['ProblemBase'] & {
      /** @constant */
      code?: 'INSUFFICIENT_FUNDS';
      details?: {
        missingMillimes: components['schemas']['PositiveAmountMillimes'];
      };
    };
    /**
     * LimitType
     * @description Plafond atteint (RG-4, spec 02 §5). Liste extensible.
     * @enum {string}
     */
    LimitType: 'TRANSACTION' | 'DAILY' | 'MONTHLY' | 'FAMILY_MEMBER';
    /**
     * LimitExceededProblem
     * @description Plafond dépassé (E8, E16). Même règle d'exposition que `INSUFFICIENT_FUNDS` : réservé au
     *     payeur ; le commerçant reçoit `PAYMENT_DECLINED`. Membre famille : `limitType`
     *     `FAMILY_MEMBER` et `remainingMillimes` = reste de **sa propre limite**, jamais un montant
     *     lié au solde ou aux plafonds de l'employé.
     */
    LimitExceededProblem: components['schemas']['ProblemBase'] & {
      /** @constant */
      code?: 'LIMIT_EXCEEDED';
      details?: {
        limitType: components['schemas']['LimitType'];
        remainingMillimes: components['schemas']['AmountMillimes'];
      };
    };
    /** RetryAfterDetails */
    RetryAfterDetails: {
      retryAfterSeconds: number;
    };
    /** RateLimitedProblem */
    RateLimitedProblem: components['schemas']['ProblemBase'] & {
      /** @constant */
      code?: 'RATE_LIMITED';
      details: components['schemas']['RetryAfterDetails'];
    };
    /** IdempotencyInProgressProblem */
    IdempotencyInProgressProblem: components['schemas']['ProblemBase'] & {
      /** @constant */
      code?: 'IDEMPOTENCY_REQUEST_IN_PROGRESS';
      details: components['schemas']['RetryAfterDetails'];
    };
    /** ServiceUnavailableProblem */
    ServiceUnavailableProblem: components['schemas']['ProblemBase'] & {
      /** @constant */
      code?: 'SERVICE_UNAVAILABLE';
      details?: components['schemas']['RetryAfterDetails'];
    };
  };
  responses: {
    /**
     * @description Session ouverte, renouvelée ou passée à l'état suivant (§10) : cookies posés (web),
     *     identifiant de session et `csrfToken` renouvelés, `nextStep` = état courant.
     */
    SessionEstablished: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        'Cache-Control': components['headers']['Cache-Control-No-Store'];
        'Set-Cookie': components['headers']['Set-Cookie-Session'];
        [name: string]: unknown;
      };
      content: {
        /**
         * @example {
         *       "nextStep": "NONE",
         *       "csrfToken": "3q2-7wEAAAB0ZXN0LWNzcmYtdG9rZW4tZXhhbXBsZQ"
         *     }
         */
        'application/json': components['schemas']['SessionResult'];
      };
    };
    /** @description Requête invalide (validation, ou en-tête d'idempotence absent ou mal formé). */
    BadRequest: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        [name: string]: unknown;
      };
      content: {
        'application/problem+json':
          components['schemas']['ValidationProblem'] | components['schemas']['Problem'];
      };
    };
    /** @description Non authentifié, session expirée, identifiants ou code MFA refusés (message générique). */
    Unauthorized: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        'WWW-Authenticate': components['headers']['WWW-Authenticate'];
        [name: string]: unknown;
      };
      content: {
        'application/problem+json': components['schemas']['Problem'];
      };
    };
    /** @description Rôle insuffisant, mot de passe temporaire à changer, MFA à enrôler, ou jeton CSRF invalide. */
    Forbidden: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        [name: string]: unknown;
      };
      content: {
        'application/problem+json': components['schemas']['Problem'];
      };
    };
    /** @description Ressource introuvable **ou appartenant à un autre tenant** (indiscernables). */
    NotFound: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        [name: string]: unknown;
      };
      content: {
        /**
         * @example {
         *       "type": "urn:flexipay:problem:not-found",
         *       "title": "Not found",
         *       "status": 404,
         *       "code": "NOT_FOUND",
         *       "messageKey": "errors.notFound",
         *       "requestId": "0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21"
         *     }
         */
        'application/problem+json': components['schemas']['Problem'];
      };
    };
    /** @description Requête idempotente encore en cours, ou état de la ressource incompatible. */
    Conflict: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        'Retry-After': components['headers']['Retry-After'];
        [name: string]: unknown;
      };
      content: {
        'application/problem+json':
          components['schemas']['IdempotencyInProgressProblem'] | components['schemas']['Problem'];
      };
    };
    /** @description Corps de requête trop volumineux. */
    PayloadTooLarge: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        [name: string]: unknown;
      };
      content: {
        'application/problem+json': components['schemas']['Problem'];
      };
    };
    /** @description Type de contenu non pris en charge (seul `application/json` est accepté). */
    UnsupportedMediaType: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        [name: string]: unknown;
      };
      content: {
        'application/problem+json': components['schemas']['Problem'];
      };
    };
    /**
     * @description Refus métier d'une opération financière, **sans aucune écriture au ledger** : solde
     *     insuffisant ou plafond dépassé (au payeur), paiement refusé sans raison (au commerçant), ou
     *     clé d'idempotence réutilisée avec un contenu différent.
     */
    UnprocessableFinancial: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        [name: string]: unknown;
      };
      content: {
        'application/problem+json':
          | components['schemas']['InsufficientFundsProblem']
          | components['schemas']['LimitExceededProblem']
          | components['schemas']['Problem'];
      };
    };
    /** @description Limite de débit atteinte (par IP, compte ou route). */
    TooManyRequests: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        'Retry-After': components['headers']['Retry-After'];
        'RateLimit-Limit': components['headers']['RateLimit-Limit'];
        'RateLimit-Remaining': components['headers']['RateLimit-Remaining'];
        'RateLimit-Reset': components['headers']['RateLimit-Reset'];
        [name: string]: unknown;
      };
      content: {
        /**
         * @example {
         *       "type": "urn:flexipay:problem:rate-limited",
         *       "title": "Rate limited",
         *       "status": 429,
         *       "code": "RATE_LIMITED",
         *       "messageKey": "errors.rateLimited",
         *       "requestId": "0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21",
         *       "details": {
         *         "retryAfterSeconds": 30
         *       }
         *     }
         */
        'application/problem+json': components['schemas']['RateLimitedProblem'];
      };
    };
    /** @description Erreur interne générique (aucun détail technique exposé). */
    InternalError: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        [name: string]: unknown;
      };
      content: {
        /**
         * @example {
         *       "type": "urn:flexipay:problem:internal-error",
         *       "title": "Internal error",
         *       "status": 500,
         *       "code": "INTERNAL_ERROR",
         *       "messageKey": "errors.internal",
         *       "requestId": "0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21"
         *     }
         */
        'application/problem+json': components['schemas']['Problem'];
      };
    };
    /** @description Service temporairement indisponible. */
    ServiceUnavailable: {
      headers: {
        'X-Request-Id': components['headers']['X-Request-Id'];
        'Retry-After': components['headers']['Retry-After'];
        [name: string]: unknown;
      };
      content: {
        /**
         * @example {
         *       "type": "urn:flexipay:problem:service-unavailable",
         *       "title": "Service unavailable",
         *       "status": 503,
         *       "code": "SERVICE_UNAVAILABLE",
         *       "messageKey": "errors.serviceUnavailable",
         *       "requestId": "0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21"
         *     }
         */
        'application/problem+json': components['schemas']['ServiceUnavailableProblem'];
      };
    };
  };
  parameters: {
    /**
     * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
     *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
     *     Voir la section 5 de la description.
     * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
     */
    IdempotencyKey: string;
    /** @description Nombre maximal d'éléments par page. */
    Limit: number;
    /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
    Cursor: string;
    /**
     * @description Champ de tri autorisé par l'endpoint (liste blanche), préfixe `-` pour l'ordre
     *     décroissant. Défaut : `-createdAt`.
     */
    Sort: string;
    /** @description Borne basse incluse de la période (UTC). */
    CreatedFrom: components['schemas']['Timestamp'];
    /** @description Borne haute exclue de la période (UTC). */
    CreatedTo: components['schemas']['Timestamp'];
    /**
     * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
     *     chaque changement de filtre.
     */
    WithCount: boolean;
    /**
     * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
     *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
     *     contrat mobile (non cassant).
     */
    ClientChannel: 'web';
    /** @description Langue des notifications et documents générés. Les erreurs restent des clés i18n. */
    AcceptLanguage: 'fr' | 'ar' | 'en';
  };
  requestBodies: never;
  headers: {
    /** @description Identifiant de corrélation généré par le serveur, repris dans `Problem.requestId`. */
    'X-Request-Id': string;
    /** @description Les réponses de l'API ne sont jamais mises en cache. */
    'Cache-Control-No-Store': 'no-store';
    /** @description Quota de requêtes de la politique la plus restrictive applicable (IP, compte, route). */
    'RateLimit-Limit': number;
    /** @description Requêtes restantes dans la fenêtre courante. */
    'RateLimit-Remaining': number;
    /** @description Secondes avant la réinitialisation de la fenêtre. */
    'RateLimit-Reset': number;
    /** @description Délai en secondes avant de réessayer. */
    'Retry-After': number;
    /** @description Présent avec la valeur `true` quand la réponse est le rejeu d'une requête déjà traitée. */
    'Idempotent-Replayed': 'true';
    /** @description Pour le schéma bearer : `Bearer error="invalid_token"`, sans autre information. */
    'WWW-Authenticate': string;
    /**
     * @description Web uniquement. Cookies de session (§6) : `__Host-fp_at` (jeton d'accès, `Path=/`) et
     *     `__Secure-fp_rt` (jeton de rafraîchissement, `Path=/v1/auth`), tous deux `HttpOnly; Secure;
     *     SameSite=Strict`, sans `Domain`. À la déconnexion ou à l'échec du rafraîchissement : mêmes
     *     noms avec `Max-Age=0`. Jamais lisibles par le JavaScript.
     */
    'Set-Cookie-Session': string;
  };
  pathItems: never;
}
export type $defs = Record<string, never>;
export interface operations {
  getHealth: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description L'API répond. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          'RateLimit-Limit': components['headers']['RateLimit-Limit'];
          'RateLimit-Remaining': components['headers']['RateLimit-Remaining'];
          'RateLimit-Reset': components['headers']['RateLimit-Reset'];
          [name: string]: unknown;
        };
        content: {
          /**
           * @example {
           *       "status": "OK"
           *     }
           */
          'application/json': components['schemas']['HealthStatus'];
        };
      };
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  login: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['LoginRequest'];
      };
    };
    responses: {
      /**
       * @description Mot de passe accepté. `MFA_CHALLENGE` : aucun cookie, défi à résoudre par
       *     `POST /v1/auth/mfa/verify`. Sinon : session (restreinte si `nextStep` ≠ `NONE`), cookies
       *     posés et `csrfToken` dans le corps.
       */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          'Set-Cookie': components['headers']['Set-Cookie-Session'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['LoginResult'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  verifyMfa: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['MfaVerifyRequest'];
      };
    };
    responses: {
      200: components['responses']['SessionEstablished'];
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  startMfaEnrollment: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody?: {
      content: {
        'application/json': components['schemas']['MfaReEnrollmentRequest'];
      };
    };
    responses: {
      /** @description Secret TOTP en attente de confirmation. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MfaEnrollment'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  confirmMfaEnrollment: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['MfaEnrollmentConfirmRequest'];
      };
    };
    responses: {
      200: components['responses']['SessionEstablished'];
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  changePassword: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['PasswordChangeRequest'];
      };
    };
    responses: {
      200: components['responses']['SessionEstablished'];
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  getPasswordPolicy: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Politique en vigueur. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          [name: string]: unknown;
        };
        content: {
          /**
           * @example {
           *       "rules": [
           *         {
           *           "code": "MIN_LENGTH",
           *           "params": {
           *             "min": 12
           *           }
           *         },
           *         {
           *           "code": "MAX_LENGTH",
           *           "params": {
           *             "max": 128
           *           }
           *         },
           *         {
           *           "code": "NOT_COMPROMISED"
           *         },
           *         {
           *           "code": "NOT_IDENTIFIER"
           *         },
           *         {
           *           "code": "DIFFERENT_FROM_CURRENT"
           *         }
           *       ]
           *     }
           */
          'application/json': components['schemas']['PasswordPolicy'];
        };
      };
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  refreshSession: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      200: components['responses']['SessionEstablished'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  logout: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Session révoquée, cookies effacés. */
      204: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Set-Cookie': components['headers']['Set-Cookie-Session'];
          [name: string]: unknown;
        };
        content?: never;
      };
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  requestPasswordReset: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['PasswordForgotRequest'];
      };
    };
    responses: {
      /** @description Demande prise en compte (aucune indication sur l'existence du compte). */
      202: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          [name: string]: unknown;
        };
        content?: never;
      };
      400: components['responses']['BadRequest'];
      403: components['responses']['Forbidden'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  resetPassword: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10).
         *     En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le
         *     contrat mobile (non cassant).
         */
        'X-FlexiPay-Client': components['parameters']['ClientChannel'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['PasswordResetRequest'];
      };
    };
    responses: {
      /** @description Mot de passe réinitialisé ; se reconnecter. */
      204: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          [name: string]: unknown;
        };
        content?: never;
      };
      400: components['responses']['BadRequest'];
      403: components['responses']['Forbidden'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
      503: components['responses']['ServiceUnavailable'];
    };
  };
  getMe: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Profil. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          /**
           * @example {
           *       "id": "0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21",
           *       "displayName": "Salma B.",
           *       "role": "MERCHANT",
           *       "subRole": "CASHIER",
           *       "permissions": [
           *         "payments.collect",
           *         "sales.read"
           *       ],
           *       "tenant": {
           *         "id": "0192f0c4-7b2f-7d4c-8e3f-6c8b2a1f5d32",
           *         "label": "Café du Lac"
           *       },
           *       "mfa": {
           *         "required": true,
           *         "enrolled": true
           *       }
           *     }
           */
          'application/json': components['schemas']['Me'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
}
type FlattenedDeepRequired<T> = {
  [K in keyof T]-?: FlattenedDeepRequired<
    T[K] extends unknown[] | undefined | null ? Extract<T[K], unknown[]>[number] : T[K]
  >;
};
type ReadonlyArray<T> = [Exclude<T, undefined>] extends [unknown[]]
  ? Readonly<Exclude<T, undefined>>
  : Readonly<Exclude<T, undefined>[]>;
export const currencyValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['Currency']
> = ['TND'];
export const directionValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['Direction']
> = ['DEBIT', 'CREDIT'];
export const sessionNextStepValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['SessionNextStep']
> = ['NONE', 'PASSWORD_CHANGE', 'MFA_ENROLL'];
export const passwordPolicyRuleCodeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['PasswordPolicyRuleCode']
> = ['MIN_LENGTH', 'MAX_LENGTH', 'NOT_COMPROMISED', 'NOT_IDENTIFIER', 'DIFFERENT_FROM_CURRENT'];
export const roleValues: ReadonlyArray<FlattenedDeepRequired<components>['schemas']['Role']> = [
  'ADMIN',
  'COMPANY',
  'MERCHANT',
  'EMPLOYEE',
  'FAMILY_MEMBER',
];
export const subRoleValues: ReadonlyArray<FlattenedDeepRequired<components>['schemas']['SubRole']> =
  [
    'SUPER_ADMIN',
    'FINANCE',
    'SUPPORT',
    'COMPLIANCE',
    'OWNER',
    'MANAGER',
    'ACCOUNTANT',
    'READ_ONLY',
    'CASHIER',
  ];
export const accountStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['AccountStatus']
> = ['PENDING_KYC', 'APPROVED', 'REJECTED', 'SUSPENDED'];
export const orderStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['OrderStatus']
> = ['CREATED', 'PAID', 'RECONCILED', 'CREDITED', 'CANCELLED'];
export const paymentStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['PaymentStatus']
> = ['INITIATED', 'CONFIRMED', 'SETTLED', 'REFUSED', 'DISPUTED'];
export const payoutRequestStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['PayoutRequestStatus']
> = ['REQUESTED', 'CHECKED', 'SENT', 'EXECUTED', 'REJECTED'];
export const approvalStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['ApprovalStatus']
> = ['PENDING', 'APPROVED', 'REJECTED'];
export const problemCodeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['ProblemCode']
> = [
  'VALIDATION_FAILED',
  'IDEMPOTENCY_KEY_REQUIRED',
  'IDEMPOTENCY_KEY_INVALID',
  'UNAUTHENTICATED',
  'SESSION_EXPIRED',
  'INVALID_CREDENTIALS',
  'MFA_CODE_INVALID',
  'MFA_CHALLENGE_EXPIRED',
  'PASSWORD_CHANGE_REQUIRED',
  'MFA_ENROLLMENT_REQUIRED',
  'FORBIDDEN',
  'CSRF_TOKEN_INVALID',
  'NOT_FOUND',
  'IDEMPOTENCY_REQUEST_IN_PROGRESS',
  'RESOURCE_STATE_CONFLICT',
  'PAYLOAD_TOO_LARGE',
  'UNSUPPORTED_MEDIA_TYPE',
  'IDEMPOTENCY_KEY_REUSED',
  'INSUFFICIENT_FUNDS',
  'LIMIT_EXCEEDED',
  'PAYMENT_DECLINED',
  'RATE_LIMITED',
  'INTERNAL_ERROR',
  'SERVICE_UNAVAILABLE',
];
export const fieldErrorCodeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['FieldErrorCode']
> = [
  'REQUIRED',
  'INVALID_TYPE',
  'INVALID_FORMAT',
  'INVALID_ENUM',
  'NOT_INTEGER',
  'TOO_SMALL',
  'TOO_BIG',
  'TOO_SHORT',
  'TOO_LONG',
  'UNKNOWN_FIELD',
  'INVALID_CURSOR',
  'CURRENT_PASSWORD_INVALID',
  'PASSWORD_POLICY_VIOLATION',
];
export const fieldErrorInValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['FieldError']['in']
> = ['body', 'query', 'path', 'header'];
export const limitTypeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['LimitType']
> = ['TRANSACTION', 'DAILY', 'MONTHLY', 'FAMILY_MEMBER'];
export const componentsParametersClientChannelValues: ReadonlyArray<
  FlattenedDeepRequired<components>['parameters']['ClientChannel']
> = ['web'];
export const componentsParametersAcceptLanguageValues: ReadonlyArray<
  FlattenedDeepRequired<components>['parameters']['AcceptLanguage']
> = ['fr', 'ar', 'en'];
