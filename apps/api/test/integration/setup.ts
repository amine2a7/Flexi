// Integration tests run against a local PostgreSQL test database, recreated for each run:
// the connection settings come from infra/.env (loaded by the test process, never printed), the
// database name is forced to flexipay_test.
import { existsSync } from 'node:fs';
import { join } from 'node:path';
import pg from 'pg';
import { databaseUrls } from '../../src/config/database-urls.js';

const ENV_FILE = join(import.meta.dirname, '..', '..', '..', '..', 'infra', '.env');

export function loadTestEnv(): void {
  if (existsSync(ENV_FILE)) process.loadEnvFile(ENV_FILE);
  process.env.DB_NAME = 'flexipay_test';
  process.env.NODE_ENV = 'test';
}

/** Owner connection (superuser on the test database): to check what the app role cannot do. */
export async function ownerClient(): Promise<pg.Client> {
  const client = new pg.Client({ connectionString: databaseUrls(process.env).migrationUrl });
  await client.connect();
  return client;
}

/** Application role connection (RLS applies, no UPDATE/DELETE on the ledger). */
export async function appClient(): Promise<pg.Client> {
  const client = new pg.Client({ connectionString: databaseUrls(process.env).appUrl });
  await client.connect();
  return client;
}
