/**
 * PostgreSQL connection strings, derived from three variables of infra/.env (never hard-coded):
 * - PG_ADMIN_URL: superuser on the maintenance database (only db:setup and migrations use it);
 * - DB_NAME: FlexiPay database (flexipay, or flexipay_test for the integration tests);
 * - APP_DB_PASSWORD: password of the application role `flexipay_app` (NOSUPERUSER NOBYPASSRLS).
 */
export const APP_DB_ROLE = 'flexipay_app';

/**
 * Startup options of every connection: the Prisma pg adapter reads and writes timestamptz values
 * without their offset, so the session must be in UTC (otherwise a server in another time zone
 * shifts every comparison between JS dates and now() by its offset).
 */
export const PG_SESSION_OPTIONS = '-c TimeZone=UTC';

export interface DatabaseUrls {
  /** Superuser, maintenance database (CREATE DATABASE, roles). */
  readonly adminUrl: string;
  /** Superuser, FlexiPay database: migrations (tables are owned by it, RLS applies to the app). */
  readonly migrationUrl: string;
  /** Application role, FlexiPay database: the API at runtime. */
  readonly appUrl: string;
  readonly dbName: string;
}

const DB_NAME = /^[a-z][a-z0-9_]{0,62}$/;

export function databaseUrls(env: NodeJS.ProcessEnv): DatabaseUrls {
  const admin = env.PG_ADMIN_URL;
  if (admin === undefined || admin === '') {
    // Prisma loads its config for every command (generate included): an absent URL must not fail
    // there. Commands that connect still fail, with the hint to run `pnpm --filter @flexipay/api env:init`.
    const placeholder = 'postgresql://unset@localhost:5432/unset';
    return {
      adminUrl: placeholder,
      migrationUrl: placeholder,
      appUrl: placeholder,
      dbName: 'unset',
    };
  }
  const dbName = env.DB_NAME ?? 'flexipay';
  if (!DB_NAME.test(dbName)) throw new Error('DB_NAME must be a plain lower-case identifier');
  const base = new URL(admin);
  const migration = new URL(base.toString());
  migration.pathname = `/${dbName}`;
  const app = new URL(migration.toString());
  app.username = APP_DB_ROLE;
  app.password = encodeURIComponent(env.APP_DB_PASSWORD ?? '');
  return {
    adminUrl: base.toString(),
    migrationUrl: migration.toString(),
    appUrl: app.toString(),
    dbName,
  };
}
