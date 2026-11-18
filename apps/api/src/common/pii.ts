import { Inject, Injectable, type Provider } from '@nestjs/common';
import { ENV } from '../config/env.provider.js';
import type { Env } from '../config/env.js';
import { encryptSecret } from './crypto.js';
import { DbService } from './db.service.js';
import {
  blindIndex,
  isSealedValue,
  openWith,
  sealWith,
  unwrapKeys,
  type DataKeyRow,
  type KeyRing,
} from './keyring.js';

// Personal data encrypted at rest (securite B5-S11, SEC-1): phones, IBAN, CIN number and tax id
// are sealed with AES-256-GCM under a data key (envelope, common/keyring.ts); the identifiers
// that are searched or kept unique also have a blind index (HMAC-SHA256, BLIND_INDEX_KEY), so
// that they are found without being decrypted. Out of the API, only the last 4 characters.

export function isSealed(value: string): boolean {
  return isSealedValue(value);
}

/** Sealing with a key of its own (the seed and the tests): same format as before SEC-1. */
export function sealPii(key: Buffer, value: string): string {
  return encryptSecret(key, value);
}

/** Search index of a phone number (sign-in by phone, uniqueness), with the blind index key. */
export function phoneIndex(blindKey: Buffer, phone: string): string {
  return blindIndex(blindKey, 'phone', phone);
}

/** CIN number: 8 digits. */
export function normaliseNationalId(value: string): string {
  return value.replace(/\s+/g, '');
}

/** Tax id (matricule fiscal), upper case, without spaces. */
export function normaliseTaxId(value: string): string {
  return value.replace(/\s+/g, '').toUpperCase();
}

/** Last 4 characters only (CIN, RIB, tax id): never the whole value out of the API. */
export function maskTail(clear: string): string {
  return `•••• ${clear.slice(-4)}`;
}

export const KEYRING = Symbol('KEYRING');

/** Data keys unwrapped once at start-up with the master key; a missing key stops the API. */
export const keyringProvider: Provider = {
  provide: KEYRING,
  inject: [ENV, DbService],
  useFactory: async (env: Env, db: DbService): Promise<KeyRing> => {
    const rows = await db.prisma.$queryRaw<DataKeyRow[]>`
      SELECT id, wrapped_key, retired_at FROM data_keys ORDER BY id`;
    return {
      ...unwrapKeys(Buffer.from(env.DATA_MASTER_KEY, 'base64'), rows),
      legacy: Buffer.from(env.DATA_ENCRYPTION_KEY, 'base64'),
      blind: Buffer.from(env.BLIND_INDEX_KEY, 'base64'),
    };
  },
};

@Injectable()
export class PiiService {
  constructor(@Inject(KEYRING) private readonly ring: KeyRing) {}

  seal(value: string): string {
    return sealWith(this.ring, value);
  }

  sealNullable(value: string | null | undefined): string | null {
    return value === null || value === undefined || value === '' ? null : this.seal(value);
  }

  /** Decrypts a sealed value; a value in clear is an error (never shown as if it were trusted). */
  open(value: string): string {
    return openWith(this.ring, value);
  }

  openNullable(value: string | null): string | null {
    return value === null ? null : this.open(value);
  }

  phoneIndex(phone: string): string {
    return phoneIndex(this.ring.blind, phone);
  }

  nationalIdIndex(value: string): string {
    return blindIndex(this.ring.blind, 'cin', normaliseNationalId(value));
  }

  taxIdIndex(value: string): string {
    return blindIndex(this.ring.blind, 'tax', normaliseTaxId(value));
  }

  ibanIndex(iban: string): string {
    return blindIndex(this.ring.blind, 'iban', iban);
  }

  /** Masked IBAN of a sealed value: last 4 digits only. */
  maskedIban(sealed: string): string {
    return maskTail(this.open(sealed));
  }

  maskedNullable(sealed: string | null): string | null {
    return sealed === null ? null : maskTail(this.open(sealed));
  }
}
