# PR feat/web → main : terminer l'espace web

## Objectif
Terminer la partie web de FlexiPay (Administrateur, Entreprise, Commerçant) sur l'API réelle, avec les décisions des 2026-11-02, 03 et 04 : litiges, grilles de commission, TVA et timbre, lots J+2 avec banque simulée, factures PDF. L'API du mobile n'est pas dans ce périmètre.

## Contenu
**Commun :** landing et connexion « carnet de tickets » (« Composter mon ticket », tampon, arabe vérifié).
**Argent (API) :**
- litiges N2 v3 : virement retenu, plusieurs litiges, commission et sa TVA annulées, dette déduite au règlement, contrôle des blocages ;
- grilles de commission par entreprise et par commerçant (tranches à bornes incluses, ligne par défaut obligatoire, migration des profils) ;
- commission, TVA 19 % sur la commission arrondie et timbre 1 DT, figés et écrits sur des comptes séparés ;
- R2 : alerte quotidienne en cas d'écart du grand livre ;
- lots libérés par Finance en double validation, ordre à une banque simulée derrière une interface, retour bancaire et rapprochement ;
- factures PDF.

**Administrateur :**
- écrans Sécurité sur l'API réelle (litiges, alertes) ;
- fenêtre « Commission » à l'étape 2 de la création ;
- fiches entreprise et commerçant modifiables à tout moment, avec historique, grille et RIB en double validation ;
- page Grilles de commission, libération des lots, paramètres TVA, timbre et seuil.

**Entreprise :** simulation de commande détaillée, factures PDF.

**Commerçant :** simulation de virement détaillée, facture de commission, bouton « Redemander ».

**Contrat :** OpenAPI 0.8.0 → 0.13.0, client régénéré. **Migrations :** 0023 à 0030 (aucune migration existante modifiée).

## Tests (dernière passe, 2026-11-05)
- `pnpm lint`, `pnpm typecheck` et `pnpm test` : verts ;
- intégration API : 171 tests, tous verts après l'ajustement de 3 attentes de test ;
- builds API et web : OK ;
- e2e sur l'API réelle (connexion, Sécurité, fenêtre Commission et simulations) : 9/9 ;
- seed : grand livre rapproché.

## Revues
- securite (N2, grilles) : OK.
- ledger-auditor (N2, TVA et timbre) : OK, Moyennes corrigées.
- design et qualite : OK avec réserves.
- ux : OK.
- conformite : interrompue par la limite d'usage, à relancer.
- Aucun constat Critique ni Haute ouvert.

## Risques
- 4 vulnérabilités modérées dans les dépendances de production (`qs`, `glob`, `minimatch`) : leur montée de version est à valider.
- `pages-sweep` est toujours bloqué sous MSW.
- `/audit-acces` complet n'a pas été relancé.
- Les factures sont générées à la demande ; le PDF n'est pas disponible en arabe.
- Les e-mails sont simulés.

## Décisions à confirmer
- Montants de la commande recalculés à la création (et non repris du devis).
- Repli de la migration 0025 : grille au taux du premier type accepté par le commerçant.
- Banque simulée : un IBAN finissant par 0000 est rejeté.
- Notification envoyée dans la transaction (fichier simulé).
- Rejet bancaire : virement contre-passé et redemandé.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
