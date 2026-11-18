import { randomBytes } from 'node:crypto';
import { hash } from '@node-rs/argon2';
import { describe, expect, it } from 'vitest';

// Pepper of this test run only (never a real key).
process.env.PASSWORD_PEPPER ??= randomBytes(32).toString('base64');
const { brokenRules, hashSecret, needsRehash, verifySecret } = await import(
  '../../src/auth/password.js'
);

describe('password policy (DP 9)', () => {
  it('accepts a long password unrelated to the identifier', async () => {
    expect(await brokenRules('Rose-des-sables-2026', ['leila@carthage.tn'])).toEqual([]);
  });

  it('lists every broken rule', async () => {
    const codes = async (value: string) =>
      (await brokenRules(value, ['leila.mansour@carthage.tn', '+21698123456'])).map(
        (rule) => rule.code,
      );
    expect(await codes('court')).toEqual(['MIN_LENGTH']);
    expect(await codes('motdepasse123')).toEqual(['NOT_COMPROMISED']);
    expect(await codes('leila.mansour-2026!')).toEqual(['NOT_IDENTIFIER']);
    expect(await codes('x'.repeat(129))).toEqual(['MAX_LENGTH']);
  });

  it('counts Arabic and accented letters as one character each', async () => {
    expect(await brokenRules('كلمةسريةطويلة', [])).toEqual([]);
  });

  it('refuses the current password', async () => {
    const current = await hashSecret('Un-mot-de-passe-long');
    expect(
      (await brokenRules('Un-mot-de-passe-long', [], current)).map((rule) => rule.code),
    ).toEqual(['DIFFERENT_FROM_CURRENT']);
  });

  it('hashes with Argon2id and verifies', async () => {
    const hash = await hashSecret('Rose-des-sables-2026');
    expect(hash.startsWith('$argon2id$')).toBe(true);
    expect(await verifySecret(hash, 'Rose-des-sables-2026')).toBe(true);
    expect(await verifySecret(hash, 'rose-des-sables-2026')).toBe(false);
    expect(await verifySecret('not a hash', 'x')).toBe(false);
  });

  // SEC-1: 64 MiB, 3 passes and a pepper; a hash of the former parameters is still verified and
  // marked to be replaced at the next good sign-in.
  it('uses 64 MiB, 3 passes and the pepper; former hashes are verified then replaced', async () => {
    const current = await hashSecret('Rose-des-sables-2026');
    expect(current.startsWith('$argon2id$v=19$m=65536,t=3,p=1$')).toBe(true);
    expect(needsRehash(current)).toBe(false);
    // Without the pepper, the hash does not verify.
    const withoutPepper = await hash('Rose-des-sables-2026', {
      memoryCost: 65_536,
      timeCost: 3,
      parallelism: 1,
    });
    expect(await verifySecret(withoutPepper, 'Rose-des-sables-2026')).toBe(false);
    const former = await hash('1234', { memoryCost: 19_456, timeCost: 2, parallelism: 1 });
    expect(needsRehash(former)).toBe(true);
    expect(await verifySecret(former, '1234')).toBe(true);
    expect(await verifySecret(former, '4321')).toBe(false);
  });
});
