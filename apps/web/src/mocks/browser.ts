import { setupWorker } from 'msw/browser';
import { getApiOrigin } from '@/lib/env';
import { handlers } from './handlers';

const worker = setupWorker(...handlers);
let started: Promise<void> | undefined;

/**
 * Starts the service worker (served from /mockServiceWorker.js, copied by `pnpm dev`).
 * Idempotent: React strict mode runs effects twice in development.
 */
export function startMocking(): Promise<void> {
  started ??= worker
    .start({
      serviceWorker: { url: '/mockServiceWorker.js' },
      quiet: true,
      // Only requests to the API must be mocked; Next.js own requests pass through untouched.
      onUnhandledRequest(request, print) {
        if (new URL(request.url).origin === getApiOrigin()) print.error();
      },
    })
    .then(() => undefined);
  return started;
}
