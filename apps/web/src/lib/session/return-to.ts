import type { Schemas } from '@flexipay/api-client';

type Role = Schemas['Role'];

/** Home of each web space. Employees and family members have no web space (cahier §1.2). */
export const SPACE_HOME: Partial<Record<Role, string>> = {
  ADMIN: '/admin',
  COMPANY: '/entreprise',
  MERCHANT: '/commercant',
};

const SPACE_PREFIX = /^\/(admin|entreprise|commercant)(\/[a-z0-9-]+)*$/;

/**
 * Validates a `returnTo` value (commun-session-expiree §3.1): decoded once, then rejected if it
 * still contains `%`, a control character, `//`, `\` or `..`; it must be an exact in-app path of a
 * web space, without query string or fragment. Returns the safe path or undefined.
 */
export function safeReturnTo(raw: string | null | undefined): string | undefined {
  if (raw === null || raw === undefined || raw === '' || raw.length > 200) return undefined;
  let decoded: string;
  try {
    decoded = decodeURIComponent(raw);
  } catch {
    return undefined;
  }
  // eslint-disable-next-line no-control-regex
  if (/[%\\\u0000-\u001f\u007f]|\/\/|\.\./.test(decoded)) return undefined;
  return SPACE_PREFIX.test(decoded) ? decoded : undefined;
}

/** Where a user lands after signing in: the requested page of their own space, else its home. */
export function landingPath(role: Role, returnTo: string | undefined): string | undefined {
  const home = SPACE_HOME[role];
  if (home === undefined) return undefined;
  return returnTo !== undefined && (returnTo === home || returnTo.startsWith(`${home}/`))
    ? returnTo
    : home;
}
