import { Inject, Injectable } from '@nestjs/common';
import { credentialsOf, InvitationService, invitationExpiry } from '../auth/invitation.service.js';
import { AuditService } from '../common/audit.service.js';
import { DbService, type Tx } from '../common/db.service.js';
import { problems, validationFailed } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import type { SubRole } from '../generated/prisma/client.js';
import {
  assignableSubRoles,
  canManageTarget,
  type TeamActor,
  type TenantRole,
} from './team-rules.js';

/** The tenant whose users are managed: from the session (owner) or from the path (admin). */
export type TeamScope =
  | { readonly role: 'COMPANY'; readonly companyId: string }
  | { readonly role: 'MERCHANT'; readonly merchantId: string };

interface TeamUserRow {
  id: string;
  displayName: string;
  email: string;
  subRole: SubRole | null;
  status: 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED';
  mustChangePassword: boolean;
  createdAt: Date;
}

/** An account of the team; « Invité » while the temporary password is unchanged. */
export function teamUser(row: TeamUserRow) {
  return {
    id: row.id,
    displayName: row.displayName,
    email: row.email,
    subRole: row.subRole,
    status: row.status === 'ACTIVE' && row.mustChangePassword ? 'INVITED' : row.status,
    createdAt: row.createdAt.toISOString(),
  };
}

function tenantWhere(scope: TeamScope) {
  return scope.role === 'COMPANY'
    ? { role: scope.role, companyId: scope.companyId, employeeId: null }
    : { role: scope.role, merchantId: scope.merchantId, employeeId: null };
}

/** The scope of the session of an owner (a company or a merchant), never from the request. */
export function ownerScope(): TeamScope {
  const who = principal();
  if (who.role === 'COMPANY' && who.companyId !== null)
    return { role: 'COMPANY', companyId: who.companyId };
  if (who.role === 'MERCHANT' && who.merchantId !== null)
    return { role: 'MERCHANT', merchantId: who.merchantId };
  throw problems.forbidden();
}

/**
 * Users of a company or a merchant (request of 2026-11-14): the owner manages its RH and Finance
 * (or its cashiers) on its « Utilisateurs » page; the super-admin manages every account of the
 * tenant from its record. Each change is in the audit log with the account it is about; a role
 * change, a deactivation and a new password end the sessions of the account.
 */
@Injectable()
export class TeamService {
  constructor(
    @Inject(DbService) private readonly db: DbService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(InvitationService) private readonly invitations: InvitationService,
  ) {}

  async list(scope: TeamScope) {
    const rows = await this.db.system((tx) =>
      tx.user.findMany({ where: tenantWhere(scope), orderBy: { createdAt: 'asc' }, take: 200 }),
    );
    return { data: rows.map(teamUser) };
  }

  /**
   * New account with a temporary password shown once (and sent by e-mail). For an owner, an
   * address that already signs in gets the same answer, no account, and its holder is told
   * (securite S04); the administrator, who reads every account, gets a 409.
   */
  async create(
    scope: TeamScope,
    actor: TeamActor,
    input: { displayName: string; email: string; subRole: SubRole },
  ) {
    this.checkSubRole(scope.role, actor, input.subRole);
    const [prepared] = await this.invitations.prepare([
      {
        role: scope.role,
        subRole: input.subRole,
        displayName: input.displayName.trim(),
        email: input.email,
        ...(scope.role === 'COMPANY'
          ? { companyId: scope.companyId }
          : { merchantId: scope.merchantId }),
      },
    ]);
    if (prepared === undefined) throw problems.conflict();
    const email = prepared.invitee.email;
    const taken = await this.db.system(async (tx) => {
      await this.tenantExists(tx, scope);
      const inUse = (await this.invitations.emailsInUse(tx, [email])).has(email);
      if (inUse && actor === 'ADMIN') throw problems.conflict();
      if (!inUse) await this.invitations.create(tx, [prepared]);
      await this.audit.record(
        tx,
        'team.create',
        `${prepared.invitee.displayName} (${input.subRole})`,
      );
      return inUse;
    });
    if (taken) await this.invitations.notifyExisting([email]);
    else await this.invitations.deliver([prepared]);
    return { credentials: credentialsOf(prepared) };
  }

  /** Name and/or sub-role; the last active owner of the tenant is never demoted. */
  async update(
    scope: TeamScope,
    actor: TeamActor,
    userId: string,
    change: { displayName?: string; subRole?: SubRole },
    reason: string | null,
  ) {
    if (change.subRole !== undefined) this.checkSubRole(scope.role, actor, change.subRole);
    return this.db.system(async (tx) => {
      const user = await this.lockTarget(tx, scope, actor, userId);
      const displayName = change.displayName?.trim();
      const data: { displayName?: string; subRole?: SubRole } = {};
      if (displayName !== undefined && displayName !== user.displayName)
        data.displayName = displayName;
      if (change.subRole !== undefined && change.subRole !== user.subRole) {
        if (user.subRole === 'OWNER') await this.keepAnOwner(tx, scope, user.id);
        data.subRole = change.subRole;
      }
      if (Object.keys(data).length === 0) return teamUser(user);
      const updated = await tx.user.update({ where: { id: user.id }, data });
      if (data.subRole !== undefined) {
        await this.endSessions(tx, user.id);
        await this.audit.recordFor(
          tx,
          'team.role',
          user.id,
          `${updated.displayName} → ${data.subRole}`,
          reason,
        );
      }
      if (data.displayName !== undefined)
        await this.audit.recordFor(
          tx,
          'team.rename',
          user.id,
          `${user.displayName} → ${data.displayName}`,
          reason,
        );
      return teamUser(updated);
    });
  }

  /** Deactivation (final): the account no longer signs in; the last active owner is kept. */
  async deactivate(scope: TeamScope, actor: TeamActor, userId: string, reason: string | null) {
    return this.db.system(async (tx) => {
      const user = await this.lockTarget(tx, scope, actor, userId);
      if (user.status === 'DEACTIVATED') throw problems.conflict();
      if (user.subRole === 'OWNER') await this.keepAnOwner(tx, scope, user.id);
      const updated = await tx.user.update({
        where: { id: user.id },
        data: { status: 'DEACTIVATED', deactivatedAt: new Date() },
      });
      await this.endSessions(tx, user.id);
      await this.audit.recordFor(tx, 'team.deactivate', user.id, user.displayName, reason);
      return teamUser(updated);
    });
  }

  /** New temporary password, shown once and sent by e-mail; the old one and the sessions end. */
  async resetPassword(scope: TeamScope, actor: TeamActor, userId: string) {
    const target = await this.db.system((tx) => this.findTarget(tx, scope, actor, userId));
    if (target.status !== 'ACTIVE') throw problems.conflict();
    const [prepared] = await this.invitations.prepare([
      {
        role: scope.role,
        subRole: target.subRole,
        displayName: target.displayName,
        email: target.email,
      },
    ]);
    if (prepared === undefined) throw problems.conflict();
    const updated = await this.db.system(async (tx) => {
      await this.lockTarget(tx, scope, actor, userId);
      const row = await tx.user.update({
        where: { id: userId },
        data: {
          passwordHash: prepared.passwordHash,
          mustChangePassword: true,
          tempPasswordExpiresAt: await invitationExpiry(tx),
        },
      });
      await this.endSessions(tx, userId);
      await this.audit.recordFor(tx, 'team.resetPassword', userId, target.displayName, null);
      return row;
    });
    await this.invitations.deliver([prepared]);
    return { user: teamUser(updated), credentials: credentialsOf(prepared) };
  }

  /** The tenant of an account of a company or a merchant (the administrator's PATCH). */
  async scopeOf(userId: string): Promise<TeamScope> {
    const user = await this.db.system((tx) =>
      tx.user.findUnique({
        where: { id: userId },
        select: { role: true, companyId: true, merchantId: true, employeeId: true },
      }),
    );
    if (user?.employeeId !== null) throw problems.notFound();
    if (user.role === 'COMPANY' && user.companyId !== null)
      return { role: 'COMPANY', companyId: user.companyId };
    if (user.role === 'MERCHANT' && user.merchantId !== null)
      return { role: 'MERCHANT', merchantId: user.merchantId };
    throw problems.notFound();
  }

  private checkSubRole(tenant: TenantRole, actor: TeamActor, subRole: SubRole): void {
    if (!assignableSubRoles(tenant, actor).includes(subRole))
      throw validationFailed([{ in: 'body', pointer: '/subRole', code: 'INVALID_ENUM' }]);
  }

  private async tenantExists(tx: Tx, scope: TeamScope): Promise<void> {
    const found =
      scope.role === 'COMPANY'
        ? await tx.company.findUnique({ where: { id: scope.companyId }, select: { id: true } })
        : await tx.merchant.findUnique({ where: { id: scope.merchantId }, select: { id: true } });
    if (found === null) throw problems.notFound();
  }

  /** An account of the tenant (another tenant's is a 404) that the actor may change (403). */
  private async findTarget(tx: Tx, scope: TeamScope, actor: TeamActor, userId: string) {
    const user = await tx.user.findFirst({ where: { id: userId, ...tenantWhere(scope) } });
    if (user === null) throw problems.notFound();
    const allowed = canManageTarget({
      tenant: scope.role,
      actor,
      actorUserId: principal().userId,
      target: user,
    });
    if (!allowed) throw problems.forbidden();
    return user;
  }

  private async lockTarget(tx: Tx, scope: TeamScope, actor: TeamActor, userId: string) {
    await tx.$queryRaw`SELECT id FROM users WHERE id = ${userId}::uuid FOR UPDATE`;
    return this.findTarget(tx, scope, actor, userId);
  }

  /** Refuses to remove the last active owner of the tenant (409), owners locked in order. */
  private async keepAnOwner(tx: Tx, scope: TeamScope, leavingId: string): Promise<void> {
    const owners =
      scope.role === 'COMPANY'
        ? await tx.$queryRaw<{ id: string }[]>`
            SELECT id FROM users WHERE role = 'COMPANY' AND company_id = ${scope.companyId}::uuid
               AND sub_role = 'OWNER' AND status = 'ACTIVE' ORDER BY id FOR UPDATE`
        : await tx.$queryRaw<{ id: string }[]>`
            SELECT id FROM users WHERE role = 'MERCHANT' AND merchant_id = ${scope.merchantId}::uuid
               AND sub_role = 'OWNER' AND status = 'ACTIVE' ORDER BY id FOR UPDATE`;
    if (owners.filter((owner) => owner.id !== leavingId).length === 0) throw problems.conflict();
  }

  private async endSessions(tx: Tx, userId: string): Promise<void> {
    await tx.session.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }
}
