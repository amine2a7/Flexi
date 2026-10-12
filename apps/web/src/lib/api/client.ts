import { createApiClient, type ApiClient } from '@flexipay/api-client';
import { getApiOrigin } from '@/lib/env';

// The CSRF token lives in memory only (contract §6): never in storage, never in the URL.
let csrfToken: string | undefined;
let client: ApiClient | undefined;

export function setCsrfToken(token: string | undefined): void {
  csrfToken = token;
}

/**
 * The single API client of the web app. The origin is a build-time constant (getApiOrigin);
 * without a valid one the app refuses to call anything (fail closed, securite F1/F3 note).
 */
export function getApi(): ApiClient {
  if (client !== undefined) return client;
  const baseUrl = getApiOrigin();
  if (baseUrl === undefined) throw new Error('API origin is not configured');
  client = createApiClient({ baseUrl, getCsrfToken: () => csrfToken });
  return client;
}

/** New Idempotency-Key, generated once per user intention (contract §5). */
export function newIdempotencyKey(): string {
  return crypto.randomUUID();
}
