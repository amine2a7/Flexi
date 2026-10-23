import { WEB_CHANNEL_HEADER } from '@flexipay/api-client';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

// The CSRF token is kept in memory only: after a page reload the client recovers it through the
// session refresh before the first request that changes something (contract §6).

const API = 'http://localhost:3000';

interface Call {
  readonly url: string;
  readonly method: string;
  readonly csrf: string | null;
}

let calls: Call[] = [];

function stubFetch(refreshStatus = 200) {
  calls = [];
  vi.stubGlobal(
    'fetch',
    vi.fn(async (input: RequestInfo | URL, init?: RequestInit) => {
      const request = new Request(input, init);
      calls.push({
        url: request.url.replace(API, ''),
        method: request.method,
        csrf: request.headers.get('X-CSRF-Token'),
      });
      await Promise.resolve();
      if (request.url.endsWith('/v1/auth/refresh')) {
        return refreshStatus === 200
          ? Response.json({ nextStep: 'NONE', csrfToken: 'recovered-token' })
          : new Response(null, { status: refreshStatus });
      }
      return new Response(null, { status: 204 });
    }),
  );
}

async function freshClient() {
  vi.resetModules();
  return import('@/lib/api/client');
}

describe('API client: CSRF token after a page reload', () => {
  beforeEach(() => {
    vi.stubEnv('NEXT_PUBLIC_API_BASE_URL', API);
  });
  afterEach(() => {
    vi.unstubAllGlobals();
    vi.unstubAllEnvs();
  });

  it('refreshes the session once, then sends the recovered token', async () => {
    stubFetch();
    const { getApi } = await freshClient();
    await Promise.all([
      getApi().POST('/v1/me/onboarding-tour'),
      getApi().POST('/v1/me/onboarding-tour'),
    ]);
    expect(calls.filter((call) => call.url === '/v1/auth/refresh')).toHaveLength(1);
    const posts = calls.filter((call) => call.url === '/v1/me/onboarding-tour');
    expect(posts.map((call) => call.csrf)).toEqual(['recovered-token', 'recovered-token']);
  });

  it('never refreshes for a read or for a public sign-in route', async () => {
    stubFetch();
    const { getApi } = await freshClient();
    await getApi().GET('/v1/me');
    await getApi().POST('/v1/auth/login', {
      params: { header: WEB_CHANNEL_HEADER },
      body: { identifier: 'a@b.test', password: 'x' },
    });
    expect(calls.map((call) => call.url)).toEqual(['/v1/me', '/v1/auth/login']);
  });

  it('keeps the token given at sign-in (no refresh)', async () => {
    stubFetch();
    const { getApi, setCsrfToken } = await freshClient();
    setCsrfToken('signed-in-token');
    await getApi().POST('/v1/me/onboarding-tour');
    expect(calls).toEqual([
      { url: '/v1/me/onboarding-tour', method: 'POST', csrf: 'signed-in-token' },
    ]);
  });

  it('sends the request without a token when there is no session (the API answers)', async () => {
    stubFetch(401);
    const { getApi } = await freshClient();
    await getApi().POST('/v1/me/onboarding-tour');
    expect(calls.map((call) => [call.url, call.csrf])).toEqual([
      ['/v1/auth/refresh', null],
      ['/v1/me/onboarding-tour', null],
    ]);
  });
});

describe('API client: two tabs of one browser renew the session', () => {
  beforeEach(() => {
    vi.stubEnv('NEXT_PUBLIC_API_BASE_URL', API);
  });
  afterEach(() => {
    vi.useRealTimers();
    vi.unstubAllGlobals();
    vi.unstubAllEnvs();
  });

  /** Scripted answers, in order, for each path; records every call with its body. */
  function script(answers: Record<string, (() => Response)[]>) {
    const seen: { url: string; csrf: string | null; body: string }[] = [];
    vi.stubGlobal(
      'fetch',
      vi.fn(async (input: RequestInfo | URL, init?: RequestInit) => {
        const request = new Request(input, init);
        const url = request.url.replace(API, '');
        seen.push({ url, csrf: request.headers.get('X-CSRF-Token'), body: await request.text() });
        const next = answers[url]?.shift();
        return next === undefined ? new Response(null, { status: 204 }) : next();
      }),
    );
    return seen;
  }
  const problem = (status: number, code: string) => () =>
    Response.json(
      {
        type: 'urn:flexipay:problem:x',
        title: code,
        status,
        code,
        messageKey: 'x',
        requestId: 'r',
      },
      { status },
    );
  const session = (token: string) => () => Response.json({ nextStep: 'NONE', csrfToken: token });

  it('retries the refresh once when another tab renewed the session (409)', async () => {
    vi.useFakeTimers({ toFake: ['setTimeout'] });
    const seen = script({
      '/v1/auth/refresh': [problem(409, 'RESOURCE_STATE_CONFLICT'), session('second-try')],
    });
    const { getApi } = await freshClient();
    const done = getApi().POST('/v1/me/onboarding-tour');
    await vi.runAllTimersAsync();
    await done;
    expect(seen.map((call) => call.url)).toEqual([
      '/v1/auth/refresh',
      '/v1/auth/refresh',
      '/v1/me/onboarding-tour',
    ]);
    expect(seen.at(-1)?.csrf).toBe('second-try');
  });

  it('recovers the token and replays the request once, with its body, after a CSRF refusal', async () => {
    const seen = script({
      '/v1/company/employees': [problem(403, 'CSRF_TOKEN_INVALID')],
      '/v1/auth/refresh': [session('renewed')],
    });
    const { getApi, setCsrfToken } = await freshClient();
    setCsrfToken('stale');
    const body = {
      employeeNumber: 'E-1',
      firstName: 'Nour',
      lastName: 'Trabelsi',
      email: 'nour@exemple.tn',
      phone: '+21698111222',
    };
    const result = await getApi().POST('/v1/company/employees', { body });
    expect(result.response.status).toBe(204);
    expect(seen.map((call) => [call.url, call.csrf])).toEqual([
      ['/v1/company/employees', 'stale'],
      ['/v1/auth/refresh', null],
      ['/v1/company/employees', 'renewed'],
    ]);
    expect(JSON.parse(seen[2]?.body ?? '{}')).toEqual(body);
  });

  it('replays a financial request with the SAME Idempotency-Key (that is what makes it safe)', async () => {
    const headers: (string | null)[] = [];
    vi.stubGlobal(
      'fetch',
      vi.fn(async (input: RequestInfo | URL, init?: RequestInit) => {
        const request = new Request(input, init);
        await Promise.resolve();
        if (request.url.endsWith('/v1/auth/refresh')) return session('renewed')();
        headers.push(request.headers.get('Idempotency-Key'));
        return headers.length === 1
          ? problem(403, 'CSRF_TOKEN_INVALID')()
          : new Response(null, { status: 204 });
      }),
    );
    const { getApi, setCsrfToken } = await freshClient();
    setCsrfToken('stale');
    const key = crypto.randomUUID();
    const result = await getApi().POST('/v1/merchant/payouts', {
      params: { header: { 'Idempotency-Key': key } },
      body: { quoteId: crypto.randomUUID() },
    });
    expect(result.response.status).toBe(204);
    expect(headers).toEqual([key, key]);
  });

  it('forgets the copy of a request when the network fails (no body kept in memory)', async () => {
    vi.stubGlobal(
      'fetch',
      vi.fn(async () => {
        await Promise.resolve();
        throw new TypeError('Failed to fetch');
      }),
    );
    const { getApi, setCsrfToken, pendingReplayCopies } = await freshClient();
    setCsrfToken('token');
    await expect(getApi().POST('/v1/me/onboarding-tour')).rejects.toThrow('Failed to fetch');
    expect(pendingReplayCopies()).toBe(0);
  });

  it('forgets the copy once the answer arrived', async () => {
    script({});
    const { getApi, setCsrfToken, pendingReplayCopies } = await freshClient();
    setCsrfToken('token');
    await getApi().POST('/v1/me/onboarding-tour');
    expect(pendingReplayCopies()).toBe(0);
  });

  it('does not loop: a second CSRF refusal is returned as is', async () => {
    const seen = script({
      '/v1/me/onboarding-tour': [
        problem(403, 'CSRF_TOKEN_INVALID'),
        problem(403, 'CSRF_TOKEN_INVALID'),
      ],
      '/v1/auth/refresh': [session('renewed')],
    });
    const { getApi, setCsrfToken } = await freshClient();
    setCsrfToken('stale');
    const result = await getApi().POST('/v1/me/onboarding-tour');
    expect(result.response.status).toBe(403);
    expect(seen.filter((call) => call.url === '/v1/me/onboarding-tour')).toHaveLength(2);
  });
});
