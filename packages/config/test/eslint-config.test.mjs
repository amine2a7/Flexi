// Shared ESLint config: behaviour checks (node:test, no extra dependency).
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { ESLint } from 'eslint';
import { createConfig } from '../eslint.js';

const eslint = new ESLint({
  cwd: import.meta.dirname,
  overrideConfigFile: true,
  overrideConfig: createConfig({ tsconfigRootDir: import.meta.dirname }),
});

async function ruleIds(code, filePath) {
  const [result] = await eslint.lintText(code, { filePath });
  return (result?.messages ?? []).map((m) => m.ruleId);
}

test('no-console: refused in application code (Q0-03, SEC-D4)', async () => {
  assert.ok((await ruleIds('console.log("x");\n', 'src/service.js')).includes('no-console'));
});

test('no-console: allowed in CLI entry points (scripts/ and generate files)', async () => {
  assert.ok(!(await ruleIds('console.log("x");\n', 'scripts/codegen.js')).includes('no-console'));
  assert.ok(!(await ruleIds('console.log("x");\n', 'src/generate.js')).includes('no-console'));
});

test('money safety rules still apply', async () => {
  assert.ok(
    (await ruleIds('const a = (1).toFixed(2);\nvoid a;\n', 'src/x.js')).includes(
      'no-restricted-properties',
    ),
  );
});
