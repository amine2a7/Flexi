# Spec design – Entreprise › Tableau de bord
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/entreprise` · **Permission :** `balances.read`
**Contrat :** `GET /v1/company/dashboard`, `GET /v1/company/orders?status=AWAITING_PAYMENT` (à faire).

## 1. Objectif
Voir le portefeuille de crédits par type et ce qui attend une action. **Action principale :** « Commander des crédits » (si `orders.create`) ; secondaire « Attribuer » (si `credits.allocate`).
## 2. Structure
1. `PageHeader` « Votre portefeuille de crédits » + actions filtrées par permission.
2. `TodoPanel` : commandes à payer, preuves refusées (lien vers la commande).
3. Soldes par type (`CreditTypeBalanceCards`, montant mis en avant, icône + texte par type).
4. KPI (`StatCard`) : total du portefeuille (compteur animé, jamais négatif), attribué ce mois, employés actifs, commandes en cours.
5. `BarChart` crédité / attribué par mois et `ActivityList` des dernières commandes (montant + statut).
## 3. États
Squelette ; erreur + « Réessayer » ; vide (aucune commande) : message + action « Commander des crédits ».
## 4. Textes
Clés `company.dashboard.*` (FR/AR/EN). Montants `Amount`, `dir="ltr"` isolé.
