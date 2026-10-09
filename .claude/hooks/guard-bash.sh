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

if echo "$cmd" | grep -qiE '(update|delete[[:space:]]+from|truncate|drop[[:space:]]+table)[[:space:]]+(public\.)?(ledger_entries|transactions|audit_log)'; then
  echo "Bloqué : le ledger et le journal d'audit sont immuables (contre-passation uniquement)." >&2
  exit 2
fi
exit 0
