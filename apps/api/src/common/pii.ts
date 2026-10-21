import { createHmac } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { KEYS, type Keys } from '../config/env.provider.js';
import { decryptSecret, encryptSecret } from './crypto.js';

// Personal data encrypted at rest (securite B5-S11): IBAN and phone numbers are stored with
// AES-256-GCM (key DATA_ENCRYPTION_KEY, like the TOTP secrets); a phone used to sign in is also
// stored as an HMAC index, so that it can be found and kept unique without being decrypted.

/** Format of a sealed value: iv.tag.ciphertext (base64url). A clear value never matches. */
const SEALED = /^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$/;

export function isSealed(value: string): boolean {
  return SEALED.test(value);
}

export function sealPii(key: Buffer, value: string): string {
  return encryptSecret(key, value);
}

/** Decrypts a sealed value; a value in clear is an error (never shown as if it were trusted). */
export function openPii(key: Buffer, value: string): string {
  if (!isSealed(value)) throw new Error('personal data not encrypted');
  return decryptSecret(key, value);
}

/** Search index of a phone number (sign-in by phone, uniqueness). */
export function phoneIndex(key: Buffer, phone: string): string {
  return createHmac('sha256', key).update(`phone|${phone}`).digest('hex');
}

@Injectable()
export class PiiService {
  constructor(@Inject(KEYS) private readonly keys: Keys) {}

  seal(value: string): string {
    return sealPii(this.keys.data, value);
  }

  sealNullable(value: string | null | undefined): string | null {
    return value === null || value === undefined || value === '' ? null : this.seal(value);
  }

  open(value: string): string {
    return openPii(this.keys.data, value);
  }

  openNullable(value: string | null): string | null {
    return value === null ? null : this.open(value);
  }

  phoneIndex(phone: string): string {
    return phoneIndex(this.keys.data, phone);
  }

  /** Masked IBAN of a sealed value: last 4 digits only. */
  maskedIban(sealed: string): string {
    return `•••• ${this.open(sealed).slice(-4)}`;
  }
}
