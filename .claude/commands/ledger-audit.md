---
description: Auditer les invariants financiers du diff courant
argument-hint: [sujet ou liste de fichiers]
---
Utilise le sous-agent `ledger-auditor` sur `$ARGUMENTS` (par défaut : `git diff main...HEAD` ; sans dépôt git, la liste de fichiers fournie).
Lance toi-même les tests de concurrence et d'idempotence (`pnpm --filter api test ledger`) et transmets leur sortie au sous-agent : `ledger-auditor` n'a pas d'outil d'exécution (CF-07).
Enregistre le tableau dans `docs/handoff/reviews/ledger-<sujet>-<AAAA-MM-JJ>.md`.
Tout invariant ❌ part en `[CONSTAT]` à `backend` avec copie à `securite` (si l'équipe est active).
Présente le tableau des invariants (✅/❌/⚠️) puis le verdict `BLOQUANT` ou `OK`.
