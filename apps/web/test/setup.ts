import { afterEach } from 'vitest';

// Unmount React trees rendered by @testing-library/react between tests (jsdom files only).
afterEach(async () => {
  if (typeof document === 'undefined') return;
  const { cleanup } = await import('@testing-library/react');
  cleanup();
});
