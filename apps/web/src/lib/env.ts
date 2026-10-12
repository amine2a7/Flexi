import { z } from 'zod';

const DEFAULT_API_BASE_URL = 'http://localhost:3000';

const apiBaseUrlSchema = z.url({ protocol: /^https?$/ });

/**
 * Origin of the API (contract `servers`). Production must be HTTPS; plain HTTP is accepted only
 * for local development. Returns `undefined` when the value is invalid so callers fail closed
 * (e.g. the CSP then allows no cross-origin connection).
 */
export function getApiOrigin(
  raw: string | undefined = process.env.NEXT_PUBLIC_API_BASE_URL,
  isProduction: boolean = process.env.NODE_ENV === 'production',
): string | undefined {
  const value = raw === undefined || raw === '' ? DEFAULT_API_BASE_URL : raw;
  const parsed = apiBaseUrlSchema.safeParse(value);
  if (!parsed.success) return undefined;
  const url = new URL(parsed.data);
  if (isProduction && url.protocol !== 'https:') return undefined;
  return url.origin;
}
