import { randomBytes } from 'node:crypto';
// The test clock of the end-to-end journey (request of 2026-11-12): days move forward for the
// whole API process, only when TEST_CLOCK=1, never in production.
import { afterEach, describe, expect, it } from 'vitest';
import type { Request } from 'express';
import {
  advanceTestClock,
  installTestClock,
  isLocalTestRequest,
  resetTestClock,
} from '../../src/common/test-clock.js';
import { loadEnv } from '../../src/config/env.js';

const DAY = 86_400_000;

describe('test clock', () => {
  afterEach(() => {
    resetTestClock();
  });

  it('moves new Date() and Date.now() forward, explicit dates stay as given', () => {
    installTestClock();
    const before = Date.now();
    advanceTestClock(3);
    expect(Date.now() - before).toBeGreaterThanOrEqual(3 * DAY);
    expect(new Date().getTime() - before).toBeGreaterThanOrEqual(3 * DAY);
    expect(new Date('2026-11-12T00:00:00Z').toISOString()).toBe('2026-11-12T00:00:00.000Z');
    expect(new Date(0).getTime()).toBe(0);
    expect(new Date()).toBeInstanceOf(Date);
  });

  it('refuses to move backwards or by more than 60 days at once', () => {
    installTestClock();
    expect(() => {
      advanceTestClock(-1);
    }).toThrow();
    expect(() => {
      advanceTestClock(61);
    }).toThrow();
  });

  it('is forbidden in production', () => {
    const base = {
      NODE_ENV: 'production',
      PG_ADMIN_URL: 'postgresql://localhost/postgres',
      APP_DB_PASSWORD: 'x'.repeat(16),
      MIGRATE_DB_PASSWORD: 'y'.repeat(16),
      DB_SSL: 'verify-full',
      SESSION_SECRET: randomBytes(32).toString('base64'),
      DATA_ENCRYPTION_KEY: randomBytes(32).toString('base64'),
      DATA_MASTER_KEY: randomBytes(32).toString('base64'),
      BLIND_INDEX_KEY: randomBytes(32).toString('base64'),
      PASSWORD_PEPPER: randomBytes(32).toString('base64'),
      FILE_LINK_SECRET: randomBytes(32).toString('base64'),
      WEB_ORIGINS: 'https://app.flexipay.tn',
    };
    expect(() => loadEnv(base)).not.toThrow();
    expect(() => loadEnv({ ...base, TEST_CLOCK: '1' })).toThrow(/TEST_CLOCK/);
    // SEC-1: TLS to the database, one key per use.
    expect(() => loadEnv({ ...base, DB_SSL: 'disable' })).toThrow(/DB_SSL/);
    expect(() => loadEnv({ ...base, PASSWORD_PEPPER: base.SESSION_SECRET })).toThrow(
      /PASSWORD_PEPPER must differ from SESSION_SECRET/,
    );
    // Never a dummy key nor the test database in production (SEC-1 review).
    expect(() =>
      loadEnv({ ...base, DATA_MASTER_KEY: Buffer.alloc(32, 7).toString('base64') }),
    ).toThrow(/DATA_MASTER_KEY is a dummy key/);
    expect(() => loadEnv({ ...base, DB_NAME: 'flexipay_test' })).toThrow(/test database/);
    // A missing or short key stops the start-up.
    expect(() => loadEnv({ ...base, DATA_MASTER_KEY: undefined })).toThrow(/DATA_MASTER_KEY/);
    expect(() => loadEnv({ ...base, BLIND_INDEX_KEY: randomBytes(16).toString('base64') })).toThrow(
      /BLIND_INDEX_KEY/,
    );
  });

  it('answers only the local test runner: loopback, not relayed, no Origin, test header', () => {
    const request = (headers: Record<string, string>, remoteAddress = '127.0.0.1') =>
      ({
        headers: { host: 'localhost:3198', 'x-flexipay-test': '1', ...headers },
        socket: { remoteAddress },
      }) as unknown as Request;
    expect(isLocalTestRequest(request({}))).toBe(true);
    expect(isLocalTestRequest(request({}, '10.0.0.4'))).toBe(false);
    expect(isLocalTestRequest(request({ 'x-forwarded-for': '203.0.113.9' }))).toBe(false);
    expect(isLocalTestRequest(request({ forwarded: 'for=203.0.113.9' }))).toBe(false);
    expect(isLocalTestRequest(request({ origin: 'https://evil.example' }))).toBe(false);
    expect(isLocalTestRequest(request({ host: 'abcd.ngrok.app' }))).toBe(false);
    expect(isLocalTestRequest(request({ 'x-flexipay-test': '0' }))).toBe(false);
  });
});
