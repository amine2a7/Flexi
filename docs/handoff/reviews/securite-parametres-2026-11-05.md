# Revue sécurité – Paramètres en base, annulation d'un paiement confirmé (2026-11-05)

- **Base** : commit `c4ba0ab` (branche `feat/web`), mode économe : fichiers cités par le lead uniquement (+ dépendances directes lues pour vérifier : `idempotency.service.ts`, `db.service.ts#asService`, `disputes.service.ts#open`, `payouts.service.ts#reject`, `ledger.service.ts#post`, `common/http.ts#rateLimit`, `orders.service.ts` diff, test `payments.test.ts` §annulation).
- **Référentiels** : ASVS 4.0.3 niveau 2, API Security Top 10 2023.
- **Verdict : OK** (aucun Critique ni Haute). 2 Moyennes, 6 Basses ouvertes.

## Points vérifiés conformes

| Sujet | Constat |
| --- | --- |
| `GET /v1/public/terms` | `@Public()` explicite, renvoie 6 entiers (cycle, validités, délai d'annulation, minimum de virement, seuil quatre yeux). Aucun RIB/IBAN, aucune donnée personnelle, aucun paramètre de sécurité (PIN, OTP). Limité à 30 req/min/IP (`/v1/public/`). |
| Route `POST /v1/merchant/payments/:id/refund` | `@Can('payments.refund')`, permission du seul Gérant (`MERCHANT.OWNER`) ; Caissier → 403, Comptable sans permission. Tenant : lecture RLS puis `found.merchantId !== who.merchantId` → 404 identique à « inexistant » (pas d'énumération). Testé (caissier 403, autre commerçant 404). |
| Idempotence | `IdempotencyService.run` (portée tenant + utilisateur + clé, empreinte de requête, 422 si réutilisée) ; clé exigée (testé `IDEMPOTENCY_KEY_REQUIRED`), rejeu → même réponse (testé), seconde clé → 409 (testé). |
| Concurrence / double annulation | Verrou des deux comptes (`lockAccounts`, ordre global) puis `SELECT … FOR UPDATE` du paiement, relecture et revérification du statut, `payoutId`, litige, fenêtre. Sérialisé avec `payouts.request` et `disputes.open` par le verrou du portefeuille commerçant pris avant la ligne paiement : pas d'interblocage, pas de double dépense. Solde commerçant revérifié sous verrou. |
| `asService` | Bloc borné (verrous, comptage de litiges, écriture ledger et lots du portefeuille employé) ; le résultat renvoyé au commerçant est `merchantPayment(updated)` (aucune ligne d'un autre tenant). Restauration du rôle en `finally` logique. Voir S-PA-07 (documentation). |
| Ledger | Écriture équilibrée D commerçant / C employé, lots recréés avec l'échéance d'origine (pas de prolongation de validité), contrôle somme des lots = montant, aucun `UPDATE`/`DELETE` ledger. Commission prélevée au virement, donc rien à contre-passer côté commission. |
| Paramètres : validation | `settingsBody` en `z.strictObject` imbriqué, bornes strictes (RIB 20 chiffres, IBAN `TN`+22, PIN 1–5 paliers de 1–1440 min, OTP 1–30 min, invitation 1–30 j, annulation 0–72 h, cycle 1–10 j) doublées par des `CHECK` SQL (0031). |
| Paramètres : quatre yeux | `PUT /settings` = `settings.request` (SUPER_ADMIN) → approbation `SETTINGS_CHANGE`, appliquée par un autre administrateur (`ensureNotAuthor` sous verrou), une seule demande en attente. Le compte de réception FlexiPay est désormais couvert par les quatre yeux (auparavant : configuration serveur). |
| Audit | `settings.apply` = noms des champs modifiés seulement (jamais les valeurs) ; la charge complète reste dans `approvals.payload` (traçable). `payments.cancelConfirmed` journalisé avec la référence. |
| Paliers PIN (`pin.service.ts:81-88`) | SQL paramétré (template Prisma), indices PostgreSQL 1-based corrects (niveau 0 → 1er palier), au-delà du dernier palier → `pin_requires_reauth` + révocation des sessions. Transaction `db.system` (pas d'effet RLS). Si la ligne `platform_settings` manquait : `pin_failures` reste à 3 → réservation impossible → échec fermé. Plafond de tentatives avant reconnexion : 3 × (5 + 1) = 18 au pire. |
| OTP (défi MFA) | Durée lue en base ; échecs comptés par utilisateur (`recordFailure`, verrouillage du compte) ; défi consommé atomiquement. Les jetons de réinitialisation (15 min) et l'OTP SMS (10 min) restent des constantes. |
| Commandes | Seuil quatre yeux et fin de devis figés à la création (`second_validation_required`, `quote_expires_at`) : un changement de paramètre ne rétroagit pas sur une commande en cours. |
| Web | Bouton visible seulement avec `useCan('payments.refund')` et statut `CONFIRMED` (confort ; l'API décide). Confirmation explicite, clé d'idempotence conservée en cas d'exception réseau, régénérée après réponse. Aucune donnée sensible affichée ni stockée. |

## Constats

```
[CONSTAT] S-PA-01 Compte de réception FlexiPay : aucune clé de contrôle ni cohérence RIB/IBAN, valeur de démo en production
Sévérité : Moyenne
Fichier : apps/api/src/admin/admin.controller.ts:59-64 ; apps/api/prisma/migrations/0031_platform_parameters/migration.sql:9-10 ; apps/api/src/admin/admin.service.ts:910-918
Preuve : rib = /^[0-9]{20}$/, iban = /^TN[0-9]{22}$/ saisis séparément ; aucun contrôle mod 97 (grep mod97|isValidIban : 0 résultat) ; défauts '08006000671234567891' / 'TN5908006000671234567891' posés par la migration sur toute base, y compris la production ; l'audit ne garde que « fundingAccount ».
Scénario d'attaque : un super-admin malveillant (ou dont la session est volée) propose un paramétrage où seul l'IBAN change (RIB inchangé, montants identiques) ; l'approbateur Finance, qui voit une demande « Paramétrage de la plateforme » de 20 champs, approuve. Les entreprises qui virent sur l'IBAN affiché envoient les fonds des commandes sur un compte tiers. Variante sans malveillance : une faute de frappe non détectée (pas de clé), ou un déploiement neuf qui affiche le RIB de démo aux entreprises.
Correctif proposé : (1) valider la clé RIB et l'IBAN mod 97, et imposer iban = 'TN59' + rib (ou dériver l'IBAN du RIB) ; (2) pour `fundingAccount`, journaliser avant/après (ce RIB est public pour les clients, pas une donnée personnelle) et afficher le différentiel en évidence à l'approbateur ; (3) pas de défaut en production : refuser la création de commande / l'affichage du compte tant que le compte n'a pas été paramétré (drapeau `funding_configured` ou défaut NULL + garde).
Exigence : ASVS 1.11.3, 7.2.2 (traçabilité avant/après), 11.1.x (intégrité des processus métier) ; règle 12-13 du CLAUDE.md
```

```
[CONSTAT] S-PA-02 Validité du mot de passe temporaire : 7 jours par défaut, jusqu'à 30 jours, contre SEC-A2 (72 h)
Sévérité : Moyenne
Fichier : apps/api/src/auth/invitation.service.ts:13-19 ; apps/api/src/admin/admin.controller.ts:67 ; migration 0031:15,24
Preuve : invitationValidityDays min 1 max 30 ; défaut 7 ; SEC-A2 = « expire à 72 h » ; decisions.md 2026-11-05 (4) marqué « à confirmer par Amine ».
Scénario d'attaque : le mot de passe temporaire part par e-mail en clair. Une boîte compromise, un transfert automatique ou un e-mail lu sur un poste partagé donne la prise du compte (entreprise : commandes, affectation de crédits ; commerçant : virements) pendant 7 à 30 jours au lieu de 3. La MFA obligatoire limite le risque pour ces rôles mais pas l'employé (PIN + appareil).
Correctif proposé : si l'utilisateur confirme 7 jours, mettre à jour SEC-A2 et borner le paramètre à 7 jours (max 7 au lieu de 30, CHECK aligné) ; sinon revenir à 72 h par défaut. [DÉCISION] remontée au lead.
Exigence : SEC-A2 / ASVS 2.3.1
```

```
[CONSTAT] S-PA-03 Seuil interne de double validation publié sans authentification
Sévérité : Basse
Fichier : apps/api/src/platform/settings.service.ts:69
Preuve : curl https://<api>/v1/public/terms → "secondValidationThresholdMillimes": 10000000
Scénario d'attaque : un initié (comptable d'entreprise de connivence avec un administrateur) connaît sans compte le seuil exact et fractionne une commande juste en dessous pour qu'un seul administrateur la valide. Gain limité (la commande reste payée par virement), mais un contrôle interne ne devrait pas être publié.
Correctif proposé : ne publier le seuil que sur une route authentifiée (rôle COMPANY/ADMIN) ou formuler le texte public sans valeur.
Exigence : API3:2023 (exposition excessive) / ASVS 1.4.x
```

```
[CONSTAT] S-PA-04 Contre-passation d'annulation sans lien `reversesId` vers le paiement
Sévérité : Basse
Fichier : apps/api/src/payments/payments.service.ts:709-719
Preuve : ledger.post({ type: 'PAYMENT_CANCELLATION', reference: `${ref}-ANN`, … }) sans reversesId.
Scénario d'attaque : pas d'exploitation directe (le statut du paiement verrouillé empêche une seconde annulation) ; la piste d'audit ledger ne relie la contre-passation à l'opération d'origine que par la référence texte, ce qui affaiblit la détection d'une double contre-passation par réconciliation.
Correctif proposé : renseigner reversesId: payment.transactionId (et, si une contrainte d'unicité sur reverses_id existe ou est ajoutée, elle empêche toute seconde contre-passation). À valider avec ledger-auditor.
Exigence : ASVS 7.2.2 / règle 3 du CLAUDE.md
```

```
[CONSTAT] S-PA-05 Tests manquants sur les chemins de refus de l'annulation
Sévérité : Basse
Fichier : apps/api/test/integration/payments.test.ts:603-675
Preuve : testés : clé absente, rejeu, double annulation séquentielle, Caissier 403, autre commerçant 404, fenêtre dépassée. Non testés : paiement pris dans un virement (409), paiement en litige (409), deux annulations simultanées avec deux clés (une seule réussit), Comptable commerçant (403), paramètre 0 h (annulation désactivée).
Scénario d'attaque : une régression future sur la garde `payoutId`/litige permettrait de reprendre au commerçant des fonds déjà virés ou retenus (solde du portefeuille commerçant négatif évité par le contrôle de solde, mais dette non tracée).
Correctif proposé : ajouter ces 5 cas.
Exigence : ASVS 1.1.x (tests de sécurité) / règle 6 du CLAUDE.md
```

```
[CONSTAT] S-PA-06 Pages publiques rendues serveur : toutes les visites partagent le quota de l'IP du serveur web
Sévérité : Basse
Fichier : apps/web/src/lib/api/platform-terms.ts:31-37 ; apps/api/src/common/http.ts:146-149
Preuve : fetch(`${origin}/v1/public/terms`, { cache: 'no-store' }) à chaque rendu ; quota 30/min par (IP, chemin).
Scénario d'attaque : 31 affichages de l'accueil ou de l'aide par minute (ou un script qui les recharge) épuisent le quota de l'IP du serveur Next : les textes publics affichent « … » pour tous les visiteurs pendant une minute (déni de service léger, sans fuite).
Correctif proposé : mettre en cache côté web (`next: { revalidate: 300 }`) ou exempter l'IP du serveur web via un en-tête signé ; à terme, quota en Redis.
Exigence : API4:2023
```

```
[CONSTAT] S-PA-07 `asService` étendu à des écritures inter-tenants hors de la décision du 2026-11-04
Sévérité : Basse
Fichier : apps/api/src/payments/payments.service.ts:673,677,692-726 ; apps/api/src/common/db.service.ts:35-39
Preuve : le commentaire de asService limite l'usage « au calcul d'une valeur qui ne quitte pas le serveur » ; ici il écrit dans le portefeuille et les lots d'un employé d'un autre tenant.
Scénario d'attaque : aucun aujourd'hui (le tenant du paiement est vérifié avant l'élévation) ; le risque est la banalisation : un futur appel avec un identifiant non vérifié écrirait hors RLS.
Correctif proposé : documenter l'usage (décision ou commentaire de asService), et garder la règle « vérification du tenant avant toute élévation » dans la revue de code.
Exigence : ASVS 4.1.3 / 1.4.x
```

```
[CONSTAT] S-PA-08 Exception localStorage prévue pour `lib/ui/menu-state.ts` (fichier pas encore écrit)
Sévérité : Basse
Fichier : apps/web/test/conventions/source-conventions.test.ts:64-73 ; apps/web/eslint.config.mjs:44,70
Preuve : exception au chemin exact (`lib/ui/menu-state.ts:`), correcte ; le fichier n'existe pas ; la règle ESLint `no-restricted-globals` interdit encore localStorage.
Scénario d'attaque : sur un poste partagé, une clé du type `menu:<userId>` ou `menu:<email>` révèle qui s'est connecté ; une valeur relue sans validation peut casser le rendu (déni local) si elle est altérée.
Correctif proposé : clé fixe sans identifiant ni e-mail (ou hachage non réversible), valeur = liste d'identifiants de catégories validée par Zod à la lecture, aucune donnée métier ; dérogation ESLint limitée à ce seul fichier ; à revoir à la livraison du fichier.
Exigence : SEC-A7 / ASVS 8.2.2
```

## Remarque hors sécurité (qualité, pour information)

- `applySettings` appelle `this.platformSettings()`, qui ouvre une seconde transaction (`db.user`) pendant celle de l'approbation (connexion supplémentaire du pool). Une demande `SETTINGS_CHANGE` en attente créée avant 0031 n'a pas les nouveaux champs : `BigInt(undefined)` → 500 à l'approbation (la demande peut être rejetée).

## Non vérifié

- Écran d'approbation web d'un `SETTINGS_CHANGE` : affiche-t-il le différentiel, notamment du compte de réception (S-PA-01) ? Non lu (mode économe).
- Écran `admin/parametres/page.tsx` (578 lignes modifiées) non lu : seulement l'API est l'autorité.
- `pnpm test`, `pnpm audit --prod`, `gitleaks` non lancés (revue statique, consigne « lis seulement les fichiers cités »).
- RLS de `platform_settings` (lecture par les rôles COMPANY via `db.user` pour `fundingAccount()`) et `FORCE RLS` : non relus.
- `ledger.lockAccounts` : tri global des codes supposé d'après les revues précédentes, non relu ici.
- `spentToday` : prise en compte (ou non) d'un paiement annulé dans le plafond journalier : non vérifié (règle métier, pas une faille).
- Lots recréés avec une échéance déjà passée (crédits expirés entre paiement et annulation) : traitement par le job d'expiration non relu (sujet ledger-auditor).
