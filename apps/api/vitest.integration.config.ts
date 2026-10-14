import { defineConfig } from 'vitest/config';

// Integration tests against the local PostgreSQL test database (DB_NAME=flexipay_test).
export default defineConfig({
  test: {
    include: ['test/integration/**/*.test.ts'],
    environment: 'node',
    fileParallelism: false,
    testTimeout: 60_000,
    hookTimeout: 120_000,
  },
});
