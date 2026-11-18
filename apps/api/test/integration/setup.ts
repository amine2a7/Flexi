// Integration tests run against a local PostgreSQL test database, recreated for each run:
// the connection settings come from infra/.env (loaded by the test process, never printed), the
// database name is forced to flexipay_test.
import { randomBytes } from 'node:crypto';
import { existsSync } from 'node:fs';
import { join } from 'node:path';
import pg from 'pg';
import { databaseUrls, PG_SESSION_OPTIONS } from '../../src/config/database-urls.js';

const ENV_FILE = join(import.meta.dirname, '..', '..', '..', '..', 'infra', '.env');

/**
 * Keys and role passwords of the test run (SEC-1): drawn at random once per run, by the global
 * setup that recreates the test database, then inherited by every test process. Never the values
 * of infra/.env, never derived from another secret, never written anywhere.
 */
const RUN_KEYS = [
  'MIGRATE_DB_PASSWORD',
  'WORKER_DB_PASSWORD',
  'REPORT_DB_PASSWORD',
  'DATA_MASTER_KEY',
  'BLIND_INDEX_KEY',
  'PASSWORD_PEPPER',
  'FILE_LINK_SECRET',
] as const;
/** Set by the first call of the run (global setup): the test processes keep its keys. */
const RUN_MARKER = 'FLEXIPAY_TEST_RUN_KEYS';

export function loadTestEnv(): void {
  const inherited = new Map(RUN_KEYS.map((name) => [name, process.env[name]]));
  if (existsSync(ENV_FILE)) process.loadEnvFile(ENV_FILE);
  process.env.DB_NAME = 'flexipay_test';
  process.env.NODE_ENV = 'test';
  const ownRun = process.env[RUN_MARKER] === '1';
  for (const name of RUN_KEYS) {
    const kept = inherited.get(name);
    process.env[name] = ownRun && kept !== undefined ? kept : randomBytes(32).toString('base64');
  }
  process.env[RUN_MARKER] = '1';
}

/** Superuser connection on the test database: to check what the app role cannot do. */
export async function ownerClient(): Promise<pg.Client> {
  const client = new pg.Client({
    connectionString: databaseUrls(process.env).superUrl,
    options: PG_SESSION_OPTIONS,
  });
  await client.connect();
  return client;
}

/** fp_app connection, as the API (RLS applies, no UPDATE/DELETE on the ledger). */
export async function appClient(): Promise<pg.Client> {
  const client = new pg.Client({
    connectionString: databaseUrls(process.env).appUrl,
    options: PG_SESSION_OPTIONS,
  });
  await client.connect();
  return client;
}
