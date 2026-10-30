# Revue UX et fidélité design – Étape 3, espace Commerçant (web) – 2026-10-30

Base : lecture du code (pas de navigateur) de `encaissement/page.tsx`, `virements/page.tsx`, `commercant/page.tsx` et des sections 1 à 6 des 4 specs.
**Verdict : À REVOIR** (aucun Bloquant, 5 Majeurs).

## Majeurs
1. **Annulation sans retour d'erreur** – `encaissement/page.tsx:120,166,208`. Si l'annulation échoue, `setError` n'est pas visible (le formulaire est masqué pendant l'attente) et le dialogue se ferme. Le commerçant croit avoir annulé. Correctif : bandeau d'erreur dans la vue d'attente, dialogue ouvert tant que l'issue n'est pas connue. Réf. Nielsen 1 et 9.
2. **Annulation sans `Idempotency-Key`** – `:113-116`. La spec (resultat §6) l'exige. Correctif : clé par intention d'annulation.
3. **Attente perdue au rechargement** – `:50,166`. L'état vit en mémoire, la spec prévoit `/collect/payments/{id}`. Un F5 pendant l'attente ramène un formulaire vide, d'où un risque de double encaissement. Les erreurs de lecture du polling sont avalées (`:69-73`). Il n'y a ni « Impossible de vérifier l'état » ni gestion du délai dépassé. Les statuts autres que CONFIRMED et REFUSED (annulé, expiré) retombent sur le formulaire sans message. Correctif : route par identifiant, bandeau non bloquant en cas d'erreur de lecture, état « Annulé » ou « Délai dépassé ».
4. **Taux figé sans suite à l'échéance** – `virements/page.tsx:105-127,236`. L'échéance est affichée (`expiresAt`, bien), mais rien ne marque la simulation expirée ni n'ouvre la modale « taux changé ». `PAYOUT_QUOTE_CHANGED`, `PAYOUT_BELOW_MINIMUM` et `PAYOUT_EXCEEDS_AVAILABLE` passent par le message générique (`:116,298`), sans ancienne/nouvelle simulation ni seuil chiffré. Correctif : masquer la simulation à l'échéance (« Simulation à actualiser »), traiter les 3 codes avec leurs `details`, jamais de resoumission automatique.
5. **Sous-rôles mal gérés sur le tableau de bord** – `commercant/page.tsx:51-70,53,34`. Le TodoPanel de virement et `receivablesMillimes` (champ non optionnel) sont montrés au caissier, qui est renvoyé vers une page interdite. La spec veut une carte absente si le champ est absent. Le comptable n'a aucune action principale, alors que la spec prévoit « Demander un virement ». Correctif : conditionner le panneau à `payouts.request`, accepter les champs absents, ajouter l'action pour le comptable.

## Mineurs
- `encaissement:261-267` : la note `ruleNote` affiche le taux de commission à l'encaissement, alors que la spec dit « pas de commission affichée » (RG-1.5). À soumettre en `[DÉCISION]` à `main`.
- `:254-256` : bouton « Encaisser » désactivé sans raison ni erreur de format du code (spec : `errors.field.invalidFormat`). Le bouton principal est `primary` par défaut, pas `accent`. Sur l'écran de résultat, « Nouvel encaissement » est `secondary`, il n'y a pas de principal, ni « Imprimer le reçu » ni « Voir l'historique ».
- `:33-34` : `POLL_MS` et `VALIDITY_SECONDS` sont en dur. Utiliser `UI.pollIntervalMs` ou la valeur fournie par l'API (`expiresAt`).
- `virements:251,306` : sans `payouts.request`, la carte de simulation disparaît sans raison écrite. Après la demande, l'alerte et le toast font doublon et aucun lien ne mène au suivi (frise) ; seule la table l'offre. Les erreurs sont en bas de colonne sur mobile, sans focus ni `role="alert"` vérifié.
- `virements:214-249` : les 3 StatCards dupliquent l'`AmountBreakdown`. Le net n'est pas plus saillant que « disponible ». Le type de crédit par défaut `RESTAURATION` peut ne pas être accepté tant que le profil charge. L'erreur de chargement des créances reste en « en attente » sans fin.
- `commercant/page.tsx:85,151` : liens `text-navy underline` sans cible de 44 px. Pas de période, ni carte réglé, commission ou panier moyen, ni montant du prochain règlement, ni état vide « Bienvenue » (écart avec la spec ; choix de périmètre à confirmer).

## Points conformes
Montants entiers en millimes via `Amount` et `formatMillimesWithCurrency`. Brut, commission (avec taux) puis net en total via `AmountBreakdown`. Confirmation avec récapitulatif et net dans le libellé du bouton. Refus générique sans motif, ni solde, ni « Réessayer ». Aucun hex ni px en dur (tokens `size-*`, `text-*`, `rounded-*`). RTL : `dir="ltr"` sur code et montant, chevrons en miroir, `text-start`. Les états chargement, erreur et vide existent sur les listes.

## User stories proposées
Aucune.

## Non vérifié
Rendu réel (navigateur, 360 px, zoom 200 %, clavier, lecteur d'écran), textes i18n FR/AR/EN, contrôle de permission de la page d'encaissement par le layout, composants `ConfirmDialog` et `Countdown` (piège de focus, expiration).
