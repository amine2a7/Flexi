import { http, HttpResponse } from 'msw';
import { afterAll, afterEach, beforeAll, describe, expect, it } from 'vitest';
import { server } from '@/mocks/server';

// Proves the Node-side mock server works for unit tests; real handlers are typed with
// @flexipay/api-client and added screen by screen.
describe('MSW node server', () => {
  beforeAll(() => {
    server.listen({ onUnhandledRequest: 'error' });
  });
  afterEach(() => {
    server.resetHandlers();
  });
  afterAll(() => {
    server.close();
  });

  it('answers requests with the handlers it is given', async () => {
    server.use(http.get('http://localhost:3000/health', () => HttpResponse.json({ status: 'OK' })));
    const response = await fetch('http://localhost:3000/health');
    expect(response.status).toBe(200);
    expect(await response.json()).toEqual({ status: 'OK' });
  });

  it('fails loudly on a request nobody mocked', async () => {
    await expect(fetch('http://localhost:3000/v1/unknown')).rejects.toThrow();
  });
});
