import { z } from 'zod';
import { validationFailed, type FieldError, type FieldErrorCode } from './problem.js';

type Location = FieldError['in'];

function codeOf(issue: z.core.$ZodIssue, input: unknown): FieldErrorCode {
  switch (issue.code) {
    case 'invalid_type':
      if (issue.expected === 'int') return 'NOT_INTEGER';
      return input === undefined ? 'REQUIRED' : 'INVALID_TYPE';
    case 'too_small':
      return issue.origin === 'number' || issue.origin === 'bigint' ? 'TOO_SMALL' : 'TOO_SHORT';
    case 'too_big':
      return issue.origin === 'number' || issue.origin === 'bigint' ? 'TOO_BIG' : 'TOO_LONG';
    case 'invalid_format':
      return 'INVALID_FORMAT';
    case 'invalid_value':
      return 'INVALID_ENUM';
    case 'custom': {
      const custom = (issue.params as { fieldCode?: FieldErrorCode } | undefined)?.fieldCode;
      return custom ?? 'INVALID_FORMAT';
    }
    default:
      return 'INVALID_FORMAT';
  }
}

function valueAt(root: unknown, path: readonly PropertyKey[]): unknown {
  let value = root;
  for (const key of path) {
    if (value === null || typeof value !== 'object') return undefined;
    value = (value as Record<PropertyKey, unknown>)[key];
  }
  return value;
}

function paramsOf(issue: z.core.$ZodIssue): Record<string, unknown> | undefined {
  if (issue.code === 'too_small') return { min: Number(issue.minimum) };
  if (issue.code === 'too_big') return { max: Number(issue.maximum) };
  return undefined;
}

/** Zod issues -> contract field errors. The typed value is never echoed (contract §4). */
export function toFieldErrors(error: z.ZodError, input: unknown, where: Location): FieldError[] {
  return error.issues.flatMap((issue): FieldError[] => {
    const prefix = where === 'body' ? '/' : '';
    if (issue.code === 'unrecognized_keys') {
      return issue.keys.map((key) => ({
        in: where,
        pointer: prefix + [...issue.path, key].map(String).join('/'),
        code: 'UNKNOWN_FIELD',
      }));
    }
    const params = paramsOf(issue);
    return [
      {
        in: where,
        pointer: prefix + issue.path.map(String).join('/'),
        code: codeOf(issue, valueAt(input, issue.path)),
        ...(params === undefined ? {} : { params }),
      },
    ];
  });
}

/** Parses or throws `400 VALIDATION_FAILED` with `details.fields[]`. */
export function parse<T extends z.ZodType>(
  schema: T,
  input: unknown,
  where: Location = 'body',
): z.infer<T> {
  const result = schema.safeParse(input);
  if (!result.success) throw validationFailed(toFieldErrors(result.error, input, where));
  return result.data;
}

/** Field error helper for business checks done after parsing (same format). */
export function fieldError(
  pointer: string,
  code: FieldErrorCode,
  where: Location = 'body',
): ReturnType<typeof validationFailed> {
  return validationFailed([{ in: where, pointer, code }]);
}

// ------------------------------------------------------------------ shared schemas (contract)

export const uuid = z.uuid();
export const millimes = z.number().int().min(0).max(Number.MAX_SAFE_INTEGER);
export const positiveMillimes = z.number().int().min(1).max(Number.MAX_SAFE_INTEGER);
export const rateBps = z.number().int().min(0).max(10_000);
export const phoneNumber = z.string().regex(/^\+[1-9][0-9]{7,14}$/);
export const email = z.email().max(254);
export const creditType = z.enum(['RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX']);
export const reason = z.string().trim().min(1).max(500);

/** Query string flag (`true` / `false`). */
export const queryBoolean = z.enum(['true', 'false']).transform((value) => value === 'true');
