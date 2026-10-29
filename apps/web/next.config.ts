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
