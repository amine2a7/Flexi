import type { Schemas } from '@flexipay/api-client';

export type ProblemCode = Schemas['ProblemCode'];
export type FieldErrorCode = Schemas['FieldErrorCode'];

export interface FieldError {
  readonly in: 'body' | 'query' | 'path' | 'header';
  readonly pointer: string;
  readonly code: FieldErrorCode;
  readonly params?: Record<string, unknown>;
}

const camel = (code: string): string =>
  code.toLowerCase().replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase());
const kebab = (code: string): string => code.toLowerCase().replaceAll('_', '-');
const title = (code: string): string =>
  code
    .toLowerCase()
    .split('_')
    .map((word, index) => (index === 0 ? word.charAt(0).toUpperCase() + word.slice(1) : word))
    .join(' ');

/** Message key of the catalogue (contract §4): `errors.<codeInCamelCase>`, with its exceptions. */
const MESSAGE_KEY_OVERRIDES: Partial<Record<ProblemCode, string>> = {
  INTERNAL_ERROR: 'errors.internal',
};

/**
 * Error of the API, rendered as an RFC 9457 problem by ProblemFilter. Never carries a value typed
 * by the user, a stack trace, an SQL message, a secret or a full balance (contract §4).
 */
export class ApiProblem extends Error {
  constructor(
    readonly status: number,
    readonly code: ProblemCode,
    readonly details?: Record<string, unknown>,
    /** Extra response headers (Retry-After…). */
    readonly headers?: Record<string, string>,
  ) {
    super(code);
  }

  body(requestId: string): Record<string, unknown> {
    return {
      type: `urn:flexipay:problem:${kebab(this.code)}`,
      title: title(this.code),
      status: this.status,
      code: this.code,
      messageKey: MESSAGE_KEY_OVERRIDES[this.code] ?? `errors.${camel(this.code)}`,
      requestId,
      ...(this.details === undefined ? {} : { details: this.details }),
    };
  }
}

export function validationFailed(fields: readonly FieldError[]): ApiProblem {
  return new ApiProblem(400, 'VALIDATION_FAILED', {
    fields: fields.map((field) => ({
      in: field.in,
      pointer: field.pointer,
      code: field.code,
      messageKey: `errors.field.${camel(field.code)}`,
      ...(field.params === undefined ? {} : { params: field.params }),
    })),
  });
}

export const problems = {
  unauthenticated: () => new ApiProblem(401, 'UNAUTHENTICATED'),
  forbidden: () => new ApiProblem(403, 'FORBIDDEN'),
  notFound: () => new ApiProblem(404, 'NOT_FOUND'),
  conflict: () => new ApiProblem(409, 'RESOURCE_STATE_CONFLICT'),
  csrf: () => new ApiProblem(403, 'CSRF_TOKEN_INVALID'),
  invalidCredentials: () => new ApiProblem(401, 'INVALID_CREDENTIALS'),
} as const;
