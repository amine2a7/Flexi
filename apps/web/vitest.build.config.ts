import { defineConfig } from 'vitest/config';

// Checks of the production build output: `pnpm test:build`, to run after `pnpm build`.
export default defineConfig({
  test: {
    include: ['test/build/**/*.test.ts'],
    environment: 'node',
  },
});
