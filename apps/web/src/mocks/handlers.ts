import type { RequestHandler } from 'msw';
import { MOCK_FIXTURE_SENTINEL } from './fixtures/sentinel';

/**
 * Mock handlers of the FlexiPay API. Every response body is typed with the generated types of
 * `@flexipay/api-client` (contract docs/handoff/contracts/openapi.yaml): amounts are integer
 * millimes, errors are RFC 9457 problems, statuses come from the glossary enums.
 * Handlers are added screen by screen (the contract only has GET /health today).
 */
export const handlers: RequestHandler[] = [];

export const MOCK_HANDLERS_MARKER = MOCK_FIXTURE_SENTINEL;
