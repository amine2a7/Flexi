import type { Messages } from './messages';

type Leaves<T, Prefix extends string = ''> = {
  [K in keyof T & string]: T[K] extends string ? `${Prefix}${K}` : Leaves<T[K], `${Prefix}${K}.`>;
}[keyof T & string];

/** Any message key of the French reference catalogue. */
export type MessageKey = Leaves<Messages>;

/**
 * Key computed at runtime (navigation entries, status tokens, error codes). The catalogue tests
 * guarantee that every such key exists in the three languages.
 */
export function messageKey(key: string): MessageKey {
  return key as MessageKey;
}
