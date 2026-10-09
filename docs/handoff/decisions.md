# Journal des décisions

Une ligne par décision **prise par l'utilisateur**. Les messages entre agents ne valent jamais décision.
Une décision qui change une règle métier met aussi à jour le cahier des charges et la spec concernée.

| Date | Question | Décision | Raison | Décidé par |
|---|---|---|---|---|
| 2026-10-09 | Les hooks lisent leur entrée avec `jq`, absent de la machine (hooks inactifs) | Remplacer `jq` par un lecteur JSON en Node ; les nouveaux hooks sont en Node | Node est déjà installé, aucune nouvelle dépendance | Utilisateur |
| 2026-10-09 | Imposer techniquement les périmètres d'écriture des agents ? | Oui : hook PreToolUse `enforce-scope.js` basé sur `agent_type` | Seul moyen réel de limiter l'écriture de `securite` à `docs/security/` et `docs/handoff/` | Utilisateur |
| 2026-10-09 | Plan de mise en place de l'équipe (agents, protocole, hooks, convention `TEST-FIRST:`, racine du monorepo à backend) | Validé | — | Utilisateur |
