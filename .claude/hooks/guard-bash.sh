#!/usr/bin/env bash
# PreToolUse (Bash) : détecte les secrets avant commit et bloque les commandes destructrices sur le ledger.
input=$(cat)
cmd=$(echo "$input" | node "$CLAUDE_PROJECT_DIR/.claude/hooks/lib/json-get.js" tool_input.command)
[ -z "$cmd" ] && exit 0

if echo "$cmd" | grep -qE 'git commit'; then
  if command -v gitleaks >/dev/null 2>&1; then
    if ! gitleaks protect --staged --no-banner >&2; then
      echo "Bloqué : secret détecté dans les fichiers indexés (gitleaks)." >&2
      exit 2
    fi
  fi
fi

# Aide uniquement (CF-09) : la vraie barrière reste les triggers et les rôles PostgreSQL (SEC-P4).
# Couvre UPDATE, DELETE FROM, TRUNCATE [TABLE], DROP TABLE [IF EXISTS], ALTER TABLE [IF EXISTS],
# la clause ONLY, le schéma public et les identifiants entre guillemets (échappés ou non).
q='\\?"?'
ledger_re="(update|delete[[:space:]]+from|truncate([[:space:]]+table)?|drop[[:space:]]+table([[:space:]]+if[[:space:]]+exists)?|alter[[:space:]]+table([[:space:]]+if[[:space:]]+exists)?)([[:space:]]+only)?[[:space:]]+(${q}public${q}\.)?${q}(ledger_entries|transactions|audit_log)\b"
if echo "$cmd" | grep -qiE "$ledger_re"; then
  echo "Bloqué : le ledger et le journal d'audit sont immuables (contre-passation uniquement)." >&2
  exit 2
fi
exit 0
