# Revue sécurité – Grilles de commission (diff non commité, 2026-11-04)

Base : `git diff` + nouveaux fichiers (0024, 0025, `commission-grids.ts`, `shared/commission.ts`). Décisions 2026-11-03/04.
**Verdict : OK** (aucun Critique ni Haute ouvert). 1 Moyenne, 3 Basses.

## Points vérifiés (sans constat)

- `asService` : valeurs paramétrées (`set_config(... ${previous}, true)`), aucune injection ; portée `is_local=true` (transaction) ; appels séquentiels (pas de `Promise.all` sur le même `tx`) ; `fn` = `gridRate` filtré sur le seul `merchantId` du paiement, ne renvoie qu'un entier. Erreur SQL dans `fn` = transaction avortée, aucune requête suivante possible : pas de fuite en rôle SYSTEM. Le taux n'est jamais renvoyé à l'employé (`operationDetail` sans `commissionRateBps`).
- RLS : lecture plateforme, COMPANY (sa grille), MERCHANT (sa grille) ; EMPLOYEE aucune ligne ; `commission_tiers` filtré via la politique de `commission_grids` (sous-requête soumise à la RLS, tables possédées par le superutilisateur, API en `flexipay_app`) ; INSERT plateforme seulement ; GRANT SELECT, INSERT uniquement, aucune politique UPDATE/DELETE (refus par défaut).
- Quatre yeux : `ensureNotAuthor` sous `FOR UPDATE` de l'approbation, statut revérifié ; une seule demande en attente par entité (verrou `FOR UPDATE` de l'entité puis relecture en READ COMMITTED) ; ancienne approbation `COMMISSION_RATE_CHANGE` refusée (409). Route `commissions.request` (MONEY dans la matrice testée), approbation `approvals.decide`.
- Entrées : `z.strictObject`, union exclusive companyId/merchantId, 1 à 20 tranches, `rateBps` 0..10 000, bornes entières 0..MAX_SAFE_INTEGER (BIGINT), chevauchement/défaut unique contrôlés + CHECK et index unique en base ; `reason` ≤ 500.
- Alerte : transaction séparée `db.system`, sujet = nom (≤ 120) et identifiant, aucune donnée sensible ; dédoublonnage `ON CONFLICT (kind, subject_key)`.

## Constats

[CONSTAT] S-GC-01 Tests absents sur les nouveaux risques de tenant et de rôle
Sévérité : Moyenne
Fichier : apps/api/test/integration/admin.test.ts:171-231
Preuve : la vérification « after » (l.197) ouvre une NOUVELLE transaction : elle ne prouve pas la restauration du rôle dans la même transaction ; aucun test COMPANY/MERCHANT sur la grille d'un autre tenant, ni INSERT/UPDATE/DELETE refusés hors plateforme, ni demandes concurrentes, ni grille manquante sous transaction utilisateur.
Scénario d'attaque : une régression future (restauration supprimée, politique élargie à `app_role()='EMPLOYEE'`) passerait la CI ; un employé lirait alors grilles ou soldes d'autres tenants dans la suite de sa transaction.
Correctif proposé : dans une même `db.run({role:'EMPLOYEE'})`, appeler `commissionRate` puis vérifier `current_setting('app.role')='EMPLOYEE'` et `findMany` vide (et idem quand `fn` lève) ; tests RLS croisés COMPANY A/B, MERCHANT A/B et MERCHANT→grille entreprise ; `update`/`delete`/`create` sous MERCHANT refusés ; deux demandes `Promise.all` → une 201, une 409.
Exigence : SEC-autorisation / ASVS 4.1.3, 4.2.1

[CONSTAT] S-GC-02 `asService` restauration silencieuse en cas d'échec (fail-open théorique), primitive générique exportée
Sévérité : Basse
Fichier : apps/api/src/common/db.service.ts:40-56 (l.51 `restore().catch(() => undefined)`)
Preuve : si `fn` lève une erreur JS (ex. `tierFor` « without a default line ») et que la restauration échoue, l'erreur de restauration est avalée ; tout appelant futur qui attrape l'erreur et continue resterait en SYSTEM.
Scénario d'attaque : un développeur réutilise `asService` ou entoure `commissionRate` d'un `try/catch` de repli ; la suite de la requête employé lit toutes les tables en SYSTEM (IDOR massif).
Correctif proposé : préférer une fonction SQL `SECURITY DEFINER` `commission_rate_for(owner, amount) RETURNS int` (l'employé ne change jamais de rôle) ; à défaut, en cas d'échec de restauration lever une erreur fatale distincte, et limiter `asService` (non exporté, ou règle lint) au seul `SettingsService`.
Exigence : ASVS 4.1.5 (échec sécurisé), 1.4.x

[CONSTAT] S-GC-03 Signalement « grille manquante » : seconde connexion sous verrous, audit non dédoublonné
Sévérité : Basse
Fichier : apps/api/src/platform/settings.service.ts:80, 90-103
Preuve : `reportMissingGrid` ouvre `db.system` pendant que la transaction appelante garde sa connexion et ses verrous (après `ledger.post` dans le paiement) ; `audit.record` est écrit à chaque essai, même si l'alerte existe déjà.
Scénario d'attaque : grille absente (erreur de données) ; employés ou script qui répètent paiements / `GET` détail commerçant : chaque requête retient 2 connexions (pool de 10) → famine du pool jusqu'au timeout 20 s, et journal d'audit inondé.
Correctif proposé : lever une erreur typée et signaler APRÈS le rollback (filtre/intercepteur ou job BullMQ), ou au minimum n'écrire l'audit que si l'INSERT de l'alerte a inséré 1 ligne.
Exigence : ASVS 11.1.4 (anti-automatisation), 7.x

[CONSTAT] S-GC-04 Grilles complètes visibles par SUPPORT (accounts.read) sans `commissions.read`
Sévérité : Basse
Fichier : apps/api/src/admin/admin.service.ts:63, 346 (+ création l.400)
Preuve : `merchantAccount` et la liste des entreprises renvoient `commissionGrid` (toutes les tranches) ; la matrice réserve les commissions à COMPLIANCE/FINANCE/SUPER_ADMIN.
Scénario d'attaque : un agent Support exporte les conditions commerciales de tous les commerçants et entreprises (fuite concurrentielle) ; élargit l'exposition existante (taux du profil) aux entreprises et aux tranches.
Correctif proposé : n'inclure `commissionGrid` que si `permissionsOf(role, subRole).includes('commissions.read')` (sinon `null`), test matrice SUPPORT.
Exigence : ASVS 4.1.3 (moindre privilège)

## Non vérifié

- Tests non exécutés (mode économe, base de test non lancée) : résultats de `admin.test.ts` non constatés.
- Pas de `FORCE ROW LEVEL SECURITY` (repose sur le fait que l'API n'est pas propriétaire des tables, cf. N2-T9).
- Migration 0025 : grilles à 0 bps (`coalesce(..., 0)`) pour un commerçant sans type paramétré ; perte de revenu, à voir par `ledger-auditor`/conformite.
- Usage de la grille entreprise sur les commandes et cohérence taux paiement (montant du paiement) / virement (montant du virement) : hors sécurité.
- Front web, mocks MSW, `packages/shared/test/commission.test.ts` non relus.
