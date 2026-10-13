import type { Schemas } from '@flexipay/api-client';

export type CreditType = Schemas['CreditType'];

/** The 4 credit types, in display order (decision of 2026-10-13). Usable on the server too. */
export const CREDIT_TYPES: readonly CreditType[] = [
  'RESTAURATION',
  'HABILLEMENT',
  'CARBURANT',
  'CADEAUX',
];
