import { describe, expect, it } from 'vitest';
import { commissionGridSchema, tierFor, type CommissionTier } from '../src/index.js';

const tier = (rateBps: number, minMillimes: number | null, maxMillimes: number | null) => ({
  rateBps,
  minMillimes,
  maxMillimes,
});
const codes = (grid: unknown) => {
  const result = commissionGridSchema.safeParse(grid);
  return result.success
    ? []
    : result.error.issues.map((issue) => ({
        path: issue.path.join('/'),
        code: (issue as { params?: { fieldCode?: string } }).params?.fieldCode ?? issue.code,
      }));
};

describe('commissionGridSchema', () => {
  it('accepts a default line alone', () => {
    expect(codes([tier(500, null, null)])).toEqual([]);
  });

  it('accepts adjacent tranches: the next min is the previous max + 0,001 TND', () => {
    expect(
      codes([tier(500, null, null), tier(400, 0, 14_999_999), tier(300, 15_000_000, 18_000_000)]),
    ).toEqual([]);
  });

  it('both bounds are included: a shared bound is an overlap', () => {
    expect(
      codes([tier(500, null, null), tier(400, 0, 15_000_000), tier(300, 15_000_000, 18_000_000)]),
    ).toEqual([{ path: '2', code: 'GRID_OVERLAP' }]);
  });

  it('accepts open tranches (only a min, only a max)', () => {
    expect(
      codes([tier(500, null, null), tier(600, null, 1_000_000), tier(200, 50_000_000, null)]),
    ).toEqual([]);
  });

  it('requires one default line', () => {
    expect(codes([tier(300, 0, 15_000_000)])).toEqual([
      { path: '', code: 'GRID_DEFAULT_REQUIRED' },
    ]);
  });

  it('refuses a second default line', () => {
    expect(codes([tier(500, null, null), tier(400, null, null)])).toEqual([
      { path: '1', code: 'GRID_DEFAULT_DUPLICATE' },
    ]);
  });

  it('refuses overlapping tranches and names the second line', () => {
    expect(
      codes([tier(500, null, null), tier(400, 0, 16_000_000), tier(300, 15_000_000, 18_000_000)]),
    ).toEqual([{ path: '2', code: 'GRID_OVERLAP' }]);
  });

  it('an open tranche overlaps everything above its min', () => {
    expect(
      codes([
        tier(500, null, null),
        tier(200, 10_000_000, null),
        tier(300, 15_000_000, 18_000_000),
      ]),
    ).toEqual([{ path: '2', code: 'GRID_OVERLAP' }]);
  });

  it('refuses a min above the max (a single amount is a valid tranche)', () => {
    expect(codes([tier(500, null, null), tier(300, 18_000_000, 18_000_000)])).toEqual([]);
    expect(codes([tier(500, null, null), tier(300, 18_000_001, 18_000_000)])).toEqual([
      { path: '1', code: 'GRID_BOUNDS' },
    ]);
  });

  it.each([
    [[]],
    [[tier(10_001, null, null)]],
    [[tier(1.5, null, null)]],
    [[tier(500, -1, null)]],
    [[{ rateBps: 500, minMillimes: null, maxMillimes: null, extra: 1 }]],
  ])('refuses malformed grids %#', (grid) => {
    expect(commissionGridSchema.safeParse(grid).success).toBe(false);
  });
});

describe('tierFor', () => {
  const grid: CommissionTier[] = [
    tier(500, null, null),
    tier(400, 0, 14_999_999),
    tier(300, 15_000_000, 18_000_000),
  ];

  it('16 000 TND falls in the 15 000 – 18 000 tranche', () => {
    expect(tierFor(grid, 16_000_000).rateBps).toBe(300);
  });

  it('both bounds are included: 18 000 TND is in the 15 000 – 18 000 tranche', () => {
    expect(tierFor(grid, 15_000_000).rateBps).toBe(300);
    expect(tierFor(grid, 14_999_999).rateBps).toBe(400);
    expect(tierFor(grid, 18_000_000).rateBps).toBe(300);
    expect(tierFor(grid, 18_000_001).rateBps).toBe(500);
  });

  it('the default line applies when no tranche matches', () => {
    expect(tierFor(grid, 20_000_000).rateBps).toBe(500);
    expect(tierFor([tier(200, null, null)], 45_000).rateBps).toBe(200);
  });

  it('a grid without a default line is a programming error', () => {
    expect(() => tierFor([tier(300, 0, 1_000)], 5_000)).toThrow();
  });
});
