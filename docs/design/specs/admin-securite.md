# Spec design – Administrateur › Sécurité & conformité
**Statut :** écrite et codée en mode continu (2026-10-30) · **Auteur :** lead · **Route :** `/admin/securite` · **Permission :** `risk.read` (super-admin, Opérations ; décision C)
**Contrat :** `GET /v1/admin/fraud-alerts`, `GET /v1/admin/disputes` (contrat 0.6.0, routes prévues : données de démonstration MSW tant que l'API ne les sert pas).

## 1. Objectif
Voir les alertes de fraude (paiements trop rapprochés, montant inhabituel, refus répétés, PIN bloqué à répétition) et les litiges ouverts. **Lecture seule** : le traitement arrive avec le module litiges (N2, test d'abord), annoncé par un bandeau d'information.
## 2. Structure
`PageHeader` ; bandeau `Alert info` ; `Tabs` « Alertes de fraude » / « Litiges » ; `DataTable` par onglet (alerte : type, concerné, gravité, date, statut ; litige : paiement, commerçant, montant mis en avant, motif, date, statut). Gravité et statut en badges (icône + texte, couleurs de la charte : élevée = danger, moyenne = attention, faible = information).
## 3. États
Squelette, vide (« Aucune alerte », « Aucun litige »), erreur + réessayer ; sans `risk.read` : « Accès refusé ».
## 4. À confirmer par Amine
Règles de détection des alertes (seuils), circuit de clôture d'une alerte (motif journalisé) et de résolution d'un litige (écriture corrective, double validation ?).
