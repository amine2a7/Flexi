import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { POSTGRES_IMAGE, REDIS_IMAGE } from '../../src/images.js';

const composePath = fileURLToPath(new URL('../../../docker-compose.yml', import.meta.url));
// Comment lines are removed: only effective configuration is checked.
const compose = readFileSync(composePath, 'utf8')
  .split(/\r?\n/)
  .filter((line) => !line.trimStart().startsWith('#'))
  .join('\n');
const pinned = /^[a-z0-9./-]+:[A-Za-z0-9._-]+@sha256:[a-f0-9]{64}$/;

describe('container images', () => {
  it('are pinned by version and sha256 digest', () => {
    expect(POSTGRES_IMAGE).toMatch(pinned);
    expect(REDIS_IMAGE).toMatch(pinned);
  });

  it('use PostgreSQL 16', () => {
    expect(POSTGRES_IMAGE).toMatch(/^postgres:16\.\d+-alpine@/);
  });

  it('are the same images as infra/docker-compose.yml', () => {
    const images = [...compose.matchAll(/^\s*image:\s*(\S+)\s*$/gm)].map((m) => m[1]);
    expect(images.sort()).toEqual([POSTGRES_IMAGE, REDIS_IMAGE].sort());
  });
});

describe('infra/docker-compose.yml hardening', () => {
  it('binds every published port to 127.0.0.1', () => {
    const ports = [...compose.matchAll(/^\s*-\s*'([^']*:\d+)'\s*$/gm)].map((m) => m[1] ?? '');
    expect(ports.length).toBeGreaterThan(0);
    for (const p of ports) expect(p.startsWith('127.0.0.1:')).toBe(true);
  });

  it('requires every password and user from the environment (no default, no literal)', () => {
    const secrets = [
      ...compose.matchAll(/^\s*(POSTGRES_PASSWORD|POSTGRES_USER|REDIS_PASSWORD):\s*(.+)$/gm),
    ];
    expect(secrets.length).toBe(3);
    for (const [, , value] of secrets) expect(value).toMatch(/^\$\{[A-Z_]+:\?.+\}$/);
  });

  it('defines healthchecks and named volumes', () => {
    expect(compose.match(/^\s*healthcheck:/gm)?.length).toBe(2);
    expect(compose).toMatch(/^volumes:\n\s+postgres-data:\n\s+redis-data:/m);
  });

  it('never uses privileged mode, host network or the Docker socket', () => {
    expect(compose).not.toMatch(/privileged:\s*true/);
    expect(compose).not.toMatch(/network_mode:\s*host/);
    expect(compose).not.toMatch(/docker\.sock/);
  });
});
