import { z } from 'zod';
import { hmac, safeEqual } from './crypto.js';
import { validationFailed } from './problem.js';
import { parse, queryBoolean } from './validation.js';

/** Bounded counter limit (contract §7, DP n° 23). */
export const COUNT_LIMIT = 10_000;

const listQuery = z.object({
  limit: z.coerce.number().int().min(1).max(100).default(20),
  cursor: z.string().max(512).optional(),
  withCount: queryBoolean.optional(),
  createdFrom: z.iso.datetime({ offset: true }).optional(),
  createdTo: z.iso.datetime({ offset: true }).optional(),
});

export interface PageRequest {
  readonly limit: number;
  readonly offset: number;
  readonly withCount: boolean;
  readonly createdFrom?: Date;
  readonly createdTo?: Date;
}

export interface Page<T> {
  data: T[];
  page: {
    limit: number;
    hasMore: boolean;
    nextCursor: string | null;
    count?: { value: number; isLowerBound: boolean };
  };
}

/**
 * Opaque, signed cursors (contract §7): the cursor carries the position and a fingerprint of the
 * filters; an altered cursor, or one reused with other filters, is `400 VALIDATION_FAILED`.
 */
export class Paginator {
  constructor(private readonly key: Buffer) {}

  /** Reads limit / cursor / withCount / period from a query, checked against `filters`. */
  request(query: Record<string, unknown>, filters: Record<string, unknown>): PageRequest {
    const { limit, cursor, withCount, createdFrom, createdTo } = parse(
      listQuery,
      {
        limit: query.limit,
        cursor: query.cursor,
        withCount: query.withCount,
        createdFrom: query.createdFrom,
        createdTo: query.createdTo,
      },
      'query',
    );
    const scope = this.scope({ ...filters, createdFrom, createdTo });
    return {
      limit,
      offset: cursor === undefined ? 0 : this.decode(cursor, scope),
      withCount: withCount ?? false,
      ...(createdFrom === undefined ? {} : { createdFrom: new Date(createdFrom) }),
      ...(createdTo === undefined ? {} : { createdTo: new Date(createdTo) }),
    };
  }

  /**
   * Builds the page from `limit + 1` rows read at `offset` (hasMore without a count) and the
   * optional bounded count.
   */
  page<T>(
    request: PageRequest,
    rows: T[],
    filters: Record<string, unknown>,
    count?: number,
  ): Page<T> {
    const hasMore = rows.length > request.limit;
    const data = hasMore ? rows.slice(0, request.limit) : rows;
    const scope = this.scope({
      ...filters,
      createdFrom: request.createdFrom?.toISOString(),
      createdTo: request.createdTo?.toISOString(),
    });
    return {
      data,
      page: {
        limit: request.limit,
        hasMore,
        nextCursor: hasMore ? this.encode(request.offset + request.limit, scope) : null,
        ...(count === undefined
          ? {}
          : { count: { value: Math.min(count, COUNT_LIMIT), isLowerBound: count > COUNT_LIMIT } }),
      },
    };
  }

  private scope(filters: Record<string, unknown>): string {
    const entries = Object.entries(filters)
      .filter(([, value]) => value !== undefined && value !== null && value !== '')
      .sort(([a], [b]) => a.localeCompare(b));
    return JSON.stringify(entries);
  }

  private encode(offset: number, scope: string): string {
    const body = Buffer.from(JSON.stringify({ o: offset })).toString('base64url');
    return `${body}.${hmac(this.key, `${body}|${scope}`)}`;
  }

  private decode(cursor: string, scope: string): number {
    const invalid = validationFailed([{ in: 'query', pointer: 'cursor', code: 'INVALID_CURSOR' }]);
    const [body, signature] = cursor.split('.');
    if (body === undefined || signature === undefined) throw invalid;
    if (!safeEqual(signature, hmac(this.key, `${body}|${scope}`))) throw invalid;
    const offset = (JSON.parse(Buffer.from(body, 'base64url').toString('utf8')) as { o?: unknown })
      .o;
    if (typeof offset !== 'number' || !Number.isInteger(offset) || offset < 0) throw invalid;
    return offset;
  }
}
