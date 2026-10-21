import { Injectable } from '@nestjs/common';
import type { Tx } from './db.service.js';
import { currentContext } from './request-context.js';

/**
 * Audit log of sensitive actions (CLAUDE.md rule 13), append-only (trigger). Written in the same
 * SQL transaction as the action. `target` names the object (reference, name), never a secret,
 * a PIN, a token, an IBAN or a balance.
 */
@Injectable()
export class AuditService {
  async record(tx: Tx, action: string, target: string, actorName?: string): Promise<void> {
    const who = currentContext()?.principal;
    // No RETURNING: a tenant may write its audit entry but never read the audit log (RLS).
    await tx.auditLog.createMany({
      data: {
        actorUserId: who?.userId ?? null,
        actorName: actorName ?? who?.displayName ?? 'Système',
        action,
        target: target.slice(0, 200),
      },
    });
  }
}
