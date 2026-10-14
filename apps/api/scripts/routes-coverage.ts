// Contract coverage: every route of docs/handoff/contracts/openapi.yaml has a handler in the API
// (and the API has no route outside the contract, except the development-only /__demo routes).
//   pnpm --filter @flexipay/api routes:check
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';

process.env.NODE_ENV ??= 'development';
const { AppModule } = await import('../src/app.module.js');

const contract = readFileSync(
  join(import.meta.dirname, '..', '..', '..', 'docs', 'handoff', 'contracts', 'openapi.yaml'),
  'utf8',
);
const expected = new Set<string>();
let path = '';
for (const line of contract.split(/\r?\n/)) {
  const route = /^ {2}(\/[^:]+):\s*$/.exec(line);
  if (route?.[1] !== undefined) {
    path = route[1];
    continue;
  }
  const method = /^ {4}(get|post|put|patch|delete):/.exec(line);
  if (method?.[1] !== undefined && path !== '')
    expected.add(`${method[1].toUpperCase()} ${path.replace(/\{[^}]+\}/g, ':p')}`);
}

const app = await NestFactory.create<NestExpressApplication>(AppModule, {
  logger: false,
  bodyParser: false,
});
await app.init();
const router = app.getHttpAdapter().getInstance() as {
  router?: { stack: { route?: { path: string; methods: Record<string, boolean> } }[] };
};
const actual = new Set<string>();
for (const layer of router.router?.stack ?? []) {
  if (layer.route === undefined) continue;
  for (const method of Object.keys(layer.route.methods)) {
    actual.add(`${method.toUpperCase()} ${layer.route.path.replace(/:[A-Za-z]+/g, ':p')}`);
  }
}
await app.close();

const missing = [...expected].filter((route) => !actual.has(route)).sort();
const extra = [...actual]
  .filter((route) => !expected.has(route) && !route.includes('/__demo/'))
  .sort();
console.log(
  `contract routes: ${String(expected.size)}, implemented: ${String(expected.size - missing.length)}`,
);
if (missing.length > 0) console.log(`missing:\n  ${missing.join('\n  ')}`);
if (extra.length > 0) console.log(`outside the contract:\n  ${extra.join('\n  ')}`);
process.exit(missing.length + extra.length === 0 ? 0 : 1);
