import type { Request, RequestHandler } from 'express';

/**
 * Test clock of the end-to-end journey (request of 2026-11-12): the days of the whole API process
 * move forward (payment caps per day, settlement at D+2, expiries), so that a test can play
 * several days in a few minutes. Installed only when TEST_CLOCK=1, which loadEnv refuses in
 * production; reached only on the loopback, outside the contract and the authenticated routes.
 * `new Date()` and `Date.now()` move; a date built from a given value stays as given.
 */
const RealDate = Date;
const DAY_MS = 86_400_000;
const MAX_STEP_DAYS = 60;
let offsetMs = 0;
let installed = false;

export function installTestClock(): void {
  if (installed) return;
  installed = true;
  function TestDate(this: unknown, ...args: unknown[]): unknown {
    // Called without `new`: a string, like Date() (new.target is then undefined at run time).
    if (!(new.target as unknown)) return new RealDate(RealDate.now() + offsetMs).toString();
    if (args.length === 0) return new RealDate(RealDate.now() + offsetMs);
    return Reflect.construct(RealDate, args, new.target);
  }
  TestDate.prototype = RealDate.prototype;
  Object.setPrototypeOf(TestDate, RealDate);
  const shifted = TestDate as unknown as DateConstructor & { now: () => number };
  shifted.now = () => RealDate.now() + offsetMs;
  globalThis.Date = shifted;
}

/** Moves the clock forward by whole days (never backwards: the ledger only moves forward). */
export function advanceTestClock(days: number): void {
  if (!installed) throw new Error('test clock not installed');
  if (!Number.isInteger(days) || days < 1 || days > MAX_STEP_DAYS) {
    throw new Error(`test clock: 1 to ${String(MAX_STEP_DAYS)} days`);
  }
  offsetMs += days * DAY_MS;
}

/** Back to the real clock (unit tests). */
export function resetTestClock(): void {
  offsetMs = 0;
  if (installed) globalThis.Date = RealDate;
  installed = false;
}

const LOOPBACK = ['127.0.0.1', '::1', '::ffff:127.0.0.1'];
const LOCAL_HOSTS = ['localhost', '127.0.0.1', '[::1]'];
/** Header a test runner sends on purpose (a web page cannot send it without a preflight). */
export const TEST_HEADER = 'x-flexipay-test';

/**
 * A request of the local test runner only (securite, revue du 2026-11-12): from the loopback,
 * not relayed (no Forwarded / X-Forwarded-For / X-Real-IP: a tunnel or port forward shows
 * 127.0.0.1), not sent by a web page (no Origin), to a local Host, with the test header.
 */
export function isLocalTestRequest(req: Request): boolean {
  const host = (req.headers.host ?? '').replace(/:\d+$/, '');
  return (
    LOOPBACK.includes(req.socket.remoteAddress ?? '') &&
    req.headers.forwarded === undefined &&
    req.headers['x-forwarded-for'] === undefined &&
    req.headers['x-real-ip'] === undefined &&
    req.headers.origin === undefined &&
    LOCAL_HOSTS.includes(host) &&
    req.headers[TEST_HEADER] === '1'
  );
}

/** POST /__test/clock?days=N on the loopback: the new time; GET: the current time. */
export const testClockHandler: RequestHandler = (req, res) => {
  if (!isLocalTestRequest(req)) {
    res.status(404).end();
    return;
  }
  if (req.method === 'POST') {
    try {
      advanceTestClock(Number(req.query.days));
    } catch {
      res.status(400).json({ error: 'days: integer from 1 to 60' });
      return;
    }
  } else if (req.method !== 'GET') {
    res.status(405).end();
    return;
  }
  res.json({ now: new Date().toISOString(), offsetDays: offsetMs / DAY_MS });
};

/**
 * POST /__test/reconcile on the loopback: runs the reconciliation of the books now (the daily job
 * of the API) and answers whether they balance; a gap raises the usual « Écart du grand livre »
 * alert. Same guard as the clock: TEST_CLOCK=1, never in production.
 */
export function testReconcileHandler(reconcile: () => Promise<boolean>): RequestHandler {
  return (req, res) => {
    if (!isLocalTestRequest(req) || req.method !== 'POST') {
      res.status(404).end();
      return;
    }
    reconcile().then(
      (ok) => {
        res.json({ ok });
      },
      () => {
        res.status(500).json({ ok: false });
      },
    );
  };
}
