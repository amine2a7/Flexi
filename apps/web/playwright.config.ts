import { defineConfig, devices } from '@playwright/test';

// Explicit ports, never 3000 (often used by another local server). The web only talks to the API
// (no mocks since 2026-11-05): the suite runs against the API of `pnpm demo` (demo seed).
const DEV_PORT = Number(process.env.E2E_WEB_PORT ?? 3101);
const PROD_PORT = Number(process.env.E2E_BUILD_PORT ?? 3102);
const API_ORIGIN = `http://localhost:${process.env.E2E_API_PORT ?? '3198'}`;
const DEV_URL = `http://localhost:${String(DEV_PORT)}`;
const PROD_URL = `http://localhost:${String(PROD_PORT)}`;

// Browsers can be installed outside the system drive:
//   PLAYWRIGHT_BROWSERS_PATH=D:/pw-browsers pnpm --filter @flexipay/web test:e2e:install
export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  // Locally the dev server compiles pages on first hit: more workers make it time out.
  ...(process.env.CI ? {} : { workers: 2 }),
  forbidOnly: Boolean(process.env.CI),
  // Locally the dev server compiles a page on its first visit (often 10 to 20 s on Windows): a
  // longer assertion timeout and one retry absorb that compile, CI keeps the defaults.
  retries: 1,
  ...(process.env.CI ? {} : { expect: { timeout: 20_000 } }),
  reporter: process.env.CI ? [['github'], ['html', { open: 'never' }]] : [['list']],
  use: {
    // Full Chromium (new headless mode): no separate headless-shell download needed.
    // E2E_CHANNEL=msedge on a machine without the Playwright Chromium (local Windows).
    channel: process.env.E2E_CHANNEL ?? 'chromium',
    // The browser language drives the first redirect of / (Accept-Language); pin it for stable tests.
    locale: 'fr-FR',
    trace: 'retain-on-failure',
    // Reduced motion keeps screenshots and focus assertions deterministic.
    reducedMotion: 'reduce',
  },
  projects: [
    // Development server on the demo API (`pnpm demo` running, or API_PORT=3198 + demo seed).
    {
      name: 'desktop',
      testIgnore: '**/production/**',
      use: { ...devices['Desktop Chrome'], baseURL: DEV_URL },
    },
    {
      name: 'mobile',
      testIgnore: '**/production/**',
      use: { ...devices['Pixel 5'], baseURL: DEV_URL },
    },
    // Real production build served by `next start`: CSP, headers, no development panel.
    {
      name: 'built',
      testMatch: '**/production/**/*.spec.ts',
      use: { ...devices['Desktop Chrome'], baseURL: PROD_URL },
    },
  ],
  webServer: [
    {
      command: 'pnpm dev',
      url: `${DEV_URL}/fr`,
      env: { WEB_PORT: String(DEV_PORT), NEXT_PUBLIC_API_BASE_URL: API_ORIGIN },
      reuseExistingServer: !process.env.CI,
      timeout: 120_000,
    },
    // The built server (production-build tests) is skipped by E2E_SKIP_BUILD=1 (local runs).
    ...(process.env.E2E_SKIP_BUILD === '1'
      ? []
      : [
          {
            command: `pnpm exec next build && pnpm start -p ${String(PROD_PORT)}`,
            url: `${PROD_URL}/fr`,
            reuseExistingServer: !process.env.CI,
            timeout: 240_000,
            env: {
              NEXT_DIST_DIR: '.next-e2e',
              NEXT_PUBLIC_API_BASE_URL: 'https://api.example.test',
              NEXT_TELEMETRY_DISABLED: '1',
            },
          },
        ]),
  ],
});
