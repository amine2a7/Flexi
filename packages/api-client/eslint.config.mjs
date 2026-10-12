import { createConfig } from '@flexipay/config/eslint';

export default [
  // Generated from the OpenAPI contract: not linted, checked by the freshness test.
  { ignores: ['src/generated/**'] },
  ...createConfig({ tsconfigRootDir: import.meta.dirname }),
];
