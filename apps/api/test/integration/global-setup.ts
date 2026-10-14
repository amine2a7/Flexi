import { spawnSync } from 'node:child_process';
import { join } from 'node:path';
import { loadTestEnv } from './setup.js';

/** Recreates flexipay_test (drop, create, migrate, app role) once before the integration suite. */
export default function setup(): void {
  loadTestEnv();
  if (process.env.PG_ADMIN_URL === undefined) {
    throw new Error('infra/.env is missing: run `pnpm --filter @flexipay/api env:init` first');
  }
  const apiRoot = join(import.meta.dirname, '..', '..');
  const result = spawnSync(
    process.execPath,
    [join(apiRoot, 'node_modules', 'tsx', 'dist', 'cli.mjs'), 'scripts/db-setup.ts', '--reset'],
    { cwd: apiRoot, env: process.env, stdio: 'inherit' },
  );
  if (result.status !== 0) throw new Error('test database setup failed');
}
