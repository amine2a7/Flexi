// Every route of every controller, read from the Nest metadata (shared by the permission tests).
import 'reflect-metadata';
import { readdirSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { RequestMethod } from '@nestjs/common';
import { METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants.js';
import { PERMISSIONS, PUBLIC } from '../src/common/decorators.js';

const SRC = join(import.meta.dirname, '..', 'src');

function controllerFiles(dir: string): string[] {
  return readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) return entry.name === 'generated' ? [] : controllerFiles(path);
    return entry.name.endsWith('.controller.ts') ? [path] : [];
  });
}

export interface Route {
  /** `Controller.method`. */
  readonly name: string;
  readonly method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';
  /** Full path, parameters kept as `:name` (e.g. `/v1/admin/merchants/:merchantId`). */
  readonly path: string;
  readonly isPublic: boolean;
  readonly permissions: unknown;
}

const join2 = (...parts: unknown[]) =>
  `/${parts
    .map((part) => (typeof part === 'string' ? part : ''))
    .join('/')
    .split('/')
    .filter(Boolean)
    .join('/')}`;

export async function routes(): Promise<Route[]> {
  const found: Route[] = [];
  for (const file of controllerFiles(SRC)) {
    const module = (await import(pathToFileURL(file).href)) as Record<string, unknown>;
    for (const exported of Object.values(module)) {
      if (typeof exported !== 'function') continue;
      const controller = exported as new (...args: never[]) => unknown;
      const base = Reflect.getMetadata(PATH_METADATA, controller) as unknown;
      if (base === undefined) continue;
      const proto = controller.prototype as Record<string, unknown>;
      for (const key of Object.getOwnPropertyNames(proto)) {
        const handler = proto[key];
        if (key === 'constructor' || typeof handler !== 'function') continue;
        const method = Reflect.getMetadata(METHOD_METADATA, handler) as RequestMethod | undefined;
        if (method === undefined) continue;
        const read = (meta: string): unknown =>
          (Reflect.getMetadata(meta, handler) as unknown) ??
          (Reflect.getMetadata(meta, controller) as unknown);
        found.push({
          name: `${controller.name}.${key}`,
          method: RequestMethod[method] as Route['method'],
          path: join2(base, Reflect.getMetadata(PATH_METADATA, handler)),
          isPublic: read(PUBLIC) === true,
          permissions: read(PERMISSIONS),
        });
      }
    }
  }
  return found;
}
