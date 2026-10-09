---
description: Vérifier la fidélité d'un écran à la charte et aux tokens
argument-hint: <chemin du fichier ou de l'écran>
---
Fais relire `$ARGUMENTS` par l'agent `design` (coéquipier `design` actif : envoie-lui un `[LIVRÉ]` ; sinon, lance le sous-agent `design`).
Référence : `docs/design/specs/<ecran>.md`, `docs/design/charte-graphique.md`, `docs/design/design-tokens.json`.
Signale : couleurs/espacements/rayons en dur, contraste insuffisant (AA), cibles tactiles < 44 px (48 dp mobile), états manquants (chargement, vide, erreur, hors connexion, session expirée, solde insuffisant), chaînes non traduites, usage de gauche/droite en dur (RTL), montants non formatés selon la règle (montant gras + devise réduite), écarts avec la spec.
La revue est écrite dans `docs/handoff/reviews/design-<ecran>-<AAAA-MM-JJ>.md`, avec écarts (capture ou fichier:ligne) et verdict `OK` ou `[CONSTAT]`. Propose les corrections sans les appliquer.
