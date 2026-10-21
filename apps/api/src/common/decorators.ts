import { SetMetadata } from '@nestjs/common';
import type { Role, SessionStep } from '../generated/prisma/enums.js';
import { SELF, type Permission } from './permissions.js';

export const PUBLIC = 'flexipay:public';
export const ROLES = 'flexipay:roles';
export const STEPS = 'flexipay:steps';
export const FINANCIAL = 'flexipay:financial';
export const PERMISSIONS = 'flexipay:permissions';

/** Route open without a session (contract: `security: []`, `x-public: true`). Explicit only. */
export const Public = () => SetMetadata(PUBLIC, true);

/**
 * Permission(s) needed by the route, any of them (securite B5-S02). Every non-public route
 * declares one: a route without it is refused (deny by default, and a unit test fails).
 */
export const Can = (...permissions: Permission[]) => SetMetadata(PERMISSIONS, permissions);

/** Route of the signed-in user itself (own session, profile, tour), whatever the role. */
export const Self = () => SetMetadata(PERMISSIONS, [SELF]);

/** Roles allowed on the route (403 FORBIDDEN otherwise). Every non-public route declares them. */
export const Roles = (...roles: Role[]) => SetMetadata(ROLES, roles);

/**
 * Session states allowed besides a complete session (contract §10): the sign-in sequence only
 * (password change, MFA enrolment, logout, refresh).
 */
export const AllowSteps = (...steps: SessionStep[]) => SetMetadata(STEPS, steps);
