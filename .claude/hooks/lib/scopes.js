// Source unique des périmètres de l'équipe d'agents (voir docs/handoff/README.md).
// - write  : préfixes de chemins (relatifs à la racine du projet) où l'agent peut écrire.
// - writeIf: fonction optionnelle pour les périmètres définis par motif (test-writer).
// - checks : vérifications lancées par le hook TaskCompleted.
//            { kind: 'pnpm', dir }    → lint, typecheck, test si dir/package.json existe
//            { kind: 'flutter', dir } → flutter analyze, flutter test si dir/pubspec.yaml existe
//            { kind: 'json', file }   → le fichier doit être un JSON valide

// Réservés au lead (team-lead) : aucun coéquipier ne les modifie.
const LEAD_ONLY = [
  'docs/handoff/BOARD.md',
  'docs/handoff/decisions.md',
  'docs/handoff/README.md',
  'docs/handoff/reports/',
  'CLAUDE.md',
  '.claude/',
];

const TEST_FILE = /(^|\/)(test|tests|__tests__|e2e|integration_test)\/|\.(spec|test)\.(ts|tsx|js)$|_test\.dart$/;

const AGENTS = {
  securite: {
    owner: 'securite',
    write: ['docs/security/', 'docs/handoff/'],
    checks: [],
  },
  design: {
    owner: 'design',
    write: ['docs/design/', 'packages/ui-tokens/', 'docs/handoff/reviews/'],
    checks: [
      { kind: 'json', file: 'docs/design/design-tokens.json' },
      { kind: 'pnpm', dir: 'packages/ui-tokens' },
    ],
  },
  backend: {
    owner: 'backend',
    write: [
      'apps/api/',
      'packages/shared/',
      'packages/api-client/',
      'packages/config/',
      'infra/',
      'docker-compose',
      'docs/handoff/contracts/',
      '.github/',
      'package.json',
      'pnpm-workspace.yaml',
      'pnpm-lock.yaml',
      'turbo.json',
      'tsconfig.base.json',
      '.npmrc',
      '.nvmrc',
      '.prettierrc',
      '.prettierignore',
      'eslint.config.mjs',
      '.editorconfig',
    ],
    checks: [
      { kind: 'pnpm', dir: 'apps/api' },
      { kind: 'pnpm', dir: 'packages/shared' },
      { kind: 'pnpm', dir: 'packages/api-client' },
    ],
  },
  frontend: {
    owner: 'frontend',
    write: ['apps/web/'],
    checks: [{ kind: 'pnpm', dir: 'apps/web' }],
  },
  mobile: {
    owner: 'mobile',
    write: ['apps/mobile-employe/', 'apps/mobile-pro/'],
    checks: [
      { kind: 'flutter', dir: 'apps/mobile-employe' },
      { kind: 'flutter', dir: 'apps/mobile-pro' },
    ],
  },
  'test-writer': {
    owner: 'test-writer',
    write: [],
    writeIf: (rel) => /^(apps|packages)\//.test(rel) && TEST_FILE.test(rel),
    checks: [],
  },
  'ledger-auditor': {
    owner: 'ledger-auditor',
    write: [],
    checks: [],
  },
};

// Propriétaire d'un chemin, pour orienter le message de blocage.
function ownerOf(rel) {
  if (LEAD_ONLY.some((p) => rel === p || rel.startsWith(p))) return 'team-lead';
  for (const [name, def] of Object.entries(AGENTS)) {
    if (name === 'securite' || name === 'test-writer') continue;
    if (def.write.some((p) => rel.startsWith(p))) return name;
  }
  if (rel.startsWith('docs/handoff/') || rel.startsWith('docs/security/')) return 'securite';
  return 'team-lead';
}

module.exports = { LEAD_ONLY, AGENTS, ownerOf };
