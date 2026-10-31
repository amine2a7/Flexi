# Revue securite – N2 (litiges) et alertes de fraude – 2026-10-31

- **Branche** : `feat/web`, commits `9c017f7`, `afedccc`, `4c22ab7`, `02edc83`.
- **Périmètre lu (consigne du lead, lecture limitée)** : `apps/api/src/risk/risk.controller.ts`, `apps/api/src/risk/disputes.service.ts`, `apps/api/src/risk/fraud.service.ts`, route `approve` de `apps/api/src/admin/admin.controller.ts` (l. 177-203), `approvalType`/`approveIn`/`reject` de `apps/api/src/admin/admin.service.ts` (l. 478-546), matrice de `apps/api/src/common/permissions.ts`, migrations `0019` à `0022`, tests `disputes.test.ts`, `fraud-alerts.test.ts`, `admin-matrix.test.ts`. Lecture ponctuelle complémentaire : `four-eyes.service.ts` (l. 24-34), enum `PayoutStatus` du schéma Prisma, appel du job (`jobs.service.ts:86`).
- **Méthode** : lecture du code ; aucun test exécuté (base PostgreSQL de test non sollicitée dans cette revue).

## Verdict : **OK** (aucun Critique ni Haute ouvert)

2 Moyenne, 4 Basse. Les Moyenne sont à corriger avant la clôture de la phase N2, sans bloquer la tâche.

## Points vérifiés (preuves positives)

| Point | Résultat |
| --- | --- |
| Contrôle d'accès | `@Roles('ADMIN')` sur les deux contrôleurs ; `risk.read` / `disputes.manage` / `alerts.manage` = SUPER_ADMIN et COMPLIANCE seulement (`permissions.ts:108-116`) ; FINANCE et SUPPORT refusés (403), couvert par `admin-matrix.test.ts:78-86` (toutes les routes, toutes les sous-rôles) et `fraud-alerts.test.ts:122`. |
| Quatre yeux | Le remboursement (`DISPUTE_REFUND`) passe par `approveIn` : `ensureNotAuthor(approval.initiatorId)` sous verrou de l'approbation (`admin.service.ts:496-499`) ; testé pour COMPLIANCE (`disputes.test.ts:177-183`) et pour un SUPER_ADMIN (`disputes.test.ts:486-489`). Opérations n'a pas `approvals.decide`. |
| Idempotence | `Idempotency-Key` sur ouvrir, rejeter, accepter et sur l'approbation d'un remboursement (`admin.controller.ts:186-192`, absence de clé → 400 testée `disputes.test.ts:490-491`). Double approbation : verrou `FOR UPDATE` sur l'approbation puis sur le litige, statuts `PENDING` puis `ACCEPTANCE_PENDING` revérifiés (`disputes.service.ts:283-285`). Double ouverture : verrou du paiement + `payment_id UNIQUE` (testé : 409). Une seule approbation en cours par litige (`lockOpen` exige `OPEN`). |
| Ledger | Écritures équilibrées, aucune mise à jour du ledger ; contre-passation du virement retenu (`ledger.reverse`) ; contrôle que les débits du paiement portent tous un lot (`disputes.service.ts:298-307`). |
| Injection SQL | Toutes les requêtes brutes sont des gabarits étiquetés `$queryRaw`/`$executeRaw` paramétrés ; aucun `$queryRawUnsafe` ni `Prisma.raw` (grep sur `risk/` et `admin.service.ts`). Casts d'enum sur paramètres liés. |
| Validation | Zod strict : `reason` 10-500 (trim), note 1-2000, `paymentId` UUID, identifiants de chemin UUID (`pathId`) ; longueurs alignées sur les colonnes `VARCHAR`. |
| Fuite de données | Corps de litige : référence, commerce, montant, motif ; aucune donnée de l'employé. Alerte : prénom + initiale du nom ou nom du commerce ; `subject_key` (identifiants internes) jamais renvoyé. Logs : seulement un compteur (`fraud.service.ts:84`). Erreurs génériques (`problems.conflict/notFound`). |
| RLS / droits | `ENABLE ROW LEVEL SECURITY` + politique `app_is_platform()` sur `disputes`, `dispute_notes`, `fraud_alerts` ; aucun `DELETE` accordé ; `dispute_notes` en ajout seul (pas d'`UPDATE`). |
| Audit | `disputes.open/note/reject/accept/refund`, `approvals.approve/reject`, `fraudAlerts.start/close`, `fourEyes.refused`, dans la même transaction que l'action. |
| Déni de service (job) | Fenêtre de 20 min, alertes regroupées par employé/commerce et tranche horaire, clé unique `(kind, subject_key)` + `ON CONFLICT DO NOTHING` : deux passages ne dupliquent rien (testé). |

## Constats

```
[CONSTAT] S-N2-01 Second litige sur un virement déjà « En attente — litige » traité comme « déjà payé »
Sévérité : Moyenne
Fichier : apps/api/src/risk/disputes.service.ts:134-148 (et refundSource 368)
Preuve : la branche « virement retenu » n'accepte que REQUESTED/CHECKED ; un virement ON_HOLD (retenu par un
premier litige L1) tombe dans le « sinon » (rien ne bouge, ni retenue ni heldPayoutId) pour le litige L2.
Scénario d'attaque : deux paiements p1, p2 du même virement V sont contestés. L1 accepté → V contre-passé et
REJECTED, `payoutId` remis à null pour p1 ET p2 : le montant de p2 (toujours DISPUTED) revient libre dans le
portefeuille du commerçant, qui peut le demander en virement avant la décision sur L2. L1 rejeté → V repasse
REQUESTED et peut être payé avec p2 en litige. Si L2 est accepté, la somme devient une dette « déduite du
prochain règlement » : perte sèche si le commerçant cesse son activité (fonds sortis pendant le litige).
Correctif proposé : traiter ON_HOLD comme « virement retenu » (rattacher L2 au même virement, ne restaurer le
statut de V qu'à la clôture du dernier litige ouvert sur V) ; ou, à l'acceptation de L1, retenir au compte
de litige les montants des autres paiements DISPUTED du virement contre-passé. Test : deux litiges, même virement.
Exigence : SEC règle 4 (argent), ASVS 11.1.2 / 11.1.3 (logique métier) — à confirmer par ledger-auditor.
```

```
[CONSTAT] S-N2-02 Finance donne la seconde validation sans pouvoir lire le litige
Sévérité : Moyenne (efficacité des quatre yeux)
Fichier : apps/api/src/common/permissions.ts:117-125 ; apps/api/src/risk/disputes.service.ts:256-264
Preuve : FINANCE n'a pas `risk.read` (403 sur GET /v1/admin/disputes/:id, matrice testée) ; l'approbation ne
porte que `Litige LIT-… (PAY-…)`, le motif d'acceptation et `payload.disputeId` : ni montant, ni commerce,
ni notes d'enquête.
Scénario d'attaque : un agent Opérations de connivence avec un employé ouvre puis accepte un litige non fondé
avec un motif plausible ; Finance approuve « à l'aveugle » (montant inconnu) ; l'employé est recrédité et le
commerçant débité. La seconde validation existe mais ne contrôle rien.
Correctif proposé : soit donner `risk.read` à FINANCE, soit figer dans l'approbation (payload + affichage) le
montant, le commerce, la référence de paiement et le motif d'ouverture. Changement de matrice → [DÉCISION] main.
Exigence : règle 12 (double validation), ASVS 1.4.x / 4.1.x
```

```
[CONSTAT] S-N2-03 Course sur payoutId entre la lecture initiale et les verrous à l'ouverture
Sévérité : Basse
Fichier : apps/api/src/risk/disputes.service.ts:95-113,137
Preuve : le virement à verrouiller est choisi d'après `found.payoutId` lu SANS verrou ; si un virement est créé
entre cette lecture et `lockAccounts`, le paiement relu (l. 105) porte un payoutId dont la ligne n'est pas
verrouillée ; `payout.status` est lu sans `FOR UPDATE` puis écrasé par `update({where:{id}})` (l. 137).
Scénario d'attaque : fenêtre de quelques ms ; une décision Finance concurrente (SENT/EXECUTED) serait écrasée en
ON_HOLD, puis un rejet du litige restaurerait REQUESTED/CHECKED → virement payable deux fois. Exploitation
improbable (action humaine dans la même fenêtre), impact financier.
Correctif proposé : après le verrou du paiement, `if (payment.payoutId !== found.payoutId) throw conflict()`
(le client réessaie avec la même clé) ; ou `updateMany({ where: { id, status: { in: ['REQUESTED','CHECKED'] } } })`
avec contrôle du nombre de lignes.
Exigence : règle 4 (verrouillage ordonné), ASVS 11.1.6
```

```
[CONSTAT] S-N2-04 Seuils des règles de fraude non validés : un réglage fautif arrête toute la détection
Sévérité : Basse (aucune route n'écrit `fraud_rules` aujourd'hui)
Fichier : apps/api/src/risk/fraud.service.ts:144-147,153,172
Preuve : `{ ...DEFAULT_RULES, ...(settings.fraudRules as Partial<FraudRules>) }` sans schéma ; `refusedMinutes`
ou `merchantMinutes` = 0 → division par zéro ; une chaîne → erreur de type SQL ; les 3 règles tournent dans
une seule transaction : une erreur supprime toutes les alertes, silencieusement, à chaque passage.
Scénario d'attaque : un super-admin (ou une erreur de saisie) met un seuil à 0 ou très grand → plus aucune
alerte de fraude, sans signal.
Correctif proposé : schéma Zod (entiers bornés, minutes ≥ 1, pourcentage 1-100) à la lecture ET dans la future
route de réglage (quatre yeux) ; isoler chaque règle (try/catch + log d'erreur + métrique).
Exigence : ASVS 5.1.3, 7.4.x (journal des erreurs)
```

```
[CONSTAT] S-N2-05 Requêtes du job sans index adapté (statut + date)
Sévérité : Basse (disponibilité, croît avec le volume)
Fichier : apps/api/src/risk/fraud.service.ts:174,192 ; index existants 0001_init:730-736
Preuve : filtre `status IN ('CONFIRMED','SETTLED',…) AND created_at >= since` ; seuls `payments(status)` et des
index préfixés par merchant_id/employee_id existent → parcours de tous les paiements confirmés depuis
l'origine, toutes les 10 minutes.
Scénario : à fort volume, le job charge la base partagée avec le paiement QR (latence, délais de verrou).
Correctif proposé : nouvelle migration `CREATE INDEX … ON payments (created_at, status)` (ou index partiel).
Exigence : API4:2023 (consommation de ressources)
```

```
[CONSTAT] S-N2-06 Tests manquants sur la concurrence et le rejeu
Sévérité : Basse
Fichier : apps/api/test/integration/disputes.test.ts
Preuve : aucun test de deux approbations simultanées du même remboursement, de deux ouvertures simultanées, ni
de rejeu de la même `Idempotency-Key` (réponse identique, aucune écriture en double) ; aucun test de deux
litiges sur le même virement (S-N2-01).
Correctif proposé : `Promise.all` de deux approbations (une 200, une 409, solde employé crédité une fois) ;
même clé rejouée sur open/accept/approve ; scénario S-N2-01.
Exigence : règle 6 (test d'abord), ASVS 11.1.x
```

Remarque (non comptée) : l'initiateur d'un `DISPUTE_REFUND` disposant de `approvals.decide` (SUPER_ADMIN) peut rejeter sa propre demande (`admin.service.ts:522-529`, pas de `ensureNotAuthor`) ; effet = retrait de la demande, le litige revient à OPEN ; aucun gain, comportement antérieur à N2.

## Non vérifié

- `IdempotencyService.run` (liaison de la clé à l'utilisateur, à la route et au corps ; stockage de la réponse) : hors liste de lecture.
- `AuditService.record` : contenu réel (IP, appareil, avant/après, chaînage append-only) : hors liste.
- `LedgerService.lockAccounts`/`reverse`/`post` (ordre des verrous, refus de solde négatif) et traitement des statuts `ON_HOLD` et du compte de dette par le service des virements et le règlement : hors liste, relève de ledger-auditor.
- Application effective de la RLS : aucune migration n'utilise `FORCE ROW LEVEL SECURITY` ; dépend du fait que `flexipay_app` n'est pas propriétaire des tables (non vérifié ici).
- Rendu web des motifs et notes (échappement, export CSV éventuel, neutralisation des formules) : frontend non lu.
- Exécution des tests : non lancés.

## Modèle de menaces

Section « N2 – litiges et alertes de fraude » ajoutée à `docs/security/modele-de-menaces.md`.
