import { defineConfig } from 'vitest/config';

// Unit tests: no database (pure functions, money, crypto, validation).
export default defineConfig({
  test: {
    include: ['test/unit/**/*.test.ts'],
    environment: 'node',
  },
});
