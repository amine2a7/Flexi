import { resolve } from 'node:path';
import { z } from 'zod';
import { databaseUrls } from './database-urls.js';

const base64Key = z
  .string()
  .regex(/^[A-Za-z0-9+/]+={0,2}$/, 'base64')
  .refine((value) => Buffer.from(value, 'base64').length >= 32, 'at least 32 bytes');

const schema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  API_PORT: z.coerce.number().int().min(1).max(65_535).default(3000),
  /**
   * Listening address: 127.0.0.1 (this computer only) by default; 0.0.0.0 to reach the API from a
   * phone on the same Wi-Fi during development.
   */
  API_HOST: z.union([z.literal('localhost'), z.ipv4()]).default('127.0.0.1'),
  /** Exact origins allowed by CORS and the CSRF Origin check (comma separated, no wildcard). */
  WEB_ORIGINS: z.string().default('http://localhost:3001'),
  PG_ADMIN_URL: z.string().min(1),
  DB_NAME: z.string().default('flexipay'),
  /** Password of `fp_app`, the only role the API connects with (RLS applies, no DDL). */
  APP_DB_PASSWORD: z.string().min(16),
  /** Password of `fp_migrate`, owner of the schema: migrations and data scripts only. */
  MIGRATE_DB_PASSWORD: z.string().min(16),
  /** Passwords of `fp_worker` (outbox only) and `fp_report` (read only): set by db:setup. */
  WORKER_DB_PASSWORD: z.string().min(16).optional(),
  REPORT_DB_PASSWORD: z.string().min(16).optional(),
  /** TLS to PostgreSQL: `verify-full` required in production (CA of the server in DB_SSL_CA_FILE). */
  DB_SSL: z.enum(['disable', 'require', 'verify-full']).default('disable'),
  DB_SSL_CA_FILE: z.string().optional(),
  /** HMAC key of the CSRF tokens (contract §6). */
  SESSION_SECRET: base64Key,
  /** AES-256-GCM key of the TOTP secrets at rest, and of the personal data sealed before SEC-1. */
  DATA_ENCRYPTION_KEY: base64Key,
  /**
   * Master key (KEK) that wraps the data keys of the personal data (CIN, RIB, tax id, phones):
   * an environment variable for now, a key vault later. Never stored in the database.
   */
  DATA_MASTER_KEY: base64Key,
  /** HMAC-SHA256 key of the blind indexes (search and uniqueness without decrypting). */
  BLIND_INDEX_KEY: base64Key,
  /** Pepper of the Argon2id hashes (passwords, PINs, temporary passwords). */
  PASSWORD_PEPPER: base64Key,
  /** HMAC key of the signed links of the KYC pieces (5 minutes, one administrator). */
  FILE_LINK_SECRET: base64Key,
  /** Local file storage (KYC pieces, transfer proofs), outside Git. */
  UPLOAD_DIR: z.string().default('var/uploads'),
  /**
   * Development only: a fixed MFA code accepted for every account (the demo accounts of the web
   * sign-in page). Refused in production.
   */
  DEMO_FIXED_MFA_CODE: z
    .string()
    .regex(/^[0-9]{6}$/)
    .optional(),
  /**
   * End-to-end tests only: the days of the API move forward on request (common/test-clock.ts).
   * Refused in production.
   */
  TEST_CLOCK: z.enum(['0', '1']).optional(),
  /**
   * Path under which the browser reaches the API when the web relays it on its own origin
   * (request of 2026-11-14: Next rewrite /api -> API, one tunnel): the refresh cookie is scoped to
   * `<prefix>/v1/auth`. Empty when the browser calls the API directly.
   */
  PUBLIC_PATH_PREFIX: z
    .string()
    .regex(/^(\/[a-z][a-z0-9-]*)?$/)
    .default(''),
});

export type Env = Readonly<
  z.infer<typeof schema> & { databaseUrl: string; webOrigins: readonly string[]; uploadDir: string }
>;

/** Reads and checks the environment once at start-up; any error stops the API (fail closed). */
export function loadEnv(source: NodeJS.ProcessEnv = process.env): Env {
  const parsed = schema.safeParse(source);
  if (!parsed.success) {
    // Names of the invalid variables only, never their values.
    const names = [...new Set(parsed.error.issues.map((issue) => issue.path.join('.')))];
    throw new Error(`Invalid environment (see infra/.env): ${names.join(', ')}`);
  }
  const env = parsed.data;
  if (env.NODE_ENV === 'production' && env.DEMO_FIXED_MFA_CODE !== undefined) {
    throw new Error('DEMO_FIXED_MFA_CODE is forbidden in production');
  }
  if (env.NODE_ENV === 'production' && env.TEST_CLOCK === '1') {
    throw new Error('TEST_CLOCK is forbidden in production');
  }
  if (env.NODE_ENV === 'production' && env.DB_SSL !== 'verify-full') {
    throw new Error('DB_SSL must be verify-full in production');
  }
  // One key, one use: the same value reused for two purposes is refused (names only, no value).
  const keys = [
    'SESSION_SECRET',
    'DATA_ENCRYPTION_KEY',
    'DATA_MASTER_KEY',
    'BLIND_INDEX_KEY',
    'PASSWORD_PEPPER',
    'FILE_LINK_SECRET',
  ] as const;
  const seen = new Map<string, string>();
  for (const name of keys) {
    const other = seen.get(env[name]);
    if (other !== undefined) throw new Error(`${name} must differ from ${other}`);
    seen.set(env[name], name);
  }
  if (env.NODE_ENV === 'production') {
    // Never a dummy key (one repeated byte, as in the unit tests) nor the test database.
    for (const name of keys) {
      if (new Set(Buffer.from(env[name], 'base64')).size === 1)
        throw new Error(`${name} is a dummy key, refused in production`);
    }
    if (env.DB_NAME.endsWith('_test')) throw new Error('DB_NAME is a test database');
  }
  const uploadDir = resolve(env.UPLOAD_DIR);
  // Uploaded pieces never live under a folder served by a web server.
  if (/[\\/](public|static|www|\.next)([\\/]|$)/i.test(uploadDir)) {
    throw new Error('UPLOAD_DIR must stay outside any web folder');
  }
  const webOrigins = env.WEB_ORIGINS.split(',')
    .map((origin) => origin.trim())
    .filter((origin) => origin !== '');
  for (const origin of webOrigins) {
    if (origin === '*' || origin === 'null' || new URL(origin).origin !== origin) {
      throw new Error('WEB_ORIGINS must list exact origins');
    }
  }
  return {
    ...env,
    databaseUrl: databaseUrls(source).appUrl,
    webOrigins,
    uploadDir,
  };
}
