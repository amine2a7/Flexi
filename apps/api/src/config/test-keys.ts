import { createHmac } from 'node:crypto';

/**
 * Keys and passwords that the integration tests derive when infra/.env does not hold them yet
 * (test/integration/setup.ts). The derivation is published here only so that the API can refuse
 * them: in production, a value equal to its test derivation stops the start-up (loadEnv).
 */
export const TEST_DERIVED_NAMES = [
  'MIGRATE_DB_PASSWORD',
  'WORKER_DB_PASSWORD',
  'REPORT_DB_PASSWORD',
  'DATA_MASTER_KEY',
  'BLIND_INDEX_KEY',
  'PASSWORD_PEPPER',
  'FILE_LINK_SECRET',
] as const;

export function testDerivedValue(seed: string, name: string): string {
  return createHmac('sha256', seed).update(`flexipay-test|${name}`).digest('base64');
}
