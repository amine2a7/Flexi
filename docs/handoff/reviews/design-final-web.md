# Revue de fidélité design – web final (depuis edf19b2) – 2026-11-05

Verdict : **OK avec réserves** (aucun Bloquant, aucune Haute).
Portée (mode économe) : commission-grid-editor, account-form, account-record, pdf-download, amount, parité i18n admin.
Non relus en détail : pages reglements/commissions/securite/virements/commandes (seulement grep tokens/RTL/chaînes en dur : rien).

## Vérifié, conforme
- Tokens : aucune couleur hex, `[px]`, `ml/mr/pl/pr/left/right`, `text-left/right` dans components/admin, ui/amount et les pages listées.
- Composants existants réutilisés (Button, TextField, Card, AmountBreakdown, StatusBadge, Toast).
- Cibles tactiles : Button `sm` = `min-h-touch-target-mobile` (mobile) / `touch-target-min` (desktop) ; bouton icône suppression avec `aria-label` i18n.
- RTL : champs numériques/e-mail/téléphone en `dir="ltr"`, mise en page en grid/flex logique.
- i18n : admin.json FR/AR/EN, 0 clé manquante vs FR ; aucune chaîne en dur détectée dans les fichiers prioritaires.
- Montants : `Amount`/`AmountBreakdown`, `tabular-nums`, total en `font-semibold` (TVA, timbre, net listés).

## Constats
- [Moyenne] commission-grid-editor.tsx:222 : valeurs de repli en dur (TVA 1 900 bps, timbre 1 000 millimes) quand /v1/admin/settings n'a pas répondu. Règle métier dupliquée dans l'UI, aperçu potentiellement faux. Correction : n'afficher l'aperçu qu'une fois les réglages chargés (squelette/erreur sinon), ou lire une constante de `@flexipay/shared`.
- [Basse] commission-grid-editor.tsx:146 : `sm:grid-cols-4` ; bouton supprimer aligné `items-end` mais sans libellé visible. OK a11y (aria-label), mais vérifier visuellement l'alignement avec hint « toHint » (le champ « À » est plus haut).
- [Basse] commission-grid-editor.tsx:189 : erreur de ligne en `role="alert"` ; ajouter un lien `aria-describedby` vers les champs concernés.
- [Basse] pdf-download.tsx:28-34 : pas d'annonce lecteur d'écran du succès (le toast n'est utilisé que pour l'erreur) ; ajouter un toast de succès ou `aria-live`.
- [Basse] commission-grid-editor.tsx:136 : `<h3>` sans `<h2>` garanti dans la fenêtre ; vérifier la hiérarchie des titres dans le dialogue.

## À vérifier dans le navigateur
Contraste et rendu AR (tableau lignes TVA/timbre), focus clavier dans la fenêtre Commission, 375 px (cartes au lieu de tableaux sur la fiche compte).
