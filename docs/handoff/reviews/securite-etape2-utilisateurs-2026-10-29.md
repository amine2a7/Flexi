# Revue sécurité – Étape 2 : gestion des utilisateurs (2026-10-29)

- **Base** : commits `cfa546e` (API) et `034ed96` (web), branche `feat/web`, fichiers listés par `main` uniquement.
- **Règles** : décisions A à D du 2026-10-23, e3 du 2026-10-22 (`docs/handoff/decisions.md` l. 56-59, 62-65).
- **Verdict : OK** (aucun Critique ni Haute). 3 Moyennes à corriger avant la clôture de la phase, 3 Basses.

## Constats

[CONSTAT] S2-01 Course sur le dernier super-admin
Sévérité : Moyenne
Fichier : apps/api/src/users/users.service.ts:196, 206, 361-372 (`db.system` en READ COMMITTED, `db.service.ts:53`)
Preuve : `lockUser` ne verrouille que la ligne **cible** ; `refuseUnsafe` compte ensuite les super-admins actifs sans verrou. Deux transactions concurrentes voient chacune `activeSuperAdmins = 2`.
Scénario d'attaque : deux super-admins A et B (ou un attaquant détenant les deux sessions) envoient au même instant `POST /v1/admin/users/{B}/suspend` (par A) et `POST /v1/admin/users/{A}/suspend` (par B), ou deux rétrogradations croisées `…/role {subRole: FINANCE}`. Les deux passent : plus aucun super-admin actif, plus personne ne peut gérer les rôles ni créer d'administrateur ; reprise seulement par intervention en base.
Correctif proposé : avant le comptage, sérialiser les changements touchant un super-admin : `SELECT id FROM users WHERE role='ADMIN' AND sub_role='SUPER_ADMIN' AND status='ACTIVE' ORDER BY id FOR UPDATE` (ou `pg_advisory_xact_lock` sur une clé constante). Test d'intégration avec deux requêtes concurrentes (`Promise.all`) : une seule réussit, l'autre 422 `LAST_SUPER_ADMIN`. Remarque qualité : le comptage inclut la cible même si elle est déjà suspendue (refus 422 à tort quand on rétrograde ou désactive un super-admin suspendu).
Exigence : décision B ; ASVS 1.11.3 / 11.1.6 (logique métier sous concurrence).

[CONSTAT] S2-02 Support réinitialise le mot de passe de n'importe quel compte, super-admin et lui-même compris
Sévérité : Moyenne
Fichier : apps/api/src/users/users.service.ts:232-262 ; apps/api/src/users/users.controller.ts:112-117
Preuve : seule condition `target.status === 'ACTIVE'` ; aucune vérification du rôle de la cible, ni de `actorId === id`, ni de `mustChangePassword`. Le `passwordHash` est remplacé et toutes les sessions révoquées.
Scénario d'attaque : un compte Support (rôle le moins privilégié) compromis ou malveillant appelle en boucle `POST /v1/admin/users/{superAdminId}/reset-invitation` sur chaque super-admin et chaque Finance : leurs sessions sont fermées et leur mot de passe remplacé à chaque appel (déni de service ciblé du back-office, en plein lot de règlement). Le web masque le bouton sur son propre compte, l'API ne le refuse pas.
Correctif proposé : refuser `SELF` (403) ; cible `ADMIN` réservée à `users.adminRoles` (même règle que le changement de rôle) ; limiter le débit par acteur. Restreindre aux comptes encore « Invité » contredirait le contrat (« invité ou actif ») : voir [DÉCISION] ci-dessous.
Exigence : ASVS 4.1.3 (moindre privilège), 2.5.x (récupération) ; API5:2023 (autorisation au niveau fonction).

[CONSTAT] S2-03 Le déblocage du PIN lève la reconnexion complète sans fermer les sessions
Sévérité : Moyenne
Fichier : apps/api/src/users/users.service.ts:275-278
Preuve : `pinRequiresReauth: false, pinLockLevel: 0, pinFailures: 0`, sessions de l'employé conservées.
Scénario d'attaque : un voleur du téléphone déverrouillé épuise les essais du PIN jusqu'au palier « connexion complète exigée », appelle le support en se faisant passer pour l'employé ; Support débloque : 5 nouveaux essais, répétable ; l'e-mail de notification arrive au vrai titulaire trop tard. Le palier anti-force-brute est contourné par ingénierie sociale.
Correctif proposé : le déblocage révoque aussi toutes les sessions de l'employé (il se reconnecte avec son mot de passe, ce que le voleur n'a pas) ; tester que la session d'avant le déblocage reçoit 401.
Exigence : ASVS 2.2.1 (anti-automatisation), 3.3.x ; MASVS-AUTH.

[CONSTAT] S2-04 Statut de l'employé non revérifié dans la transaction de paiement
Sévérité : Basse
Fichier : apps/api/src/payments/payments.service.ts:269-290 (`confirmRequest`), 361-375 (`payMerchant`)
Preuve : `canSpend` n'est appliqué qu'à l'initiation par code (l. 611) ; ailleurs seul le guard lit `users.status` avant la transaction.
Scénario d'attaque : un paiement lancé quelques millisecondes avant le commit d'une suspension passe ; un employé dont la ligne `employees` est suspendue mais le compte `users` actif (désynchronisation, employé sans compte rattaché plus tard) paie librement.
Correctif proposé : dans `debit`, `SELECT … FROM employees WHERE id = $1 FOR UPDATE` puis `canSpend(employee, now)`, sinon 422 `PAYMENT_DECLINED`.
Exigence : décision e3 ; ASVS 1.11.3.

[CONSTAT] S2-05 Audit incomplet pour un employé sans compte
Sévérité : Basse
Fichier : apps/api/src/users/users.service.ts:349
Preuve : `audit.record(tx, 'employees.suspend', employeeNumber)` : ni `subjectId`, ni motif. L'audit ne garde pas non plus l'état avant/après, l'IP ni l'appareil (écart existant).
Correctif proposé : `recordFor` avec le motif (sujet = identifiant employé) ; ajouter `from → to` dans `target`.
Exigence : décision B ; SEC audit (qui, quoi, avant/après).

[CONSTAT] S2-06 Les handlers MSW ne reflètent pas les règles
Sévérité : Basse
Fichier : apps/web/src/mocks/handlers/users.ts:191-217
Preuve : `…/role` sans contrôle de permission ni du dernier super-admin ; `…/reset-invitation` sans permission ni refus de soi. Les e2e passent sur un comportement plus permissif que l'API.
Correctif proposé : appliquer les mêmes refus (403 permission/soi, 422 `LAST_SUPER_ADMIN`).

## Vérifié sans constat
- IDOR entreprise : `employeeChange` compare explicitement `employee.companyId` au `companyId` de la session malgré `db.system` (404, lot : `SKIPPED` identique pour « autre entreprise » et « conflit ») ; `company.employee()` en `db.user` (RLS) ; tests l. 256-276.
- Escalade : `subRolesOf` interdit un sous-rôle admin à un tenant (test 400) ; cible ADMIN exige `users.adminRoles` ; employé sans sous-rôle ; création d'admin réservée à `users.adminRoles`.
- Soi-même : statut et rôle refusés 403 (tests).
- Révocation des sessions : suspension, désactivation, changement de rôle, réinitialisation ; guard, rafraîchissement et connexion utilisent `canSignIn`.
- Employé désactivé en grâce : seules les routes `EMPLOYEE` (portefeuille, opérations, profil, PIN, paiement) ; aucune attribution (409, testé) ; pas de retour arrière (409).
- Énumération à la création d'admin : 202 identique, e-mail d'avertissement à l'adresse existante.
- Fuites : solde seulement avec `userBalances.read` (Support exclu, testé) ; aucun téléphone dans la fiche admin ; motif admin invisible pour l'entreprise (test D7) ; aucun secret dans la réponse de réinitialisation (testé) ; motif rendu échappé par React (pas de XSS).
- Audit : append-only (trigger 0002), `subject_id` et `reason` (500 max) ajoutés, aucune donnée sensible.

## Règles métier non couvertes ([DÉCISION] à `main`)
1. Cascade famille (e3, D6) : aucun modèle famille côté serveur. À la création du modèle : cascade suspension/désactivation tracée, réactivation des seuls membres suspendus par cascade, et contrôle du statut de l'employé parent dans **tous** les chemins de paiement du membre.
2. Fin du délai de grâce : la connexion est refusée, mais aucun job ne ferme le compte ni n'applique au solde la règle des crédits expirés.
3. Une entreprise (MANAGER) peut réactiver un employé suspendu par l'administrateur (ex. fraude) : règle absente.
4. Réinitialisation par Support : comptes ADMIN autorisés ou non ; « Invité » seulement ou « actif » aussi (S2-02).
5. Rétrogradation du dernier OWNER d'une entreprise ou d'un commerçant : non encadrée.

## Vérifications
- `npx vitest run test/unit/account-lifecycle.test.ts` (apps/api) : 9/9 réussis.

## Non vérifié
- Tests d'intégration `user-management.test.ts` non lancés (PostgreSQL requis) ; lus seulement.
- Révocation des sessions au changement de rôle : codée, non testée.
- Parcours « mot de passe oublié » d'un compte suspendu ou désactivé (hors fichiers fournis).
- Politiques RLS de `audit_log` pour les nouvelles colonnes ; pages web `admin/utilisateurs/page.tsx`, `create-administrator.tsx`, `entreprise/employes/page.tsx` (hors liste).
- Absence des handlers MSW dans le build web (contrôle existant, non rejoué).
