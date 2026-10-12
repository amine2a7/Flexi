import { writeFile } from 'node:fs/promises';
import { fileURLToPath, pathToFileURL } from 'node:url';
import openapiTS, { astToString } from 'openapi-typescript';
import { format, resolveConfig } from 'prettier';

/** Source of truth, written by hand by backend. */
export const CONTRACT_PATH = fileURLToPath(
  new URL('../../../docs/handoff/contracts/openapi.yaml', import.meta.url),
);

/** Generated types, committed and compared by test/freshness.test.ts. */
export const SCHEMA_PATH = fileURLToPath(new URL('../src/generated/schema.ts', import.meta.url));

const BANNER = `/**
 * GENERATED from docs/handoff/contracts/openapi.yaml by openapi-typescript. DO NOT EDIT.
 * Regenerate: pnpm --filter @flexipay/api-client generate
 */
`;

/**
 * Generates the TypeScript types of the contract, formatted with the repository Prettier config,
 * so that the committed file can be compared byte for byte.
 * Amounts (`integer`, `int64`, millimes) are generated as `number` (checked by the freshness test).
 */
export async function generateSchemaSource(contractPath: string): Promise<string> {
  // enumValues: runtime arrays of every enum (e.g. problemCodeValues), used by isKnownProblemCode.
  const ast = await openapiTS(pathToFileURL(contractPath), { enumValues: true });
  const prettierConfig = (await resolveConfig(SCHEMA_PATH)) ?? {};
  return format(BANNER + astToString(ast), { ...prettierConfig, filepath: SCHEMA_PATH });
}

// CLI: pnpm --filter @flexipay/api-client generate (node --experimental-strip-types scripts/codegen.ts)
if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
  await writeFile(SCHEMA_PATH, await generateSchemaSource(CONTRACT_PATH), 'utf8');
  process.stdout.write('api-client: src/generated/schema.ts regenerated from the contract\n');
}
