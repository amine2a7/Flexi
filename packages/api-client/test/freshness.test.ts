import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { CONTRACT_PATH, generateSchemaSource, SCHEMA_PATH } from '../scripts/codegen.js';

describe('generated client types', () => {
  const committed = readFileSync(SCHEMA_PATH, 'utf8');

  it('are up to date with docs/handoff/contracts/openapi.yaml', async () => {
    // On failure: run `pnpm --filter @flexipay/api-client generate` and commit the result.
    expect(committed).toBe(await generateSchemaSource(CONTRACT_PATH));
  }, 60_000);

  it('type amounts (int64 millimes) and rates (basis points) as number', () => {
    expect(committed).toContain('AmountMillimes: number;');
    expect(committed).toContain('PositiveAmountMillimes: number;');
    expect(committed).toContain('RateBps: number;');
    expect(committed).not.toMatch(/\bbigint\b/);
  });
});
