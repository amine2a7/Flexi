import { createApiClient, WEB_CHANNEL_HEADER, type ApiClient } from '@flexipay/api-client';
import { getApiOrigin } from '@/lib/env';

// The CSRF token lives in memory only (contract §6): never in storage, never in the URL.
let csrfToken: string | undefined;
let client: ApiClient | undefined;
let recovering: Promise<string | undefined> | undefined;

const UNSAFE_METHODS = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);
/** Public routes (no session, no CSRF token): the sign-in steps hand the token themselves. */
const PUBLIC_ROUTES = new Set([
  '/v1/auth/login',
  '/v1/auth/mfa/verify',
  '/v1/auth/refresh',
  '/v1/auth/password/forgot',
  '/v1/auth/password/reset',
  '/v1/public/contact-messages',
]);

export function setCsrfToken(token: string | undefined): void {
  csrfToken = token;
}

/**
 * After a page reload the in-memory token is gone: the session refresh hands a new one (contract
 * §6). One refresh at a time; without a session nothing is set and the request gets its 401/403.
 */
async function recoverCsrfToken(baseUrl: string): Promise<string | undefined> {
  recovering ??= (async () => {
    try {
      const response = await fetch(`${baseUrl}/v1/auth/refresh`, {
        method: 'POST',
        credentials: 'include',
        headers: WEB_CHANNEL_HEADER,
      });
      if (!response.ok) return undefined;
      const body = (await response.json()) as { csrfToken?: unknown };
      if (typeof body.csrfToken === 'string') csrfToken = body.csrfToken;
      return csrfToken;
    } catch {
      // Network error: the request itself will report it.
      return undefined;
    } finally {
      recovering = undefined;
    }
  })();
  return recovering;
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
  client.use({
    async onRequest({ request }) {
      const unsafe = UNSAFE_METHODS.has(request.method.toUpperCase());
      if (!unsafe || csrfToken !== undefined || PUBLIC_ROUTES.has(new URL(request.url).pathname))
        return undefined;
      const token = await recoverCsrfToken(baseUrl);
      if (token === undefined) return undefined;
      request.headers.set('X-CSRF-Token', token);
      return request;
    },
  });
  return client;
}

/** New Idempotency-Key, generated once per user intention (contract §5). */
export function newIdempotencyKey(): string {
  return crypto.randomUUID();
}
