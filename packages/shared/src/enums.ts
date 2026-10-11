import { z } from 'zod';

/** Only TND exists (contract schema `Currency`). Stored unit: the millime. */
export const CURRENCY = 'TND';
export const currencySchema = z.enum([CURRENCY]);
export type Currency = z.infer<typeof currencySchema>;

/** Direction of a movement: amounts are never negative (contract schema `Direction`). */
export const DIRECTIONS = ['DEBIT', 'CREDIT'] as const;
export const directionSchema = z.enum(DIRECTIONS);
export type Direction = z.infer<typeof directionSchema>;

/** Time zone of business rules: daily/monthly limits, D+2, expirations (decision 2026-10-09). API timestamps are UTC. */
export const BUSINESS_TIME_ZONE = 'Africa/Tunis';
