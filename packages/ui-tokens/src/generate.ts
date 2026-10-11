import { mkdirSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { renderDart } from './dart.js';
import { renderTailwindModule, renderTailwindTypes } from './tailwind.js';
import { loadTokens } from './tokens.js';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const tokens = loadTokens();

const files: [string, string][] = [
  ['generated/tailwind-preset.cjs', renderTailwindModule(tokens)],
  ['generated/tailwind-preset.d.cts', renderTailwindTypes()],
  ['dart/lib/flexipay_tokens.dart', renderDart(tokens)],
];
for (const [rel, content] of files) {
  const target = join(root, rel);
  mkdirSync(dirname(target), { recursive: true });
  writeFileSync(target, content, 'utf8');
  console.log(`wrote ${rel}`);
}
