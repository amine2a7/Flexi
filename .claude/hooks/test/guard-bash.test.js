// Tests du hook guard-bash (S1-01, S1-02, CF-09) : exécuté comme fichier, entrée JSON sur stdin,
// dans des dépôts jetables (dossier temporaire) pour contrôler core.hooksPath.
// Lancer : node --test .claude/hooks/test/guard-bash.test.js
const { test, before } = require('node:test');
const assert = require('node:assert');
const { spawnSync, execFileSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const projectRoot = path.resolve(__dirname, '..', '..', '..');
const hook = path.join(projectRoot, '.claude', 'hooks', 'guard-bash.js');

let okRepo; // core.hooksPath = .githooks, pre-commit commité
let noHookRepo; // core.hooksPath absent
let tamperedRepo; // pre-commit modifié après le commit
let introRepo; // pre-commit pas encore commité (commit qui l'introduit)

function makeRepo(name, { setHooksPath, tamper, intro }) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), `guard-${name}-`));
  const git = (...args) => execFileSync('git', ['-C', dir, ...args], { stdio: 'ignore' });
  git('init', '-q');
  git('config', 'user.email', 't@example.invalid');
  git('config', 'user.name', 't');
  fs.mkdirSync(path.join(dir, '.githooks'));
  fs.copyFileSync(path.join(projectRoot, '.githooks', 'pre-commit'), path.join(dir, '.githooks', 'pre-commit'));
  git('commit', '-q', '--allow-empty', '-m', 'init');
  git('add', '.githooks/pre-commit');
  if (!intro) git('-c', 'core.hooksPath=/dev/null', 'commit', '-q', '-m', 'hook');
  if (setHooksPath) git('config', '--local', 'core.hooksPath', '.githooks');
  if (tamper) fs.writeFileSync(path.join(dir, '.githooks', 'pre-commit'), '#!/bin/sh\nexit 0\n');
  return dir;
}

before(() => {
  okRepo = makeRepo('ok', { setHooksPath: true });
  noHookRepo = makeRepo('nohook', { setHooksPath: false });
  tamperedRepo = makeRepo('tampered', { setHooksPath: true, tamper: true });
  introRepo = makeRepo('intro', { setHooksPath: true, intro: true });
});

function run(command, repo = okRepo) {
  const res = spawnSync(process.execPath, [hook], {
    input: typeof command === 'string' ? JSON.stringify({ tool_input: { command } }) : command.raw,
    env: { ...process.env, CLAUDE_PROJECT_DIR: repo },
    encoding: 'utf8',
  });
  return res.status;
}

const PASS = [
  // Commits normaux et faux positifs de S1-02 (options ou mots-clés dans d'autres commandes ou le message)
  'git commit -m "feat: x"',
  'git add a.txt && git commit -m x',
  'git commit -am x',
  'sed -i s/a/b/ f.txt; git commit -m x',
  'grep -i foo f.txt && git commit -m x',
  'git log -n 3 && git commit -m x',
  'git commit -m "option -n et --no-verify dans le message"',
  "git commit -m 'add -a flag'",
  'git commit -m "fix hooksPath doc"',
  'git commit -F msg.txt',
  'git commit -m "update transactions screen"',
  'git commit --amend --no-edit',
  // Lecture ou activation de core.hooksPath
  'git config --get core.hooksPath',
  'git config --local core.hooksPath .githooks',
  'grep hooksPath docs/handoff/README.md',
  'cat .githooks/pre-commit',
  'git add .githooks/pre-commit',
  // Commandes ordinaires
  'pnpm lint',
  'SELECT * FROM ledger_entries',
  'psql -c "select count(*) from transactions_archive"',
];

const BLOCK = [
  // Désactivation du hook natif
  'git commit -n -m x',
  'git commit -nm x',
  'git commit -anm x',
  'git commit "-n" -m x',
  'git commit --no-verify -m x',
  'git commit --no-verif -m x',
  'git commit --no-v -m x',
  'git -C . commit -n -m x',
  'GIT_DIR=.git git commit -n -m x',
  'bash -c "git commit -n -m x"',
  'echo $(git commit -n -m x)',
  'echo "$(git commit --no-verify -m x)"',
  'echo `git commit -n -m x`',
  // core.hooksPath et .githooks
  'git -c core.hooksPath=/dev/null commit -m x',
  'git -c core.hookspath= commit -m x',
  'GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/tmp git commit -m x',
  'git config --unset core.hooksPath',
  'git config core.hooksPath /tmp/hooks',
  'git config --local --unset-all core.hooksPath',
  'git config --remove-section core',
  'git config --edit',
  'echo "exit 0" > .githooks/pre-commit',
  'rm .githooks/pre-commit',
  'cp /tmp/x .githooks/pre-commit',
  // Alias et plomberie
  'git -c alias.ci="commit -n" ci -m x',
  'git commit-tree HEAD^{tree} -m x',
  // Ledger (aide CF-09)
  'psql -c "DELETE FROM ledger_entries"',
  'UPDATE transactions SET amount = 0',
  'TRUNCATE TABLE audit_log',
];

for (const c of PASS) test(`laisse passer : ${c}`, () => assert.strictEqual(run(c), 0));
for (const c of BLOCK) test(`bloque : ${c}`, () => assert.strictEqual(run(c), 2));

test('commit refusé si core.hooksPath ne vaut pas .githooks (échec fermé)', () => {
  assert.strictEqual(run('git commit -m x', noHookRepo), 2);
  assert.strictEqual(run('pnpm lint', noHookRepo), 0);
});

test('commit refusé si .githooks/ diffère du dernier commit', () => {
  assert.strictEqual(run('git commit -m x', tamperedRepo), 2);
});

test('commit qui introduit le hook natif (absent de HEAD) autorisé', () => {
  assert.strictEqual(run('git commit -m x', introRepo), 0);
});

test('entrée illisible → blocage', () => {
  assert.strictEqual(run({ raw: 'pas du json' }), 2);
  assert.strictEqual(run({ raw: 'null' }), 2);
});
