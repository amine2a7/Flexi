// Local database setup (development and tests), with the variables of infra/.env:
//   pnpm --filter @flexipay/api db:setup            create the database if needed, migrate
//   pnpm --filter @flexipay/api db:reset            drop and recreate it (development data only)
//   DB_NAME=flexipay_test pnpm --filter @flexipay/api db:setup   test database
// Never against staging or production: the admin URL must point to localhost.
import pg from 'pg';
import { APP_DB_ROLE, databaseUrls } from '../src/config/database-urls.js';
import { runMigrations } from './db-migrate.js';

const reset = process.argv.includes('--reset');
const urls = databaseUrls(process.env);
if (urls.dbName === 'unset') {
  console.error('PG_ADMIN_URL is missing: run `pnpm --filter @flexipay/api env:init` first.');
  process.exit(1);
}
const host = new URL(urls.adminUrl).hostname;
if (!['localhost', '127.0.0.1', '::1'].includes(host)) {
  console.error('db:setup only runs against a local PostgreSQL (localhost).');
  process.exit(1);
}
const appPassword = process.env.APP_DB_PASSWORD ?? '';
if (appPassword.length < 16) {
  console.error('APP_DB_PASSWORD is missing or too short (16 characters at least).');
  process.exit(1);
}

const admin = new pg.Client({ connectionString: urls.adminUrl });
await admin.connect();
try {
  const ident = admin.escapeIdentifier(urls.dbName);
  const exists =
    (await admin.query('SELECT 1 FROM pg_database WHERE datname = $1', [urls.dbName])).rowCount ===
    1;
  if (exists && reset) {
    await admin.query(
      'SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = $1 AND pid <> pg_backend_pid()',
      [urls.dbName],
    );
    await admin.query(`DROP DATABASE ${ident}`);
    console.log(`database ${urls.dbName} dropped`);
  }
  if (!exists || reset) {
    await admin.query(`CREATE DATABASE ${ident} ENCODING 'UTF8' TEMPLATE template0`);
    console.log(`database ${urls.dbName} created`);
  }
} finally {
  await admin.end();
}

await runMigrations();

// The migration creates the role without login; give it LOGIN and the password of infra/.env.
const owner = new pg.Client({ connectionString: urls.migrationUrl });
await owner.connect();
try {
  await owner.query(
    `ALTER ROLE ${owner.escapeIdentifier(APP_DB_ROLE)} LOGIN PASSWORD ${owner.escapeLiteral(appPassword)}`,
  );
  await owner.query(
    `GRANT CONNECT ON DATABASE ${owner.escapeIdentifier(urls.dbName)} TO ${owner.escapeIdentifier(APP_DB_ROLE)}`,
  );
  console.log(`role ${APP_DB_ROLE} ready (LOGIN, NOSUPERUSER, NOBYPASSRLS)`);
  // Local database (this script refuses any other host): marked as a development one, the only
  // kind where the seed may write opening balances (migration 0010). Never done in production.
  await owner.query(
    `ALTER DATABASE ${owner.escapeIdentifier(urls.dbName)} SET app.environment = 'development'`,
  );
} finally {
  await owner.end();
}
console.log('Next: pnpm --filter @flexipay/api db:seed');
