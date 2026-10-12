import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  resolve: {
    alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) },
  },
  test: {
    include: ['test/**/*.test.{ts,tsx}'],
    // Build-output checks need `pnpm build` first: they run in `pnpm test:build`.
    exclude: ['test/build/**', '**/node_modules/**'],
    environment: 'node',
    // Component tests opt in to jsdom with a `// @vitest-environment jsdom` docblock.
    setupFiles: ['./test/setup.ts'],
    // next-intl imports 'next/server' without extension: let Vite resolve it.
    server: { deps: { inline: ['next-intl'] } },
  },
});
