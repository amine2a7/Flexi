import { createConfig } from '@flexipay/config/eslint';

export default [
  { ignores: ['src/generated/**', 'var/**'] },
  ...createConfig({ tsconfigRootDir: import.meta.dirname }),
  {
    // Developer scripts in plain JavaScript (Node globals).
    files: ['scripts/**/*.mjs'],
    languageOptions: { globals: { process: 'readonly', console: 'readonly', URL: 'readonly' } },
  },
  {
    // NestJS classes are declared for the DI container (decorators): empty classes are modules.
    files: ['src/**/*.module.ts'],
    rules: { '@typescript-eslint/no-extraneous-class': 'off' },
  },
];
