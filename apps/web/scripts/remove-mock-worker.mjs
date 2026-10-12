// Production build guard: the MSW service worker must never be served by a production build.
// Optional argument: app root (tests); defaults to apps/web.
import { rmSync } from 'node:fs';
import { dirname, join } from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const root = process.argv[2] ?? join(dirname(fileURLToPath(import.meta.url)), '..');
rmSync(join(root, 'public', 'mockServiceWorker.js'), { force: true });
