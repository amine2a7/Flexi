// securite B5-S02: every route of every controller declares who may call it. A new route without
// @Public(), @Can(...) or @Self() fails here (and is refused at runtime by the global guard).
import { describe, expect, it } from 'vitest';
import { routes } from '../routes.js';

describe('route permissions (deny by default)', () => {
  it('every non-public route declares its permission', async () => {
    const all = await routes();
    expect(all.length).toBeGreaterThan(90);
    const missing = all
      .filter((route) => !route.isPublic)
      .filter((route) => !Array.isArray(route.permissions) || route.permissions.length === 0)
      .map((route) => route.name);
    expect(missing).toEqual([]);
  }, 30_000); // builds the whole Nest application: slow on a busy machine
});
