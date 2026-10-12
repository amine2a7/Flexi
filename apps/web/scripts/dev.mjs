// Development server launcher (`pnpm dev`).
// 1. Copies the MSW service worker into public/ (git-ignored; removed by `pnpm build`).
// 2. Starts `next dev` WITHOUT the AI-agent environment variables: when it detects a coding agent,
//    Next.js writes AGENTS.md / CLAUDE.md (instructions from a dependency, never reviewed) which
//    agent tools then load automatically. Any stale copy is removed first (security review F1-S02).
import { spawn } from 'node:child_process';
import { rmSync } from 'node:fs';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const require = createRequire(import.meta.url);

await import('./sync-mock-worker.mjs');

for (const file of ['AGENTS.md', 'CLAUDE.md']) rmSync(join(root, file), { force: true });

const AGENT_ENV = /^(AI_AGENT|CLAUDE|CURSOR|GEMINI|CODEX|OPENCODE|DEVIN|COPILOT|REPL_ID|AUGMENT)/i;
const env = Object.fromEntries(
  Object.entries(process.env).filter(([name]) => !AGENT_ENV.test(name)),
);

const args = process.argv.slice(2);
const child = spawn(
  process.execPath,
  [require.resolve('next/dist/bin/next'), 'dev', '-p', '3001', ...args],
  { cwd: root, env, stdio: 'inherit' },
);

for (const signal of ['SIGINT', 'SIGTERM']) process.on(signal, () => child.kill(signal));
child.on('exit', (code) => {
  process.exit(code ?? 0);
});
