import { defineConfig } from 'vitest/config';

// Integration tests against the local PostgreSQL test database (flexipay_test, recreated per run).
export default defineConfig({
  test: {
    include: ['test/integration/**/*.test.ts'],
    environment: 'node',
    globalSetup: ['test/integration/global-setup.ts'],
    fileParallelism: false,
    testTimeout: 120_000,
    hookTimeout: 180_000,
  },
});
