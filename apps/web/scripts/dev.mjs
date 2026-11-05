// Development server launcher (`pnpm dev`): the pages call the API only (NEXT_PUBLIC_API_BASE_URL,
// started by `pnpm demo` or `pnpm --filter @flexipay/api dev`); there is no mocked API any more.
// Runs with webpack (`--webpack` in package.json) while Turbopack's persistent cache crashes on
// this machine ("turbo-tasks: an internal panic occurred", 2026-10-17).
// Starts `next dev` WITHOUT the AI-agent environment variables: when it detects a coding agent,
// Next.js writes AGENTS.md / CLAUDE.md (instructions from a dependency, never reviewed) which
// agent tools then load automatically. Any stale copy is removed first (security review F1-S02).
import { spawn } from 'node:child_process';
import { rmSync } from 'node:fs';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const require = createRequire(import.meta.url);

for (const file of ['AGENTS.md', 'CLAUDE.md']) rmSync(join(root, file), { force: true });

const AGENT_ENV = /^(AI_AGENT|CLAUDE|CURSOR|GEMINI|CODEX|OPENCODE|DEVIN|COPILOT|REPL_ID|AUGMENT)/i;
const env = Object.fromEntries(
  Object.entries(process.env).filter(([name]) => !AGENT_ENV.test(name)),
);

// WEB_PORT: port of the dev server (3001 by default; the e2e suite uses its own, never 3000).
const child = spawn(
  process.execPath,
  [
    require.resolve('next/dist/bin/next'),
    'dev',
    '-p',
    process.env.WEB_PORT ?? '3001',
    ...process.argv.slice(2),
  ],
  { cwd: root, env, stdio: 'inherit' },
);

for (const signal of ['SIGINT', 'SIGTERM']) process.on(signal, () => child.kill(signal));
child.on('exit', (code) => {
  process.exit(code ?? 0);
});
