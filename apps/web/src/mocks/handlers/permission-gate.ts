import { http } from 'msw';
import ROUTES from '../fixtures/route-permissions.json';
import { currentAccount } from '../db';
import { apiUrl, problem } from './util';

// The mock refuses what the server refuses (decision C of 2026-10-23): same table as the @Can of
// the API controllers, kept equal by apps/api/test/unit/mock-route-permissions.test.ts.
const TABLE = ROUTES.map((route) => ({
  method: route.method,
  pattern: new RegExp(`^${route.path.replace(/:[A-Za-z]+/g, '[^/]+')}$`),
  permissions: route.permissions,
}));

/** Runs before the routes: 403 when the signed-in account lacks the permission, else falls through. */
export const permissionGate = http.all(apiUrl('/v1/*'), ({ request }) => {
  const account = currentAccount();
  if (account === undefined) return undefined;
  const path = new URL(request.url).pathname;
  const route = TABLE.find((item) => item.method === request.method && item.pattern.test(path));
  if (route === undefined) return undefined;
  const allowed = route.permissions.some((permission) => account.permissions.includes(permission));
  return allowed ? undefined : problem(403, 'FORBIDDEN');
});
