import { Redis } from 'ioredis';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { releaseAll, startRedis, type CleanupStep, type StartedRedis } from '../../src/index.js';

describe('Redis (Testcontainers)', () => {
  let redis: StartedRedis;
  let client: Redis;
  // beforeAll may fail half-way: afterAll releases only what was actually created.
  const cleanup: CleanupStep[] = [];

  beforeAll(async () => {
    redis = await startRedis();
    cleanup.push(() => redis.stop());
    client = new Redis(redis.connectionUrl, { lazyConnect: true, maxRetriesPerRequest: 1 });
    await client.connect();
    cleanup.push(async () => {
      await client.quit();
    });
  });

  afterAll(async () => {
    await releaseAll(cleanup);
  });

  it('publishes the port on the loopback interface only', () => {
    expect(redis.hostBindingIps).toEqual(['127.0.0.1']);
  });

  it('answers PING', async () => {
    await expect(client.ping()).resolves.toBe('PONG');
  });

  it('requires authentication', async () => {
    const anonymous = new Redis({
      host: redis.host,
      port: redis.port,
      lazyConnect: true,
      maxRetriesPerRequest: 0,
      enableReadyCheck: false,
      retryStrategy: () => null,
    });
    await anonymous.connect();
    await expect(anonymous.ping()).rejects.toThrow(/NOAUTH/);
    anonymous.disconnect();
  });
});
