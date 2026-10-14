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
