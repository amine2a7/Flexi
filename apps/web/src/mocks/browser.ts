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
    .then(() => {
      keepActive();
    });
  return started;
}

/**
 * The worker keeps its active clients in memory and forgets them when the browser restarts it or
 * when another tab of the same origin closes (it then bypasses every request: they reached the
 * network). Telling it again every few seconds that this page mocks keeps every request mocked.
 */
function keepActive(): void {
  const activate = () => {
    navigator.serviceWorker.controller?.postMessage('MOCK_ACTIVATE');
  };
  setInterval(activate, REACTIVATE_MS);
  document.addEventListener('visibilitychange', activate);
}

const REACTIVATE_MS = 3_000;
