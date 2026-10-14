// Applies the pending migrations (prisma migrate deploy) as the owner of the database.
import { spawnSync } from 'node:child_process';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const API_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');

export async function runMigrations(): Promise<void> {
  const require = createRequire(import.meta.url);
  const cli = join(dirname(require.resolve('prisma/package.json')), 'build', 'index.js');
  const result = spawnSync(process.execPath, [cli, 'migrate', 'deploy'], {
    cwd: API_ROOT,
    stdio: 'inherit',
    env: process.env,
  });
  if (result.status !== 0) throw new Error('prisma migrate deploy failed');
  await Promise.resolve();
}

if (process.argv[1] !== undefined && fileURLToPath(import.meta.url) === process.argv[1]) {
  await runMigrations();
}
