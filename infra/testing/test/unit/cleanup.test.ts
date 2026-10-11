import { describe, expect, it } from 'vitest';
import { releaseAll } from '../../src/cleanup.js';

describe('releaseAll', () => {
  it('runs every step in reverse order of creation', async () => {
    const calls: string[] = [];
    await releaseAll([
      () => Promise.resolve(void calls.push('container')),
      () => Promise.resolve(void calls.push('client')),
    ]);
    expect(calls).toEqual(['client', 'container']);
  });

  it('keeps going after a failing step, then reports every failure', async () => {
    const calls: string[] = [];
    const run = releaseAll([
      () => Promise.resolve(void calls.push('container')),
      () => Promise.reject(new Error('client end failed')),
    ]);
    await expect(run).rejects.toBeInstanceOf(AggregateError);
    expect(calls).toEqual(['container']);
  });
});
