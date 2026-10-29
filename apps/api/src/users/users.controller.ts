import { Body, Controller, Get, HttpCode, Inject, Param, Post, Query } from '@nestjs/common';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { permissionsOf } from '../common/permissions.js';
import { problems } from '../common/problem.js';
import { principal } from '../common/request-context.js';
import { pathId } from '../common/responses.js';
import { email, parse } from '../common/validation.js';
import { UsersService } from './users.service.js';

/** Reason of an access change: bounds 10 to 500 (commun-statut-utilisateur §12.4, to confirm). */
export const accessReason = z.string().trim().min(10).max(500);
const reasonBody = z.strictObject({ reason: accessReason });
const usersQuery = z.object({
  role: z.enum(['ADMIN', 'COMPANY', 'MERCHANT', 'EMPLOYEE', 'FAMILY_MEMBER']).optional(),
  status: z.enum(['INVITED', 'ACTIVE', 'SUSPENDED', 'DEACTIVATED']).optional(),
  q: z.string().trim().min(1).max(100).optional(),
});
const createBody = z.strictObject({
  displayName: z.string().trim().min(1).max(120),
  email,
  subRole: z.enum(['SUPER_ADMIN', 'COMPLIANCE', 'FINANCE', 'SUPPORT']),
  reason: accessReason,
});
const roleBody = z.strictObject({
  subRole: z.enum([
    'SUPER_ADMIN',
    'COMPLIANCE',
    'FINANCE',
    'SUPPORT',
    'OWNER',
    'MANAGER',
    'ACCOUNTANT',
    'READ_ONLY',
    'CASHIER',
  ]),
  reason: accessReason,
});

/** The balance of an employee is shown only with `userBalances.read` (decision D4). */
function withBalance(): boolean {
  const who = principal();
  return permissionsOf(who.role, who.subRole).includes('userBalances.read');
}

/** Users of the platform for the administrators (decisions A to D of 2026-10-23). */
@Roles('ADMIN')
@Controller('v1/admin/users')
export class AdminUsersController {
  constructor(@Inject(UsersService) private readonly users: UsersService) {}

  @Can('users.read')
  @Get()
  list(@Query() query: Record<string, unknown>) {
    return this.users.list(
      query,
      parse(usersQuery, { role: query.role, status: query.status, q: query.q }, 'query'),
    );
  }

  @Can('users.adminRoles')
  @Post()
  @HttpCode(202)
  async create(@Body() body: unknown): Promise<void> {
    await this.users.createAdministrator(parse(createBody, body));
  }

  @Can('users.read')
  @Get(':userId')
  detail(@Param('userId') userId: string) {
    return this.users.detail(pathId('userId', userId), withBalance());
  }

  @Can('users.manage')
  @Post(':userId/suspend')
  @HttpCode(200)
  suspend(@Param('userId') userId: string, @Body() body: unknown) {
    const { reason } = parse(reasonBody, body);
    return this.users.changeStatus(pathId('userId', userId), 'SUSPEND', reason, withBalance());
  }

  @Can('users.manage')
  @Post(':userId/reactivate')
  @HttpCode(200)
  reactivate(@Param('userId') userId: string, @Body() body: unknown) {
    const { reason } = parse(reasonBody, body);
    return this.users.changeStatus(pathId('userId', userId), 'REACTIVATE', reason, withBalance());
  }

  @Can('users.manage')
  @Post(':userId/deactivate')
  @HttpCode(200)
  deactivate(@Param('userId') userId: string, @Body() body: unknown) {
    const { reason } = parse(reasonBody, body);
    return this.users.changeStatus(pathId('userId', userId), 'DEACTIVATE', reason, withBalance());
  }

  /** Administrator target: `users.adminRoles`; company or merchant user: `users.manage` (D3). */
  @Can('users.manage', 'users.adminRoles')
  @Post(':userId/role')
  @HttpCode(200)
  async role(@Param('userId') userId: string, @Body() body: unknown) {
    const id = pathId('userId', userId);
    const input = parse(roleBody, body);
    const who = principal();
    const held = permissionsOf(who.role, who.subRole);
    const needed = (await this.users.roleOf(id)) === 'ADMIN' ? 'users.adminRoles' : 'users.manage';
    if (!held.includes(needed)) throw problems.forbidden();
    return this.users.changeRole(id, input.subRole, input.reason, withBalance());
  }

  @Can('users.support')
  @Post(':userId/reset-invitation')
  @HttpCode(200)
  resendInvitation(@Param('userId') userId: string) {
    return this.users.resendInvitation(pathId('userId', userId), withBalance());
  }

  @Can('users.support')
  @Post(':userId/unlock-pin')
  @HttpCode(200)
  unlockPin(@Param('userId') userId: string) {
    return this.users.unlockPin(pathId('userId', userId), withBalance());
  }
}
