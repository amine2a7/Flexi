import type { Response } from 'express';
import { z } from 'zod';
import type { Outcome } from './idempotency.service.js';
import { validationFailed } from './problem.js';

/** UUID of a path parameter, or `400 VALIDATION_FAILED` (in: path). */
export function pathId(name: string, value: string): string {
  if (!z.uuid().safeParse(value).success) {
    throw validationFailed([{ in: 'path', pointer: name, code: 'INVALID_FORMAT' }]);
  }
  return value;
}

/** Writes an idempotent outcome: its status, and `Idempotent-Replayed: true` on a replay. */
export function sendOutcome<T>(res: Response, outcome: Outcome<T>): T {
  res.status(outcome.status);
  if (outcome.replayed) res.setHeader('Idempotent-Replayed', 'true');
  return outcome.body;
}

/** Downloaded file (proof, KYC piece): attachment, original type, never sniffed by the browser. */
export function sendFile(res: Response, data: Buffer, contentType: string, fileName: string): void {
  const safe = fileName.replace(/[^\w.-]/g, '_').slice(0, 120) || 'document';
  res.setHeader('Content-Type', contentType);
  res.setHeader('Content-Disposition', `attachment; filename="${safe}"`);
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.status(200).end(data);
}
