#!/usr/bin/env bash
# PostToolUse (Edit|Write|MultiEdit) : formate le fichier modifié.
input=$(cat)
file=$(echo "$input" | node "$CLAUDE_PROJECT_DIR/.claude/hooks/lib/json-get.js" tool_input.file_path)
[ -z "$file" ] && exit 0
case "$file" in
  *.ts|*.tsx|*.js|*.json|*.md|*.css) npx --no-install prettier --write "$file" >/dev/null 2>&1 || true ;;
  *.dart) dart format "$file" >/dev/null 2>&1 || true ;;
esac
exit 0
