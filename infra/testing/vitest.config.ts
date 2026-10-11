import { defineConfig } from 'vitest/config';

// Unit tests only: no Docker required (run by `pnpm test`).
export default defineConfig({
  test: {
    include: ['test/unit/**/*.test.ts'],
    environment: 'node',
  },
});
