#!/usr/bin/env node
// PreToolUse (Bash), appelé par guard-bash.sh. Code 2 = blocage, message sur stderr.
// 1. Commits et pushs (S1-01, S1-02, S1-09) : le scan gitleaks est fait par les hooks git natifs
//    .githooks/pre-commit (après l'indexation) et .githooks/pre-push (chaque commit poussé, y compris
//    stash, cherry-pick, am, rebase). Ici on refuse seulement ce qui les contourne : --no-verify / -n,
//    toute modification de core.hooksPath, de .githooks/ ou de .git/config hors git, les variables
//    GIT_CONFIG_* / GIT_DIR / GIT_INDEX_FILE, les alias, les sous-commandes git non littérales,
//    commit-tree ; et on vérifie avant chaque commit ou push que les hooks natifs sont actifs et intacts.
//    L'analyse se limite au segment « git … commit » : un message de commit n'est jamais lu comme option.
//    Les corps de heredoc sont des données, sauf s'ils alimentent un interpréteur ou psql (S1-10).
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

const SHELLS = ['bash', 'sh', 'zsh', 'dash'];
const commandName = (words) => (words.find((w) => !isEnvAssign(w)) || '').replace(/^.*[\\/]/, '');
// Variables d'environnement qui changent la configuration, le dépôt ou l'index vus par git (S1-09).
const GIT_ENV = /^(GIT_CONFIG(_[A-Z0-9_]*)?|GIT_DIR|GIT_INDEX_FILE|GIT_WORK_TREE|GIT_OBJECT_DIRECTORY|GIT_ALTERNATE_OBJECT_DIRECTORIES|GIT_EXEC_PATH)(=|$)/i;
// Mots qui désignent un chemin vers les hooks natifs ou la configuration du dépôt (pas du texte libre).
const HOOK_PATH = /^[<>]*(\.[\\/])?\.githooks([\\/]|$)|^[^\s]*[\\/]\.githooks([\\/]|$)/i;
const GIT_INTERNAL_PATH = /^[<>]*(\.[\\/])?\.git[\\/](config|hooks)|^[^\s]*[\\/]\.git[\\/](config|hooks)/i;
// --no-verify et ses abréviations acceptées par git (jusqu'à --no-v).
const isNoVerify = (w) => {
  const name = w.split('=')[0];
  return name.length >= '--no-v'.length && '--no-verify'.startsWith(name);
};

// Renvoie { sub, subIndex, globals, viaXargs } pour un segment qui lance git, sinon null.
function parseGit(words) {
  let k = 0;
  let viaXargs = false;
  while (k < words.length && (isEnvAssign(words[k]) || ['env', 'command', 'exec', 'nohup', 'time', 'sudo', 'xargs'].includes(words[k]))) {
    if (words[k] === 'xargs') viaXargs = true;
    k++;
  }
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
  return { sub: words[j] ?? '', subIndex: j, globals, viaXargs };
}

// Cherche --no-verify (et ses abréviations) ou -n dans les options de git commit.
function commitBypass(args) {
  for (let j = 0; j < args.length; j++) {
    const w = args[j];
    if (w === '--') return null;
    if (w.startsWith('--')) {
      if (isNoVerify(w)) return w;
      if (COMMIT_LONG_WITH_ARG.has(w) && !w.includes('=')) j++;
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
  for (const name of ['pre-commit', 'pre-push']) {
    if (!fs.existsSync(path.join(root, '.githooks', name))) {
      block(`.githooks/${name} est absent : commit ou push refusé sans scan de secrets (échec fermé).`);
    }
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
// Un heredoc qui alimente un interpréteur s'exécute (S1-10) : son corps est alors analysé comme commandes.
const shellFed = segments.some((s) => SHELLS.includes(commandName(s)));
const psqlFed = /\bpsql\b/i.test(cmd);
let gitWrites = false;
const sqlText = [];

for (const words of segments) {
  const joined = words.join(' ');
  const first = commandName(words);
  const readOnly = READ_ONLY.has(first) && !/>/.test(joined);

  // Contenus exécutés ailleurs : bash -c "…", eval …, corps de heredoc lu par un interpréteur ou psql.
  if (SHELLS.includes(first)) {
    const c = words.indexOf('-c');
    if (c !== -1 && words[c + 1]) segments.push(...splitCommand(words[c + 1]));
  }
  if (first === 'eval') segments.push(...splitCommand(words.slice(words.indexOf('eval') + 1).join(' ')));
  if (words.heredoc !== undefined) {
    if (shellFed) segments.push(...splitCommand(words.heredoc));
    if (psqlFed) sqlText.push(words.heredoc);
  }

  const git = parseGit(words);
  // Pour un commit, seuls les mots avant la sous-commande sont examinés (jamais le message).
  const examined = git && git.sub === 'commit' ? words.slice(0, git.subIndex) : words;

  if (examined.some((w) => GIT_ENV.test(w) || GIT_ENV.test(w.replace(/^export\s+/i, '')))) {
    block('les variables GIT_CONFIG_*, GIT_DIR, GIT_INDEX_FILE et GIT_WORK_TREE sont interdites (contournement possible du hook natif, S1-09).');
  }
  if (/[$`]/.test(first) && /\b(commit|push|config)\b/i.test(joined)) {
    block('commande git construite dynamiquement interdite (S1-09) : écris la commande en clair.');
  }

  if (!git) {
    if (!readOnly && words.some((w) => HOOK_PATH.test(w))) {
      block('.githooks/ ne se modifie pas en ligne de commande (S1-01) : demande à main.');
    }
    if (!readOnly && words.some((w) => GIT_INTERNAL_PATH.test(w))) {
      block('.git/config et .git/hooks ne se modifient pas en dehors de git (S1-09).');
    }
    sqlText.push(joined);
    continue;
  }

  if (/[$`]/.test(git.sub) || (git.viaXargs && !git.sub)) {
    block('sous-commande git non littérale interdite (S1-09) : écris la commande en clair.');
  }
  if (examined.some((w) => /hooks\s*path/i.test(w))) {
    const args = git.sub === 'config' ? words.slice(git.subIndex + 1).filter((w) => w !== '--local') : [];
    const readGet = args.length === 2 && args[0] === '--get' && /^core\.hookspath$/i.test(args[1]);
    const enable = args.length === 2 && /^core\.hookspath$/i.test(args[0]) && args[1] === '.githooks';
    if (!readGet && !enable) block('toute modification de core.hooksPath est interdite (S1-01). Le hook git natif doit rester actif.');
  }
  if (git.globals.some((g, idx) => g === '-c' && /^alias\./i.test(git.globals[idx + 1] || '')) || git.globals.some((g) => /^-calias\./i.test(g)) || git.globals.includes('--config-env')) {
    block('alias ou configuration git définis à la volée interdits (contournement possible du hook natif).');
  }
  if (git.sub === 'config') {
    const args = words.slice(git.subIndex + 1);
    if (args.some((w) => /^--(remove-section|rename-section|edit)$|^-e$/.test(w))) {
      block('édition globale de la configuration git interdite (risque de retirer core.hooksPath).');
    }
    const reads = args.some((w) => /^(--get|--get-all|--get-regexp|--list|-l)$/.test(w));
    if (!reads && args.some((w) => /^alias\./i.test(w))) {
      block('création ou modification d\'alias git interdite (contournement possible du hook natif, S1-09).');
    }
  }
  if (git.sub === 'commit-tree') {
    block('git commit-tree crée un commit sans hook (contournement du scan de secrets).');
  }
  if (git.sub === 'commit') {
    gitWrites = true;
    const bad = commitBypass(words.slice(git.subIndex + 1));
    if (bad) block(`« ${bad} » sur git commit désactive le scan de secrets (hook natif). Commite sans cette option.`);
    continue; // le message de commit n'est pas analysé par le contrôle SQL
  }
  if (git.sub === 'push') {
    gitWrites = true;
    const bad = words.slice(git.subIndex + 1).find(isNoVerify);
    if (bad) block(`« ${bad} » sur git push désactive le scan de secrets (hook natif pre-push). Pousse sans cette option.`);
  }
  sqlText.push(joined);
}

if (gitWrites) checkNativeHook();

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
