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
/** Pause before retrying a refresh that another tab of the browser was doing (409). */
const CONCURRENT_REFRESH_RETRY_MS = 300;

export function setCsrfToken(token: string | undefined): void {
  csrfToken = token;
}

async function refreshSession(baseUrl: string): Promise<Response> {
  return fetch(`${baseUrl}/v1/auth/refresh`, {
    method: 'POST',
    credentials: 'include',
    headers: WEB_CHANNEL_HEADER,
  });
}

/**
 * A new CSRF token through the session refresh (contract §6): after a page reload (the token in
 * memory is gone) or after another tab renewed the session (the token is tied to it). One refresh
 * at a time; a 409 (another tab is renewing) is retried once, with the cookie it received.
 * Without a session nothing is set and the request gets its own 401/403.
 */
async function recoverCsrfToken(baseUrl: string): Promise<string | undefined> {
  recovering ??= (async () => {
    try {
      let response = await refreshSession(baseUrl);
      if (response.status === 409) {
        await new Promise((resolve) => setTimeout(resolve, CONCURRENT_REFRESH_RETRY_MS));
        response = await refreshSession(baseUrl);
      }
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

/** True for `403 CSRF_TOKEN_INVALID` (read on a copy: the caller still gets the body). */
async function isCsrfRefusal(response: Response): Promise<boolean> {
  if (response.status !== 403) return false;
  try {
    const body = (await response.clone().json()) as { code?: unknown };
    return body.code === 'CSRF_TOKEN_INVALID';
  } catch {
    return false;
  }
}

/**
 * The single API client of the web app. The origin is a build-time constant (getApiOrigin);
 * without a valid one the app refuses to call anything (fail closed, securite F1/F3 note).
 */
export function getApi(): ApiClient {
  if (client !== undefined) return client;
  const baseUrl = getApiOrigin();
  if (baseUrl === undefined) throw new Error('API origin is not configured');
  // Copies of the requests that change something, to replay one once after a CSRF refusal (the
  // API refuses before doing anything, so the replay is safe).
  const copies = new Map<string, Request>();
  client = createApiClient({ baseUrl, getCsrfToken: () => csrfToken });
  client.use({
    async onRequest({ request, id }) {
      const unsafe = UNSAFE_METHODS.has(request.method.toUpperCase());
      if (!unsafe || PUBLIC_ROUTES.has(new URL(request.url).pathname)) return undefined;
      if (csrfToken === undefined) {
        const token = await recoverCsrfToken(baseUrl);
        if (token !== undefined) request.headers.set('X-CSRF-Token', token);
      }
      copies.set(id, request.clone());
      return request;
    },
    async onResponse({ response, id }) {
      const copy = copies.get(id);
      copies.delete(id);
      if (copy === undefined || !(await isCsrfRefusal(response))) return undefined;
      // Another tab renewed the session: new token, then the same request once more.
      csrfToken = undefined;
      const token = await recoverCsrfToken(baseUrl);
      if (token === undefined) return undefined;
      const replay = new Request(copy);
      replay.headers.set('X-CSRF-Token', token);
      return fetch(replay);
    },
  });
  return client;
}

/** CSRF header for a request outside the typed client (development routes), recovered if needed. */
export async function csrfHeader(): Promise<Record<string, string>> {
  const baseUrl = getApiOrigin();
  const token = csrfToken ?? (baseUrl === undefined ? undefined : await recoverCsrfToken(baseUrl));
  return token === undefined ? {} : { 'X-CSRF-Token': token };
}

/** New Idempotency-Key, generated once per user intention (contract §5). */
export function newIdempotencyKey(): string {
  return crypto.randomUUID();
}
