import type { RequestHandler } from 'express';

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

/** POST /__test/clock?days=N on the loopback: the new time; GET: the current time. */
export const testClockHandler: RequestHandler = (req, res) => {
  const remote = req.socket.remoteAddress ?? '';
  if (!['127.0.0.1', '::1', '::ffff:127.0.0.1'].includes(remote)) {
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
