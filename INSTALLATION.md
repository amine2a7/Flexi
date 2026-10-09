# Installation du kit

1. Créer le dépôt Git (privé) et copier **tout** le contenu de ce dossier à la racine (`CLAUDE.md`, `.claude/`, `docs/`, `.gitignore`, `.env.example`).
2. Installer les prérequis : Node 20+ (nécessaire aux hooks), `gitleaks`, pnpm, Docker, Flutter SDK.
3. Rendre les hooks exécutables : `chmod +x .claude/hooks/*.sh`.
4. Ouvrir le dépôt dans Claude Code et lancer `/help` pour vérifier que les commandes `/spec-plan`, `/write-tests`, `/security-review`, `/ledger-audit`, `/new-module`, `/design-check`, `/release-check` sont listées, et `/agents` pour les 7 agents (`securite`, `design`, `backend`, `frontend`, `mobile`, `ledger-auditor`, `test-writer`).
5. Vérifier les permissions avec `/permissions` (le fichier `.claude/settings.json` est partagé avec l'équipe ; les réglages personnels vont dans `.claude/settings.local.json`, ignoré par Git).
6. Premier prompt : « Lis `docs/roadmap.md` et propose le plan de la phase 0 ».
7. Ajouter les exports Figma dans `docs/design/` quand ils existent.

**Rappels :** les hooks nécessitent Node. Protocole de l'équipe d'agents : `docs/handoff/README.md`. Adaptez les commandes `pnpm` de `CLAUDE.md` à vos vrais scripts une fois le monorepo créé. Les points juridiques et bancaires de `docs/open-questions.md` restent à trancher avec un juriste et la banque.
