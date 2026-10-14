import { createHmac, randomBytes } from 'node:crypto';

// TOTP, RFC 6238: SHA-1, 30 s, 6 digits (contract §10, DP n° 23). ±1 step of clock drift; a step
// already used is refused (no replay of a code within its window).

const ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
export const STEP_SECONDS = 30;

export function newSecretBase32(): string {
  const bytes = randomBytes(20);
  let bits = 0;
  let value = 0;
  let output = '';
  for (const byte of bytes) {
    value = (value << 8) | byte;
    bits += 8;
    while (bits >= 5) {
      output += ALPHABET.charAt((value >>> (bits - 5)) & 31);
      bits -= 5;
    }
  }
  if (bits > 0) output += ALPHABET.charAt((value << (5 - bits)) & 31);
  return output;
}

function decodeBase32(secret: string): Buffer {
  let bits = 0;
  let value = 0;
  const bytes: number[] = [];
  for (const char of secret.replace(/=+$/, '')) {
    const index = ALPHABET.indexOf(char);
    if (index < 0) throw new Error('invalid base32');
    value = (value << 5) | index;
    bits += 5;
    if (bits >= 8) {
      bytes.push((value >>> (bits - 8)) & 255);
      bits -= 8;
    }
  }
  return Buffer.from(bytes);
}

export function codeAt(secretBase32: string, step: bigint): string {
  const counter = Buffer.alloc(8);
  counter.writeBigUInt64BE(step);
  const digest = createHmac('sha1', decodeBase32(secretBase32)).update(counter).digest();
  const offset = (digest[digest.length - 1] ?? 0) & 0x0f;
  const binary = digest.readUInt32BE(offset) & 0x7fffffff;
  return String(binary % 1_000_000).padStart(6, '0');
}

export function currentStep(now = Date.now()): bigint {
  return BigInt(Math.floor(now / 1000 / STEP_SECONDS));
}

/** Step matched by `code` within ±1 step, or undefined. Steps ≤ `lastStep` are refused. */
export function matchStep(
  secretBase32: string,
  code: string,
  lastStep: bigint | null,
  now = Date.now(),
): bigint | undefined {
  const step = currentStep(now);
  for (const candidate of [step - 1n, step, step + 1n]) {
    if (lastStep !== null && candidate <= lastStep) continue;
    if (codeAt(secretBase32, candidate) === code) return candidate;
  }
  return undefined;
}

export function otpauthUri(label: string, secretBase32: string): string {
  const account = encodeURIComponent(`FlexiPay:${label}`);
  return `otpauth://totp/${account}?secret=${secretBase32}&issuer=FlexiPay&algorithm=SHA1&digits=6&period=30`;
}
