# Revue sécurité : BLOC 5 (backend réel, web branché), parties A (comptes et invitations) et B (requêtes pg, renouvellement dans deux onglets)

- **Relecteur** : securite
- **Date** : 2026-10-15
- **Base** : `git diff 3c958c2^..38110ed`, sans 9c44aea (animations). Commits relus : 3c958c2, 88fd5ae, dac48a2, a0149c4, 4494706, 1d44eca, 49350e8, 3a33a6b, 57b56cf, c6c6fb3, bb8a50e, 38110ed.
- **Référentiels** : OWASP ASVS 4.0.3 niveau 2, OWASP API Security Top 10 (2023), `docs/security/exigences-securite.md`.
- **Hors base** : le répertoire de travail contient des corrections **non commitées** en cours (backend, ledger-auditor, frontend : `orders.service.ts`, `payouts.service.ts`, `payments.service.ts`, migration `0010_ledger_once_and_dev_marker`, `client.ts`, `concurrency.test.ts`). Elles ne sont **pas** revues ici ; les numéros de ligne citent l'état de 38110ed.

## Verdict : **BLOQUANT**

3 constats Haute ouverts (B5-S01 PIN, B5-S02 sous-rôles, B5-S03 décisions financières concurrentes). Aucun Critique.

| Sévérité | Nombre | Constats |
|---|---|---|
| Critique | 0 | — |
| Haute | 3 | S01, S02, S03 |
| Moyenne | 9 | S04 à S12 |
| Basse | 9 | S13 à S21 |
| Info | 1 | S22 |

## Réponses aux points prioritaires du lead

1. **Fenêtre de 30 s du refresh (409 sans révocation)** : le verrou est correct (voir S13) : `SELECT … FOR UPDATE` sur la ligne, puis relecture `findUnique` dans une nouvelle instruction en READ COMMITTED : le second onglet attend le COMMIT du premier, puis voit `rotated_at`. Le test 200/409 passe. Le compromis est acceptable **sous conditions** : fenêtre réduite (10 s, comme la grâce du jeton d'accès), événement journalisé, et révocation si le même jeton revient après le nouvel essai du client. Basse.
2. **Rejeu web après 403 `CSRF_TOKEN_INVALID`** : pas de contournement CSRF (le rejeu part de l'origine légitime avec un jeton obtenu par le refresh `SameSite=Strict`) et pas de double exécution : les deux seuls émetteurs du 403 (`http.ts:109`, middleware ; `auth.guard.ts:53`, garde) refusent avant tout traitement, et la copie conserve l'`Idempotency-Key`. Risque résiduel : le rejeu est fait sous **un autre compte** si l'utilisateur a changé de compte dans un autre onglet (S14, Basse).
3. **Garde `OPENING_BALANCE` (0007)** : solide contre l'API (`current_user = 'flexipay_app'` refusé quel que soit le GUC ; l'API ne se connecte jamais avec un autre rôle ; aucune fonction `SECURITY DEFINER`). Faiblesse : échec ouvert sur une base non marquée et marqueur modifiable par `SET` (S17, Basse ; correction en cours dans 0010, non revue).
4. **RLS 0009 et 409 sur e-mail** : la politique limite bien l'insertion (rôle EMPLOYEE, sans sous-rôle ni tenant direct, `must_change_password`, sans MFA, employé de l'entreprise courante). En revanche le 409 et le marquage `ALREADY_EXISTS` de l'aperçu permettent à une entreprise d'**énumérer les comptes de tous les tenants, administrateurs compris**, jusqu'à 5 000 adresses par requête (S04, Moyenne, décision demandée). Le test RLS de 0009 ne prouve pas ce qu'il annonce (S18).
5. **Mots de passe temporaires** : 16 caractères tirés par `crypto.randomInt` (environ 93 bits), Argon2id, 72 h vérifiées à la connexion, session restreinte de 10 min. **Jamais renvoyés** (corps de `createEmployee`, `createMerchant`, `createCompany` vérifiés), **jamais journalisés** (seul le sujet en production ; aucun `logger` ne reçoit le texte), cibles d'audit = noms. Écrits en clair dans `var/outbox` hors production, sans purge (S16, Basse).
6. **Seed** : gardes correctes (`NODE_ENV ≠ production`, URL admin en localhost, base marquée production refusée, base non vide refusée) ; `gitleaks` : aucune fuite sur la plage ; les `gitleaks:allow` portent sur des valeurs de test. Le code MFA de démonstration n'est refusé **que** si `NODE_ENV = production`, et `NODE_ENV` vaut `development` par défaut (S08, Moyenne).
7. **Reste du périmètre** : voir S01 à S22.

## Constats

### [CONSTAT] B5-S01 PIN de paiement : force brute par requêtes simultanées, blocage non progressif
Sévérité : **Haute**
Fichier : `apps/api/src/payments/pin.service.ts:49-83` (appelé par `employee.controller.ts` `confirm` et `pay`, et `change`)
Preuve : la vérification lit l'employé dans une transaction (`findUnique`, l. 50), teste `pinLockedUntil` (l. 54), vérifie le haché (l. 57), puis incrémente `pinFailures` dans une **autre** transaction (l. 65-69). Rien ne réserve la tentative avant la vérification : N requêtes envoyées ensemble lisent toutes « non bloqué » avant que le 3e échec soit commité. Après blocage, le compteur repart à 0 (l. 73) et la durée reste 15 min (pas de progression, contrairement à SEC-A5). Le test `locks the PIN after 3 failures` est séquentiel.
Scénario d'attaque : un tiers dispose de la session web d'un bénéficiaire (poste partagé resté ouvert, cookie volé) mais pas du PIN. Il envoie en rafale 200 `POST /v1/employee/payments` (PIN 0000 à 0199, `Idempotency-Key` distinctes, montant au plafond, code d'un commerçant complice). Chaque rafale teste des dizaines à des centaines de PIN avant que le verrou ne prenne ; quelques rafales espacées de 15 min couvrent les 10 000 valeurs. Gain : paiement chez le complice jusqu'au plafond journalier, chaque jour.
Correctif proposé : réserver la tentative de façon atomique **avant** la vérification : `UPDATE employees SET pin_failures = pin_failures + 1 WHERE id = $1 AND (pin_locked_until IS NULL OR pin_locked_until <= now()) RETURNING pin_failures, pin_hash` (0 ligne = `PIN_LOCKED`), poser le verrou dans la même instruction quand le compteur atteint 3, remettre à 0 seulement sur succès ; ou `SELECT … FOR UPDATE` sur la ligne employé pendant toute la vérification. Blocage progressif (15 min, 30, 60… puis blocage jusqu'à intervention) avec compteur cumulé non remis à zéro par le verrou ; audit de chaque échec. Test : 20 requêtes simultanées avec un mauvais PIN ⇒ au plus 3 `PIN_INVALID`, le reste `PIN_LOCKED`.
Exigence : SEC-A5 / ASVS 2.2.1, 11.1.4 / API4:2023

### [CONSTAT] B5-S02 Permissions de sous-rôle calculées mais jamais appliquées par le serveur
Sévérité : **Haute**
Fichier : `apps/api/src/auth/auth.service.ts:40-61` (calcul) ; `apps/api/src/company/company.controller.ts:57-197` (seul `@Roles('COMPANY')`) ; aucun contrôle de `subRole` dans `src/` hors `permissionsOf`
Preuve : `permissionsOf('COMPANY', 'MANAGER')` = `['employees.manage', 'credits.allocate']`, publié par `GET /v1/me` ; or `POST /v1/company/orders`, `GET /v1/company/invoices`, `GET /v1/company/funding-account` et `GET /v1/company/dashboard` ne vérifient que le rôle. Le contrat (`openapi.yaml`, schéma `Permission`) promet : « le web masque ce qui n'est pas permis, le serveur refuse (`403 FORBIDDEN`) ». Le seed crée un tel compte (`premiere@flexipay.test`, `MANAGER`).
Scénario d'attaque : un gestionnaire RH (`MANAGER`) appelle directement `POST /v1/company/orders` avec une `Idempotency-Key` : il engage une commande de crédits au nom de l'entreprise (facture émise à la confirmation) et lit les factures, réservées au propriétaire. Contournement d'autorisation au niveau fonction.
Correctif proposé : décorateur `@Permissions('orders.create')` lu par le garde global, alimenté par la même fonction `permissionsOf` (une seule source) ; l'appliquer à chaque route (commandes, devis, factures, compte de financement, tableau de bord si financier). Test par route : `MANAGER` ⇒ 403. Côté commerçant et administrateur, la matrice actuelle donne tout à chaque sous-rôle : cohérent aujourd'hui, à reprendre quand la matrice sera tranchée.
Exigence : SEC-Z2 / ASVS 4.1.3, 4.2.1 / API5:2023

### [CONSTAT] B5-S03 Décisions financières concurrentes sans verrou de ligne (double crédit, virement exécuté et remboursé)
Sévérité : **Haute** (suivi conjoint avec ledger-auditor, tests C1 à C6)
Fichier : `apps/api/src/orders/orders.service.ts:169-173` et `:497-547` (`validate`) ; `apps/api/src/payouts/payouts.service.ts:548` (`approve`) et `:581` (`reject`) ; `:277-289` (`request`, devis) ; `apps/api/src/admin/admin.service.ts:466-509` (`approve`/`reject` d'une approbation)
Preuve : l'état est lu par `findUnique` sans `FOR UPDATE`, puis le traitement (écriture ledger comprise) s'exécute et l'état est mis à jour sans condition (`update where: { id }`). Deux requêtes portant des `Idempotency-Key` différentes passent toutes les deux. Le compte `BANK_ESCROW` n'est pas `nonNegative` : rien n'arrête un second `ORDER_VALIDATED`. Aucune unicité sur `ledger_transactions.reference`. Exécution réelle : `concurrency.test.ts` (non versionné, ledger-auditor) échoue sur 38110ed pour C2 (« approuve et rejette un virement » ⇒ `[200, 200]` au lieu de `[200, 409]`) et C3 ; C1 (double validation) passe sur un essai (fenêtre étroite), la course reste ouverte à la lecture du code.
Scénario d'attaque : deux administrateurs traitent la même file ; l'un valide une commande de 9 000 TND (sous le seuil des quatre yeux) pendant que l'autre la valide aussi : le portefeuille de l'entreprise est crédité deux fois pour un seul virement reçu (création de monnaie). Pour un virement commerçant : un administrateur approuve (mise en lot, exécution J+2) pendant qu'un autre rejette (contre-passation, solde rendu) : le commerçant est payé **et** recrédité. Un administrateur complice d'une entreprise peut provoquer la course volontairement.
Correctif proposé : `SELECT … FOR UPDATE` sur la ligne métier (commande, demande de virement, devis, approbation) en tête de chaque transition, avant toute écriture ; transitions conditionnelles (`updateMany where: { id, status: 'AWAITING_VALIDATION' }` ⇒ 409 si 0 ligne) ; filet en base (unicité `(type, reference)` des écritures non contre-passées, en cours dans 0010). Tests de concurrence C1 à C6 versionnés et verts. **Revérification nécessaire** quand les corrections en cours seront commitées.
Exigence : CLAUDE.md règle 4 / SEC-P3, SEC-Z5 / ASVS 1.11.3, 11.1.6

### [CONSTAT] B5-S04 Énumération des comptes de tous les tenants par une entreprise (409 et `ALREADY_EXISTS`)
Sévérité : **Moyenne**
Fichier : `apps/api/src/company/company.service.ts:286-293` et `:326-327` (aperçu, `emailsInUse` en portée SYSTEM), `:278` + `apps/api/src/auth/invitation.service.ts:87-89` (409 à la création unitaire)
Preuve : l'aperçu d'import confronte jusqu'à 5 001 adresses à **toute** la table `users` et marque `ALREADY_EXISTS` ; la création unitaire renvoie 409 pour un e-mail utilisé par n'importe quel compte. Le test `accounts.test.ts:171-188` le démontre avec l'adresse d'un **administrateur**. Ni limite dédiée, ni audit de l'aperçu.
Scénario d'attaque : un utilisateur entreprise (même `MANAGER`) colle 5 000 adresses candidates (`prenom.nom@flexipay.tn`, adresses des commerçants concurrents) dans l'aperçu, 600 fois par minute : il obtient la liste des comptes FlexiPay existants, y compris administrateurs, puis cible l'hameçonnage ou le bourrage d'identifiants. Variante : il « réserve » des adresses (squat) qui ne pourront plus servir à un vrai compte (409 pour l'administrateur qui crée le commerçant).
Correctif proposé : dans l'aperçu, ne signaler que les doublons **de l'entreprise** ; pour une adresse déjà prise ailleurs, ligne acceptée en aperçu puis, à la confirmation, employé créé sans compte (ou écarté) avec un motif générique « invitation impossible pour cette adresse » sans dire pourquoi, et message au titulaire existant (« quelqu'un a tenté de vous inscrire ») ; même logique pour `POST /v1/company/employees` (201 générique, pas de 409 révélateur). Limite par entreprise sur l'aperçu et la création ; audit de l'aperçu (nombre de lignes). **[DÉCISION] demandée** : le comportement actuel (409, `ALREADY_EXISTS` visible) vient du `[LIVRÉ]` A ; le cahier ne tranche pas.
Exigence : SEC-W5 / ASVS 2.2.1 (anti-énumération), 4.1.1 / API3:2023

### [CONSTAT] B5-S05 Déni de service par l'import de salariés (Argon2id en masse, aperçus en mémoire sans plafond, invitations en masse)
Sévérité : **Moyenne** (point aussi relevé par qualite, B1)
Fichier : `apps/api/src/auth/invitation.service.ts:52-63` (`Promise.all` de `hashSecret`) ; `apps/api/src/company/company.service.ts:66-69`, `:335-339` (Map d'aperçus), `:355-410` (confirmation)
Preuve : une confirmation de 5 000 lignes lance 5 000 hachages Argon2id (19 MiB, t=2) sur le pool libuv (4 fils) : environ 38 s mesurées par qualite, pendant lesquelles chaque connexion et chaque vérification de PIN attend. La Map `previews` accepte un aperçu de 1,1 MiB par requête, sans plafond par entreprise, conservé 30 min. Chaque import envoie 5 000 invitations.
Scénario d'attaque : un compte entreprise enchaîne aperçus (5 000 adresses fictives) et confirmations : connexions et paiements de toute la plateforme bloqués au pic de midi ; mémoire du processus saturée par les aperçus ; coût et réputation d'envoi grillés par les invitations.
Correctif proposé : création en masse sans hachage synchrone : compte créé avec un jeton d'invitation à usage unique (aléatoire, haché SHA-256, 72 h) au lieu d'un mot de passe temporaire haché, ou file BullMQ à concurrence bornée ; plafond d'aperçus par entreprise (1 actif) et stockage partagé borné ; limite d'imports par heure et par entreprise ; envoi des invitations par file avec débit plafonné.
Exigence : SEC-W2 / ASVS 11.1.4, 12.1.1 / API4:2023

### [CONSTAT] B5-S06 Code de réinitialisation par SMS (6 chiffres) sans limite d'essais par jeton ni par compte
Sévérité : **Moyenne**
Fichier : `apps/api/src/auth/auth.service.ts:512-534` ; `apps/api/src/common/http.ts:142-175`
Preuve : `resetPassword` cherche `sha256('otp|' + userId + '|' + otp)` ; aucun compteur d'échecs, le jeton reste valable 10 min ; seule limite : 30 requêtes par minute **par IP** et par route.
Scénario d'attaque : l'attaquant déclenche `password/forgot` pour le numéro d'un bénéficiaire, puis répartit les essais sur 100 IP (3 000 essais/min, 30 000 par fenêtre de 10 min, environ 3 % de réussite par fenêtre) ; il recommence jusqu'au succès. Gain : prise de contrôle du compte (MFA facultative pour les bénéficiaires), donc de l'historique et des données personnelles ; le PIN protège encore le paiement.
Correctif proposé : compteur d'échecs sur le jeton (invalidé après 5 essais) et par compte, sur le même modèle que le verrouillage de connexion ; audit et alerte.
Exigence : SEC-W2 / ASVS 2.5.x, 2.7.x (essais limités sur les codes hors bande)

### [CONSTAT] B5-S07 Le PIN est récupérable à partir de l'empreinte d'idempotence stockée
Sévérité : **Moyenne**
Fichier : `apps/api/src/common/idempotency.service.ts:61-65` (empreinte = SHA-256 de méthode, chemin, query et **corps canonique**) et `:123-134` (stockée dans `idempotency_keys.fingerprint`)
Preuve : pour `POST /v1/employee/payment-requests/{id}/confirm`, le corps est `{"pin":"NNNN"}` ; le chemin est connu par la ligne `payments`. 10 000 SHA-256 suffisent pour retrouver le PIN. Même chose pour `POST /v1/employee/payments` (montant, type et code commerçant connus par la ligne de paiement).
Scénario d'attaque : un lecteur de la base (sauvegarde fuitée, accès DBA, future injection) retrouve en quelques millisecondes le PIN de chaque bénéficiaire ayant payé, ce qui annule le hachage Argon2id du PIN.
Correctif proposé : exclure `pin` (et tout secret) du corps avant l'empreinte, ou calculer l'empreinte en HMAC avec une clé serveur ; purge des clés d'idempotence après leur durée de rejeu.
Exigence : SEC-A5, SEC-D4 / ASVS 2.4.1, 8.3.x

### [CONSTAT] B5-S08 `NODE_ENV` vaut `development` par défaut : code MFA universel, routes de démonstration, boîte d'envoi en clair, pas de HSTS
Sévérité : **Moyenne**
Fichier : `apps/api/src/config/env.ts:11`, `:43-46`, `:62-64` ; `apps/api/src/payments/payments.module.ts:27-30` (lit `process.env.NODE_ENV` directement) ; `apps/api/src/common/outbox.service.ts:156-169` ; `apps/api/src/common/http.ts:64-66`
Preuve : `NODE_ENV: z.enum([...]).default('development')`. Le refus de `DEMO_FIXED_MFA_CODE` ne porte que sur `production`. `env:init` écrit `DEMO_FIXED_MFA_CODE=123456`.
Scénario d'attaque : un environnement de démonstration ou de préproduction démarré sans `NODE_ENV` et avec un fichier d'environnement copié du poste : `123456` ouvre **tout** compte dont le mot de passe est connu (administrateurs compris), `/__demo/*` est exposé, les mots de passe temporaires et liens de réinitialisation sont écrits en clair sur disque, HSTS absent.
Correctif proposé : `NODE_ENV` obligatoire (sans défaut) ; `DEMO_FIXED_MFA_CODE` accepté seulement si `NODE_ENV === 'development'` **et** une variable explicite `DEMO_MODE=on` ; `payments.module.ts` lit l'environnement validé (`loadEnv`) au lieu de `process.env` ; refus de démarrer si l'API n'écoute pas sur une adresse locale en mode démo.
Exigence : ASVS 14.1.x, 14.3.x (configuration de production sûre par défaut), 2.8.x

### [CONSTAT] B5-S09 RIB et IBAN de financement FlexiPay codés en dur comme valeurs par défaut
Sévérité : **Moyenne**
Fichier : `apps/api/src/config/env.ts:29-42`
Preuve : `FUNDING_RIB` `.default('08006000671234567891')`, `FUNDING_IBAN` `.default('TN5908006000671234567891')`, renvoyés aux entreprises par `GET /v1/company/funding-account`.
Scénario d'attaque : en production, variable oubliée ⇒ les entreprises reçoivent un RIB plausible (code banque 08) qui n'appartient pas à FlexiPay et y virent le montant de leurs commandes. Gain pour le titulaire réel de ce RIB s'il existe ; perte et litige pour FlexiPay. Non vérifié : appartenance réelle de ce numéro (règle SEC-D7 : données synthétiques uniquement).
Correctif proposé : aucune valeur par défaut en production (variables obligatoires, démarrage refusé) ; en développement, une valeur manifestement fictive et invalide pour un virement réel (clé de contrôle fausse, mention « FICTIF »).
Exigence : SEC-D7, SEC-P7 / ASVS 14.1.x

### [CONSTAT] B5-S10 RLS absente sur le ledger, l'audit, les sessions, l'idempotence et les secrets d'authentification ; politique `companies_access` sans rôle
Sévérité : **Moyenne** (défense en profondeur)
Fichier : `apps/api/prisma/migrations/0002_security/migration.sql:15` (droits sur toutes les tables), `:116-119` ; tables sans `ENABLE ROW LEVEL SECURITY` : `ledger_accounts`, `ledger_transactions`, `ledger_entries`, `account_balances`, `credit_lots`, `audit_log`, `idempotency_keys`, `sessions`, `recovery_codes`, `mfa_challenges`, `password_reset_tokens`, `login_failures`
Preuve : `grep "ROW LEVEL" 0001_init` ⇒ aucune ; 0002 n'active la RLS que sur les tables métier. `companies_access` (USING sans `FOR`, donc aussi UPDATE et DELETE) accepte `id = app.company_id` pour **tout** rôle ; or le garde place `companyId` de l'entreprise dans le contexte d'un EMPLOYEE (`auth.guard.ts:76`).
Scénario d'attaque : un futur défaut applicatif (filtre oublié dans une requête du ledger sous `db.user`, comme `ledger.balances` appelé avec un identifiant venu de la requête) expose les soldes, lots et écritures de tous les tenants à un bénéficiaire ou à un commerçant, sans que la base l'en empêche ; un employé dans une transaction utilisateur peut modifier ou supprimer la ligne de son entreprise. SEC-Z3 attend l'isolation par la base, pas seulement par le code.
Correctif proposé : RLS sur `ledger_accounts` (par `owner_type`/`owner_id`), `ledger_entries` et `credit_lots` (via le compte), `account_balances` ; tables d'authentification, `audit_log` et `idempotency_keys` réservées à `app_role() IN ('SYSTEM','ADMIN')` (lecture admin de l'audit) ; `companies_access` limitée à `COMPANY` pour l'écriture et `SELECT` seul pour `EMPLOYEE` ; `FORCE ROW LEVEL SECURITY` (menace DC-5). Tests IDOR avec le rôle `flexipay_app`.
Exigence : SEC-Z3, SEC-Z4 / ASVS 4.1.5, 4.2.1

### [CONSTAT] B5-S11 IBAN et téléphones stockés en clair
Sévérité : **Moyenne** (Must avant lancement)
Fichier : `apps/api/prisma/schema.prisma:233` (`merchants.iban`), `:670` (`payout_requests.iban`) ; colonnes `phone` de `users`, `employees`, `merchants`, `companies`, `contact_messages`
Preuve : colonnes `Char(24)` et `VARCHAR` en clair ; seuls les secrets TOTP sont chiffrés (`encryptSecret`).
Scénario d'attaque : sauvegarde ou réplique exposée : l'attaquant obtient les IBAN de tous les commerçants et les téléphones des salariés (hameçonnage ciblé « FlexiPay », fraude au changement de RIB).
Correctif proposé : chiffrement AES-256-GCM au niveau du champ avec clé gérée (KMS), empreinte HMAC pour la recherche et l'unicité, affichage masqué déjà en place.
Exigence : SEC-D2 / ASVS 6.1.1, 6.2.x

### [CONSTAT] B5-S12 Journal d'audit sans chaînage, sans IP, appareil ni avant/après ; téléchargement des pièces KYC non journalisé
Sévérité : **Moyenne**
Fichier : `apps/api/src/common/audit.service.ts:222-232` (état 38110ed : `record`) ; `apps/api/prisma/migrations/0001_init/migration.sql` (`audit_log` : id, date, acteur, action, cible) ; `apps/api/src/admin/admin.service.ts:754-768` (`kycDocument`)
Preuve : aucune colonne `ip`, `user_agent`/appareil, `before`/`after`, `prev_hash`/`hash` ; la lecture d'une pièce d'identité par un administrateur ne laisse aucune trace ; les approbations de paramétrage n'enregistrent pas l'ancienne valeur.
Scénario d'attaque : un administrateur malveillant consulte en masse les pièces d'identité KYC ou approuve un paramétrage frauduleux : l'enquête ne peut ni dater précisément l'accès par appareil, ni prouver l'intégrité du journal (une ligne insérée par le propriétaire de la base passe inaperçue).
Correctif proposé : colonnes IP, appareil (empreinte de session), avant/après (JSON sans secret), hachage chaîné (`hash = sha256(prev_hash || ligne)`) calculé en base ; audit de `kycDocument` et de `proof` ; contrôle périodique de la chaîne.
Exigence : SEC-L1 / ASVS 7.1.x, 7.3.x

### [CONSTAT] B5-S13 Refresh concurrent : fenêtre de 30 s sans révocation ni trace
Sévérité : **Basse**
Fichier : `apps/api/src/auth/session.service.ts:27`, `:194-226` ; `apps/api/src/auth/auth.service.ts:567-587` ; `apps/web/src/lib/api/client.ts:40-60`
Preuve : verrou correct (voir réponse au point 1). Mais un jeton tourné il y a moins de 30 s reçoit 409 sans révocation ni audit ; le client web réessaie une seule fois après 300 ms **avec le même cookie** s'il n'en a pas reçu de nouveau.
Scénario d'attaque : un voleur du cookie de rafraîchissement l'utilise en premier (il obtient la nouvelle famille) ; le navigateur légitime arrive dans les 30 s : 409, nouvel essai, 409, l'utilisateur est renvoyé à la connexion ; la détection de vol ne se déclenche jamais, le voleur garde la session jusqu'à l'échéance absolue (8 h). Inversement, un voleur qui sonde dans la fenêtre n'est pas détecté.
Correctif proposé : fenêtre ramenée à 10 s (alignée sur la grâce du jeton d'accès) ; audit `auth.refreshConcurrent` ; si le même jeton tourné est présenté une **seconde** fois (le client n'a manifestement pas reçu le nouveau cookie), traiter comme une réutilisation et révoquer la famille ; côté web, après le second 409, ne pas réessayer en boucle.
Exigence : SEC-A3 / ASVS 3.5.x, 3.3.x

### [CONSTAT] B5-S14 Rejeu automatique après 403 CSRF sous un autre compte
Sévérité : **Basse**
Fichier : `apps/web/src/lib/api/client.ts:96-107`
Preuve : après 403 `CSRF_TOKEN_INVALID`, le client renouvelle la session puis rejoue la requête sans vérifier que la session obtenue est celle du même utilisateur.
Scénario d'attaque : sur un poste partagé, l'administrateur A prépare l'approbation d'une demande qu'il a lui-même initiée ; dans un autre onglet, B se connecte. A clique « Approuver » : 403 (jeton de A), refresh avec les cookies de B, rejeu : la demande de A est approuvée **au nom de B** sans action de B. Les quatre yeux sont contournés par erreur ; une allocation ou un paiement peut aussi partir sous le mauvais compte.
Correctif proposé : ne rejouer que si l'utilisateur n'a pas changé (identifiant de l'utilisateur ou de la famille de session renvoyé par le refresh et comparé à celui mémorisé) ; sinon rendre l'erreur et recharger l'espace. (La fuite mémoire des copies en cas d'erreur réseau, où restait le PIN, est en cours de correction, non revue.)
Exigence : ASVS 3.x, 4.1.x (intégrité de l'acteur), SEC-Z5

### [CONSTAT] B5-S15 Énumération par le temps de réponse (connexion et mot de passe oublié)
Sévérité : **Basse**
Fichier : `apps/api/src/auth/auth.service.ts:162-171` (`recordFailure` seulement pour un compte existant), `:472-493` (`forgotPassword` : retour immédiat si compte inconnu, sinon écritures SQL et fichier de boîte d'envoi)
Preuve : le coût Argon2id est égalisé, mais pas les écritures qui suivent.
Scénario d'attaque : mesure statistique du temps de réponse de `password/forgot` pour tester une liste d'adresses ⇒ comptes existants.
Correctif proposé : traitement de `forgotPassword` en tâche asynchrone (réponse 202 avant tout accès base dépendant du compte) ; `recordFailure` décalé hors du chemin de réponse ou appliqué aussi aux identifiants inconnus (compteur sur l'identifiant haché, déjà prévu en S6-01).
Exigence : SEC-W5 / ASVS 2.2.1

### [CONSTAT] B5-S16 Boîte d'envoi locale : secrets en clair sans purge, chemin relatif au répertoire courant, contenu injectable
Sévérité : **Basse**
Fichier : `apps/api/src/common/outbox.service.ts:156-169` ; `apps/api/src/config/env.ts:77` (`resolve(UPLOAD_DIR)` relatif au répertoire courant) ; `apps/api/.gitignore:4` ; `apps/api/src/auth/invitation.service.ts:106-117`
Preuve : mots de passe temporaires et liens de réinitialisation conservés indéfiniment dans `var/outbox` ; `git check-ignore` : `apps/api/var/outbox/x.txt` ignoré, `var/outbox/x.txt` à la racine **non** ignoré (API lancée depuis la racine ⇒ fichiers commis par `git add -A`, gitleaks ne reconnaît pas ces mots de passe). Le nom saisi par l'entreprise et l'adresse choisie par elle sont recopiés dans un message signé FlexiPay.
Scénario d'attaque : (a) commit accidentel de mots de passe temporaires valables 72 h ; (b) une entreprise crée un « salarié » `Votre compte est suspendu, appelez le +216…` avec l'adresse d'une victime : FlexiPay envoie lui-même le texte d'hameçonnage.
Correctif proposé : chemin résolu par rapport au paquet `apps/api` (ou `var/` dans le `.gitignore` racine, à demander au lead) ; purge au démarrage des fichiers de plus de 72 h ; noms d'affichage limités à des lettres, espaces et tirets avant insertion dans un message ; à terme, fournisseur d'envoi avec domaine dédié (SPF/DKIM/DMARC).
Exigence : SEC-D4, SEC-S2 / ASVS 5.2.x, 8.3.x

### [CONSTAT] B5-S17 Garde `OPENING_BALANCE` : échec ouvert sur une base non marquée
Sévérité : **Basse**
Fichier : `apps/api/prisma/migrations/0007_opening_balance_guard/migration.sql:9-11`
Preuve : la condition est `app.environment <> 'production'` : une base de préproduction, de démonstration ou une restauration oubliée sans `ALTER DATABASE … SET app.environment` accepte les écritures d'ouverture du propriétaire avec `app.seed = on` ; le marqueur est un GUC modifiable par tout rôle (`SET app.environment = ''`). Le rôle applicatif reste toujours refusé (testé : `ledger.test.ts:331-351`).
Scénario d'attaque : le seed (ou un opérateur) est lancé par erreur contre une base de préproduction non marquée reliée à de vrais comptes : soldes d'ouverture fictifs créés.
Correctif proposé : échec fermé : exiger `app.environment = 'development'` posé par `db:setup` (correction en cours dans 0010, **non revue**) ; documenter que le marqueur protège contre l'erreur, pas contre un propriétaire malveillant (qui peut supprimer le trigger).
Exigence : SEC-P4 / ASVS 1.14.x

### [CONSTAT] B5-S18 Le test RLS de 0009 ne prouve pas le contrôle d'appartenance de l'employé
Sévérité : **Basse**
Fichier : `apps/api/test/integration/accounts.test.ts:190-209`
Preuve : l'`INSERT` du test n'a pas `must_change_password` (défaut `false`) : il est refusé par la clause `AND must_change_password`, que l'employé appartienne ou non à l'entreprise. Retirer la sous-requête `employee_id IN (…)` de la politique ne ferait pas échouer ce test.
Scénario d'attaque : une régression future de la politique (sous-requête supprimée ou fautive) passerait les tests : une entreprise créerait le compte de connexion d'un salarié d'une autre entreprise et recevrait son mot de passe temporaire.
Correctif proposé : insérer une ligne par ailleurs conforme (`must_change_password = true`, `role = 'EMPLOYEE'`) pour l'employé d'une autre entreprise ⇒ 42501, et la même ligne pour un employé de l'entreprise ⇒ acceptée.
Exigence : SEC-Z3 / ASVS 4.1.x

### [CONSTAT] B5-S19 Code client à 8 chiffres : aucune limite d'échecs par commerçant, collision possible
Sévérité : **Basse** (menace déjà inscrite au modèle, ligne « Code manuel d'encaissement »)
Fichier : `apps/api/src/payments/payments.service.ts:150-167` (`newCode`), `:573-600` (`initiate`) ; index `payment_codes_code_idx` non unique
Preuve : un commerçant peut enchaîner les `POST /v1/merchant/payments` (600/min par IP) ; un code faux répond `PAYMENT_DECLINED` sans compteur ni alerte ; deux codes vivants identiques sont possibles (le plus récent l'emporte).
Scénario d'attaque : un commerçant malveillant balaie l'espace des codes aux heures de pointe : chaque succès consomme le code d'un client inconnu, lui révèle prénom, initiale et matricule masqué, et pousse une demande que le client peut confirmer par erreur.
Correctif proposé : compteur d'échecs par commerçant et par terminal (blocage et alerte antifraude, SEC-L2) ; unicité des codes vivants (index unique partiel ou nouvel essai à la génération).
Exigence : SEC-P1, SEC-L2

### [CONSTAT] B5-S20 Cookie mal encodé : erreur 500 et page d'erreur Express hors production
Sévérité : **Basse**
Fichier : `apps/api/src/common/http.ts:28-40`
Preuve : `decodeURIComponent` lève `URIError` sur `%E0` ; dans `originCheck` (middleware avant Nest) l'erreur part au gestionnaire par défaut d'Express, qui affiche la pile hors `production` (voir S08 pour le défaut de `NODE_ENV`).
Scénario d'attaque : impact limité (le client ne contrôle que ses propres cookies), mais fuite de chemins et de versions dans une page d'erreur si un proxy ou un sous-domaine compromis pose un cookie piégé.
Correctif proposé : `try/catch` autour du décodage (cookie ignoré) ; gestionnaire d'erreurs final qui renvoie un problème RFC 9457 générique.
Exigence : SEC-W5 / ASVS 7.4.1

### [CONSTAT] B5-S21 Courses mineures sur les compteurs d'authentification (TOTP, verrouillage de connexion)
Sévérité : **Basse**
Fichier : `apps/api/src/auth/auth.service.ts:101-145` (vérification du blocage puis incrément dans une autre transaction), `:213-230` (`mfaLastStep` écrit sans comparaison atomique)
Preuve : même schéma que S01 : des rafales simultanées passent le contrôle de blocage avant l'incrément ; deux vérifications simultanées du même code TOTP peuvent toutes deux réussir.
Scénario d'attaque : un attaquant qui connaît le mot de passe envoie des centaines de codes TOTP en même temps sur un défi : plus de 20 essais avant le blocage global (probabilité faible par rafale, mais supérieure au modèle prévu). Rejeu d'un code TOTP intercepté dans la même seconde.
Correctif proposé : réservation atomique de la tentative (comme S01) ; `UPDATE users SET mfa_last_step = $step WHERE id = $1 AND (mfa_last_step IS NULL OR mfa_last_step < $step)` et succès seulement si une ligne est modifiée.
Exigence : ASVS 2.2.1, 2.8.4

### [CONSTAT] B5-S22 Limitation de débit et verrouillage fondés sur l'adresse du socket
Sévérité : **Info** (déploiement)
Fichier : `apps/api/src/common/http.ts:51`, `:142-175` ; `apps/api/src/app.factory.ts:316` (`trust proxy` désactivé)
Preuve : derrière un proxy inverse, tous les clients partagent l'IP du proxy : le plafond « auth » de 30/min devient global et le couple (compte, IP) du verrouillage perd son sens ; la table des compteurs est vidée au-delà de 50 000 entrées (vidage provoquable avec des IPv6 variées).
Correctif proposé : avant tout déploiement, IP client lue d'un en-tête de proxy de confiance explicitement configuré ; compteurs dans Redis ; limite par compte en plus de l'IP (SEC-W2).
Exigence : SEC-W2

## Points vérifiés sans constat

- Garde global : refus par défaut, `@Public()` explicite sur 8 routes (connexion, MFA, refresh, oubli, réinitialisation, politique, contact, santé) ; `@Roles` présent au niveau de chaque contrôleur non public ; états restreints (`PASSWORD_CHANGE`, `MFA_ENROLL`) limités à leurs routes.
- Cookies `__Host-fp_at` (Path=/) et `__Secure-fp_rt` (Path=/v1/auth), HttpOnly, Secure, SameSite=Strict ; jetons de 256 bits stockés hachés ; jeton CSRF = HMAC lié à la ligne de session ; contrôle `Origin` sur méthodes non sûres ; cookie + `Authorization` refusés ensemble ; JSON seul (415) ; CORS sur liste exacte.
- Argon2id (19 MiB, t=2) ; vérification factice pour un identifiant inconnu ; secrets TOTP chiffrés AES-256-GCM ; codes de secours en HMAC ; lien de réinitialisation dans le fragment (`#token=`).
- SQL : uniquement `$queryRaw`/`$executeRaw` en gabarits paramétrés, aucun `Unsafe`, aucun `eval` ; identifiants de chemin validés en UUID ; curseurs signés HMAC.
- Téléversement de preuve : garde avant intercepteur, 5 MiB, type détecté par signature, stockage par clé aléatoire (pas de chemin client), téléchargement en `attachment` + `nosniff` + CSP `default-src 'none'`.
- Erreurs : filtre RFC 9457, journal = identifiant de requête et classe d'erreur seulement ; aucun journal de corps, de PIN, de jeton.
- Idempotence : portée (tenant, utilisateur, clé), empreinte, bail, jeton de clôture vérifié sous `FOR UPDATE`, refus métier enregistrés ; PIN vérifié hors transaction métier (échecs comptés).
- Ledger : append-only par trigger et par droits, partie double différée, verrouillage ordonné des soldes, `OPENING_BALANCE` refusé au rôle applicatif (tests).
- Quatre yeux : commission et paramétrage (initiateur ≠ approbateur), validation de commande au-delà du seuil.
- `gitleaks git --log-opts="3c958c2^..38110ed"` : 13 commits, aucune fuite.

## Vérifications

| Commande | Résultat |
|---|---|
| `pnpm --filter @flexipay/api test:integration` (1er passage, base `flexipay_test`) | 7 fichiers sur 8 verts, 55 tests verts sur 58 ; 3 échecs, tous dans `concurrency.test.ts` **non versionné** (ledger-auditor) : C2 `[200,200]`, C3 « insufficient funds », C6 `[400,400]` |
| idem, 2e passage | 13 échecs dont « Database (not available) does not exist » : base de test recréée en parallèle par un autre agent ; passage non probant |
| `pnpm --filter @flexipay/api test` | 4 fichiers, 19 tests verts |
| `pnpm --filter @flexipay/web exec vitest run test/lib/api-client.test.ts` | 10 tests verts (état du répertoire de travail, client en cours de modification) |
| `gitleaks git --no-banner --log-opts="3c958c2^..38110ed" .` | 13 commits, « no leaks found » |
| `git check-ignore -v var/outbox/x.txt apps/api/var/outbox/x.txt` | seul `apps/api/var/…` est ignoré |
| `pnpm audit --prod` | **refusé** par les permissions de la session (non exécuté) |

## Non vérifié

- `pnpm audit --prod` : commande refusée par les permissions ; dépendances nouvelles du socle (`@node-rs/argon2`, `@prisma/adapter-pg`, `pg`, `multer` via `@nestjs/platform-express`) non auditées en ligne.
- S01 et S21 : non reproduits dynamiquement (écrire un test est hors de mon périmètre) ; constat établi à la lecture du code.
- S03 : C1 (double validation de commande) non reproduit de façon fiable (passe sur un essai) ; C2 reproduit par le test de ledger-auditor. Les corrections en cours (non commitées, migration 0010) ne sont pas revues.
- S09 : appartenance réelle du RIB par défaut inconnue.
- Configuration de production (proxy, TLS, HSTS effectif, gestionnaire de secrets, marquage `app.environment` des bases) : aucun environnement déployé.
- Application web : CSP et pages non relues dans ce lot (hors périmètre de la demande, déjà couvertes en F1/F3) ; mobile : non concerné.
- Base de développement (`flexipay`) : non consultée (consigne : pas de `db:reset` ni `db:seed`).
- Le contenu de `infra/.env` n'a pas été lu (consigne) : valeurs réelles de `NODE_ENV`, `DEMO_FIXED_MFA_CODE`, `FUNDING_*` inconnues.

## Revérification S02 (2026-10-21)

Base : modifications non commitées de `feat/web` (`git diff` + nouveaux fichiers `apps/api/src/common/permissions.ts`, `apps/api/test/integration/permissions.test.ts`, `apps/api/test/unit/route-permissions.test.ts`). `apps/web/**` et `docs/design/**` hors périmètre.

### Verdict S02 : **FERMÉ**

Le serveur applique désormais le sous-rôle sur chaque route. Un constat Moyenne et deux Basse nouveaux (ci-dessous), aucun Critique ni Haute.

### Points vérifiés

| Point | Résultat |
|---|---|
| Refus par défaut, route sans règle | `auth.guard.ts` : `required === undefined` → 403 après `@Roles` ; test unitaire statique sur toutes les routes de tous les `*.controller.ts` (> 90), échoue si une route non publique n'a ni `@Can` ni `@Self` |
| Sous-rôle `null` ou absent de la matrice | `permissionsOf` : `MATRIX[role][subRole ?? 'NONE'] ?? []` → aucun droit (MERCHANT/COMPANY/ADMIN sans sous-rôle, EMPLOYEE avec sous-rôle, ADMIN avec `OWNER`) ; `allows` ne contourne que `SELF` |
| Source du rôle et du sous-rôle | ligne `users` relue par `db.system` à chaque requête (`session.userId`), statut `ACTIVE` exigé ; rien n'est lu de la requête ni du jeton ; `principal.subRole` alimenté par la même ligne |
| Routes oubliées | 9 contrôleurs ; toutes les routes non publiques annotées ; publiques : `health`, `v1/public/*`, routes d'auth explicitement `@Public()` ; `__demo` annoté `@Can('payments.pay')` et non enregistré hors `DEVELOPMENT` ; noms de permission disjoints entre rôles (aucune permission d'un rôle n'ouvre une route d'un autre) |
| Caissier : liste | `merchantPayments` : `createdFrom` borné au début du jour ouvré de Tunis, quelle que soit la période demandée ; `createdTo` ne peut que réduire ; curseur signé à décalage, le filtre s'applique à chaque page ; RLS `merchant_id` inchangée |
| Caissier : détail | `merchantPaymentDetail` → 404 si `createdAt` < début du jour (pas d'oracle 403/404) ; `cancel` ne porte que sur un paiement `INITIATED` (expiré avant la veille) |
| Caissier : IBAN | profil `shop.read` : `maskedIban` uniquement ; virements, créances, règlements, documents, tableau de bord refusés |
| Matrice | conforme à la demande pour Entreprise (Administrateur, RH, Comptable), Commerçant (Gérant, Caissier), Admin (Super-admin seul à demander paramétrage et commission ; Finance : validation, virements, seconde validation ; Support : lecture + messages ; pièces KYC hors Support) ; écarts en S02-c |
| Créateur ≠ validateur | approbations (`admin.service.ts:473`), double validation des commandes (`orders.service.ts:528`) : OK ; virement : demandé par le commerçant, décidé par l'admin. Exception : KYC (S02-a) |

### [CONSTAT] B5-S02-a Le même administrateur crée le commerçant (ouvre son dossier KYC) et valide ce KYC
Sévérité : Moyenne
Fichier : apps/api/src/admin/admin.service.ts:774-783 (`decideKyc` sans contrôle d'auteur) ; apps/api/src/common/permissions.ts:73-80 (COMPLIANCE : `merchants.manage` + `kyc.decide`)
Preuve : `createMerchant`/`createCompany` appellent `openKyc` (dossier `PENDING`, auteur non stocké) ; `decideKyc` ne compare l'acteur à personne. Opérations (et Super-admin) détiennent les deux permissions.
Scénario d'attaque : un admin Opérations malveillant crée un commerçant fictif avec sa propre adresse (il reçoit l'invitation du Gérant), approuve lui-même le KYC sans pièce, saisit son IBAN ; des employés complices « vendent » leurs crédits sur ce commerçant (encaissement contre espèces), les virements sont ensuite approuvés en une seule validation. Un Super-admin seul peut enchaîner création, KYC et approbation du virement. Contraire à la règle de l'utilisateur « celui qui crée une opération ne peut jamais la valider ».
Correctif proposé : nouvelle migration stockant l'auteur du dossier (`kyc_files.opened_by_id`) ; `decideKyc` → 403 si `who.userId` = auteur ; test d'intégration (créer puis approuver avec le même admin → 403, un autre admin → 200). Étendre la même règle à `payouts.decide` si la création du commerçant et l'approbation du virement par la même personne doit être interdite (à trancher).
Exigence : SEC-RBAC (séparation des tâches) / ASVS 4.0 V1.4.1, V11.1.x (logique métier)

### [CONSTAT] B5-S02-b Preuve de test incomplète sur trois chemins du refus par défaut
Sévérité : Basse
Fichier : apps/api/test/integration/permissions.test.ts (fichier entier)
Preuve : aucun cas avec sous-rôle `null` ou hors matrice (ex. MERCHANT sans sous-rôle, ADMIN `OWNER`) ; aucun appel du caissier avec `?createdFrom=` antérieur au jour (seule la liste par défaut est testée) ; le refus à l'exécution d'une route sans règle n'est prouvé que statiquement.
Scénario d'attaque : régression silencieuse (ex. `?? 'OWNER'` réintroduit dans `permissionsOf`, borne `from` retirée) non détectée par la CI ; le code actuel est correct à la lecture.
Correctif proposé : ajouter ces trois cas (dont `GET /v1/merchant/payments?createdFrom=<J-3>` qui ne contient pas l'ancien paiement).
Exigence : ASVS 4.0 V4.1.3, V4.1.5

### [CONSTAT] B5-S02-c Écarts de matrice tranchés par le lead, non confirmés par l'utilisateur
Sévérité : Basse
Fichier : apps/api/src/common/permissions.ts:78-79, 88, 95, 100-108 ; docs/handoff/decisions.md (ligne du 2026-10-21, « à confirmer »)
Preuve : Opérations reçoit `merchants.manage` et `companies.manage` (création de comptes commerçant et entreprise) ; Comptable reçoit `balances.read` (tableau de bord de l'entreprise) ; sous-rôles `READ_ONLY` (entreprise) et `ACCOUNTANT` (commerçant) absents de la demande, dotés de droits de lecture.
Scénario d'attaque : droits plus larges que la demande (création de comptes par Opérations, combinée à S02-a).
Correctif proposé : `[DÉCISION]` du lead auprès de l'utilisateur ; recommandation : retirer la création de comptes à Opérations tant que S02-a n'est pas corrigé.
Exigence : ASVS 4.0 V4.1.3 (moindre privilège)

### Vérifications

| Commande | Résultat |
|---|---|
| `pnpm --filter @flexipay/api test` | 6 fichiers, 22 tests verts |
| `pnpm --filter @flexipay/api test:integration` (base `flexipay_test`) | 10 fichiers, 78 tests verts |

### Non vérifié (S02)

- Le test de couverture qui échoue après retrait d'une règle : non rejoué (constat de `main` repris, lecture du test cohérente).
- Contenu exposé à Support par `platform.read` (détail KYC, preuve de virement de commande, détail des virements) : lecture seule conforme à la demande, minimisation des données non revue.
- `apps/web/**` (masquage côté interface) : hors périmètre.
- Modèle de menaces non mis à jour dans ce passage (mode économe) : la menace « séparation des tâches KYC » (S02-a) est à y ajouter au prochain passage.
