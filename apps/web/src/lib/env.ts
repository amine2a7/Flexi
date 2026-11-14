import { z } from 'zod';

const DEFAULT_API_BASE_URL = 'http://localhost:3000';

const apiBaseUrlSchema = z.url({ protocol: /^https?$/ });

/**
 * Loopback hosts: browsers treat them as secure contexts. Accepted over HTTP by a production build
 * only when the build says it is local (NEXT_PUBLIC_LOCAL_BUILD=1, set by `pnpm demo:rapide`): a
 * real deployment pointed at a local API by mistake still fails closed.
 */
const LOOPBACK_HOSTS = new Set(['localhost', '127.0.0.1', '[::1]']);

/**
 * Origin of the API (contract `servers`). Production must be HTTPS; plain HTTP is accepted only
 * for local development or a production build talking to an API on the loopback. Returns `undefined` when the value is invalid so callers fail closed
 * (e.g. the CSP then allows no cross-origin connection).
 */
export function getApiOrigin(
  raw: string | undefined = process.env.NEXT_PUBLIC_API_BASE_URL,
  isProduction: boolean = process.env.NODE_ENV === 'production',
  localBuild: boolean = process.env.NEXT_PUBLIC_LOCAL_BUILD === '1',
): string | undefined {
  // The local default is for development only: a production build without a value fails closed.
  if ((raw === undefined || raw === '') && isProduction) return undefined;
  const value = raw === undefined || raw === '' ? DEFAULT_API_BASE_URL : raw;
  const parsed = apiBaseUrlSchema.safeParse(value);
  if (!parsed.success) return undefined;
  const url = new URL(parsed.data);
  if (
    isProduction &&
    url.protocol !== 'https:' &&
    !(localBuild && LOOPBACK_HOSTS.has(url.hostname))
  ) {
    return undefined;
  }
  return url.origin;
}

/**
 * Prefix of the API on the origin of the web (request of 2026-11-14): with
 * NEXT_PUBLIC_API_BASE_URL=/api the browser calls /api/v1/..., which Next rewrites to the API
 * (API_PROXY_TARGET, next.config.ts), so one tunnel exposes everything.
 */
export const SAME_ORIGIN_PREFIX = '/api';

export function isSameOriginApi(raw: string | undefined = process.env.NEXT_PUBLIC_API_BASE_URL) {
  return raw === SAME_ORIGIN_PREFIX;
}

/**
 * Base of the API calls of the browser: the same-origin prefix, or the API origin (undefined when
 * not configured: callers fail closed).
 */
export function getApiBaseUrl(): string | undefined {
  return isSameOriginApi() ? SAME_ORIGIN_PREFIX : getApiOrigin();
}

/**
 * Origin of the API for the server rendering (it cannot call a relative URL): the target of the
 * rewrite in same-origin mode, the public API origin otherwise.
 */
export function getServerApiOrigin(): string | undefined {
  return isSameOriginApi() ? getApiOrigin(process.env.API_PROXY_TARGET) : getApiOrigin();
}
