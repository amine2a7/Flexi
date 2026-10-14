import { describe, expect, it } from 'vitest';
import { z } from 'zod';
import { ApiProblem } from '../../src/common/problem.js';
import { Paginator } from '../../src/common/pagination.js';
import { parse, positiveMillimes } from '../../src/common/validation.js';

const fieldsOf = (fn: () => unknown): unknown[] => {
  try {
    fn();
  } catch (error) {
    if (error instanceof ApiProblem) {
      return (error.body('id').details as { fields: unknown[] }).fields;
    }
  }
  return [];
};

describe('validation errors of the contract (details.fields[])', () => {
  const schema = z.strictObject({ amountMillimes: positiveMillimes, label: z.string().max(5) });

  it('maps Zod issues to field codes without echoing the value', () => {
    const fields = fieldsOf(() =>
      parse(schema, { amountMillimes: 1.5, label: 'trop long', extra: 1 }),
    );
    expect(fields).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ in: 'body', pointer: '/amountMillimes', code: 'NOT_INTEGER' }),
        expect.objectContaining({ pointer: '/label', code: 'TOO_LONG', params: { max: 5 } }),
        expect.objectContaining({ pointer: '/extra', code: 'UNKNOWN_FIELD' }),
      ]),
    );
    expect(JSON.stringify(fields)).not.toContain('trop long');
  });

  it('reports a missing field as REQUIRED and a zero amount as TOO_SMALL', () => {
    expect(fieldsOf(() => parse(schema, { label: 'a' }))).toEqual([
      expect.objectContaining({ pointer: '/amountMillimes', code: 'REQUIRED' }),
    ]);
    expect(fieldsOf(() => parse(schema, { amountMillimes: 0, label: 'a' }))).toEqual([
      expect.objectContaining({ pointer: '/amountMillimes', code: 'TOO_SMALL' }),
    ]);
  });
});

describe('signed cursors (contract §7)', () => {
  const paginator = new Paginator(Buffer.alloc(32, 7));

  it('round-trips a cursor with the same filters', () => {
    const request = paginator.request({ limit: '2' }, { status: 'CONFIRMED' });
    const page = paginator.page(request, [1, 2, 3], { status: 'CONFIRMED' });
    expect(page.data).toEqual([1, 2]);
    expect(page.page.hasMore).toBe(true);
    const next = paginator.request(
      { limit: '2', cursor: page.page.nextCursor },
      { status: 'CONFIRMED' },
    );
    expect(next.offset).toBe(2);
  });

  it('refuses a cursor reused with other filters, or altered', () => {
    const request = paginator.request({ limit: '2' }, { status: 'CONFIRMED' });
    const cursor =
      paginator.page(request, [1, 2, 3], { status: 'CONFIRMED' }).page.nextCursor ?? '';
    expect(() => paginator.request({ cursor }, { status: 'REFUSED' })).toThrow(ApiProblem);
    expect(() => paginator.request({ cursor: `x${cursor}` }, { status: 'CONFIRMED' })).toThrow(
      ApiProblem,
    );
  });

  it('bounds the counter at 10 000', () => {
    const request = paginator.request({ withCount: 'true' }, {});
    expect(paginator.page(request, [], {}, 12_345).page.count).toEqual({
      value: 10_000,
      isLowerBound: true,
    });
  });
});
