# Spec design – Entreprise › Attribuer des crédits
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/entreprise/attribution` · **Permission :** `credits.allocate`
**Contrat :** `POST /v1/company/allocations` (Idempotency-Key), `POST /v1/company/allocation-imports/previews`.

## 1. Objectif
Répartir les crédits du portefeuille d'un type entre des employés, à la main ou par fichier. **Action principale :** « Attribuer » (confirmation avec le total).
## 2. Structure
1. `PageHeader` « Attribuer des crédits » ; solde disponible du type choisi (mis en avant).
2. Choix du type de crédit ; recherche d'employés ; sélection (page) ; montant par employé ; total sélectionné.
3. Import CSV d'attributions : analyse, lignes en erreur, totaux par type, confirmation.
4. Confirmation (`ConfirmDialog`) : nombre d'employés, total ; succès persistant.
## 3. États
Solde insuffisant (message, bouton désactivé avec raison), employé suspendu ou désactivé (refus 409 expliqué), vide (aucun employé actif), erreur + réessayer.
## 4. Textes
`company.allocation.*`. Montants entiers en millimes, total affiché tel que calculé côté serveur à la confirmation.
