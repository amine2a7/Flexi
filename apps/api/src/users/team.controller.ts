import { Body, Controller, Get, HttpCode, Inject, Param, Patch, Post } from '@nestjs/common';
import { z } from 'zod';
import { Can, Roles } from '../common/decorators.js';
import { pathId } from '../common/responses.js';
import { email, parse } from '../common/validation.js';
import { accessReason } from './users.controller.js';
import { ownerScope, TeamService } from './team.service.js';

const teamSubRole = z.enum(['OWNER', 'MANAGER', 'FINANCE', 'CASHIER']);
const displayName = z.string().trim().min(1).max(120);
const createBody = z.strictObject({ displayName, email, subRole: teamSubRole });
const ownerUpdateBody = z
  .strictObject({ displayName: displayName.optional(), subRole: teamSubRole.optional() })
  .refine((body) => body.displayName !== undefined || body.subRole !== undefined);
const adminUpdateBody = z
  .strictObject({
    displayName: displayName.optional(),
    subRole: teamSubRole.optional(),
    reason: accessReason,
  })
  .refine((body) => body.displayName !== undefined || body.subRole !== undefined);

/**
 * « Utilisateurs » page of the owner of a company (its RH and Finance) or of a merchant (its
 * cashiers), request of 2026-11-14. The tenant comes from the session, never from the request.
 */
@Roles('COMPANY', 'MERCHANT')
@Controller('v1/team/users')
export class TeamController {
  constructor(@Inject(TeamService) private readonly team: TeamService) {}

  @Can('team.manage')
  @Get()
  list() {
    return this.team.list(ownerScope());
  }

  @Can('team.manage')
  @Post()
  @HttpCode(201)
  create(@Body() body: unknown) {
    return this.team.create(ownerScope(), 'OWNER', parse(createBody, body));
  }

  @Can('team.manage')
  @Patch(':userId')
  update(@Param('userId') userId: string, @Body() body: unknown) {
    return this.team.update(
      ownerScope(),
      'OWNER',
      pathId('userId', userId),
      parse(ownerUpdateBody, body),
      null,
    );
  }

  @Can('team.manage')
  @Post(':userId/deactivate')
  @HttpCode(200)
  deactivate(@Param('userId') userId: string) {
    return this.team.deactivate(ownerScope(), 'OWNER', pathId('userId', userId), null);
  }

  @Can('team.manage')
  @Post(':userId/reset-password')
  @HttpCode(200)
  resetPassword(@Param('userId') userId: string) {
    return this.team.resetPassword(ownerScope(), 'OWNER', pathId('userId', userId));
  }
}

/**
 * « Utilisateurs » tab of a company or merchant record (request of 2026-11-14): the super-admin
 * creates and edits the accounts (name, role); deactivation and a new password use the routes of
 * /v1/admin/users. Opérations, Finance and Support read the tab (overview) only.
 */
@Roles('ADMIN')
@Controller('v1/admin')
export class AdminTeamController {
  constructor(@Inject(TeamService) private readonly team: TeamService) {}

  @Can('users.manage')
  @Post('companies/:companyId/users')
  @HttpCode(201)
  createCompanyUser(@Param('companyId') companyId: string, @Body() body: unknown) {
    return this.team.create(
      { role: 'COMPANY', companyId: pathId('companyId', companyId) },
      'ADMIN',
      parse(createBody, body),
    );
  }

  @Can('users.manage')
  @Post('merchants/:merchantId/users')
  @HttpCode(201)
  createMerchantUser(@Param('merchantId') merchantId: string, @Body() body: unknown) {
    return this.team.create(
      { role: 'MERCHANT', merchantId: pathId('merchantId', merchantId) },
      'ADMIN',
      parse(createBody, body),
    );
  }

  /** Name and/or role of an account of a company or a merchant (never an administrator). */
  @Can('users.manage')
  @Patch('users/:userId')
  async updateUser(@Param('userId') userId: string, @Body() body: unknown) {
    const id = pathId('userId', userId);
    const { reason, ...change } = parse(adminUpdateBody, body);
    return this.team.update(await this.team.scopeOf(id), 'ADMIN', id, change, reason);
  }
}
