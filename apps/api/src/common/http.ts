import { randomUUID } from 'node:crypto';
import express, { type NextFunction, type Request, type Response } from 'express';
import type { Env } from '../config/env.js';
import { ApiProblem } from './problem.js';
import { currentContext, runWithContext } from './request-context.js';

export const ACCESS_COOKIE = '__Host-fp_at';
export const REFRESH_COOKIE = '__Secure-fp_rt';
const UNSAFE = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);
const ALLOWED_HEADERS =
  'Content-Type, Authorization, Idempotency-Key, X-CSRF-Token, X-FlexiPay-Client, Accept-Language';
const EXPOSED_HEADERS =
  'X-Request-Id, Retry-After, RateLimit-Limit, RateLimit-Remaining, RateLimit-Reset, Idempotent-Replayed';
/** Routes receiving multipart/form-data (files), with their own size limit. */
const MULTIPART_ROUTES = [
  /^\/v1\/company\/orders\/[^/]+\/transfer-declarations$/,
  /^\/v1\/account\/kyc\/documents$/,
];

/** Writes a problem directly (middlewares that run before Nest). */
export function sendProblem(res: Response, problem: ApiProblem): void {
  const requestId = currentContext()?.requestId ?? randomUUID();
  for (const [name, value] of Object.entries(problem.headers ?? {})) res.setHeader(name, value);
  res
    .status(problem.status)
    .type('application/problem+json')
    .send(JSON.stringify(problem.body(requestId)));
}

/** Cookies of the request (no dependency: name=value pairs, first occurrence wins). */
export function cookiesOf(req: Request): Record<string, string> {
  const header = req.headers.cookie;
  const result: Record<string, string> = {};
  if (header === undefined) return result;
  for (const part of header.split(';')) {
    const index = part.indexOf('=');
    if (index < 0) continue;
    const name = part.slice(0, index).trim();
    if (name !== '' && !(name in result))
      result[name] = decodeURIComponent(part.slice(index + 1).trim());
  }
  return result;
}

function hasFlexiPayCookie(req: Request): boolean {
  const cookies = cookiesOf(req);
  return ACCESS_COOKIE in cookies || REFRESH_COOKIE in cookies;
}

/** Request id (server generated, client value ignored) and request context. */
function context(req: Request, res: Response, next: NextFunction): void {
  const requestId = randomUUID();
  res.setHeader('X-Request-Id', requestId);
  runWithContext({ requestId, ip: req.socket.remoteAddress ?? 'unknown' }, () => {
    next();
  });
}

/** Security headers of every API response (contract §8). */
function securityHeaders(env: Env) {
  return (_req: Request, res: Response, next: NextFunction): void => {
    res.setHeader('Cache-Control', 'no-store');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.setHeader('Content-Security-Policy', "default-src 'none'; frame-ancestors 'none'");
    res.setHeader('Cross-Origin-Resource-Policy', 'same-site');
    if (env.NODE_ENV === 'production') {
      res.setHeader('Strict-Transport-Security', 'max-age=63072000; includeSubDomains');
    }
    next();
  };
}

/** CORS: exact allow-list, never a reflected origin, never `*`, `null` refused (contract §6). */
function cors(env: Env) {
  const allowed = new Set(env.webOrigins);
  return (req: Request, res: Response, next: NextFunction): void => {
    res.setHeader('Vary', 'Origin');
    const origin = req.headers.origin;
    const isAllowed = origin !== undefined && allowed.has(origin);
    if (isAllowed) {
      res.setHeader('Access-Control-Allow-Origin', origin);
      res.setHeader('Access-Control-Allow-Credentials', 'true');
      res.setHeader('Access-Control-Expose-Headers', EXPOSED_HEADERS);
    }
    if (req.method === 'OPTIONS') {
      if (isAllowed) {
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE');
        res.setHeader('Access-Control-Allow-Headers', ALLOWED_HEADERS);
        res.setHeader('Access-Control-Max-Age', '600');
      }
      res.status(204).end();
      return;
    }
    next();
  };
}

/**
 * A Cloudflare quick tunnel of the demo (request of 2026-11-14): its address changes at each
 * launch. Outside production only; the web relays /api on that same origin, so the cookies stay
 * same-site (trycloudflare.com is a public suffix: another tunnel is another site) and the CSRF
 * token is still required.
 */
const DEMO_TUNNEL_ORIGIN = /^https:\/\/[a-z0-9-]+\.trycloudflare\.com$/;

/**
 * CSRF, first control (contract §6): on an unsafe method, an Origin header must be exactly one of
 * the allowed origins (or, outside production, a demo tunnel); without Origin, a request carrying
 * a FlexiPay cookie is refused.
 */
function originCheck(env: Env) {
  const allowed = new Set(env.webOrigins);
  const isAllowed = (origin: string) =>
    allowed.has(origin) || (env.NODE_ENV !== 'production' && DEMO_TUNNEL_ORIGIN.test(origin));
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!UNSAFE.has(req.method)) {
      next();
      return;
    }
    const origin = req.headers.origin;
    if (origin !== undefined ? !isAllowed(origin) : hasFlexiPayCookie(req)) {
      sendProblem(res, new ApiProblem(403, 'CSRF_TOKEN_INVALID'));
      return;
    }
    next();
  };
}

/** Only JSON bodies (and multipart on the upload routes): `415 UNSUPPORTED_MEDIA_TYPE`. */
function mediaType(req: Request, res: Response, next: NextFunction): void {
  const length = Number(req.headers['content-length'] ?? '0');
  const hasBody = length > 0 || req.headers['transfer-encoding'] !== undefined;
  if (!UNSAFE.has(req.method) || !hasBody) {
    next();
    return;
  }
  const type = (req.headers['content-type'] ?? '').split(';')[0]?.trim().toLowerCase() ?? '';
  const multipart = MULTIPART_ROUTES.some((route) => route.test(req.path));
  if (type === 'application/json' || (multipart && type === 'multipart/form-data')) {
    next();
    return;
  }
  sendProblem(res, new ApiProblem(415, 'UNSUPPORTED_MEDIA_TYPE'));
}

interface Bucket {
  count: number;
  resetAt: number;
}

/**
 * Rate limiting per IP and route (in memory: one API process in local development; Redis will
 * hold the counters when the API runs on several instances). Headers on every response.
 */
/**
 * Stricter limits per minute and IP (M4): sign-in, PIN, till requests and their confirmation. The
 * 4-digit code of a till can only be tried a few times (guessing it is useless without the PIN).
 */
const ROUTE_LIMITS: readonly { name: string; pattern: RegExp; limit: number }[] = [
  { name: 'auth', pattern: /^\/v1\/(mobile\/)?auth\//, limit: 30 },
  { name: 'public', pattern: /^\/v1\/public\//, limit: 30 },
  { name: 'checkout-code', pattern: /^\/v1\/employee\/checkouts\/code\//, limit: 12 },
  { name: 'checkout-sticker', pattern: /^\/v1\/employee\/checkouts\/sticker\//, limit: 30 },
  {
    name: 'pin',
    pattern:
      /^\/v1\/employee\/(pin$|checkouts\/[^/]+\/confirm$|payment-requests\/[^/]+\/confirm$|payments$)/,
    limit: 30,
  },
  { name: 'checkout-create', pattern: /^\/v1\/merchant\/registers\/[^/]+\/checkouts$/, limit: 60 },
];

function rateLimit(env: Env) {
  const buckets = new Map<string, Bucket>();
  const WINDOW_MS = 60_000;
  // Integration tests drive many requests from 127.0.0.1 in a few seconds.
  const factor = env.NODE_ENV === 'test' ? 10 : 1;
  return (req: Request, res: Response, next: NextFunction): void => {
    const route = ROUTE_LIMITS.find((entry) => entry.pattern.test(req.path));
    // Sign-in and public pages are counted per path (unchanged); the others per group.
    const bucketName =
      route === undefined
        ? 'api'
        : route.name === 'auth' || route.name === 'public'
          ? req.path
          : route.name;
    const limit = (route?.limit ?? 600) * factor;
    const now = Date.now();
    const key = `${req.socket.remoteAddress ?? 'unknown'}|${bucketName}`;
    let bucket = buckets.get(key);
    if (bucket === undefined || bucket.resetAt <= now) {
      bucket = { count: 0, resetAt: now + WINDOW_MS };
      buckets.set(key, bucket);
      if (buckets.size > 50_000) buckets.clear();
    }
    bucket.count += 1;
    const reset = Math.max(1, Math.ceil((bucket.resetAt - now) / 1000));
    res.setHeader('RateLimit-Limit', String(limit));
    res.setHeader('RateLimit-Remaining', String(Math.max(0, limit - bucket.count)));
    res.setHeader('RateLimit-Reset', String(reset));
    if (bucket.count > limit) {
      sendProblem(
        res,
        new ApiProblem(
          429,
          'RATE_LIMITED',
          { retryAfterSeconds: reset },
          { 'Retry-After': String(reset) },
        ),
      );
      return;
    }
    next();
  };
}

/** Routes receiving a CSV inside JSON (contract: 1 MiB for employees, 200 kB for allocations). */
const LARGE_JSON_ROUTES = [
  /^\/v1\/company\/employees\/import-previews$/,
  /^\/v1\/company\/allocation-imports\/previews$/,
];

/**
 * JSON body parser: 64 KiB at most (1.1 MiB on the CSV import routes), `413` beyond; malformed
 * JSON is a validation error (`400`).
 */
function jsonBody() {
  const small = express.json({ limit: '64kb', strict: true, type: 'application/json' });
  const large = express.json({ limit: '1100kb', strict: true, type: 'application/json' });
  return (req: Request, res: Response, next: NextFunction): void => {
    const parser = LARGE_JSON_ROUTES.some((route) => route.test(req.path)) ? large : small;
    parser(req, res, (error?: unknown) => {
      if (error === undefined) {
        next();
        return;
      }
      const type = (error as { type?: string }).type;
      if (type === 'entity.too.large') sendProblem(res, new ApiProblem(413, 'PAYLOAD_TOO_LARGE'));
      else {
        sendProblem(
          res,
          new ApiProblem(400, 'VALIDATION_FAILED', {
            fields: [
              {
                in: 'body',
                pointer: '',
                code: 'INVALID_TYPE',
                messageKey: 'errors.field.invalidType',
              },
            ],
          }),
        );
      }
    });
  };
}

/** Middlewares that run before Nest, in order. */
export function httpPipeline(env: Env) {
  return [
    context,
    securityHeaders(env),
    cors(env),
    rateLimit(env),
    originCheck(env),
    mediaType,
    jsonBody(),
  ];
}
