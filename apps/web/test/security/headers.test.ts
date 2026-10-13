import { describe, expect, it } from 'vitest';
import {
  buildContentSecurityPolicy,
  buildStaticSecurityHeaders,
  createNonce,
} from '@/lib/security/headers';

const API = 'https://api.example.test';
const directive = (csp: string, name: string): string[] =>
  csp
    .split('; ')
    .find((part) => part.startsWith(`${name} `) || part === name)
    ?.split(' ')
    .slice(1) ?? [];

describe('Content-Security-Policy (production)', () => {
  const csp = buildContentSecurityPolicy({ nonce: 'abc123', isDevelopment: false, apiOrigin: API });

  it('allows scripts and styles only from self and the request nonce', () => {
    expect(directive(csp, 'script-src')).toEqual(["'self'", "'nonce-abc123'", "'strict-dynamic'"]);
    expect(directive(csp, 'style-src')).toEqual(["'self'", "'nonce-abc123'"]);
  });

  it('never allows unsafe-inline, unsafe-eval or wildcards', () => {
    expect(csp).not.toContain('unsafe-inline');
    expect(csp).not.toContain('unsafe-eval');
    expect(csp).not.toMatch(/(^|\s)\*(\s|;|$)/);
    expect(csp).not.toMatch(/\bhttps?:(\s|;|$)/);
  });

  it('forbids framing, plugins, other bases and foreign form targets', () => {
    expect(directive(csp, 'frame-ancestors')).toEqual(["'none'"]);
    expect(directive(csp, 'frame-src')).toEqual(["'none'"]);
    expect(directive(csp, 'object-src')).toEqual(["'none'"]);
    expect(directive(csp, 'base-uri')).toEqual(["'self'"]);
    expect(directive(csp, 'form-action')).toEqual(["'self'"]);
    expect(directive(csp, 'worker-src')).toEqual(["'none'"]);
  });

  it('defaults everything else to self and upgrades insecure requests', () => {
    expect(directive(csp, 'default-src')).toEqual(["'self'"]);
    expect(csp.split('; ')).toContain('upgrade-insecure-requests');
  });

  it('lets the browser talk to the API origin only (plus self)', () => {
    expect(directive(csp, 'connect-src')).toEqual(["'self'", API]);
  });

  it('fails closed when the API origin is invalid', () => {
    const closed = buildContentSecurityPolicy({
      nonce: 'n',
      isDevelopment: false,
      apiOrigin: undefined,
    });
    expect(directive(closed, 'connect-src')).toEqual(["'self'"]);
  });
});

describe('Content-Security-Policy (development)', () => {
  const csp = buildContentSecurityPolicy({ nonce: 'n', isDevelopment: true, apiOrigin: API });

  it('only relaxes what the dev tooling needs: eval, inline styles, the mock worker', () => {
    expect(directive(csp, 'script-src')).toContain("'unsafe-eval'");
    expect(directive(csp, 'style-src')).toContain("'unsafe-inline'");
    expect(directive(csp, 'worker-src')).toEqual(["'self'"]);
    expect(directive(csp, 'frame-ancestors')).toEqual(["'none'"]);
    expect(csp).not.toContain('upgrade-insecure-requests');
  });
});

describe('static security headers', () => {
  const asMap = (isProduction: boolean): Map<string, string> =>
    new Map(buildStaticSecurityHeaders(isProduction).map(({ key, value }) => [key, value]));

  it('sets the baseline headers everywhere', () => {
    const headers = asMap(false);
    expect(headers.get('Referrer-Policy')).toBe('no-referrer');
    expect(headers.get('X-Content-Type-Options')).toBe('nosniff');
    expect(headers.get('X-Frame-Options')).toBe('DENY');
    expect(headers.get('Cross-Origin-Opener-Policy')).toBe('same-origin');
    expect(headers.get('Cross-Origin-Resource-Policy')).toBe('same-origin');
    expect(headers.get('Permissions-Policy')).toContain('camera=(self)');
    expect(headers.get('Permissions-Policy')).toContain('geolocation=()');
  });

  it('sends HSTS in production only (development runs on http://localhost)', () => {
    expect(asMap(false).has('Strict-Transport-Security')).toBe(false);
    expect(asMap(true).get('Strict-Transport-Security')).toMatch(
      /^max-age=\d{8,}; includeSubDomains$/,
    );
  });
});

describe('createNonce', () => {
  it('returns 128 bits of base64 that differ on every call', () => {
    const nonces = new Set(Array.from({ length: 50 }, createNonce));
    expect(nonces.size).toBe(50);
    for (const nonce of nonces) expect(nonce).toMatch(/^[A-Za-z0-9+/]{22}==$/);
  });
});
