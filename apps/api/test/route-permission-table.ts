// The permission table of the API routes, as the web mock (MSW) mirrors it in
// apps/web/src/mocks/fixtures/route-permissions.json (same refusals as the server).
import { SELF } from '../src/common/permissions.js';
import { routes } from './routes.js';

export interface RoutePermission {
  readonly method: string;
  readonly path: string;
  readonly permissions: readonly string[];
}

export async function routePermissionTable(): Promise<RoutePermission[]> {
  return (await routes())
    .filter((route) => !route.isPublic && Array.isArray(route.permissions))
    .map((route) => ({
      method: route.method,
      path: route.path,
      permissions: [...(route.permissions as string[])].sort(),
    }))
    .filter((route) => !route.permissions.includes(SELF))
    .sort((a, b) => `${a.path} ${a.method}`.localeCompare(`${b.path} ${b.method}`));
}
