import { describe, expect, it } from 'vitest';
import { APP_ROLE, bindToLoopback, LOOPBACK_IP } from '../../src/containers.js';

describe('bindToLoopback', () => {
  it('forces 127.0.0.1 on every binding, keeping the host port', () => {
    const bindings = {
      '5432/tcp': [{ HostPort: '0' }],
      '6379/tcp': [{ HostIp: '0.0.0.0', HostPort: '6380' }],
    };
    bindToLoopback(bindings);
    expect(bindings).toEqual({
      '5432/tcp': [{ HostIp: LOOPBACK_IP, HostPort: '0' }],
      '6379/tcp': [{ HostIp: LOOPBACK_IP, HostPort: '6380' }],
    });
  });

  it('accepts a container without port bindings', () => {
    expect(() => {
      bindToLoopback(undefined);
    }).not.toThrow();
  });
});

describe('application role', () => {
  it('is a plain lower-case identifier (safe in DDL)', () => {
    expect(APP_ROLE).toMatch(/^[a-z_][a-z0-9_]*$/);
  });
});
