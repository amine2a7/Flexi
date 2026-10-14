import { Inject, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit.service.js';
import { DbService } from '../common/db.service.js';
import { ApiProblem } from '../common/problem.js';
import { hashSecret, verifySecret } from '../auth/password.js';

/** Contract: a wrong PIN counts; 3 failures lock it for 15 minutes (PIN_LOCKED). */
const MAX_FAILURES = 3;
const LOCK_MS = 15 * 60_000;
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
   * Verifies the payment PIN of the employee. Runs in its own SQL transaction, so a failure is
   * counted (and the lock set) even though the operation is then refused.
   */
  async verify(employeeId: string, pin: string): Promise<void> {
    const employee = await this.db.system((tx) =>
      tx.employee.findUnique({ where: { id: employeeId } }),
    );
    if (employee?.pinHash === undefined || employee.pinHash === null) throw new ApiProblem(403, 'PIN_INVALID');
    if (employee.pinLockedUntil !== null && employee.pinLockedUntil.getTime() > Date.now()) {
      throw new ApiProblem(403, 'PIN_LOCKED');
    }
    if (await verifySecret(employee.pinHash, pin)) {
      if (employee.pinFailures > 0) {
        await this.db.system((tx) =>
          tx.employee.update({ where: { id: employeeId }, data: { pinFailures: 0 } }),
        );
      }
      return;
    }
    const locked = await this.db.system(async (tx) => {
      const updated = await tx.employee.update({
        where: { id: employeeId },
        data: { pinFailures: { increment: 1 } },
      });
      if (updated.pinFailures < MAX_FAILURES) return false;
      await tx.employee.update({
        where: { id: employeeId },
        data: { pinFailures: 0, pinLockedUntil: new Date(Date.now() + LOCK_MS) },
      });
      await this.audit.record(
        tx,
        'pin.locked',
        `${updated.firstName} ${updated.lastName.charAt(0)}.`,
      );
      return true;
    });
    throw new ApiProblem(403, locked ? 'PIN_LOCKED' : 'PIN_INVALID');
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
        data: { pinHash, pinFailures: 0, pinLockedUntil: null },
      });
      await this.audit.record(
        tx,
        'pin.changed',
        `${employee.firstName} ${employee.lastName.charAt(0)}.`,
      );
    });
  }
}
