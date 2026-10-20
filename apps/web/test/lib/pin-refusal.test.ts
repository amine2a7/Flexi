import { describe, expect, it } from 'vitest';
import { pinRefusal } from '@/lib/api/problem';

const problem = (code: string, details?: Record<string, unknown>) => ({
  type: `urn:flexipay:problem:${code.toLowerCase().replaceAll('_', '-')}`,
  title: code,
  status: 403,
  code,
  messageKey: 'errors.x',
  requestId: 'r',
  ...(details === undefined ? {} : { details }),
});

describe('pinRefusal (securite S01: one answer for a wrong or a locked PIN)', () => {
  it('reads a plain refusal, a lock with its time left, and the sign-in required', () => {
    expect(pinRefusal(problem('PIN_INVALID'))).toEqual({});
    expect(pinRefusal(problem('PIN_INVALID', { retryAfterSeconds: 840 }))).toEqual({
      retryAfterSeconds: 840,
    });
    expect(pinRefusal(problem('PIN_INVALID', { reauthenticationRequired: true }))).toEqual({
      reauthenticationRequired: true,
    });
  });

  it('ignores other problems and malformed details', () => {
    expect(pinRefusal(problem('FORBIDDEN'))).toBeUndefined();
    expect(pinRefusal(problem('PIN_INVALID', { retryAfterSeconds: '840' }))).toEqual({});
  });
});
