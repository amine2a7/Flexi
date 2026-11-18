import { hash, verify, type Algorithm } from '@node-rs/argon2';

/**
 * Argon2id of passwords, PINs and temporary passwords (SEC-1): 64 MiB, 3 passes, with a pepper
 * (Argon2 secret key) read from PASSWORD_PEPPER, never stored with the hashes. The parameters are
 * written in the hash itself: a hash of the former parameters (19 MiB, 2 passes, no pepper) is
 * still verified, then replaced at the next successful sign-in (`needsRehash`).
 */
// `Algorithm` is a const enum (not importable as a value here): 2 = Argon2id.
const ARGON2 = { algorithm: 2 as Algorithm, memoryCost: 65_536, timeCost: 3, parallelism: 1 };
const CURRENT_PREFIX = '$argon2id$v=19$m=65536,t=3,p=1$';

export const MIN_LENGTH = 12;
export const MAX_LENGTH = 128;

let cachedPepper: Buffer | undefined;
/** Pepper of the environment (base64, 32 bytes at least); its absence stops the API. */
function pepper(): Buffer {
  if (cachedPepper !== undefined) return cachedPepper;
  const raw = process.env.PASSWORD_PEPPER ?? '';
  const key = Buffer.from(raw, 'base64');
  if (!/^[A-Za-z0-9+/]+={0,2}$/.test(raw) || key.length < 32) {
    throw new Error('PASSWORD_PEPPER is missing or shorter than 32 bytes');
  }
  cachedPepper = key;
  return key;
}

export async function hashSecret(secret: string): Promise<string> {
  return hash(secret, { ...ARGON2, secret: pepper() });
}

/** True for a hash of the former parameters (no pepper): replace it after a good verification. */
export function needsRehash(stored: string): boolean {
  return !stored.startsWith(CURRENT_PREFIX);
}

export async function verifySecret(stored: string, secret: string): Promise<boolean> {
  try {
    return needsRehash(stored)
      ? await verify(stored, secret)
      : await verify(stored, secret, { secret: pepper() });
  } catch {
    return false;
  }
}

let dummy: Promise<string> | undefined;
/**
 * Hash of a random value, verified when the identifier is unknown so that every
 * INVALID_CREDENTIALS answer costs the same (contract §10, WD1-S01).
 */
export function dummyHash(): Promise<string> {
  dummy ??= hashSecret(`dummy-${String(Math.random())}`);
  return dummy;
}

/** Published rules (GET /v1/auth/password-policy); the server stays the judge. */
export const PASSWORD_POLICY = {
  rules: [
    { code: 'MIN_LENGTH', params: { min: MIN_LENGTH } },
    { code: 'MAX_LENGTH', params: { max: MAX_LENGTH } },
    { code: 'NOT_COMPROMISED' },
    { code: 'NOT_IDENTIFIER' },
    { code: 'DIFFERENT_FROM_CURRENT' },
  ],
} as const;

// Most common passwords and their local variants (offline list: no password ever leaves the API).
const COMPROMISED = new Set(
  [
    '123456789012',
    '1234567890123',
    'azerty123456',
    'azertyuiop12',
    'qwerty123456',
    'password1234',
    'password12345',
    'motdepasse12',
    'motdepasse123',
    'motdepasse1234',
    'tunisie12345',
    'tunisie123456',
    'flexipay1234',
    'flexipay12345',
    'administrator',
    'iloveyou1234',
    'welcome12345',
    'letmein12345',
    'abcdefghijkl',
    '000000000000',
    '111111111111',
  ].map((value) => value.toLowerCase()),
);

export type PolicyRuleCode = (typeof PASSWORD_POLICY.rules)[number]['code'];

/**
 * Rules broken by `candidate`. `identifier` (e-mail, phone) must not be contained in it; the
 * current password, when known, must be different.
 */
export async function brokenRules(
  candidate: string,
  identifiers: readonly string[],
  currentHash?: string,
): Promise<{ code: PolicyRuleCode; params?: Record<string, number> }[]> {
  const broken: { code: PolicyRuleCode; params?: Record<string, number> }[] = [];
  // Length in code points (an accented letter or an Arabic letter counts for one).
  const length = Array.from(candidate).length;
  if (length < MIN_LENGTH) broken.push({ code: 'MIN_LENGTH', params: { min: MIN_LENGTH } });
  if (length > MAX_LENGTH) broken.push({ code: 'MAX_LENGTH', params: { max: MAX_LENGTH } });
  if (COMPROMISED.has(candidate.toLowerCase())) broken.push({ code: 'NOT_COMPROMISED' });
  const lower = candidate.toLowerCase();
  const parts = identifiers
    .flatMap((value) => [value.toLowerCase(), value.toLowerCase().split('@')[0] ?? ''])
    .filter((value) => value.length >= 4);
  if (parts.some((part) => lower.includes(part))) broken.push({ code: 'NOT_IDENTIFIER' });
  if (currentHash !== undefined && (await verifySecret(currentHash, candidate))) {
    broken.push({ code: 'DIFFERENT_FROM_CURRENT' });
  }
  return broken;
}
