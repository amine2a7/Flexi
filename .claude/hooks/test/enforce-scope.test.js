// Tests du hook enforce-scope : le hook est exécuté comme fichier (README §14), entrée JSON sur stdin.
// Lancer : node --test .claude/hooks/test/enforce-scope.test.js
const { test } = require('node:test');
const assert = require('node:assert');
const { spawnSync } = require('node:child_process');
const path = require('node:path');

const root = path.resolve(__dirname, '..', '..', '..');
const hook = path.join(root, '.claude', 'hooks', 'enforce-scope.js');

function run(input) {
  const res = spawnSync(process.execPath, [hook], {
    input: typeof input === 'string' ? input : JSON.stringify(input),
    env: { ...process.env, CLAUDE_PROJECT_DIR: root },
    encoding: 'utf8',
  });
  return res.status;
}
const write = (agent, file) => run({ agent_id: 'a1', agent_type: agent, tool_input: { file_path: file } });

const REVIEWERS = {
  ux: ['docs/handoff/reviews/ux-connexion-2026-10-11.md', 'docs/handoff/reviews/ux-captures/connexion-fr-360.png'],
  qualite: ['docs/handoff/reviews/qualite-f1-2026-10-11.md'],
  conformite: ['docs/handoff/reviews/conformite-f1-2026-10-11.md', 'docs/handoff/reviews/tracabilite.md'],
};

// Chemins qu'aucun relecteur ne doit pouvoir écrire.
const FORBIDDEN = [
  'apps/web/src/app/page.tsx',
  'apps/api/src/main.ts',
  'packages/shared/src/money.ts',
  'packages/ui-tokens/src/dart.ts',
  'docs/design/specs/connexion.md',
  'docs/handoff/contracts/openapi.yaml',
  'docs/security/modele-de-menaces.md',
  'docs/cahier-des-charges.md',
  'docs/handoff/reviews/securite-p0-s1.md',
  'docs/handoff/reviews/design-f2.md',
  'docs/handoff/BOARD.md',
  'docs/handoff/decisions.md',
  'CLAUDE.md',
  '.claude/agents/ux.md',
  '../hors-projet.md',
];

for (const [agent, allowed] of Object.entries(REVIEWERS)) {
  for (const file of allowed) {
    test(`${agent} peut écrire ${file}`, () => assert.strictEqual(write(agent, file), 0));
  }
  for (const file of FORBIDDEN) {
    test(`${agent} ne peut pas écrire ${file}`, () => assert.strictEqual(write(agent, file), 2));
  }
}

test('les relecteurs ne peuvent pas écrire les revues des autres relecteurs', () => {
  assert.strictEqual(write('ux', REVIEWERS.qualite[0]), 2);
  assert.strictEqual(write('qualite', REVIEWERS.conformite[0]), 2);
  assert.strictEqual(write('conformite', REVIEWERS.ux[0]), 2);
  assert.strictEqual(write('ux', 'docs/handoff/reviews/tracabilite.md'), 2);
});

test('casse et antislashs Windows ne contournent pas le périmètre', () => {
  assert.strictEqual(write('ux', 'APPS\\web\\page.tsx'), 2);
  assert.strictEqual(write('qualite', 'docs\\handoff\\reviews\\QUALITE-x.md'), 0);
});

test('non-régression : périmètres existants', () => {
  assert.strictEqual(write('securite', 'docs/security/x.md'), 0);
  assert.strictEqual(write('securite', 'apps/api/x.ts'), 2);
  assert.strictEqual(write('design', 'docs/design/specs/x.md'), 0);
  assert.strictEqual(write('frontend', 'apps/web/x.tsx'), 0);
  assert.strictEqual(write('frontend', 'docs/handoff/reviews/qualite-x.md'), 2);
  assert.strictEqual(write('backend', 'docs/handoff/reviews/conformite-x.md'), 2);
});

test('échec fermé : entrée illisible, sous-agent sans type', () => {
  assert.strictEqual(run('pas du json'), 2);
  assert.strictEqual(run('null'), 2);
  assert.strictEqual(run({ agent_id: 'a1', tool_input: { file_path: 'docs/x.md' } }), 2);
});

test('session principale (sans agent_id) non concernée', () => {
  assert.strictEqual(run({ tool_input: { file_path: 'docs/handoff/BOARD.md' } }), 0);
});
