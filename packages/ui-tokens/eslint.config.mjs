import { createConfig } from '@flexipay/config/eslint';

export default [
  // Generated artefacts (CJS / Dart) are not linted; they are checked by the freshness test.
  { ignores: ['generated/**', 'dart/**'] },
  ...createConfig({ tsconfigRootDir: import.meta.dirname }),
  {
    files: ['src/**/*.ts', 'test/**/*.ts'],
    // Token numbers (px, ms, ratios) are interpolated into generated source; no money is handled here.
    rules: {
      '@typescript-eslint/restrict-template-expressions': ['error', { allowNumber: true }],
    },
  },
];
