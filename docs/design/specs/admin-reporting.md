# Spec design – Administrateur › Reporting
**Statut :** écrite et codée en mode continu (2026-10-30) · **Auteur :** lead · **Route :** `/admin/reporting` · **Permission :** `dashboard.read` (super-admin, Opérations, Finance)
**Contrat :** `GET /v1/admin/dashboard` (`monthlyFlows`, `monthByCreditType`, `todayVolumeMillimes`).

## 1. Objectif
Suivre les volumes de la plateforme par mois et exporter le tableau. **Action principale :** « Exporter (CSV) ».
## 2. Structure
`PageHeader` + export ; `DataTable` « Volumes par mois » (mois, crédité, payé) ; carte « Volume du jour » (montant mis en avant) + `CreditTypeBreakdown` des paiements du mois.
## 3. États
Squelette, vide, erreur + réessayer.
## 4. À confirmer par Amine
Rapports par commerçant, par entreprise, commissions perçues par période : route de reporting dédiée à écrire.
