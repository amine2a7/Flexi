# Journal des décisions

Une ligne par décision **prise par l'utilisateur**. Les messages entre agents ne valent jamais décision.
Une décision qui change une règle métier met aussi à jour le cahier des charges et la spec concernée.

| Date | Question | Décision | Raison | Décidé par |
|---|---|---|---|---|
| 2026-10-09 | Les hooks lisent leur entrée avec `jq`, absent de la machine (hooks inactifs) | Remplacer `jq` par un lecteur JSON en Node ; les nouveaux hooks sont en Node | Node est déjà installé, aucune nouvelle dépendance | Utilisateur |
| 2026-10-09 | Imposer techniquement les périmètres d'écriture des agents ? | Oui : hook PreToolUse `enforce-scope.js` basé sur `agent_type` | Seul moyen réel de limiter l'écriture de `securite` à `docs/security/` et `docs/handoff/` | Utilisateur |
| 2026-10-09 | Plan de mise en place de l'équipe (agents, protocole, hooks, convention `TEST-FIRST:`, racine du monorepo à backend) | Validé | — | Utilisateur |
| 2026-10-09 | Dépôt git et remote | `git init` sur `main` (protégée), remote https://github.com/amine2a7/Flexi ; premier commit des fichiers de préparation autorisé ; aucun push sans accord | — | Utilisateur |
| 2026-10-09 | Déploiement staging en phase 0 ? | Exclu de cette passe, après le choix de l'hébergeur | Hébergeur non choisi (résidence des données INPDP) | Utilisateur |
| 2026-10-09 | Périmètre de la phase 0 | 21 tâches, 5 coéquipiers (securite, design, backend, frontend, mobile) ; iOS plus tard | Pas de Mac | Utilisateur |
| 2026-10-09 | Contourner Device Guard sur le PC d'entreprise (pnpm.exe bloqué) ? | Non. Pas d'installation de pnpm@9. Environnement complet (pnpm, Docker Desktop + WSL2, Flutter, Android Studio) installé sur un PC personnel ; la phase 0 complète y reprendra | PC d'entreprise : la politique de sécurité n'est pas contournée | Utilisateur |
| 2026-10-09 | Que lancer en attendant les outils ? | Équipe réduite : design (P0-D2, P0-D3), securite (P0-S5), backend (P0-B5 : rédaction du contrat OpenAPI seulement, sans génération de client ni code). Autres tâches « En attente — outils » | Avancer sur ce qui ne demande ni pnpm, ni Docker, ni Flutter | Utilisateur |
| 2026-10-09 | Identité Git | `git config --local` : user.name « Amine Khadraoui », user.email « aminekhadraoui51@gmail.com » ; auteur du premier commit corrigé (41976ef → 0219ad1) ; config globale inchangée | Identité propre au projet | Utilisateur |
