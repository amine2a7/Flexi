import { describe, expect, it } from 'vitest';
import { orderBreakdown, payoutBreakdown, rateOf, type CommissionTier } from '../src/index.js';

const tier = (rateBps: number, minMillimes: number | null, maxMillimes: number | null) => ({
  rateBps,
  minMillimes,
  maxMillimes,
});
const TAXES = { vatRateBps: 1_900, stampDutyMillimes: 1_000 };

describe('rateOf', () => {
  it('rounds half up to the nearest millime', () => {
    expect(rateOf(1_005, 5_000)).toBe(503); // 502,5 -> 503
    expect(rateOf(1_004, 5_000)).toBe(502); // 502
    expect(rateOf(45_000, 200)).toBe(900);
    expect(rateOf(900, 1_900)).toBe(171);
  });

  it('stays exact on amounts beyond 2^53 / 10 000', () => {
    expect(rateOf(9_000_000_000_000, 10_000)).toBe(9_000_000_000_000);
  });
});

describe('orderBreakdown (company: total = amount + commission + VAT + stamp)', () => {
  it('order of 10 000 TND at 5 % -> total 10 596,000 TND', () => {
    expect(orderBreakdown(10_000_000, [tier(500, null, null)], TAXES)).toMatchObject({
      amountMillimes: 10_000_000,
      rateBps: 500,
      commissionMillimes: 500_000,
      vatRateBps: 1_900,
      vatMillimes: 95_000,
      stampDutyMillimes: 1_000,
      totalMillimes: 10_596_000,
    });
  });

  it('order of 16 000 TND in the 15 000 – 18 000 tranche at 3 %', () => {
    const grid: CommissionTier[] = [
      tier(500, null, null),
      tier(400, 0, 14_999_999),
      tier(300, 15_000_000, 18_000_000),
    ];
    expect(orderBreakdown(16_000_000, grid, TAXES)).toMatchObject({
      rateBps: 300,
      commissionMillimes: 480_000,
      vatMillimes: 91_200,
      totalMillimes: 16_572_200,
    });
  });

  it('the VAT is computed on the rounded commission', () => {
    // 333,333 TND at 1,5 % = 4,999995 -> 5,000 ; VAT 19 % of 5,000 = 0,950
    expect(orderBreakdown(333_333, [tier(150, null, null)], TAXES)).toMatchObject({
      commissionMillimes: 5_000,
      vatMillimes: 950,
      totalMillimes: 333_333 + 5_000 + 950 + 1_000,
    });
  });
});

describe('payoutBreakdown (merchant: net = amount - commission - VAT - stamp)', () => {
  it('payout of 45 TND at 2 % -> net 42,929 TND', () => {
    expect(payoutBreakdown(45_000, [tier(200, null, null)], TAXES)).toMatchObject({
      amountMillimes: 45_000,
      rateBps: 200,
      commissionMillimes: 900,
      vatRateBps: 1_900,
      vatMillimes: 171,
      stampDutyMillimes: 1_000,
      netMillimes: 42_929,
    });
  });

  it('a zero rate leaves only the stamp duty', () => {
    expect(payoutBreakdown(60_000, [tier(0, null, null)], TAXES).netMillimes).toBe(59_000);
  });

  it('every line adds up to the amount', () => {
    const lines = payoutBreakdown(1_234_567, [tier(275, null, null)], TAXES);
    expect(
      lines.netMillimes + lines.commissionMillimes + lines.vatMillimes + lines.stampDutyMillimes,
    ).toBe(1_234_567);
  });
});

describe('fees of processus v2 (Règles de frais)', () => {
  const v2 = (withholdingRateBps: number) => ({
    vatRateBps: 1_900,
    stampDutyMillimes: 1_000,
    withholdingRateBps,
    withholdingThresholdMillimes: 1_000_000,
    transferFeeMillimes: 4_000,
  });

  it('example 1: PM MF order, grid 3 %, 16 000 TND -> 16 576,200 (corrections of 13/11)', () => {
    expect(
      orderBreakdown(16_000_000, [{ rateBps: 300, minMillimes: null, maxMillimes: null }], v2(100))
        .totalMillimes,
    ).toBe(16_576_200);
  });

  it('example 2: PP CIN payout, grid 2 %, 1 250 TND -> net 1 215,250 (corrections of 13/11)', () => {
    expect(
      payoutBreakdown(1_250_000, [{ rateBps: 200, minMillimes: null, maxMillimes: null }], v2(300))
        .netMillimes,
    ).toBe(1_215_250);
  });
});

// Corrections after the demo (2026-11-13): frais TTC = commission + VAT; withholding = rate of the
// legal form x frais TTC above 1 000 TND, deducted from the total or the net.
describe('fees v2 with the withholding on the frais TTC', () => {
  const V2 = (withholdingRateBps: number) => ({
    vatRateBps: 1_900,
    stampDutyMillimes: 1_000,
    withholdingRateBps,
    withholdingThresholdMillimes: 1_000_000,
    transferFeeMillimes: 4_000,
  });

  it('order of 16 000 TND, PM MF 3 % -> 16 576,200', () => {
    expect(orderBreakdown(16_000_000, [tier(300, null, null)], V2(100))).toMatchObject({
      feesTtcMillimes: 571_200,
      withholdingMillimes: 0,
      totalMillimes: 16_576_200,
    });
  });

  it('order of 40 000 TND, PM MF 3 % -> 41 418,720 (withholding 14,280 deducted)', () => {
    expect(orderBreakdown(40_000_000, [tier(300, null, null)], V2(100))).toMatchObject({
      feesTtcMillimes: 1_428_000,
      withholdingMillimes: 14_280,
      totalMillimes: 41_418_720,
    });
  });

  it('payout of 1 250 TND, PP CIN 2 % -> net 1 215,250', () => {
    expect(payoutBreakdown(1_250_000, [tier(200, null, null)], V2(300))).toMatchObject({
      feesTtcMillimes: 29_750,
      withholdingMillimes: 0,
      netMillimes: 1_215_250,
    });
  });
});
