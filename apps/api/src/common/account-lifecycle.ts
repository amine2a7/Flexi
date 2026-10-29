import type { Role, SubRole } from '../generated/prisma/enums.js';

// Lifecycle of an account (decisions A, B of 2026-10-23, e3 of 2026-10-22): pure rules, shared by
// the administrator and company routes, sign-in, payments and allocations.

/** Status shown to the web: INVITED is an active account whose temporary password is unchanged. */
export type AccountStatus = 'INVITED' | 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED';
export type LifecycleAction = 'SUSPEND' | 'REACTIVATE' | 'DEACTIVATE';

const DAY_MS = 86_400_000;

/** Status after the action, or null when the transition is impossible (409). */
export function nextStatus(current: AccountStatus, action: LifecycleAction): AccountStatus | null {
  if (current === 'DEACTIVATED') return null; // irreversible
  if (action === 'DEACTIVATE') return 'DEACTIVATED';
  if (action === 'SUSPEND') return current === 'SUSPENDED' ? null : 'SUSPENDED';
  return current === 'SUSPENDED' ? 'ACTIVE' : null;
}

/** End of the grace period, frozen at the deactivation (like the commission snapshot). */
export function graceEnd(now: Date, days: number): Date {
  return new Date(now.getTime() + days * DAY_MS);
}

interface EmployeeState {
  readonly status: 'INVITED' | 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED';
  readonly graceUntil: Date | null;
}

/** Pays with its balance: not suspended; deactivated only until the end of its grace period. */
export function canSpend(employee: EmployeeState, now: Date): boolean {
  if (employee.status === 'SUSPENDED') return false;
  if (employee.status === 'DEACTIVATED') {
    return employee.graceUntil !== null && employee.graceUntil.getTime() > now.getTime();
  }
  return true;
}

/** Receives credits: never when suspended or deactivated. */
export function canReceiveCredits(employee: EmployeeState): boolean {
  return employee.status === 'ACTIVE' || employee.status === 'INVITED';
}

/** Signs in (and keeps its sessions): active, or an employee spending during its grace period. */
export function canSignIn(
  user: { readonly status: 'ACTIVE' | 'SUSPENDED' | 'DEACTIVATED'; readonly role: Role },
  employee: EmployeeState | null,
  now: Date,
): boolean {
  if (user.status === 'ACTIVE') return true;
  return (
    user.status === 'DEACTIVATED' &&
    user.role === 'EMPLOYEE' &&
    employee !== null &&
    canSpend(employee, now)
  );
}

/**
 * Why a status or role change is refused (decision B), or null: nobody changes its own account;
 * the last active super-admin is never suspended, deactivated nor demoted.
 */
export function changeRefusal(input: {
  readonly actorId: string;
  readonly target: { readonly id: string; readonly role: Role; readonly subRole: SubRole | null };
  readonly activeSuperAdmins: number;
  readonly action: LifecycleAction | 'ROLE';
  readonly newSubRole?: SubRole;
}): 'SELF' | 'LAST_SUPER_ADMIN' | null {
  const { actorId, target, activeSuperAdmins, action, newSubRole } = input;
  if (actorId === target.id) return 'SELF';
  const removesSuperAdmin =
    action === 'SUSPEND' ||
    action === 'DEACTIVATE' ||
    (action === 'ROLE' && newSubRole !== 'SUPER_ADMIN');
  if (target.subRole === 'SUPER_ADMIN' && removesSuperAdmin && activeSuperAdmins <= 1) {
    return 'LAST_SUPER_ADMIN';
  }
  return null;
}
