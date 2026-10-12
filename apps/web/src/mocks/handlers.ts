import type { RequestHandler } from 'msw';
import { MOCK_FIXTURE_SENTINEL } from './fixtures/sentinel';
import { adminHandlers } from './handlers/admin';
import { authHandlers } from './handlers/auth';
import { companyHandlers } from './handlers/company';
import { merchantHandlers } from './handlers/merchant';

/**
 * Mock handlers of the FlexiPay API, one file per space. Every response body is typed with the
 * generated types of `@flexipay/api-client` (contract docs/handoff/contracts/openapi.yaml):
 * amounts are integer millimes, errors are RFC 9457 problems, statuses come from the contract.
 */
export const handlers: RequestHandler[] = [
  ...authHandlers,
  ...merchantHandlers,
  ...companyHandlers,
  ...adminHandlers,
];

export const MOCK_HANDLERS_MARKER = MOCK_FIXTURE_SENTINEL;
