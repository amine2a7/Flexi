#!/usr/bin/env node
// PreToolUse (Bash), appelé par guard-bash.sh. Code 2 = blocage, message sur stderr.
// 1. Commits (S1-01, S1-02) : le scan gitleaks est fait par le hook git natif .githooks/pre-commit,
//    APRÈS l'indexation. Ici on refuse seulement ce qui le contourne : --no-verify / -n sur commit,
//    toute modification de core.hooksPath ou de .githooks/, commit-tree, alias définis à la volée ;
//    et on vérifie avant chaque commit que le hook natif est actif et intact (échec fermé).
//    L'analyse se limite au segment « git … commit » : un message de commit n'est jamais lu comme option.
// 2. Aide (CF-09) : commandes SQL destructrices sur le ledger et l'audit, hors messages de commit.
//    La vraie barrière reste les triggers et les rôles PostgreSQL (SEC-P4, DC-5).
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const { splitCommand } = require('./lib/shell-split');

process.on('uncaughtException', () => {
  process.stderr.write("Bloqué : erreur interne du hook guard-bash (échec fermé). Signale-le à main.\n");
  process.exit(2);
});

let input;
try {
  input = JSON.parse(fs.readFileSync(0, 'utf8'));
} catch {
  input = undefined;
}
if (input === null || typeof input !== 'object' || Array.isArray(input)) {
  process.stderr.write("Bloqué : entrée du hook guard-bash illisible (échec fermé). Signale-le à main.\n");
  process.exit(2);
}
const cmd = typeof input.tool_input?.command === 'string' ? input.tool_input.command : '';
if (!cmd.trim()) process.exit(0);

const root = process.env.CLAUDE_PROJECT_DIR || input.cwd || process.cwd();

function block(msg) {
  process.stderr.write(`Bloqué : ${msg}\n`);
  process.exit(2);
}

// Options globales de git qui prennent un argument séparé.
const GIT_GLOBAL_WITH_ARG = new Set(['-C', '-c', '--git-dir', '--work-tree', '--namespace', '--super-prefix', '--config-env', '--exec-path']);
// Options de git commit qui prennent un argument séparé (leur argument n'est pas analysé).
const COMMIT_LONG_WITH_ARG = new Set([
  '--message', '--file', '--author', '--date', '--fixup', '--squash', '--template',
  '--reuse-message', '--reedit-message', '--cleanup', '--trailer', '--pathspec-from-file',
]);
const COMMIT_SHORT_WITH_ARG = 'mFCct';
const READ_ONLY = new Set(['grep', 'rg', 'cat', 'head', 'tail', 'less', 'wc', 'ls', 'diff']);

const isGit = (w) => /^(.*[\\/])?git(\.exe)?$/i.test(w);
const isEnvAssign = (w) => /^[A-Za-z_][A-Za-z0-9_]*=/.test(w);

// Renvoie { sub, subIndex, globals } pour un segment qui lance git, sinon null.
function parseGit(words) {
  let k = 0;
  while (k < words.length && (isEnvAssign(words[k]) || ['env', 'command', 'exec', 'nohup', 'time'].includes(words[k]))) k++;
  if (k >= words.length || !isGit(words[k])) return null;
  const globals = [];
  let j = k + 1;
  while (j < words.length && words[j].startsWith('-')) {
    const w = words[j];
    if (GIT_GLOBAL_WITH_ARG.has(w)) {
      globals.push(w, words[j + 1] ?? '');
      j += 2;
    } else {
      globals.push(w);
      j++;
    }
  }
  return { sub: words[j] ?? '', subIndex: j, globals };
}

// Cherche --no-verify (et ses abréviations) ou -n dans les options de git commit.
function commitBypass(args) {
  for (let j = 0; j < args.length; j++) {
    const w = args[j];
    if (w === '--') return null;
    if (w.startsWith('--')) {
      const name = w.split('=')[0];
      if (name.length >= '--no-v'.length && '--no-verify'.startsWith(name)) return w;
      if (COMMIT_LONG_WITH_ARG.has(name) && !w.includes('=')) j++;
      continue;
    }
    if (/^-[A-Za-z]+/.test(w)) {
      for (let p = 1; p < w.length; p++) {
        const ch = w[p];
        if (ch === 'n') return w;
        if (COMMIT_SHORT_WITH_ARG.includes(ch)) {
          if (p === w.length - 1) j++;
          break;
        }
      }
    }
  }
  return null;
}

function checkNativeHook() {
  let hooksPath = '';
  try {
    hooksPath = execFileSync('git', ['-C', root, 'config', '--get', 'core.hooksPath'], { encoding: 'utf8' }).trim();
  } catch {
    hooksPath = '';
  }
  if (hooksPath !== '.githooks') {
    block("le hook git natif n'est pas actif (core.hooksPath doit valoir .githooks). Lance « git config --local core.hooksPath .githooks » (README §14) ou demande à main.");
  }
  if (!fs.existsSync(path.join(root, '.githooks', 'pre-commit'))) {
    block('.githooks/pre-commit est absent : commit refusé sans scan de secrets (échec fermé).');
  }
  // Intégrité : une fois commité, le hook natif ne change plus sans l'utilisateur (commit fait par lui).
  let committed = true;
  try {
    execFileSync('git', ['-C', root, 'cat-file', '-e', 'HEAD:.githooks/pre-commit'], { stdio: 'ignore' });
  } catch {
    committed = false;
  }
  if (committed) {
    try {
      execFileSync('git', ['-C', root, 'diff', '--quiet', 'HEAD', '--', '.githooks/'], { stdio: 'ignore' });
    } catch {
      block(".githooks/ diffère du dernier commit : commit refusé. Restaure-le (git checkout HEAD -- .githooks/) ; une modification du hook natif est commitée par l'utilisateur.");
    }
  }
}

const segments = splitCommand(cmd);
let commits = false;
const sqlText = [];

for (const words of segments) {
  const joined = words.join(' ');
  const first = (words.find((w) => !isEnvAssign(w)) || '').replace(/^.*[\\/]/, '');
  const readOnly = READ_ONLY.has(first) && !/>/.test(joined);

  // Interpréteurs avec -c : le contenu de la chaîne s'exécute aussi.
  if (['bash', 'sh', 'zsh', 'dash'].includes(first)) {
    const c = words.indexOf('-c');
    if (c !== -1 && words[c + 1]) segments.push(...splitCommand(words[c + 1]));
  }

  const git = parseGit(words);
  // Pour un commit, seules les options globales de git sont examinées (jamais le message).
  const scanned = git && git.sub === 'commit' ? words.slice(0, git.subIndex).join(' ') : joined;
  if (/hooks\s*path/i.test(scanned) && !readOnly) {
    const args = git && git.sub === 'config' ? words.slice(git.subIndex + 1).filter((w) => w !== '--local') : [];
    const readGet = args.length === 2 && args[0] === '--get' && /^core\.hookspath$/i.test(args[1]);
    const enable = args.length === 2 && /^core\.hookspath$/i.test(args[0]) && args[1] === '.githooks';
    if (!readGet && !enable) block("toute modification de core.hooksPath est interdite (S1-01). Le hook git natif doit rester actif.");
  }
  if (/\.githooks/i.test(scanned) && !readOnly && !git) {
    block('.githooks/ ne se modifie pas en ligne de commande (S1-01) : demande à main.');
  }

  if (!git) {
    sqlText.push(joined);
    continue;
  }
  if (git.globals.some((g, idx) => g === '-c' && /^alias\./i.test(git.globals[idx + 1] || '')) || git.globals.some((g) => /^-calias\./i.test(g)) || git.globals.includes('--config-env')) {
    block('alias ou configuration git définis à la volée interdits (contournement possible du hook natif).');
  }
  if (git.sub === 'config' && words.slice(git.subIndex + 1).some((w) => /^--(remove-section|rename-section|edit)$|^-e$/.test(w))) {
    block('édition globale de la configuration git interdite (risque de retirer core.hooksPath).');
  }
  if (git.sub === 'commit-tree') {
    block('git commit-tree crée un commit sans hook (contournement du scan de secrets).');
  }
  if (git.sub === 'commit') {
    commits = true;
    const bad = commitBypass(words.slice(git.subIndex + 1));
    if (bad) block(`« ${bad} » sur git commit désactive le scan de secrets (hook natif). Commite sans cette option.`);
    continue; // le message de commit n'est pas analysé par le contrôle SQL
  }
  sqlText.push(joined);
}

if (commits) checkNativeHook();

// Aide uniquement (CF-09) : la vraie barrière reste les triggers et les rôles PostgreSQL (SEC-P4).
const q = '\\\\?"?';
const ledgerRe = new RegExp(
  `(update|delete\\s+from|truncate(\\s+table)?|drop\\s+table(\\s+if\\s+exists)?|alter\\s+table(\\s+if\\s+exists)?)(\\s+only)?\\s+(${q}public${q}\\.)?${q}(ledger_entries|transactions|audit_log)\\b`,
  'i',
);
if (sqlText.some((t) => ledgerRe.test(t))) {
  block("le ledger et le journal d'audit sont immuables (contre-passation uniquement).");
}
process.exit(0);
