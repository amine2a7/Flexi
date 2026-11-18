// TEST-FIRST (securite B5-S07): the stored request fingerprint must not reveal the PIN of a
// payment confirmation (10 000 candidates would be enough against a plain SHA-256).
import { createHash, randomBytes } from 'node:crypto';
import type { Request } from 'express';
import { describe, expect, it } from 'vitest';
import type { DbService } from '../../src/common/db.service.js';
import { IdempotencyService } from '../../src/common/idempotency.service.js';

const request = (pin: string) =>
  ({
    method: 'POST',
    path: '/v1/employee/payment-requests/0193a1c4-0000-7000-8000-000000000001/confirm',
    originalUrl: '/v1/employee/payment-requests/0193a1c4-0000-7000-8000-000000000001/confirm',
    body: { pin },
  }) as unknown as Request;

describe('idempotency fingerprint', () => {
  const service = new IdempotencyService({} as DbService, {
    session: randomBytes(32),
    data: randomBytes(32),
    fileLink: randomBytes(32),
  });

  it('is keyed by a server secret: no PIN can be found from it by trying the 10 000 values', () => {
    const stored = service.fingerprint(request('4826'));
    const found = Array.from({ length: 10_000 }, (_, n) => String(n).padStart(4, '0')).find(
      (pin) =>
        createHash('sha256')
          .update(JSON.stringify([request(pin).method, request(pin).path, [], { pin }]))
          .digest('hex') === stored,
    );
    expect(found).toBeUndefined();
    expect(stored).toMatch(/^[0-9a-f]{64}$/);
  });

  it('stays the same for the same request and differs for another body', () => {
    expect(service.fingerprint(request('4826'))).toBe(service.fingerprint(request('4826')));
    expect(service.fingerprint(request('4826'))).not.toBe(service.fingerprint(request('4827')));
  });
});
