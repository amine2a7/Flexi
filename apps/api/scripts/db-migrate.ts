// Applies the pending migrations (prisma migrate deploy) as fp_migrate, owner of the schema, then
// makes sure a data key exists (SEC-1: wrapped by DATA_MASTER_KEY, never stored in clear).
import { spawnSync } from 'node:child_process';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import pg from 'pg';
import { newWrappedKey } from '../src/common/keyring.js';
import { databaseUrls, PG_SESSION_OPTIONS, pgSsl } from '../src/config/database-urls.js';
import { encryptPii } from './encrypt-pii.js';

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
  await ensureDataKey();
  // Personal data stored before SEC-1: sealed with the data key, blind indexes computed.
  await encryptPii();
}

/** First data key of the database, if none yet (idempotent). */
export async function ensureDataKey(): Promise<void> {
  const raw = process.env.DATA_MASTER_KEY ?? '';
  const master = Buffer.from(raw, 'base64');
  if (master.length < 32) throw new Error('DATA_MASTER_KEY is missing or shorter than 32 bytes');
  const client = new pg.Client({
    connectionString: databaseUrls(process.env).migrationUrl,
    options: PG_SESSION_OPTIONS,
    ssl: pgSsl(process.env),
  });
  await client.connect();
  try {
    await client.query(
      `INSERT INTO data_keys (id, wrapped_key) SELECT 1, $1
        WHERE NOT EXISTS (SELECT 1 FROM data_keys)`,
      [newWrappedKey(master)],
    );
  } finally {
    await client.end();
  }
}

if (process.argv[1] !== undefined && fileURLToPath(import.meta.url) === process.argv[1]) {
  await runMigrations();
}
