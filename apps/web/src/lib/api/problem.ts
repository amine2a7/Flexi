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
  PIN_INVALID: 'errors.pinInvalid',
  PIN_LOCKED: 'errors.pinLocked',
  RATE_LIMITED: 'errors.rateLimited',
  INTERNAL_ERROR: 'errors.internalError',
  SERVICE_UNAVAILABLE: 'errors.serviceUnavailable',
  QUOTE_EXPIRED: 'errors.quoteExpired',
  CANCEL_WINDOW_OVER: 'errors.cancelWindowOver',
};

/**
 * Refused PIN (securite S01): one code whether it is wrong or locked; while locked, the time left,
 * or the full sign-in required after the fourth lock.
 */
export function pinRefusal(
  error: unknown,
): { retryAfterSeconds?: number; reauthenticationRequired?: boolean } | undefined {
  const problem = asProblem(error);
  if (problem?.code !== 'PIN_INVALID') return undefined;
  const details = (problem.details ?? {}) as {
    retryAfterSeconds?: unknown;
    reauthenticationRequired?: unknown;
  };
  return {
    ...(typeof details.retryAfterSeconds === 'number'
      ? { retryAfterSeconds: details.retryAfterSeconds }
      : {}),
    ...(details.reauthenticationRequired === true ? { reauthenticationRequired: true } : {}),
  };
}

/** The problem carried by an API error body, if it is a well-formed RFC 9457 problem. */
export function asProblem(error: unknown): ApiProblem | undefined {
  return isProblem(error) ? error : undefined;
}

/** Invalid fields of a `400 VALIDATION_FAILED` (contract §4: `details.fields[]`), else empty. */
export function fieldErrors(error: unknown): { pointer: string; code: string }[] {
  const problem = asProblem(error);
  if (problem?.code !== 'VALIDATION_FAILED') return [];
  const fields = (problem.details as { fields?: unknown } | undefined)?.fields;
  if (!Array.isArray(fields)) return [];
  return fields.flatMap((item: unknown) => {
    const field = item as { pointer?: unknown; code?: unknown };
    return typeof field.pointer === 'string' && typeof field.code === 'string'
      ? [{ pointer: field.pointer, code: field.code }]
      : [];
  });
}

/** i18n key explaining an API error; network failures and unknown codes get a generic message. */
export function errorMessageKey(error: unknown): string {
  const problem = asProblem(error);
  if (problem === undefined) return 'errors.network';
  return MESSAGE_KEYS[problem.code] ?? 'errors.generic';
}
