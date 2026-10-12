import { describe, expect, it } from 'vitest';
import type { Middleware } from 'openapi-fetch';
import {
  createApiClient,
  csrfMiddleware,
  isKnownProblemCode,
  isProblem,
  WEB_CHANNEL_HEADER,
} from '../src/index.js';

interface Captured {
  request: Request;
}

function fakeFetch(captured: Captured[], response: () => Response) {
  return (input: Request): Promise<Response> => {
    captured.push({ request: input });
    return Promise.resolve(response());
  };
}

const json = (body: unknown, status = 200, type = 'application/json') =>
  new Response(JSON.stringify(body), { status, headers: { 'Content-Type': type } });

describe('createApiClient', () => {
  it('calls GET /health on the base URL and returns typed data', async () => {
    const captured: Captured[] = [];
    const api = createApiClient({
      baseUrl: 'http://localhost:3000',
      fetch: fakeFetch(captured, () => json({ status: 'OK' })),
    });
    const { data, error } = await api.GET('/health');
    expect(error).toBeUndefined();
    expect(data).toEqual({ status: 'OK' });
    expect(captured[0]?.request.url).toBe('http://localhost:3000/health');
    expect(captured[0]?.request.method).toBe('GET');
  });

  it('sends session cookies (credentials: include) for the web session', async () => {
    const captured: Captured[] = [];
    const api = createApiClient({
      baseUrl: 'http://localhost:3000',
      fetch: fakeFetch(captured, () => json({ status: 'OK' })),
    });
    await api.GET('/health');
    expect(captured[0]?.request.credentials).toBe('include');
  });

  it('never adds the CSRF token on safe methods', async () => {
    const captured: Captured[] = [];
    const api = createApiClient({
      baseUrl: 'http://localhost:3000',
      fetch: fakeFetch(captured, () => json({ status: 'OK' })),
      getCsrfToken: () => 'csrf-in-memory',
    });
    await api.GET('/health');
    expect(captured[0]?.request.headers.get('X-CSRF-Token')).toBeNull();
  });

  it('returns RFC 9457 problems as typed errors', async () => {
    const problem = {
      type: 'urn:flexipay:problem:rate-limited',
      title: 'Rate limited',
      status: 429,
      code: 'RATE_LIMITED',
      messageKey: 'errors.rateLimited',
      requestId: '0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21',
      details: { retryAfterSeconds: 30 },
    };
    const api = createApiClient({
      baseUrl: 'http://localhost:3000',
      fetch: fakeFetch([], () => json(problem, 429, 'application/problem+json')),
    });
    const { data, error, response } = await api.GET('/health');
    expect(data).toBeUndefined();
    expect(response.status).toBe(429);
    expect(isProblem(error)).toBe(true);
    if (isProblem(error)) expect(error.code).toBe('RATE_LIMITED');
  });
});

type OnRequest = NonNullable<Middleware['onRequest']>;

async function runOnRequest(middleware: Middleware, request: Request) {
  const { onRequest } = middleware;
  if (onRequest === undefined) throw new Error('csrfMiddleware must define onRequest');
  return onRequest({
    request,
    schemaPath: '/v1/x',
    params: {},
    options: {} as Parameters<OnRequest>[0]['options'],
    id: 'test',
  });
}

describe('csrfMiddleware (unsafe methods)', () => {
  it('adds X-CSRF-Token on POST, PUT, PATCH and DELETE when a token is held in memory', async () => {
    const middleware = csrfMiddleware(() => 'csrf-in-memory');
    for (const method of ['POST', 'PUT', 'PATCH', 'DELETE']) {
      const out = await runOnRequest(
        middleware,
        new Request('http://localhost:3000/v1/x', { method }),
      );
      expect(out instanceof Request ? out.headers.get('X-CSRF-Token') : null).toBe(
        'csrf-in-memory',
      );
    }
  });

  it('leaves the request unchanged when no token is held', async () => {
    const middleware = csrfMiddleware(() => undefined);
    const out = await runOnRequest(
      middleware,
      new Request('http://localhost:3000/v1/x', { method: 'POST' }),
    );
    expect(out).toBeUndefined();
  });
});

describe('isProblem', () => {
  const base = {
    type: 'urn:flexipay:problem:not-found',
    title: 'Not found',
    status: 404,
    code: 'NOT_FOUND',
    messageKey: 'errors.notFound',
    requestId: '0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21',
  };

  it('accepts an RFC 9457 problem of the contract', () => {
    expect(isProblem(base)).toBe(true);
  });

  it('accepts an unknown code (non-breaking addition) but does not type it as a known code', () => {
    const problem: unknown = {
      ...base,
      code: 'UNKNOWN_CODE',
      type: 'urn:flexipay:problem:unknown-code',
    };
    expect(isProblem(problem)).toBe(true);
    if (isProblem(problem)) expect(isKnownProblemCode(problem.code)).toBe(false);
    expect(isKnownProblemCode('NOT_FOUND')).toBe(true);
  });

  it('rejects values that are not Problem Details', () => {
    expect(isProblem(undefined)).toBe(false);
    expect(isProblem({ code: 1 })).toBe(false);
    expect(isProblem({ status: 400, code: 'VALIDATION_FAILED' })).toBe(false);
    expect(isProblem({ ...base, type: 'about:blank' })).toBe(false);
    expect(isProblem({ ...base, title: 3 })).toBe(false);
  });
});

describe('auth routes (contract 0.2.0)', () => {
  it('sends X-CSRF-Token and X-FlexiPay-Client on POST /v1/auth/logout', async () => {
    const captured: Captured[] = [];
    const api = createApiClient({
      baseUrl: 'http://localhost:3000',
      fetch: fakeFetch(captured, () => new Response(null, { status: 204 })),
      getCsrfToken: () => 'csrf-in-memory',
    });
    const { response } = await api.POST('/v1/auth/logout', {
      params: { header: WEB_CHANNEL_HEADER },
    });
    expect(response.status).toBe(204);
    expect(captured[0]?.request.headers.get('X-CSRF-Token')).toBe('csrf-in-memory');
    expect(captured[0]?.request.headers.get('X-FlexiPay-Client')).toBe('web');
  });

  it('types the login result as an MFA challenge or a session', async () => {
    const api = createApiClient({
      baseUrl: 'http://localhost:3000',
      fetch: fakeFetch([], () =>
        json({
          nextStep: 'MFA_CHALLENGE',
          challengeId: '0192f0c4-6a1e-7c3b-9d2e-5b7a1f0e4c21',
          challengeExpiresAt: '2026-10-11T08:35:00.000Z',
        }),
      ),
    });
    const { data } = await api.POST('/v1/auth/login', {
      params: { header: WEB_CHANNEL_HEADER },
      body: { identifier: 'owner@example.test', password: 'not-a-real-password' },
    });
    expect(data?.nextStep).toBe('MFA_CHALLENGE');
    if (data?.nextStep === 'MFA_CHALLENGE') expect(data.challengeId).toMatch(/^[0-9a-f-]{36}$/);
  });
});
