import { http, type RequestHandler } from 'msw';
import { MOCK_FIXTURE_SENTINEL } from './fixtures/sentinel';
import { adminHandlers } from './handlers/admin';
import { adminOpsHandlers } from './handlers/admin-ops';
import { authHandlers } from './handlers/auth';
import { contactHandlers } from './handlers/contact';
import { companyHandlers } from './handlers/company';
import { employeeHandlers } from './handlers/employee';
import { merchantHandlers } from './handlers/merchant';
import { orderHandlers } from './handlers/orders';
import { apiUrl, MOCK_SESSION_COOKIE, restoreSession } from './handlers/util';

// Runs before every route and falls through (returns nothing): restores the session after a reload.
const sessionRestore = http.all(apiUrl('/v1/*'), ({ cookies }) => {
  restoreSession(cookies[MOCK_SESSION_COOKIE]);
});

/**
 * Mock handlers of the FlexiPay API, one file per space. Every response body is typed with the
 * generated types of `@flexipay/api-client` (contract docs/handoff/contracts/openapi.yaml):
 * amounts are integer millimes, errors are RFC 9457 problems, statuses come from the contract.
 */
export const handlers: RequestHandler[] = [
  sessionRestore,
  ...authHandlers,
  ...merchantHandlers,
  ...companyHandlers,
  ...employeeHandlers,
  ...orderHandlers,
  ...adminHandlers,
  ...adminOpsHandlers,
  ...contactHandlers,
];

export const MOCK_HANDLERS_MARKER = MOCK_FIXTURE_SENTINEL;
