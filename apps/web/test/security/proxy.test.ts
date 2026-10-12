import { NextRequest } from 'next/server';
import { describe, expect, it } from 'vitest';
import proxy, { config } from '@/proxy';

// Next.js compiles a matcher into `^<matcher>$` (path-to-regexp with a raw regex group).
const matcher = new RegExp(`^${config.matcher[0] ?? ''}$`);

describe('proxy matcher', () => {
  it.each(['/', '/fr', '/ar/anything', '/fr/a.b', '/en/report.pdf', '/fr/x.y/z'])(
    'runs on the page %s (so it gets the CSP)',
    (path) => {
      expect(matcher.test(path)).toBe(true);
    },
  );

  it.each([
    '/_next/static/chunks/app.js',
    '/_next/image',
    '/favicon.ico',
    '/icon.svg',
    '/robots.txt',
    '/mockServiceWorker.js',
  ])('skips the static file %s', (path) => {
    expect(matcher.test(path)).toBe(false);
  });
});

const call = (path: string, headers?: Record<string, string>) =>
  proxy(new NextRequest(`http://localhost:3001${path}`, { headers }));

describe('proxy', () => {
  it('sets a CSP with a fresh nonce on every page response', () => {
    const first = call('/fr').headers.get('content-security-policy');
    const second = call('/fr').headers.get('content-security-policy');
    expect(first).toMatch(/script-src 'self' 'nonce-[^']+' 'strict-dynamic'/);
    expect(first).not.toEqual(second);
  });

  it('forwards the same nonce to the page (request header) so Next.js can stamp its scripts', () => {
    const response = call('/ar');
    const csp = response.headers.get('content-security-policy') ?? '';
    const nonce = /'nonce-([^']+)'/.exec(csp)?.[1];
    expect(nonce).toBeDefined();
    expect(response.headers.get('x-middleware-request-x-nonce')).toBe(nonce);
    expect(response.headers.get('x-middleware-request-content-security-policy')).toBe(csp);
  });

  it('never lets HTML be cached', () => {
    expect(call('/en').headers.get('cache-control')).toBe('no-store');
  });

  it('ignores a CSP or nonce header sent by the client', () => {
    const forged = call('/fr', { 'content-security-policy': 'default-src *', 'x-nonce': 'forged' });
    const csp = forged.headers.get('content-security-policy') ?? '';
    expect(csp).not.toContain('default-src *');
    expect(forged.headers.get('x-middleware-request-x-nonce')).not.toBe('forged');
  });

  it('keeps redirecting / to the default locale, with the policy', () => {
    const response = call('/');
    expect(response.status).toBe(307);
    expect(response.headers.get('location')).toBe('http://localhost:3001/fr');
    expect(response.headers.get('content-security-policy')).toContain("frame-ancestors 'none'");
  });

  it('sets the language cookie with SameSite=Strict and nothing else', () => {
    const cookie = call('/ar').headers.get('set-cookie') ?? '';
    expect(cookie).toMatch(/^NEXT_LOCALE=ar;/);
    expect(cookie.toLowerCase()).toContain('samesite=strict');
    expect(cookie.toLowerCase()).not.toContain('domain=');
  });
});
