import { createConfig } from '@flexipay/config/eslint';

export default [
  // prisma/volume: generator of the volume data set (former web mock), run by tsx only.
  { ignores: ['src/generated/**', 'var/**', 'prisma/volume/**'] },
  ...createConfig({ tsconfigRootDir: import.meta.dirname }),
  {
    // Developer scripts in plain JavaScript (Node globals).
    files: ['scripts/**/*.mjs'],
    languageOptions: { globals: { process: 'readonly', console: 'readonly', URL: 'readonly' } },
  },
  {
    // Database seed: a command-line program, like the scripts.
    files: ['prisma/seed.ts', 'prisma/seed-volume.ts', 'prisma/demo/**/*.ts'],
    rules: { 'no-console': 'off' },
  },
  {
    // NestJS classes are declared for the DI container (decorators): empty classes are modules.
    files: ['src/**/*.module.ts'],
    rules: { '@typescript-eslint/no-extraneous-class': 'off' },
  },
];
