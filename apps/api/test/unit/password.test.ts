import { describe, expect, it } from 'vitest';
import { brokenRules, hashSecret, verifySecret } from '../../src/auth/password.js';

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
});
