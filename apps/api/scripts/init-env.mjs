// Creates infra/.env for the local API (run by the developer, never by an agent):
//   pnpm --filter @flexipay/api env:init
// - copies infra/.env.example when infra/.env does not exist yet;
// - adds the API variables that are missing, with random secrets;
// - asks once for the password of the PostgreSQL superuser (hidden input), never printed.
// infra/.env is ignored by Git. Existing values are never changed.
import { randomBytes } from 'node:crypto';
import { appendFileSync, copyFileSync, existsSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { createInterface } from 'node:readline';
import { fileURLToPath } from 'node:url';

const INFRA = join(dirname(fileURLToPath(import.meta.url)), '..', '..', '..', 'infra');
const TARGET = join(INFRA, '.env');
const EXAMPLE = join(INFRA, '.env.example');

function askHidden(question) {
  return new Promise((resolve) => {
    const rl = createInterface({ input: process.stdin, output: process.stdout, terminal: true });
    rl.stdoutMuted = true;
    rl._writeToOutput = (text) => {
      if (!rl.stdoutMuted || text.includes(question)) rl.output.write(text);
    };
    rl.question(question, (answer) => {
      rl.close();
      process.stdout.write('\n');
      resolve(answer);
    });
  });
}

function ask(question, fallback) {
  return new Promise((resolve) => {
    const rl = createInterface({ input: process.stdin, output: process.stdout });
    rl.question(`${question} [${fallback}] `, (answer) => {
      rl.close();
      resolve(answer.trim() === '' ? fallback : answer.trim());
    });
  });
}

const secret = (bytes = 32) => randomBytes(bytes).toString('base64');
const password = () => randomBytes(24).toString('base64url');

if (!existsSync(TARGET)) {
  if (existsSync(EXAMPLE)) copyFileSync(EXAMPLE, TARGET);
  else appendFileSync(TARGET, '');
  console.log('infra/.env created from infra/.env.example');
}
const present = new Set(
  readFileSync(TARGET, 'utf8')
    .split(/\r?\n/)
    .map((line) => /^\s*([A-Z0-9_]+)\s*=/.exec(line)?.[1])
    .filter(Boolean),
);

const lines = [];
if (!present.has('PG_ADMIN_URL')) {
  const host = await ask('PostgreSQL host', 'localhost');
  const port = await ask('PostgreSQL port', '5432');
  const user = await ask('PostgreSQL superuser', 'postgres');
  const pass = await askHidden(`Password of ${user} (hidden): `);
  const url = new URL('postgresql://localhost/postgres');
  url.hostname = host;
  url.port = port;
  url.username = user;
  url.password = encodeURIComponent(pass);
  lines.push(`PG_ADMIN_URL=${url.toString()}`);
}
const defaults = {
  DB_NAME: 'flexipay',
  APP_DB_PASSWORD: password(),
  API_PORT: '3000',
  WEB_ORIGINS: 'http://localhost:3001',
  SESSION_SECRET: secret(),
  DATA_ENCRYPTION_KEY: secret(),
  UPLOAD_DIR: 'var/uploads',
  // Development only (refused in production): the demo accounts accept this MFA code.
  DEMO_FIXED_MFA_CODE: '123456',
};
for (const [name, value] of Object.entries(defaults)) {
  if (!present.has(name)) lines.push(`${name}=${value}`);
}
if (lines.length > 0) {
  appendFileSync(TARGET, `\n# --- FlexiPay API (local development) ---\n${lines.join('\n')}\n`);
}
console.log(
  lines.length === 0
    ? 'infra/.env already complete: nothing changed.'
    : `Added to infra/.env: ${lines.map((line) => line.split('=')[0]).join(', ')}`,
);
console.log('Next: pnpm --filter @flexipay/api db:setup');
