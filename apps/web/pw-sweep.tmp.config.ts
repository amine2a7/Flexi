import { defineConfig, devices } from '@playwright/test';
export default defineConfig({
  testDir: 'D:/Project/Flexi/Flexi/apps/web/e2e',
  testMatch: ['dev-library.spec.ts', 'login.spec.ts', 'admin-subroles.spec.ts', 'pages-sweep.spec.ts'],
  workers: 1,
  timeout: 120_000,
  expect: { timeout: 20_000 },
  reporter: [['line']],
  use: { ...devices['Desktop Chrome'], channel: 'msedge', locale: 'fr-FR', baseURL: 'http://localhost:3001' },
  webServer: { command: 'pnpm dev', cwd: 'D:/Project/Flexi/Flexi/apps/web', url: 'http://localhost:3001/fr', reuseExistingServer: true, timeout: 180_000 },
});
