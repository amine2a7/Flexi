import { describe, expect, it } from 'vitest';
import { codeAt, matchStep, newSecretBase32 } from '../../src/auth/totp.js';

// RFC 6238 appendix B, SHA-1 secret "12345678901234567890" (base32 below), last 6 digits.
const RFC_SECRET = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ'; // gitleaks:allow (public RFC 6238 test vector)

describe('TOTP (RFC 6238, SHA-1, 30 s, 6 digits)', () => {
  it.each([
    [59, '287082'],
    [1_111_111_109, '081804'],
    [1_234_567_890, '005924'],
    [2_000_000_000, '279037'],
  ])('matches the RFC vector at T=%i', (seconds, code) => {
    expect(codeAt(RFC_SECRET, BigInt(Math.floor(seconds / 30)))).toBe(code);
  });

  it('accepts one step of drift and refuses a step already used', () => {
    const now = 1_234_567_890_000;
    const step = BigInt(Math.floor(now / 30_000));
    const code = codeAt(RFC_SECRET, step - 1n);
    expect(matchStep(RFC_SECRET, code, null, now)).toBe(step - 1n);
    expect(matchStep(RFC_SECRET, code, step - 1n, now)).toBeUndefined();
    expect(matchStep(RFC_SECRET, codeAt(RFC_SECRET, step - 2n), null, now)).toBeUndefined();
  });

  it('generates 160-bit base32 secrets', () => {
    expect(newSecretBase32()).toMatch(/^[A-Z2-7]{32}$/);
  });
});
