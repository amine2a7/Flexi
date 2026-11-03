# Revue securite – N2 litiges v3 – 2026-11-03

- **Base** : `git diff 02edc83..b028b78 -- apps/api` (commits `0f5ed56`, `edf19b2`, `b028b78`). Lecture complémentaire : `admin.service.ts` (approveIn/reject l. 490-545), `payouts.service.ts` (reject, executeDueBatches), `ledger.service.ts` (lockAccounts), `permissions.ts`, `payments.service.ts` (cancel).
- **Méthode** : lecture du code et des tests ; aucun test exécuté (base PostgreSQL de test non sollicitée).

## Verdict : **OK** – aucun Critique, Haute ni Moyenne ouvert ; 1 Basse résiduelle (S-N2-04).

## Points vérifiés
| Point | Résultat |
| --- | --- |
| Permissions | `disputes.read` = SUPER_ADMIN, COMPLIANCE, FINANCE ; écritures (`open/note/reject/accept`) = `disputes.manage` (SUPER_ADMIN, COMPLIANCE) ; alertes toujours `risk.read` (Finance 403). Matrice HTTP mise à jour (`admin-matrix.test.ts:81-82`) + `disputes.test.ts:799` (Finance : lecture 200, note/rejet 403, alertes 403). Pas de tenant : routes plateforme `@Roles('ADMIN')`. |
| Quatre yeux | Inchangé : `ensureNotAuthor(approval.initiatorId)` sous verrou de l'approbation (`admin.service.ts:496-499`) ; super-admin accepteur refusé (`disputes.test.ts:883`). Finance n'a pas `disputes.manage`. |
| Idempotence | `Idempotency-Key` sur open/reject/accept et approbation ; rejeu d'un remboursement testé (`disputes.test.ts:646`) ; deux approbations simultanées → un seul crédit (`:630`). |
| Verrous / courses | Ordre unique comptes (triés, `lockAccounts`) → litige → virement → paiement/lot. `reject` (litige et virement) et `refund` verrouillent désormais les comptes avant la ligne. Règlement : lot `SKIP LOCKED` → comptes → `updateMany(status='CHECKED', batchId=lot)` : un virement passé `ON_HOLD` entre-temps est ignoré (`payouts.service.ts:711-716`, testé `:744`). `nextBatch` (lots `> aujourd'hui`) disjoint des lots exécutés. Aucun cycle de verrous identifié. |
| Statuts de virement | `ON_HOLD` intouchable par Finance (approve/reject exigent `REQUESTED`) ; reprise seulement à la clôture du dernier litige actif (`releasePayout`) ; contre-passation du virement retenu avec mise en retenue immédiate des autres litiges (`reverseHeldPayout`). |
| Commission / dette | Commission annulée bornée au reste de la commission du virement, sérialisée par le verrou du compte commission (`commissionToCancel`, test `:662`) ; déduction ≤ net (CHECK migration 0023 + `min` dans le règlement). |
| Validation | Zod strict inchangé ; filtres de statut `ON_HOLD` ajoutés en enum (admin et commerçant). Seuils de fraude bornés par Zod avec repli sur défaut. |
| Fuites | Corps de litige sans donnée employé ; erreurs génériques ; log de réconciliation = compteur ; audit = codes de comptes (identifiants internes), jamais de montant. Historique de virement commerçant : motif = référence `LIT-…` seulement (pas de détail). IBAN figé et chiffré dans le virement. |
| Migration | `0023_dispute_commission` nouvelle ; aucune migration existante modifiée (diff stat). CHECK, FK `held_payout_id`, index `(status, created_at)`. |
| SQL | Gabarits `$queryRaw` paramétrés uniquement ; aucun `Unsafe`/`Prisma.raw`. |

## Suivi des constats précédents
| ID | État | Preuve |
| --- | --- | --- |
| S-N2-01 Moyenne | **Fermé** | `ON_HOLD` traité comme virement retenu (`disputes.service.ts:144-149`, `holdPayout:468-475`) ; reprise au dernier litige (`:494-497`) ; contre-passation → retenue des autres (`:408-438`). Tests `:548`, `:565`, `:592`, `:684`, `:724`. |
| S-N2-02 Moyenne | **Fermé** | Finance a `disputes.read` (décision 2026-11-02), lecture seule testée (`:799`). |
| S-N2-03 Basse | **Fermé** | `payment.payoutId !== found.payoutId` → 409 (`disputes.service.ts:115`) ; virement verrouillé avant lecture du statut. |
| S-N2-04 Basse | **Partiel** | Seuils validés (`fraud.service.ts:29-38`). Reste : les 3 règles dans une transaction sans isolement (aucun `try/catch`), une erreur SQL d'une règle supprime toutes les alertes du passage. |
| S-N2-05 Basse | **Fermé** | `payments_status_created_idx` (migration 0023). |
| S-N2-06 Basse | **Fermé** | Tests concurrence, rejeu, deux litiges sur un virement, ouverture pendant le règlement. |

```
[CONSTAT] S-N2-04 (résiduel) Règles de fraude non isolées
Sévérité : Basse
Fichier : apps/api/src/risk/fraud.service.ts (run des 3 règles, même transaction)
Scénario : une règle en erreur (donnée inattendue, timeout) annule silencieusement les alertes des deux autres à chaque passage.
Correctif proposé : une transaction (ou try/catch + log d'erreur sans donnée + métrique) par règle.
Exigence : ASVS 7.4.x, 11.1.x
```

Remarques (non comptées) : (1) l'ouvreur d'un litige (super-admin) peut approuver le remboursement si un autre agent l'a accepté : deux personnes distinctes restent impliquées, conforme à la règle 12. (2) `refund` verrouille les comptes globaux commission et virements à payer même pour une retenue simple : point de contention, pas de faille.

## Non vérifié
- Exécution des tests (`disputes.test.ts`, `admin-matrix.test.ts`) : non lancés.
- `IdempotencyService.run` (liaison clé/utilisateur/route/corps) et `AuditService.record` (IP, appareil, chaînage) : hors diff.
- Filtre d'exceptions global (les `Error` internes → 500 sans message) : hors diff.
- Application effective de la RLS (`FORCE ROW LEVEL SECURITY`, propriétaire des tables) : inchangé, non vérifié.
- Justesse comptable de l'annulation de commission (facturation, TVA) : relève de ledger-auditor.
