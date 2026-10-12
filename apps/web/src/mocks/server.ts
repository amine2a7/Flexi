import { setupServer } from 'msw/node';
import { handlers } from './handlers';

/** Node-side mock server for unit tests (Vitest). Never imported by application code. */
export const server = setupServer(...handlers);
