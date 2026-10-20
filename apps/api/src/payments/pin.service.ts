import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { DbService } from '../common/db.service.js';
import { ApiProblem } from '../common/problem.js';
import { hashSecret, verifySecret } from '../auth/password.js';

/** 3 wrong PINs lock it: 15 min, then 30, then 60 (TIMED_LOCKS), then until a full sign-in. */
const MAX_FAILURES = 3;
const FIRST_LOCK_MINUTES = 15;
const TIMED_LOCKS = 3;
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
      // Old values on the right-hand side: level 0 -> 15 min, 1 -> 30, 2 -> 60, 3 -> sign-in.
      const [locked] = await tx.$queryRaw<
        { pin_lock_level: number; pin_requires_reauth: boolean }[]
      >`
        UPDATE employees SET pin_failures = 0, pin_lock_level = pin_lock_level + 1,
               pin_requires_reauth = pin_lock_level + 1 > ${TIMED_LOCKS},
               pin_locked_until = CASE WHEN pin_lock_level + 1 > ${TIMED_LOCKS} THEN NULL
                 ELSE now() + make_interval(mins => ${FIRST_LOCK_MINUTES} * (2 ^ pin_lock_level)::int) END
         WHERE id = ${employeeId}::uuid AND pin_failures >= ${MAX_FAILURES}
        RETURNING pin_lock_level, pin_requires_reauth`;
      if (locked === undefined) return;
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

  async change(employeeId: string, currentPin: string, newPin: string): Promise<void> {
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
