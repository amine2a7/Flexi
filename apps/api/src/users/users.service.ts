import { Inject, Injectable } from '@nestjs/common';
import { credentialsOf, InvitationService, invitationExpiry } from '../auth/invitation.service.js';
import {
  changeRefusal,
  graceEnd,
  nextStatus,
  type AccountStatus,
  type LifecycleAction,
} from '../common/account-lifecycle.js';
import { AuditService } from '../common/audit.service.js';
import { DbService, type Tx } from '../common/db.service.js';
import { toMillimes } from '../common/money.js';
import { OutboxService } from '../common/outbox.service.js';
import { Paginator, type Page } from '../common/pagination.js';
import { ApiProblem, problems, validationFailed } from '../common/problem.js';
import { permissionsOf } from '../common/permissions.js';
import { principal } from '../common/request-context.js';
import { LedgerService, accounts } from '../ledger/ledger.service.js';
import type { Prisma, Role, SubRole } from '../generated/prisma/client.js';

const ADMIN_SUB_ROLES: readonly SubRole[] = ['SUPER_ADMIN', 'COMPLIANCE', 'FINANCE', 'SUPPORT'];
const COMPANY_SUB_ROLES: readonly SubRole[] = ['OWNER', 'MANAGER', 'ACCOUNTANT', 'READ_ONLY'];
const MERCHANT_SUB_ROLES: readonly SubRole[] = ['OWNER', 'CASHIER', 'ACCOUNTANT'];
const CREDIT_TYPES = ['RESTAURATION', 'HABILLEMENT', 'CARBURANT', 'CADEAUX'] as const;
const HISTORY_SIZE = 50;

type UserRow = Prisma.UserGetPayload<{
  include: {
    company: { select: { id: true; name: true } };
    merchant: { select: { id: true; name: true } };
    employee: { include: { company: { select: { id: true; name: true } } } };
  };
}>;
const USER_INCLUDE = {
  company: { select: { id: true, name: true } },
  merchant: { select: { id: true, name: true } },
  employee: { include: { company: { select: { id: true, name: true } } } },
} as const;

/** Status shown to the web: an account whose temporary password is unchanged is « Invité ». */
function shownStatus(user: {
  status: UserRow['status'];
  mustChangePassword: boolean;
}): AccountStatus {
  return user.status === 'ACTIVE' && user.mustChangePassword ? 'INVITED' : user.status;
}

function adminUser(user: UserRow) {
  const tenant = user.company ?? user.merchant ?? user.employee?.company ?? null;
  return {
    id: user.id,
    displayName: user.displayName,
    email: user.email,
    role: user.role,
    subRole: user.subRole,
    tenant: tenant === null ? null : { id: tenant.id, name: tenant.name },
    status: shownStatus(user),
    graceUntil: user.employee?.graceUntil?.toISOString() ?? null,
    createdAt: user.createdAt.toISOString(),
  };
}

/** Sub-roles allowed for the role of an account (an admin sub-role is never given to a tenant). */
function subRolesOf(role: Role): readonly SubRole[] {
  if (role === 'ADMIN') return ADMIN_SUB_ROLES;
  if (role === 'COMPANY') return COMPANY_SUB_ROLES;
  if (role === 'MERCHANT') return MERCHANT_SUB_ROLES;
  return [];
}

/**
 * User management (decisions A to D of 2026-10-23): immediate changes (no four eyes), reason
 * recorded in the audit with the account it is about, self changes and the removal of the last
 * active super-admin refused (decision B).
 */
@Injectable()
export class UsersService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(Paginator) private readonly paginator: Paginator,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(InvitationService) private readonly invitations: InvitationService,
    @Inject(OutboxService) private readonly outbox: OutboxService,
    @Inject(LedgerService) private readonly ledger: LedgerService,
  ) {}

  async list(
    query: Record<string, unknown>,
    filters: { role?: Role; status?: AccountStatus; q?: string },
  ): Promise<Page<unknown>> {
    const request = this.paginator.request(query, filters);
    return this.db.user(async (tx) => {
      const status: Prisma.UserWhereInput =
        filters.status === undefined
          ? {}
          : filters.status === 'INVITED'
            ? { status: 'ACTIVE', mustChangePassword: true }
            : filters.status === 'ACTIVE'
              ? { status: 'ACTIVE', mustChangePassword: false }
              : { status: filters.status };
      const where: Prisma.UserWhereInput = {
        ...(filters.role === undefined ? {} : { role: filters.role }),
        ...status,
        ...(filters.q === undefined
          ? {}
          : {
              OR: [
                { displayName: { contains: filters.q, mode: 'insensitive' } },
                { email: { contains: filters.q, mode: 'insensitive' } },
              ],
            }),
      };
      const rows = await tx.user.findMany({
        where,
        include: USER_INCLUDE,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: request.offset,
        take: request.limit + 1,
      });
      const count = request.withCount ? await tx.user.count({ where, take: 10_001 }) : undefined;
      return this.paginator.page(request, rows.map(adminUser), filters, count);
    });
  }

  /** Detail and history; the balance only with `userBalances.read` (decision D4). */
  async detail(id: string, withBalance: boolean) {
    return this.db.user((tx) => this.detailIn(tx, id, withBalance));
  }

  private async detailIn(tx: Tx, id: string, withBalance: boolean) {
    const user = await tx.user.findUnique({ where: { id }, include: USER_INCLUDE });
    if (user === null) throw problems.notFound();
    const history = await tx.auditLog.findMany({
      where: { subjectId: id },
      orderBy: { occurredAt: 'desc' },
      take: HISTORY_SIZE,
    });
    const employee = user.employee;
    let balance: bigint | undefined;
    if (withBalance && employee !== null) {
      const balances = await Promise.all(
        CREDIT_TYPES.map((type) =>
          this.ledger.balance(tx, accounts.employeeWallet(employee.id, type)),
        ),
      );
      balance = balances.reduce((sum, value) => sum + value, 0n);
    }
    return {
      ...adminUser(user),
      mfaEnabled: user.mfaSecretEnc !== null,
      pinLocked:
        employee !== null &&
        (employee.pinRequiresReauth ||
          (employee.pinLockedUntil !== null && employee.pinLockedUntil.getTime() > Date.now())),
      ...(balance === undefined ? {} : { balanceMillimes: toMillimes(balance) }),
      ...(employee === null
        ? {}
        : {
            graceDays: (await tx.platformSettings.findUniqueOrThrow({ where: { id: 1 } }))
              .accountGraceDays,
          }),
      history: history.map((entry) => ({
        occurredAt: entry.occurredAt.toISOString(),
        actorName: entry.actorName,
        action: entry.action,
        reason: entry.reason,
      })),
    };
  }

  /** Creates an administrator at once (decision A); an address in use gets the same answer. */
  async createAdministrator(input: {
    displayName: string;
    email: string;
    subRole: SubRole;
    reason: string;
  }): Promise<void> {
    const [prepared] = await this.invitations.prepare([
      { role: 'ADMIN', subRole: input.subRole, displayName: input.displayName, email: input.email },
    ]);
    if (prepared === undefined) return;
    const created = await this.db.system(async (tx) => {
      const inUse = await this.invitations.emailsInUse(tx, [prepared.invitee.email]);
      if (inUse.size > 0) return false;
      await this.invitations.create(tx, [prepared]);
      const user = await tx.user.findUniqueOrThrow({ where: { email: prepared.invitee.email } });
      await this.audit.recordFor(tx, 'users.create', user.id, user.displayName, input.reason);
      return true;
    });
    if (created) await this.invitations.deliver([prepared]);
    else await this.invitations.notifyExisting([prepared.invitee.email]);
  }

  /** Status change by an administrator (suspend, reactivate, deactivate). */
  async changeStatus(id: string, action: LifecycleAction, reason: string, withBalance: boolean) {
    await this.db.system(async (tx) => {
      const user = await this.lockUser(tx, id);
      await this.refuseUnsafe(tx, user, action);
      await this.apply(tx, user, action, reason);
    });
    return this.detail(id, withBalance);
  }

  /** Sub-role change; an administrator target needs `users.adminRoles` (checked by the caller). */
  async changeRole(id: string, subRole: SubRole, reason: string, withBalance: boolean) {
    await this.db.system(async (tx) => {
      const user = await this.lockUser(tx, id);
      if (!subRolesOf(user.role).includes(subRole)) {
        throw validationFailed([{ in: 'body', pointer: '/subRole', code: 'INVALID_ENUM' }]);
      }
      await this.refuseUnsafe(tx, user, 'ROLE', subRole);
      if (user.subRole === subRole) return;
      // The last active owner of a company or a merchant is never demoted (to confirm by Amine).
      if (user.subRole === 'OWNER' && user.role !== 'ADMIN') {
        const owners = await tx.user.count({
          where: {
            role: user.role,
            subRole: 'OWNER',
            status: 'ACTIVE',
            ...(user.companyId === null ? {} : { companyId: user.companyId }),
            ...(user.merchantId === null ? {} : { merchantId: user.merchantId }),
          },
        });
        if (owners <= 1) throw problems.conflict();
      }
      await tx.user.update({ where: { id }, data: { subRole } });
      await tx.session.updateMany({
        where: { userId: id, revokedAt: null },
        data: { revokedAt: new Date() },
      });
      await this.audit.recordFor(tx, 'users.role', id, `${user.displayName} → ${subRole}`, reason);
    });
    return this.detail(id, withBalance);
  }

  /** Role of the target account: an administrator target needs `users.adminRoles`. */
  async roleOf(id: string): Promise<Role> {
    const user = await this.db.user((tx) =>
      tx.user.findUnique({ where: { id }, select: { role: true } }),
    );
    if (user === null) throw problems.notFound();
    return user.role;
  }

  /**
   * New temporary password (72 h), sessions closed, the old one refused. By e-mail always; shown
   * once in the answer only to an administrator who manages accounts (processus v2, « Générer un
   * nouveau mot de passe »), never to the support.
   */
  async resendInvitation(id: string, withBalance: boolean) {
    const target = await this.db.user((tx) => tx.user.findUnique({ where: { id } }));
    if (target === null) throw problems.notFound();
    // Never one's own account, never an administrator: the support cannot close the sessions of
    // the back office in a loop (securite S2-02).
    if (target.id === principal().userId || target.role === 'ADMIN') throw problems.forbidden();
    if (target.status !== 'ACTIVE') throw problems.conflict();
    const [prepared] = await this.invitations.prepare([
      {
        role: target.role,
        subRole: target.subRole,
        displayName: target.displayName,
        email: target.email,
      },
    ]);
    if (prepared === undefined) throw problems.conflict();
    await this.db.system(async (tx) => {
      await tx.user.update({
        where: { id },
        data: {
          passwordHash: prepared.passwordHash,
          mustChangePassword: true,
          tempPasswordExpiresAt: await invitationExpiry(tx),
        },
      });
      await tx.session.updateMany({
        where: { userId: id, revokedAt: null },
        data: { revokedAt: new Date() },
      });
      await this.audit.recordFor(tx, 'users.resendInvitation', id, target.displayName, null);
    });
    await this.invitations.deliver([prepared]);
    const who = principal();
    const shown = permissionsOf(who.role, who.subRole).includes('users.manage');
    return {
      ...(await this.detail(id, withBalance)),
      ...(shown ? { credentials: credentialsOf(prepared) } : {}),
    };
  }

  /** Unlocks the payment PIN of an employee; the employee is told by e-mail. */
  async unlockPin(id: string, withBalance: boolean) {
    const target = await this.db.system(async (tx) => {
      const user = await tx.user.findUnique({ where: { id }, include: { employee: true } });
      if (user === null) throw problems.notFound();
      const employee = user.employee;
      if (employee === null) throw problems.conflict();
      const locked =
        employee.pinRequiresReauth ||
        (employee.pinLockedUntil !== null && employee.pinLockedUntil.getTime() > Date.now());
      if (!locked) throw problems.conflict();
      await tx.employee.update({
        where: { id: employee.id },
        data: { pinFailures: 0, pinLockedUntil: null, pinLockLevel: 0, pinRequiresReauth: false },
      });
      // A stolen phone gets no new tries: the employee signs in again (securite S2-03).
      await tx.session.updateMany({
        where: { userId: id, revokedAt: null },
        data: { revokedAt: new Date() },
      });
      await this.audit.recordFor(tx, 'users.unlockPin', id, user.displayName, null);
      return user;
    });
    await this.outbox.send({
      to: target.email,
      subject: 'Votre code PIN FlexiPay est débloqué',
      text: [
        `Bonjour ${target.displayName},`,
        '',
        'Le support FlexiPay a débloqué votre code PIN de paiement.',
        "Si vous n'êtes pas à l'origine de cette demande, contactez le support.",
      ].join('\n'),
    });
    return this.detail(id, withBalance);
  }

  /** Status change of an employee by its company (tenant checked: another company is a 404). */
  async changeEmployeeStatus(employeeId: string, action: LifecycleAction, reason: string) {
    const companyId = principal().companyId;
    if (companyId === null) throw problems.forbidden();
    const done = await this.db.system((tx) =>
      this.employeeChange(tx, companyId, employeeId, action, reason),
    );
    if (!done) throw problems.notFound();
  }

  /** Bulk suspend or reactivate of one page of employees (never a bulk deactivation). */
  async changeEmployeesStatus(
    employeeIds: readonly string[],
    action: 'SUSPEND' | 'REACTIVATE',
    reason: string,
  ) {
    const companyId = principal().companyId;
    if (companyId === null) throw problems.forbidden();
    const results: { employeeId: string; outcome: 'DONE' | 'SKIPPED' }[] = [];
    for (const employeeId of employeeIds) {
      const done = await this.db
        .system((tx) => this.employeeChange(tx, companyId, employeeId, action, reason))
        .catch((error: unknown) => {
          if (error instanceof ApiProblem && error.status === 409) return false;
          throw error;
        });
      results.push({ employeeId, outcome: done ? 'DONE' : 'SKIPPED' });
    }
    return { results };
  }

  /** False when the employee is not one of the company (the caller answers 404 or SKIPPED). */
  private async employeeChange(
    tx: Tx,
    companyId: string,
    employeeId: string,
    action: LifecycleAction,
    reason: string,
  ): Promise<boolean> {
    await tx.$queryRaw`SELECT id FROM employees WHERE id = ${employeeId}::uuid FOR UPDATE`;
    const employee = await tx.employee.findUnique({
      where: { id: employeeId },
      include: { user: true },
    });
    if (employee?.companyId !== companyId) return false;
    if (employee.user !== null) {
      const user = await this.lockUser(tx, employee.user.id);
      // A suspension decided by an administrator is lifted by an administrator only (to confirm
      // by Amine).
      if (action === 'REACTIVATE') await this.refuseAdminSuspension(tx, user.id);
      await this.apply(tx, user, action, reason);
      return true;
    }
    // Employee without sign-in account yet: only the employee row changes.
    const next = nextStatus(employee.status, action);
    if (next === null) throw problems.conflict();
    await this.applyEmployee(tx, employee.id, next);
    await this.audit.record(tx, `employees.${action.toLowerCase()}`, employee.employeeNumber);
    return true;
  }

  /**
   * Locks the target; a super-admin target locks every super-admin row, in id order, so that two
   * concurrent changes never remove the last active super-admin together (qualite, decision B).
   */
  private async refuseAdminSuspension(tx: Tx, userId: string): Promise<void> {
    const last = await tx.auditLog.findFirst({
      where: { subjectId: userId, action: 'users.suspend' },
      orderBy: { occurredAt: 'desc' },
    });
    if (last?.actorUserId === null || last === null) return;
    const actor = await tx.user.findUnique({
      where: { id: last.actorUserId },
      select: { role: true },
    });
    if (actor?.role === 'ADMIN') throw problems.forbidden();
  }

  private async lockUser(tx: Tx, id: string): Promise<UserRow> {
    const [target] = await tx.$queryRaw<{ sub_role: string | null }[]>`
      SELECT sub_role FROM users WHERE id = ${id}::uuid`;
    if (target?.sub_role === 'SUPER_ADMIN') {
      await tx.$queryRaw`
        SELECT id FROM users WHERE role = 'ADMIN' AND sub_role = 'SUPER_ADMIN' ORDER BY id FOR UPDATE`;
    } else {
      await tx.$queryRaw`SELECT id FROM users WHERE id = ${id}::uuid FOR UPDATE`;
    }
    const user = await tx.user.findUnique({ where: { id }, include: USER_INCLUDE });
    if (user === null) throw problems.notFound();
    return user;
  }

  /** Decision B: own account refused (403), last active super-admin kept (422). */
  private async refuseUnsafe(
    tx: Tx,
    user: UserRow,
    action: LifecycleAction | 'ROLE',
    newSubRole?: SubRole,
  ) {
    const activeSuperAdmins =
      user.subRole === 'SUPER_ADMIN'
        ? await tx.user.count({
            where: { role: 'ADMIN', subRole: 'SUPER_ADMIN', status: 'ACTIVE' },
          })
        : 0;
    const refusal = changeRefusal({
      actorId: principal().userId,
      target: { ...user, active: user.status === 'ACTIVE' },
      activeSuperAdmins,
      action,
      ...(newSubRole === undefined ? {} : { newSubRole }),
    });
    if (refusal === 'SELF') throw problems.forbidden();
    if (refusal === 'LAST_SUPER_ADMIN') throw new ApiProblem(422, 'LAST_SUPER_ADMIN');
  }

  /** Applies a status change to an account (and to its employee), closes sessions, audits. */
  private async apply(
    tx: Tx,
    user: UserRow,
    action: LifecycleAction,
    reason: string,
  ): Promise<void> {
    const shown = user.employee === null ? shownStatus(user) : user.employee.status;
    const next = nextStatus(shown, action);
    if (next === null) throw problems.conflict();
    const now = new Date();
    const userStatus = next === 'INVITED' ? 'ACTIVE' : next;
    await tx.user.update({
      where: { id: user.id },
      data: { status: userStatus, ...(next === 'DEACTIVATED' ? { deactivatedAt: now } : {}) },
    });
    if (user.employee !== null) await this.applyEmployee(tx, user.employee.id, next, now);
    // Suspended or deactivated: the sessions end now (an employee in its grace period signs in
    // again to spend its balance).
    if (next === 'SUSPENDED' || next === 'DEACTIVATED') {
      await tx.session.updateMany({
        where: { userId: user.id, revokedAt: null },
        data: { revokedAt: now },
      });
    }
    await this.audit.recordFor(
      tx,
      `users.${action.toLowerCase()}`,
      user.id,
      user.displayName,
      reason,
    );
  }

  private async applyEmployee(tx: Tx, employeeId: string, next: AccountStatus, now = new Date()) {
    if (next !== 'DEACTIVATED') {
      await tx.employee.update({ where: { id: employeeId }, data: { status: next } });
      return;
    }
    const settings = await tx.platformSettings.findUniqueOrThrow({ where: { id: 1 } });
    await tx.employee.update({
      where: { id: employeeId },
      data: { status: 'DEACTIVATED', graceUntil: graceEnd(now, settings.accountGraceDays) },
    });
  }
}
