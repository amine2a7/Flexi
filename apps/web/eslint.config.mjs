import { createConfig, ignores, safetyRules } from '@flexipay/config/eslint';
import reactHooks from 'eslint-plugin-react-hooks';

export default [
  {
    ignores: [
      ...ignores,
      '.next/**',
      '.next-test/**',
      '.next-e2e/**',
      '.next-build/**',
      'next-env.d.ts',
      'playwright-report/**',
      'test-results/**',
    ],
  },
  ...createConfig({ tsconfigRootDir: import.meta.dirname }),
  reactHooks.configs.flat.recommended,
  {
    // Node scripts (i18n sources and generator): CommonJS, run by hand.
    files: ['scripts/**/*.cjs'],
    languageOptions: {
      sourceType: 'commonjs',
      globals: {
        require: 'readonly',
        module: 'writable',
        __dirname: 'readonly',
        console: 'readonly',
      },
    },
    rules: {
      '@typescript-eslint/no-require-imports': 'off',
      'no-console': 'off',
    },
  },
  {
    files: ['src/**/*.{ts,tsx}'],
    rules: {
      // Leaving a field out of a copy ({ secret: _secret, ...rest }) is the idiomatic way to strip it.
      '@typescript-eslint/no-unused-vars': ['error', { ignoreRestSiblings: true }],
      // Rule 3 (no token in localStorage/sessionStorage) and rule 1 (money): extends the shared list.
      'no-restricted-globals': [
        ...safetyRules['no-restricted-globals'],
        { name: 'localStorage', message: 'No token or personal data in browser storage (SEC-A7).' },
        {
          name: 'sessionStorage',
          message: 'No token or personal data in browser storage (SEC-A7).',
        },
      ],
      'no-restricted-syntax': [
        'error',
        {
          selector: "JSXAttribute[name.name='dangerouslySetInnerHTML']",
          message: 'dangerouslySetInnerHTML is forbidden (XSS); sanitize and review first.',
        },
        {
          selector: "MemberExpression[object.name='document'][property.name='cookie']",
          message: 'Cookies are set by the API (HttpOnly); the client never reads or writes them.',
        },
      ],
    },
  },
  {
    // Mock API only (development, never in the build, fictional data): the demo keeps its orders
    // and tour state across reloads in sessionStorage. localStorage stays forbidden here too.
    files: ['src/mocks/**/*.ts'],
    rules: {
      'no-restricted-globals': [
        ...safetyRules['no-restricted-globals'],
        { name: 'localStorage', message: 'No token or personal data in browser storage (SEC-A7).' },
      ],
    },
  },
];
