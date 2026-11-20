import { readFileSync } from 'node:fs';
import type { ConnectionOptions } from 'node:tls';

/**
 * PostgreSQL roles (SEC-1), each with its own password from infra/.env (never hard-coded):
 * - fp_app: the API at runtime (NOSUPERUSER NOBYPASSRLS, no DDL, Row-Level Security applies),
 *   member of the group role `flexipay_app` that carries the grants and policies;
 * - fp_worker: the outbox only; fp_report: reading only; fp_migrate: owner of the schema
 *   (migrations and data scripts).
 * The superuser (PG_ADMIN_URL) only creates the database and the roles, on a local server.
 */
export const APP_DB_ROLE = 'fp_app';
export const APP_GROUP_ROLE = 'flexipay_app';
export const WORKER_DB_ROLE = 'fp_worker';
export const MIGRATE_DB_ROLE = 'fp_migrate';
export const REPORT_DB_ROLE = 'fp_report';

/**
 * Startup options of every connection: the Prisma pg adapter reads and writes timestamptz values
 * without their offset, so the session must be in UTC (otherwise a server in another time zone
 * shifts every comparison between JS dates and now() by its offset).
 */
export const PG_SESSION_OPTIONS = '-c TimeZone=UTC';

/** Suffix of the login roles of a separate database (`_test`): lower case, 16 characters at most. */
const ROLE_SUFFIX = /^(_[a-z0-9]{1,16})?$/;

export interface DbRoles {
  readonly app: string;
  readonly migrate: string;
  readonly worker: string;
  readonly report: string;
  /** Empty for the roles of the development database (the base names). */
  readonly suffix: string;
}

/**
 * Login roles of the database. PostgreSQL roles belong to the whole server: the integration
 * tests use their own roles (DB_ROLE_SUFFIX=_test: fp_app_test, fp_migrate_test...), members of
 * the base roles for the grants of the migrations, each with its own password, so that a test run
 * never changes a role, nor a password, of the development database.
 */
export function dbRoles(env: NodeJS.ProcessEnv): DbRoles {
  const suffix = env.DB_ROLE_SUFFIX ?? '';
  if (!ROLE_SUFFIX.test(suffix)) throw new Error('DB_ROLE_SUFFIX must look like _test');
  return {
    app: `${APP_DB_ROLE}${suffix}`,
    migrate: `${MIGRATE_DB_ROLE}${suffix}`,
    worker: `${WORKER_DB_ROLE}${suffix}`,
    report: `${REPORT_DB_ROLE}${suffix}`,
    suffix,
  };
}

export interface DatabaseUrls {
  /** Superuser, maintenance database (CREATE DATABASE, roles): local db:setup only. */
  readonly adminUrl: string;
  /** Superuser, FlexiPay database: local db:setup and the integration tests only. */
  readonly superUrl: string;
  /** fp_migrate, FlexiPay database: migrations and data scripts. */
  readonly migrationUrl: string;
  /** fp_app, FlexiPay database: the API at runtime. */
  readonly appUrl: string;
  readonly dbName: string;
}

const DB_NAME = /^[a-z][a-z0-9_]{0,62}$/;

function withRole(base: URL, role: string, password: string | undefined): string {
  const url = new URL(base.toString());
  url.username = role;
  url.password = encodeURIComponent(password ?? '');
  return url.toString();
}

export function databaseUrls(env: NodeJS.ProcessEnv): DatabaseUrls {
  const admin = env.PG_ADMIN_URL;
  if (admin === undefined || admin === '') {
    // Prisma loads its config for every command (generate included): an absent URL must not fail
    // there. Commands that connect still fail, with the hint to run `pnpm --filter @flexipay/api env:init`.
    const placeholder = 'postgresql://unset@localhost:5432/unset';
    return {
      adminUrl: placeholder,
      superUrl: placeholder,
      migrationUrl: placeholder,
      appUrl: placeholder,
      dbName: 'unset',
    };
  }
  const dbName = env.DB_NAME ?? 'flexipay';
  if (!DB_NAME.test(dbName)) throw new Error('DB_NAME must be a plain lower-case identifier');
  const base = new URL(admin);
  const database = new URL(base.toString());
  database.pathname = `/${dbName}`;
  const roles = dbRoles(env);
  const migration = new URL(withRole(database, roles.migrate, env.MIGRATE_DB_PASSWORD));
  // Prisma migrate reads the TLS mode from the URL.
  if (env.DB_SSL === 'require' || env.DB_SSL === 'verify-full') {
    migration.searchParams.set('sslmode', env.DB_SSL === 'require' ? 'require' : 'verify-full');
    if (env.DB_SSL_CA_FILE !== undefined)
      migration.searchParams.set('sslrootcert', env.DB_SSL_CA_FILE);
  }
  return {
    adminUrl: base.toString(),
    superUrl: database.toString(),
    migrationUrl: migration.toString(),
    appUrl: withRole(database, roles.app, env.APP_DB_PASSWORD),
    dbName,
  };
}

/** TLS options of a pg connection (DB_SSL): none locally, the server certificate checked otherwise. */
export function pgSsl(env: {
  readonly DB_SSL?: string | undefined;
  readonly DB_SSL_CA_FILE?: string | undefined;
}): false | ConnectionOptions {
  if (env.DB_SSL === 'verify-full') {
    return {
      rejectUnauthorized: true,
      ...(env.DB_SSL_CA_FILE === undefined ? {} : { ca: readFileSync(env.DB_SSL_CA_FILE, 'utf8') }),
    };
  }
  // `require`: encrypted, certificate not checked (a test server with a self-signed certificate).
  if (env.DB_SSL === 'require') return { rejectUnauthorized: false };
  return false;
}
