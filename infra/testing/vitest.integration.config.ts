import { defineConfig } from 'vitest/config';

// Integration tests: real containers through Testcontainers (Docker required).
// Run with `pnpm test:integration` at the repository root.
export default defineConfig({
  test: {
    include: ['test/integration/**/*.test.ts'],
    environment: 'node',
    testTimeout: 60_000,
    hookTimeout: 240_000,
    fileParallelism: false,
    env: {
      // Ryuk (reaper) would mount the Docker socket in a container and pull an unpinned image
      // (threat DC-4 / SC-7). Disabled: every test stops its containers in afterAll.
      TESTCONTAINERS_RYUK_DISABLED: 'true',
      // Ports are published on 127.0.0.1 only: connect through IPv4 loopback, never a resolved name.
      TESTCONTAINERS_HOST_OVERRIDE: '127.0.0.1',
    },
  },
});
