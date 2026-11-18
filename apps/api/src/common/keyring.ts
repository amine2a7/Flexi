import { createHmac, randomBytes } from 'node:crypto';
import { decryptSecret, encryptSecret } from './crypto.js';

/**
 * Envelope encryption of the personal data (SEC-1). Each value is sealed with a data key
 * (AES-256-GCM); the data keys are stored in `data_keys`, wrapped by the master key of the
 * environment (DATA_MASTER_KEY, a key vault later) which never reaches the database.
 *
 * Format of a sealed value: `v2.<keyId>.<iv>.<tag>.<ciphertext>` (base64url). The values sealed
 * before SEC-1 (`<iv>.<tag>.<ciphertext>`, DATA_ENCRYPTION_KEY) are still read, then re-sealed by
 * the data script `encrypt-pii`.
 */
export interface KeyRing {
  /** Key used to seal from now on. */
  readonly activeId: number;
  readonly keys: ReadonlyMap<number, Buffer>;
  /** Key of the values sealed before SEC-1. */
  readonly legacy: Buffer;
  /** Key of the blind indexes. */
  readonly blind: Buffer;
}

export interface DataKeyRow {
  readonly id: number;
  readonly wrapped_key: string;
  readonly retired_at: Date | null;
}

export function unwrapKeys(
  master: Buffer,
  rows: readonly DataKeyRow[],
): { activeId: number; keys: Map<number, Buffer> } {
  const keys = new Map<number, Buffer>();
  let activeId = 0;
  for (const row of rows) {
    keys.set(row.id, Buffer.from(decryptSecret(master, row.wrapped_key), 'base64'));
    if (row.retired_at === null && row.id > activeId) activeId = row.id;
  }
  if (activeId === 0) throw new Error('no active data key: run the migrations (db:migrate)');
  return { activeId, keys };
}

/** A new data key, wrapped by the master key (stored by the migration script only). */
export function newWrappedKey(master: Buffer): string {
  return encryptSecret(master, randomBytes(32).toString('base64'));
}

const V2 = /^v2\.([0-9]{1,5})\.([A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+)$/;
const LEGACY = /^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$/;

export function isSealedValue(value: string): boolean {
  return V2.test(value) || LEGACY.test(value);
}

/** True when the value is sealed with the current scheme (data key). */
export function isEnvelope(value: string): boolean {
  return V2.test(value);
}

export function sealWith(ring: KeyRing, value: string): string {
  const key = ring.keys.get(ring.activeId);
  if (key === undefined) throw new Error('active data key missing');
  return `v2.${String(ring.activeId)}.${encryptSecret(key, value)}`;
}

export function openWith(ring: KeyRing, sealed: string): string {
  const v2 = V2.exec(sealed);
  if (v2 !== null) {
    const key = ring.keys.get(Number(v2[1]));
    if (key === undefined) throw new Error('unknown data key');
    return decryptSecret(key, v2[2] ?? '');
  }
  if (LEGACY.test(sealed)) return decryptSecret(ring.legacy, sealed);
  throw new Error('personal data not encrypted');
}

/**
 * Blind index (HMAC-SHA256) of a normalised identifier, per kind: the same value of two kinds
 * never gives the same index. Hex, 64 characters.
 */
export function blindIndex(key: Buffer, kind: string, value: string): string {
  return createHmac('sha256', key).update(`${kind}|${value}`).digest('hex');
}
