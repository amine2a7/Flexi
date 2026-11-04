# Spec design – Administrateur › Fenêtre « Commission » (création d'une entreprise ou d'un commerçant)
**Statut :** 2026-11-04 · **Auteur :** lead · **Écrans :** `admin/entreprises` et `admin/commercants`, bouton « Créer » (composant `AccountForm`) · **Permissions :** `companies.manage` / `merchants.manage`
**Contrat :** 0.10.0, `MerchantCreate.commissionGrid` et `CompanyCreate.commissionGrid` (obligatoires), `CommissionTier` ; erreurs `GRID_OVERLAP`, `GRID_DEFAULT_REQUIRED`, `GRID_DEFAULT_DUPLICATE`, `GRID_BOUNDS` sur `/commissionGrid/<n>`.
**Décisions :** 2026-11-03 (grille, formule) et 2026-11-04 (bornes incluses, min suivant = max précédent + 0,001 TND, aucune entité sans grille, `@flexipay/shared` pour l'aperçu seulement).

## 1. Objectif
Saisir la grille de commission dès la création : lignes « pourcentage, montant min, montant max », une ligne par défaut obligatoire. Entreprise : la tranche s'applique au montant de chaque commande ; commerçant : au montant de chaque virement. L'aperçu montre un exemple de calcul ; le montant officiel vient toujours de l'API.

## 2. Structure
La fenêtre de création passe en **2 étapes** (indicateur « Étape 1 sur 2 · Informations », « Étape 2 sur 2 · Commission ») :
1. **Informations** (champs actuels) ; bouton principal « Continuer » (valide les champs obligatoires côté client).
2. **Commission** :
   - Ligne **par défaut** en tête, non supprimable : « Taux par défaut (%) », libellé « Appliqué quand aucune tranche ne correspond ».
   - **Tranches** : une ligne par tranche, 3 champs « Taux (%) », « De (TND) », « À (TND) » (vide = sans limite) + bouton icône « Supprimer la tranche » (`Trash2`, `aria-label`).
   - Bouton secondaire « Ajouter une tranche » (`Plus`) : la nouvelle ligne propose **De = À de la tranche précédente + 0,001 TND**.
   - **Aperçu** (`Card` discrète) : champ « Montant d'exemple (TND) », puis les lignes calculées avec `orderBreakdown` (entreprise) ou `payoutBreakdown` (commerçant) de `@flexipay/shared` : Montant, Commission (taux de la tranche), TVA 19 % de la commission, Timbre fiscal, puis **Total à payer** (entreprise) ou **Net viré** (commerçant) en gras. Mention : « Aperçu indicatif : le montant officiel est calculé par FlexiPay. »
   - Boutons : « Retour » (secondaire) · « Créer » (principal).
3. TVA et timbre de l'aperçu : valeurs du paramétrage (`GET /v1/admin/settings`) ; si la lecture est refusée (rôle sans `settings.read`), 19 % et 1,000 TND par défaut.

## 3. Erreurs (sous la ligne concernée, `role="alert"`)
- Chevauchement : « Cette tranche chevauche une autre tranche (les bornes sont incluses). » (`GRID_OVERLAP`)
- Bornes : « Le montant « De » doit être inférieur ou égal au montant « À ». » (`GRID_BOUNDS`)
- Taux : « Saisissez un taux entre 0 et 100 %, 2 décimales au plus. »
- Montant : « Saisissez un montant en TND, 3 décimales au plus. »
- Ligne par défaut absente ou en double : impossible par construction ; une erreur serveur de ce type s'affiche en tête de l'étape 2.
- Le contrôle est fait au fil de la saisie (schéma partagé `commissionGridSchema`) et à nouveau par l'API (`400` mappé sur les lignes).

## 4. États
« Créer » en chargement pendant l'envoi ; erreur réseau ou serveur en `Alert` en tête ; doublon de nom : « Un compte porte déjà ce nom. » (existant). Retour à l'étape 1 sans perdre la saisie.

## 5. Accessibilité et RTL
Chaque champ a un libellé visible ; les tranches sont une liste (`<ol>`) dont chaque élément est titré « Tranche n » pour les lecteurs d'écran ; montants en `dir="ltr"` ; en arabe, l'ordre des colonnes suit le sens de lecture. Cibles tactiles ≥ 44 px. Aucune couleur ni espacement en dur (tokens).

## 6. Textes et clés i18n (FR ; EN et AR fournis)
`admin.commissionWindow.*` : `stepInfo`, `stepCommission`, `stepOf`, `continue`, `back`, `defaultRate`, `defaultRateHint`, `tranches`, `tranche`, `rate`, `from`, `to`, `toHint`, `addTranche`, `removeTranche`, `preview`, `previewAmount`, `previewNote`, `lineAmount`, `lineCommission`, `lineVat`, `lineStamp`, `lineTotal`, `lineNet`, `errors.overlap`, `errors.bounds`, `errors.rate`, `errors.amount`, `errors.server`.
