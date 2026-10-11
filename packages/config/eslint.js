// Shared ESLint flat config (FlexiPay).
// Usage in a package `eslint.config.mjs`:
//   import { createConfig } from '@flexipay/config/eslint';
//   export default createConfig({ tsconfigRootDir: import.meta.dirname });
import js from '@eslint/js';
import prettier from 'eslint-config-prettier';
import tseslint from 'typescript-eslint';

/** Ignored everywhere: build output, caches, coverage. */
export const ignores = ['**/dist/**', '**/coverage/**', '**/.turbo/**', '**/node_modules/**'];

/**
 * Rules protecting money handling and code safety (CLAUDE.md rules 1, 14).
 * Amounts are integer millimes: no decimal formatting/parsing in code that may touch money.
 */
export const safetyRules = {
  'no-eval': 'error',
  'no-implied-eval': 'error',
  'no-new-func': 'error',
  eqeqeq: ['error', 'always'],
  'no-restricted-properties': [
    'error',
    {
      object: 'Number',
      property: 'parseFloat',
      message: 'Money is integer millimes: never parse floats.',
    },
    {
      property: 'toFixed',
      message: 'Money is integer millimes: never use toFixed. Formatting is client-side only.',
    },
  ],
  'no-restricted-globals': [
    'error',
    { name: 'parseFloat', message: 'Money is integer millimes: never parse floats.' },
  ],
};

/**
 * Builds the shared flat config.
 * @param {{ tsconfigRootDir: string }} options absolute directory of the package (import.meta.dirname)
 */
export function createConfig({ tsconfigRootDir }) {
  return tseslint.config(
    { ignores },
    js.configs.recommended,
    ...tseslint.configs.strictTypeChecked,
    ...tseslint.configs.stylisticTypeChecked,
    {
      languageOptions: {
        parserOptions: {
          projectService: true,
          tsconfigRootDir,
        },
      },
      linterOptions: {
        reportUnusedDisableDirectives: 'error',
      },
      rules: {
        ...safetyRules,
        '@typescript-eslint/consistent-type-imports': 'error',
        '@typescript-eslint/no-explicit-any': 'error',
      },
    },
    {
      // Plain JS config files are not part of a TS project: no type-aware rules.
      files: ['**/*.{js,mjs,cjs}'],
      extends: [tseslint.configs.disableTypeChecked],
    },
    prettier,
  );
}
