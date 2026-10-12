// Security headers of the web app (P0-F3, SEC-W*). Pure functions: used by src/proxy.ts (CSP with a
// per-request nonce) and next.config.ts (static headers), and tested without a server.

export interface CspOptions {
  /** Per-request random value (base64); allows Next.js own scripts and nothing else. */
  readonly nonce: string;
  /** Development needs eval (React refresh), inline styles (HMR) and the mock service worker. */
  readonly isDevelopment: boolean;
  /** Origin of the API (from build configuration, never from the user); undefined = same origin only. */
  readonly apiOrigin: string | undefined;
}

/** Strict, nonce-based Content-Security-Policy. No `unsafe-inline` and no `unsafe-eval` in production. */
export function buildContentSecurityPolicy({
  nonce,
  isDevelopment,
  apiOrigin,
}: CspOptions): string {
  const nonceSource = `'nonce-${nonce}'`;
  const directives: [string, ...string[]][] = [
    ['default-src', "'self'"],
    [
      'script-src',
      "'self'",
      nonceSource,
      "'strict-dynamic'",
      ...(isDevelopment ? ["'unsafe-eval'"] : []),
    ],
    ['style-src', "'self'", ...(isDevelopment ? ["'unsafe-inline'"] : [nonceSource])],
    // blob: = preview of a transfer proof fetched by the app itself (credit orders), images only.
    ['img-src', "'self'", 'data:', 'blob:'],
    ['font-src', "'self'"],
    ['connect-src', "'self'", ...(apiOrigin === undefined ? [] : [apiOrigin])],
    ['worker-src', isDevelopment ? "'self'" : "'none'"],
    ['manifest-src', "'self'"],
    ['object-src', "'none'"],
    ['frame-src', "'none'"],
    ['frame-ancestors', "'none'"],
    ['base-uri', "'self'"],
    ['form-action', "'self'"],
  ];
  const lines = directives.map((directive) => directive.join(' '));
  if (!isDevelopment) lines.push('upgrade-insecure-requests');
  return lines.join('; ');
}

export interface HeaderEntry {
  readonly key: string;
  readonly value: string;
}

/** Headers that do not depend on the request: applied to every response by next.config.ts. */
export function buildStaticSecurityHeaders(isProduction: boolean): HeaderEntry[] {
  const headers: HeaderEntry[] = [
    // The app never needs the referrer, and URLs may carry identifiers.
    { key: 'Referrer-Policy', value: 'no-referrer' },
    { key: 'X-Content-Type-Options', value: 'nosniff' },
    // Legacy equivalent of CSP frame-ancestors for old browsers.
    { key: 'X-Frame-Options', value: 'DENY' },
    {
      key: 'Permissions-Policy',
      value: 'camera=(), microphone=(), geolocation=(), payment=(), usb=(), browsing-topics=()',
    },
    { key: 'Cross-Origin-Opener-Policy', value: 'same-origin' },
    { key: 'Cross-Origin-Resource-Policy', value: 'same-origin' },
  ];
  // HSTS only where HTTPS is guaranteed; local development runs on http://localhost.
  if (isProduction) {
    headers.push({
      key: 'Strict-Transport-Security',
      value: 'max-age=63072000; includeSubDomains',
    });
  }
  return headers;
}

/** Random nonce (128 bits, base64) from the Web Crypto API (available in the proxy runtime). */
export function createNonce(): string {
  const bytes = crypto.getRandomValues(new Uint8Array(16));
  return btoa(String.fromCharCode(...bytes));
}
