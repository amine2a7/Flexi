import type { NextConfig } from 'next';
import { PHASE_DEVELOPMENT_SERVER } from 'next/constants';
import createNextIntlPlugin from 'next-intl/plugin';
import { buildStaticSecurityHeaders } from './src/lib/security/headers';

const withNextIntl = createNextIntlPlugin('./src/i18n/request.ts');

const nextConfig: NextConfig = {
  // Separate output directory for the production-build test, so it never clobbers `.next`.
  distDir: process.env.NEXT_DIST_DIR ?? '.next',
  poweredByHeader: false,
  reactStrictMode: true,
  // The dev indicator is a focusable button inserted before the app: it breaks keyboard e2e tests.
  devIndicators: false,
  // Same-origin API (request of 2026-11-14): with NEXT_PUBLIC_API_BASE_URL=/api the browser calls
  // /api/..., relayed here to API_PROXY_TARGET, so a single tunnel exposes the web and the API.
  rewrites() {
    const target = process.env.API_PROXY_TARGET;
    if (process.env.NEXT_PUBLIC_API_BASE_URL !== '/api' || target === undefined) {
      return Promise.resolve([]);
    }
    const destination = `${new URL(target).origin}/:path*`;
    return Promise.resolve([{ source: '/api/:path*', destination }]);
  },
  headers() {
    return Promise.resolve([
      {
        source: '/:path*',
        headers: buildStaticSecurityHeaders(process.env.NODE_ENV === 'production'),
      },
    ]);
  },
};

// `*.dev.tsx` pages (component library) exist for `next dev` only: never routed nor bundled in a
// build (dev-composants.md §2, checked by the build output test in test/build).
export default function config(phase: string): NextConfig {
  return withNextIntl({
    ...nextConfig,
    pageExtensions: phase === PHASE_DEVELOPMENT_SERVER ? ['dev.tsx', 'tsx', 'ts'] : ['tsx', 'ts'],
  });
}
