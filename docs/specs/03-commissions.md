# Spec 03 – Profils de commission
**Phase 3 · Cahier :** RG-1, ADM-03, ADM-04, ADM-09

## 1. Objectif
Permettre à l'Administrateur de définir des profils de commission et de les rattacher aux sociétés et aux commerçants via une liste déroulante.

## 2. Règles
- Deux types : `COMPANY` (frais sur commande) et `MERCHANT` (commission de règlement).
- Un profil : code unique, libellé, taux en **bps** (éventuellement par catégorie), montant minimum, statut actif/inactif, date d'effet.
- **À la création d'une société ou d'un commerçant, le profil est obligatoire** (liste déroulante limitée aux profils actifs du bon type).
- Modification d'un profil ou changement de profil d'un compte : **double validation**, motif obligatoire, date d'effet future ou immédiate, jamais rétroactive.
- Commission COMPANY : ajoutée à la commande. Commission MERCHANT : calculée **uniquement** à la demande de virement, **taux figé** dans la demande.
- Arrondi : défini dans `open-questions.md` (par défaut arrondi au millime supérieur).
- Un profil utilisé ne peut pas être supprimé, seulement désactivé.

## 3. Données
`commission_profiles` (id, type, code, label, rate_bps, min_fee_millimes, active) · `commission_profile_rates` (profile_id, category, rate_bps) · `commission_assignments` (subject_type, subject_id, profile_id, effective_from, effective_to, approved_by) · `commission_history` (qui, quand, avant/après, motif).

## 4. API
| Route | Rôle | Description |
|---|---|---|
| GET /commission-profiles?type= | ADMIN | liste (alimente les listes déroulantes) |
| POST /commission-profiles | ADMIN finance | crée (soumis à approbation) |
| PATCH /commission-profiles/{id} | ADMIN finance | demande de modification |
| POST /approvals/{id}/approve | ADMIN (≠ initiateur) | approuve |
| PUT /companies/{id}/commission-profile · PUT /merchants/{id}/commission-profile | ADMIN | changement de profil (approbation) |
| GET /payouts/quote?amount= | MERCHANT | simulation : brut, taux, commission, net |

## 5. Écrans
Création société / commerçant (liste déroulante), page « Commissions » (tableau, historique), écran de simulation commerçant.

## 6. Tests
- Création sans profil refusée ; profil du mauvais type refusé.
- E4 (2 % de 45 000 = 900, net 44 100), E5 (1,5 %), E6 (taux figé).
- Approbation par l'initiateur refusée ; sans approbation, rien ne change.
- Changement avec date d'effet future : appliqué à partir de cette date seulement.
- Simulation identique au calcul réel du virement (même fonction).
- Montant minimum de commission respecté.
