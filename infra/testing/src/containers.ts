import { randomBytes } from 'node:crypto';
import { PostgreSqlContainer, type StartedPostgreSqlContainer } from '@testcontainers/postgresql';
import { RedisContainer, type StartedRedisContainer } from '@testcontainers/redis';
import pg from 'pg';
import { POSTGRES_IMAGE, REDIS_IMAGE } from './images.js';

/** Host interface for published ports: loopback only, never 0.0.0.0 (threat DC-1). */
export const LOOPBACK_IP = '127.0.0.1';

/** Application role used by tests that exercise RLS: not superuser, no BYPASSRLS (threat DC-5). */
export const APP_ROLE = 'flexipay_app';

/** Throwaway credential, generated per container: never a literal in the code. */
function ephemeralSecret(): string {
  return randomBytes(24).toString('hex');
}

export interface PortBinding {
  HostIp?: string;
  HostPort?: string;
}

/** Rewrites every port binding of a container definition to the loopback interface (exported for unit tests). */
export function bindToLoopback(
  bindings: Record<string, PortBinding[] | undefined> | undefined,
): void {
  if (bindings === undefined) return;
  for (const key of Object.keys(bindings)) {
    bindings[key] = (bindings[key] ?? []).map((b) => ({ ...b, HostIp: LOOPBACK_IP }));
  }
}

/** Host IPs actually used by Docker for the published ports (read back after start). */
function publishedHostIps(container: StartedPostgreSqlContainer | StartedRedisContainer): string[] {
  const ports = (
    container as unknown as {
      startedTestContainer: {
        inspectResult: { NetworkSettings: { Ports: Record<string, PortBinding[] | null> } };
      };
    }
  ).startedTestContainer.inspectResult.NetworkSettings.Ports;
  const ips = Object.values(ports)
    .flatMap((list) => list ?? [])
    .map((b) => b.HostIp ?? '');
  return [...new Set(ips)];
}

class LoopbackPostgreSqlContainer extends PostgreSqlContainer {
  public override async start(): Promise<StartedPostgreSqlContainer> {
    bindToLoopback(this.hostConfig.PortBindings as Record<string, PortBinding[]> | undefined);
    return super.start();
  }
}

class LoopbackRedisContainer extends RedisContainer {
  public override async start(): Promise<StartedRedisContainer> {
    bindToLoopback(this.hostConfig.PortBindings as Record<string, PortBinding[]> | undefined);
    return super.start();
  }
}

export interface StartedPostgres {
  /** Superuser of the container: schema setup and migrations only. */
  readonly adminConnectionUri: string;
  /** Application role (NOSUPERUSER, NOBYPASSRLS): use it for any test touching tenant data. */
  readonly appConnectionUri: string;
  readonly appRole: string;
  readonly hostBindingIps: readonly string[];
  stop(): Promise<void>;
}

export interface StartedRedis {
  readonly connectionUrl: string;
  readonly host: string;
  readonly port: number;
  readonly hostBindingIps: readonly string[];
  stop(): Promise<void>;
}

async function createAppRole(adminUri: string, password: string): Promise<void> {
  const client = new pg.Client({ connectionString: adminUri });
  await client.connect();
  try {
    // DDL cannot take bind parameters: identifiers are constants and the password is hex only.
    if (!/^[a-f0-9]+$/.test(password)) throw new Error('unexpected password format');
    await client.query(
      `CREATE ROLE ${APP_ROLE} LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION PASSWORD '${password}'`,
    );
    await client.query(`GRANT USAGE ON SCHEMA public TO ${APP_ROLE}`);
  } finally {
    await client.end();
  }
}

/**
 * Starts a disposable PostgreSQL 16 container, ports on 127.0.0.1, with an application role.
 * The caller must call `stop()` (Ryuk is disabled).
 */
export async function startPostgres(): Promise<StartedPostgres> {
  const container = await new LoopbackPostgreSqlContainer(POSTGRES_IMAGE)
    .withDatabase('flexipay_test')
    .withUsername('flexipay_admin')
    .withPassword(ephemeralSecret())
    .start();
  try {
    const appPassword = ephemeralSecret();
    await createAppRole(container.getConnectionUri(), appPassword);
    const appUri = new URL(container.getConnectionUri());
    appUri.username = APP_ROLE;
    appUri.password = appPassword;
    return {
      adminConnectionUri: container.getConnectionUri(),
      appConnectionUri: appUri.toString(),
      appRole: APP_ROLE,
      hostBindingIps: publishedHostIps(container),
      stop: async () => {
        await container.stop();
      },
    };
  } catch (error) {
    await container.stop();
    throw error;
  }
}

/** Starts a disposable Redis container, password protected, ports on 127.0.0.1. The caller must call `stop()`. */
export async function startRedis(): Promise<StartedRedis> {
  const container = await new LoopbackRedisContainer(REDIS_IMAGE)
    .withPassword(ephemeralSecret())
    .start();
  return {
    connectionUrl: container.getConnectionUrl(),
    host: container.getHost(),
    port: container.getPort(),
    hostBindingIps: publishedHostIps(container),
    stop: async () => {
      await container.stop();
    },
  };
}
