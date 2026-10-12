import type { Schemas } from '@flexipay/api-client';
import { delay, HttpResponse } from 'msw';
import { getApiOrigin } from '@/lib/env';
import { currentAccount, db } from '../db';
import type { DemoAccount } from '../fixtures/accounts';

type S = Schemas;

/** Absolute URL of an API route (handlers match the configured API origin). */
export function apiUrl(path: string): string {
  return `${getApiOrigin() ?? 'http://localhost:3000'}${path}`;
}

/**
 * Difficult cases on demand, from the page URL (development only):
 * `?mock=slow` (3 s per request), `?mock=error` (500 on reads), `?mock=empty` (empty lists).
 */
export function scenario(): 'slow' | 'error' | 'empty' | undefined {
  const search = typeof location === 'undefined' ? '' : location.search;
  const value = new URLSearchParams(search).get('mock');
  return value === 'slow' || value === 'error' || value === 'empty' ? value : undefined;
}

/** Realistic latency (and the slow scenario). */
export async function latency(): Promise<void> {
  if (scenario() === 'slow') await delay(3000);
  else if (typeof location !== 'undefined') await delay(250);
}

const kebab = (code: string): string => code.toLowerCase().replaceAll('_', '-');
const camel = (code: string): string =>
  code.toLowerCase().replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase());

/** RFC 9457 problem (`application/problem+json`) as described by the contract. */
export function problem(status: number, code: S['ProblemCode'], details?: Record<string, unknown>) {
  return HttpResponse.json(
    {
      type: `urn:flexipay:problem:${kebab(code)}`,
      title: code,
      status,
      code,
      messageKey: `errors.${camel(code)}`,
      requestId: crypto.randomUUID(),
      ...(details === undefined ? {} : { details }),
    },
    { status, headers: { 'Content-Type': 'application/problem+json' } },
  );
}

export function validationProblem(errors: { pointer: string; code: S['FieldErrorCode'] }[]) {
  return problem(400, 'VALIDATION_FAILED', {
    errors: errors.map((error) => ({
      in: 'body',
      pointer: error.pointer,
      code: error.code,
      messageKey: `fieldErrors.${error.code}`,
    })),
  });
}

/** Signed-in account with a complete session and the expected role, or the matching problem. */
export function requireRole(role: S['Role']): DemoAccount | Response {
  const account = currentAccount();
  if (account === undefined || db.session === null) return problem(401, 'UNAUTHENTICATED');
  if (db.session.step === 'PASSWORD_CHANGE') return problem(403, 'PASSWORD_CHANGE_REQUIRED');
  if (db.session.step === 'MFA_ENROLL') return problem(403, 'MFA_ENROLLMENT_REQUIRED');
  if (account.role !== role) return problem(403, 'FORBIDDEN');
  return account;
}

export function isResponse(value: unknown): value is Response {
  return value instanceof Response;
}

/** Reads list parameters of the contract (limit, cursor, withCount). */
export function listParams(request: Request) {
  const query = new URL(request.url).searchParams;
  const limit = Math.min(Math.max(Number(query.get('limit') ?? '20') || 20, 1), 100);
  const cursor = query.get('cursor');
  const offset =
    cursor === null
      ? 0
      : Number.parseInt(atob(cursor.replaceAll('-', '+').replaceAll('_', '/')), 10) || 0;
  return { query, limit, offset, withCount: query.get('withCount') === 'true' };
}

/** Cursor page `{ data, page }` with the bounded counter (contract §7). */
export function paginate<T>(
  items: readonly T[],
  request: Request,
): { data: T[]; page: S['PageInfo'] } {
  const { limit, offset, withCount } = listParams(request);
  const source = scenario() === 'empty' ? [] : items;
  const data = source.slice(offset, offset + limit);
  const hasMore = offset + limit < source.length;
  const nextCursor = hasMore
    ? btoa(String(offset + limit))
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_')
    : null;
  const page: S['PageInfo'] = { limit, hasMore, nextCursor };
  if (withCount)
    page.count = { value: Math.min(source.length, 10_000), isLowerBound: source.length > 10_000 };
  return { data, page };
}

/** Case-insensitive text filter (`q`). */
export function matches(query: string | null, ...values: string[]): boolean {
  if (query === null || query.trim() === '') return true;
  const needle = query.trim().toLowerCase();
  return values.some((value) => value.toLowerCase().includes(needle));
}

/** Common preamble of a read handler: latency, error scenario, role check. */
export async function guardRead(role: S['Role']): Promise<DemoAccount | Response> {
  await latency();
  if (scenario() === 'error') return problem(500, 'INTERNAL_ERROR');
  return requireRole(role);
}

/** Common preamble of a write handler: latency, role check, Idempotency-Key on financial writes. */
export async function guardWrite(
  request: Request,
  role: S['Role'],
  financial = false,
): Promise<DemoAccount | Response> {
  await latency();
  const account = requireRole(role);
  if (isResponse(account)) return account;
  if (financial && request.headers.get('Idempotency-Key') === null) {
    return problem(400, 'IDEMPOTENCY_KEY_REQUIRED');
  }
  return account;
}

// The mocked session survives page reloads (development reloads, F5) through a demo cookie set by
// MSW on the mocked responses; the data itself restarts from the seed after a reload.
export const MOCK_SESSION_COOKIE = 'fp_mock_session';

export function sessionCookie(session: { accountId: string; step: string } | null): HeadersInit {
  return {
    'Set-Cookie':
      session === null
        ? `${MOCK_SESSION_COOKIE}=; Path=/; Max-Age=0; SameSite=Strict`
        : `${MOCK_SESSION_COOKIE}=${session.accountId}.${session.step}; Path=/; SameSite=Strict`,
  };
}

/** Restores the session from the demo cookie when the in-memory state was lost (page reload). */
export function restoreSession(raw: string | undefined): void {
  if (db.session !== null || raw === undefined || raw === '') return;
  const [accountId, step] = raw.split('.');
  if (accountId === undefined || !db.accounts.some((account) => account.id === accountId)) return;
  if (step === 'NONE' || step === 'MFA_ENROLL') db.session = { accountId, step };
}

export function audit(action: string, target: string): void {
  const account = currentAccount();
  db.admin.audit.unshift({
    id: crypto.randomUUID(),
    occurredAt: new Date().toISOString(),
    actorName: account?.displayName ?? 'Système',
    action,
    target,
  });
}
