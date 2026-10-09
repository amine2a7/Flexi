---
description: Créer le squelette d'un module backend NestJS conforme aux règles
argument-hint: <nom-du-module>
---
Crée le module `$ARGUMENTS` dans `apps/api/src/modules/` :
- `controller` (routes protégées par défaut, rôles via décorateur), `service`, `dto` Zod, `repository`.
- Tests (squelette) dans le même dossier.
- Entrée dans le module racine.
- Événement d'audit pour chaque action sensible.
Respecte `CLAUDE.md`. Ne crée aucune migration sans me montrer le SQL.
