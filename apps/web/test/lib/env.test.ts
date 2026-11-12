import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { getApiOrigin } from '@/lib/env';

describe('getApiOrigin', () => {
  // The developer's shell may define NEXT_PUBLIC_API_BASE_URL: tests must not depend on it.
  beforeEach(() => {
    vi.stubEnv('NEXT_PUBLIC_API_BASE_URL', '');
  });
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('defaults to the local API of the contract in development', () => {
    expect(getApiOrigin(undefined, false)).toBe('http://localhost:3000');
    expect(getApiOrigin('', false)).toBe('http://localhost:3000');
  });

  it('keeps only the origin of a valid URL', () => {
    expect(getApiOrigin('https://api.example.test/v1/', true)).toBe('https://api.example.test');
  });

  it('refuses plain HTTP in production (fails closed)', () => {
    expect(getApiOrigin('http://api.example.test', true)).toBeUndefined();
    expect(getApiOrigin(undefined, true)).toBeUndefined();
  });

  it('accepts plain HTTP in production only on the loopback of a build marked local', () => {
    expect(getApiOrigin('http://localhost:3198', true, true)).toBe('http://localhost:3198');
    expect(getApiOrigin('http://127.0.0.1:3198', true, true)).toBe('http://127.0.0.1:3198');
    expect(getApiOrigin('http://localhost.example.test', true, true)).toBeUndefined();
    expect(getApiOrigin('http://10.0.0.5:3198', true, true)).toBeUndefined();
    // Not marked local: a production build never talks HTTP, even to the loopback.
    expect(getApiOrigin('http://localhost:3198', true, false)).toBeUndefined();
  });

  it.each(['not a url', 'javascript:alert(1)', 'ftp://api.example.test', 'data:text/plain,x'])(
    'refuses %s',
    (raw) => {
      expect(getApiOrigin(raw, false)).toBeUndefined();
    },
  );
});
