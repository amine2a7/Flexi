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
  /** Exact origins allowed by CORS and the CSRF Origin check (comma separated, no wildcard). */
  WEB_ORIGINS: z.string().default('http://localhost:3001'),
  PG_ADMIN_URL: z.string().min(1),
  DB_NAME: z.string().default('flexipay'),
  APP_DB_PASSWORD: z.string().min(16),
  /** HMAC key of the CSRF tokens (contract §6). */
  SESSION_SECRET: base64Key,
  /** AES-256-GCM key of the TOTP secrets at rest. */
  DATA_ENCRYPTION_KEY: base64Key,
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
    uploadDir: resolve(env.UPLOAD_DIR),
  };
}
