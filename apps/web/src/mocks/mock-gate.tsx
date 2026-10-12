'use client';

import { useEffect, useState, type ReactNode } from 'react';

/**
 * API mocking is a development tool: it is on by default in `next dev` (no backend yet) and can be
 * switched off with NEXT_PUBLIC_API_MOCKING=disabled. In a production build NODE_ENV is replaced
 * by "production", so this constant is false, the dynamic import below is dead code and the
 * bundler never includes MSW or the fixtures (proved by test/build/no-mocks-in-production.test.ts).
 */
const MOCKING_ENABLED =
  process.env.NODE_ENV !== 'production' && process.env.NEXT_PUBLIC_API_MOCKING !== 'disabled';

interface MockGateProps {
  readonly children: ReactNode;
}

/** Renders the app once the mock service worker is ready, so no first request escapes the mocks. */
export function MockGate({ children }: MockGateProps) {
  const [ready, setReady] = useState(!MOCKING_ENABLED);
  const [failure, setFailure] = useState<unknown>(undefined);

  useEffect(() => {
    if (!MOCKING_ENABLED) return undefined;
    let active = true;
    import('./browser')
      .then(async ({ startMocking }) => {
        await startMocking();
        if (active) setReady(true);
      })
      .catch((error: unknown) => {
        // Rethrown during render below so the error boundary (error.tsx) shows it: never a blank page.
        if (active) setFailure(error ?? new Error('API mocking failed to start'));
      });
    return () => {
      active = false;
    };
  }, []);

  if (failure !== undefined) throw failure instanceof Error ? failure : new Error('Mocking failed');
  return ready ? children : null;
}
