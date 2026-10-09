---
description: Lire une spec et proposer un plan d'implémentation avant de coder
argument-hint: <numéro ou nom de la spec, ex. 02-ledger>
---
Lis `docs/specs/$ARGUMENTS*.md`, le cahier des charges (`docs/cahier-des-charges.md`) et `CLAUDE.md`.
Propose un **plan d'implémentation** (ne code rien) :
1. Résumé de la spec en 5 lignes.
2. Fichiers à créer ou modifier.
3. Migrations de base de données nécessaires (nouvelles, jamais de modification d'une existante).
4. Liste des tests à écrire d'abord.
5. Risques de sécurité et d'argent à surveiller.
6. Découpage en petites PR.
Termine par les questions ouvertes (voir `docs/open-questions.md`). Attends ma validation.
