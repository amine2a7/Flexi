import { hash, verify, type Algorithm } from '@node-rs/argon2';

/** Argon2id parameters (OWASP 2024 baseline), versioned in the hash string itself. */
// `Algorithm` is a const enum (not importable as a value here): 2 = Argon2id.
const ARGON2 = { algorithm: 2 as Algorithm, memoryCost: 19_456, timeCost: 2, parallelism: 1 };

export const MIN_LENGTH = 12;
export const MAX_LENGTH = 128;

export async function hashSecret(secret: string): Promise<string> {
  return hash(secret, ARGON2);
}

export async function verifySecret(stored: string, secret: string): Promise<boolean> {
  try {
    return await verify(stored, secret);
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
