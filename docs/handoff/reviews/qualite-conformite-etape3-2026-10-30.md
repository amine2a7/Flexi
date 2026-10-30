# Revue groupée étape 3 (Commerçant) : qualité et conformité, 2026-10-30

Verdict qualité : **OK avec réserves** (aucun Bloquant ; 3 Importants, 3 Améliorations).
Verdict conformité : **NON CONFORME (partiel)** : N3 non livré (décision bloquée), exécution Playwright non prouvée.

Revue statique uniquement (suites complètes non relancées sur consigne : API verte 110+, web 206).

## Qualité

[CONSTAT] Appels réseau sans `catch` dans le virement
Gravité : Important
Fichier : apps/web/src/app/[locale]/commercant/virements/page.tsx:90-102 et 108-126
Problème : `onSimulate` et `onRequest` n'ont que `try/finally`. Une erreur réseau (rejet du fetch) est une promesse rejetée non gérée (`void onSimulate`), sans message à l'écran ; l'encaissement, lui, a bien un `catch`.
Correctif proposé : ajouter `catch (reason) { setError(reason); }` comme dans `encaissement/page.tsx:102`.
Référence : critère 6 (erreurs avalées / états d'erreur).

[CONSTAT] Sondage du paiement : erreurs ignorées
Gravité : Important
Fichier : apps/web/src/app/[locale]/commercant/encaissement/page.tsx:69-73
Problème : `.then(...)` sans `.catch` : un rejet est non géré, et une erreur de réponse (`error` ignoré) laisse l'écran « en attente » sans signal jusqu'à l'expiration.
Correctif proposé : `.catch(() => undefined)` explicite avec commentaire (on réessaie au tick suivant) et affichage d'une erreur après N échecs.
Référence : critère 6.

[CONSTAT] Test de rejeu concurrent trop permissif
Gravité : Important
Fichier : apps/api/test/integration/payments.test.ts:635-641
Problème : `toBeGreaterThanOrEqual(1)` accepte « aucune réponse » pour l'un des deux appels sans vérifier l'autre (rejet 409 attendu ou même réponse ?). Le test passe même si les deux appels renvoient des corps différents mais un seul < 300. Le test « reused » utilise un `quoteId` aléatoire : il prouve la clé réutilisée, pas le rejeu avec corps différent d'une demande réelle.
Correctif proposé : asserter le statut de l'éventuel second appel (rejeu identique ou 409 documenté) et utiliser un second devis réel pour le corps différent.
Référence : critère 7 (pertinence des tests).

[CONSTAT] E2E virement : assertions faibles et sélecteur fragile
Gravité : Amélioration
Fichier : apps/web/e2e/merchant.spec.ts:28, 34-38
Problème : `expect(net).toMatch(/\d/)` n'a aucune valeur ; `getByRole('link', { name: /VIR-|Voir/ })` dépend d'un libellé ; `getByText(net, {exact})` sur la page détail peut aussi correspondre au brut si net = montant d'une autre ligne. Le test « net affiché = net viré » ne compare pas au net de la liste.
Correctif proposé : comparer au montant de la première ligne de la liste (colonne Net) puis au détail ; vérifier le format millimes attendu pour un brut de 100 TND avec un taux connu du mock.
Référence : critère 7.

[CONSTAT] Cast et taille
Gravité : Amélioration
Fichier : virements/page.tsx:75 (`status as Status`), page de 380 lignes
Problème : assertion `as` pour le filtre ; page qui mélange simulation, liste et colonnes. Logique d'état « montant + parse + aperçu » dupliquée avec l'encaissement.
Correctif proposé : type du FilterBar générique pour supprimer le cast ; extraire un champ `AmountField`/hook `useAmountInput` et le formulaire de simulation.
Référence : critères 3, 4, 5.

Points conformes : aucune couleur/espacement en dur, chaînes via i18n, montants par `formatMillimesWithCurrency` et `parseMillimes`, aucun calcul de commission côté front (simulation serveur, taux figé via `quoteId`), Idempotency-Key générée par intention, types issus du client généré, démo chargée uniquement hors production. Tests N4 écrits avant le code et assertions sur le ledger (comptage d'écritures, solde).

## Conformité

Demande : specs manquantes, écrans, N3, N4, Playwright.
- Specs : 8 présentes (`commercant-` tableau-de-bord, encaissement, encaissement-resultat, historique, creances, virement, reglements, mon-commerce) : CONFORME.
- Écrans : pages présentes pour tableau de bord, encaissement (succès/refus intégrés), historique (+ détail), créances, virements (+ détail, simulation, taux figé `expiresAt`), règlements, mon-commerce : CONFORME.
- N4 (tests de rejeu) : présent (paiement, virement, clé absente) : CONFORME. Le rejeu des autres routes financières (recharge, annulation, remboursement) n'est pas couvert, la description dit « every financial route » : écart mineur de commentaire ou de couverture.
- N3 (commission par paiement) : NON LIVRÉ. `decisions.md` ligne 74 : « [DÉCISION] N3 bloquée », en attente d'Amine ; aucun code. Écart ouvert, justifié par la règle « pas d'invention » mais la demande n'est pas satisfaite.
- Playwright : deux scénarios écrits (encaissement ; net simulé = net demandé), commit 57404f5. Exécution non prouvée (port 3000 occupé, noté au BOARD) : la preuve « net affiché = net viré » reste à obtenir.

## Commandes

`ls docs/design/specs/commercant-*`, `find .../commercant -name page.tsx`, `git log --oneline -5`, `grep N3 decisions.md` : résultats ci-dessus. Lint/typecheck/test/build non relancés (consigne).

## Non vérifié

Exécution Playwright ; build Next et taille des bundles ; couverture ; pages creances, historique, reglements, mon-commerce, tableau de bord (présence seulement, contenu non relu) ; fidélité aux specs.
