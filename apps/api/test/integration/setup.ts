// Integration tests run against a local PostgreSQL test database, recreated for each run:
// the connection settings come from infra/.env (loaded by the test process, never printed), the
// database name is forced to flexipay_test.
import { existsSync } from 'node:fs';
import { join } from 'node:path';
import pg from 'pg';
import { databaseUrls, PG_SESSION_OPTIONS } from '../../src/config/database-urls.js';
import { TEST_DERIVED_NAMES, testDerivedValue } from '../../src/config/test-keys.js';

const ENV_FILE = join(import.meta.dirname, '..', '..', '..', '..', 'infra', '.env');

/**
 * Keys and passwords added by SEC-1 that infra/.env may not hold yet: the tests derive them from
 * SESSION_SECRET (same values in every test process, never written anywhere). The API never
 * derives a key, and refuses these values in production (src/config/test-keys.ts).
 */
export function loadTestEnv(): void {
  if (existsSync(ENV_FILE)) process.loadEnvFile(ENV_FILE);
  process.env.DB_NAME = 'flexipay_test';
  process.env.NODE_ENV = 'test';
  const seed = process.env.SESSION_SECRET ?? '';
  for (const name of TEST_DERIVED_NAMES) {
    if (process.env[name] === undefined || process.env[name] === '') {
      process.env[name] = testDerivedValue(seed, name);
    }
  }
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
