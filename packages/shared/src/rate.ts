import { z } from 'zod';

/** Rates are integer basis points: 100 % = 10 000 bps, 2 % = 200 bps. */
export const BPS_PER_UNIT = 10_000;
export const MIN_RATE_BPS = 0;
export const MAX_RATE_BPS = BPS_PER_UNIT;

/** Rate in basis points, 0 .. 10 000 (contract schema `RateBps`). */
export const rateBpsSchema = z.number().int().min(MIN_RATE_BPS).max(MAX_RATE_BPS).brand<'Bps'>();

export type RateBps = z.infer<typeof rateBpsSchema>;
