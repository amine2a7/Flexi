import { defineConfig, devices } from '@playwright/test';

const DEV_PORT = 3001;
const PROD_PORT = 3002;
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
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? [['github'], ['html', { open: 'never' }]] : [['list']],
  use: {
    // Full Chromium (new headless mode): no separate headless-shell download needed.
    channel: 'chromium',
    // The browser language drives the first redirect of / (Accept-Language); pin it for stable tests.
    locale: 'fr-FR',
    trace: 'retain-on-failure',
    // Reduced motion keeps screenshots and focus assertions deterministic.
    reducedMotion: 'reduce',
  },
  projects: [
    // Development server with the API mocked by MSW: no backend needed.
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
    // Real production build served by `next start`: CSP, headers, no mocks.
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
      reuseExistingServer: !process.env.CI,
      timeout: 120_000,
    },
    {
      // `next build` directly: the `build` script deletes public/mockServiceWorker.js, which the dev
      // server above needs while both run together (the script itself is covered by Vitest).
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
  ],
});
