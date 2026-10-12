import createMiddleware from 'next-intl/middleware';
import { NextRequest, type NextResponse } from 'next/server';
import { routing } from './i18n/routing';
import { getApiOrigin } from './lib/env';
import { buildContentSecurityPolicy, createNonce } from './lib/security/headers';

const handleI18nRouting = createMiddleware(routing);

/**
 * Runs before every page: locale routing (next-intl) + a per-request CSP nonce. The policy is set
 * on the request (Next.js then adds the nonce to its own scripts) and on the response (the browser
 * enforces it). HTML is never cached: pages are personal and authenticated.
 */
export default function proxy(request: NextRequest): NextResponse {
  const nonce = createNonce();
  const csp = buildContentSecurityPolicy({
    nonce,
    isDevelopment: process.env.NODE_ENV !== 'production',
    apiOrigin: getApiOrigin(),
  });

  const requestHeaders = new Headers(request.headers);
  requestHeaders.set('x-nonce', nonce);
  requestHeaders.set('content-security-policy', csp);

  const response = handleI18nRouting(new NextRequest(request, { headers: requestHeaders }));
  response.headers.set('content-security-policy', csp);
  response.headers.set('cache-control', 'no-store');
  return response;
}

export const config = {
  // Every page goes through the proxy (CSP, no-store). Only real static files are excluded: a
  // path with a dot (/fr/a.b) is a page like any other and must carry the CSP (review F1-S01).
  // `[^/]+\.js$` = scripts served from the root of public/ (the dev-only mock service worker).
  matcher: ['/((?!api/|_next/|_vercel/|favicon\\.ico$|icon\\.svg$|robots\\.txt$|[^/]+\\.js$).*)'],
};
