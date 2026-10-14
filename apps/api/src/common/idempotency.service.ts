import { randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import type { Request } from 'express';
import { sha256 } from './crypto.js';
import { DbService, TRANSACTION_TIMEOUT_MS, scopeOf, type Tx } from './db.service.js';
import { ApiProblem } from './problem.js';
import { principal, tenantOf } from './request-context.js';
import type { Prisma } from '../generated/prisma/client.js';

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
/** Lease strictly longer than the longest financial SQL transaction (contract §5). */
const LEASE_MS = TRANSACTION_TIMEOUT_MS * 3;

export interface Outcome<T> {
  readonly status: number;
  readonly body: T;
  readonly replayed: boolean;
}

/** Business refusal: definitive for the key, recorded (contract §5, step 3). */
function isRefusal(error: unknown): error is ApiProblem {
  return (
    error instanceof ApiProblem &&
    (error.status === 422 ||
      (error.status === 409 && error.code !== 'IDEMPOTENCY_REQUEST_IN_PROGRESS'))
  );
}

function canonical(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(canonical);
  if (value !== null && typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value as Record<string, unknown>)
        .sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))
        .map(([key, item]) => [key, canonical(item)]),
    );
  }
  return value;
}

/**
 * Idempotency-Key registry, distinct from the ledger. Scope (tenant, user, key); fingerprint of
 * method + concrete path + sorted query + canonical body; reservation with a fencing token and a
 * lease; result recorded in the same SQL transaction as the business writes.
 */
@Injectable()
export class IdempotencyService {
  constructor(@Inject(DbService) private readonly db: DbService) {}

  /** Key of the request: required (`400 IDEMPOTENCY_KEY_REQUIRED`) and a UUID. */
  keyOf(req: Request): string {
    const header = req.headers['idempotency-key'];
    if (header === undefined || header === '')
      throw new ApiProblem(400, 'IDEMPOTENCY_KEY_REQUIRED');
    if (typeof header !== 'string' || !UUID.test(header)) {
      throw new ApiProblem(400, 'IDEMPOTENCY_KEY_INVALID');
    }
    return header.toLowerCase();
  }

  fingerprint(req: Request): string {
    const query = new URL(req.originalUrl, 'http://api').searchParams;
    const sorted = [...query.entries()].sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0));
    return sha256(JSON.stringify([req.method, req.path, sorted, canonical(req.body as unknown)]));
  }

  /**
   * Runs `work` once per key. `work` receives the SQL transaction (RLS scope of the user) and the
   * key; its result is recorded with the business writes, in the same transaction.
   */
  async run<T>(
    req: Request,
    work: (tx: Tx, key: string) => Promise<{ status: number; body: T }>,
  ): Promise<Outcome<T>> {
    const key = this.keyOf(req);
    const who = principal();
    const scope = tenantOf(who) ?? '-';
    const fingerprint = this.fingerprint(req);
    const reserved = await this.reserve(scope, who.userId, key, fingerprint);
    if ('replay' in reserved) return reserved.replay as Outcome<T>;
    const { fence } = reserved;
    try {
      return await this.db.run(scopeOf(who), async (tx) => {
        const result = await work(tx, key);
        await this.complete(tx, scope, who.userId, key, fence, result.status, result.body);
        return { ...result, replayed: false };
      });
    } catch (error) {
      if (isRefusal(error)) {
        const body = error.body(randomUUID());
        await this.db.system((tx) =>
          this.complete(tx, scope, who.userId, key, fence, error.status, body, true),
        );
        throw error;
      }
      await this.release(scope, who.userId, key, fence);
      throw error;
    }
  }

  private async reserve(
    scope: string,
    userId: string,
    key: string,
    fingerprint: string,
  ): Promise<{ fence: string } | { replay: Outcome<unknown> }> {
    return this.db.system(async (tx) => {
      const now = new Date();
      const rows = await tx.$queryRaw<
        {
          fingerprint: string;
          state: string;
          lease_until: Date;
          response_status: number | null;
          response_body: unknown;
        }[]
      >`SELECT fingerprint, state, lease_until, response_status, response_body
        FROM idempotency_keys WHERE scope = ${scope} AND user_id = ${userId}::uuid AND key = ${key}::uuid
        FOR UPDATE`;
      const existing = rows[0];
      const fence = randomUUID();
      const leaseUntil = new Date(now.getTime() + LEASE_MS);
      if (existing === undefined) {
        await tx.idempotencyKey.create({
          data: {
            scope,
            userId,
            key,
            fingerprint,
            state: 'IN_PROGRESS',
            fenceToken: fence,
            leaseUntil,
          },
        });
        return { fence };
      }
      if (existing.fingerprint !== fingerprint) throw new ApiProblem(422, 'IDEMPOTENCY_KEY_REUSED');
      if (existing.state === 'DONE') {
        return {
          replay: {
            status: existing.response_status ?? 200,
            body: existing.response_body,
            replayed: true,
          },
        };
      }
      if (existing.lease_until > now) {
        const retry = Math.max(
          1,
          Math.ceil((existing.lease_until.getTime() - now.getTime()) / 1000),
        );
        throw new ApiProblem(
          409,
          'IDEMPOTENCY_REQUEST_IN_PROGRESS',
          { retryAfterSeconds: retry },
          { 'Retry-After': String(retry) },
        );
      }
      // Orphan reservation (lease expired): taken over with a new fencing token.
      await tx.idempotencyKey.update({
        where: { scope_userId_key: { scope, userId, key } },
        data: { fenceToken: fence, leaseUntil },
      });
      return { fence };
    });
  }

  /** Records the response under `FOR UPDATE`, only if the fencing token is still ours. */
  private async complete(
    tx: Tx,
    scope: string,
    userId: string,
    key: string,
    fence: string,
    status: number,
    body: unknown,
    quiet = false,
  ): Promise<void> {
    const rows = await tx.$queryRaw<{ fence_token: string }[]>`SELECT fence_token
      FROM idempotency_keys WHERE scope = ${scope} AND user_id = ${userId}::uuid AND key = ${key}::uuid
      FOR UPDATE`;
    if (rows[0]?.fence_token !== fence) {
      if (quiet) return;
      // Lease expired and taken over: roll back, a single processing may commit.
      throw new ApiProblem(
        409,
        'IDEMPOTENCY_REQUEST_IN_PROGRESS',
        { retryAfterSeconds: 1 },
        { 'Retry-After': '1' },
      );
    }
    await tx.idempotencyKey.update({
      where: { scope_userId_key: { scope, userId, key } },
      data: {
        state: 'DONE',
        responseStatus: status,
        responseBody: (body ?? null) as Prisma.InputJsonValue,
      },
    });
  }

  /** Technical failure before or during processing: nothing recorded, the key can be retried. */
  private async release(scope: string, userId: string, key: string, fence: string): Promise<void> {
    await this.db.system((tx) =>
      tx.idempotencyKey.deleteMany({
        where: { scope, userId, key, fenceToken: fence, state: 'IN_PROGRESS' },
      }),
    );
  }
}
