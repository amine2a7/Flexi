// Integration tests run against a local PostgreSQL test database, recreated for each run:
// the connection settings come from infra/.env (loaded by the test process, never printed), the
// database name is forced to flexipay_test.
import { createHmac } from 'node:crypto';
import { existsSync } from 'node:fs';
import { join } from 'node:path';
import pg from 'pg';
import { databaseUrls, PG_SESSION_OPTIONS } from '../../src/config/database-urls.js';

const ENV_FILE = join(import.meta.dirname, '..', '..', '..', '..', 'infra', '.env');

/**
 * Keys and passwords added by SEC-1 that infra/.env may not hold yet: the tests derive them from
 * SESSION_SECRET (same values in every test process, never written anywhere, never used outside
 * the test database). The API itself never derives a key: it stops when one is missing.
 */
const DERIVED_FOR_TESTS = [
  'MIGRATE_DB_PASSWORD',
  'WORKER_DB_PASSWORD',
  'REPORT_DB_PASSWORD',
  'DATA_MASTER_KEY',
  'BLIND_INDEX_KEY',
  'PASSWORD_PEPPER',
  'FILE_LINK_SECRET',
] as const;

export function loadTestEnv(): void {
  if (existsSync(ENV_FILE)) process.loadEnvFile(ENV_FILE);
  process.env.DB_NAME = 'flexipay_test';
  process.env.NODE_ENV = 'test';
  const seed = process.env.SESSION_SECRET ?? '';
  for (const name of DERIVED_FOR_TESTS) {
    if (process.env[name] === undefined || process.env[name] === '') {
      process.env[name] = createHmac('sha256', seed).update(`flexipay-test|${name}`).digest('base64');
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
