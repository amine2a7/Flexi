import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { DbService } from '../common/db.service.js';
import { ApiProblem } from '../common/problem.js';
import { hashSecret, verifySecret } from '../auth/password.js';
import { SessionService } from '../auth/session.service.js';

/**
 * 3 wrong PINs lock it, for the successive durations of the settings (15, 30, 60 min by default,
 * pin_lock_minutes), then until a full sign-in.
 */
const MAX_FAILURES = 3;
/** Obvious sequences refused for a new PIN (spec 01 §3). */
const WEAK = new Set([
  '0000',
  '1111',
  '2222',
  '3333',
  '4444',
  '5555',
  '6666',
  '7777',
  '8888',
  '9999',
  '0123',
  '1234',
  '2345',
  '3456',
  '4567',
  '5678',
  '6789',
  '9876',
  '8765',
  '7654',
  '6543',
  '5432',
  '4321',
  '3210',
]);

@Injectable()
export class PinService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SessionService) private readonly sessions: SessionService,
  ) {}

  /**
   * Verifies the payment PIN of the employee (securite B5-S01). The attempt is reserved first by
   * one UPDATE (at most 3 per lock window, whatever the number of simultaneous requests), then
   * the hash is checked. 3 failures lock it 15 min, then 30, then 60, then until a full sign-in.
   * A wrong PIN and a locked PIN get the same answer (PIN_INVALID), with the time left when locked.
   */
  async verify(employeeId: string, pin: string): Promise<void> {
    const [reserved] = await this.db.system(
      (tx) => tx.$queryRaw<{ pin_hash: string; pin_failures: number }[]>`
        UPDATE employees SET pin_failures = pin_failures + 1
         WHERE id = ${employeeId}::uuid AND pin_hash IS NOT NULL AND NOT pin_requires_reauth
           AND pin_failures < ${MAX_FAILURES}
           AND (pin_locked_until IS NULL OR pin_locked_until <= now())
        RETURNING pin_hash, pin_failures`,
    );
    if (reserved === undefined) throw await this.refusal(employeeId);
    if (await verifySecret(reserved.pin_hash, pin)) {
      await this.db.system(
        (tx) => tx.$executeRaw`UPDATE employees SET pin_failures = 0, pin_lock_level = 0
          WHERE id = ${employeeId}::uuid`,
      );
      return;
    }
    await this.db.system(async (tx) => {
      const target = `employé ${employeeId}`;
      await this.audit.record(tx, 'pin.failed', target);
      if (reserved.pin_failures < MAX_FAILURES) return;
      // Old values on the right-hand side: level 0 -> 1st duration, 1 -> 2nd... past the last
      // one -> sign-in (durations of the settings).
      const [locked] = await tx.$queryRaw<
        { pin_lock_level: number; pin_requires_reauth: boolean }[]
      >`
        UPDATE employees e SET pin_failures = 0, pin_lock_level = e.pin_lock_level + 1,
               pin_requires_reauth = e.pin_lock_level + 1 > cardinality(s.pin_lock_minutes),
               pin_locked_until = CASE WHEN e.pin_lock_level + 1 > cardinality(s.pin_lock_minutes)
                 THEN NULL
                 ELSE now() + make_interval(mins => s.pin_lock_minutes[e.pin_lock_level + 1]) END
          FROM platform_settings s
         WHERE s.id = 1 AND e.id = ${employeeId}::uuid AND e.pin_failures >= ${MAX_FAILURES}
        RETURNING e.pin_lock_level, e.pin_requires_reauth`;
      if (locked === undefined) return;
      if (locked.pin_requires_reauth) {
        // Whoever holds the session loses it: only a complete sign-in lifts the block (S24).
        const users = await tx.user.findMany({ where: { employeeId }, select: { id: true } });
        for (const user of users) await this.sessions.revokeOthers(tx, user.id);
      }
      await this.audit.record(
        tx,
        locked.pin_requires_reauth ? 'pin.blockedUntilSignIn' : 'pin.locked',
        `${target} (niveau ${String(locked.pin_lock_level)})`,
      );
    });
    throw await this.refusal(employeeId);
  }

  /** The single answer to a refused PIN: same code, with the time left or the sign-in needed. */
  private async refusal(employeeId: string): Promise<ApiProblem> {
    const employee = await this.db.system((tx) =>
      tx.employee.findUnique({
        where: { id: employeeId },
        select: { pinLockedUntil: true, pinRequiresReauth: true },
      }),
    );
    if (employee?.pinRequiresReauth === true) {
      return new ApiProblem(403, 'PIN_INVALID', { reauthenticationRequired: true });
    }
    const left = (employee?.pinLockedUntil?.getTime() ?? 0) - Date.now();
    return left > 0
      ? new ApiProblem(403, 'PIN_INVALID', { retryAfterSeconds: Math.ceil(left / 1000) })
      : new ApiProblem(403, 'PIN_INVALID');
  }

  /**
   * Changes the PIN (the current one is checked), or chooses the first PIN of a new beneficiary:
   * without a current PIN, only while the account has none (one atomic UPDATE: never twice).
   */
  async change(employeeId: string, currentPin: string | undefined, newPin: string): Promise<void> {
    if (WEAK.has(newPin)) {
      throw new ApiProblem(400, 'VALIDATION_FAILED', {
        fields: [
          {
            in: 'body',
            pointer: '/newPin',
            code: 'INVALID_FORMAT',
            messageKey: 'errors.field.invalidFormat',
          },
        ],
      });
    }
    if (currentPin === undefined) {
      const first = await hashSecret(newPin);
      await this.db.system(async (tx) => {
        const set = await tx.$executeRaw`
          UPDATE employees SET pin_hash = ${first}, pin_failures = 0, pin_lock_level = 0,
                 pin_locked_until = NULL
           WHERE id = ${employeeId}::uuid AND pin_hash IS NULL`;
        if (set === 0) throw new ApiProblem(403, 'PIN_INVALID');
        await this.audit.record(tx, 'pin.created', `employé ${employeeId}`);
      });
      return;
    }
    await this.verify(employeeId, currentPin);
    const pinHash = await hashSecret(newPin);
    await this.db.system(async (tx) => {
      const employee = await tx.employee.update({
        where: { id: employeeId },
        data: { pinHash, pinFailures: 0, pinLockedUntil: null, pinLockLevel: 0 },
      });
      await this.audit.record(
        tx,
        'pin.changed',
        `${employee.firstName} ${employee.lastName.charAt(0)}.`,
      );
    });
  }
}
