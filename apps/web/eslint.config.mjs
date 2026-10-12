import { createConfig, ignores, safetyRules } from '@flexipay/config/eslint';
import reactHooks from 'eslint-plugin-react-hooks';

export default [
  {
    ignores: [
      ...ignores,
      '.next/**',
      '.next-test/**',
      '.next-e2e/**',
      'next-env.d.ts',
      'playwright-report/**',
      'test-results/**',
      'public/mockServiceWorker.js',
    ],
  },
  ...createConfig({ tsconfigRootDir: import.meta.dirname }),
  reactHooks.configs.flat.recommended,
  {
    files: ['src/**/*.{ts,tsx}'],
    rules: {
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
];
