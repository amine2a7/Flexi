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
     * Réponse au défi MFA (code TOTP ou code de secours)
     * @description Route **publique** (le défi tient lieu d'authentification partielle). Corps : `code`
     *     (TOTP RFC 6238 à 6 chiffres, DP n° 23) **ou** `recoveryCode` (code de secours à usage
     *     unique, DP n° 10 : consommé, journalisé et notifié au titulaire). Échecs comptés dans le
     *     compteur de verrouillage de la connexion.
     *     **Anti-rejeu** (WB2-S02) : tolérance de ±1 pas de 30 s ; un code accepté est refusé
     *     (`MFA_CODE_INVALID`) pour ce compte jusqu'à la fin de sa fenêtre de validité.
     *     Erreurs : `401 MFA_CODE_INVALID` (code faux, le défi reste valable jusqu'au verrouillage),
     *     `401 MFA_CHALLENGE_EXPIRED` (défi inconnu, déjà utilisé, expiré ou invalidé par le
     *     verrouillage : retour à la connexion). Journal d'audit : succès et échec.
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
     *     cours ou s'il a expiré, 10 min, DP n° 23). La session devient complète (`nextStep: NONE`),
     *     identifiant de session et `csrfToken` renouvelés. Journal d'audit et notification au
     *     titulaire. **Codes de secours** (SEC-A4, DP n° 10) : 10 nouveaux codes à usage unique,
     *     renvoyés **une seule fois** dans cette réponse (les anciens sont annulés) ; jamais
     *     journalisés, stockés hachés côté serveur ; le client les affiche sans les conserver.
     */
    post: operations['confirmMfaEnrollment'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/auth/mfa/recovery-codes': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Régénère les 10 codes de secours (les anciens sont annulés)
     * @description Session **complète**. Preuve exigée comme pour un ré-enrôlement : `currentPassword` et
     *     `currentCode` (code TOTP ou code de secours encore valable) ; échecs comptés dans le
     *     verrouillage (`CURRENT_PASSWORD_INVALID`, `401 MFA_CODE_INVALID`). Renvoie 10 nouveaux
     *     codes une seule fois (DP n° 10). Journal d'audit et notification au titulaire.
     */
    post: operations['regenerateRecoveryCodes'];
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
     *     paramètres de la règle. Succès : session renouvelée, `nextStep` suivant (§10) ; **toutes
     *     les autres sessions** et familles de jetons de rafraîchissement sont fermées (DP n° 12).
     *     Journal d'audit et notification au titulaire. Jamais de mot de passe dans les journaux ni
     *     les erreurs.
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
     *     Valeurs en vigueur : DP n° 9 (12 à 128 caractères, aucune règle de composition, mots de passe compromis refusés par une liste locale, différent de l'identifiant), comme dans l'exemple.
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
     *     haché. Mécanisme (DP n° 11), choisi **d'après la forme de l'identifiant saisi** (aucun
     *     oracle : le client sait déjà ce qu'il a tapé) :
     *     - **e-mail** : lien à usage unique valable 15 min, jeton dans le fragment de l'URL ; la
     *       page de réinitialisation envoie `{ token, newPassword }` ;
     *     - **téléphone** : code SMS de 6 chiffres, valable 10 min, 5 essais ; la page envoie
     *       `{ identifier, otp, newPassword }`.
     *     Une nouvelle demande annule le lien ou le code précédent. Un mot de passe temporaire
     *     expiré peut être remplacé par ce moyen (DP n° 15). Journal d'audit.
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
     * Réinitialise le mot de passe (lien par e-mail ou code SMS)
     * @description Route **publique** (DP n° 11). Deux formes de corps :
     *     - **lien** `{ token, newPassword }` : le jeton est placé dans le **fragment** de l'URL
     *       (`#token=…`), jamais envoyé au serveur dans l'URL ni journalisé ; la page web le lit et
     *       l'envoie dans le corps. Jeton (WB2-S02) : au moins 128 bits issus d'un générateur
     *       cryptographique, stocké **haché** (SHA-256), usage unique, 15 min, invalidé par une
     *       nouvelle demande ou par un changement de mot de passe. Jeton inconnu, utilisé ou
     *       expiré : `400 VALIDATION_FAILED` (champ `/token`, code `INVALID_FORMAT`), sans
     *       distinguer les cas ;
     *     - **code SMS** `{ identifier, otp, newPassword }` : 6 chiffres, 10 min, 5 essais au plus
     *       (au-delà le code est annulé). Identifiant inconnu, code faux, épuisé ou expiré :
     *       `400 VALIDATION_FAILED` (champ `/otp`, code `INVALID_FORMAT`), même réponse dans tous
     *       les cas.
     *     Politique non respectée : `PASSWORD_POLICY_VIOLATION`. Succès : **toutes** les sessions du
     *     compte sont fermées (DP n° 12), aucune session n'est ouverte (le client renvoie vers la
     *     connexion). La réinitialisation ne désactive **jamais** la MFA. Journal d'audit et
     *     notification au titulaire.
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
  '/v1/merchant/dashboard': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Tableau de bord du commerçant
     * @description Encaissé du jour, créances à régler et prochain règlement (J+2). Aucun solde d'un client.
     */
    get: operations['getMerchantDashboard'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/payments': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Historique des encaissements */
    get: operations['listMerchantPayments'];
    put?: never;
    /**
     * Initier un encaissement par code client (DP n° 17)
     * @description Le commerçant saisit le code à 8 chiffres affiché par le client et le montant. Paiement `INITIATED`,
     *     valable `expiresAt` (60 s, DP n° 8) ; le client confirme sur son téléphone. Limitation de débit par
     *     commerçant et terminal (429 `RATE_LIMITED`, `Retry-After`). Code inconnu, expiré ou déjà utilisé :
     *     `422 PAYMENT_DECLINED` générique, sans révéler si le code existe.
     */
    post: operations['initiateMerchantPayment'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/payments/{paymentId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Détail d'un encaissement (suivi de la confirmation, commission, règlement, historique) */
    get: operations['getMerchantPayment'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/payments/{paymentId}/cancel': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Annuler un encaissement encore « Initié »
     * @description Possible seulement au statut `INITIATED` (DP n° 17). Après confirmation : `409 RESOURCE_STATE_CONFLICT` ;
     *     une annulation passe alors par une demande motivée validée par l'Administrateur.
     */
    post: operations['cancelMerchantPayment'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/receivables': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Créances : paiements confirmés non encore réglés */
    get: operations['listMerchantReceivables'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/payout-quotes': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Simuler une demande de virement (brut → commission → net)
     * @description Calculé par le serveur ; le taux de commission est figé dans `quoteId` jusqu'à `expiresAt` (règle 5).
     */
    post: operations['createPayoutQuote'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/payouts': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Demandes de virement */
    get: operations['listPayoutRequests'];
    put?: never;
    /**
     * Demander un virement à partir d'une simulation
     * @description Simulation expirée ou profil de commission modifié : `409 RESOURCE_STATE_CONFLICT`, refaire la simulation.
     */
    post: operations['createPayoutRequest'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/payouts/{payoutId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Détail d'une demande de virement, avec son historique */
    get: operations['getPayoutRequest'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/settlements': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Règlements reçus et prévus (J+2) */
    get: operations['listMerchantSettlements'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/documents': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Factures de commission, relevés et attestations */
    get: operations['listMerchantDocuments'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/merchant/profile': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Mon commerce : coordonnées, profil de commission, points de vente, équipe */
    get: operations['getMerchantProfile'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/dashboard': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Tableau de bord de l'entreprise */
    get: operations['getCompanyDashboard'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/employees': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Employés */
    get: operations['listEmployees'];
    put?: never;
    /** Créer un employé (mot de passe temporaire envoyé, RG-2.2) */
    post: operations['createEmployee'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/employees/import-previews': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Aperçu d'un import CSV (erreurs et doublons)
     * @description Le serveur analyse le fichier (taille bornée, formules `= + - @` neutralisées) ; rien n'est créé.
     */
    post: operations['previewEmployeeImport'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/employees/imports': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Confirmer un import (lignes valides de l'aperçu) */
    post: operations['confirmEmployeeImport'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/order-quotes': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Récapitulatif d'une commande de crédits (montant, frais, total) */
    post: operations['createCreditOrderQuote'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/orders': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Commandes de crédits */
    get: operations['listCreditOrders'];
    put?: never;
    /** Passer une commande de crédits */
    post: operations['createCreditOrder'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/orders/{orderId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Détail d'une commande de crédits (déclaration, motif, historique) */
    get: operations['getCreditOrder'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/orders/{orderId}/cancel': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Annuler une commande tant qu'aucun virement n'a été déclaré
     * @description Possible en `AWAITING_CONFIRMATION` et en `AWAITING_PAYMENT` sans déclaration en attente.
     *     Sinon `409 RESOURCE_STATE_CONFLICT`.
     */
    post: operations['cancelCreditOrder'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/orders/{orderId}/transfer-declarations': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Déclarer le virement d'une commande (référence, date, montant, capture)
     * @description Possible en `AWAITING_PAYMENT` uniquement (`409 RESOURCE_STATE_CONFLICT` sinon) ; la
     *     commande passe en `AWAITING_VALIDATION`. **Exception à la règle « JSON uniquement »**
     *     (section 8) : corps `multipart/form-data`. La capture est obligatoire : JPG, PNG ou PDF,
     *     5 Mo maximum, type vérifié sur le contenu (signature) et non sur le nom ; au-delà
     *     `413 PAYLOAD_TOO_LARGE`, autre type `415 UNSUPPORTED_MEDIA_TYPE`. Champ invalide :
     *     `400 VALIDATION_FAILED` (`IN_FUTURE` pour une date future).
     */
    post: operations['declareCreditOrderTransfer'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/orders/{orderId}/proof': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Capture du virement déclaré (entreprise)
     * @description Fichier tel que déposé (JPG, PNG ou PDF, 5 Mo maximum), servi avec son type d'origine,
     *     `Content-Disposition: attachment` et `X-Content-Type-Options: nosniff`.
     */
    get: operations['getCreditOrderProof'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/funding-account': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Compte bancaire de FlexiPay à créditer par virement */
    get: operations['getFundingAccount'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/allocations': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Attribuer des crédits à des employés
     * @description Débite le wallet de l'entreprise ; solde insuffisant : `422 INSUFFICIENT_FUNDS`.
     */
    post: operations['allocateCredits'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/company/invoices': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Factures */
    get: operations['listCompanyInvoices'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/dashboard': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Tableau de bord Administrateur */
    get: operations['getAdminDashboard'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/merchants': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Commerçants */
    get: operations['listMerchantAccounts'];
    put?: never;
    /** Créer un commerçant (profil de commission obligatoire) */
    post: operations['createMerchantAccount'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/companies': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Entreprises */
    get: operations['listCompanyAccounts'];
    put?: never;
    /** Créer une entreprise */
    post: operations['createCompanyAccount'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/commission-profiles': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Profils de commission */
    get: operations['listCommissionProfiles'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/commission-profiles/{profileId}/change-requests': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Demander un changement de taux (double validation, règle 12) */
    post: operations['requestCommissionChange'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/approvals': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Demandes en attente de double validation */
    get: operations['listApprovals'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/approvals/{approvalId}/approve': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Approuver (approbateur différent de l'initiateur)
     * @description L'initiateur ne peut pas approuver sa propre demande : `403 FORBIDDEN` (règle 12).
     */
    post: operations['approveApproval'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/approvals/{approvalId}/reject': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Refuser une demande (motif obligatoire) */
    post: operations['rejectApproval'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/credit-orders': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Toutes les commandes de crédits (filtre par statut et par entreprise)
     * @description Tri : les commandes qui attendent une action de l'administrateur
     *     (`AWAITING_CONFIRMATION`, `AWAITING_VALIDATION`) d'abord, puis par date décroissante.
     */
    get: operations['listAdminCreditOrders'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/credit-orders/{orderId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Détail d'une commande de crédits */
    get: operations['getAdminCreditOrder'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/credit-orders/{orderId}/confirm': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Confirmer une commande (AWAITING_CONFIRMATION → AWAITING_PAYMENT) */
    post: operations['confirmCreditOrder'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/credit-orders/{orderId}/refuse': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Refuser une commande avec un motif (AWAITING_CONFIRMATION → REFUSED) */
    post: operations['refuseCreditOrder'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/credit-orders/{orderId}/validate': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Valider le virement reçu et créditer le solde de l'entreprise (AWAITING_VALIDATION → VALIDATED)
     * @description L'administrateur a vérifié l'arrivée des fonds sur le compte de FlexiPay. Les crédits
     *     (`amountMillimes`) sont ajoutés au solde de l'entreprise dans la même transaction.
     *     Double validation (règle 12) : si `requiresSecondValidation`, le premier appel enregistre
     *     `firstValidation` (statut inchangé) ; le second appel, par un **autre** administrateur, valide.
     *     Le même administrateur une seconde fois : `403 FORBIDDEN`.
     */
    post: operations['validateCreditOrderPayment'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/credit-orders/{orderId}/reject-proof': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /**
     * Rejeter le justificatif avec un motif (AWAITING_VALIDATION → AWAITING_PAYMENT)
     * @description L'entreprise voit le motif et peut déclarer de nouveau son virement.
     */
    post: operations['rejectCreditOrderProof'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/credit-orders/{orderId}/proof': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Capture du virement déclaré (administrateur)
     * @description Fichier tel que déposé (JPG, PNG ou PDF, 5 Mo maximum), servi avec son type d'origine,
     *     `Content-Disposition: attachment` et `X-Content-Type-Options: nosniff`.
     */
    get: operations['getAdminCreditOrderProof'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/kyc-files': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Dossiers KYC des commerçants et des entreprises
     * @description Tri — dossiers `PENDING` d'abord, puis par date de dépôt décroissante.
     */
    get: operations['listKycFiles'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/kyc-files/{fileId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Dossier KYC avec ses pièces et son historique */
    get: operations['getKycFile'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/kyc-files/{fileId}/documents/{documentId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Pièce d'un dossier KYC
     * @description Fichier tel que déposé (JPG, PNG ou PDF), servi avec son type d'origine,
     *     `Content-Disposition: attachment` et `X-Content-Type-Options: nosniff`.
     */
    get: operations['getKycDocument'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/kyc-files/{fileId}/approve': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Valider un dossier KYC (le compte devient actif, `APPROVED`) */
    post: operations['approveKycFile'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/kyc-files/{fileId}/reject': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Refuser un dossier KYC avec un motif (le compte reste inactif, `REJECTED`) */
    post: operations['rejectKycFile'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/payout-requests': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /**
     * Demandes de virement des commerçants
     * @description Tri — demandes `REQUESTED` (à contrôler) d'abord, puis par date décroissante.
     */
    get: operations['listAdminPayoutRequests'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/payout-requests/{payoutId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Demande de virement (brut, commission, net, IBAN, historique) */
    get: operations['getAdminPayoutRequest'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/payout-requests/{payoutId}/approve': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Valider une demande de virement (`REQUESTED` → `CHECKED`), ajoutée au prochain lot de règlement */
    post: operations['approveAdminPayoutRequest'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/payout-requests/{payoutId}/reject': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    get?: never;
    put?: never;
    /** Refuser une demande de virement avec un motif (`REQUESTED` → `REJECTED`) */
    post: operations['rejectAdminPayoutRequest'];
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/settlements': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Lots de règlement des commerçants (J+2) */
    get: operations['listSettlementBatches'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/settlements/{batchId}': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Détail d'un lot de règlement (virements validés qui le composent) */
    get: operations['getSettlementBatch'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/transactions': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Transactions globales (paiements chez les commerçants) */
    get: operations['listAdminTransactions'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/audit-logs': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Journal d'audit (lecture seule) */
    get: operations['listAuditLogs'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/v1/admin/settings': {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    /** Paramétrage de la plateforme */
    get: operations['getPlatformSettings'];
    /** Demander une modification du paramétrage (double validation) */
    put: operations['requestPlatformSettingsChange'];
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
     *     résultats (plafond 10 000, DP n° 23).
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
       * @description Délai d'inactivité de la session (DP n° 18 : 900 s). Toute requête authentifiée le
       *     remet à zéro ; avertissement 2 min avant.
       */
      idleTimeoutSeconds: number;
      /**
       * @description Échéance absolue de la session (DP n° 18 : 8 h Entreprise et Commerçant, 4 h
       *     Administrateur ; égale à `restrictedUntil` en session restreinte `PASSWORD_CHANGE`).
       *     Jamais prolongée par le rafraîchissement.
       */
      absoluteExpiresAt: components['schemas']['Timestamp'];
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
       * @description Identifiant opaque du défi, usage unique, valable 5 min (DP n° 23).
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
     * @description Code TOTP (RFC 6238) à 6 chiffres (DP n° 23). Jamais journalisé.
     */
    TotpCode: string;
    /**
     * RecoveryCode
     * @description Code de secours MFA (DP n° 10) : 10 caractères à usage unique, alphabet sans caractère
     *     ambigu (provisoire). Saisie insensible à la casse et aux tirets : le client met en
     *     majuscules et retire espaces et tirets avant l'envoi. Jamais journalisé.
     */
    RecoveryCode: string;
    /**
     * MfaVerifyRequest
     * @description Code TOTP (`code`) **ou** code de secours (`recoveryCode`), jamais les deux.
     */
    MfaVerifyRequest:
      | {
          /** Format: uuid */
          challengeId: string;
          code: components['schemas']['TotpCode'];
        }
      | {
          /** Format: uuid */
          challengeId: string;
          recoveryCode: components['schemas']['RecoveryCode'];
        };
    /**
     * RecoveryCodes
     * @description Les 10 codes de secours, renvoyés une seule fois (DP n° 10). Les précédents sont annulés.
     */
    RecoveryCodes: {
      recoveryCodes: components['schemas']['RecoveryCode'][];
    };
    /**
     * MfaEnrollmentConfirmResult
     * @description Session complète et codes de secours (affichés une seule fois).
     */
    MfaEnrollmentConfirmResult: {
      nextStep: components['schemas']['SessionNextStep'];
      csrfToken: components['schemas']['CsrfToken'];
      idleTimeoutSeconds: number;
      absoluteExpiresAt: components['schemas']['Timestamp'];
      recoveryCodes: components['schemas']['RecoveryCode'][];
    };
    /**
     * MfaCurrentCode
     * @description Code de l'ancien secret TOTP (6 chiffres) ou code de secours encore valable.
     */
    MfaCurrentCode: string;
    /**
     * MfaProofRequest
     * @description Preuve de possession du compte et de la MFA actuelle (session complète).
     */
    MfaProofRequest: {
      /** Format: password */
      currentPassword: string;
      currentCode: components['schemas']['MfaCurrentCode'];
    };
    /**
     * MfaEnrollment
     * @description Secret TOTP en attente de confirmation (10 min, DP n° 23). Affiché une seule fois, jamais
     *     journalisé, jamais conservé par le client après l'écran.
     */
    MfaEnrollment: {
      /**
       * @description URI `otpauth://totp/FlexiPay:<libellé>?secret=…&issuer=FlexiPay&algorithm=SHA1&digits=6&period=30` (DP n° 23),
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
      currentCode?: components['schemas']['MfaCurrentCode'];
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
     *     l'afficher). Règles en vigueur (SEC-A1, DP n° 9) : `MIN_LENGTH {min: 12}`,
     *     `MAX_LENGTH {max: 128}`, `NOT_COMPROMISED` (absent d'une liste locale de mots de passe
     *     compromis), `NOT_IDENTIFIER` (différent de l'identifiant), `DIFFERENT_FROM_CURRENT`.
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
     * @description Lien par e-mail (`token`) ou code SMS (`identifier` + `otp`), DP n° 11.
     */
    PasswordResetRequest:
      | {
          /** @description Jeton à usage unique lu dans le fragment de l'URL du lien. Jamais journalisé. */
          token: string;
          /** Format: password */
          newPassword: string;
        }
      | {
          /** @description Numéro de téléphone saisi à la demande. Jamais renvoyé ni journalisé en clair. */
          identifier: string;
          /** @description Code SMS à 6 chiffres (10 min, 5 essais). Jamais journalisé. */
          otp: string;
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
     * @description Permission calculée par le serveur (DP n° 13), sous la forme `module.action`. Les noms
     *     sont publiés espace par espace (§11 Commerçant) ; les cases de la matrice rôle ×
     *     sous-rôle que les documents ne fixent pas sont soumises à l'utilisateur. Une permission
     *     inconnue du client est ignorée ; le web masque ce qui n'est pas permis, le serveur
     *     refuse (`403 FORBIDDEN`).
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
        /** @description Codes de secours encore utilisables (0 à 10, DP n° 10). */
        recoveryCodesRemaining: number;
      };
    };
    /** TenantSummary */
    TenantSummary: {
      id: components['schemas']['Uuid'];
      /** @description Raison sociale de l'entreprise ou nom du commerce. */
      label: string;
    };
    /**
     * CreditCategory
     * @description Catégorie de crédits. V1 : une seule catégorie, `RESTAURATION` ; le modèle (soldes, commandes,
     *     paiements) porte déjà la catégorie pour en ajouter d'autres sans changement cassant.
     * @enum {string}
     */
    CreditCategory: 'RESTAURATION';
    /**
     * AccountStatus
     * @description Compte (cahier §8) — En attente KYC, Validé, Rejeté, Suspendu. Un compte reste **inactif**
     *     (aucune opération métier) tant que son dossier KYC n'est pas validé (`APPROVED`).
     * @enum {string}
     */
    AccountStatus: 'PENDING_KYC' | 'APPROVED' | 'REJECTED' | 'SUSPENDED';
    /**
     * OrderStatus
     * @description Commande de crédits — En attente de confirmation (par l'administrateur), En attente de
     *     paiement (virement à déclarer par l'entreprise), En attente de validation (virement déclaré,
     *     à vérifier par l'administrateur), Validée (crédits ajoutés au solde), Refusée, Annulée.
     * @enum {string}
     */
    OrderStatus:
      | 'AWAITING_CONFIRMATION'
      | 'AWAITING_PAYMENT'
      | 'AWAITING_VALIDATION'
      | 'VALIDATED'
      | 'REFUSED'
      | 'CANCELLED';
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
     * CreditBatchStatus
     * @description Lot de crédits — Actif, Expiré (glossaire, DP n° 14). Calculé par le serveur en
     *     `Africa/Tunis` (E10) ; le client ne compare jamais une date d'expiration à l'heure locale.
     * @enum {string}
     */
    CreditBatchStatus: 'ACTIVE' | 'EXPIRED';
    /**
     * FraudAlertStatus
     * @description Alerte antifraude — Ouverte, En cours, Close (clôture motivée et journalisée, DP n° 14).
     * @enum {string}
     */
    FraudAlertStatus: 'OPEN' | 'IN_PROGRESS' | 'CLOSED';
    /**
     * PhoneNumber
     * @description Numéro tunisien au format E.164.
     * @example +21698123456
     */
    PhoneNumber: string;
    /**
     * MerchantCategory
     * @description Catégorie du commerce (MVP : Restauration).
     * @enum {string}
     */
    MerchantCategory: 'RESTAURANT' | 'CAFE' | 'GROCERY' | 'BAKERY' | 'FAST_FOOD';
    /**
     * CustomerSummary
     * @description Client vu par le commerçant : prénom, initiale, matricule masqué (COM-04). Jamais de solde.
     */
    CustomerSummary: {
      firstName: string;
      lastInitial: string;
      /** @description Matricule masqué (4 derniers caractères). */
      maskedEmployeeNumber: string;
    };
    /**
     * MerchantPayment
     * @description Encaissement vu par le commerçant.
     */
    MerchantPayment: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['PaymentStatus'];
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      customer: components['schemas']['CustomerSummary'];
      createdAt: components['schemas']['Timestamp'];
      /** @description Fin de validité tant que `INITIATED` ; `null` ensuite. */
      expiresAt: components['schemas']['Timestamp'] | null;
    };
    /**
     * MerchantPaymentDetail
     * @description Encaissement avec sa commission, sa date de règlement et ses étapes.
     */
    MerchantPaymentDetail: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['PaymentStatus'];
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      customer: components['schemas']['CustomerSummary'];
      createdAt: components['schemas']['Timestamp'];
      /** @description Fin de validité tant que `INITIATED` ; `null` ensuite. */
      expiresAt: components['schemas']['Timestamp'] | null;
      category: components['schemas']['CreditCategory'];
      /** @description Taux figé au moment de l'encaissement. */
      commissionRateBps: components['schemas']['RateBps'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      /** @description Date de règlement J+2 (fuseau Africa/Tunis) ; `null` si non encaissé. */
      settlementDate: components['schemas']['CalendarDate'] | null;
      history: components['schemas']['PaymentEvent'][];
    };
    /** PaymentEvent */
    PaymentEvent: {
      status: components['schemas']['PaymentStatus'];
      occurredAt: components['schemas']['Timestamp'];
    };
    /**
     * MerchantPaymentPage
     * @description Liste paginée de MerchantPayment (§7).
     */
    MerchantPaymentPage: {
      data: components['schemas']['MerchantPayment'][];
      page: components['schemas']['PageInfo'];
    };
    /** PaymentInitiateRequest */
    PaymentInitiateRequest: {
      /** @description Code à 8 chiffres affiché par le client (60 s). Jamais journalisé. */
      customerCode: string;
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
    };
    /** MerchantDashboard */
    MerchantDashboard: {
      todayCollectedMillimes: components['schemas']['AmountMillimes'];
      /** Format: int32 */
      todayPaymentsCount: number;
      receivablesMillimes: components['schemas']['AmountMillimes'];
      nextSettlementDate: components['schemas']['CalendarDate'] | null;
      commissionRateBps: components['schemas']['RateBps'];
      recentPayments: components['schemas']['MerchantPayment'][];
      /** @description Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord). */
      monthlyFlows: components['schemas']['MerchantMonthlyFlow'][];
    };
    /** MerchantMonthlyFlow */
    MerchantMonthlyFlow: {
      /** @description Mois (AAAA-MM), fuseau métier Africa/Tunis. */
      month: string;
      /** @description Paiements encaissés (confirmés) sur le mois. */
      collectedMillimes: components['schemas']['AmountMillimes'];
      /** @description Montant net réglé au commerçant sur le mois. */
      settledMillimes: components['schemas']['AmountMillimes'];
    };
    /**
     * Receivable
     * @description Paiement confirmé non encore réglé (statut affiché « En attente de règlement », DP n° 2).
     */
    Receivable: {
      paymentId: components['schemas']['Uuid'];
      reference: string;
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      confirmedAt: components['schemas']['Timestamp'];
      settlementDate: components['schemas']['CalendarDate'];
    };
    /** ReceivablePage */
    ReceivablePage: {
      data: components['schemas']['Receivable'][];
      page: components['schemas']['PageInfo'];
      totalMillimes: components['schemas']['AmountMillimes'];
    };
    /** PayoutQuoteRequest */
    PayoutQuoteRequest: {
      grossMillimes: components['schemas']['PositiveAmountMillimes'];
    };
    /**
     * PayoutQuote
     * @description Simulation calculée par le serveur ; taux figé jusqu'à `expiresAt`.
     */
    PayoutQuote: {
      quoteId: components['schemas']['Uuid'];
      grossMillimes: components['schemas']['PositiveAmountMillimes'];
      commissionRateBps: components['schemas']['RateBps'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      availableMillimes: components['schemas']['AmountMillimes'];
      expiresAt: components['schemas']['Timestamp'];
    };
    /** PayoutRequestCreate */
    PayoutRequestCreate: {
      quoteId: components['schemas']['Uuid'];
    };
    /** PayoutRequest */
    PayoutRequest: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['PayoutRequestStatus'];
      grossMillimes: components['schemas']['PositiveAmountMillimes'];
      commissionRateBps: components['schemas']['RateBps'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      requestedAt: components['schemas']['Timestamp'];
      /** @description RIB masqué (4 derniers chiffres). */
      maskedIban: string;
    };
    /**
     * PayoutRequestDetail
     * @description Demande de virement avec les étapes franchies (du plus ancien au plus récent).
     */
    PayoutRequestDetail: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['PayoutRequestStatus'];
      grossMillimes: components['schemas']['PositiveAmountMillimes'];
      commissionRateBps: components['schemas']['RateBps'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      requestedAt: components['schemas']['Timestamp'];
      /** @description RIB masqué (4 derniers chiffres). */
      maskedIban: string;
      history: components['schemas']['PayoutEvent'][];
    };
    /**
     * PayoutEvent
     * @description Passage de la demande à un statut ; le motif accompagne un rejet.
     */
    PayoutEvent: {
      status: components['schemas']['PayoutRequestStatus'];
      occurredAt: components['schemas']['Timestamp'];
      /** @description Clé i18n d'un motif de rejet automatique. */
      reasonKey?: string;
      /** @description Motif saisi par l'administrateur qui a refusé la demande. */
      reason?: string;
    };
    /**
     * PayoutRequestPage
     * @description Liste paginée de PayoutRequest (§7).
     */
    PayoutRequestPage: {
      data: components['schemas']['PayoutRequest'][];
      page: components['schemas']['PageInfo'];
    };
    /**
     * SettlementStatus
     * @description Règlement J+2 — Prévu, Payé (provisoire).
     * @enum {string}
     */
    SettlementStatus: 'SCHEDULED' | 'PAID';
    /** Settlement */
    Settlement: {
      id: components['schemas']['Uuid'];
      reference: string;
      settlementDate: components['schemas']['CalendarDate'];
      /** Format: int32 */
      paymentsCount: number;
      grossMillimes: components['schemas']['AmountMillimes'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      status: components['schemas']['SettlementStatus'];
    };
    /**
     * SettlementPage
     * @description Liste paginée de Settlement (§7).
     */
    SettlementPage: {
      data: components['schemas']['Settlement'][];
      page: components['schemas']['PageInfo'];
    };
    /**
     * MerchantDocumentType
     * @description Facture de commission, relevé, attestation (COM-08).
     * @enum {string}
     */
    MerchantDocumentType: 'COMMISSION_INVOICE' | 'STATEMENT' | 'CERTIFICATE';
    /** MerchantDocument */
    MerchantDocument: {
      id: components['schemas']['Uuid'];
      type: components['schemas']['MerchantDocumentType'];
      /** @description Mois couvert (AAAA-MM). */
      period: string;
      issuedAt: components['schemas']['Timestamp'];
    };
    /**
     * MerchantDocumentPage
     * @description Liste paginée de MerchantDocument (§7).
     */
    MerchantDocumentPage: {
      data: components['schemas']['MerchantDocument'][];
      page: components['schemas']['PageInfo'];
    };
    /** PointOfSale */
    PointOfSale: {
      id: components['schemas']['Uuid'];
      name: string;
      city: string;
    };
    /** StaffMember */
    StaffMember: {
      id: components['schemas']['Uuid'];
      displayName: string;
      subRole: components['schemas']['SubRole'];
    };
    /** CommissionProfileSummary */
    CommissionProfileSummary: {
      id: components['schemas']['Uuid'];
      name: string;
      rateBps: components['schemas']['RateBps'];
    };
    /** MerchantProfile */
    MerchantProfile: {
      name: string;
      category: components['schemas']['MerchantCategory'];
      city: string;
      address: string;
      phone: components['schemas']['PhoneNumber'];
      maskedIban: string;
      commissionProfile: components['schemas']['CommissionProfileSummary'];
      pointsOfSale: components['schemas']['PointOfSale'][];
      staff: components['schemas']['StaffMember'][];
    };
    /** CompanyDashboard */
    CompanyDashboard: {
      walletBalanceMillimes: components['schemas']['AmountMillimes'];
      /** Format: int32 */
      employeesCount: number;
      /** Format: int32 */
      activeEmployeesCount: number;
      monthAllocatedMillimes: components['schemas']['AmountMillimes'];
      /** Format: int32 */
      pendingOrdersCount: number;
      recentOrders: components['schemas']['CreditOrder'][];
      /** @description Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord). */
      monthlyFlows: components['schemas']['CompanyMonthlyFlow'][];
    };
    /** CompanyMonthlyFlow */
    CompanyMonthlyFlow: {
      /** @description Mois (AAAA-MM), fuseau métier Africa/Tunis. */
      month: string;
      /** @description Crédits ajoutés au solde (commandes validées) sur le mois. */
      creditedMillimes: components['schemas']['AmountMillimes'];
      /** @description Crédits attribués aux employés sur le mois. */
      allocatedMillimes: components['schemas']['AmountMillimes'];
    };
    /**
     * EmployeeStatus
     * @description Employé — Invité (mot de passe temporaire), Actif, Suspendu.
     * @enum {string}
     */
    EmployeeStatus: 'INVITED' | 'ACTIVE' | 'SUSPENDED';
    /** Employee */
    Employee: {
      id: components['schemas']['Uuid'];
      employeeNumber: string;
      firstName: string;
      lastName: string;
      /** Format: email */
      email: string;
      phone: components['schemas']['PhoneNumber'];
      status: components['schemas']['EmployeeStatus'];
      monthAllocatedMillimes: components['schemas']['AmountMillimes'];
    };
    /**
     * EmployeePage
     * @description Liste paginée de Employee (§7).
     */
    EmployeePage: {
      data: components['schemas']['Employee'][];
      page: components['schemas']['PageInfo'];
    };
    /** EmployeeCreate */
    EmployeeCreate: {
      employeeNumber: string;
      firstName: string;
      lastName: string;
      /** Format: email */
      email: string;
      phone: components['schemas']['PhoneNumber'];
    };
    /** EmployeeImportRequest */
    EmployeeImportRequest: {
      /** @description Contenu du fichier CSV (UTF-8, 1 Mo maximum). */
      csv: string;
    };
    /**
     * ImportIssueCode
     * @description Problème d'une ligne d'import.
     * @enum {string}
     */
    ImportIssueCode: 'REQUIRED' | 'INVALID_FORMAT' | 'DUPLICATE_IN_FILE' | 'ALREADY_EXISTS';
    /** ImportIssue */
    ImportIssue: {
      /** @enum {string} */
      field: 'employeeNumber' | 'firstName' | 'lastName' | 'email' | 'phone';
      code: components['schemas']['ImportIssueCode'];
    };
    /** ImportRow */
    ImportRow: {
      /** Format: int32 */
      line: number;
      employeeNumber: string;
      firstName: string;
      lastName: string;
      email: string;
      phone: string;
      issues: components['schemas']['ImportIssue'][];
    };
    /** EmployeeImportPreview */
    EmployeeImportPreview: {
      previewId: components['schemas']['Uuid'];
      rows: components['schemas']['ImportRow'][];
      /** Format: int32 */
      validCount: number;
      /** Format: int32 */
      errorCount: number;
      /** Format: int32 */
      duplicateCount: number;
    };
    /** EmployeeImportConfirm */
    EmployeeImportConfirm: {
      previewId: components['schemas']['Uuid'];
    };
    /** EmployeeImportResult */
    EmployeeImportResult: {
      /** Format: int32 */
      createdCount: number;
    };
    /** CreditOrderQuoteRequest */
    CreditOrderQuoteRequest: {
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
    };
    /**
     * CreditOrderQuote
     * @description Récapitulatif calculé par le serveur.
     */
    CreditOrderQuote: {
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      feeRateBps: components['schemas']['RateBps'];
      feesMillimes: components['schemas']['AmountMillimes'];
      totalMillimes: components['schemas']['PositiveAmountMillimes'];
    };
    /** CreditOrderCreate */
    CreditOrderCreate: {
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      /** @description Catégorie commandée (défaut `RESTAURATION`). */
      category?: components['schemas']['CreditCategory'];
    };
    /** CreditOrder */
    CreditOrder: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['OrderStatus'];
      category: components['schemas']['CreditCategory'];
      companyId: components['schemas']['Uuid'];
      companyName: string;
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      feesMillimes: components['schemas']['AmountMillimes'];
      totalMillimes: components['schemas']['PositiveAmountMillimes'];
      createdAt: components['schemas']['Timestamp'];
      /** @description Référence à indiquer sur le virement. */
      paymentReference: string;
      /** @description Montant du dernier virement déclaré (absent sans déclaration en cours). */
      declaredAmountMillimes?: components['schemas']['PositiveAmountMillimes'];
    };
    /**
     * CreditOrderDetail
     * @description Commande avec sa déclaration de virement, son dernier motif et son historique.
     */
    CreditOrderDetail: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['OrderStatus'];
      category: components['schemas']['CreditCategory'];
      companyId: components['schemas']['Uuid'];
      companyName: string;
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      feesMillimes: components['schemas']['AmountMillimes'];
      totalMillimes: components['schemas']['PositiveAmountMillimes'];
      createdAt: components['schemas']['Timestamp'];
      /** @description Référence à indiquer sur le virement. */
      paymentReference: string;
      /** @description Montant du dernier virement déclaré (absent sans déclaration en cours). */
      declaredAmountMillimes?: components['schemas']['PositiveAmountMillimes'];
      /** @description Dernière déclaration de virement (absente avant la première déclaration). */
      declaration?: components['schemas']['TransferDeclaration'];
      /** @description Motif du refus de la commande (statut REFUSED). */
      refusalReason?: string;
      /** @description Motif du dernier rejet de justificatif, affiché à l'entreprise pour redéclarer. */
      proofRejectionReason?: string;
      /**
       * @description Double validation (règle 12) : vrai quand les crédits dépassent 10 000,000 TND
       *     (`amountMillimes` > 10000000). La validation du paiement exige alors deux administrateurs
       *     différents.
       */
      requiresSecondValidation: boolean;
      /** @description Première validation enregistrée, en attente du second administrateur. */
      firstValidation?: components['schemas']['FirstValidation'];
      history: components['schemas']['CreditOrderEvent'][];
    };
    /**
     * CreditOrderEventAction
     * @enum {string}
     */
    CreditOrderEventAction:
      | 'CREATED'
      | 'CONFIRMED'
      | 'REFUSED'
      | 'CANCELLED'
      | 'TRANSFER_DECLARED'
      | 'PROOF_REJECTED'
      | 'FIRST_VALIDATION'
      | 'VALIDATED';
    /** FirstValidation */
    FirstValidation: {
      actorName: string;
      occurredAt: components['schemas']['Timestamp'];
      /** @description Vrai si l'administrateur connecté a fait cette première validation (il ne peut pas faire la seconde). */
      byMe: boolean;
    };
    /**
     * CreditOrderEvent
     * @description Étape de l'historique d'une commande (qui, quoi, quand).
     */
    CreditOrderEvent: {
      action: components['schemas']['CreditOrderEventAction'];
      occurredAt: components['schemas']['Timestamp'];
      actorName: string;
      actorRole: components['schemas']['Role'];
      reason?: string;
    };
    /** TransferDeclaration */
    TransferDeclaration: {
      transferReference: string;
      transferDate: components['schemas']['CalendarDate'];
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      proof: components['schemas']['TransferProof'];
      declaredAt: components['schemas']['Timestamp'];
    };
    /**
     * TransferProof
     * @description Métadonnées de la capture ; le fichier se lit par la route `…/proof`.
     */
    TransferProof: {
      fileName: string;
      /** @enum {string} */
      contentType: 'image/jpeg' | 'image/png' | 'application/pdf';
      /** Format: int32 */
      sizeBytes: number;
    };
    /**
     * TransferDeclarationForm
     * @description Corps multipart de la déclaration de virement.
     */
    TransferDeclarationForm: {
      transferReference: string;
      /** @description Date du virement, jamais dans le futur. */
      transferDate: components['schemas']['CalendarDate'];
      /** @description Montant viré, entier en millimes. */
      amountMillimes: string;
      /**
       * Format: binary
       * @description Capture du virement (JPG, PNG ou PDF, 5 Mo maximum).
       */
      proof: string;
    };
    /** CreditOrderDecisionReason */
    CreditOrderDecisionReason: {
      reason: string;
    };
    /**
     * FundingBankAccount
     * @description Compte bancaire de FlexiPay sur lequel l'entreprise vire le total de la commande.
     */
    FundingBankAccount: {
      bankName: string;
      holder: string;
      rib: string;
      iban: string;
    };
    /**
     * CreditOrderPage
     * @description Liste paginée de CreditOrder (§7).
     */
    CreditOrderPage: {
      data: components['schemas']['CreditOrder'][];
      page: components['schemas']['PageInfo'];
    };
    /** AllocationLine */
    AllocationLine: {
      employeeId: components['schemas']['Uuid'];
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
    };
    /** AllocationRequest */
    AllocationRequest: {
      allocations: components['schemas']['AllocationLine'][];
    };
    /** AllocationResult */
    AllocationResult: {
      /** Format: int32 */
      allocatedCount: number;
      allocatedMillimes: components['schemas']['PositiveAmountMillimes'];
      walletBalanceMillimes: components['schemas']['AmountMillimes'];
    };
    /**
     * InvoiceStatus
     * @description Facture — Payée, À payer.
     * @enum {string}
     */
    InvoiceStatus: 'PAID' | 'UNPAID';
    /** Invoice */
    Invoice: {
      id: components['schemas']['Uuid'];
      number: string;
      orderReference: string;
      totalMillimes: components['schemas']['PositiveAmountMillimes'];
      issuedAt: components['schemas']['Timestamp'];
      status: components['schemas']['InvoiceStatus'];
    };
    /**
     * InvoicePage
     * @description Liste paginée de Invoice (§7).
     */
    InvoicePage: {
      data: components['schemas']['Invoice'][];
      page: components['schemas']['PageInfo'];
    };
    /** AdminDashboard */
    AdminDashboard: {
      /** Format: int32 */
      merchantsCount: number;
      /** Format: int32 */
      companiesCount: number;
      todayVolumeMillimes: components['schemas']['AmountMillimes'];
      /** Format: int32 */
      pendingApprovalsCount: number;
      /** Format: int32 */
      pendingKycCount: number;
      nextSettlementNetMillimes: components['schemas']['AmountMillimes'];
      /** @description Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord). */
      monthlyFlows: components['schemas']['AdminMonthlyFlow'][];
    };
    /** AdminMonthlyFlow */
    AdminMonthlyFlow: {
      /** @description Mois (AAAA-MM), fuseau métier Africa/Tunis. */
      month: string;
      /** @description Crédits ajoutés aux soldes des entreprises (commandes validées) sur le mois. */
      creditedMillimes: components['schemas']['AmountMillimes'];
      /** @description Paiements confirmés chez les commerçants sur le mois. */
      paymentsMillimes: components['schemas']['AmountMillimes'];
    };
    /** MerchantAccount */
    MerchantAccount: {
      id: components['schemas']['Uuid'];
      name: string;
      category: components['schemas']['MerchantCategory'];
      city: string;
      status: components['schemas']['AccountStatus'];
      commissionProfile: components['schemas']['CommissionProfileSummary'];
      createdAt: components['schemas']['Timestamp'];
    };
    /**
     * MerchantAccountPage
     * @description Liste paginée de MerchantAccount (§7).
     */
    MerchantAccountPage: {
      data: components['schemas']['MerchantAccount'][];
      page: components['schemas']['PageInfo'];
    };
    /** MerchantCreate */
    MerchantCreate: {
      name: string;
      category: components['schemas']['MerchantCategory'];
      city: string;
      phone: components['schemas']['PhoneNumber'];
      /** Format: email */
      email: string;
      /** @description Profil de commission, obligatoire (liste déroulante). */
      commissionProfileId: components['schemas']['Uuid'];
    };
    /** CompanyAccount */
    CompanyAccount: {
      id: components['schemas']['Uuid'];
      name: string;
      city: string;
      status: components['schemas']['AccountStatus'];
      /** Format: int32 */
      employeesCount: number;
      createdAt: components['schemas']['Timestamp'];
    };
    /**
     * CompanyAccountPage
     * @description Liste paginée de CompanyAccount (§7).
     */
    CompanyAccountPage: {
      data: components['schemas']['CompanyAccount'][];
      page: components['schemas']['PageInfo'];
    };
    /** CompanyCreate */
    CompanyCreate: {
      name: string;
      city: string;
      phone: components['schemas']['PhoneNumber'];
      /** Format: email */
      email: string;
    };
    /** CommissionProfile */
    CommissionProfile: {
      id: components['schemas']['Uuid'];
      name: string;
      rateBps: components['schemas']['RateBps'];
      /** Format: int32 */
      merchantsCount: number;
      updatedAt: components['schemas']['Timestamp'];
    };
    /** CommissionProfileList */
    CommissionProfileList: {
      data: components['schemas']['CommissionProfile'][];
    };
    /** CommissionChangeRequest */
    CommissionChangeRequest: {
      newRateBps: components['schemas']['RateBps'];
      reason: string;
    };
    /**
     * ApprovalType
     * @description Opération sensible soumise à double validation (règle 12).
     * @enum {string}
     */
    ApprovalType: 'COMMISSION_RATE_CHANGE' | 'SETTINGS_CHANGE';
    /** Approval */
    Approval: {
      id: components['schemas']['Uuid'];
      type: components['schemas']['ApprovalType'];
      status: components['schemas']['ApprovalStatus'];
      /** @description Libellé de la ressource concernée (profil, paramètre). */
      subject: string;
      oldRateBps?: components['schemas']['RateBps'];
      newRateBps?: components['schemas']['RateBps'];
      reason?: string;
      initiatorName: string;
      /** @description Vrai si la demande vient de l'utilisateur courant (il ne peut pas l'approuver). */
      initiatedByMe: boolean;
      createdAt: components['schemas']['Timestamp'];
    };
    /**
     * ApprovalPage
     * @description Liste paginée de Approval (§7).
     */
    ApprovalPage: {
      data: components['schemas']['Approval'][];
      page: components['schemas']['PageInfo'];
    };
    /** ApprovalRejectRequest */
    ApprovalRejectRequest: {
      reason: string;
    };
    /** SettlementBatch */
    SettlementBatch: {
      id: components['schemas']['Uuid'];
      reference: string;
      settlementDate: components['schemas']['CalendarDate'];
      /** Format: int32 */
      merchantsCount: number;
      grossMillimes: components['schemas']['AmountMillimes'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      status: components['schemas']['SettlementStatus'];
    };
    /** SettlementBatchDetail */
    SettlementBatchDetail: {
      id: components['schemas']['Uuid'];
      reference: string;
      settlementDate: components['schemas']['CalendarDate'];
      /** Format: int32 */
      merchantsCount: number;
      grossMillimes: components['schemas']['AmountMillimes'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      status: components['schemas']['SettlementStatus'];
      /** @description Virements validés qui composent le lot (sommes égales aux totaux du lot). */
      payouts: components['schemas']['AdminPayoutRequest'][];
    };
    /**
     * DecisionReason
     * @description Motif obligatoire d'un refus (visible par le titulaire du compte).
     */
    DecisionReason: {
      reason: string;
    };
    /**
     * KycStatus
     * @enum {string}
     */
    KycStatus: 'PENDING' | 'APPROVED' | 'REJECTED';
    /**
     * KycAccountType
     * @enum {string}
     */
    KycAccountType: 'MERCHANT' | 'COMPANY';
    /**
     * KycDocumentType
     * @description Extrait du registre de commerce, attestation fiscale, pièce d'identité du gérant, RIB.
     * @enum {string}
     */
    KycDocumentType: 'REGISTRY_EXTRACT' | 'TAX_CERTIFICATE' | 'MANAGER_ID' | 'BANK_DETAILS';
    /** KycDocument */
    KycDocument: {
      id: components['schemas']['Uuid'];
      type: components['schemas']['KycDocumentType'];
      fileName: string;
      /** @enum {string} */
      contentType: 'image/jpeg' | 'image/png' | 'application/pdf';
      /** Format: int32 */
      sizeBytes: number;
      uploadedAt: components['schemas']['Timestamp'];
    };
    /** KycEvent */
    KycEvent: {
      /** @enum {string} */
      action: 'SUBMITTED' | 'APPROVED' | 'REJECTED';
      occurredAt: components['schemas']['Timestamp'];
      actorName: string;
      reason?: string;
    };
    /** KycFileSummary */
    KycFileSummary: {
      id: components['schemas']['Uuid'];
      accountType: components['schemas']['KycAccountType'];
      accountId: components['schemas']['Uuid'];
      accountName: string;
      city: string;
      status: components['schemas']['KycStatus'];
      submittedAt: components['schemas']['Timestamp'];
      /** Format: int32 */
      documentsCount: number;
    };
    /** KycFile */
    KycFile: {
      id: components['schemas']['Uuid'];
      accountType: components['schemas']['KycAccountType'];
      accountId: components['schemas']['Uuid'];
      accountName: string;
      city: string;
      status: components['schemas']['KycStatus'];
      submittedAt: components['schemas']['Timestamp'];
      /** Format: int32 */
      documentsCount: number;
      documents: components['schemas']['KycDocument'][];
      rejectionReason?: string;
      history: components['schemas']['KycEvent'][];
    };
    /** KycFilePage */
    KycFilePage: {
      data: components['schemas']['KycFileSummary'][];
      page: components['schemas']['PageInfo'];
    };
    /**
     * AdminPayoutRequest
     * @description Demande de virement vue par l'administrateur (IBAN complet pour le contrôle).
     */
    AdminPayoutRequest: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['PayoutRequestStatus'];
      merchantId: components['schemas']['Uuid'];
      merchantName: string;
      grossMillimes: components['schemas']['PositiveAmountMillimes'];
      commissionRateBps: components['schemas']['RateBps'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      requestedAt: components['schemas']['Timestamp'];
      iban: string;
      /** @description Lot de règlement qui contient le virement validé. */
      batchId?: components['schemas']['Uuid'];
      batchReference?: string;
    };
    /** AdminPayoutRequestDetail */
    AdminPayoutRequestDetail: {
      id: components['schemas']['Uuid'];
      reference: string;
      status: components['schemas']['PayoutRequestStatus'];
      merchantId: components['schemas']['Uuid'];
      merchantName: string;
      grossMillimes: components['schemas']['PositiveAmountMillimes'];
      commissionRateBps: components['schemas']['RateBps'];
      commissionMillimes: components['schemas']['AmountMillimes'];
      netMillimes: components['schemas']['AmountMillimes'];
      requestedAt: components['schemas']['Timestamp'];
      iban: string;
      batchId?: components['schemas']['Uuid'];
      batchReference?: string;
      history: components['schemas']['PayoutEvent'][];
    };
    /** AdminPayoutRequestPage */
    AdminPayoutRequestPage: {
      data: components['schemas']['AdminPayoutRequest'][];
      page: components['schemas']['PageInfo'];
    };
    /** AdminTransaction */
    AdminTransaction: {
      id: components['schemas']['Uuid'];
      reference: string;
      merchantName: string;
      /** @description Entreprise de l'employé qui a payé. */
      companyName: string;
      category: components['schemas']['CreditCategory'];
      amountMillimes: components['schemas']['PositiveAmountMillimes'];
      status: components['schemas']['PaymentStatus'];
      createdAt: components['schemas']['Timestamp'];
    };
    /** AdminTransactionPage */
    AdminTransactionPage: {
      data: components['schemas']['AdminTransaction'][];
      page: components['schemas']['PageInfo'];
    };
    /**
     * SettlementBatchPage
     * @description Liste paginée de SettlementBatch (§7).
     */
    SettlementBatchPage: {
      data: components['schemas']['SettlementBatch'][];
      page: components['schemas']['PageInfo'];
    };
    /** AuditLogEntry */
    AuditLogEntry: {
      id: components['schemas']['Uuid'];
      occurredAt: components['schemas']['Timestamp'];
      actorName: string;
      /** @description Action journalisée (`module.action`). */
      action: string;
      /** @description Libellé de la ressource (aucune donnée sensible). */
      target: string;
    };
    /**
     * AuditLogPage
     * @description Liste paginée de AuditLogEntry (§7).
     */
    AuditLogPage: {
      data: components['schemas']['AuditLogEntry'][];
      page: components['schemas']['PageInfo'];
    };
    /** PlatformSettings */
    PlatformSettings: {
      payoutMinimumMillimes: components['schemas']['AmountMillimes'];
      /** Format: int32 */
      creditValidityMonths: number;
      /** Format: int32 */
      maxFamilyMembers: number;
      orderFeeRateBps: components['schemas']['RateBps'];
    };
    /** PlatformSettingsChange */
    PlatformSettingsChange: {
      settings: components['schemas']['PlatformSettings'];
      reason: string;
    };
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
      | 'PASSWORD_POLICY_VIOLATION'
      | 'IN_FUTURE';
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
         *       "csrfToken": "3q2-7wEAAAB0ZXN0LWNzcmYtdG9rZW4tZXhhbXBsZQ",
         *       "idleTimeoutSeconds": 900,
         *       "absoluteExpiresAt": "2026-10-11T16:30:00.000Z"
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
      /** @description Secret activé, session complète, codes de secours (affichés une seule fois). */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          'Set-Cookie': components['headers']['Set-Cookie-Session'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MfaEnrollmentConfirmResult'];
        };
      };
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
  regenerateRecoveryCodes: {
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
        'application/json': components['schemas']['MfaProofRequest'];
      };
    };
    responses: {
      /** @description Nouveaux codes de secours (affichés une seule fois). */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['RecoveryCodes'];
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
           *         "enrolled": true,
           *         "recoveryCodesRemaining": 10
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
  getMerchantDashboard: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantDashboard'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listMerchantPayments: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut de paiement. */
        status?: components['schemas']['PaymentStatus'];
        /** @description Recherche par nom, référence ou ville (insensible à la casse). Jamais journalisée. */
        q?: string;
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantPaymentPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  initiateMerchantPayment: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
         *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
         *     Voir la section 5 de la description.
         * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
         */
        'Idempotency-Key': components['parameters']['IdempotencyKey'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['PaymentInitiateRequest'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantPayment'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      422: components['responses']['UnprocessableFinancial'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getMerchantPayment: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        paymentId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantPaymentDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  cancelMerchantPayment: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        paymentId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantPayment'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listMerchantReceivables: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['ReceivablePage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  createPayoutQuote: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['PayoutQuoteRequest'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['PayoutQuote'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      422: components['responses']['UnprocessableFinancial'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listPayoutRequests: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut. */
        status?: components['schemas']['PayoutRequestStatus'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['PayoutRequestPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  createPayoutRequest: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
         *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
         *     Voir la section 5 de la description.
         * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
         */
        'Idempotency-Key': components['parameters']['IdempotencyKey'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['PayoutRequestCreate'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['PayoutRequest'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      422: components['responses']['UnprocessableFinancial'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getPayoutRequest: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        payoutId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['PayoutRequestDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listMerchantSettlements: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['SettlementPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listMerchantDocuments: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantDocumentPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getMerchantProfile: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantProfile'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getCompanyDashboard: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CompanyDashboard'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listEmployees: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut. */
        status?: components['schemas']['EmployeeStatus'];
        /** @description Recherche par nom, référence ou ville (insensible à la casse). Jamais journalisée. */
        q?: string;
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['EmployeePage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  createEmployee: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['EmployeeCreate'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['Employee'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  previewEmployeeImport: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['EmployeeImportRequest'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['EmployeeImportPreview'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  confirmEmployeeImport: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['EmployeeImportConfirm'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['EmployeeImportResult'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  createCreditOrderQuote: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['CreditOrderQuoteRequest'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderQuote'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listCreditOrders: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut. */
        status?: components['schemas']['OrderStatus'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  createCreditOrder: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
         *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
         *     Voir la section 5 de la description.
         * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
         */
        'Idempotency-Key': components['parameters']['IdempotencyKey'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['CreditOrderCreate'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrder'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      422: components['responses']['UnprocessableFinancial'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getCreditOrder: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  cancelCreditOrder: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  declareCreditOrderTransfer: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
         *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
         *     Voir la section 5 de la description.
         * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
         */
        'Idempotency-Key': components['parameters']['IdempotencyKey'];
      };
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody: {
      content: {
        'multipart/form-data': components['schemas']['TransferDeclarationForm'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      413: components['responses']['PayloadTooLarge'];
      415: components['responses']['UnsupportedMediaType'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getCreditOrderProof: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Le fichier. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'image/jpeg': string;
          'image/png': string;
          'application/pdf': string;
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getFundingAccount: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['FundingBankAccount'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  allocateCredits: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
         *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
         *     Voir la section 5 de la description.
         * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
         */
        'Idempotency-Key': components['parameters']['IdempotencyKey'];
      };
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['AllocationRequest'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AllocationResult'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      422: components['responses']['UnprocessableFinancial'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listCompanyInvoices: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['InvoicePage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getAdminDashboard: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AdminDashboard'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listMerchantAccounts: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut. */
        status?: components['schemas']['AccountStatus'];
        /** @description Recherche par nom, référence ou ville (insensible à la casse). Jamais journalisée. */
        q?: string;
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantAccountPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  createMerchantAccount: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['MerchantCreate'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['MerchantAccount'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listCompanyAccounts: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut. */
        status?: components['schemas']['AccountStatus'];
        /** @description Recherche par nom, référence ou ville (insensible à la casse). Jamais journalisée. */
        q?: string;
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CompanyAccountPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  createCompanyAccount: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['CompanyCreate'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CompanyAccount'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listCommissionProfiles: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CommissionProfileList'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  requestCommissionChange: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        profileId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['CommissionChangeRequest'];
      };
    };
    responses: {
      /** @description Succès. */
      201: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['Approval'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listApprovals: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut. */
        status?: components['schemas']['ApprovalStatus'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['ApprovalPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  approveApproval: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        approvalId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['Approval'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  rejectApproval: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        approvalId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['ApprovalRejectRequest'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['Approval'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listAdminCreditOrders: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Filtre par statut. */
        status?: components['schemas']['OrderStatus'];
        /** @description Filtre par entreprise. */
        companyId?: components['schemas']['Uuid'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getAdminCreditOrder: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  confirmCreditOrder: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  refuseCreditOrder: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['CreditOrderDecisionReason'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  validateCreditOrderPayment: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
         *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
         *     Voir la section 5 de la description.
         * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
         */
        'Idempotency-Key': components['parameters']['IdempotencyKey'];
      };
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  rejectCreditOrderProof: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['CreditOrderDecisionReason'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['CreditOrderDetail'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getAdminCreditOrderProof: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        orderId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Le fichier. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'image/jpeg': string;
          'image/png': string;
          'application/pdf': string;
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listKycFiles: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Filtre par statut. */
        status?: components['schemas']['KycStatus'];
        /** @description Filtre par type de compte. */
        accountType?: components['schemas']['KycAccountType'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['KycFilePage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getKycFile: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        fileId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['KycFile'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getKycDocument: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        fileId: components['schemas']['Uuid'];
        documentId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Le fichier. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'image/jpeg': string;
          'image/png': string;
          'application/pdf': string;
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  approveKycFile: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        fileId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['KycFile'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  rejectKycFile: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        fileId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['DecisionReason'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['KycFile'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listAdminPayoutRequests: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Filtre par statut. */
        status?: components['schemas']['PayoutRequestStatus'];
        /** @description Recherche par commerçant ou référence (insensible à la casse). Jamais journalisée. */
        q?: string;
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AdminPayoutRequestPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getAdminPayoutRequest: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        payoutId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AdminPayoutRequestDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  approveAdminPayoutRequest: {
    parameters: {
      query?: never;
      header: {
        /**
         * @description Clé d'idempotence, obligatoire sur toute opération financière (`x-financial: true`).
         *     UUID généré une fois par intention de l'utilisateur et réutilisé pour chaque nouvel essai.
         *     Voir la section 5 de la description.
         * @example 0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21
         */
        'Idempotency-Key': components['parameters']['IdempotencyKey'];
      };
      path: {
        payoutId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AdminPayoutRequestDetail'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  rejectAdminPayoutRequest: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        payoutId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['DecisionReason'];
      };
    };
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AdminPayoutRequestDetail'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      409: components['responses']['Conflict'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listSettlementBatches: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['SettlementBatchPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getSettlementBatch: {
    parameters: {
      query?: never;
      header?: never;
      path: {
        batchId: components['schemas']['Uuid'];
      };
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['SettlementBatchDetail'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      404: components['responses']['NotFound'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listAdminTransactions: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Filtre par statut. */
        status?: components['schemas']['PaymentStatus'];
        /** @description Recherche par commerçant, entreprise ou référence (insensible à la casse). Jamais journalisée. */
        q?: string;
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AdminTransactionPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  listAuditLogs: {
    parameters: {
      query?: {
        /** @description Nombre maximal d'éléments par page. */
        limit?: components['parameters']['Limit'];
        /** @description Curseur opaque renvoyé par `page.nextCursor`. Absent pour la première page. */
        cursor?: components['parameters']['Cursor'];
        /**
         * @description Demande le compteur borné `page.count` (§7). À n'envoyer qu'au premier chargement et à
         *     chaque changement de filtre.
         */
        withCount?: components['parameters']['WithCount'];
        /** @description Borne basse incluse de la période (UTC). */
        createdFrom?: components['parameters']['CreatedFrom'];
        /** @description Borne haute exclue de la période (UTC). */
        createdTo?: components['parameters']['CreatedTo'];
        /** @description Recherche par nom, référence ou ville (insensible à la casse). Jamais journalisée. */
        q?: string;
      };
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['AuditLogPage'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  getPlatformSettings: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody?: never;
    responses: {
      /** @description Succès. */
      200: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['PlatformSettings'];
        };
      };
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      429: components['responses']['TooManyRequests'];
      500: components['responses']['InternalError'];
    };
  };
  requestPlatformSettingsChange: {
    parameters: {
      query?: never;
      header?: never;
      path?: never;
      cookie?: never;
    };
    requestBody: {
      content: {
        'application/json': components['schemas']['PlatformSettingsChange'];
      };
    };
    responses: {
      /** @description Demande créée, en attente de double validation. */
      202: {
        headers: {
          'X-Request-Id': components['headers']['X-Request-Id'];
          'Cache-Control': components['headers']['Cache-Control-No-Store'];
          [name: string]: unknown;
        };
        content: {
          'application/json': components['schemas']['Approval'];
        };
      };
      400: components['responses']['BadRequest'];
      401: components['responses']['Unauthorized'];
      403: components['responses']['Forbidden'];
      409: components['responses']['Conflict'];
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
export const creditCategoryValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['CreditCategory']
> = ['RESTAURATION'];
export const accountStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['AccountStatus']
> = ['PENDING_KYC', 'APPROVED', 'REJECTED', 'SUSPENDED'];
export const orderStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['OrderStatus']
> = [
  'AWAITING_CONFIRMATION',
  'AWAITING_PAYMENT',
  'AWAITING_VALIDATION',
  'VALIDATED',
  'REFUSED',
  'CANCELLED',
];
export const paymentStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['PaymentStatus']
> = ['INITIATED', 'CONFIRMED', 'SETTLED', 'REFUSED', 'DISPUTED'];
export const payoutRequestStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['PayoutRequestStatus']
> = ['REQUESTED', 'CHECKED', 'SENT', 'EXECUTED', 'REJECTED'];
export const approvalStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['ApprovalStatus']
> = ['PENDING', 'APPROVED', 'REJECTED'];
export const creditBatchStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['CreditBatchStatus']
> = ['ACTIVE', 'EXPIRED'];
export const fraudAlertStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['FraudAlertStatus']
> = ['OPEN', 'IN_PROGRESS', 'CLOSED'];
export const merchantCategoryValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['MerchantCategory']
> = ['RESTAURANT', 'CAFE', 'GROCERY', 'BAKERY', 'FAST_FOOD'];
export const settlementStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['SettlementStatus']
> = ['SCHEDULED', 'PAID'];
export const merchantDocumentTypeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['MerchantDocumentType']
> = ['COMMISSION_INVOICE', 'STATEMENT', 'CERTIFICATE'];
export const employeeStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['EmployeeStatus']
> = ['INVITED', 'ACTIVE', 'SUSPENDED'];
export const importIssueCodeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['ImportIssueCode']
> = ['REQUIRED', 'INVALID_FORMAT', 'DUPLICATE_IN_FILE', 'ALREADY_EXISTS'];
export const importIssueFieldValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['ImportIssue']['field']
> = ['employeeNumber', 'firstName', 'lastName', 'email', 'phone'];
export const creditOrderEventActionValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['CreditOrderEventAction']
> = [
  'CREATED',
  'CONFIRMED',
  'REFUSED',
  'CANCELLED',
  'TRANSFER_DECLARED',
  'PROOF_REJECTED',
  'FIRST_VALIDATION',
  'VALIDATED',
];
export const transferProofContentTypeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['TransferProof']['contentType']
> = ['image/jpeg', 'image/png', 'application/pdf'];
export const invoiceStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['InvoiceStatus']
> = ['PAID', 'UNPAID'];
export const approvalTypeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['ApprovalType']
> = ['COMMISSION_RATE_CHANGE', 'SETTINGS_CHANGE'];
export const kycStatusValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['KycStatus']
> = ['PENDING', 'APPROVED', 'REJECTED'];
export const kycAccountTypeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['KycAccountType']
> = ['MERCHANT', 'COMPANY'];
export const kycDocumentTypeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['KycDocumentType']
> = ['REGISTRY_EXTRACT', 'TAX_CERTIFICATE', 'MANAGER_ID', 'BANK_DETAILS'];
export const kycDocumentContentTypeValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['KycDocument']['contentType']
> = ['image/jpeg', 'image/png', 'application/pdf'];
export const kycEventActionValues: ReadonlyArray<
  FlattenedDeepRequired<components>['schemas']['KycEvent']['action']
> = ['SUBMITTED', 'APPROVED', 'REJECTED'];
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
  'IN_FUTURE',
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
