import { isProblem, type ApiProblem } from '@flexipay/api-client';

/** Error codes the interface knows how to explain; anything else falls back to a generic message. */
const MESSAGE_KEYS: Readonly<Record<string, string>> = {
  VALIDATION_FAILED: 'errors.validationFailed',
  UNAUTHENTICATED: 'errors.unauthenticated',
  SESSION_EXPIRED: 'errors.sessionExpired',
  INVALID_CREDENTIALS: 'errors.invalidCredentials',
  MFA_CODE_INVALID: 'errors.mfaCodeInvalid',
  MFA_CHALLENGE_EXPIRED: 'errors.mfaChallengeExpired',
  FORBIDDEN: 'errors.forbidden',
  NOT_FOUND: 'errors.notFound',
  RESOURCE_STATE_CONFLICT: 'errors.resourceStateConflict',
  INSUFFICIENT_FUNDS: 'errors.insufficientFunds',
  LIMIT_EXCEEDED: 'errors.limitExceeded',
  PAYMENT_DECLINED: 'errors.paymentDeclined',
  RATE_LIMITED: 'errors.rateLimited',
  INTERNAL_ERROR: 'errors.internalError',
  SERVICE_UNAVAILABLE: 'errors.serviceUnavailable',
};

/** The problem carried by an API error body, if it is a well-formed RFC 9457 problem. */
export function asProblem(error: unknown): ApiProblem | undefined {
  return isProblem(error) ? error : undefined;
}

/** i18n key explaining an API error; network failures and unknown codes get a generic message. */
export function errorMessageKey(error: unknown): string {
  const problem = asProblem(error);
  if (problem === undefined) return 'errors.network';
  return MESSAGE_KEYS[problem.code] ?? 'errors.generic';
}
