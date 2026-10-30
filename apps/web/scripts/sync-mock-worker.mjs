// Dev only: copies the MSW service worker into public/ (git-ignored, never committed).
// `pnpm build` removes it (scripts/remove-mock-worker.mjs) so it can never ship to production.
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const require = createRequire(import.meta.url);
const source = join(dirname(require.resolve('msw/package.json')), 'lib', 'mockServiceWorker.js');
if (!existsSync(source)) {
  throw new Error('msw service worker not found: run pnpm install');
}
mkdirSync(join(root, 'public'), { recursive: true });
// The worker unregisters itself when its last page closes, which a full navigation in a single
// tab does: the next page then loads without a controller and its requests leave the mocks (they
// reached a foreign server on port 3000). Kept registered instead; the integrity checksum is a
// constant of the file, unchanged.
const UNREGISTER = 'self.registration.unregister()';
const worker = readFileSync(source, 'utf8');
if (!worker.includes(UNREGISTER)) {
  throw new Error('msw service worker changed: review the patch of sync-mock-worker.mjs');
}
writeFileSync(
  join(root, 'public', 'mockServiceWorker.js'),
  worker.replace(UNREGISTER, 'void 0 /* kept registered: see scripts/sync-mock-worker.mjs */'),
);
