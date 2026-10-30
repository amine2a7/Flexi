# Spec design – Entreprise › Importer des employés (CSV)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Route :** `/entreprise/employes/import` · **Permission :** `employees.manage`
**Contrat :** `POST /v1/company/employees/import-previews` (analyse), `POST /v1/company/employees/imports` (création des lignes valides).

## 1. Objectif
Créer des employés en masse à partir d'un fichier CSV, en voyant les erreurs et doublons avant de créer. **Action principale :** « Analyser le fichier » puis « Créer les employés valides ».
## 2. Structure
1. `PageHeader` « Importer des employés » + retour à la liste.
2. Étape 1 : `FileDrop` (CSV, taille maximale annoncée), aide sur les colonnes attendues.
3. Étape 2 : résumé (valides, erreurs, doublons) puis tableau des lignes en erreur (ligne, problèmes) ; bouton de création des seules lignes valides.
4. Fin : nombre d'employés créés (invitation envoyée), retour à la liste.
## 3. États
Analyse en cours, fichier refusé (format, taille), aucune ligne valide (bouton absent, raison écrite), erreur API + réessayer.
## 4. Textes
`company.import.*`. Les adresses déjà inscrites ne sont jamais révélées (S04).
