import type { Schemas } from '@flexipay/api-client';
import type { Random } from './fixtures/random';

type S = Schemas;
export type CreditType = S['CreditType'];

/** The 4 credit types (decision of 2026-10-13): one balance per type, no transfer between them. */
export const CREDIT_TYPES: readonly CreditType[] = [
  'RESTAURATION',
  'HABILLEMENT',
  'CARBURANT',
  'CADEAUX',
];

export type TypeBalances = Record<CreditType, number>;

export function emptyBalances(): TypeBalances {
  return { RESTAURATION: 0, HABILLEMENT: 0, CARBURANT: 0, CADEAUX: 0 };
}

export function balancesList(balances: TypeBalances): S['CreditTypeAmount'][] {
  return CREDIT_TYPES.map((creditType) => ({ creditType, amountMillimes: balances[creditType] }));
}

/** Credit types a shop accepts, from its activity (a restaurant: Restauration; a station: Carburant). */
export function typesForCategory(category: S['MerchantCategory']): CreditType[] {
  switch (category) {
    case 'CLOTHING':
      return ['HABILLEMENT'];
    case 'FUEL_STATION':
      return ['CARBURANT'];
    case 'GIFT_SHOP':
      return ['CADEAUX'];
    case 'GROCERY':
      return ['RESTAURATION', 'CADEAUX'];
    default:
      return ['RESTAURATION'];
  }
}

/** Platform settings per type (rule 6): commission, validity, daily limit, enabled. */
export const DEFAULT_TYPE_SETTINGS: S['CreditTypeSettings'][] = [
  {
    creditType: 'RESTAURATION',
    enabled: true,
    commissionRateBps: 200,
    validityMonths: 12,
    dailyLimitMillimes: 80_000,
  },
  {
    creditType: 'HABILLEMENT',
    enabled: true,
    commissionRateBps: 250,
    validityMonths: 12,
    dailyLimitMillimes: 300_000,
  },
  {
    creditType: 'CARBURANT',
    enabled: true,
    commissionRateBps: 150,
    validityMonths: 6,
    dailyLimitMillimes: 150_000,
  },
  {
    creditType: 'CADEAUX',
    enabled: true,
    commissionRateBps: 300,
    validityMonths: 12,
    dailyLimitMillimes: 250_000,
  },
];

/** Splits a total over 1 to 3 types (order lines), amounts in multiples of 100 TND. */
export function splitOverTypes(random: Random, total: number): S['CreditOrderLine'][] {
  const count = random.pick([1, 1, 2, 2, 3]);
  const types = [...CREDIT_TYPES].sort(() => random.next() - 0.5).slice(0, count);
  if (!types.includes('RESTAURATION') && random.next() < 0.7) types[0] = 'RESTAURATION';
  const unique = [...new Set(types)];
  const step = 100_000;
  let left = total;
  return unique.map((creditType, index) => {
    const last = index === unique.length - 1;
    const share = last
      ? left
      : Math.max(step, Math.floor((left * random.int(40, 70)) / 100 / step) * step);
    left -= share;
    return { creditType, amountMillimes: share };
  });
}
