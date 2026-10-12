import createClient, { type Client, type Middleware } from 'openapi-fetch';
import {
  problemCodeValues,
  type components,
  type operations,
  type paths,
} from './generated/schema.js';

export type { components, operations, paths };

/** Every schema of the contract, by name (e.g. `Schemas['HealthStatus']`). */
export type Schemas = components['schemas'];

/** Error codes known by this version of the client (closed list generated from the contract). */
export type ProblemCode = Schemas['ProblemCode'];

/**
 * RFC 9457 problem as received. `code` stays a plain string: the server may add codes without a new
 * major version (contract §1), so a switch on it must keep a fallback branch. Narrow it with
 * `isKnownProblemCode`. The client only tests `code` and translates `messageKey`.
 */
export type ApiProblem = Omit<Schemas['ProblemBase'], 'code'> & { code: string; details?: unknown };

export type ApiClient = Client<paths>;

export interface ApiClientOptions {
  /**
   * API origin, e.g. `http://localhost:3000` in development. Must be a configuration constant,
   * never a user- or URL-supplied value: with `credentials: 'include'` it receives the cookies.
   */
  readonly baseUrl: string;
  /** Custom fetch (tests, MSW, server components). Defaults to the global fetch. */
  readonly fetch?: (request: Request) => Promise<Response>;
  /** Web only: CSRF token held in memory (contract §6). Sent on POST, PUT, PATCH, DELETE. */
  readonly getCsrfToken?: () => string | undefined;
}

/**
 * Channel header required on every web `/v1/auth/*` call (contract §10):
 * `api.POST('/v1/auth/logout', { params: { header: WEB_CHANNEL_HEADER } })`.
 */
export const WEB_CHANNEL_HEADER = { 'X-FlexiPay-Client': 'web' } as const;

const UNSAFE_METHODS = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);

/** Adds `X-CSRF-Token` to unsafe methods only (never GET, HEAD, OPTIONS), when a token is held. */
export function csrfMiddleware(getCsrfToken: () => string | undefined): Middleware {
  return {
    onRequest({ request }) {
      if (!UNSAFE_METHODS.has(request.method.toUpperCase())) return undefined;
      const token = getCsrfToken();
      if (token === undefined || token === '') return undefined;
      request.headers.set('X-CSRF-Token', token);
      return request;
    },
  };
}

/**
 * Typed client of the FlexiPay API. Web session by cookies (`credentials: 'include'`):
 * tokens are never readable by JavaScript and never put in the URL.
 */
export function createApiClient(options: ApiClientOptions): ApiClient {
  const client = createClient<paths>({
    baseUrl: options.baseUrl,
    credentials: 'include',
    ...(options.fetch === undefined ? {} : { fetch: options.fetch }),
  });
  if (options.getCsrfToken !== undefined) client.use(csrfMiddleware(options.getCsrfToken));
  return client;
}

const PROBLEM_TYPE = /^urn:flexipay:problem:[a-z0-9]+(-[a-z0-9]+)*$/;
const KNOWN_CODES: ReadonlySet<string> = new Set(problemCodeValues);

/** Type guard for an RFC 9457 error body returned by the API (members of ProblemBase). */
export function isProblem(value: unknown): value is ApiProblem {
  if (typeof value !== 'object' || value === null) return false;
  const v = value as Record<string, unknown>;
  return (
    typeof v.type === 'string' &&
    PROBLEM_TYPE.test(v.type) &&
    typeof v.title === 'string' &&
    typeof v.status === 'number' &&
    typeof v.code === 'string' &&
    typeof v.messageKey === 'string' &&
    typeof v.requestId === 'string'
  );
}

/** True when the code belongs to the contract this client was generated from. */
export function isKnownProblemCode(code: string): code is ProblemCode {
  return KNOWN_CODES.has(code);
}
