// securite B5-S02: every route of every controller declares who may call it. A new route without
// @Public(), @Can(...) or @Self() fails here (and is refused at runtime by the global guard).
import 'reflect-metadata';
import { readdirSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants.js';
import { describe, expect, it } from 'vitest';
import { PERMISSIONS, PUBLIC } from '../../src/common/decorators.js';

const SRC = join(import.meta.dirname, '..', '..', 'src');

function controllerFiles(dir: string): string[] {
  return readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) return entry.name === 'generated' ? [] : controllerFiles(path);
    return entry.name.endsWith('.controller.ts') ? [path] : [];
  });
}

interface Route {
  readonly name: string;
  readonly isPublic: boolean;
  readonly permissions: unknown;
}

async function routes(): Promise<Route[]> {
  const found: Route[] = [];
  for (const file of controllerFiles(SRC)) {
    const module = (await import(pathToFileURL(file).href)) as Record<string, unknown>;
    for (const exported of Object.values(module)) {
      if (typeof exported !== 'function') continue;
      const controller = exported as new (...args: never[]) => unknown;
      if (Reflect.getMetadata(PATH_METADATA, controller) === undefined) continue;
      const proto = controller.prototype as Record<string, unknown>;
      for (const key of Object.getOwnPropertyNames(proto)) {
        const handler = proto[key];
        if (key === 'constructor' || typeof handler !== 'function') continue;
        if (Reflect.getMetadata(METHOD_METADATA, handler) === undefined) continue;
        const read = (meta: string): unknown =>
          (Reflect.getMetadata(meta, handler) as unknown) ??
          (Reflect.getMetadata(meta, controller) as unknown);
        found.push({
          name: `${controller.name}.${key}`,
          isPublic: read(PUBLIC) === true,
          permissions: read(PERMISSIONS),
        });
      }
    }
  }
  return found;
}

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
