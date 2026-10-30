# Spec design – Commerçant › Statistiques
**Statut :** écrite et codée en mode continu (2026-10-30) · **Auteur :** lead · **Route :** `/commercant/statistiques` · **Permission :** `stats.read` (gérant, comptable du commerce ; jamais le caissier)
**Contrat :** `GET /v1/merchant/dashboard` (`monthlyFlows`, `monthByCreditType`, KPI du jour). Aucun calcul d'argent côté web.

## 1. Objectif
Suivre l'activité sur plusieurs mois : encaissé (brut) et réglé (net) par mois, répartition du mois par type de crédit. **Action principale :** aucune (consultation).

## 2. Structure
1. `PageHeader` « Statistiques » · « Vos encaissements et vos règlements des derniers mois. »
2. Quatre `StatCard` : encaissé aujourd'hui (montant mis en avant + nombre de paiements), créances à régler, prochain règlement (date), taux de commission (« Aucun » si nul).
3. `BarChart` « Encaissé et réglé par mois » (2 séries, légende texte + pastille, valeurs formatées en TND) et `CreditTypeBreakdown` « Par type de crédit ».

## 3. États
Chargement : `LoadingBlock` · Erreur : `ErrorState` + « Réessayer » · Vide (aucun flux) : `EmptyState` « Pas encore de statistiques » · « Elles apparaîtront après vos premiers encaissements. »

## 4. Textes, RTL, accessibilité
Clés `merchant.statistics.*` (FR/AR/EN). Graphique avec titre et légende textuelle (jamais la couleur seule) ; montants `Amount`, isolés `ltr` ; grille 1 colonne sous `breakpoint.lg`.

## 5. À confirmer par Amine
Sélecteur de période (mois, trimestre, année) : non prévu par le contrat actuel (6 derniers mois fournis par l'API).
