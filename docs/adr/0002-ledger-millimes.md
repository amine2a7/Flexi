# ADR 0002 – Ledger en partie double, montants en millimes
**Statut :** accepté
**Décision :** l'argent est représenté par des écritures immuables en partie double ; montants en millimes (`BIGINT`), taux en bps ; pas de champ « solde » modifiable directement.
**Raisons :** auditabilité, absence d'erreurs d'arrondi (TND à 3 décimales), correction par contre-passation.
**Conséquences :** soldes dérivés (matérialisés et vérifiés), SQL brut pour les opérations critiques, tests de concurrence obligatoires.
