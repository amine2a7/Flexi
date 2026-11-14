import type { Role, SubRole } from '../generated/prisma/enums.js';

/**
 * Users of a company or a merchant (request of 2026-11-14). Pure rules, unit tested.
 * - Company: Propriétaire (OWNER), RH (MANAGER), Finance (FINANCE).
 * - Merchant: Propriétaire (OWNER), Caissier (CASHIER).
 * The owner is created by the FlexiPay administrator; the owner manages its RH and Finance (or its
 * cashiers), never an owner nor itself. The administrator manages every account of the tenant.
 */
export type TenantRole = Extract<Role, 'COMPANY' | 'MERCHANT'>;
export type TeamActor = 'OWNER' | 'ADMIN';

export const TEAM_SUB_ROLES: Readonly<Record<TenantRole, readonly SubRole[]>> = {
  COMPANY: ['OWNER', 'MANAGER', 'FINANCE'],
  MERCHANT: ['OWNER', 'CASHIER'],
};

/** Sub-roles the actor may give in the tenant (an owner never creates another owner). */
export function assignableSubRoles(tenant: TenantRole, actor: TeamActor): readonly SubRole[] {
  const all = TEAM_SUB_ROLES[tenant];
  return actor === 'ADMIN' ? all : all.filter((subRole) => subRole !== 'OWNER');
}

/**
 * True when the actor may change the target account (edit, role, deactivation, new password):
 * the administrator any account of the tenant; the owner only the accounts it manages (not an
 * owner, not itself, not a former sub-role it cannot give).
 */
export function canManageTarget(input: {
  readonly tenant: TenantRole;
  readonly actor: TeamActor;
  readonly actorUserId: string;
  readonly target: { readonly id: string; readonly subRole: SubRole | null };
}): boolean {
  const { tenant, actor, actorUserId, target } = input;
  if (actor === 'ADMIN') return true;
  if (target.id === actorUserId || target.subRole === null) return false;
  return assignableSubRoles(tenant, 'OWNER').includes(target.subRole);
}
