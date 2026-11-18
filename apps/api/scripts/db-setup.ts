// Local database setup (development and tests), with the variables of infra/.env:
//   pnpm --filter @flexipay/api db:setup            create the database if needed, migrate
//   pnpm --filter @flexipay/api db:reset            drop and recreate it (development data only)
//   DB_NAME=flexipay_test pnpm --filter @flexipay/api db:setup   test database
// Never against staging or production: the admin URL must point to localhost. There, the DBA
// creates the same roles (SEC-1): fp_migrate owner of the database, fp_app member of
// flexipay_app, fp_worker, fp_report BYPASSRLS read only.
import pg from 'pg';
import {
  APP_DB_ROLE,
  APP_GROUP_ROLE,
  databaseUrls,
  MIGRATE_DB_ROLE,
  REPORT_DB_ROLE,
  WORKER_DB_ROLE,
} from '../src/config/database-urls.js';
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
const passwords: Record<string, string> = {
  [APP_DB_ROLE]: process.env.APP_DB_PASSWORD ?? '',
  [MIGRATE_DB_ROLE]: process.env.MIGRATE_DB_PASSWORD ?? '',
  [WORKER_DB_ROLE]: process.env.WORKER_DB_PASSWORD ?? '',
  [REPORT_DB_ROLE]: process.env.REPORT_DB_PASSWORD ?? '',
};
for (const [role, password] of Object.entries(passwords)) {
  if (password.length < 16) {
    console.error(`The password of ${role} is missing or too short (16 characters at least).`);
    process.exit(1);
  }
}

/** Role attributes: nobody but the superuser bypasses the policies, except the reader. */
const ROLES: readonly [string, string][] = [
  [MIGRATE_DB_ROLE, 'LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS'],
  [APP_DB_ROLE, 'LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS INHERIT'],
  [WORKER_DB_ROLE, 'LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS'],
  [REPORT_DB_ROLE, 'LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE BYPASSRLS'],
];

const admin = new pg.Client({ connectionString: urls.adminUrl });
await admin.connect();
try {
  for (const [role, attributes] of ROLES) {
    const ident = admin.escapeIdentifier(role);
    const exists =
      (await admin.query('SELECT 1 FROM pg_roles WHERE rolname = $1', [role])).rowCount === 1;
    await admin.query(
      `${exists ? 'ALTER' : 'CREATE'} ROLE ${ident} ${attributes} PASSWORD ${admin.escapeLiteral(passwords[role] ?? '')}`,
    );
  }
  // Group role of the grants and policies (migration 0002); the API logs in as its member fp_app.
  const group =
    (await admin.query('SELECT 1 FROM pg_roles WHERE rolname = $1', [APP_GROUP_ROLE])).rowCount ===
    1;
  if (!group) {
    await admin.query(
      `CREATE ROLE ${admin.escapeIdentifier(APP_GROUP_ROLE)} NOLOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOINHERIT`,
    );
  }
  await admin.query(`ALTER ROLE ${admin.escapeIdentifier(APP_GROUP_ROLE)} NOLOGIN PASSWORD NULL`);
  await admin.query(
    `GRANT ${admin.escapeIdentifier(APP_GROUP_ROLE)} TO ${admin.escapeIdentifier(APP_DB_ROLE)}`,
  );

  const ident = admin.escapeIdentifier(urls.dbName);
  const exists =
    (await admin.query('SELECT 1 FROM pg_database WHERE datname = $1', [urls.dbName])).rowCount ===
    1;
  if (exists && reset) {
    await admin.query(
      'SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = $1 AND pid <> pg_backend_pid()',
      [urls.dbName],
    );
    // FORCE: a running API (pnpm demo) may reconnect between the termination and the drop.
    await admin.query(`DROP DATABASE ${ident} WITH (FORCE)`);
    console.log(`database ${urls.dbName} dropped`);
  }
  if (!exists || reset) {
    await admin.query(
      `CREATE DATABASE ${ident} OWNER ${admin.escapeIdentifier(MIGRATE_DB_ROLE)} ENCODING 'UTF8' TEMPLATE template0`,
    );
    console.log(`database ${urls.dbName} created`);
  } else {
    await admin.query(
      `ALTER DATABASE ${ident} OWNER TO ${admin.escapeIdentifier(MIGRATE_DB_ROLE)}`,
    );
  }
  for (const role of [APP_DB_ROLE, WORKER_DB_ROLE, REPORT_DB_ROLE]) {
    await admin.query(`GRANT CONNECT ON DATABASE ${ident} TO ${admin.escapeIdentifier(role)}`);
  }
  await admin.query(`REVOKE CONNECT ON DATABASE ${ident} FROM PUBLIC`);
  await admin.query(
    `GRANT CONNECT ON DATABASE ${ident} TO ${admin.escapeIdentifier(MIGRATE_DB_ROLE)}`,
  );
  // Local database (this script refuses any other host): marked as a development one, the only
  // kind where the seed may write opening balances (migration 0010). Never done in production.
  await admin.query(`ALTER DATABASE ${ident} SET app.environment = 'development'`);
  // Every session in UTC (the API also sets it per connection: PG_SESSION_OPTIONS).
  await admin.query(`ALTER DATABASE ${ident} SET timezone = 'UTC'`);
} finally {
  await admin.end();
}

// A database created before SEC-1 belongs to the superuser: its objects go to fp_migrate.
const owner = new pg.Client({ connectionString: urls.superUrl });
await owner.connect();
try {
  await owner.query(`
    DO $$
    DECLARE r record;
    BEGIN
      FOR r IN SELECT c.relname, c.relkind FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
                WHERE n.nspname = 'public' AND c.relkind IN ('r', 'p', 'v', 'm')
                  AND pg_get_userbyid(c.relowner) <> '${MIGRATE_DB_ROLE}' LOOP
        EXECUTE format('ALTER TABLE %I OWNER TO ${MIGRATE_DB_ROLE}', r.relname);
      END LOOP;
      FOR r IN SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
                WHERE n.nspname = 'public' AND c.relkind = 'S'
                  AND pg_get_userbyid(c.relowner) <> '${MIGRATE_DB_ROLE}' LOOP
        EXECUTE format('ALTER SEQUENCE %I OWNER TO ${MIGRATE_DB_ROLE}', r.relname);
      END LOOP;
      FOR r IN SELECT p.oid::regprocedure AS sig FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
                WHERE n.nspname = 'public' AND pg_get_userbyid(p.proowner) <> '${MIGRATE_DB_ROLE}' LOOP
        EXECUTE format('ALTER ROUTINE %s OWNER TO ${MIGRATE_DB_ROLE}', r.sig);
      END LOOP;
      FOR r IN SELECT t.typname FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace
                WHERE n.nspname = 'public' AND t.typtype = 'e'
                  AND pg_get_userbyid(t.typowner) <> '${MIGRATE_DB_ROLE}' LOOP
        EXECUTE format('ALTER TYPE %I OWNER TO ${MIGRATE_DB_ROLE}', r.typname);
      END LOOP;
    END $$`);
} finally {
  await owner.end();
}

await runMigrations();
console.log(`roles ${APP_DB_ROLE}, ${WORKER_DB_ROLE}, ${MIGRATE_DB_ROLE}, ${REPORT_DB_ROLE} ready`);
console.log('Next: pnpm --filter @flexipay/api db:seed');
