#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit) : bloque les fichiers sensibles et les migrations existantes.
# Nécessite node. Code de sortie 2 = blocage, le message stderr est renvoyé à Claude.
input=$(cat)
file=$(echo "$input" | node "$CLAUDE_PROJECT_DIR/.claude/hooks/lib/json-get.js" tool_input.file_path)
[ -z "$file" ] && exit 0

case "$file" in
  *.env.example) exit 0 ;;
  *.env|*.env.*|*/secrets/*|*.pem|*.key)
    echo "Bloqué : fichier sensible ($file). Ne pas le modifier." >&2
    exit 2 ;;
esac

case "$file" in
  */prisma/migrations/*|*/db/migrations/*)
    if [ -f "$file" ]; then
      echo "Bloqué : les migrations existantes sont immuables. Créez une nouvelle migration." >&2
      exit 2
    fi ;;
esac
exit 0
