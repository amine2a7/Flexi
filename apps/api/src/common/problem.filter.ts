import { randomUUID } from 'node:crypto';
import {
  Catch,
  HttpException,
  Logger,
  type ArgumentsHost,
  type ExceptionFilter,
} from '@nestjs/common';
import type { Response } from 'express';
import { ApiProblem } from './problem.js';
import { currentContext } from './request-context.js';

/**
 * Every error leaves the API as an RFC 9457 problem (contract §4). Unknown errors become
 * `500 INTERNAL_ERROR`: the log keeps the request id and the error class only, never the
 * message (it may contain SQL or a value typed by the user).
 */
@Catch()
export class ProblemFilter implements ExceptionFilter {
  private readonly logger = new Logger('Problem');

  catch(error: unknown, host: ArgumentsHost): void {
    const res = host.switchToHttp().getResponse<Response>();
    const requestId = currentContext()?.requestId ?? randomUUID();
    const problem = this.toProblem(error, requestId);
    if (res.headersSent) return;
    for (const [name, value] of Object.entries(problem.headers ?? {})) res.setHeader(name, value);
    res
      .status(problem.status)
      .type('application/problem+json')
      .send(JSON.stringify(problem.body(requestId)));
  }

  private toProblem(error: unknown, requestId: string): ApiProblem {
    if (error instanceof ApiProblem) return error;
    if (error instanceof HttpException) {
      const status = error.getStatus();
      if (status === 404) return new ApiProblem(404, 'NOT_FOUND');
      if (status === 413) return new ApiProblem(413, 'PAYLOAD_TOO_LARGE');
      if (status === 415) return new ApiProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
      if (status === 403) return new ApiProblem(403, 'FORBIDDEN');
      if (status === 401) return new ApiProblem(401, 'UNAUTHENTICATED');
      if (status === 400) {
        return new ApiProblem(400, 'VALIDATION_FAILED', {
          fields: [
            {
              in: 'body',
              pointer: '',
              code: 'INVALID_TYPE',
              messageKey: 'errors.field.invalidType',
            },
          ],
        });
      }
    }
    // Lock / statement timeout or serialization failure under load: retryable, nothing written.
    const pgCode = (error as { code?: unknown; meta?: { code?: unknown } }).meta?.code;
    // A unique index refused the row (two requests at the same time, e.g. the same CIN by its
    // blind index): a conflict, never a server error.
    if ((error as { code?: unknown }).code === 'P2002' || pgCode === '23505') {
      return new ApiProblem(409, 'RESOURCE_STATE_CONFLICT');
    }
    if (pgCode === '40001' || pgCode === '55P03' || pgCode === '57014') {
      return new ApiProblem(
        503,
        'SERVICE_UNAVAILABLE',
        { retryAfterSeconds: 1 },
        { 'Retry-After': '1' },
      );
    }
    this.logger.error(
      `request ${requestId}: ${error instanceof Error ? error.constructor.name : typeof error}`,
    );
    return new ApiProblem(500, 'INTERNAL_ERROR');
  }
}
