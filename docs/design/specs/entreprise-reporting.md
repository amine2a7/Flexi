# Spec design – Entreprise › Reporting
**Statut :** écrite et codée en mode continu (2026-10-30) · **Auteur :** lead · **Route :** `/entreprise/reporting` · **Permission :** `balances.read`
**Contrat :** `GET /v1/company/dashboard` (`monthlyFlows`, `balances`, `walletBalanceMillimes`) ; aucune route de reporting dédiée pour l'instant.

## 1. Objectif
Suivre, mois par mois, les crédits reçus et attribués, et exporter le tableau. **Action principale :** « Exporter (CSV) » (absente sans données).
## 2. Structure
1. `PageHeader` « Reporting » + « Exporter (CSV) » (fichier UTF-8 avec BOM, séparateur `;`, montants au format de la langue).
2. `DataTable` « Crédits par mois » (mois, crédité, attribué ; montants à `end`) ; cartes sous `breakpoint.md`.
3. Carte « Portefeuille actuel » : total mis en avant + `CreditTypeBreakdown`.
## 3. États
Squelette ; erreur + réessayer ; vide « Pas encore de données ».
## 4. À confirmer par Amine
Période paramétrable (12 mois, année), rapports par employé ou par service, export PDF : demandent une route `GET /v1/company/reports` (contrat à écrire).
