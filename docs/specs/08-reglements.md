# Spec 08 – Règlements, rapprochement et litiges
**Phase 7 · Cahier :** RG-6, RG-7, ADM-08

## 1. Objectif
Exécuter les virements aux commerçants, rapprocher avec la banque, gérer les litiges.

## 2. Règles
- Cycle par défaut J+2, paramétrable, calculé en jours calendaires `Africa/Tunis`. Demande libre (au-dessus du seuil) ou lot automatique.
- Contrôles avant virement : RIB conforme au KYB, commerçant actif, créance non en litige, plafond de virement, LAB/FT.
- Double validation du lot au-delà du seuil (ex. 10 000 TND). L'approbateur n'est pas l'initiateur.
- Génération du fichier/ordre bancaire ; import du retour bancaire pour passer en `EXECUTEE` ou `REJETEE` (en cas de rejet : contre-passation et notification).
- Rapprochement quotidien relevé bancaire ↔ ledger ; écarts listés et traités avec justification.
- Litige : transaction gelée, créance suspendue ; résolution = confirmée, annulée avec remboursement du wallet de l'employé, ou ajustée ; tout est journalisé.
- Factures : commission (mensuelle), attestations fiscales, relevés (PDF générés de façon asynchrone).

## 3. Données
`payout_requests` (merchant_id, gross, rate_bps_snapshot, commission, net, status, approved_by, bank_reference) · `settlement_batches` · `bank_files` · `bank_reconciliations` · `disputes` · `invoices`.

## 4. Tests
E4, E14, E15 ; rejet bancaire → contre-passation ; rapprochement détecte un écart injecté ; lot sans seconde approbation non exécuté ; RIB modifié récemment → délai de carence/contrôle ; rejeu d'un fichier de retour sans doublon.
