import type { Provider } from '@nestjs/common';
import { loadEnv, type Env } from './env.js';

/** Injection token of the checked environment. */
export const ENV = Symbol('ENV');

export function envProvider(env: Env = loadEnv()): Provider {
  return { provide: ENV, useValue: env };
}

/** Keys derived from the secrets of the environment (never logged). */
export const KEYS = Symbol('KEYS');

export interface Keys {
  readonly session: Buffer;
  readonly data: Buffer;
}

export const keysProvider: Provider = {
  provide: KEYS,
  inject: [ENV],
  useFactory: (env: Env): Keys => ({
    session: Buffer.from(env.SESSION_SECRET, 'base64'),
    data: Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64'),
  }),
};
