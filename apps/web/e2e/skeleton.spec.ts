import { expect, test } from '@playwright/test';

test.describe('application skeleton', () => {
  test('redirects / to the French locale (LTR)', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveURL(/\/fr$/);
    await expect(page.locator('html')).toHaveAttribute('lang', 'fr');
    await expect(page.locator('html')).toHaveAttribute('dir', 'ltr');
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  });

  test('serves Arabic right-to-left and mirrors the layout', async ({ page }) => {
    await page.goto('/ar');
    await expect(page.locator('html')).toHaveAttribute('lang', 'ar');
    await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
    const brand = await page.locator('header span').first().boundingBox();
    const switcher = await page.getByRole('navigation', { name: 'اللغة' }).boundingBox();
    // Logical layout: the brand sits at the start (right) and the language links at the end (left).
    expect(brand).not.toBeNull();
    expect(switcher).not.toBeNull();
    expect((brand?.x ?? 0) > (switcher?.x ?? 0)).toBe(true);
  });

  test('switches language and keeps the path', async ({ page }) => {
    await page.goto('/fr');
    await page.getByRole('link', { name: 'English' }).click();
    await expect(page).toHaveURL(/\/en$/);
    await expect(page.locator('html')).toHaveAttribute('lang', 'en');
    await expect(
      page.getByRole('heading', { level: 1, name: 'Application skeleton' }),
    ).toBeVisible();
  });

  test('skip link is the first focusable element and reaches the main content', async ({
    page,
    isMobile,
  }) => {
    test.skip(isMobile, 'keyboard navigation is a desktop concern');
    await page.goto('/fr');
    // The app renders once the API mock worker is ready (development): wait for it.
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    await page.keyboard.press('Tab');
    const skip = page.getByRole('link', { name: 'Aller au contenu principal' });
    await expect(skip).toBeFocused();
    await expect(skip).toBeVisible();
    await page.keyboard.press('Enter');
    await expect(page.locator('#main-content')).toBeFocused();
  });

  test('shows the localized not-found page for an unknown path', async ({ page }) => {
    await page.goto('/en/does-not-exist');
    await expect(page.getByRole('heading', { level: 1, name: 'Not found' })).toBeVisible();
  });

  test('does not overflow horizontally at the minimum supported width', async ({ page }) => {
    await page.setViewportSize({ width: 360, height: 640 });
    await page.goto('/ar');
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    const overflow = await page.evaluate(
      () => document.documentElement.scrollWidth > document.documentElement.clientWidth,
    );
    expect(overflow).toBe(false);
  });

  test('registers the API mock service worker in development', async ({ page }) => {
    await page.goto('/fr');
    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    const active = await page.evaluate(async () => {
      const registration = await navigator.serviceWorker.getRegistration();
      return registration?.active?.scriptURL ?? null;
    });
    expect(active).toContain('/mockServiceWorker.js');
  });

  test('raises no console error and no page error', async ({ page }) => {
    const problems: string[] = [];
    page.on('console', (message) => {
      if (message.type() === 'error') problems.push(message.text());
    });
    page.on('pageerror', (error) => problems.push(error.message));
    for (const path of ['/fr', '/ar', '/en']) {
      await page.goto(path);
      await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    }
    expect(problems).toEqual([]);
  });
});
