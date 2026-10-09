# Rapport — Préparation de l'équipe d'agents (2026-10-09)

## 1. Résumé
- 5 agents coéquipiers créés (`securite`, `design`, `backend`, `frontend`, `mobile`) ; `ledger-auditor` et `test-writer` conservés comme sous-agents.
- `security-reviewer` fusionné dans `securite`, `flutter-reviewer` fusionné dans `mobile`, puis supprimés.
- Protocole écrit dans `docs/handoff/README.md` et résumé dans `CLAUDE.md` (section « Équipe d'agents »).
- 3 hooks ajoutés (périmètres, TaskCompleted, TeammateIdle) ; les 3 hooks existants, inactifs faute de `jq`, fonctionnent à nouveau (Node).
- Aucun coéquipier lancé, aucune fonctionnalité métier, aucun commit (pas de dépôt git).

## 2. Fichiers
- `.claude/agents/` : `securite.md`, `design.md`, `backend.md`, `frontend.md`, `mobile.md` (créés) ; `ledger-auditor.md`, `test-writer.md` (section « Équipe » ajoutée) ; `security-reviewer.md`, `flutter-reviewer.md` (supprimés).
- `.claude/commands/` : `security-review.md`, `design-check.md`, `ledger-audit.md` (mis à jour).
- `.claude/hooks/` : `enforce-scope.js`, `task-completed.js`, `teammate-idle.js`, `lib/scopes.js`, `lib/json-get.js`, `lib/read-stdin-json.js` (créés) ; `protect-files.sh`, `guard-bash.sh`, `format.sh` (lecture JSON par Node au lieu de `jq`).
- `.claude/settings.json` : PreToolUse `enforce-scope`, `TaskCompleted`, `TeammateIdle`.
- `docs/handoff/` : `README.md`, `BOARD.md`, `decisions.md`, `contracts/`, `reviews/`, `reports/` ; `docs/design/specs/`.
- `CLAUDE.md`, `docs/README.md`, `docs/roadmap.md`, `docs/security/plan-incident.md` (références).

## 3. Vérifications
- Hooks testés sur entrées simulées : `enforce-scope` 23/23, `task-completed` 10/10, `teammate-idle` 12/12, hooks existants 13/13.
- `settings.json` : JSON valide. Frontmatter des 7 agents : valide, nom = fichier.
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` dans `settings.json` et dans l'environnement de la session.

## 4. Constats d'environnement
- `pnpm.exe` bloqué par la stratégie Device Guard de l'organisation (`node` et `npm` fonctionnent).
- Absents : `jq` (contourné), `flutter`, `dart`, `docker`, `gitleaks` ; pas de dépôt git.

## 5. Non vérifié (à confirmer au premier lancement d'équipe)
- `agent_type` présent dans l'entrée des hooks d'un coéquipier (sinon `enforce-scope` laisse passer : le cantonnement redevient une règle écrite).
- Possibilité pour un coéquipier (`backend`) de lancer les sous-agents `ledger-auditor` / `test-writer`.
- Format exact du transcript d'un coéquipier (`teammate-idle` lit les `tool_use` `SendMessage`).
