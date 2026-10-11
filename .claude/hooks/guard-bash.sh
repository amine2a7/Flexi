#!/usr/bin/env bash
# PreToolUse (Bash) : détecte les secrets avant commit et bloque les commandes destructrices sur le ledger.
input=$(cat)
cmd=$(echo "$input" | node "$CLAUDE_PROJECT_DIR/.claude/hooks/lib/json-get.js" tool_input.command)
[ -z "$cmd" ] && exit 0

# Commit détecté aussi sous les formes « git -C dir commit », « git -c k=v commit », espaces multiples (S9-02).
commit_re='(^|[;&|(`[:space:]])git([[:space:]]+-[cC][[:space:]]*[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)'
if echo "$cmd" | grep -qE "$commit_re"; then
  # gitleaks ne scanne que l'index : refuser ce qui commit hors index ou saute la vérification (S9-02).
  set -f
  for tok in $cmd; do
    case "$tok" in
      --all|--include|--only|--no-verify|-i|-o|-n)
        echo "Bloqué : « $tok » sur git commit contourne le scan de l'index. Indexe avec git add puis commit sans cette option." >&2
        exit 2 ;;
      --*) ;;
      -[a-zA-Z]*)
        if [[ "$tok" =~ ^-[a-zA-Z]+$ ]] && [[ "$tok" == *a* || "$tok" == *n* ]]; then
          echo "Bloqué : « $tok » sur git commit (-a ou -n) contourne le scan de l'index. Indexe avec git add puis commit sans cette option." >&2
          exit 2
        fi ;;
    esac
  done
  set +f
  # Échec fermé (CF-02) : pas de commit sans scan de secrets.
  if ! command -v gitleaks >/dev/null 2>&1; then
    echo "Bloqué : gitleaks est introuvable, le commit est refusé sans scan de secrets (échec fermé)." >&2
    echo "Installe gitleaks (voir docs/handoff/README.md §14), ou laisse l'utilisateur commiter lui-même après vérification." >&2
    exit 2
  fi
  if ! gitleaks protect --staged --no-banner >&2; then
    echo "Bloqué : secret détecté dans les fichiers indexés (gitleaks)." >&2
    exit 2
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
