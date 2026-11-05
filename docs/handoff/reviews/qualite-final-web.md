# Revue qualité finale (web + API) — 2026-11-05

Verdict : **OK** (aucun Bloquant). Revue sur diff `edf19b2..HEAD`, mode économe : lint/typecheck/test/build non relancés (résultats fournis par le lead).

## Constats
[CONSTAT] Fichiers de service trop longs
Gravité : Moyenne
Fichier : apps/api/src/admin/admin.service.ts (1147 l.), apps/api/src/payouts/payouts.service.ts (965 l.; `executeDueBatches` ~176 l. à :778)
Problème : plusieurs responsabilités par classe (liste, approbation, lots, factures) ; `executeDueBatches` difficile à suivre et à tester.
Correctif : extraire les lots de règlement (batches) dans un service dédié et découper `executeDueBatches` en étapes nommées. Pas de refactor dans cette PR (règle 16) : ticket de suivi.

[CONSTAT] Formule de commission dupliquée dans les mocks
Gravité : Moyenne
Fichier : apps/web/src/mocks/db.ts:234 (`commissionOf`), :211 (`defaultRateOf`)
Problème : `commissionOf` réimplémente `rateOf` de packages/shared/fees.ts (en `Math.floor` flottant, non exact en BigInt) ; `defaultRateOf` réécrit `isDefaultTier`. Risque de divergence entre mocks et API.
Correctif : importer `rateOf` et `isDefaultTier` de `@flexipay/shared`.

[CONSTAT] Commentaire orphelin
Gravité : Basse
Fichier : apps/web/src/mocks/db.ts:200
Problème : le doc-comment « Commission in millimes… » est collé au-dessus de `defaultGrid` au lieu de `commissionOf` (:234).
Correctif : le déplacer.

[CONSTAT] Conversion Number(BigInt) sur montants
Gravité : Basse
Fichier : packages/shared/src/fees.ts:26, apps/api/src/platform/commission-grids.ts:21-22
Problème : retour en `number` sûr tant que MAX_AMOUNT_MILLIMES reste < 2^53 (borné par le schéma Zod) ; la contrainte n'est documentée qu'implicitement.
Correctif : ajouter une phrase au commentaire de `rateOf`.

## Points conformes
- Pas de `toFixed`/`parseFloat` hors du formateur unique `apps/web/src/lib/format/money.ts` (règle ESLint dédiée) ; aucun `any`, `@ts-ignore`, `console.log`, `TODO` dans le diff.
- Logique de grille unique dans packages/shared (`tierFor`, `commissionGridSchema`) réutilisée par l'API (`commission-grids.ts`) ; arrondi BigInt exact côté serveur.
- Pas de chaîne d'interface en dur repérée (clés i18n `t('…')`).

## Non vérifié
lint/typecheck/test/build et couverture (non relancés par consigne) ; pertinence détaillée des tests d'intégration ; `pdf.ts` lu seulement en volume (102 l., taille correcte) ; contenu complet de account-record.tsx (593 l., long mais en composants).
