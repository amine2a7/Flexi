import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from './audit.service.js';
import { DbService } from './db.service.js';
import { problems } from './problem.js';
import { principal } from './request-context.js';

/**
 * Four eyes (decision of 2026-10-21): the author of a file or an operation never validates it,
 * the super-admin included. Used by every validation (KYC, rate and settings changes, second
 * validation of an order, payouts, and later RIB and administrator role changes). A refusal is
 * audited in its own transaction, so it stays even though the request is then refused.
 */
@Injectable()
export class FourEyesService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /**
   * Refuses (403, audited) when the signed-in user is the author. With `authorRequired`, an
   * unknown author is refused too (fail closed): the check can never be skipped silently.
   */
  async ensureNotAuthor(
    authorUserId: string | null | undefined,
    subject: string,
    options: { authorRequired?: boolean } = {},
  ): Promise<void> {
    const who = principal();
    const unknown = authorUserId === null || authorUserId === undefined;
    if (unknown ? options.authorRequired !== true : authorUserId !== who.userId) return;
    await this.db.system((tx) =>
      this.audit.record(tx, 'fourEyes.refused', unknown ? `${subject} (auteur inconnu)` : subject),
    );
    throw problems.forbidden();
  }
}
