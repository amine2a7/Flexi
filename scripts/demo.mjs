// Single demo command (request of 2026-11-05), local only:
//   pnpm demo        empties the local database, applies the migrations, loads the demo seed,
//                    starts the API then the web (webpack) and prints the URL and the accounts;
//   pnpm demo:reset  loads the demo data again (empty database + seed), servers left running.
//   pnpm demo:rapide same, but the web is an optimised local build (`next build` then
//                    `next start`): every page is ready at once, no compile on first visit.
//   node scripts/demo.mjs --api-only  starts one more API on the current data (no reset, no
//                    web), for a production web on DEMO_WEB_PORT (e2e pass on a build).
// Refuses any database that is not on this machine, and never runs in production.
import { spawn } from 'node:child_process';
import { existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const envFile = join(root, 'infra', '.env');
if (existsSync(envFile)) process.loadEnvFile(envFile);

const API_PORT = process.env.DEMO_API_PORT ?? '3198';
const WEB_PORT = process.env.DEMO_WEB_PORT ?? '3101';
const WEB_URL = `http://localhost:${WEB_PORT}`;
const API_URL = `http://localhost:${API_PORT}`;
const MFA = '123456';
const resetOnly = process.argv.includes('--reset');
const apiOnly = process.argv.includes('--api-only');
const production = process.argv.includes('--build');
// The optimised build has its own folder: a development server may keep `.next`.
const webBuildEnv = {
  ...process.env,
  NEXT_PUBLIC_API_BASE_URL: API_URL,
  // DEMO_DIST_DIR: another folder while a previous demo still holds .next-demo (Windows).
  NEXT_DIST_DIR: process.env.DEMO_DIST_DIR ?? '.next-demo',
  NEXT_TELEMETRY_DISABLED: '1',
  // A local build: the only case where a production build may call an HTTP API (loopback).
  NEXT_PUBLIC_LOCAL_BUILD: '1',
};

function refuse(message) {
  console.error(`pnpm demo: ${message}`);
  process.exit(1);
}
if (process.env.NODE_ENV === 'production') refuse('never in production.');
let host;
try {
  host = new URL(process.env.PG_ADMIN_URL ?? '').hostname;
} catch {
  refuse('PG_ADMIN_URL is missing: run `pnpm --filter @flexipay/api env:init` first.');
}
if (!['localhost', '127.0.0.1', '::1', '[::1]'].includes(host)) {
  refuse(`the database is not local (${host}): refused.`);
}

const shell = process.platform === 'win32';
const demoEnv = {
  ...process.env,
  NODE_ENV: 'development',
  DEMO_FIXED_MFA_CODE: MFA,
  API_PORT,
  WEB_ORIGINS: WEB_URL,
};

function run(args, env = demoEnv) {
  return new Promise((resolve, reject) => {
    const child = spawn('pnpm', args, { cwd: root, env, stdio: 'inherit', shell });
    child.on('exit', (code) => {
      if (code === 0) resolve();
      else reject(new Error(`pnpm ${args.join(' ')} failed (${String(code)})`));
    });
  });
}

async function waitFor(url, label) {
  for (let attempt = 0; attempt < 120; attempt += 1) {
    try {
      const response = await fetch(url);
      if (response.status < 500) return;
    } catch {
      // not listening yet
    }
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }
  throw new Error(`${label} did not start (${url})`);
}

const ACCOUNTS = [
  ['Super-admin', 'admin@flexipay.test'],
  ['Opérations', 'operations@flexipay.test'],
  ['Finance', 'admin2@flexipay.test'],
  ['Finance (scénario) Sarra', 'sarra@flexipay.tn'],
  ['Finance (seconde validation) Nour', 'nour@flexipay.tn'],
  ['Gérant Le Jasmin (Karim)', 'karim@lejasmin.tn'],
  ['Support', 'support@flexipay.test'],
  ['Administrateur entreprise', 'entreprise@flexipay.test'],
  ['RH', 'rh@flexipay.test'],
  ['Comptable', 'comptable@flexipay.test'],
  ['Gérant', 'commercant@flexipay.test'],
  ['Caissier', 'caissier@flexipay.test'],
  ['Bénéficiaire', 'beneficiaire@flexipay.test'],
  ['Première connexion', 'premiere@flexipay.test'],
];

function printAccess() {
  console.log(`\nFlexiPay démo : ${WEB_URL}/fr   (API ${API_URL})`);
  console.log(`Mot de passe Test1234! · code MFA ${MFA} · PIN démo 1234`);
  for (const [role, email] of ACCOUNTS) console.log(`  ${role.padEnd(27)} ${email}`);
  console.log('Cas et où les trouver : docs/demo/donnees-demo.md\n');
}

if (!apiOnly) {
  await run(['--filter', '@flexipay/api', 'db:reset']);
  await run(['--filter', '@flexipay/api', 'db:seed']);
}
if (resetOnly) {
  console.log('Demo data loaded again.');
  printAccess();
  process.exit(0);
}
if (production) {
  await run(['--filter', '@flexipay/web', 'exec', 'next', 'build'], webBuildEnv);
}

const children = [
  spawn('pnpm', ['--filter', '@flexipay/api', 'dev'], {
    cwd: root,
    env: demoEnv,
    stdio: 'inherit',
    shell,
  }),
];
await waitFor(`${API_URL}/health`, 'API');
if (apiOnly) {
  console.log(`API seule : ${API_URL} (origine autorisée ${WEB_URL})`);
} else {
  children.push(
    production
      ? spawn('pnpm', ['--filter', '@flexipay/web', 'exec', 'next', 'start', '-p', WEB_PORT], {
          cwd: root,
          env: webBuildEnv,
          stdio: 'inherit',
          shell,
        })
      : spawn('pnpm', ['--filter', '@flexipay/web', 'dev'], {
          cwd: root,
          env: { ...process.env, WEB_PORT, NEXT_PUBLIC_API_BASE_URL: API_URL },
          stdio: 'inherit',
          shell,
        }),
  );
  await waitFor(`${WEB_URL}/fr`, 'web');
  printAccess();
}

const stop = () => {
  for (const child of children) child.kill();
  process.exit(0);
};
process.on('SIGINT', stop);
process.on('SIGTERM', stop);
for (const child of children) child.on('exit', stop);
