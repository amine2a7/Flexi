#!/usr/bin/env bash
# PreToolUse (Bash) : la logique est dans guard-bash.js (S1-01, S1-02, CF-09).
exec node "$CLAUDE_PROJECT_DIR/.claude/hooks/guard-bash.js"
