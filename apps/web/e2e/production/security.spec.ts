import { expect, test, type Page } from '@playwright/test';

// Runs against `next build` + `next start` (NODE_ENV=production): the real CSP and headers.
interface CspWindow {
  __csp: string[];
  __pwned?: boolean;
}

async function trackViolations(page: Page): Promise<() => Promise<string[]>> {
  await page.addInitScript(() => {
    const target = window as unknown as CspWindow;
    target.__csp = [];
    document.addEventListener('securitypolicyviolation', (event) => {
      target.__csp.push(`${event.violatedDirective} ${event.blockedURI}`);
    });
  });
  return () => page.evaluate(() => (window as unknown as CspWindow).__csp);
}

const nonceOf = (csp: string | undefined): string | undefined =>
  /'nonce-([^']+)'/.exec(csp ?? '')?.[1];

test.describe('production security', () => {
  test('sends the strict CSP and the security headers on pages', async ({ request }) => {
    const response = await request.get('/fr');
    expect(response.status()).toBe(200);
    const headers = response.headers();
    const csp = headers['content-security-policy'] ?? '';
    expect(csp).toMatch(/script-src 'self' 'nonce-[\w+/=]+' 'strict-dynamic'/);
    expect(csp).not.toContain('unsafe-inline');
    expect(csp).not.toContain('unsafe-eval');
    expect(csp).toContain("frame-ancestors 'none'");
    expect(csp).toContain("connect-src 'self' https://api.example.test");
    expect(headers['referrer-policy']).toBe('no-referrer');
    expect(headers['x-content-type-options']).toBe('nosniff');
    expect(headers['x-frame-options']).toBe('DENY');
    expect(headers['cross-origin-opener-policy']).toBe('same-origin');
    expect(headers['cross-origin-resource-policy']).toBe('same-origin');
    // Camera for the page itself only: the beneficiary scans the merchant QR.
    expect(headers['permissions-policy']).toContain('camera=(self)');
    expect(headers['strict-transport-security']).toMatch(/^max-age=\d+; includeSubDomains$/);
    expect(headers['cache-control']).toBe('no-store');
    expect(headers['x-powered-by']).toBeUndefined();
  });

  test('stamps every inline script with the nonce of that very response', async ({ request }) => {
    const response = await request.get('/ar');
    const nonce = nonceOf(response.headers()['content-security-policy']);
    expect(nonce).toBeTruthy();
    const html = await response.text();
    const inline = [...html.matchAll(/<script(?![^>]*\ssrc=)([^>]*)>/g)];
    expect(inline.length).toBeGreaterThan(0);
    for (const [, attributes] of inline) expect(attributes).toContain(`nonce="${nonce ?? ''}"`);
  });

  test('uses a different nonce on every request', async ({ request }) => {
    const first = nonceOf((await request.get('/fr')).headers()['content-security-policy']);
    const second = nonceOf((await request.get('/fr')).headers()['content-security-policy']);
    expect(first).toBeTruthy();
    expect(first).not.toBe(second);
  });

  test('hydrates and works under the CSP, with no violation and no console error', async ({
    page,
  }) => {
    const violations = await trackViolations(page);
    const errors: string[] = [];
    page.on('console', (message) => {
      if (message.type() === 'error') errors.push(message.text());
    });
    page.on('pageerror', (error) => errors.push(error.message));

    await page.goto('/fr');
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    // A client-side navigation proves the scripts were allowed to run and hydrate.
    await page.getByRole('link', { name: 'العربية' }).click();
    await expect(page).toHaveURL(/\/ar$/);
    await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');

    expect(errors).toEqual([]);
    expect(await violations()).toEqual([]);
  });

  test('blocks injected inline handlers (XSS payloads do not run)', async ({ page }) => {
    const violations = await trackViolations(page);
    await page.goto('/fr');
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    await page.evaluate(() => {
      document.body.insertAdjacentHTML(
        'beforeend',
        '<img src="x" onerror="window.__pwned = true">',
      );
    });
    await page.waitForTimeout(300);
    expect(await page.evaluate(() => (window as unknown as CspWindow).__pwned)).toBeUndefined();
    expect((await violations()).some((entry) => entry.includes('script-src'))).toBe(true);
  });

  test('ships no mock: no service worker is registered', async ({ page }) => {
    // The absence of the worker file and of MSW code in the build is proved by Vitest
    // (test/build); here we check the behaviour of the running app.
    await page.goto('/fr');
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    const registrations = await page.evaluate(
      async () => (await navigator.serviceWorker.getRegistrations()).length,
    );
    expect(registrations).toBe(0);
  });

  test('serves no MSW code and no mock fixture to the browser', async ({ page }) => {
    const scripts = new Set<string>();
    page.on('response', (response) => {
      const url = response.url();
      if (url.includes('/_next/static/') && url.endsWith('.js')) scripts.add(url);
    });
    await page.goto('/fr');
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    expect(scripts.size).toBeGreaterThan(0);
    for (const url of scripts) {
      const body = await (await page.request.get(url)).text();
      expect(body, url).not.toMatch(/__FLEXIPAY_MOCK_FIXTURE__|mockServiceWorker|setupWorker/);
    }
  });

  test('sets only the language cookie, Secure and SameSite=Strict', async ({ request }) => {
    const response = await request.get('/fr', { maxRedirects: 0 });
    const cookies = response
      .headersArray()
      .filter((header) => header.name.toLowerCase() === 'set-cookie')
      .map((header) => header.value);
    expect(cookies).toHaveLength(1);
    expect(cookies[0]).toMatch(/^NEXT_LOCALE=fr;/);
    expect(cookies[0]?.toLowerCase()).toContain('samesite=strict');
    expect(cookies[0]).toContain('Secure');
  });

  test('answers an unknown page with a real 404, still under the CSP', async ({ request }) => {
    const response = await request.get('/fr/does-not-exist');
    expect(response.status()).toBe(404);
    expect(response.headers()['content-security-policy']).toContain("frame-ancestors 'none'");
  });

  test('puts the CSP on a page whose path contains a dot', async ({ request }) => {
    const response = await request.get('/fr/a.b');
    expect(response.status()).toBe(404);
    expect(response.headers()['content-security-policy']).toContain("frame-ancestors 'none'");
    expect(response.headers()['cache-control']).toBe('no-store');
  });

  test('serves static assets with the baseline headers and immutable caching', async ({
    page,
    request,
  }) => {
    await page.goto('/fr');
    const asset = await page.evaluate(
      () => document.querySelector<HTMLLinkElement>('link[rel="stylesheet"]')?.href ?? '',
    );
    expect(asset).toContain('/_next/static/');
    const response = await request.get(asset);
    expect(response.status()).toBe(200);
    expect(response.headers()['x-content-type-options']).toBe('nosniff');
    expect(response.headers()['cache-control']).toContain('immutable');
  });
});
