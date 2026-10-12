// Dev only: copies the MSW service worker into public/ (git-ignored, never committed).
// `pnpm build` removes it (scripts/remove-mock-worker.mjs) so it can never ship to production.
import { copyFileSync, existsSync, mkdirSync } from 'node:fs';
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
copyFileSync(source, join(root, 'public', 'mockServiceWorker.js'));
