#!/usr/bin/env node
// TaskCompleted : refuse la complétion d'une tâche si lint, typecheck ou tests du périmètre échouent.
// Code de sortie 2 = la tâche reste ouverte, le message stderr est renvoyé à l'agent.
// - Périmètre = teammate_name (repli agent_type) ; inconnu → tous les périmètres.
// - Un périmètre pas encore initialisé (pas de package.json / pubspec.yaml) est ignoré.
// - Sujet commençant par « TEST-FIRST: » : les tests peuvent échouer (tests écrits avant le code),
//   lint et typecheck restent obligatoires.
const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');
const readStdinJson = require('./lib/read-stdin-json');
const { AGENTS } = require('./lib/scopes');

const input = readStdinJson();
const root = process.env.CLAUDE_PROJECT_DIR || input.cwd || process.cwd();
const agent = input.teammate_name || input.agent_type;
const subject = String(input.task_subject || '');
const testFirst = /^\s*TEST-FIRST:/i.test(subject);

const defs = AGENTS[agent] ? [AGENTS[agent]] : Object.values(AGENTS);
const seen = new Set();
const checks = defs
  .flatMap((d) => d.checks)
  .filter((c) => {
    const key = `${c.kind}:${c.dir || c.file}`;
    return seen.has(key) ? false : seen.add(key);
  });

// Commandes fixes : aucune donnée de l'entrée du hook n'est interpolée dans le shell.
function run(cmd, args, cwd) {
  const res = spawnSync(cmd, args, { cwd, encoding: 'utf8', shell: process.platform === 'win32' });
  const output = `${res.stdout || ''}${res.stderr || ''}${res.error ? String(res.error) : ''}`;
  return { ok: res.status === 0 && !res.error, output, missing: res.error?.code === 'ENOENT' };
}

function hasScript(dir, name) {
  try {
    const pkg = JSON.parse(fs.readFileSync(path.join(dir, 'package.json'), 'utf8'));
    return Boolean(pkg.scripts && pkg.scripts[name]);
  } catch {
    return false;
  }
}

const failures = [];
const ran = [];

for (const c of checks) {
  if (c.kind === 'json') {
    const file = path.join(root, c.file);
    if (!fs.existsSync(file)) continue;
    try {
      JSON.parse(fs.readFileSync(file, 'utf8'));
      ran.push(`JSON valide : ${c.file}`);
    } catch (e) {
      failures.push({ label: `JSON invalide : ${c.file}`, output: String(e.message) });
    }
    continue;
  }

  const dir = path.join(root, c.dir);
  if (c.kind === 'pnpm') {
    if (!fs.existsSync(path.join(dir, 'package.json'))) continue;
    const scripts = testFirst ? ['lint', 'typecheck'] : ['lint', 'typecheck', 'test'];
    for (const s of scripts) {
      if (!hasScript(dir, s)) continue;
      const r = run('pnpm', ['run', s], dir);
      ran.push(`pnpm run ${s} (${c.dir}) : ${r.ok ? 'OK' : 'ÉCHEC'}`);
      if (!r.ok) failures.push({ label: `pnpm run ${s} dans ${c.dir}`, output: r.output });
    }
  }

  if (c.kind === 'flutter') {
    if (!fs.existsSync(path.join(dir, 'pubspec.yaml'))) continue;
    const steps = testFirst ? [['analyze']] : [['analyze'], ['test']];
    for (const args of steps) {
      const r = run('flutter', args, dir);
      const label = `flutter ${args.join(' ')} dans ${c.dir}`;
      ran.push(`${label} : ${r.ok ? 'OK' : 'ÉCHEC'}`);
      if (!r.ok) {
        failures.push({
          label,
          output: r.missing ? 'flutter introuvable : installer le SDK Flutter (échec fermé par défaut).' : r.output,
        });
      }
    }
  }
}

if (failures.length === 0) process.exit(0);

const tail = (s) => s.trimEnd().split(/\r?\n/).slice(-60).join('\n');
process.stderr.write(
  `Tâche « ${subject} » refusée : vérifications du périmètre en échec.\n` +
    failures.map((f) => `\n--- ${f.label}\n${tail(f.output)}`).join('\n') +
    `\n\nCorrige puis termine à nouveau la tâche. Si le blocage ne relève pas de ton périmètre, envoie [BLOQUÉ] à team-lead.\n` +
    (testFirst ? '' : `Tâche de tests écrits avant le code : préfixer le sujet par « TEST-FIRST: ».\n`),
);
process.exit(2);
