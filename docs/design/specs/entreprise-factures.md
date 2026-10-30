# Spec design – Entreprise › Factures
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/entreprise/factures` · **Permission :** `invoices.read`
**Contrat :** `GET /v1/company/invoices` ; PDF asynchrone (à venir : statut « En préparation » puis téléchargement).

## 1. Objectif
Retrouver les factures des commandes validées et leur état de paiement. **Action principale :** aucune ; téléchargement d'une facture (quand le PDF est prêt).
## 2. Structure
`PageHeader` « Factures » ; `DataTable` (numéro, commande, date, total mis en avant, statut Payée / À payer) ; cartes sous `breakpoint.md`.
## 3. États
Squelette ; vide « Aucune facture » ; erreur + réessayer.
## 4. Textes
`company.invoices.*`.
