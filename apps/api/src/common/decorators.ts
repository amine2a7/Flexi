import { SetMetadata } from '@nestjs/common';
import type { Role, SessionStep } from '../generated/prisma/enums.js';

export const PUBLIC = 'flexipay:public';
export const ROLES = 'flexipay:roles';
export const STEPS = 'flexipay:steps';
export const FINANCIAL = 'flexipay:financial';

/** Route open without a session (contract: `security: []`, `x-public: true`). Explicit only. */
export const Public = () => SetMetadata(PUBLIC, true);

/** Roles allowed on the route (403 FORBIDDEN otherwise). Every non-public route declares them. */
export const Roles = (...roles: Role[]) => SetMetadata(ROLES, roles);

/**
 * Session states allowed besides a complete session (contract §10): the sign-in sequence only
 * (password change, MFA enrolment, logout, refresh).
 */
export const AllowSteps = (...steps: SessionStep[]) => SetMetadata(STEPS, steps);
